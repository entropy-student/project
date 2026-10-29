"""CWS MEDIA integration entry point: bounded discovery, review, acquisition and QA.

Standard-library only. Requires external yt-dlp, ffprobe and ffmpeg for media operations.
No automatic download after search; non-loopback URLs only for media candidates.
"""
from __future__ import annotations
import argparse
import hashlib
import html
import http.client
import ipaddress
import json
import os
import re
import signal
import socket
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from urllib.parse import parse_qsl, urlencode, urljoin, urlsplit, urlunsplit
from urllib.request import ProxyHandler, Request, build_opener, HTTPRedirectHandler
from urllib.error import HTTPError, URLError

from media_filter import assess_candidate, assess_orientation, is_mainland_video_platform, normalize_host
import safe_proxy

TIMEOUT = 60
DEFAULT_FILE_BYTES = 60_000_000
DEFAULT_TOTAL_BYTES = 250_000_000
HARD_FILE_BYTES = 80_000_000
HARD_TOTAL_BYTES = 2_000_000_000
DEFAULT_IMAGE_BYTES = 15_000_000
SAFE_DIRECT_MAX_FILE_BYTES = 30_000_000
SAFE_DIRECT_MAX_TOTAL_BYTES = 60_000_000
REDACT = re.compile(r"(?i)(token|signature|secret|password|cookie|authorization|auth|key|credential|x-amz)")
CWS_ROOT = Path(__file__).resolve().parents[1]


def ensure_local_workdir(workdir: Path) -> Path:
    """Keep candidate indexes, downloads and previews under the ignored CWS .local directory."""
    local_root = (CWS_ROOT / ".local").resolve()
    target = Path(workdir).resolve()
    if target != local_root and local_root not in target.parents:
        raise ValueError("workdir must be inside curious-world-studio/.local")
    return target


def cleaned_url(url: str) -> str:
    u = urlsplit(url)
    if u.scheme not in ("http", "https") or not u.hostname or u.username or u.password:
        raise ValueError("HTTP(S) URL with a host is required")
    host = u.hostname.lower().rstrip(".")
    if host in ("localhost",) or host.endswith(".localhost"):
        raise ValueError("Localhost is not an eligible media source")
    try:
        ip = ipaddress.ip_address(host)
        if not ip.is_global:
            raise ValueError("Non-public media source IP")
    except ValueError as e:
        if str(e) == "Non-public media source IP":
            raise
    query = [(k, v) for k, v in parse_qsl(u.query, keep_blank_values=True) if not REDACT.search(k)]
    port = ":" + str(u.port) if u.port else ""
    return urlunsplit((u.scheme, host + port, u.path or "/", urlencode(query), ""))


def candidate_id(kind: str, url: str) -> str:
    return kind + "-" + hashlib.sha256(cleaned_url(url).encode()).hexdigest()[:20]


def parse_results(engine: str, kind: str, payload: dict) -> list[dict]:
    # 4get live/archive API uses singular collection keys: video / image.
    # Accept plural only as a compatibility fallback, not the primary schema.
    key = "results" if engine == "searxng" else kind
    rows = payload.get(key, payload.get(kind + "s", []))
    if not isinstance(rows, list):
        raise ValueError("SEARCH_SCHEMA_UNEXPECTED: " + key)
    parsed = []
    for row in rows:
        if not isinstance(row, dict):
            continue
        url = row.get("url", "")
        try:
            clean = cleaned_url(url)
        except (ValueError, TypeError):
            continue
        title = str(row.get("title", ""))[:300]
        row_out = {"id": candidate_id(kind, clean), "kind": kind, "url": clean,
                   "title": title, "engine": engine,
                   "site": normalize_host(clean), "status": "DISCOVERED"}
        if kind == "image":
            for field, aliases in (("media_url", ("img_src", "image", "image_url", "media_url")),
                                   ("thumbnail", ("thumbnail_src", "thumbnail", "thumb"))):
                for alias in aliases:
                    value = row.get(alias)
                    if isinstance(value, str) and value.startswith(("http://", "https://")):
                        try:
                            if field == "media_url" and REDACT.search(urlsplit(value).query):
                                continue
                            row_out[field] = cleaned_url(value)
                            break
                        except ValueError:
                            pass
        else:
            for field in ("width", "height"):
                value = row.get(field)
                if isinstance(value, int) and 0 < value <= 100_000:
                    row_out[field] = value
            resolution = row.get("resolution")
            if isinstance(resolution, str):
                match = re.fullmatch(r"\s*(\d{2,5})\s*[x×]\s*(\d{2,5})\s*", resolution, re.I)
                if match:
                    row_out.setdefault("width", int(match.group(1)))
                    row_out.setdefault("height", int(match.group(2)))
        parsed.append(row_out)
    return parsed


def filter_record(record: dict, metadata: dict | None = None) -> dict:
    m = metadata or {}
    if record.get("kind") == "image":
        blocked, reason = is_mainland_video_platform(record.get("url", ""))
        result = {"eligible": not blocked,
                  "filter_reason": reason if blocked else "IMAGE_ORIENTATION_NOT_APPLICABLE",
                  "host": normalize_host(record.get("url", ""))}
        return {**record, "filter": result, "status": "EXCLUDED" if blocked else "ELIGIBLE"}
    res = assess_candidate(record["url"], m.get("width"), m.get("height"),
                           m.get("sar", "1:1"), m.get("rotation", 0))
    return {**record, "filter": res, "status": "ELIGIBLE" if res["eligible"] else "EXCLUDED"}


