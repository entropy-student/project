<?php
/**
 * G5 local full-report preview and structured issue explanation adapter.
 */

if (!defined('ABSPATH')) { exit; }

interface CLA_G5_Explanation_Provider {
    public function identifier(): string;
    public function explain(array $input);
}

final class CLA_G5_Fake_Explanation_Provider implements CLA_G5_Explanation_Provider {
    public function identifier(): string {
        return 'deterministic_fake';
    }

    public function explain(array $input) {
        return [
            'summary' => 'The Scanner observed: ' . $input['observed_fact'],
            'why_it_may_matter' => 'This observation may leave a question about the documented part of the public purchase journey unresolved.',
            'recommended_next_step' => $input['first_move'],
            'caveat' => $input['limitation'],
        ];
    }
}

final class CLA_G5_Json_Explanation_Provider implements CLA_G5_Explanation_Provider {
    private string $endpoint;
    private string $api_key;
    private string $model;

    public function __construct(string $endpoint, string $api_key, string $model) {
        $this->endpoint = $endpoint;
        $this->api_key = $api_key;
        $this->model = $model;
    }

    public function identifier(): string {
        return 'cla_json_explainer_v1';
    }

    public function explain(array $input) {
        $schema = [
            'type' => 'object',
            'additionalProperties' => false,
            'required' => ['summary', 'why_it_may_matter', 'recommended_next_step', 'caveat'],
            'properties' => [
                'summary' => ['type' => 'string'],
                'why_it_may_matter' => ['type' => 'string'],
                'recommended_next_step' => ['type' => 'string'],
                'caveat' => ['type' => 'string'],
            ],
        ];
        $system = 'Explain only the supplied existing structured Scanner issue. Do not diagnose pages or create findings. Do not invent facts, evidence, metrics, merchants, or sources. Do not infer causal conversion impact, revenue loss, or why sales are low. Preserve uncertainty and the supplied limitation. Return only the required JSON object.';
        $body = wp_json_encode([
            'schema_version' => 'cla.issue-explanation.v1',
            'model' => $this->model,
            'system' => $system,
            'input' => $input,
            'output_schema' => $schema,
            'max_output_tokens' => 300,
        ]);
        if (!is_string($body) || strlen($body) > 4096) {
            return new WP_Error('G5_PAYLOAD_TOO_LARGE', 'Explanation input exceeded the local size bound.');
        }

        $response = wp_remote_post($this->endpoint, [
            'timeout' => 8,
            'redirection' => 0,
            'reject_unsafe_urls' => true,
            'headers' => [
                'Accept' => 'application/json',
                'Content-Type' => 'application/json',
                'Authorization' => 'Bearer ' . $this->api_key,
            ],
            'body' => $body,
        ]);
        if (is_wp_error($response)) {
            $message = strtolower($response->get_error_message());
            $code = preg_match('/timed?\s*out|timeout/', $message) ? 'G5_PROVIDER_TIMEOUT' : 'G5_PROVIDER_UNAVAILABLE';
            return new WP_Error($code, 'The explanation provider did not return a usable response.');
        }
        $status = (int) wp_remote_retrieve_response_code($response);
        $raw = wp_remote_retrieve_body($response);
        if ($status < 200 || $status >= 300 || !is_string($raw) || strlen($raw) > 2400) {
            return new WP_Error('G5_PROVIDER_UNAVAILABLE', 'The explanation provider did not return a usable response.');
        }
        $decoded = json_decode($raw, true);
        if (!is_array($decoded)) {
            return new WP_Error('G5_MALFORMED_OUTPUT', 'The explanation provider returned malformed output.');
        }
        return isset($decoded['output']) && is_array($decoded['output']) ? $decoded['output'] : $decoded;
    }
}

function cla_g5_env(string $name): string {
    $value = getenv($name);
    return $value === false ? '' : trim((string) $value);
}

function cla_g5_local_preview_enabled(): bool {
    if (!in_array(strtolower(cla_g5_env('CLA_G5_LOCAL_PREVIEW')), ['1', 'true', 'yes'], true)) {
        return false;
    }
    if (!function_exists('wp_get_environment_type') || wp_get_environment_type() !== 'local') {
        return false;
    }
    $host = strtolower((string) wp_parse_url(home_url('/'), PHP_URL_HOST));
    return in_array(trim($host, '[]'), ['localhost', '127.0.0.1', '::1'], true);
}

