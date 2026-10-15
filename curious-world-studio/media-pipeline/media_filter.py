"""CWS default source filtering: block mainland video platforms and require landscape >= 4:3."""
from __future__ import annotations
from functools import lru_cache
from pathlib import Path
from urllib.parse import urlsplit

POLICY_DIR = Path(__file__).resolve().parent
PSL_PATH = POLICY_DIR / "public_suffix_list.dat"
MIN_DAR = 4 / 3
PREFERRED_DAR = 16 / 9
DOMESTIC_ROOTS = {
    "acfun.cn", "b23.tv", "bilibili.com", "bilibili.tv", "baidu.com", "douban.com", "douyin.com", "douyinvod.com",
    "douyu.com", "huya.com", "iq.com", "iqiyi.com", "ixigua.com", "kuaishou.com",
    "ksurl.cn", "le.com", "letv.com", "mgtv.com", "pptv.com", "qiyi.com",
    "qq.com", "sohu.com", "tencent.com", "toutiao.com", "tudou.com", "weibo.com", "weibo.cn", "t.cn",
    "ifeng.com", "xinpianchang.com", "xhslink.com", "xiaohongshu.com", "yizhibo.com", "youku.com", "youku.tv",
    "yy.com", "1905.com",
}

@lru_cache(maxsize=1)
def _psl_rules() -> tuple[set[str], set[str], set[str]]:
    exact: set[str] = set()
    wildcard: set[str] = set()
    exceptions: set[str] = set()
    # The full, version-pinned PSL remains an optional local data file. Offline
    # installations use a conservative set of common multi-label suffixes.
    # Source-platform exclusions always use explicit hostname suffix matching.
    fallback = "co.il\nco.uk\norg.uk\nac.uk\ncom.au\nnet.au\norg.au\nco.nz\ncom.br\ncom.mx\nco.jp\nco.kr\ncom.cn\ncom.hk\ncom.sg\ncom.tr\nco.za\n"
    rules = PSL_PATH.read_text(encoding="utf-8") if PSL_PATH.is_file() else fallback
    for line in rules.splitlines():
        rule = line.strip().lower()
        if not rule or rule.startswith("//"):
            continue
        if rule.startswith("!"):
            exceptions.add(rule[1:])
        elif rule.startswith("*."):
            wildcard.add(rule[2:])
        else:
            exact.add(rule)
    return exact, wildcard, exceptions

def normalize_host(value: str) -> str:
    raw = value.strip()
    parsed = urlsplit(raw if "://" in raw else "//" + raw)
    host = (parsed.hostname or "").rstrip(".").lower()
    return host.encode("idna").decode("ascii") if host else ""

def registered_domain(value: str) -> str:
    host = normalize_host(value)
    if not host or host == "localhost" or all(p.isdigit() for p in host.split(".")):
        return host
    labels = host.split(".")
    exact, wildcard, exceptions = _psl_rules()
    suffix_len = 1
    for i in range(len(labels)):
        candidate = ".".join(labels[i:])
        if candidate in exceptions:
            suffix_len = len(labels) - i - 1
            break
        if candidate in exact:
            suffix_len = max(suffix_len, len(labels) - i)
        if i > 0 and candidate in wildcard:
            suffix_len = max(suffix_len, len(labels) - i + 1)
    take = min(len(labels), suffix_len + 1)
    return ".".join(labels[-take:])

def is_mainland_video_platform(value: str) -> tuple[bool, str]:
    host = normalize_host(value)
    for root in DOMESTIC_ROOTS:
        if host == root or host.endswith("." + root):
            return True, "DOMESTIC_PLATFORM:" + root
    return False, ""

def assess_orientation(width=None, height=None, sar="1:1", rotation=0) -> dict:
    if width in (None, "") or height in (None, ""):
        return {"queue_status": "ALLOW_BOUNDED_FORMAT_PROBE", "display_width": None,
                "display_height": None, "display_aspect_ratio": None,
                "landscape_4_3": None, "resolution_class": "UNKNOWN_DIMENSIONS"}
    w, h = int(width), int(height)
    if w <= 0 or h <= 0:
        return {"queue_status": "ALLOW_BOUNDED_FORMAT_PROBE", "display_width": None,
                "display_height": None, "display_aspect_ratio": None,
                "landscape_4_3": None, "resolution_class": "INVALID_DIMENSIONS"}
    try:
        a, b = sar.replace("/", ":").split(":", 1)
        sar_value = float(a) / float(b)
    except (AttributeError, ValueError, ZeroDivisionError):
        sar_value = 1.0
    angle = abs(int(float(rotation))) % 360
    rotated = angle in (90, 270)
    dw, dh = (h, w) if rotated else (w, h)
    dar = ((w * sar_value) / h)
    if rotated:
        dar = 1.0 / dar
    landscape = dar >= MIN_DAR
    if not landscape:
        klass, status = "EXCLUDED_PORTRAIT_OR_SQUARE", "EXCLUDE_ORIENTATION"
    elif dh >= 2160:
        klass, status = "4K_PLUS", "ACCEPT_LANDSCAPE"
    elif dh >= 1440:
        klass, status = "1440P", "ACCEPT_LANDSCAPE"
    elif dh >= 1080:
        klass, status = "1080P", "ACCEPT_LANDSCAPE"
    elif dh >= 720:
        klass, status = "720P", "ACCEPT_LANDSCAPE"
    elif dh >= 360:
        klass, status = "UNDER_720P_LANDSCAPE", "ACCEPT_LANDSCAPE"
    else:
        klass, status = "BELOW_MINIMUM_RESOLUTION", "EXCLUDE_RESOLUTION"
    return {"queue_status": status, "display_width": dw, "display_height": dh,
            "display_aspect_ratio": round(dar, 6), "landscape_4_3": landscape,
            "resolution_class": klass,
            "preferred_16_9": abs(dar - PREFERRED_DAR) <= 0.08}

def assess_candidate(url: str, width=None, height=None, sar="1:1", rotation=0) -> dict:
    host = normalize_host(url)
    blocked, reason = is_mainland_video_platform(host)
    if blocked:
        return {"eligible": False, "filter_reason": reason, "host": host,
                "registered_domain": registered_domain(host), **assess_orientation(None, None)}
    orientation = assess_orientation(width, height, sar, rotation)
    if orientation["queue_status"] == "EXCLUDE_ORIENTATION":
        return {"eligible": False, "filter_reason": "PORTRAIT_OR_SQUARE", "host": host,
                "registered_domain": registered_domain(host), **orientation}
    if orientation["queue_status"] == "EXCLUDE_RESOLUTION":
        return {"eligible": False, "filter_reason": "BELOW_MINIMUM_RESOLUTION", "host": host,
                "registered_domain": registered_domain(host), **orientation}
    return {"eligible": True, "filter_reason": orientation["queue_status"], "host": host,
            "registered_domain": registered_domain(host), **orientation}