def atomically_write(path: Path, payload: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=".cws-", dir=str(path.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as file:
            json.dump(payload, file, ensure_ascii=False, indent=2)
            file.write("\n")
        os.replace(tmp, path)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)


class Catalog:
    def __init__(self, workdir: Path):
        self.workdir = workdir.resolve()
        self.path = self.workdir / "index.json"
        self.data = json.loads(self.path.read_text(encoding="utf-8")) if self.path.exists() else {"items": {}, "queries": [], "events": []}

    def save(self):
        atomically_write(self.path, self.data)

    def event(self, action: str, status: str, **details):
        self.data["events"].append({"action": action, "status": status, **details})
        self.save()

    def add(self, candidates: list[dict]):
        for row in candidates:
            row = filter_record(row)
            key = row["id"]
            existing = self.data["items"].get(key)
            if existing:
                engines = set(existing.get("engines", [existing["engine"]]))
                engines.add(row["engine"])
                existing["engines"] = sorted(engines)
            else:
                row["engines"] = [row["engine"]]
                self.data["items"][key] = row
        self.save()


def _validated_proxy(proxy: str | None) -> str | None:
    if not proxy:
        return None
    parsed = urlsplit(proxy)
    if parsed.scheme not in ("http", "https") or not parsed.hostname or parsed.username or parsed.password:
        raise ValueError("Proxy must be an unauthenticated HTTP(S) endpoint")
    try:
        _ = parsed.port
    except ValueError as exc:
        raise ValueError("Proxy port is invalid") from exc
    return proxy.rstrip("/")


def _is_loopback(host: str) -> bool:
    if host.lower() == "localhost" or host.lower().endswith(".localhost"):
        return True
    try:
        return ipaddress.ip_address(host).is_loopback
    except ValueError:
        return False


def _validate_public_url(url: str) -> None:
    """Reject private targets before requests; never accept untrusted DNS resolutions."""
    cleaned_url(url)
    target = urlsplit(url)
    host = (target.hostname or "").rstrip(".").lower()
    if host.endswith((".local", ".internal", ".home.arpa")):
        raise ValueError("LOCAL_NETWORK_MEDIA_URL")
    try:
        addresses = socket.getaddrinfo(host, target.port or (443 if target.scheme == "https" else 80), type=socket.SOCK_STREAM)
    except socket.gaierror as exc:
        raise ValueError("MEDIA_HOST_DNS_UNRESOLVED") from exc
    if not addresses or any(not ipaddress.ip_address(info[4][0]).is_global for info in addresses):
        raise ValueError("NON_PUBLIC_MEDIA_ADDRESS")


class _SafeRedirectHandler(HTTPRedirectHandler):
    def __init__(self, loopback_only: bool):
        self.loopback_only = loopback_only

    def redirect_request(self, req, fp, code, msg, headers, newurl):
        target = urlsplit(newurl)
        if target.scheme not in ("http", "https") or not target.hostname or target.username or target.password:
            raise ValueError("INVALID_REDIRECT_URL")
        if self.loopback_only:
            if not _is_loopback(target.hostname):
                raise ValueError("SEARCH_REDIRECT_OFF_LOOPBACK")
        else:
            _validate_public_url(newurl)
        return super().redirect_request(req, fp, code, msg, headers, newurl)


def _opener_for(url: str, proxy: str | None):
    host = urlsplit(url).hostname or ""
    proxy = _validated_proxy(proxy)
    local = _is_loopback(host)
    mapping = {} if local or not proxy else {"http": proxy, "https": proxy}
    return build_opener(ProxyHandler(mapping), _SafeRedirectHandler(local))


def _child_env(proxy: str | None = None) -> dict[str, str]:
    env = {k: v for k, v in os.environ.items() if k.lower() not in
           ("http_proxy", "https_proxy", "all_proxy", "no_proxy")}
    proxy = _validated_proxy(proxy)
    if proxy:
        for key in ("HTTP_PROXY", "HTTPS_PROXY", "ALL_PROXY", "http_proxy", "https_proxy", "all_proxy"):
            env[key] = proxy
    return env


def _process_flags() -> dict:
    if os.name == "nt":
        return {"creationflags": subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.CREATE_NO_WINDOW}
    return {"start_new_session": True}


def terminate_process_tree(proc: subprocess.Popen) -> str:
    if proc.poll() is not None:
        return "ALREADY_EXITED"
    if os.name == "nt":
        try:
            taskkill = subprocess.run(["taskkill", "/PID", str(proc.pid), "/T", "/F"],
                                      capture_output=True, text=True, errors="replace",
                                      timeout=15, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
            if taskkill.returncode == 0:
                return "TASKKILL_TREE"
        except (OSError, subprocess.TimeoutExpired):
            pass
        proc.kill()
        return "DIRECT_PROCESS_FALLBACK"
    try:
        os.killpg(proc.pid, signal.SIGTERM)
        proc.wait(timeout=2)
        return "PROCESS_GROUP_SIGTERM"
    except (ProcessLookupError, subprocess.TimeoutExpired):
        try:
            os.killpg(proc.pid, signal.SIGKILL)
            return "PROCESS_GROUP_SIGKILL"
        except ProcessLookupError:
            return "ALREADY_EXITED"


def fetch_json(url: str, timeout=20, proxy: str | None = None) -> dict:
    opener = _opener_for(url, proxy)
    with opener.open(Request(url, headers={"User-Agent": "CWS-MEDIA-INTEGRATION/1"}), timeout=timeout) as r:
        if r.status != 200:
            raise RuntimeError("SEARCH_HTTP_" + str(r.status))
        data = r.read(4_000_001)
        if len(data) > 4_000_000:
            raise RuntimeError("SEARCH_RESPONSE_TOO_LARGE")
        return json.loads(data)


def fetch_limited(url: str, cap: int, timeout: int = 20, proxy: str | None = None):
    _validate_public_url(url)
    opener = _opener_for(url, proxy)
    with opener.open(Request(url, headers={"User-Agent": "CWS-MEDIA-INTEGRATION/1"}), timeout=timeout) as r:
        _validate_public_url(r.geturl())
        final_url = cleaned_url(r.geturl())
        content_type = r.headers.get_content_type().lower()
        data = r.read(cap + 1)
        if len(data) > cap:
            raise RuntimeError("RESPONSE_SIZE_LIMIT")
        return data, content_type, final_url


def image_media_url(item: dict, proxy: str | None = None) -> str:
    direct = item.get("media_url")
    if direct:
        if REDACT.search(urlsplit(direct).query):
            raise RuntimeError("SIGNED_OR_SENSITIVE_IMAGE_URL")
        return cleaned_url(direct)
    data, content_type, page_url = fetch_limited(item["url"], 3_000_000, proxy=proxy)
    if content_type.startswith("image/"):
        media = page_url
    else:
        text = data.decode("utf-8", errors="replace")
        candidates = []
        for tag in re.findall(r"<meta\b[^>]*>", text, re.I):
            attrs = {k.lower(): html.unescape(v) for k, _, v in
                     re.findall(r"([\w:-]+)\s*=\s*([\"'])(.*?)\2", tag, re.S)}
            if (attrs.get("property") or attrs.get("name")) in ("og:image", "twitter:image", "twitter:image:src"):
                candidates.append(attrs.get("content", ""))
        media = next((urljoin(page_url, value) for value in candidates if value), "")
    if not media:
        raise RuntimeError("NO_PUBLIC_IMAGE_LINK")
    if REDACT.search(urlsplit(media).query):
        raise RuntimeError("SIGNED_OR_SENSITIVE_IMAGE_URL")
    media = cleaned_url(media)
    return media


def qa_image(path: Path, ffprobe: str, ffmpeg: str, timeout=60) -> dict:
    p = run([ffprobe, "-v", "error", "-show_streams", "-show_format", "-of", "json", str(path)], timeout)
    if p.returncode:
        raise RuntimeError("IMAGE_FFPROBE_FAILED")
    meta = json.loads(p.stdout)
    image = next((s for s in meta.get("streams", []) if s.get("codec_type") == "video"), None)
    if not image or not image.get("width") or not image.get("height"):
        raise RuntimeError("NO_DECODABLE_IMAGE_STREAM")
    p = run([ffmpeg, "-nostdin", "-v", "error", "-xerror", "-i", str(path), "-frames:v", "1",
             "-f", "null", "NUL" if os.name == "nt" else "/dev/null"], timeout)
    if p.returncode or p.stderr.strip():
        raise RuntimeError("IMAGE_DECODE_FAILED")
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    return {"sha256": digest, "file_bytes": path.stat().st_size, "width": image["width"],
            "height": image["height"], "codec": image.get("codec_name"), "status": "IMAGE_DECODE_PASS"}


def download_image_one(catalog: Catalog, key: str, ffprobe: str, ffmpeg: str,
                       max_bytes: int = DEFAULT_IMAGE_BYTES, timeout: int = 30,
                       proxy: str | None = None):
    item = catalog.data["items"][key]
    if item.get("kind") != "image" or item.get("status") not in ("ELIGIBLE", "DISCOVERED"):
        raise ValueError("Image download requires an explicitly selected indexed image")
    if not 0 < max_bytes <= DEFAULT_IMAGE_BYTES:
        raise ValueError("Image budget must be within the hard limit")
    media_url = image_media_url(item, proxy)
    data, content_type, final_url = fetch_limited(media_url, max_bytes, timeout, proxy)
    extensions = {"image/jpeg": ".jpg", "image/png": ".png", "image/webp": ".webp",
                  "image/gif": ".gif", "image/tiff": ".tiff", "image/avif": ".avif"}
    extension = extensions.get(content_type)
    if not extension:
        raise RuntimeError("UNSUPPORTED_OR_NON_IMAGE_CONTENT_TYPE")
    out = catalog.workdir / "images"
    out.mkdir(parents=True, exist_ok=True)
    dest = out / (key + extension)
    if dest.exists():
        item.update({"status": "IMAGE_CACHE_PRESENT", "local_file": dest.relative_to(catalog.workdir).as_posix()})
        catalog.save()
        return item
    temp = out / (key + ".part" + extension)
    temp.write_bytes(data)
    try:
        qa = qa_image(temp, ffprobe, ffmpeg, timeout)
        os.replace(temp, dest)
    except Exception:
        if temp.exists():
            temp.unlink()
        raise
    item.update({"status": "IMAGE_DECODE_PASS", "local_file": dest.relative_to(catalog.workdir).as_posix(),
                 "media_url": final_url, "image_content_type": content_type, "qa": qa,
                 "reuse_rights": "UNKNOWN"})
    catalog.save()
    return item


def search(catalog: Catalog, engine: str, kind: str, query: str, endpoint: str, page: int = 1,
           proxy: str | None = None):
    base = endpoint.rstrip("/")
    if not base.startswith(("http://", "https://")):
        raise ValueError("Valid search endpoint required")
    if engine == "searxng":
        url = base + "/search?" + urlencode({"q": query, "categories": kind + "s", "format": "json", "pageno": page})
    else:
        if page != 1:
            raise ValueError("4get pagination requires its server-provided next-page token")
        url = base + "/api/v1/" + kind + "s?" + urlencode({"s": query})
    try:
        started = time.monotonic()
        payload = fetch_json(url, proxy=proxy)
        records = parse_results(engine, kind, payload)
        catalog.add(records)
        status = "EMPTY_RESULTS" if not records else "OK"
        upstream_errors = []
        # Preserve a safe diagnostic summary without persisting arbitrary upstream text.
        if engine == "searxng":
            for row in payload.get("unresponsive_engines", []) if isinstance(payload, dict) else []:
                if isinstance(row, (list, tuple)) and row:
                    name = str(row[0])[:80]
                    detail = str(row[1])[:160] if len(row) > 1 else ""
                    match = re.search(r"(?:HTTP\s*)?(\d{3})", detail, re.I)
                    category = "HTTP_" + match.group(1) if match else (
                        "TIMEOUT" if "timeout" in detail.lower() else
                        "CONNECTION_ERROR" if "connect" in detail.lower() else "UPSTREAM_ERROR")
                    upstream_errors.append({"engine": name, "error_type": category})
        else:
            for field in ("error", "errors", "unresponsive_engines"):
                value = payload.get(field) if isinstance(payload, dict) else None
                if value:
                    upstream_errors.append({"engine": "fourget", "error_type": "UPSTREAM_" + field.upper()})
        catalog.data["queries"].append({"engine": engine, "kind": kind, "query": query,
                                        "page": page, "count": len(records), "status": status,
                                        "upstream_errors": upstream_errors,
                                        "elapsed_ms": round((time.monotonic() - started) * 1000)})
        catalog.save()
        return len(records)
    except Exception as exc:
        catalog.event("search", "FAILED", engine=engine, kind=kind, error=type(exc).__name__)
        raise


def run(args: list[str], timeout: int = TIMEOUT, proxy: str | None = None) -> subprocess.CompletedProcess:
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                            encoding="utf-8", errors="replace", env=_child_env(proxy), **_process_flags())
    try:
        stdout, stderr = proc.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        terminate_process_tree(proc)
        try:
            proc.communicate(timeout=10)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.communicate()
        raise subprocess.TimeoutExpired(args, timeout)
    return subprocess.CompletedProcess(args, proc.returncode, stdout, stderr)


def metadata_orientation(formats: list[dict]) -> tuple[dict | None, str | None]:
    """Choose best known landscape video format, not an unknown/portrait format."""
    eligible = []
    for f in formats:
        if not isinstance(f, dict) or f.get("has_drm") or f.get("vcodec") == "none":
            continue
        r = assess_orientation(f.get("width"), f.get("height"), f.get("sar", "1:1"), f.get("rotation", 0))
        if r["queue_status"] == "ACCEPT_LANDSCAPE":
            eligible.append((r["display_height"], f.get("tbr") or 0, str(f.get("format_id") or ""), r))
    if eligible:
        best = max(eligible, key=lambda x: (x[0], x[1]))
        return best[3], best[2]
    return None, None


def probe_one(catalog: Catalog, key: str, ytdlp: str, timeout=60, proxy: str | None = None,
              ffprobe: str = "ffprobe"):
    item = catalog.data["items"][key]
    if item["kind"] != "video":
        raise ValueError("Only video supports yt-dlp probe")
    if not filter_record(item)["filter"]["eligible"]:
        item["status"] = "EXCLUDED"
        catalog.save()
        return item
    _validate_public_url(item["url"])
    cmd = [ytdlp, "--ignore-config", "--no-playlist", "--skip-download", "--dump-single-json", "--no-warnings",
           "--socket-timeout", "15", "--retries", "0"]
    if proxy:
        cmd.extend(["--proxy", _validated_proxy(proxy)])
    cmd.append(item["url"])
    p = run(cmd, timeout, proxy)
    if p.returncode:
        item["status"] = "PROBE_FAILED"
        item["error_type"] = "EXTRACTOR_OR_ACCESS_ERROR"
        catalog.save()
        return item
    try:
        meta = json.loads(p.stdout)
    except json.JSONDecodeError:
        item["status"] = "PROBE_FAILED"
        item["error_type"] = "INVALID_METADATA_JSON"
        catalog.save()
        return item
    if not isinstance(meta, dict) or meta.get("is_live") or meta.get("_type") in ("playlist", "multi_video"):
        item["status"] = "PROBE_FAILED"
        item["error_type"] = "NOT_SINGLE_VOD"
        catalog.save()
        return item
    formats = meta.get("formats") or []
    orientation, fmtid = metadata_orientation(formats)
    bounded_results = []
    if not fmtid:
        for f in [x for x in formats if isinstance(x, dict) and x.get("url")
                  and not x.get("has_drm") and x.get("vcodec") != "none"][:5]:
            result = {"format_id": str(f.get("format_id") or ""), "status": "UNKNOWN"}
            try:
                # Never pass untrusted remote formats directly to ffprobe: a remote
                # playlist or redirect could make ffprobe fetch an internal URL.
                _validate_public_url(f["url"])
                suffix = Path(urlsplit(f["url"]).path).suffix.lower()
                if suffix not in (".mp4", ".webm", ".mkv", ".mov", ".ogv", ".avi"):
                    result["status"] = "UNSAFE_OR_UNSUPPORTED_REMOTE_PROBE"
                    bounded_results.append(result)
                    continue
                content, _, _ = fetch_limited(f["url"], 16_000_000, timeout=12, proxy=proxy)
                with tempfile.TemporaryDirectory(prefix="cws-probe-") as tempdir:
                    local_probe = Path(tempdir) / ("candidate" + suffix)
                    local_probe.write_bytes(content)
                    cmd = [ffprobe, "-v", "error", "-show_streams", "-show_format", "-of", "json", str(local_probe)]
                    p_remote = run(cmd, 15, None)
                if p_remote.returncode == 0:
                    probed = json.loads(p_remote.stdout)
                    stream = next((s for s in probed.get("streams", []) if s.get("codec_type") == "video"), None)
                    if stream:
                        rotation = next((s.get("rotation", 0) for s in stream.get("side_data_list", []) if "rotation" in s), 0)
                        f["width"], f["height"] = stream.get("width"), stream.get("height")
                        f["sar"], f["rotation"] = stream.get("sample_aspect_ratio") or "1:1", rotation
                        f["vcodec"] = stream.get("codec_name") or f.get("vcodec")
                        result.update({"status": "PROBED", "width": f["width"], "height": f["height"],
                                       "video_codec": stream.get("codec_name"),
                                       "duration": probed.get("format", {}).get("duration")})
                    else:
                        result["status"] = "NO_VIDEO_STREAM"
                else:
                    result["status"] = "FFPROBE_EXIT_" + str(p_remote.returncode)
            except (subprocess.TimeoutExpired, json.JSONDecodeError, OSError, ValueError, RuntimeError) as exc:
                result["status"] = type(exc).__name__.upper()
            bounded_results.append(result)
        orientation, fmtid = metadata_orientation(formats)
    item["landscape_format_ids"] = [str(f.get("format_id")) for f in formats
                                    if f.get("format_id") is not None
                                    and assess_orientation(f.get("width"), f.get("height"),
                                                           f.get("sar", "1:1"), f.get("rotation", 0))["queue_status"] == "ACCEPT_LANDSCAPE"]
    item["duration"] = meta.get("duration")
    item["source_title"] = str(meta.get("title", ""))[:300]
    item["extractor"] = meta.get("extractor_key", "")
    item["format_id"] = fmtid
    item["format_orientation"] = orientation
    item["bounded_format_probe"] = bounded_results
    item["status"] = "READY_TO_DOWNLOAD" if fmtid else "UNKNOWN_NEEDS_PROBE"
    catalog.save()
    return item


def qa_media(path: Path, ffprobe: str, ffmpeg: str, timeout=180, local_only=False) -> dict:
    local_protocols = ["-protocol_whitelist", "file"] if local_only else []
    p = run([ffprobe, "-v", "error", *local_protocols, "-show_streams", "-show_format", "-of", "json", str(path)], timeout)
    if p.returncode:
        raise RuntimeError("FFPROBE_FAILED")
    meta = json.loads(p.stdout)
    video = next((s for s in meta.get("streams", []) if s.get("codec_type") == "video"), None)
    if not video:
        raise RuntimeError("NO_VIDEO_STREAM")
    rotation = next((s.get("rotation", 0) for s in video.get("side_data_list", []) if "rotation" in s), 0)
    o = assess_orientation(video.get("width"), video.get("height"), video.get("sample_aspect_ratio") or "1:1", rotation)
    if o["queue_status"] != "ACCEPT_LANDSCAPE":
        raise RuntimeError(o["queue_status"])
    if o["display_height"] < 360:
        raise RuntimeError("BELOW_MINIMUM_RESOLUTION")
    decode_started = time.monotonic()
    p = run([ffmpeg, "-nostdin", "-nostats", "-v", "error", "-xerror", *local_protocols, "-i", str(path),
             "-progress", "pipe:1", "-f", "null", "NUL" if os.name == "nt" else "/dev/null"], timeout)
    if p.returncode or p.stderr.strip():
        raise RuntimeError("FULL_DECODE_FAILED")
    decoded = re.findall(r"^frame=(\d+)$", p.stdout, re.M)
    if not decoded or int(decoded[-1]) < 1:
        raise RuntimeError("FULL_DECODE_ZERO_FRAMES")
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    preview = catalog_preview_path(path)
    frame_cmd = [ffmpeg, "-nostdin", "-v", "error", "-y"]
    frame_cmd.extend(local_protocols)
    duration = float(meta.get("format", {}).get("duration") or 0)
    frame_cmd.extend(["-ss", str(max(0, duration / 2)), "-i", str(path), "-frames:v", "1",
                      "-vf", "scale=1280:-2", str(preview)])
    frame = run(frame_cmd, timeout)
    if frame.returncode or not preview.is_file() or preview.stat().st_size == 0:
        raise RuntimeError("REPRESENTATIVE_FRAME_FAILED")
    streams = meta.get("streams", [])
    return {"sha256": h.hexdigest(), "file_bytes": path.stat().st_size,
            "display_width": o["display_width"], "display_height": o["display_height"],
            "display_aspect_ratio": o["display_aspect_ratio"],
            "duration": meta.get("format", {}).get("duration"),
            "video_codec": video.get("codec_name"), "video_fps": video.get("avg_frame_rate"),
            "video_bitrate": video.get("bit_rate"),
            "audio_codecs": [s.get("codec_name") for s in streams if s.get("codec_type") == "audio"],
            "decoded_frames": int(decoded[-1]), "decode_elapsed_ms": round((time.monotonic() - decode_started) * 1000),
            "representative_frame": preview.relative_to(path.parent.parent).as_posix(), "status": "FULL_DECODE_PASS"}


def catalog_preview_path(path: Path) -> Path:
    previews = path.parent.parent / "previews"
    previews.mkdir(parents=True, exist_ok=True)
    return previews / (path.stem + ".jpg")


def download_safe_direct_candidate(catalog: Catalog, key: str, proxy: str | None,
                                   ffprobe: str, ffmpeg: str,
                                   max_bytes: int = SAFE_DIRECT_MAX_FILE_BYTES,
                                   max_total_bytes: int = SAFE_DIRECT_MAX_TOTAL_BYTES,
                                   timeout: int = 45):
    """Fetch one indexed direct MP4/WebM using pinned IP CONNECT and verified TLS."""
    item = catalog.data["items"][key]
    if item.get("kind") != "video" or item.get("status") == "EXCLUDED":
        raise ValueError("SAFE_DIRECT_REQUIRES_ELIGIBLE_VIDEO_ID")
    if not filter_record(item)["filter"]["eligible"]:
        raise ValueError("SAFE_DIRECT_REQUIRES_ELIGIBLE_VIDEO_ID")
    if not proxy:
        raise safe_proxy.SafeProxyError("SAFE_PROXY_REQUIRED")
    if not 0 < max_bytes <= SAFE_DIRECT_MAX_FILE_BYTES:
        raise ValueError("SAFE_DIRECT_FILE_CAP_EXCEEDED")
    if not 0 < max_total_bytes <= SAFE_DIRECT_MAX_TOTAL_BYTES:
        raise ValueError("SAFE_DIRECT_TOTAL_CAP_EXCEEDED")
    if not 1 <= timeout <= 60:
        raise ValueError("SAFE_DIRECT_TIMEOUT_OUT_OF_RANGE")
    width, height = item.get("width"), item.get("height")
    if not isinstance(width, int) or not isinstance(height, int):
        raise ValueError("SAFE_DIRECT_DIMENSIONS_REQUIRED")
    orientation = assess_orientation(width, height, item.get("sar", "1:1"), item.get("rotation", 0))
    if orientation["queue_status"] != "ACCEPT_LANDSCAPE":
        raise ValueError("SAFE_DIRECT_NOT_LANDSCAPE")

    out = catalog.workdir / "downloads"
    out.mkdir(parents=True, exist_ok=True)
    used = sum(path.stat().st_size for path in out.iterdir() if path.is_file())
    if used >= max_total_bytes:
        raise ValueError("SAFE_DIRECT_TOTAL_CAP_EXCEEDED")
    cap = min(max_bytes, max_total_bytes - used)
    temp = None
    dest = None
    created_dest = False
    elapsed = time.monotonic()
    try:
        with safe_proxy.open_response(item["url"], proxy, "GET", {"Accept": "video/mp4, video/webm"}, timeout) as (response, proof):
            if 300 <= response.status < 400:
                raise safe_proxy.SafeProxyError("SAFE_REDIRECT_REFUSED")
            if response.status != 200:
                raise safe_proxy.SafeProxyError("SAFE_MEDIA_HTTP_STATUS_" + str(response.status))
            content_type = (response.getheader("Content-Type") or "").split(";", 1)[0].lower()
            extensions = {"video/mp4": ".mp4", "video/webm": ".webm"}
            extension = extensions.get(content_type)
            if not extension:
                raise safe_proxy.SafeProxyError("SAFE_DIRECT_MEDIA_TYPE_REJECTED")
            content_encoding = (response.getheader("Content-Encoding") or "identity").lower()
            if content_encoding not in ("", "identity"):
                raise safe_proxy.SafeProxyError("SAFE_CONTENT_ENCODING_REJECTED")
            length = response.getheader("Content-Length")
            if length is not None:
                if not length.isdigit():
                    raise safe_proxy.SafeProxyError("SAFE_CONTENT_LENGTH_INVALID")
                if int(length) > cap:
                    raise safe_proxy.SafeProxyError("SAFE_RESPONSE_SIZE_LIMIT")
            dest = out / (key + extension)
            if dest.exists():
                raise safe_proxy.SafeProxyError("SAFE_OUTPUT_ALREADY_EXISTS")
            temp = out / (key + ".part" + extension)
            if temp.exists():
                raise safe_proxy.SafeProxyError("SAFE_OUTPUT_ALREADY_EXISTS")
            total = 0
            signature = bytearray()
            with temp.open("xb") as media_file:
                try:
                    first = response.read(min(16, cap + 1))
                except TimeoutError as exc:
                    raise safe_proxy.SafeProxyError("SAFE_MEDIA_TIMEOUT") from exc
                except http.client.IncompleteRead as exc:
                    raise safe_proxy.SafeProxyError("SAFE_RESPONSE_TRUNCATED") from exc
                except OSError as exc:
                    raise safe_proxy.SafeProxyError("SAFE_MEDIA_RESPONSE_READ_FAILED") from exc
                if not first:
                    raise safe_proxy.SafeProxyError("SAFE_MEDIA_EMPTY")
                signature.extend(first)
                media_file.write(first)
                total += len(first)
                if (content_type == "video/mp4" and (len(signature) < 8 or signature[4:8] != b"ftyp")):
                    raise safe_proxy.SafeProxyError("SAFE_MEDIA_CONTAINER_REJECTED")
                if content_type == "video/webm" and not signature.startswith(b"\x1a\x45\xdf\xa3"):
                    raise safe_proxy.SafeProxyError("SAFE_MEDIA_CONTAINER_REJECTED")
                while True:
                    try:
                        block = response.read(min(65_536, cap + 1 - total))
                    except TimeoutError as exc:
                        raise safe_proxy.SafeProxyError("SAFE_MEDIA_TIMEOUT") from exc
                    except http.client.IncompleteRead as exc:
                        raise safe_proxy.SafeProxyError("SAFE_RESPONSE_TRUNCATED") from exc
                    except OSError as exc:
                        raise safe_proxy.SafeProxyError("SAFE_MEDIA_RESPONSE_READ_FAILED") from exc
                    if not block:
                        break
                    total += len(block)
                    if total > cap:
                        raise safe_proxy.SafeProxyError("SAFE_RESPONSE_SIZE_LIMIT")
                    media_file.write(block)
            if length is not None and total != int(length):
                raise safe_proxy.SafeProxyError("SAFE_RESPONSE_TRUNCATED")
            os.replace(temp, dest)
            temp = None
            created_dest = True
        qa = qa_media(dest, ffprobe, ffmpeg, timeout=max(timeout, 30), local_only=True)
        if qa["display_width"] != width or qa["display_height"] != height:
            dest.unlink(missing_ok=True)
            created_dest = False
            raise safe_proxy.SafeProxyError("SAFE_DIRECT_SOURCE_DIMENSION_MISMATCH")
    except Exception:
        if temp is not None:
            temp.unlink(missing_ok=True)
        if created_dest and dest is not None:
            dest.unlink(missing_ok=True)
        raise
    item.update({"status": "FULL_DECODE_PASS", "qa": qa,
                 "local_file": dest.relative_to(catalog.workdir).as_posix(),
                 "reuse_rights": item.get("reuse_rights", "UNKNOWN_TEST_ONLY"),
                 "download_bytes": dest.stat().st_size,
                 "download_elapsed_ms": round((time.monotonic() - elapsed) * 1000),
                 "transport": "SAFE_DYNAMIC_DIRECT_MEDIA",
                 "safe_proxy_proof": proof,
                 "nested_media": "NOT_REQUESTED", "redirects": "REFUSED"})
    catalog.save()
    return item


def download_one(catalog: Catalog, key: str, ytdlp: str, ffprobe: str, ffmpeg: str,
                 max_bytes: int = DEFAULT_FILE_BYTES, timeout: int = 180,
                 max_total_bytes: int = DEFAULT_TOTAL_BYTES, proxy: str | None = None,
                 format_id: str | None = None):
    item = catalog.data["items"][key]
    if item["status"] != "READY_TO_DOWNLOAD" or not item.get("format_id"):
        raise ValueError("Download requires explicitly selected previously probed video")
    if not 0 < max_bytes <= HARD_FILE_BYTES:
        raise ValueError("Per-file budget must be within the hard limit")
    if not 0 < max_total_bytes <= HARD_TOTAL_BYTES:
        raise ValueError("Aggregate budget must be within the hard limit")
    out = catalog.workdir / "downloads"
    out.mkdir(parents=True, exist_ok=True)
    used = sum(f.stat().st_size for f in out.iterdir() if f.is_file())
    remaining = max_total_bytes - used
    if remaining <= 0:
        item.update({"status": "DOWNLOAD_FAILED", "error_type": "AGGREGATE_BUDGET_EXHAUSTED"})
        catalog.save()
        return item
    effective_limit = min(max_bytes, HARD_FILE_BYTES, remaining)
    template = str(out / (key + ".%(ext)s"))
    selected_format = str(format_id or item["format_id"])
    if selected_format not in item.get("landscape_format_ids", [str(item["format_id"])]):
        raise ValueError("Format ID was not validated as landscape")
    _validate_public_url(item["url"])
    fmt = selected_format + "+bestaudio/" + selected_format
    # Watch both temporary and final outputs; provider Content-Length may be absent.
    cmd = [ytdlp, "--ignore-config", "--no-playlist", "--no-warnings", "--no-progress",
           "--max-filesize", str(effective_limit), "--socket-timeout", "15", "--retries", "0",
           "--fragment-retries", "0", "--no-overwrites", "-f", fmt, "-o", template]
    if proxy:
        cmd.extend(["--proxy", _validated_proxy(proxy)])
    cmd.append(item["url"])
    before = {f.resolve() for f in out.iterdir() if f.is_file()}
    proc = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                            env=_child_env(proxy), **_process_flags())
    begun = time.monotonic()
    budget_failed = False
    while proc.poll() is None:
        disk_bytes = sum(f.stat().st_size for f in out.iterdir() if f.is_file())
        if disk_bytes > max_total_bytes or time.monotonic() - begun > timeout:
            budget_failed = True
            terminate_process_tree(proc)
            break
        time.sleep(0.25)
    try:
        proc.wait(timeout=10)
    except subprocess.TimeoutExpired:
        terminate_process_tree(proc)
        proc.wait(timeout=10)
    if budget_failed:
        item.update({"status": "DOWNLOAD_FAILED", "error_type": "AGGREGATE_SIZE_OR_TIME_BUDGET"})
        catalog.save()
        return item
    result_code = proc.returncode
    matches = [f for f in out.glob(key + ".*") if f.is_file() and f.resolve() not in before
               and f.suffix.lower() not in (".part", ".ytdl", ".tmp")]
    if result_code or not matches:
        item.update({"status": "DOWNLOAD_FAILED", "error_type": "YTDLP_EXIT_" + str(result_code)})
        catalog.save()
        return item
    f = max(matches, key=lambda x: x.stat().st_size)
    if f.stat().st_size > effective_limit:
        item.update({"status": "DOWNLOAD_FAILED", "error_type": "FILE_SIZE_LIMIT"})
        catalog.save()
        return item
    try:
        result = qa_media(f, ffprobe, ffmpeg, timeout)
    except (RuntimeError, ValueError, subprocess.TimeoutExpired) as exc:
        item.update({"status": "QA_FAILED", "error_type": str(exc)[:160]})
        catalog.save()
        return item
    item.update({"status": "FULL_DECODE_PASS", "qa": result,
                 "local_file": f.relative_to(catalog.workdir).as_posix(), "reuse_rights": "UNKNOWN",
                 "download_bytes": f.stat().st_size, "download_elapsed_ms": round((time.monotonic() - begun) * 1000),
                 "selected_format_id": selected_format})
    catalog.save()
    return item