function cla_g5_fetch_report_envelope(string $scan_id) {
    $scan_id = strtolower($scan_id);
    if (!preg_match('/^[0-9a-f]{32}$/', $scan_id)) {
        return new WP_Error('G5_SCAN_NOT_FOUND', 'The scan reference is not valid.', ['status' => 404]);
    }
    $job_response = cla_g4_scanner_request('GET', '/v1/scans/' . rawurlencode($scan_id));
    if (is_wp_error($job_response)) { return $job_response; }
    $job = $job_response->get_data();
    if (!is_array($job) || strtolower((string) ($job['id'] ?? '')) !== $scan_id) {
        return new WP_Error('G5_SCAN_BINDING_MISMATCH', 'The scan reference could not be verified.', ['status' => 502]);
    }
    $status = (string) ($job['status'] ?? '');
    if (!in_array($status, ['SUCCEEDED', 'AUDIT_INCOMPLETE'], true)) {
        return new WP_Error('G5_REPORT_NOT_READY', 'The scan has not reached a report state.', ['status' => 409]);
    }
    $report_response = cla_g4_scanner_request('GET', '/v1/scans/' . rawurlencode($scan_id) . '/report');
    if (is_wp_error($report_response)) { return $report_response; }
    $report = $report_response->get_data();
    if (!is_array($report) || (isset($report['scan_id']) && strtolower((string) $report['scan_id']) !== $scan_id)) {
        return new WP_Error('G5_REPORT_BINDING_MISMATCH', 'The report did not match this scan reference.', ['status' => 502]);
    }
    return [
        'scan_id' => $scan_id,
        'status' => $status,
        'error_code' => sanitize_key((string) ($job['error_code'] ?? '')),
        'report' => $report,
    ];
}

function cla_g5_queue_copy(): array {
    return [
        'CORE-001' => ['Key commercial page unavailable', 'Review the affected public page and restore its expected availability.'],
        'CORE-002' => ['Purchase action was not usable in the checked state', 'Verify the purchase action when the item is available and required options are selected.'],
        'CORE-003' => ['Mobile view interrupted a core task', 'Review the mobile state that obscured or blocked the core task.'],
        'CORE-004' => ['Key form control lacks a clear label', 'Add a visible, programmatically associated label to the key form control.'],
        'CORE-006' => ['Core navigation link is broken', 'Repair the core navigation target and verify that it opens.'],
        'CORE-007' => ['Product price not visible near purchase action', 'Make the current purchase price visible near the primary purchase action.'],
        'CORE-009' => ['Commercial page is excluded from indexing', 'Confirm that the page should be indexable, then review its noindex setting.'],
        'CORE-010' => ['Page price and structured price do not match', 'Align structured price and currency with the values shown on the page.'],
        'PHYS-001' => ['Return information is hard to find', 'Make return and refund terms directly discoverable from the relevant purchase journey.'],
        'PHYS-002' => ['Shipping information is hard to find', 'Surface shipping cost and timing closer to the product or cart decision point.'],
        'SUB-001' => ['Ongoing subscription price is hard to find', 'Show introductory and subsequent standard charges before purchase.'],
        'SUB-002' => ['Subscription billing cadence is unclear', 'State the recurring billing interval near the recurring price.'],
        'SUB-003' => ['Automatic renewal terms are hard to find', 'Make automatic-renewal terms easy to find before purchase.'],
        'SUB-004' => ['Post-trial charge details are incomplete', 'Show trial length, post-trial amount, and automatic-conversion terms before signup.'],
        'SUB-005' => ['Cancellation terms are hard to find', 'Make the cancellation method and any material deadline easy to find before purchase.'],
    ];
}

function cla_g5_safe_evidence_refs(array $decision): array {
    $refs = [];
    $fact_refs = is_array($decision['fact_refs'] ?? null) ? $decision['fact_refs'] : [];
    foreach (array_slice($fact_refs, 0, 12) as $ref) {
        $ref = (string) $ref;
        if (preg_match('/^(?:page:\\d+(?:\\.[A-Za-z0-9_.-]+)?|selector:[A-Za-z0-9_.:-]+)$/', $ref)) { $refs[] = $ref; }
    }
    return array_values(array_unique($refs));
}

