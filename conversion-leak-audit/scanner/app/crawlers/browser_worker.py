from __future__ import annotations

import argparse
import json
from pathlib import Path
from urllib.parse import urlsplit

from app.security import validate_url_syntax, resolve_and_validate, choose_pinned_ip, UnsafeTarget

MAX_BODY = 5 * 1024 * 1024


def browser_request_allowed(url: str, original_host: str) -> bool:
    u = urlsplit(url)
    if u.scheme in {"data", "blob", "about"}:
        return True
    try:
        t = validate_url_syntax(url)
    except UnsafeTarget:
        return False
    return t.hostname == original_host.rstrip(".").lower()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--url", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--timeout-ms", type=int, default=25000)
    ap.add_argument("--max-body-bytes", type=int, default=MAX_BODY)
    ap.add_argument("--max-redirects", type=int, default=5)
    args = ap.parse_args()
    out = Path(args.out)

    try:
        target = resolve_and_validate(validate_url_syntax(args.url))
        pinned_ip = choose_pinned_ip(target.resolved_ips)
    except UnsafeTarget as exc:
        out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": f"UNSAFE_TARGET_{exc.reason}", "pages": []}), encoding="utf-8")
        return 4

    try:
        from playwright.sync_api import sync_playwright
    except ModuleNotFoundError:
        out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "PLAYWRIGHT_DEPENDENCY_UNAVAILABLE", "pages": []}), encoding="utf-8")
        return 3

    original_host = target.hostname
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(
                headless=True,
                args=[
                    "--no-sandbox",
                    f"--host-resolver-rules=MAP {original_host} {pinned_ip}",
                ],
            )
            context = browser.new_context(viewport={"width": 1365, "height": 900}, user_agent="ConversionLeakAuditScannerBrowser/0.2")

            def route_handler(route):
                if browser_request_allowed(route.request.url, original_host):
                    return route.continue_()
                return route.abort("blockedbyclient")

            context.route("**/*", route_handler)
            page = context.new_page()
            response = page.goto(args.url, wait_until="domcontentloaded", timeout=args.timeout_ms)
            page.wait_for_timeout(750)
            final_url = page.url
            final = validate_url_syntax(final_url)
            if final.hostname != original_host:
                browser.close()
                out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "BROWSER_CROSS_HOST_REDIRECT_BLOCKED", "pages": []}), encoding="utf-8")
                return 2
            redirects = 0
            req = response.request if response else None
            while req is not None and req.redirected_from is not None:
                redirects += 1
                req = req.redirected_from
            if redirects > args.max_redirects:
                browser.close()
                out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "TOO_MANY_REDIRECTS", "pages": []}), encoding="utf-8")
                return 2
            status = response.status if response else None
            body = page.content()
            if len(body.encode("utf-8")) > args.max_body_bytes:
                browser.close()
                out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "RESPONSE_BODY_TOO_LARGE", "pages": []}), encoding="utf-8")
                return 2
            if len(context.pages) > 2:
                browser.close()
                out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "BROWSER_PAGE_LIMIT_EXCEEDED", "pages": []}), encoding="utf-8")
                return 2
            browser.close()
        state = "ACCESS_OK" if status == 200 and len(body) > 500 else "AUDIT_INCOMPLETE"
        out.write_text(json.dumps({"access_state": state, "source": "BROWSER", "pages": [{"requested_url": args.url, "final_url": final_url, "status": status, "html": body, "pinned_ip": pinned_ip}]}, ensure_ascii=False), encoding="utf-8")
        return 0 if state == "ACCESS_OK" else 2
    except Exception as exc:
        out.write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "BROWSER_RUNTIME_ERROR", "error_detail": type(exc).__name__, "pages": []}), encoding="utf-8")
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