def gallery(catalog: Catalog) -> Path:
    cards = []
    for item in catalog.data["items"].values():
        if item.get("status") == "EXCLUDED":
            continue
        preview = ""
        local = item.get("local_file")
        if local and item.get("kind") == "video":
            preview = '<video controls preload="metadata" src="' + html.escape(local.replace("\\", "/"), quote=True) + '"></video>'
            frame = item.get("qa", {}).get("representative_frame")
            if frame:
                preview += '<img loading="lazy" alt="verified frame" src="' + html.escape(frame, quote=True) + '">'
        elif local and item.get("kind") == "image":
            preview = '<a href="' + html.escape(local.replace("\\", "/"), quote=True) + '" target="_blank"><img loading="lazy" src="' + html.escape(local.replace("\\", "/"), quote=True) + '"></a>'
        elif item.get("thumbnail"):
            preview = '<img loading="lazy" alt="search thumbnail; not content verified" src="' + html.escape(item["thumbnail"], quote=True) + '"><small>搜索缩略图，未验证真实素材</small>'
        details = [item.get("kind", ""), item.get("status", "")]
        qa = item.get("qa", {})
        if qa.get("display_width"):
            details.append(str(qa["display_width"]) + "×" + str(qa["display_height"]))
        elif qa.get("width"):
            details.append(str(qa["width"]) + "×" + str(qa["height"]))
        if item.get("duration"):
            details.append(str(item["duration"]) + " 秒")
        cards.append('<article><h3>' + html.escape(item.get("source_title") or item.get("title", "")) + '</h3>' + preview +
                     '<p>' + html.escape(item["site"]) + ' · ' + html.escape(" · ".join(details)) + '</p>' +
                     '<p>本地文件: ' + html.escape(local or "无") + '</p>' +
                     '<a target="_blank" rel="noopener" href="' + html.escape(item["url"], quote=True) + '">来源页面</a></article>')
    output = catalog.workdir / "gallery.html"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text('<!doctype html><html lang="zh"><meta charset="UTF-8"><title>CWS Media</title>'
                      '<style>body{font:16px system-ui;margin:24px;background:#f7f8fa;color:#18212b}'
                      'section{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px}'
                      'article{background:white;padding:15px;border-radius:10px;overflow-wrap:anywhere}video,img{width:100%;max-height:360px;object-fit:contain}</style>'
                      '<h1>CWS 本地素材</h1><section>' + "".join(cards) + '</section></html>', encoding="utf-8")
    return output


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="CWS MEDIA integration; search never auto-downloads")
    parser.add_argument("--workdir", type=Path, required=True, help="Ignored local workspace e.g. curious-world-studio/.local/media-pipeline")
    parser.add_argument("--ytdlp", default="yt-dlp")
    parser.add_argument("--ffprobe", default="ffprobe")
    parser.add_argument("--ffmpeg", default="ffmpeg")
    parser.add_argument("--proxy", help="Optional unauthenticated HTTP(S) proxy for external requests")
    sub = parser.add_subparsers(dest="action", required=True)
    s = sub.add_parser("search"); s.add_argument("--engine", choices=["searxng", "fourget"], required=True)
    s.add_argument("--kind", choices=["video", "image"], required=True); s.add_argument("--query", required=True)
    s.add_argument("--endpoint", required=True); s.add_argument("--page", type=int, default=1)
    i = sub.add_parser("import-json"); i.add_argument("path", type=Path); i.add_argument("--engine", choices=["searxng", "fourget"], required=True)
    i.add_argument("--kind", choices=["video", "image"], required=True)
    p = sub.add_parser("probe"); p.add_argument("--ids", nargs="+", required=True); p.add_argument("--timeout", type=int, default=60)
    d = sub.add_parser("download"); d.add_argument("--ids", nargs="+", required=True)
    d.add_argument("--max-bytes", type=int, default=DEFAULT_FILE_BYTES)
    d.add_argument("--max-total-bytes", type=int, default=DEFAULT_TOTAL_BYTES); d.add_argument("--timeout", type=int, default=180)
    d.add_argument("--format-id", help="Optional explicitly selected format ID validated during probe")
    di = sub.add_parser("download-image"); di.add_argument("--ids", nargs="+", required=True)
    di.add_argument("--max-bytes", type=int, default=DEFAULT_IMAGE_BYTES); di.add_argument("--timeout", type=int, default=30)
    sub.add_parser("gallery"); sub.add_parser("summary")
    args = parser.parse_args(argv)
    try:
        _validated_proxy(args.proxy)
        workdir = ensure_local_workdir(args.workdir)
    except ValueError as exc:
        parser.error(str(exc))
    c = Catalog(workdir)
    if args.action == "search":
        if not 1 <= args.page <= 2:
            parser.error("maximum 2 search pages per invocation")
        print("results:", search(c, args.engine, args.kind, args.query, args.endpoint, args.page, args.proxy))
    elif args.action == "import-json":
        c.add(parse_results(args.engine, args.kind, json.loads(args.path.read_text(encoding="utf-8"))))
        print("indexed:", len(c.data["items"]))
    elif args.action in ("probe", "download", "download-image"):
        ids = list(dict.fromkeys(args.ids))
        if len(ids) > 30:
            parser.error("at most 30 explicit ids per invocation")
        results = []
        for key in ids:
            if key not in c.data["items"]:
                c.event(args.action, "FAILED", id=key, error="NOT_IN_INDEX")
                print("NOT_IN_INDEX", key, file=sys.stderr)
                results.append({"id": key, "status": "FAILED", "reason": "NOT_IN_INDEX"})
                continue
            try:
                if args.action == "probe":
                    r = probe_one(c, key, args.ytdlp, args.timeout, args.proxy, args.ffprobe)
                    accepted = r["status"] == "READY_TO_DOWNLOAD"
                elif args.action == "download-image":
                    r = download_image_one(c, key, args.ffprobe, args.ffmpeg, args.max_bytes, args.timeout, args.proxy)
                    accepted = r["status"] == "IMAGE_DECODE_PASS"
                elif c.data["items"][key].get("kind") == "image":
                    r = download_image_one(c, key, args.ffprobe, args.ffmpeg, args.max_bytes,
                                           min(args.timeout, 30), args.proxy)
                    accepted = r["status"] == "IMAGE_DECODE_PASS"
                else:
                    r = download_one(c, key, args.ytdlp, args.ffprobe, args.ffmpeg, args.max_bytes,
                                     args.timeout, args.max_total_bytes, args.proxy, args.format_id)
                    accepted = r["status"] == "FULL_DECODE_PASS"
                print(key, r["status"])
                results.append({"id": key, "status": r["status"], "success": accepted})
            except (RuntimeError, ValueError, subprocess.TimeoutExpired, OSError) as exc:
                c.event(args.action, "FAILED", id=key, error=type(exc).__name__)
                print(key, "FAILED", type(exc).__name__, file=sys.stderr)
                results.append({"id": key, "status": "FAILED", "reason": type(exc).__name__, "success": False})
        failures = sum(not row.get("success", False) for row in results)
        print(json.dumps({"action": args.action, "success": len(results) - failures,
                          "failed": failures, "results": results}, ensure_ascii=False))
        return 1 if failures else 0
    elif args.action == "gallery":
        print(gallery(c))
    elif args.action == "summary":
        status = {}
        for v in c.data["items"].values():
            status[v["status"]] = status.get(v["status"], 0) + 1
        print(json.dumps({"items": len(c.data["items"]), "status": status, "queries": c.data["queries"]}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
