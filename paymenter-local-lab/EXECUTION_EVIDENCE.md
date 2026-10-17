# EXECUTION_EVIDENCE — Paymenter Local Lab (append-only)
## 2026-10-17 Reviewer source discovery / no Owner-host writes
AUTHORIZED_GATE: PAYMENTER-G1-LOCAL-DOCKER-ZH-PREVIEW-20261017
PROVENANCE: DIRECT_READBACK GitHub + official docs only
- Paymenter/Paymenter master source commit: 1d4c0b92dac0f93f28998b04c4c0e282bf436177
- Official compose: docker-compose.example.yml includes database (MariaDB), cache (Redis), paymenter (PHP + Nginx); upstream host port 80 would be public unless rewritten. Local launcher rewrites to 127.0.0.1:8187 and uses a separate project name.
- Official config/app.php includes zh and lang/zh directory exists.
- app:init takes company name + URL. app:user:create takes names/email/password/role. DatabaseSeeder creates admin role; User model supports role_id and hashed password.
- Docker launcher prepared in this repository. *No local container, account, or browser flow has yet been executed from this ChatGPT session.*
CURRENT_STATUS: PREPARED_NOT_EXECUTED
EXPECTED_OWNER_RUNTIME_PROOF: host identity, docker ps/inspect, port, app/UI, login, Chinese visual, evidence without credentials.
ANOMALIES: Real Windows current state UNKNOWN until Codex executes on actual machine. Third-party Referrals excluded.
ROLLBACK: no Owner-host changes by current Reviewer; future exact project-only docker compose stop (no -v).
