from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse

MAX_BODY = 5 * 1024 * 1024


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--max-pages", type=int, default=6)
    parser.add_argument("--max-depth", type=int, default=1)
    parser.add_argument("--max-redirects", type=int, default=5)
    parser.add_argument("--max-body-bytes", type=int, default=MAX_BODY)
    args = parser.parse_args()

    try:
        import scrapy
        from scrapy.crawler import CrawlerProcess
    except ModuleNotFoundError:
        Path(args.out).write_text(json.dumps({"access_state": "AUDIT_INCOMPLETE", "error_code": "SCRAPY_DEPENDENCY_UNAVAILABLE", "pages": []}), encoding="utf-8")
        return 3

    pages = []
    origin = urlparse(args.url).hostname

    class Spider(scrapy.Spider):
        name = "conversion_leak_bounded"
        custom_settings = {
            "ROBOTSTXT_OBEY": True,
            "CONCURRENT_REQUESTS": 1,
            "CONCURRENT_REQUESTS_PER_DOMAIN": 1,
            "DOWNLOAD_DELAY": 0.75,
            "RANDOMIZE_DOWNLOAD_DELAY": True,
            "DOWNLOAD_TIMEOUT": 15,
            "DOWNLOAD_MAXSIZE": args.max_body_bytes,
            "DOWNLOAD_WARNSIZE": args.max_body_bytes,
            "RETRY_TIMES": 1,
            "REDIRECT_MAX_TIMES": args.max_redirects,
            "COOKIES_ENABLED": False,
            "TELNETCONSOLE_ENABLED": False,
            "DEPTH_LIMIT": args.max_depth,
            "CLOSESPIDER_PAGECOUNT": args.max_pages,
            "LOG_LEVEL": "WARNING",
            "DOWNLOADER_MIDDLEWARES": {"app.crawlers.safety_middleware.SafeURLMiddleware": 50},
            "USER_AGENT": "ConversionLeakAuditScanner/0.2",
        }

        async def start(self):
            yield scrapy.Request(args.url, callback=self.parse_page, errback=self.err_page, meta={"handle_httpstatus_all": True}, dont_filter=True)

        def parse_page(self, response):
            body = response.body or b""
            if len(body) > args.max_body_bytes:
                pages.append({"requested_url": response.request.url, "final_url": response.url, "status": int(response.status), "error": "RESPONSE_BODY_TOO_LARGE"})
                return
            pages.append({
                "requested_url": response.request.url,
                "final_url": response.url,
                "status": int(response.status),
                "html": response.text,
                "timestamp": datetime.now(timezone.utc).isoformat(),
                "pinned_ip": response.request.meta.get("pinned_ip"),
            })
            if len(pages) >= args.max_pages:
                return
            for href in response.css("a::attr(href)").getall():
                u = response.urljoin(href)
                if urlparse(u).hostname != origin:
                    continue
                low = u.lower()
                if any(k in low for k in ("/product", "/shop", "/collections/", "/shipping", "/delivery", "/return", "/refund", "/pricing", "/membership", "/subscription", "/faq")):
                    yield response.follow(u, callback=self.parse_page, errback=self.err_page)

        def err_page(self, failure):
            pages.append({"requested_url": failure.request.url, "final_url": failure.request.url, "status": None, "error": type(failure.value).__name__, "timestamp": datetime.now(timezone.utc).isoformat()})

    process = CrawlerProcess(settings={
        "TWISTED_DNS_RESOLVER": "app.crawlers.pinned_resolver.PinnedResolver",
    })
    crawler = process.create_crawler(Spider)
    process.crawl(crawler)
    process.start()
    stats = crawler.stats.get_stats()
    statuses = {p.get("status") for p in pages}
    if stats.get("robotstxt/forbidden", 0):
        error_code = "ROBOTS_DENIED"
    elif 429 in statuses:
        error_code = "RATE_LIMITED"
    elif 403 in statuses:
        error_code = "ACCESS_BLOCKED"
    else:
        error_code = None
    state = "ACCESS_OK" if any(p.get("status") == 200 for p in pages) and error_code is None else "AUDIT_INCOMPLETE"
    Path(args.out).write_text(json.dumps({"access_state": state, "error_code": error_code, "pages": pages}, ensure_ascii=False), encoding="utf-8")
    return 0 if state == "ACCESS_OK" else 2


if __name__ == "__main__":
    raise SystemExit(main())
