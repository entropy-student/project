#!/usr/bin/env python3
"""Provision the isolated G2-A Hysteria 2 service from a stdin-only bundle.

The first two stdin lines are base64 source (transport bootstrap) and non-secret
JSON parameters. The remaining stdin bytes contain the allowlisted recovery
frame. Never print input, configuration contents, command stderr, or exceptions.
"""

import grp
import hashlib
import json
import os
import pwd
import re
import socket
import stat
import struct
import subprocess
import sys
import time
import shutil
import urllib.request

PHASE = "input"
UNIT = "hysteria2-vpn-network-optimization.service"
BINARY = "/usr/local/lib/vpn-network-optimization/hysteria"
CONFIG = "/srv/apps/vpn-network-optimization/config/hysteria2-server.yaml"
AUTH = "/srv/data/vpn-network-optimization/secrets/hy2-auth"
KEY = "/srv/data/vpn-network-optimization/secrets/server.key"
CERT = "/srv/data/vpn-network-optimization/secrets/server.crt"
UNIT_PATH = "/etc/systemd/system/" + UNIT
RELEASE_URL = "https://github.com/HyNetworks/hysteria/releases/download/app/v2.12.3/hysteria-linux-amd64"
RELEASE_SHA256 = "8c7a68a906998b747a0db87586e364f995fbfddb95693ae6e2fdb68a6e920d3e"


class ProvisionFailure(Exception):
    pass


