from __future__ import annotations

from ..security import validate_url_syntax, resolve_and_validate, choose_pinned_ip, UnsafeTarget
from .pinning import pin


class SafeURLMiddleware:
    """Validate every request, then pin the exact validated destination used by Twisted."""

    def process_request(self, request, spider):
        try:
            target = resolve_and_validate(validate_url_syntax(request.url))
            pin(target.hostname, choose_pinned_ip(target.resolved_ips))
            request.meta["validated_public_ips"] = target.resolved_ips
            request.meta["pinned_ip"] = choose_pinned_ip(target.resolved_ips)
        except UnsafeTarget as exc:
            from scrapy.exceptions import IgnoreRequest
            raise IgnoreRequest(f"SAFE_URL_REJECT:{exc.reason}:{request.url}")