function cla_g5_fix_queue(array $report): array {
    $copy = cla_g5_queue_copy();
    $decisions = is_array($report['decisions'] ?? null) ? $report['decisions'] : [];
    $seen = [];
    $preferred = ['CORE-007', 'PHYS-002', 'PHYS-001'];
    $items = [];
    foreach ($decisions as $index => $decision) {
        if (!is_array($decision) || ($decision['result'] ?? '') !== 'ISSUE') { continue; }
        $rule_id = strtoupper((string) ($decision['rule_id'] ?? ''));
        if (!preg_match('/^[A-Z]+-\\d{3}$/', $rule_id) || isset($seen[$rule_id])) { continue; }
        $refs = cla_g5_safe_evidence_refs($decision);
        if (!$refs) { continue; }
        $observed = substr(sanitize_text_field((string) ($decision['message'] ?? '')), 0, 600);
        if ($observed === '') { continue; }
        $seen[$rule_id] = true;
        $items[] = [
            'report_index' => (int) $index,
            'rule_id' => $rule_id,
            'title' => $copy[$rule_id][0] ?? 'Evidence-backed Scanner issue',
            'observed_fact' => $observed,
            'evidence_refs' => $refs,
            'scanner_decision' => $observed,
            'first_move' => $copy[$rule_id][1] ?? 'Review the cited public evidence and verify the relevant purchase path.',
            'limitation' => 'This public-page observation is not proof of revenue loss or causal conversion impact.',
        ];
    }
    usort($items, static function (array $left, array $right) use ($preferred): int {
        $left_rank = array_search($left['rule_id'], $preferred, true);
        $right_rank = array_search($right['rule_id'], $preferred, true);
        $left_rank = $left_rank === false ? count($preferred) : $left_rank;
        $right_rank = $right_rank === false ? count($preferred) : $right_rank;
        return ($left_rank <=> $right_rank) ?: ($left['report_index'] <=> $right['report_index']);
    });
    foreach ($items as $index => &$item) {
        $item['position'] = $index + 1;
        unset($item['report_index']);
    }
    unset($item);
    return $items;
}

function cla_g5_full_report(WP_REST_Request $request) {
    if (!cla_g5_local_preview_enabled()) {
        return new WP_Error('G5_LOCAL_PREVIEW_DISABLED', 'The local report preview is not enabled.', ['status' => 404]);
    }
    $envelope = cla_g5_fetch_report_envelope((string) $request['id']);
    if (is_wp_error($envelope)) { return $envelope; }
    $envelope['fix_queue'] = $envelope['status'] === 'SUCCEEDED' ? cla_g5_fix_queue($envelope['report']) : [];
    return new WP_REST_Response($envelope, 200);
}

function cla_g5_issue_explanation_input(array $envelope, string $rule_id) {
    if (($envelope['status'] ?? '') !== 'SUCCEEDED') {
        return new WP_Error('G5_REPORT_INCOMPLETE', 'An incomplete scan cannot produce issue explanations.', ['status' => 409]);
    }
    $item = null;
    foreach (cla_g5_fix_queue($envelope['report']) as $candidate) {
        if ($candidate['rule_id'] === $rule_id) { $item = $candidate; break; }
    }
    if (!is_array($item)) {
        return new WP_Error('G5_ISSUE_NOT_ELIGIBLE', 'Only an evidence-backed Scanner issue can be explained.', ['status' => 404]);
    }
    $page_count = count($envelope['report']['pages'] ?? []);
    return [
        'schema_version' => 'cla.issue-explanation.v1',
        'rule_id' => $rule_id,
        'title' => substr($item['title'], 0, 200),
        'observed_fact' => $item['observed_fact'],
        'evidence_refs' => $item['evidence_refs'],
        'first_move' => $item['first_move'],
        'limitation' => $item['limitation'],
        'context_summary' => 'The Scanner checked ' . max(0, min(6, $page_count)) . ' public page(s); no analytics or visitor behavior data is included.',
    ];
}

