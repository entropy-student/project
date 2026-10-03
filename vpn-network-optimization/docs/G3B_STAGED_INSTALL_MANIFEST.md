# G3-B Staged Install Manifest

Status: D3 repository-only render contract. This manifest defines non-secret render inputs, protected runtime destinations, activation order, and rollback checkpoints. It does not authorize live target access or mutation.

## Non-secret render inputs

Required non-secret metadata:

- VPS_HOST
- TARGET_EXPECTED_HOSTNAME
- WG_SERVER_ADDRESS
- WG_CLIENT_ADDRESS
- WG_SERVER_PUBLIC_KEY
- WG_CLIENT_PUBLIC_KEY
- WG_PORT
- WG_PERSISTENT_KEEPALIVE
- WG_MTU
- HY2_PORT
- HY2_LISTEN
- HY2_CERT_FILE
- HY2_KEY_FILE
- HY2_SNI
- HY2_RUNTIME_USER

Provider name/region may be recorded as Evidence but is not a template constant.

## Secret checkpoints

The following values must remain external until a separately authorized Secret Gate:

- WireGuard server private key.
- WireGuard client private key.
- HY2 auth password.
- HY2 certificate private key.
- HY2 certificate material.
- HY2 leaf certificate SHA-256 fingerprint.
- Any REALITY/VLESS UUID/private-key material.

Repository/render-stage sentinels:

- __EXTERNAL_WG_SERVER_PRIVATE_KEY_NOT_IN_REPOSITORY__
- __EXTERNAL_WG_CLIENT_PRIVATE_KEY_NOT_IN_REPOSITORY__
- __EXTERNAL_SECRET_NOT_IN_REPOSITORY__
- __TARGET_CERT_SHA256_AFTER_SECRET_CHECKPOINT__

No D3 renderer may substitute those sentinels.

## Rendered artifact contract

### Target-side

- WireGuard server skeleton
  - source: templates/wireguard/server.conf.template
  - future protected destination: /etc/wireguard/wg0.conf
  - D3 status: non-secret skeleton only; server private key sentinel remains.
- HY2 server skeleton
  - source: templates/hysteria2/server.yaml.template
  - future protected destination: /srv/apps/vpn-network-optimization/config/hysteria2-server.yaml
  - D3 status: non-secret paths/SNI rendered; auth sentinel remains.
- HY2 systemd unit
  - source: templates/systemd/hysteria2.service.template
  - future destination: /etc/systemd/system/hysteria2-vpn-network-optimization.service
  - D3 status: runtime-user substitution only; unit must not be enabled/started in D3.
- Project binary path
  - future destination: /usr/local/lib/vpn-network-optimization/hysteria
  - D3 status: path contract only; no download/install.

### Owner-side

- WireGuard client skeleton
  - source: templates/wireguard/client.conf.template
  - future protected local destination: Gate-specific; never Git.
  - D3 status: target host/public key metadata may render; client private key sentinel remains.
- Mihomo HY2 skeleton
  - source: templates/clash/mihomo-hy2.yaml.template
  - future protected local destination: Gate-specific; never the active profile by default.
  - D3 status: target IP/SNI rendered; auth/fingerprint sentinels remain.

## Activation order

A later live target deployment must preserve this order:

1. D2 target qualification PASS.
2. Create only project-owned target namespaces and protected directories.
3. Secret checkpoint: prove exact target identity and empty/approved Secret destinations.
4. Inject/restore approved Secrets without printing values.
5. Render protected WireGuard target config.
6. Validate WireGuard config syntax/permissions; do not switch Owner traffic yet.
7. Render protected HY2 target config and systemd unit.
8. Validate HY2 config/unit/binary; do not switch Owner traffic yet.
9. Apply only separately authorized forwarding/firewall/NAT changes required by the qualified target.
10. Start target-side candidate services in a bounded activation Gate.
11. Perform target health/read-back.
12. Perform bounded Owner-side candidate qualification.
13. Cut over only in a separately reviewed consequential Gate.
14. Keep source VPS healthy and distinguishable through the rollback window.
15. Decommission source only in a later Closeout Gate.

## Rollback checkpoint

Before step 13, rollback is simply no cutover: the source VPS remains authoritative.

After a bounded cutover but before Closeout, rollback means restoring the exact Owner client endpoint/profile/route state to the still-valid source VPS. Deleting target artifacts is optional cleanup and is not the rollback itself.

## D3 invariants

- No target/current VPS access.
- No Provider action.
- No package install/download.
- No service enable/start/stop.
- No sysctl/firewall/NAT/route mutation.
- No Secret file read.
- No populated private key/password/token in rendered fixture output.
- No current SFO3 identity constant in portable output.
- WireGuard IPv4 full coverage remains two split defaults, never a single 0.0.0.0/0.
- REALITY remains a cold candidate; D3 does not create a persistent REALITY service.
