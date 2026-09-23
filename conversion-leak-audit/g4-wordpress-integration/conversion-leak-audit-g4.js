(function () {
  'use strict';

  var app = document.querySelector('[data-cla-g4-app]');
  if (!app) return;

  var form = app.querySelector('[data-cla-scan-form]');
  var input = app.querySelector('#cla-g4-store-url');
  var submit = app.querySelector('[data-cla-submit]');
  var fieldMessage = app.querySelector('[data-cla-field-message]');
  var progress = app.querySelector('[data-cla-progress]');
  var progressTitle = app.querySelector('[data-cla-progress-title]');
  var progressCopy = app.querySelector('[data-cla-progress-copy]');
  var reference = app.querySelector('[data-cla-scan-reference]');
  var feedback = app.querySelector('[data-cla-feedback]');
  var results = app.querySelector('[data-cla-results]');
  var apiRoot = app.getAttribute('data-api-root').replace(/\/$/, '');
  var nonce = app.getAttribute('data-api-nonce');
  var localFullPreview = app.getAttribute('data-local-full-preview') === 'true';
  var scanId = null;
  var scanUrl = null;
  var siteIdHash = null;
  var scanStartedAt = null;
  var busy = false;
  var fullReportRequested = false;

  var phaseCopy = {
    CHECKING_ACCESS: ['Checking access', 'Checking whether public pages can be read safely.'],
    READING_PAGES: ['Reading pages', 'Checking public pages and purchase-related information.'],
    MATCHING_EVIDENCE: ['Analyzing with trusted rules', 'Matching observed facts to trusted rules.'],
    PRIORITIZING: ['Finalizing results', 'Organizing the issues worth checking first.']
  };
  var findingMeta = {
    'CORE-007': {
      title: 'Product price not visible near purchase action',
      observed: 'No visible product price was found near the purchase action.',
      observedDetail: 'A direct-purchase product page exposes a purchase action, but no visible product price is present near the purchase decision.',
      why: 'Shoppers may need clear price information before they can evaluate the purchase.',
      firstMove: 'Make the current purchase price visible near the primary purchase action.'
    },
    'PHYS-002': {
      title: 'Shipping information is hard to find',
      observed: 'Shipping cost or delivery timing was not found near the purchase decision.',
      observedDetail: 'Shipping cost or delivery timing was not found in the expected purchase-adjacent pages checked.',
      why: 'Missing or distant shipping information can leave an important purchase question unresolved.',
      firstMove: 'Surface shipping cost and timing closer to the product or cart decision point.'
    },
    'PHYS-001': {
      title: 'Return information is hard to find',
      observed: 'No clear return or refund policy link was found in the checked purchase path.',
      observedDetail: 'No clear return or refund policy link was found in the checked public navigation and purchase context.',
      why: 'Return terms are a common purchase-risk question and should be easy to discover before checkout.',
      firstMove: 'Make return and refund terms directly discoverable from the relevant purchase journey.'
    }
  };
  var preferredOrder = ['CORE-007', 'PHYS-002', 'PHYS-001'];

  function escapeHtml(value) {
    return String(value == null ? '' : value).replace(/[&<>"']/g, function (character) {
      return {'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;'}[character];
    });
  }

  function emit(name, properties) {
    var event = {name: name, properties: properties || {}, at: new Date().toISOString()};
    window.claAnalyticsEvents = window.claAnalyticsEvents || [];
    window.claAnalyticsEvents.push(event);
    app.dispatchEvent(new CustomEvent('cla:' + name, {detail: event}));
  }

  async function siteIdHashFor(url) {
    var hostname = new URL(url).hostname.toLowerCase();
    var bytes = new TextEncoder().encode(hostname);
    var digest = await window.crypto.subtle.digest('SHA-256', bytes);
    return Array.from(new Uint8Array(digest)).map(function (value) {
      return value.toString(16).padStart(2, '0');
    }).join('');
  }

  function scanDurationBucket() {
    var elapsed = scanStartedAt === null ? 0 : Math.max(0, performance.now() - scanStartedAt);
    if (elapsed < 10000) return 'under_10s';
    if (elapsed < 30000) return '10_30s';
    if (elapsed < 60000) return '30_60s';
    return '60s_plus';
  }

  function referrerType() {
    if (!document.referrer) return 'none';
    try {
      return new URL(document.referrer).hostname === window.location.hostname ? 'internal' : 'external';
    } catch (error) {
      return 'external';
    }
  }

  function campaignSource() {
    var source = new URLSearchParams(window.location.search).get('utm_source');
    return source ? source.slice(0, 64) : 'none';
  }

  function publicEventProperties(extra) {
    var properties = {source_page: window.location.pathname, device_class: window.matchMedia('(max-width: 720px)').matches ? 'mobile' : 'desktop'};
    Object.keys(extra || {}).forEach(function (key) { properties[key] = extra[key]; });
    return properties;
  }

  function showFieldMessage(message) {
    fieldMessage.textContent = message || '';
    fieldMessage.hidden = !message;
  }

  function setBusy(value) {
    busy = value;
    submit.disabled = value;
    submit.textContent = value ? 'Starting scan…' : 'Scan my store';
    input.setAttribute('aria-busy', value ? 'true' : 'false');
  }

  function isPrivateHostname(hostname) {
    var host = hostname.toLowerCase().replace(/^\[|\]$/g, '');
    if (host === 'localhost' || host === '::1' || host.endsWith('.local') || host.endsWith('.internal')) return true;
    if (/^127\./.test(host) || /^10\./.test(host) || /^169\.254\./.test(host) || /^192\.168\./.test(host)) return true;
    var match = host.match(/^172\.(\d+)\./);
    return !!match && Number(match[1]) >= 16 && Number(match[1]) <= 31;
  }

  function validateUrl(value) {
    var parsed;
    try { parsed = new URL(value); } catch (error) { return {code: 'INVALID_URL', message: 'Enter a complete public website URL.'}; }
    if (!['http:', 'https:'].includes(parsed.protocol) || !parsed.hostname || parsed.username || parsed.password) {
      return {code: 'UNSUPPORTED_SCHEME', message: 'Use a public http or https website URL.'};
    }
    if (isPrivateHostname(parsed.hostname)) {
      return {code: 'UNSAFE_TARGET', message: 'For safety, this scan supports public websites only.'};
    }
    return null;
  }

  async function request(path, options) {
    var response = await fetch(apiRoot + path, Object.assign({headers: {'X-WP-Nonce': nonce, 'Accept': 'application/json'}}, options || {}));
    var data = {};
    try { data = await response.json(); } catch (error) { data = {}; }
    if (!response.ok) {
      var failure = new Error(data.message || 'The scan service is temporarily unavailable.');
      failure.code = data.code || (data.data && data.data.status) || 'SCANNER_UNAVAILABLE';
      failure.status = response.status;
      throw failure;
    }
    return data;
  }

  function setProgress(job) {
    var phase = job.phase || (job.status === 'QUEUED' ? 'CHECKING_ACCESS' : 'READING_PAGES');
    var copy = phaseCopy[phase] || phaseCopy.READING_PAGES;
    recordProgressPhase(phase);
    progress.hidden = false;
    progressTitle.textContent = copy[0];
    progressCopy.textContent = copy[1];
    app.querySelectorAll('[data-phase]').forEach(function (item) {
      var active = item.getAttribute('data-phase') === phase;
      item.classList.toggle('is-active', active);
      item.setAttribute('aria-current', active ? 'step' : 'false');
    });
    if (scanId) {
      reference.hidden = false;
      reference.textContent = 'Scan reference: ' + scanId;
    }
  }

  function showFeedback(message, kind) {
    feedback.hidden = !message;
    feedback.className = 'cla-g4-feedback' + (kind ? ' is-' + kind : '');
    feedback.textContent = message || '';
  }

  function sourceFor(report, refs) {
    var pages = report && Array.isArray(report.pages) ? report.pages : [];
    var pageIndexes = [];
    (refs || []).join(' ').replace(/page:(\d+)/g, function (_, index) {
      var pageIndex = Number(index);
      if (!pageIndexes.includes(pageIndex)) pageIndexes.push(pageIndex);
      return _;
    });
    if (!pageIndexes.length) pageIndexes = [0];
    var sources = pageIndexes.map(function (pageIndex) {
      var page = pages[pageIndex] || pages[0];
      return page ? (page.final_url || page.requested_url || 'Audited public page') : null;
    }).filter(Boolean);
    return sources.length ? sources.join(', ') : 'Structured Scanner evidence';
  }

  function mapFindings(report) {
    var decisions = report && Array.isArray(report.decisions) ? report.decisions : [];
    var findings = decisions.filter(function (decision) {
      return decision.result === 'ISSUE' && Array.isArray(decision.fact_refs) && decision.fact_refs.length > 0;
    });
    findings.sort(function (left, right) {
      var leftRank = preferredOrder.indexOf(left.rule_id);
      var rightRank = preferredOrder.indexOf(right.rule_id);
      leftRank = leftRank < 0 ? preferredOrder.length : leftRank;
      rightRank = rightRank < 0 ? preferredOrder.length : rightRank;
      return leftRank - rightRank || String(left.rule_id).localeCompare(String(right.rule_id));
    });
    return findings.slice(0, 3).map(function (decision, index) {
      var meta = findingMeta[decision.rule_id] || {
        title: 'Observable friction worth checking',
        observed: decision.message || 'The trusted rule returned an evidence-backed issue.',
        observedDetail: decision.message || 'The trusted rule returned an evidence-backed issue.',
        why: 'This observable signal may represent a point of purchase uncertainty worth checking.',
        firstMove: 'Review the cited public evidence and verify the relevant purchase path.'
      };
      return {rank: index + 1, decision: decision, meta: meta};
    });
  }

  function renderResults(report) {
    results.classList.remove('cla-g5-full-results');
    var findings = mapFindings(report);
    var count = findings.length;
    var cards = findings.map(function (finding) {
      var decision = finding.decision;
      var meta = finding.meta;
      var source = sourceFor(report, decision.fact_refs);
      var refs = decision.fact_refs.join(', ');
      return '<article class="cla-g4-finding" data-rule-id="' + escapeHtml(decision.rule_id) + '">' +
        '<div class="cla-g4-finding-top"><span class="cla-g4-priority">P' + finding.rank + '</span><span class="cla-g4-rule">' + escapeHtml(decision.rule_id) + '</span></div>' +
        '<h3>' + escapeHtml(meta.title) + '</h3>' +
        '<p><strong>Observed fact</strong>' + escapeHtml(meta.observed) + '</p>' +
        '<p><strong>First move</strong>' + escapeHtml(meta.firstMove) + '</p>' +
        '<details data-evidence-detail><summary>View details &amp; evidence</summary><div class="cla-g4-detail-body"><p><strong>Why it may matter</strong>' + escapeHtml(meta.why) + '</p><div class="cla-g4-evidence" data-evidence-content><p><strong>Source</strong>' + escapeHtml(source) + '</p><p><strong>Evidence references</strong>' + escapeHtml(refs) + '</p><p><strong>Scanner decision</strong>' + escapeHtml(decision.message) + '</p><p><strong>Limitation</strong>Public-page evidence is a useful starting point, not proof of revenue loss or causal lift.</p></div></div></details>' +
        '</article>';
    }).join('');
    var summary = count ? 'We found ' + count + ' trusted finding' + (count === 1 ? '' : 's') + ' worth checking first.' : 'No high-priority issue was confirmed in the auditable range.';
    var demoSummary = '';
    if (report && report.demo_fixture === 'demo-store-golden-v1' && report.summary) {
      demoSummary = '<div class="cla-g4-demo-summary" data-cla-demo-summary><strong>' + escapeHtml(report.summary.confirmed_findings + ' confirmed findings') + '</strong><span>' + escapeHtml(report.summary.trusted_checks + ' trusted checks') + '</span><span>' + escapeHtml(report.summary.label) + '</span></div>';
    }
    var fullPreview = localFullPreview
      ? '<div class="cla-g4-full-preview cla-g5-local-preview"><p class="cla-g4-kicker">LOCAL PREVIEW</p><h3>Complete fix queue</h3><p>Preview every evidence-backed issue for this scan. Paid access is not active and no checkout is available.</p><button type="button" data-cla-open-full-report>Open full queue</button></div>'
      : '<div class="cla-g4-full-preview"><p class="cla-g4-kicker">NEXT LAYER</p><h3>Review the evidence you can verify.</h3><p>Full expansion can add complete evidence context and a prioritized action plan. Full report access and payment are not available in this preview.</p><button type="button" data-cla-paid-preview>See what a full queue would include</button><div data-cla-paid-copy hidden>Complete fix queue, evidence context, and prioritized next actions are future expansion areas. No payment action was started.</div></div>';
    results.innerHTML = demoSummary + '<div class="cla-g4-results-head"><div><p class="cla-g4-kicker">FREE TOP 3</p><h2>' + escapeHtml(summary) + '</h2><p class="cla-g4-muted">Only evidence-backed ISSUE decisions are shown. The list is never padded.</p></div><span class="cla-g4-result-count">' + count + ' finding' + (count === 1 ? '' : 's') + '</span></div>' +
      '<div class="cla-g4-findings">' + cards + '</div>' +
      fullPreview +
      '<p class="cla-g4-scan-reference">Scan reference: ' + escapeHtml(scanId || '') + '</p>';
    results.hidden = false;
    progress.hidden = true;
    showFeedback('', '');
    emit('scan_completed', publicEventProperties({site_id_hash: siteIdHash, pages_checked: Array.isArray(report && report.pages) ? report.pages.length : 0, finding_count: count, top3_available: count > 0, scan_duration_bucket: scanDurationBucket()}));
    emit('top3_viewed', publicEventProperties({site_id_hash: siteIdHash, top3_count: count, scan_duration_bucket: scanDurationBucket()}));
    results.querySelectorAll('[data-evidence-detail]').forEach(function (detail) {
      detail.addEventListener('toggle', function () {
        if (detail.open) {
          var rule = detail.closest('[data-rule-id]');
          emit('issue_expanded', publicEventProperties({site_id_hash: siteIdHash, rule_id: rule ? rule.getAttribute('data-rule-id') : 'unknown', priority_rank: rule ? rule.querySelector('.cla-g4-priority').textContent : '', finding_type: 'ISSUE'}));
        }
      });
    });
    var fullButton = results.querySelector('[data-cla-open-full-report]');
    if (fullButton) fullButton.addEventListener('click', function () { openFullReportPreview(); });
    var paidButton = results.querySelector('[data-cla-paid-preview]');
    var paidCopy = results.querySelector('[data-cla-paid-copy]');
    if (paidButton) paidButton.addEventListener('click', function () { paidCopy.hidden = false; paidButton.hidden = true; emit('paid_expansion_viewed', publicEventProperties({surface: 'free_result'})); });
  }

  function renderFullReportUnavailable() {
    progress.hidden = true;
    results.hidden = false;
    results.innerHTML = '<div class="cla-g4-incomplete is-error"><p class="cla-g4-kicker">LOCAL PREVIEW UNAVAILABLE</p><h2>This scan could not be opened.</h2><p class="cla-g4-muted">Return to a completed scan and open its local full-queue preview. No report data was loaded.</p></div>';
  }

  function renderExplanation(panel, explanation, source) {
    panel.replaceChildren();
    panel.hidden = false;
    var heading = document.createElement('strong');
    heading.textContent = source === 'llm' ? 'Structured explanation' : (source === 'deterministic_fake' ? 'Deterministic fake-provider explanation' : 'Deterministic fallback');
    panel.appendChild(heading);
    [
      ['Summary', explanation.summary],
      ['Why it may matter', explanation.why_it_may_matter],
      ['Recommended next step', explanation.recommended_next_step],
      ['Caveat', explanation.caveat]
    ].forEach(function (item) {
      var paragraph = document.createElement('p');
      var label = document.createElement('strong');
      label.textContent = item[0];
      paragraph.appendChild(label);
      paragraph.appendChild(document.createTextNode(String(item[1] || '')));
      panel.appendChild(paragraph);
    });
  }

  function requestIssueExplanation(ruleId, position, button) {
    var row = button.closest('[data-g5-queue-item]');
    var panel = row && row.querySelector('[data-g5-explanation]');
    if (!row || !panel || !siteIdHash || !scanId) return;
    button.disabled = true;
    button.textContent = 'Preparing explanation…';
    emit('llm_explanation_requested', publicEventProperties({site_id_hash: siteIdHash, rule_id: ruleId, schema_version: 'cla.issue-explanation.v1', queue_position: position}));
    request('/full-reports/' + encodeURIComponent(scanId) + '/issues/' + encodeURIComponent(ruleId) + '/explanation', {
      method: 'POST',
      headers: {'Content-Type': 'application/json', 'X-WP-Nonce': nonce},
      body: '{}'
    }).then(function (response) {
      var source = response.status === 'explained'
        ? (response.provider === 'deterministic_fake' ? 'deterministic_fake' : 'llm')
        : 'deterministic_fallback';
      if (response.status !== 'explained') {
        emit('llm_explanation_failed', publicEventProperties({site_id_hash: siteIdHash, rule_id: ruleId, reason: response.reason || 'provider_unavailable'}));
      }
      renderExplanation(panel, response.explanation, source);
      emit('llm_explanation_viewed', publicEventProperties({site_id_hash: siteIdHash, rule_id: ruleId, source: source}));
    }).catch(function () {
      var observed = row.getAttribute('data-observed-fact') || 'The evidence-backed Scanner issue is available above.';
      var firstMove = row.getAttribute('data-first-move') || 'Review the cited public evidence and verify the relevant purchase path.';
      emit('llm_explanation_failed', publicEventProperties({site_id_hash: siteIdHash, rule_id: ruleId, reason: 'provider_unavailable'}));
      renderExplanation(panel, {
        summary: 'The Scanner observed: ' + observed,
        why_it_may_matter: 'This observation may leave a question about the documented part of the public purchase journey unresolved.',
        recommended_next_step: firstMove,
        caveat: 'This public-page observation is not proof of revenue loss or causal conversion impact.'
      }, 'deterministic_fallback');
      emit('llm_explanation_viewed', publicEventProperties({site_id_hash: siteIdHash, rule_id: ruleId, source: 'deterministic_fallback'}));
    }).finally(function () {
      button.disabled = false;
      button.textContent = 'Explain this finding';
    });
  }

  function renderFullQueue(envelope) {
    if (!envelope || String(envelope.scan_id || '').toLowerCase() !== String(scanId || '').toLowerCase() || !envelope.report || !['SUCCEEDED', 'AUDIT_INCOMPLETE'].includes(envelope.status)) {
      renderFullReportUnavailable();
      return;
    }
    if (envelope.status === 'AUDIT_INCOMPLETE') {
      renderIncomplete({status: envelope.status, error_code: envelope.error_code}, envelope.report);
      return;
    }
    var report = envelope.report;
    results.classList.add('cla-g5-full-results');
    var findings = Array.isArray(envelope.fix_queue) ? envelope.fix_queue : [];
    var cards = findings.map(function (item) {
      var ruleId = String(item.rule_id);
      var meta = findingMeta[ruleId] || {};
      var title = item.title || 'Evidence-backed Scanner issue';
      var observed = item.observed_fact || 'The trusted rule returned an evidence-backed issue.';
      var firstMove = item.first_move || 'Review the cited public evidence and verify the relevant purchase path.';
      var refs = Array.isArray(item.evidence_refs) ? item.evidence_refs : [];
      var source = sourceFor(report, refs);
      var position = Number(item.position);
      var why = meta.why || 'This observation may leave a question about the documented part of the public purchase journey unresolved.';
      return '<article class="cla-g4-finding cla-g5-queue-item" data-g5-queue-item data-rule-id="' + escapeHtml(ruleId) + '" data-queue-position="' + position + '" data-observed-fact="' + escapeHtml(observed) + '" data-first-move="' + escapeHtml(firstMove) + '">' +
        '<div class="cla-g4-finding-top"><span class="cla-g5-queue-position">Queue position ' + position + '</span><span class="cla-g4-rule">' + escapeHtml(ruleId) + '</span></div>' +
        '<h3>' + escapeHtml(title) + '</h3>' +
        '<p><strong>Observed fact</strong>' + escapeHtml(observed) + '</p>' +
        '<p><strong>First move</strong>' + escapeHtml(firstMove) + '</p>' +
        '<details data-g5-issue-detail><summary>View evidence and limitation</summary><div class="cla-g4-detail-body"><p><strong>Why it may matter</strong>' + escapeHtml(why) + '</p><div class="cla-g4-evidence"><p><strong>Source</strong>' + escapeHtml(source) + '</p><p><strong>Evidence references</strong>' + escapeHtml(refs.join(', ')) + '</p><p><strong>Scanner decision</strong>' + escapeHtml(item.scanner_decision || '') + '</p><p><strong>Limitation</strong>' + escapeHtml(item.limitation || '') + '</p></div></div></details>' +
        '<button class="cla-g5-explain-button" type="button" data-g5-explain>Explain this finding</button><div class="cla-g5-explanation" data-g5-explanation hidden aria-live="polite"></div>' +
        '</article>';
    }).join('');
    var empty = findings.length ? '' : '<p class="cla-g5-empty">No evidence-backed issues were confirmed in this completed scan. The queue is empty; no items were added.</p>';
    results.innerHTML = '<div class="cla-g5-preview-notice"><p class="cla-g4-kicker">LOCAL FULL-REPORT PREVIEW</p><p>Paid access is not active in this Gate. This preview is tied to the scan reference below; no checkout or entitlement exists.</p></div>' +
      '<div class="cla-g4-results-head"><div><p class="cla-g4-kicker">COMPLETE FIX QUEUE</p><h2>' + findings.length + ' evidence-backed issue' + (findings.length === 1 ? '' : 's') + '</h2><p class="cla-g4-muted">Queue position follows the existing Top 3 order, then the Scanner report order. It is not an impact score.</p></div><span class="cla-g4-result-count">' + findings.length + ' issue' + (findings.length === 1 ? '' : 's') + '</span></div>' +
      '<div class="cla-g4-findings cla-g5-queue" data-g5-queue>' + cards + '</div>' + empty +
      '<p class="cla-g4-scan-reference" data-cla-scan-reference>Scan reference: ' + escapeHtml(scanId) + '</p>';
    results.hidden = false;
    progress.hidden = true;
    showFeedback('', '');
    emit('full_report_viewed', publicEventProperties({site_id_hash: siteIdHash, report_mode: 'local_preview', access_state: 'not_entitled', queue_count: findings.length}));
    results.querySelectorAll('[data-g5-issue-detail]').forEach(function (detail) {
      detail.addEventListener('toggle', function () {
        if (detail.open) {
          var row = detail.closest('[data-g5-queue-item]');
          emit('full_issue_expanded', publicEventProperties({site_id_hash: siteIdHash, rule_id: row.getAttribute('data-rule-id'), queue_position: Number(row.getAttribute('data-queue-position'))}));
        }
      });
    });
    results.querySelectorAll('[data-g5-explain]').forEach(function (button) {
      button.addEventListener('click', function () {
        var row = button.closest('[data-g5-queue-item]');
        requestIssueExplanation(row.getAttribute('data-rule-id'), Number(row.getAttribute('data-queue-position')), button);
      });
    });
  }

  async function loadFullReport(id) {
    if (!localFullPreview || !/^[0-9a-f]{32}$/i.test(id || '')) {
      renderFullReportUnavailable();
      return;
    }
    try {
      var envelope = await request('/full-reports/' + encodeURIComponent(id));
      if (!siteIdHash && envelope.report && envelope.report.requested_url) siteIdHash = await siteIdHashFor(envelope.report.requested_url);
      renderFullQueue(envelope);
    } catch (error) {
      renderFullReportUnavailable();
    }
  }

  function openFullReportPreview() {
    if (!localFullPreview || !/^[0-9a-f]{32}$/i.test(scanId || '')) {
      renderFullReportUnavailable();
      return;
    }
    fullReportRequested = true;
    history.pushState(null, '', window.location.pathname + '?scan_id=' + encodeURIComponent(scanId) + '&cla_g5_full_report=1');
    loadFullReport(scanId);
  }

  function reasonLabel(code) {
    code = String(code || '').toUpperCase();
    var labels = {RATE_LIMITED: 'The site limited automated access.', BLOCKED: 'The site blocked automated access.', ACCESS_BLOCKED: 'The site blocked automated access.', LOGIN_REQUIRED: 'The audited path requires login.', JS_INCOMPLETE: 'The public page could not be read completely.', GEO_CONTEXT_MISMATCH: 'The result needs a region context that is not available locally.', SITE_UNAVAILABLE: 'The site was not available to the Scanner.', UNSAFE_TARGET: 'Only public websites can be scanned.', SCAN_TIMEOUT: 'The bounded scan timed out before it could finish.', SCANNER_UNAVAILABLE: 'The local Scanner is unavailable right now.'};
    return labels[code] || 'The scan could not be completed with enough evidence.';
  }

  function recordProgressPhase(phase) {
    window.claProgressPhases = window.claProgressPhases || [];
    if (window.claProgressPhases[window.claProgressPhases.length - 1] !== phase) window.claProgressPhases.push(phase);
  }

  function incompleteReason(code) {
    code = String(code || '').toUpperCase();
    if (code === 'RATE_LIMITED' || code === 'ACCESS_RATE_LIMITED') return 'RATE_LIMITED';
    if (code === 'BLOCKED' || code === 'ACCESS_BLOCKED' || code === 'ROBOTS_DENIED') return 'BLOCKED';
    if (code === 'LOGIN_REQUIRED' || code === 'ACCESS_LOGIN_REQUIRED') return 'LOGIN_REQUIRED';
    if (code === 'JS_INCOMPLETE' || code === 'ACCESS_JS_INCOMPLETE') return 'JS_INCOMPLETE';
    if (code === 'GEO_CONTEXT_MISMATCH') return 'GEO_CONTEXT_MISMATCH';
    if (code === 'SITE_UNAVAILABLE' || code === 'SCANNER_UNAVAILABLE' || code === 'CRAWLER_NO_OUTPUT') return 'SITE_UNAVAILABLE';
    return 'UNKNOWN_FAILURE';
  }

  function renderIncomplete(job, report) {
    results.classList.remove('cla-g5-full-results');
    progress.hidden = true;
    results.hidden = false;
    results.innerHTML = '<div class="cla-g4-incomplete"><p class="cla-g4-kicker">SCAN INCOMPLETE</p><h2>No Top 3 was generated.</h2><p>' + escapeHtml(reasonLabel(job.error_code || (report && report.warnings && report.warnings[0]))) + '</p><p class="cla-g4-muted">We will not convert incomplete evidence into an ISSUE. You can retry a temporary access problem.</p><button type="button" data-cla-retry>Try again</button><p class="cla-g4-scan-reference">Scan reference: ' + escapeHtml(scanId || '') + '</p></div>';
    emit('scan_incomplete', publicEventProperties({reason: incompleteReason(job.error_code || (report && report.warnings && report.warnings[0]))}));
    var retry = results.querySelector('[data-cla-retry]');
    if (retry) retry.addEventListener('click', function () { form.requestSubmit(); });
  }

  function renderFailure(error) {
    progress.hidden = true;
    results.hidden = false;
    results.innerHTML = '<div class="cla-g4-incomplete is-error"><p class="cla-g4-kicker">SCAN NOT STARTED</p><h2>' + escapeHtml(reasonLabel(error.code)) + '</h2><p class="cla-g4-muted">Your URL was kept so you can correct it or retry without losing your input.</p><button type="button" data-cla-retry>Retry</button></div>';
    var retry = results.querySelector('[data-cla-retry]');
    if (retry) retry.addEventListener('click', function () { results.hidden = true; form.requestSubmit(); });
  }

  function delay(milliseconds) { return new Promise(function (resolve) { window.setTimeout(resolve, milliseconds); }); }

  async function poll(id) {
    for (var attempt = 0; attempt < 120; attempt += 1) {
      var job = await request('/scans/' + encodeURIComponent(id));
      if (!siteIdHash && job.requested_url) siteIdHash = await siteIdHashFor(job.requested_url);
      if (job.status === 'QUEUED' || job.status === 'RUNNING') {
        setProgress(job);
        await delay(500);
        continue;
      }
      if (job.status === 'SUCCEEDED' || job.status === 'AUDIT_INCOMPLETE') {
        if (fullReportRequested) {
          await loadFullReport(id);
          setBusy(false);
          return;
        }
        var report = null;
        try { report = await request('/scans/' + encodeURIComponent(id) + '/report'); } catch (error) { renderFailure(error); return; }
        if (!siteIdHash && report && report.requested_url) siteIdHash = await siteIdHashFor(report.requested_url);
        recordProgressPhase(job.status === 'SUCCEEDED' ? 'COMPLETE' : 'INCOMPLETE');
        if (job.status === 'SUCCEEDED') renderResults(report); else renderIncomplete(job, report);
        setBusy(false);
        return;
      }
      recordProgressPhase(job.status === 'FAILED' ? 'FAILED' : 'CANCELLED');
      renderFailure({code: job.error_code || 'UNKNOWN_FAILURE'});
      setBusy(false);
      return;
    }
    renderFailure({code: 'SCAN_TIMEOUT'});
    setBusy(false);
  }

  async function startScan(url) {
    scanUrl = url;
    fullReportRequested = false;
    scanStartedAt = performance.now();
    siteIdHash = await siteIdHashFor(url);
    setBusy(true);
    results.hidden = true;
    showFeedback('', '');
    progress.hidden = false;
    try {
      var job = await request('/scans', {method: 'POST', headers: {'Content-Type': 'application/json', 'X-WP-Nonce': nonce}, body: JSON.stringify({url: url})});
      scanId = job.id;
      history.replaceState(null, '', window.location.pathname + '?scan_id=' + encodeURIComponent(scanId));
      emit('scan_started', publicEventProperties({site_id_hash: siteIdHash, normalized_host_class: 'public_host', scan_id: scanId}));
      setProgress(job);
      await poll(scanId);
    } catch (error) {
      if (error.code === 'UNSAFE_TARGET' || error.code === 'INVALID_URL' || error.code === 'UNSUPPORTED_SCHEME') emit('scan_rejected', publicEventProperties({reason: error.code}));
      showFieldMessage(error.message || 'The scan could not be started.');
      renderFailure(error);
      setBusy(false);
    }
  }

  form.addEventListener('submit', function (event) {
    event.preventDefault();
    if (busy) return;
    showFieldMessage('');
    var value = input.value.trim();
    var validation = validateUrl(value);
    if (validation) {
      showFieldMessage(validation.message);
      emit('scan_rejected', publicEventProperties({reason: validation.code}));
      return;
    }
    startScan(value);
  });

  var initialParams = new URLSearchParams(window.location.search);
  var restored = initialParams.get('scan_id');
  fullReportRequested = initialParams.get('cla_g5_full_report') === '1';
  if (fullReportRequested && (!localFullPreview || !restored || !/^[0-9a-f]{32}$/i.test(restored))) {
    renderFullReportUnavailable();
  } else if (restored && /^[0-9a-f]{32}$/i.test(restored)) {
    scanId = restored.toLowerCase();
    setBusy(true);
    setProgress({id: scanId, status: 'QUEUED', phase: 'CHECKING_ACCESS'});
    poll(scanId).catch(function (error) { renderFailure(error); setBusy(false); });
  }
  emit('landing_view', publicEventProperties({referrer_type: referrerType(), campaign_source: campaignSource(), locale: document.documentElement.lang || 'unknown'}));
}());