function cla_g5_output_guard(array $output, array $input): bool {
    $required = ['summary', 'why_it_may_matter', 'recommended_next_step', 'caveat'];
    $keys = array_keys($output);
    sort($keys);
    $expected = $required;
    sort($expected);
    if ($keys !== $expected) { return false; }
    foreach ($required as $key) {
        if (!is_string($output[$key]) || trim($output[$key]) === '' || strlen($output[$key]) > 900) { return false; }
    }
    if ($output['caveat'] !== $input['limitation']) { return false; }
    $text = implode("\n", array_map('trim', [
        $output['summary'],
        $output['why_it_may_matter'],
        $output['recommended_next_step'],
    ]));
    if (preg_match('/https?:\/\/|\bwww\.|<\/?[a-z][^>]*>/i', $text)) { return false; }
    if (preg_match('/\b(?:revenue|sales|conversion|orders?|profit)\b.{0,60}\b(?:loss|lost|increase|improve|boost|lift|uplift|recover|grow|cause|caused|guarantee|prove)\b|\b(?:increase|improve|boost|lift|uplift|recover|grow|cause|caused|guarantee|prove)\b.{0,60}\b(?:revenue|sales|conversion|orders?|profit)\b/i', $text)) { return false; }
    if (preg_match('/\b(?:google analytics|\bGA4\b|survey|interview|A\/?B test|experiment|heatmap|session recording|customer feedback)\b/i', $text)) { return false; }

    preg_match_all('/\b(?:CORE|PHYS|SUB|GATE)-\d{3}\b/', $text, $rule_ids);
    foreach ($rule_ids[0] as $found_rule) {
        if ($found_rule !== $input['rule_id']) { return false; }
    }
    $allowed_refs = array_flip($input['evidence_refs']);
    preg_match_all('/\b(?:page|selector):[A-Za-z0-9._:-]+/', $text, $found_refs);
    foreach ($found_refs[0] as $found_ref) {
        if (!isset($allowed_refs[$found_ref])) { return false; }
    }
    preg_match_all('/\b\d+(?:[.,]\d+)?%?\b/', $text, $numbers);
    $grounding = wp_json_encode($input);
    foreach ($numbers[0] as $number) {
        if (strpos((string) $grounding, $number) === false) { return false; }
    }
    return true;
}

function cla_g5_deterministic_explanation(array $input): array {
    return [
        'summary' => 'The Scanner observed: ' . $input['observed_fact'],
        'why_it_may_matter' => 'This observation may leave a question about the documented part of the public purchase journey unresolved.',
        'recommended_next_step' => $input['first_move'],
        'caveat' => $input['limitation'],
    ];
}

function cla_g5_provider() {
    if (!in_array(strtolower(cla_g5_env('CLA_G5_LLM_ENABLED')), ['1', 'true', 'yes'], true)) {
        return new WP_Error('G5_PROVIDER_UNAVAILABLE', 'No explanation provider is enabled.');
    }
    $provider = strtolower(cla_g5_env('CLA_G5_LLM_PROVIDER'));
    if ($provider === 'fake' && cla_g5_local_preview_enabled()) {
        return new CLA_G5_Fake_Explanation_Provider();
    }
    if ($provider !== 'json_http') {
        return new WP_Error('G5_PROVIDER_UNAVAILABLE', 'No explanation provider is available.');
    }
    $endpoint = cla_g5_env('CLA_G5_LLM_ENDPOINT');
    $api_key = cla_g5_env('CLA_G5_LLM_API_KEY');
    $model = cla_g5_env('CLA_G5_LLM_MODEL');
    $parts = $endpoint ? wp_parse_url($endpoint) : false;
    $scheme = is_array($parts) ? strtolower((string) ($parts['scheme'] ?? '')) : '';
    $host = is_array($parts) ? strtolower((string) ($parts['host'] ?? '')) : '';
    $local_http = $scheme === 'http' && in_array(trim($host, '[]'), ['localhost', '127.0.0.1', '::1'], true);
    if (!$endpoint || !$api_key || !$model || !is_array($parts) || ($scheme !== 'https' && !$local_http)) {
        return new WP_Error('G5_PROVIDER_UNAVAILABLE', 'The configured explanation provider is incomplete or unsafe.');
    }
    return new CLA_G5_Json_Explanation_Provider($endpoint, $api_key, $model);
}