def run(args, data=None, allowed=(0,)):
    p = subprocess.run(args, input=data, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if p.returncode not in allowed:
        raise ProvisionFailure()
    return p.stdout


def read_bundle(data):
    if len(data) > 131072 or not data.startswith(b"VPNHY2R1"):
        raise ProvisionFailure()
    pos = 8
    files = {}
    while pos < len(data):
        if pos + 5 > len(data):
            raise ProvisionFailure()
        name_len = data[pos]
        size = struct.unpack(">I", data[pos + 1:pos + 5])[0]
        pos += 5
        if name_len < 1 or name_len > 32 or size < 1 or size > 65536 or pos + name_len + size > len(data):
            raise ProvisionFailure()
        name = data[pos:pos + name_len].decode("utf-8")
        pos += name_len
        if name in files or name not in ("hy2-auth", "server.key", "server.crt"):
            raise ProvisionFailure()
        files[name] = data[pos:pos + size]
        pos += size
    if set(files) != {"hy2-auth", "server.key", "server.crt"}:
        raise ProvisionFailure()
    return files


def verify_target(params):
    if os.geteuid() != 0 or socket.gethostname() != params["expected_hostname"]:
        raise ProvisionFailure()
    addresses = json.loads(run(["ip", "-j", "-4", "addr", "show"]))
    ips = {a["local"] for link in addresses for a in link.get("addr_info", []) if a.get("scope") == "global"}
    if params["expected_ip"] not in ips:
        raise ProvisionFailure()
    region = urllib.request.urlopen("http://169.254.169.254/metadata/v1/region", timeout=3).read(64).decode().strip()
    if region != params["expected_region"]:
        raise ProvisionFailure()
    if run(["systemctl", "is-active", "wg-quick@wg0"]).strip() != b"active":
        raise ProvisionFailure()
    if run(["wg", "show", "wg0", "listen-port"]).strip() != b"51820":
        raise ProvisionFailure()
    routes = run(["ip", "-4", "route", "show"])
    if b"default via 24.199.112.1 dev eth0" not in routes or b"10.66.21.0/24 dev wg0" not in routes:
        raise ProvisionFailure()
    listeners = run(["ss", "-H", "-lun"]).decode().splitlines()
    if any(line.split() and line.split()[-2].endswith(":" + str(params["port"])) for line in listeners):
        raise ProvisionFailure()
    for path in ("/srv/data/vpn-network-optimization", "/srv/apps/vpn-network-optimization",
                 "/usr/local/lib/vpn-network-optimization", UNIT_PATH, AUTH, KEY, CERT, CONFIG):
        if os.path.lexists(path):
            raise ProvisionFailure()
    try:
        user = pwd.getpwnam("hy2-vpn")
        group = grp.getgrnam("hy2-vpn")
        if (user.pw_uid >= 1000 or user.pw_gid != group.gr_gid or user.pw_shell != "/usr/sbin/nologin" or
                user.pw_dir != "/nonexistent"):
            raise ProvisionFailure()
    except KeyError:
        try:
            pwd.getpwnam("hy2-vpn")
        except KeyError:
            pass
        else:
            raise ProvisionFailure()
        try:
            grp.getgrnam("hy2-vpn")
        except KeyError:
            pass
        else:
            raise ProvisionFailure()


def material_metadata(files, params):
    auth = files["hy2-auth"]
    key = files["server.key"]
    cert = files["server.crt"]
    if len(auth) != 64 or re.fullmatch(rb"[0-9a-f]{64}", auth) is None:
        raise ProvisionFailure()
    private_public = run(["openssl", "pkey", "-in", "/dev/stdin", "-pubout", "-outform", "DER"], key)
    public_text = run(["openssl", "pkey", "-pubin", "-inform", "DER", "-in", "/dev/stdin", "-text", "-noout"], private_public)
    if b"256 bit" not in public_text or (b"prime256v1" not in public_text and b"P-256" not in public_text):
        raise ProvisionFailure()
    cert_public_pem = run(["openssl", "x509", "-in", "/dev/stdin", "-pubkey", "-noout"], cert)
    cert_public = run(["openssl", "pkey", "-pubin", "-outform", "DER"], cert_public_pem)
    if private_public != cert_public:
        raise ProvisionFailure()
    san = run(["openssl", "x509", "-in", "/dev/stdin", "-noout", "-ext", "subjectAltName"], cert)
    if san.count(b"DNS:") != 1 or ("DNS:" + params["sni"]).encode() not in san:
        raise ProvisionFailure()
    run(["openssl", "x509", "-in", "/dev/stdin", "-noout", "-checkend", "0"], cert)
    der = run(["openssl", "x509", "-in", "/dev/stdin", "-outform", "DER"], cert)
    fingerprint = ":".join(f"{b:02X}" for b in hashlib.sha256(der).digest())
    return auth.decode("ascii"), fingerprint


def optional_state(args):
    if not shutil.which(args[0]):
        return None
    return hashlib.sha256(run(args)).hexdigest()


def system_snapshot():
    snapshot = {
        "routes": run(["ip", "-4", "route", "show"]),
        "default_route": run(["ip", "-4", "route", "show", "default"]),
        "wg_route": run(["ip", "-4", "route", "show", "10.66.21.0/24"]),
        "wg_active": run(["systemctl", "is-active", "wg-quick@wg0"]).strip(),
        "wg_port": run(["wg", "show", "wg0", "listen-port"]).strip(),
        "wg_link": run(["ip", "-o", "link", "show", "dev", "wg0"]),
        "forwarding": open("/proc/sys/net/ipv4/ip_forward", "rb").read().strip(),
        "nat": optional_state(["iptables-save", "-t", "nat"]),
        "firewall": optional_state(["iptables-save"]),
        "nft": optional_state(["nft", "list", "ruleset"]),
        "ufw": optional_state(["ufw", "status", "verbose"]),
        "qdisc": optional_state(["tc", "qdisc", "show", "dev", "eth0"]),
        "default_qdisc": run(["sysctl", "-n", "net.core.default_qdisc"]).strip(),
        "cc": run(["sysctl", "-n", "net.ipv4.tcp_congestion_control"]).strip(),
        "available_cc": run(["sysctl", "-n", "net.ipv4.tcp_available_congestion_control"]).strip(),
        "offload": optional_state(["ethtool", "-k", "eth0"]),
        "bbr_loaded": os.path.exists("/sys/module/tcp_bbr"),
        "available_kb": int(next(x.split()[1] for x in open("/proc/meminfo") if x.startswith("MemAvailable:"))),
    }
    return snapshot


def mkdir_owned(path, mode, uid, gid):
    os.mkdir(path, mode)
    os.chown(path, uid, gid)
    os.chmod(path, mode)


def ensure_shared_parent(path):
    if not os.path.lexists(path):
        mkdir_owned(path, 0o755, 0, grp.getgrnam("root").gr_gid)
        return
    info = os.stat(path, follow_symlinks=False)
    if (not stat.S_ISDIR(info.st_mode) or info.st_uid != 0 or info.st_gid != grp.getgrnam("root").gr_gid or
            stat.S_IMODE(info.st_mode) != 0o755):
        raise ProvisionFailure()


def write_new(path, data, mode, uid, gid):
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL | getattr(os, "O_NOFOLLOW", 0), 0o600)
    try:
        os.fchown(fd, uid, gid)
        os.fchmod(fd, mode)
        view = memoryview(data)
        while view:
            written = os.write(fd, view)
            view = view[written:]
        os.fsync(fd)
    except BaseException:
        os.close(fd)
        try:
            os.unlink(path)
        except OSError:
            pass
        raise
    else:
        os.close(fd)


def metadata(path):
    s = os.stat(path, follow_symlinks=False)
    return {"owner": pwd.getpwuid(s.st_uid).pw_name, "group": grp.getgrgid(s.st_gid).gr_name,
            "mode": format(stat.S_IMODE(s.st_mode), "04o"), "bytes": s.st_size}


