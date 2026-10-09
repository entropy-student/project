(() => {
  let running = false;
  let lastGeneratedImage = null;

  chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
    handle(message)
      .then((result) => sendResponse({ ok: true, ...result }))
      .catch((error) => sendResponse({ ok: false, error: serializeError(error) }));
    return true;
  });

  async function handle(message) {
    if (message?.type === "CHECK_READY") {
      const composer = findComposer();
      if (!composer && looksLoggedOut()) throw typed("NOT_LOGGED_IN", "ChatGPT does not appear to be signed in", false);
      return { ready: Boolean(composer) };
    }
    if (message?.type === "RUN_JOB") {
      if (running) throw typed("BUSY", "A job is already running in this tab", false);
      running = true;
      try {
        return await runJob(message);
      } finally {
        running = false;
      }
    }
    if (message?.type === "CLICK_DOWNLOAD") {
      if (!lastGeneratedImage || !document.contains(lastGeneratedImage)) throw typed("DOWNLOAD_FAILED", "The generated image is no longer available", true);
      await chrome.runtime.sendMessage({ type: "EXPECT_DOWNLOAD", jobKey: message.jobKey, filename: message.filename });
      const button = await findOrRevealDownloadButton(lastGeneratedImage);
      if (!button) throw typed("DOWNLOAD_FAILED", "Could not find a ChatGPT download control for the generated image", true);
      button.click();
      return {};
    }
    throw typed("UNKNOWN_MESSAGE", `Unknown message ${message?.type}`, false);
  }

  async function runJob(message) {
    const composer = findComposer();
    if (!composer) {
      if (looksLoggedOut()) throw typed("NOT_LOGGED_IN", "ChatGPT does not appear to be signed in", false);
      throw typed("UI_SELECTOR_MISSING", "Could not find the ChatGPT composer", false);
    }

    const baseline = new Set(getCandidateImages().map(imageFingerprint));
    setComposerText(composer, String(message.prompt));
    await sleep(250);
    const send = findSendButton();
    if (!send) throw typed("UI_SELECTOR_MISSING", "Could not find the ChatGPT send button", false);
    if (send.disabled || send.getAttribute("aria-disabled") === "true") throw typed("SUBMIT_DISABLED", "ChatGPT send button is disabled", false);

    const beforeCount = getConversationTurnCount();
    send.click();
    await waitForSubmission(beforeCount, 8000);

    const image = await waitForFreshStableImage(baseline, Number(message.timeoutMs) || 240000, message.jobKey);
    lastGeneratedImage = image;
    const src = image.currentSrc || image.src || "";
    return {
      imageUrl: src,
      imageKind: src.startsWith("blob:") ? "blob" : src.startsWith("data:") ? "data" : "url",
      width: image.naturalWidth || null,
      height: image.naturalHeight || null
    };
  }

  function findComposer() {
    const selectors = [
      "#prompt-textarea",
      "textarea[data-testid='prompt-textarea']",
      "div[contenteditable='true'][data-lexical-editor='true']",
      "div[contenteditable='true'].ProseMirror"
    ];
    for (const selector of selectors) {
      const el = document.querySelector(selector);
      if (el && isVisible(el)) return el;
    }
    return null;
  }

  function findSendButton() {
    const selectors = [
      "button[data-testid='send-button']",
      "#composer-submit-button",
      "button[aria-label*='Send']",
      "button[aria-label*='send']",
      "button[aria-label*='发送']"
    ];
    for (const selector of selectors) {
      const el = document.querySelector(selector);
      if (el && isVisible(el)) return el;
    }
    return null;
  }

  function setComposerText(el, text) {
    el.focus();
    if (el instanceof HTMLTextAreaElement || el instanceof HTMLInputElement) {
      const proto = el instanceof HTMLTextAreaElement ? HTMLTextAreaElement.prototype : HTMLInputElement.prototype;
      const descriptor = Object.getOwnPropertyDescriptor(proto, "value");
      descriptor?.set?.call(el, text);
      el.dispatchEvent(new Event("input", { bubbles: true }));
      el.dispatchEvent(new Event("change", { bubbles: true }));
      return;
    }
    try {
      document.execCommand("selectAll", false, null);
      document.execCommand("insertText", false, text);
    } catch {
      el.textContent = text;
    }
    el.dispatchEvent(new InputEvent("input", { bubbles: true, inputType: "insertText", data: text }));
  }

  async function waitForSubmission(beforeCount, timeoutMs) {
    const started = Date.now();
    while (Date.now() - started < timeoutMs) {
      if (getConversationTurnCount() > beforeCount || findStopButton()) return;
      await sleep(150);
    }
    throw typed("SUBMIT_FAILED", "Prompt submission could not be confirmed", true);
  }

  function findStopButton() {
    return document.querySelector("button[data-testid='stop-button'], button[aria-label*='Stop'], button[aria-label*='停止']");
  }

  async function waitForFreshStableImage(baseline, timeoutMs, jobKey) {
    const started = Date.now();
    let lastFp = null;
    let stable = 0;
    while (Date.now() - started < timeoutMs) {
      await chrome.runtime.sendMessage({ type: "CHATGPT_HEARTBEAT", ready: Boolean(findComposer()), jobKey }).catch(() => {});
      const rate = detectRateLimit();
      if (rate) throw typed("RATE_LIMITED", rate, true);
      const candidates = getCandidateImages().filter((img) => !baseline.has(imageFingerprint(img)));
      const best = candidates.sort((a, b) => scoreImage(b) - scoreImage(a))[0];
      if (best && scoreImage(best) >= 6) {
        const fp = imageFingerprint(best);
        if (fp === lastFp && best.complete && (best.naturalWidth || 0) >= 256) stable += 1;
        else stable = 0;
        lastFp = fp;
        if (stable >= 2) return best;
      }
      await sleep(1200);
    }
    throw typed("NO_FRESH_IMAGE", "No stable newly generated image was detected before timeout", true);
  }

  function getCandidateImages() {
    return [...document.querySelectorAll("main img, article img")].filter((img) => {
      const r = img.getBoundingClientRect();
      const w = img.naturalWidth || r.width;
      const h = img.naturalHeight || r.height;
      return isVisible(img) && w >= 128 && h >= 128;
    });
  }

  function scoreImage(img) {
    const src = (img.currentSrc || img.src || "").toLowerCase();
    const alt = (img.alt || "").toLowerCase();
    let score = 0;
    if (/generated image|image generated|生成.*图|已生成/.test(alt)) score += 10;
    if (/oaiusercontent|openaiusercontent|oaidalleapiprodscus/.test(src)) score += 8;
    if ((img.naturalWidth || 0) >= 512 && (img.naturalHeight || 0) >= 512) score += 5;
    if (img.closest("article")) score += 2;
    if (/avatar|profile|icon/.test(alt + src)) score -= 10;
    return score;
  }

  function imageFingerprint(img) {
    return `${img.currentSrc || img.src || ""}|${img.naturalWidth || 0}x${img.naturalHeight || 0}`;
  }

  async function findOrRevealDownloadButton(img) {
    let scope = img;
    for (let i = 0; i < 8 && scope; i++, scope = scope.parentElement) {
      const button = findDownloadButtonIn(scope);
      if (button) return button;
    }
    img.click();
    await sleep(700);
    return findDownloadButtonIn(document);
  }

  function findDownloadButtonIn(scope) {
    const buttons = [...scope.querySelectorAll("button, a")];
    return buttons.find((el) => {
      if (!isVisible(el)) return false;
      const label = `${el.getAttribute("aria-label") || ""} ${el.getAttribute("title") || ""} ${el.getAttribute("data-testid") || ""} ${el.textContent || ""}`;
      return /download|save image|下载|保存图片/i.test(label);
    }) ?? null;
  }

  function detectRateLimit() {
    const articles = [...document.querySelectorAll("main article")];
    const text = (articles.at(-1)?.innerText || document.querySelector("main")?.innerText || "").slice(-3000);
    const match = text.match(/(?:rate limit|too many requests|try again later|image generation.*(?:limit|unavailable)|达到.{0,20}上限|稍后再试|暂时无法生成)/i);
    return match ? match[0] : null;
  }

  function getConversationTurnCount() {
    return document.querySelectorAll("main article").length;
  }

  function looksLoggedOut() {
    const text = document.body?.innerText || "";
    return /log in|sign up|登录|注册/i.test(text) && !findComposer();
  }

  function isVisible(el) {
    const style = getComputedStyle(el);
    const rect = el.getBoundingClientRect();
    return style.display !== "none" && style.visibility !== "hidden" && rect.width > 0 && rect.height > 0;
  }

  function typed(code, message, submitted = false) {
    const e = new Error(message);
    e.code = code;
    e.submitted = submitted;
    return e;
  }

  function serializeError(error) {
    return { code: String(error?.code ?? "UNKNOWN"), message: String(error?.message ?? error ?? "Unknown error"), submitted: Boolean(error?.submitted) };
  }

  function sleep(ms) { return new Promise((resolve) => setTimeout(resolve, ms)); }

  setInterval(() => {
    chrome.runtime.sendMessage({ type: "CHATGPT_HEARTBEAT", ready: Boolean(findComposer()) }).catch(() => {});
  }, 15000);
})();
