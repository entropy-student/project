# G3-B VPS Migration Package

> Status: D1 repository-only design. This document defines the migration unit and acceptance boundary; it does not authorize provisioning, Secret movement, service activation, cutover, or decommission.

## Migration unit

### Reconstructible repository assets

- `config/variables.env.example` — non-secret deployment/migration metadata schema.
- `templates/wireguard/server.conf.template` — WireGuard server template.
- `templates/wireguard/client.conf.template` — Windows/client template using the accepted split-default IPv4 baseline.
- `templates/hysteria2/server.yaml.template` — HY2 server template.
- `templates/systemd/hysteria2.service.template` — HY2 service template.
- `templates/clash/mihomo-hy2.yaml.template` — non-secret HY2 client template.
- `scripts/preflight-linux.sh` — target-host read-only inventory.
- `scripts/health-check.sh` — post-deploy read-only health check.
- `scripts/migration-reinstall.sh` — migration plan / later project-local target bootstrap.
- `scripts/rollback-uninstall.sh` — HY2-only uninstall helper; this is not the full migration rollback.

### Existing-instance evidence, not portable templates

- `config/clash/sfo3-a-hy2.yaml` is the current SFO3 instance fragment and remains evidence/current-instance configuration. It must not be copied as the target migration template.
- Current VPS public IP, hostname, physical WLAN IP/gateway/ifIndex, and observed certificate fingerprint are environment evidence, not migration constants.

### Secret/recovery material — never in Git

The package records only these classes and expected protected destinations:

- WireGuard server private key.
- WireGuard client private key.
- HY2 authentication secret.
- HY2 certificate private key.
- HY2 certificate.
- Any REALITY/VLESS UUID/private-key material required by a later cold activation Gate.

Secret values, private-key bytes, populated runtime configs, DPAPI recovery blobs, and decrypted recovery payloads are outside the repository package.

## Migration identity inputs

A later migration Gate must freeze:

- `SOURCE_VPS_HOST`
- `TARGET_VPS_HOST`
- `TARGET_EXPECTED_HOSTNAME`
- target Provider/region metadata
- target public IPv4
- target WAN interface discovered at runtime
- WireGuard interface/addresses/port
- HY2 port
- target-specific `HY2_SNI`
- exact source and target host-key trust metadata

Source and target identities must remain distinguishable throughout rehearsal, cutover, rollback, and closeout.

## Secret transfer boundary

Secret movement is a separate Owner-authorized Gate.

Required sequence:

1. prove target identity and protected Secret destination;
2. create/verify target protected directories and runtime reader permissions;
3. transfer or restore only the approved Secret classes through a protected channel;
4. validate format/access without printing values or hashes;
5. render protected runtime configuration on the target;
6. validate service configuration before enablement;
7. retain source recovery capability until target health and rollback tests pass.

Unknown/non-empty target Secret locations fail closed. No overwrite is implicit.

## Target deployment sequence

A later live migration Gate should proceed in this order:

1. **Target read-only preflight** — hostname, OS, WAN/default route, free ports, forwarding/firewall/NAT, resources, systemd availability.
2. **Project namespace bootstrap** — only project-owned app/data/backup paths.
3. **Template render** — non-secret metadata first; protected Secret injection only after the Secret checkpoint.
4. **WireGuard target qualification** — config parse/start/port/route checks without switching the Owner client.
5. **HY2 target qualification** — config parse/service/UDP 8443 checks without changing the production client.
6. **REALITY cold-readiness check** — preserve TCP/443 availability and required binary/template metadata; do not create a persistent listener merely to call migration complete.
7. **Target health read-back** — process/service/listener/route/firewall identity checks.
8. **Owner-side bounded candidate test** — separate Gate; no silent default switch.
9. **Cutover** — only after target health and rollback are both proven.
10. **Old VPS retention** — keep the old working VPS available until the defined rollback window closes.

## Rollback model

Full migration rollback means **return traffic/control to the still-valid source VPS**, not merely run `rollback-uninstall.sh`.

- Before cutover: rollback is simply “do not cut over”; source remains authoritative.
- During staged cutover: revert the exact Owner client endpoint/profile/route changes to the source identity.
- After cutover but before closeout: source VPS remains intact and health-checked so rollback can restore service without rebuilding it.
- `rollback-uninstall.sh` may remove project-owned HY2 artifacts from a target only after rollback identity is proven; it must not delete source recovery or WireGuard.
- Source VPS deletion/decommission is a later Closeout Gate, never part of migration PASS.

## Acceptance boundary for a future rehearsal

A fresh-target rehearsal cannot PASS until all are reviewable:

- exact target hostname/public-IP/provider identity;
- project paths and runtime versions;
- WireGuard target service/listener/route health;
- HY2 target service/listener health;
- Secret compatibility/access without value exposure;
- Owner-side client compatibility;
- source VPS remains healthy and distinguishable;
- rollback-to-source procedure is executable and validated;
- no unrelated Shared Infra regression;
- exact resource/cleanup read-back.

## D1 non-goals

- no Provider purchase;
- no target VPS creation;
- no Secret transfer or rotation;
- no service enablement;
- no traffic switch;
- no source VPS mutation or deletion;
- no REALITY persistence decision;
- no G4 performance conclusion.