def deploy(params, files, auth_text, fingerprint):
    global PHASE
    PHASE = "target-recheck"
    verify_target(params)
    before = system_snapshot()

    PHASE = "binary-download"
    with urllib.request.urlopen(RELEASE_URL, timeout=60) as response:
        binary = response.read(64 * 1024 * 1024 + 1)
    if len(binary) > 64 * 1024 * 1024 or hashlib.sha256(binary).hexdigest() != RELEASE_SHA256:
        raise ProvisionFailure()

    PHASE = "account-create"
    try:
        pwd.getpwnam("hy2-vpn")
    except KeyError:
        run(["useradd", "--system", "--user-group", "--no-create-home", "--home-dir", "/nonexistent",
             "--shell", "/usr/sbin/nologin", "hy2-vpn"])
    root_uid = 0
    root_gid = grp.getgrnam("root").gr_gid
    hy2_gid = grp.getgrnam("hy2-vpn").gr_gid

    PHASE = "directory-create"
    ensure_shared_parent("/srv/data")
    ensure_shared_parent("/srv/apps")
    mkdir_owned("/srv/data/vpn-network-optimization", 0o750, root_uid, hy2_gid)
    mkdir_owned("/srv/data/vpn-network-optimization/secrets", 0o750, root_uid, hy2_gid)
    mkdir_owned("/srv/apps/vpn-network-optimization", 0o755, root_uid, root_gid)
    mkdir_owned("/srv/apps/vpn-network-optimization/config", 0o750, root_uid, hy2_gid)
    mkdir_owned("/usr/local/lib/vpn-network-optimization", 0o755, root_uid, root_gid)

    PHASE = "config-render"
    listen = ":" + str(params["port"])
    config_text = (f'listen: "{listen}"\n\n'
                   'tls:\n'
                   f'  cert: "{CERT}"\n'
                   f'  key: "{KEY}"\n'
                   '  sniGuard: strict\n\n'
                   'auth:\n'
                   '  type: password\n'
                   f'  password: "{auth_text}"\n')
    import yaml
    parsed = yaml.safe_load(config_text)
    if parsed != {"listen": listen, "tls": {"cert": CERT, "key": KEY, "sniGuard": "strict"},
                  "auth": {"type": "password", "password": auth_text}}:
        raise ProvisionFailure()

    PHASE = "secret-and-binary-files"
    write_new(AUTH, files["hy2-auth"], 0o600, root_uid, root_gid)
    write_new(KEY, files["server.key"], 0o640, root_uid, hy2_gid)
    write_new(CERT, files["server.crt"], 0o644, root_uid, root_gid)
    write_new(CONFIG, config_text.encode("ascii"), 0o640, root_uid, hy2_gid)
    write_new(BINARY, binary, 0o755, root_uid, root_gid)
    if hashlib.sha256(open(BINARY, "rb").read()).hexdigest() != RELEASE_SHA256:
        raise ProvisionFailure()

    PHASE = "unit-render-and-verify"
    unit_text = ("[Unit]\n"
                 "Description=Hysteria 2 side-by-side candidate for vpn-network-optimization\n"
                 "Wants=network-online.target\n"
                 "After=network-online.target\n\n"
                 "[Service]\n"
                 "Type=simple\n"
                 "User=hy2-vpn\n"
                 "Group=hy2-vpn\n"
                 f"ExecStart={BINARY} server -c {CONFIG}\n"
                 "Restart=on-failure\n"
                 "RestartSec=5s\n"
                 "NoNewPrivileges=true\n"
                 "PrivateTmp=true\n"
                 "ProtectSystem=strict\n"
                 "ProtectHome=true\n"
                 "StandardOutput=null\n"
                 "StandardError=null\n\n"
                 "[Install]\n"
                 "WantedBy=multi-user.target\n")
    write_new(UNIT_PATH, unit_text.encode("ascii"), 0o644, root_uid, root_gid)
    run([BINARY, "server", "--help"])
    run(["systemd-analyze", "verify", UNIT_PATH])

    PHASE = "systemd-start"
    run(["systemctl", "daemon-reload"])
    run(["systemctl", "enable", UNIT])
    run(["systemctl", "start", UNIT])
    for _ in range(20):
        state = run(["systemctl", "is-active", UNIT], allowed=(0, 3, 4)).strip()
        if state == b"active":
            break
        time.sleep(0.25)
    if state != b"active":
        raise ProvisionFailure()

    PHASE = "health-readback"
    pid = int(run(["systemctl", "show", "-p", "MainPID", "--value", UNIT]).strip())
    if pid <= 1 or os.path.realpath(f"/proc/{pid}/exe") != BINARY:
        raise ProvisionFailure()
    socket_lines = run(["ss", "-H", "-lunp"]).decode().splitlines()
    port_lines = [line for line in socket_lines
                  if len(line.split()) >= 4 and line.split()[3].endswith(":" + str(params["port"]))]
    if not port_lines or any(f"pid={pid}," not in line for line in port_lines):
        raise ProvisionFailure()
    if not any(len(line.split()) >= 4 and line.split()[3].endswith(":51820") for line in socket_lines):
        raise ProvisionFailure()
    process_sockets = run(["ss", "-H", "-lntup"]).decode().splitlines()
    owned_ports = set()
    for line in process_sockets:
        if f"pid={pid}," in line:
            fields = line.split()
            if len(fields) < 5:
                raise ProvisionFailure()
            owned_ports.add(int(fields[4].rsplit(":", 1)[1]))
    if owned_ports != {params["port"]}:
        raise ProvisionFailure()

    PHASE = "runtime-permission-check"
    for path in (KEY, CERT, CONFIG):
        run(["runuser", "-u", "hy2-vpn", "--", "test", "-r", path])
    if subprocess.run(["runuser", "-u", "hy2-vpn", "--", "test", "-r", AUTH],
                      stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0:
        raise ProvisionFailure()
    if open(AUTH, "rb").read() != files["hy2-auth"]:
        raise ProvisionFailure()

    PHASE = "regression-check"
    after = system_snapshot()
    for key in ("routes", "default_route", "wg_route", "wg_active", "wg_port", "wg_link", "forwarding",
                "nat", "firewall", "nft", "ufw", "qdisc", "default_qdisc", "cc", "available_cc",
                "offload", "bbr_loaded"):
        if before[key] != after[key]:
            raise ProvisionFailure()
    if after["wg_active"] != b"active" or after["wg_port"] != b"51820":
        raise ProvisionFailure()

    user = pwd.getpwnam("hy2-vpn")
    if user.pw_shell != "/usr/sbin/nologin" or user.pw_dir != "/nonexistent":
        raise ProvisionFailure()
    rss_kb = int(next(x.split()[1] for x in open(f"/proc/{pid}/status") if x.startswith("VmRSS:")))
    return {
        "TARGET_HOST_VERIFIED": "YES",
        "HY2_BINARY_VERSION": "v2.12.3",
        "HY2_BINARY_SHA256_VERIFIED": "YES",
        "SERVER_YAML_PARSE": "PASS",
        "SYSTEMD_UNIT_VERIFY": "PASS",
        "HY2_SERVICE_ACTIVE": "YES",
        "HY2_SERVICE_ENABLED": "YES",
        "HY2_UDP_8443_LISTENING": "YES",
        "HY2_RSS_KB": rss_kb,
        "MEM_AVAILABLE_DELTA_KB": after["available_kb"] - before["available_kb"],
        "WG_ACTIVE": "YES",
        "WG_51820_LISTENING": "YES",
        "ROUTES_UNCHANGED": "YES",
        "NAT_FIREWALL_UNCHANGED": "YES",
        "LIVE_SYSTEM_TUNING_CHANGED": "NO",
        "HY2_AUTH_FILE": metadata(AUTH),
        "TLS_KEY_FILE": metadata(KEY),
        "TLS_CERT_FILE": metadata(CERT),
        "RUNTIME_CONFIG_FILE": metadata(CONFIG),
        "SYSTEMD_UNIT_FILE": metadata(UNIT_PATH),
        "CERT_SHA256_FINGERPRINT": fingerprint,
        "SECRET_VALUES_EMITTED": 0,
        "CLIENT_HANDSHAKE_TESTED": "NO",
    }


def main():
    global PHASE
    params = json.loads(sys.stdin.buffer.readline(4096))
    if (params.get("port") != 8443 or params.get("sni") != "hy2.sfo3-a.invalid" or
            not re.fullmatch(r"[0-9.]{7,15}", params.get("expected_ip", "")) or
            params.get("expected_region") != "sfo3"):
        raise ProvisionFailure()
    PHASE = "input-bundle"
    frame = sys.stdin.buffer.read(131073)
    files = read_bundle(frame)
    PHASE = "material-validation"
    auth_text, fingerprint = material_metadata(files, params)
    PHASE = "target-validation"
    verify_target(params)
    result = deploy(params, files, auth_text, fingerprint)
    PHASE = "complete"
    sys.stdout.write(json.dumps(result, separators=(",", ":")) + "\n")
    sys.stdout.flush()


try:
    main()
except BaseException:
    sys.stdout.write(json.dumps({"DEPLOY_STATUS": "FAILED", "FAIL_PHASE": PHASE}, separators=(",", ":")) + "\n")
    sys.stdout.flush()
    sys.exit(1)
