"""Small JSON CLI that orchestrates the existing CWS media pipeline."""
from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import os
import secrets
import signal
import shutil
import socket
import subprocess
import sys
import time
from pathlib import Path
from urllib.parse import urlsplit
from urllib.error import HTTPError, URLError
from urllib.request import ProxyHandler, Request, build_opener

import media_pipeline as pipeline

ROOT = Path(__file__).resolve().parents[1]
COMPOSE = Path(__file__).resolve().parent / "docker" / "docker-compose.yml"
MIN_FREE_MEMORY_MB = 1664  # 1.375 GiB container caps plus a 256 MiB host reserve.
MIN_FREE_DISK_MB = 2048
MAX_IDS = 30


class CliError(Exception):
    def __init__(self, code: str, message: str, exit_code: int = 2):
        super().__init__(message)
        self.code = code
        self.exit_code = exit_code


class JsonArgumentParser(argparse.ArgumentParser):
    def error(self, message):
        raise CliError("INVALID_ARGUMENT", message)


def emit(command: str, *, ok: bool, code: str, data=None, warnings=None) -> None:
    print(json.dumps({"schema_version": 1, "ok": ok, "command": command,
                      "code": code, "data": data or {}, "warnings": warnings or []},
                     ensure_ascii=False, separators=(",", ":")))


def failure_code(exc: Exception) -> str:
    if isinstance(exc, pipeline.safe_proxy.SafeProxyError):
        return exc.code
    if isinstance(exc, HTTPError):
        return "HTTP_" + str(exc.code)
    if isinstance(exc, URLError):
        return "NETWORK_ERROR"
    if isinstance(exc, ValueError):
        known = {"NON_PUBLIC_MEDIA_ADDRESS", "MEDIA_HOST_DNS_UNRESOLVED", "LOCAL_NETWORK_MEDIA_URL",
                 "NOT_SINGLE_VOD", "BELOW_MINIMUM_RESOLUTION", "INVALID_REDIRECT_URL",
                 "SAFE_DIRECT_REQUIRES_ELIGIBLE_VIDEO_ID", "SAFE_DIRECT_FILE_CAP_EXCEEDED",
                 "SAFE_DIRECT_TOTAL_CAP_EXCEEDED", "SAFE_DIRECT_TIMEOUT_OUT_OF_RANGE",
                 "SAFE_DIRECT_DIMENSIONS_REQUIRED", "SAFE_DIRECT_NOT_LANDSCAPE"}
        return str(exc) if str(exc) in known else "VALUE_ERROR"
    if isinstance(exc, subprocess.TimeoutExpired):
        return "TIMEOUT"
    return type(exc).__name__.upper()


def cached_result(workdir: Path, key: str, item: dict) -> dict | None:
    if item.get("status") not in {"FULL_DECODE_PASS", "IMAGE_DECODE_PASS"}:
        return None
    relative = item.get("local_file")
    expected = item.get("qa", {}).get("sha256")
    if not isinstance(relative, str) or not expected:
        return None
    local = (workdir / relative).resolve()
    if local == workdir or workdir not in local.parents:
        return {"id": key, "status": "FAILED", "code": "CACHE_PATH_OUTSIDE_LOCAL"}
    if not local.is_file():
        return None
    digest = hashlib.sha256()
    with local.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    actual = digest.hexdigest()
    if actual != expected:
        return {"id": key, "status": "FAILED", "code": "CACHE_HASH_MISMATCH"}
    return {"id": key, "status": "CACHED", "kind": item.get("kind"),
            "local_file": relative, "sha256": actual}