function cla_g5_explanation_response(string $scan_id, array $input): array {
    $input_json = wp_json_encode($input);
    if (!is_string($input_json) || strlen($input_json) > 2048) {
        return ['status' => 'fallback', 'reason' => 'payload_too_large', 'explanation' => cla_g5_deterministic_explanation($input)];
    }
    $input_hash = hash('sha256', $input_json);
    $provider = cla_g5_provider();
    $provider_config = implode('|', [cla_g5_env('CLA_G5_LLM_ENABLED'), cla_g5_env('CLA_G5_LLM_PROVIDER'), cla_g5_env('CLA_G5_LLM_ENDPOINT'), cla_g5_env('CLA_G5_LLM_MODEL')]);
    $cache_key = 'cla_g5_' . substr(hash('sha256', $scan_id . '|' . $input['rule_id'] . '|' . $input_hash . '|' . $provider_config), 0, 40);
    $cached = get_transient($cache_key);
    if (is_array($cached) && ($cached['scan_id'] ?? '') === $scan_id && ($cached['rule_id'] ?? '') === $input['rule_id'] && ($cached['input_hash'] ?? '') === $input_hash) {
        return ['status' => $cached['status'], 'reason' => $cached['reason'] ?? '', 'provider' => $cached['provider'], 'explanation' => $cached['explanation'], 'cached' => true];
    }

    $reason = '';
    $explanation = null;
    if (is_wp_error($provider)) {
        $reason = 'provider_unavailable';
    } else {
        $candidate = $provider->explain($input);
        if (is_wp_error($candidate)) {
            $code = $candidate->get_error_code();
            $reason = $code === 'G5_PROVIDER_TIMEOUT' ? 'timeout' : ($code === 'G5_MALFORMED_OUTPUT' ? 'malformed_output' : 'provider_unavailable');
        } elseif (!is_array($candidate)) {
            $reason = 'malformed_output';
        } elseif (!cla_g5_output_guard($candidate, $input)) {
            $reason = 'guard_rejected';
        } else {
            $explanation = $candidate;
            // The claim boundary is deterministic and never delegated to the provider.
            $explanation['caveat'] = $input['limitation'];
        }
    }
    if ($explanation === null) {
        $explanation = cla_g5_deterministic_explanation($input);
    }

    $model = cla_g5_env('CLA_G5_LLM_PROVIDER') === 'json_http' ? substr(cla_g5_env('CLA_G5_LLM_MODEL'), 0, 100) : '';
    $record = [
        'scan_id' => $scan_id,
        'rule_id' => $input['rule_id'],
        'schema_version' => $input['schema_version'],
        'input_hash' => $input_hash,
        'provider' => is_wp_error($provider) ? 'deterministic_fallback' : $provider->identifier(),
        'model' => $model,
        'created_at' => gmdate('c'),
        'status' => $reason === '' ? 'explained' : 'fallback',
        'reason' => $reason,
        'explanation' => $explanation,
    ];
    set_transient($cache_key, $record, HOUR_IN_SECONDS);
    return ['status' => $record['status'], 'reason' => $reason, 'provider' => $record['provider'], 'explanation' => $explanation, 'cached' => false];
}

function cla_g5_explain_issue(WP_REST_Request $request) {
    if (!cla_g5_local_preview_enabled()) {
        return new WP_Error('G5_LOCAL_PREVIEW_DISABLED', 'The local report preview is not enabled.', ['status' => 404]);
    }
    $scan_id = strtolower((string) $request['id']);
    $rule_id = strtoupper((string) $request['rule_id']);
    if (!preg_match('/^[A-Z]+-\d{3}$/', $rule_id)) {
        return new WP_Error('G5_ISSUE_NOT_FOUND', 'The structured issue was not found.', ['status' => 404]);
    }
    $envelope = cla_g5_fetch_report_envelope($scan_id);
    if (is_wp_error($envelope)) { return $envelope; }
    $input = cla_g5_issue_explanation_input($envelope, $rule_id);
    if (is_wp_error($input)) { return $input; }
    return new WP_REST_Response(cla_g5_explanation_response($scan_id, $input), 200);
}

function cla_g5_register_routes(): void {
    register_rest_route('cla/v1', '/full-reports/(?P<id>[0-9a-f]{32})', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'cla_g5_full_report',
        'permission_callback' => 'cla_g4_rest_permission',
    ]);
    register_rest_route('cla/v1', '/full-reports/(?P<id>[0-9a-f]{32})/issues/(?P<rule_id>[A-Z]+-[0-9]{3})/explanation', [
        'methods' => WP_REST_Server::CREATABLE,
        'callback' => 'cla_g5_explain_issue',
        'permission_callback' => 'cla_g4_rest_permission',
    ]);
}
add_action('rest_api_init', 'cla_g5_register_routes');