def free_memory_mb() -> int:
    if os.name == "nt":
        class MemoryStatus(ctypes.Structure):
            _fields_ = [("dwLength", ctypes.c_ulong), ("dwMemoryLoad", ctypes.c_ulong),
                        ("ullTotalPhys", ctypes.c_ulonglong), ("ullAvailPhys", ctypes.c_ulonglong),
                        ("ullTotalPageFile", ctypes.c_ulonglong), ("ullAvailPageFile", ctypes.c_ulonglong),
                        ("ullTotalVirtual", ctypes.c_ulonglong), ("ullAvailVirtual", ctypes.c_ulonglong),
                        ("ullAvailExtendedVirtual", ctypes.c_ulonglong)]
        status = MemoryStatus()
        status.dwLength = ctypes.sizeof(status)
        if not ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(status)):
            raise OSError("GlobalMemoryStatusEx failed")
        return int(status.ullAvailPhys // (1024 * 1024))
    if hasattr(os, "sysconf"):
        return int(os.sysconf("SC_AVPHYS_PAGES") * os.sysconf("SC_PAGE_SIZE") // (1024 * 1024))
    return 0


def free_disk_mb(path: Path) -> int:
    return int(shutil.disk_usage(path).free // (1024 * 1024))


def executable(value: str) -> str | None:
    found = shutil.which(value)
    if found:
        return found
    return str(Path(value).resolve()) if Path(value).is_file() else None


def default_ytdlp() -> str:
    local = os.environ.get("LOCALAPPDATA")
    if local:
        known = Path(local) / "curious-world-studio" / "tools" / "yt-dlp" / "2026.08.19" / "yt-dlp.exe"
        if known.is_file():
            return str(known)
    return "yt-dlp"


def tool_status(value: str, version_args: list[str]) -> dict:
    path = executable(value)
    if not path:
        return {"available": False, "version": None}
    try:
        result = subprocess.run([path, *version_args], capture_output=True, text=True, timeout=15,
                                creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        version = (result.stdout or result.stderr).strip().splitlines()
        return {"available": result.returncode == 0, "version": version[0][:120] if version else None}
    except (OSError, subprocess.TimeoutExpired):
        return {"available": False, "version": None}


def port_open(port: int) -> bool:
    with socket.socket() as sock:
        sock.settimeout(0.25)
        return sock.connect_ex(("127.0.0.1", port)) == 0


def http_service_health(endpoint: str, timeout: float = 3) -> dict:
    """Check the local web process, separately from TCP port availability."""
    request = Request(endpoint.rstrip("/") + "/", headers={"User-Agent": "CWS-MEDIA-OPERATIONS/1"})
    try:
        # Do not route loopback health checks through ambient Windows proxy settings.
        opener = build_opener(ProxyHandler({}))
        with opener.open(request, timeout=timeout) as response:
            status = int(response.status)
            has_body = bool(response.read(1))
        if status != 200:
            return {"ready": False, "status": "HTTP_" + str(status)}
        if not has_body:
            return {"ready": False, "status": "EMPTY_BODY"}
        return {"ready": True, "status": "HTTP_200"}
    except HTTPError as exc:
        return {"ready": False, "status": "HTTP_" + str(exc.code)}
    except (URLError, TimeoutError, OSError) as exc:
        reason = getattr(exc, "reason", exc)
        if isinstance(reason, TimeoutError):
            status = "TIMEOUT"
        elif isinstance(reason, ConnectionRefusedError):
            status = "CONNECTION_REFUSED"
        else:
            status = "CONNECTION_FAILED"
        return {"ready": False, "status": status}


def validate_docker_proxy(value: str | None) -> str | None:
    if not value:
        return None
    parsed = urlsplit(value)
    try:
        port = parsed.port
    except ValueError as exc:
        raise CliError("INVALID_DOCKER_PROXY", "proxy port is invalid") from exc
    if (parsed.scheme not in ("http", "https") or parsed.hostname != "host.docker.internal"
            or parsed.username or parsed.password or parsed.path not in ("", "/")
            or parsed.query or parsed.fragment or not port):
        raise CliError("INVALID_DOCKER_PROXY", "proxy must be unauthenticated host.docker.internal HTTP(S)")
    return value.rstrip("/")


class ComposeProject:
    def __init__(self, workdir: Path, docker_proxy: str | None = None):
        self.workdir = pipeline.ensure_local_workdir(workdir)
        token = hashlib.sha256(str(self.workdir).casefold().encode()).hexdigest()[:10]
        self.name = "cws-media-ops-" + token
        self.env_path = self.workdir / "runtime.env"
        self.docker_proxy = validate_docker_proxy(docker_proxy)
        self.started_here = False
        self.health_checks = {}

    def _base(self) -> list[str]:
        return ["docker", "compose", "--project-name", self.name,
                "--env-file", str(self.env_path), "-f", str(COMPOSE)]

    def _ensure_env(self) -> None:
        self.workdir.mkdir(parents=True, exist_ok=True)
        secret = None
        if self.env_path.exists():
            for line in self.env_path.read_text(encoding="utf-8").splitlines():
                if line.startswith("SEARXNG_SECRET="):
                    secret = line.partition("=")[2]
        if not secret:
            secret = secrets.token_urlsafe(32)
        proxy = self.docker_proxy or ""
        # This private local runtime file is ignored with the CWS .local tree.
        self.env_path.write_text(f"SEARXNG_SECRET={secret}\nCWS_DOCKER_HTTP_PROXY={proxy}\n", encoding="utf-8")

    def _run(self, *args: str, timeout: int = 90, check: bool = True) -> subprocess.CompletedProcess:
        try:
            result = subprocess.run(self._base() + list(args), capture_output=True, text=True,
                                    encoding="utf-8", errors="replace", timeout=timeout,
                                    creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        except FileNotFoundError as exc:
            raise CliError("DOCKER_NOT_FOUND", "Docker CLI is unavailable") from exc
        except subprocess.TimeoutExpired as exc:
            raise CliError("DOCKER_TIMEOUT", "Docker Compose command timed out") from exc
        if check and result.returncode:
            # Keep stdout/stderr out of the JSON: they can contain local paths or runtime data.
            raise CliError("DOCKER_COMPOSE_FAILED", f"compose command exit {result.returncode}")
        return result

    def running_services(self) -> set[str]:
        result = self._run("ps", "--services", "--status", "running", check=False)
        if result.returncode:
            raise CliError("DOCKER_COMPOSE_FAILED", f"compose ps exit {result.returncode}")
        return {line.strip() for line in result.stdout.splitlines() if line.strip()}

    def start(self) -> bool:
        docker = shutil.which("docker")
        if not docker:
            raise CliError("DOCKER_NOT_FOUND", "Docker CLI is unavailable")
        try:
            version = subprocess.run([docker, "info", "--format", "{{.ServerVersion}}"],
                                     capture_output=True, text=True, timeout=20,
                                     creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        except (subprocess.TimeoutExpired, OSError) as exc:
            raise CliError("DOCKER_DAEMON_UNAVAILABLE", type(exc).__name__) from exc
        if version.returncode or not version.stdout.strip():
            raise CliError("DOCKER_DAEMON_UNAVAILABLE", "Docker daemon did not respond")
        self._ensure_env()
        running = self.running_services()
        expected = {"searxng", "fourget", "valkey"}
        if running:
            if running == expected:
                if not port_open(18080) or not port_open(15050):
                    raise CliError("SEARCH_SERVICES_NOT_READY", "running containers do not expose both loopback ports", 1)
                self.health_checks = {
                    "searxng": http_service_health("http://127.0.0.1:18080"),
                    "fourget": http_service_health("http://127.0.0.1:15050"),
                }
                if all(check["ready"] for check in self.health_checks.values()):
                    return False
                details = ",".join(f"{name}={check['status']}" for name, check in self.health_checks.items())
                raise CliError("SEARCH_SERVICES_NOT_READY", details, 1)
            raise CliError("PROJECT_PARTIAL_RUNNING", "This project has a partial or unexpected running service set")
        if port_open(18080) or port_open(15050):
            raise CliError("PORT_IN_USE", "A required loopback search port is already occupied")
        mem, disk = free_memory_mb(), free_disk_mb(ROOT)
        if mem < MIN_FREE_MEMORY_MB:
            raise CliError("LOW_MEMORY", f"free memory {mem} MiB is below {MIN_FREE_MEMORY_MB} MiB")
        if disk < MIN_FREE_DISK_MB:
            raise CliError("LOW_DISK", f"free disk {disk} MiB is below {MIN_FREE_DISK_MB} MiB")
        self.started_here = True
        self._run("up", "-d", "--pull", "never", timeout=180)
        deadline = time.monotonic() + 110
        while time.monotonic() < deadline:
            services = self.running_services()
            if services == expected and port_open(18080) and port_open(15050):
                self.health_checks = {
                    "searxng": http_service_health("http://127.0.0.1:18080"),
                    "fourget": http_service_health("http://127.0.0.1:15050"),
                }
                if all(check["ready"] for check in self.health_checks.values()):
                    return True
            time.sleep(1)
        details = ",".join(f"{name}={check['status']}" for name, check in self.health_checks.items())
        raise CliError("SEARCH_SERVICES_NOT_READY", details or "Compose services did not become ready", 1)

    def stop_if_owned(self) -> None:
        if not self.started_here:
            return
        result = self._run("stop", "--timeout", "25", timeout=40, check=False)
        if result.returncode:
            raise CliError("COMPOSE_STOP_FAILED", f"compose stop exit {result.returncode}")
        if self.running_services():
            raise CliError("COMPOSE_STOP_INCOMPLETE", "owned project still has running services")
        deadline = time.monotonic() + 10
        while time.monotonic() < deadline and (port_open(18080) or port_open(15050)):
            time.sleep(0.25)
        if port_open(18080) or port_open(15050):
            raise CliError("COMPOSE_PORTS_STILL_OPEN", "a required loopback search port remains open")
        self.started_here = False


def build_parser() -> JsonArgumentParser:
    p = JsonArgumentParser(description="CWS local media operations CLI")
    p.add_argument("--workdir", type=Path, default=ROOT / ".local" / "media-operations")
    p.add_argument("--ytdlp", default=default_ytdlp())
    p.add_argument("--ffprobe", default="ffprobe")
    p.add_argument("--ffmpeg", default="ffmpeg")
    p.add_argument("--proxy", help="Optional process-level unauthenticated HTTP(S) media proxy")
    sub = p.add_subparsers(dest="command", required=True, parser_class=JsonArgumentParser)
    doctor = sub.add_parser("doctor")
    doctor.add_argument("--json", action="store_true", help="JSON is always emitted")
    d = sub.add_parser("discover")
    d.add_argument("--json", action="store_true", help="JSON is always emitted")
    d.add_argument("--query", required=True)
    d.add_argument("--kind", choices=("video", "image", "both"), default="both")
    d.add_argument("--docker-proxy", default=os.environ.get("CWS_DOCKER_HTTP_PROXY"),
                   help="Optional verified HTTP(S) proxy at host.docker.internal")
    d.add_argument("--allow-partial", action="store_true",
                   help="Return success when some requested searches succeed and others fail")
    c = sub.add_parser("catalog")
    c.add_argument("--json", action="store_true", help="JSON is always emitted")
    c.add_argument("--kind", choices=("video", "image"))
    c.add_argument("--limit", type=int, default=200)
    f = sub.add_parser("fetch")
    f.add_argument("--json", action="store_true", help="JSON is always emitted")
    f.add_argument("--ids", nargs="+", required=True)
    f.add_argument("--format-id", help="Optional format already validated as landscape")
    f.add_argument("--max-bytes", type=int, default=pipeline.DEFAULT_FILE_BYTES)
    f.add_argument("--max-total-bytes", type=int, default=pipeline.DEFAULT_TOTAL_BYTES)
    f.add_argument("--timeout", type=int, default=180)
    f.add_argument("--safe-direct", action="store_true",
                   help="Fetch one indexed HTTPS MP4/WebM via public-IP-pinned loopback CONNECT; redirects/manifests are refused")
    gallery_parser = sub.add_parser("gallery")
    gallery_parser.add_argument("--json", action="store_true", help="JSON is always emitted")
    return p


def dispatch(args) -> tuple[bool, str, dict, list[str], int]:
    command = args.command
    try:
        workdir = pipeline.ensure_local_workdir(args.workdir)
        proxy = pipeline._validated_proxy(args.proxy)
    except ValueError as exc:
        raise CliError("INVALID_CONFIGURATION", str(exc)) from exc
    if command == "doctor":
        memory, disk = free_memory_mb(), free_disk_mb(ROOT)
        tools = {"ytdlp": tool_status(args.ytdlp, ["--version"]),
                 "ffprobe": tool_status(args.ffprobe, ["-version"]),
                 "ffmpeg": tool_status(args.ffmpeg, ["-version"])}
        docker = shutil.which("docker")
        compose_version = None
        daemon_ok = False
        if docker:
            v = subprocess.run([docker, "compose", "version", "--short"], capture_output=True,
                               text=True, timeout=15, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
            compose_version = v.stdout.strip() if v.returncode == 0 else None
            d = subprocess.run([docker, "info", "--format", "{{.ServerVersion}}"], capture_output=True,
                               text=True, timeout=20, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
            daemon_ok = d.returncode == 0 and bool(d.stdout.strip())
        result = {"python": sys.version.split()[0], "executables": tools, "docker": bool(docker),
                  "compose_version": compose_version, "docker_daemon": daemon_ok,
                  "memory_free_mb": memory, "disk_free_mb": disk,
                  "minimums": {"memory_free_mb": MIN_FREE_MEMORY_MB, "disk_free_mb": MIN_FREE_DISK_MB},
                  "ports": {"searxng_127.0.0.1:18080_in_use": port_open(18080),
                            "fourget_127.0.0.1:15050_in_use": port_open(15050)},
                  "compose_template": str(COMPOSE.relative_to(ROOT.parent)).replace("\\", "/"),
                  "rights": "UNKNOWN_TEST_ONLY"}
        missing = [name for name, status in tools.items() if not status["available"]]
        warnings = ["missing: " + ",".join(missing)] if missing else []
        ready = not missing and bool(docker) and daemon_ok and compose_version is not None
        if ready and memory < MIN_FREE_MEMORY_MB:
            warnings.append(f"free memory {memory} MiB is below {MIN_FREE_MEMORY_MB} MiB")
            return False, "LOW_MEMORY", result, warnings, 2
        if ready and disk < MIN_FREE_DISK_MB:
            warnings.append(f"free disk {disk} MiB is below {MIN_FREE_DISK_MB} MiB")
            return False, "LOW_DISK", result, warnings, 2
        return ready, "READY" if ready else "DOCTOR_INCOMPLETE", result, warnings, 0 if ready else 2
    if command == "catalog":
        if args.limit < 1 or args.limit > 2000:
            raise CliError("INVALID_LIMIT", "limit must be between 1 and 2000")
        catalog = pipeline.Catalog(workdir)
        rows = list(catalog.data.get("items", {}).values())
        if args.kind:
            rows = [row for row in rows if row.get("kind") == args.kind]
        counts = {}
        for row in catalog.data.get("items", {}).values():
            status = row.get("status", "UNKNOWN")
            counts[status] = counts.get(status, 0) + 1
        return True, "OK", {"total": len(rows), "status_counts": counts, "items": rows[:args.limit],
                             "queries": catalog.data.get("queries", [])}, [], 0
    if command == "gallery":
        catalog = pipeline.Catalog(workdir)
        path = pipeline.gallery(catalog)
        return True, "OK", {"path": path.relative_to(workdir).as_posix(), "items": len(catalog.data.get("items", {}))}, [], 0
    if command == "fetch":
        ids = list(dict.fromkeys(args.ids))
        if not 1 <= len(ids) <= MAX_IDS:
            raise CliError("INVALID_ID_COUNT", f"provide 1 to {MAX_IDS} explicit IDs")
        if args.safe_direct and len(ids) != 1:
            raise CliError("SAFE_DIRECT_REQUIRES_ONE_ID", "safe-direct accepts exactly one selected catalog ID")
        if not 0 < args.max_bytes <= pipeline.HARD_FILE_BYTES or not 0 < args.max_total_bytes <= pipeline.HARD_TOTAL_BYTES:
            raise CliError("INVALID_BUDGET", "requested size budget exceeds the pipeline hard limit")
        catalog = pipeline.Catalog(workdir)
        results = []
        for key in ids:
            item = catalog.data.get("items", {}).get(key)
            if not item:
                results.append({"id": key, "status": "FAILED", "code": "NOT_IN_CATALOG"})
                continue
            # A safe-direct fetch must prove this invocation used the pinned
            # proxy path; an older ordinary download cache is not that proof.
            cached = None if args.safe_direct else cached_result(workdir, key, item)
            if cached is not None:
                results.append(cached)
                continue
            try:
                if args.safe_direct and item.get("kind") != "video":
                    raise ValueError("SAFE_DIRECT_REQUIRES_ELIGIBLE_VIDEO_ID")
                if item.get("kind") == "image":
                    result = pipeline.download_image_one(catalog, key, args.ffprobe, args.ffmpeg,
                                                         min(args.max_bytes, pipeline.DEFAULT_IMAGE_BYTES),
                                                         min(args.timeout, 30), proxy)
                    success = result.get("status") == "IMAGE_DECODE_PASS"
                elif args.safe_direct:
                    result = pipeline.download_safe_direct_candidate(
                        catalog, key, proxy, args.ffprobe, args.ffmpeg,
                        min(args.max_bytes, pipeline.SAFE_DIRECT_MAX_FILE_BYTES),
                        min(args.max_total_bytes, pipeline.SAFE_DIRECT_MAX_TOTAL_BYTES),
                        min(args.timeout, 60))
                    success = result.get("status") == "FULL_DECODE_PASS"
                else:
                    if item.get("status") != "READY_TO_DOWNLOAD":
                        result = pipeline.probe_one(catalog, key, args.ytdlp, min(args.timeout, 60), proxy, args.ffprobe)
                        item = result
                    if item.get("status") == "READY_TO_DOWNLOAD":
                        result = pipeline.download_one(catalog, key, args.ytdlp, args.ffprobe, args.ffmpeg,
                                                       args.max_bytes, args.timeout, args.max_total_bytes,
                                                       proxy, args.format_id)
                    else:
                        result = item
                    success = result.get("status") == "FULL_DECODE_PASS"
                results.append({"id": key, "status": result.get("status"), "success": success,
                                "local_file": result.get("local_file"), "qa": result.get("qa"),
                                "rights": result.get("reuse_rights", "UNKNOWN_TEST_ONLY")})
            except (RuntimeError, ValueError, OSError, subprocess.TimeoutExpired) as exc:
                catalog.event("fetch", "FAILED", id=key, error=type(exc).__name__)
                results.append({"id": key, "status": "FAILED", "code": failure_code(exc)})
        failed = [row for row in results if row["status"] == "FAILED" or row.get("success") is False]
        return not failed, "OK" if not failed else "FETCH_PARTIAL", {"results": results}, [], 0 if not failed else 1
    if command == "discover":
        docker_proxy = validate_docker_proxy(args.docker_proxy)
        catalog = pipeline.Catalog(workdir)
        project = ComposeProject(workdir, docker_proxy)
        owned_started = False
        warnings = []
        results = []
        kinds = ("video", "image") if args.kind == "both" else (args.kind,)
        ok = False
        code = "SEARCH_FAILED"
        exit_code = 1
        started_by_invocation = False
        cleanup = "NOT_REQUIRED"
        try:
            owned_started = project.start()
            started_by_invocation = owned_started
            endpoints = {"searxng": "http://127.0.0.1:18080", "fourget": "http://127.0.0.1:15050"}
            for engine, endpoint in endpoints.items():
                for kind in kinds:
                    try:
                        count = pipeline.search(catalog, engine, kind, args.query, endpoint, page=1, proxy=proxy)
                        query_record = (catalog.data.get("queries") or [{}])[-1]
                        upstream_errors = query_record.get("upstream_errors", [])
                        status = "OK" if count and not upstream_errors else (
                            "UPSTREAM_PARTIAL" if count else "EMPTY_RESULTS")
                        results.append({"engine": engine, "kind": kind, "count": count,
                                        "status": status,
                                        "code": None if status == "OK" else status,
                                        "upstream_errors": upstream_errors,
                                        "elapsed_ms": query_record.get("elapsed_ms")})
                        if status != "OK":
                            warnings.append({"engine": engine, "kind": kind, "error": status})
                    except Exception as exc:
                        error = failure_code(exc)
                        warnings.append({"engine": engine, "kind": kind, "error": error})
                        results.append({"engine": engine, "kind": kind, "count": 0, "status": "FAILED", "code": error})
            successes = sum(row["status"] == "OK" for row in results)
            failed = len(results) - successes
            if not failed and successes:
                code, ok, exit_code = "OK", True, 0
            elif successes and args.allow_partial:
                code, ok, exit_code = "PARTIAL_SEARCH_ALLOWED", True, 0
            elif successes:
                code, ok, exit_code = "PARTIAL_SEARCH", False, 1
            else:
                code, ok, exit_code = "SEARCH_FAILED", False, 1
        finally:
            if project.started_here:
                try:
                    project.stop_if_owned()
                    cleanup = "STOPPED_AND_VERIFIED"
                except CliError as exc:
                    cleanup = exc.code
                    warnings.append({"cleanup_error": exc.code})
                    ok, code, exit_code = False, "CLEANUP_FAILED", 1
        return ok, code, {"query": args.query, "requested_kinds": kinds,
                           "results": results, "catalog_items": len(catalog.data.get("items", {})),
                           "compose_project": project.name, "started_by_invocation": started_by_invocation,
                           "service_health": project.health_checks,
                           "cleanup": cleanup, "rights": "UNKNOWN_TEST_ONLY"}, warnings, exit_code
    raise CliError("UNKNOWN_COMMAND", "unsupported command")


def main(argv=None) -> int:
    command = "unknown"
    old_term = None
    if hasattr(signal, "SIGTERM"):
        old_term = signal.getsignal(signal.SIGTERM)

        def interrupt_on_term(*_):
            raise KeyboardInterrupt

        signal.signal(signal.SIGTERM, interrupt_on_term)
    try:
        args = build_parser().parse_args(argv)
        command = args.command
        ok, code, data, warnings, exit_code = dispatch(args)
        emit(command, ok=ok, code=code, data=data, warnings=warnings)
        return exit_code
    except CliError as exc:
        emit(command, ok=False, code=exc.code, data={"message": str(exc)})
        return exc.exit_code
    except KeyboardInterrupt:
        emit(command, ok=False, code="INTERRUPTED", data={})
        return 130
    except Exception as exc:
        emit(command, ok=False, code="UNEXPECTED_ERROR", data={"type": type(exc).__name__})
        return 1
    finally:
        if old_term is not None:
            signal.signal(signal.SIGTERM, old_term)


if __name__ == "__main__":
    raise SystemExit(main())
