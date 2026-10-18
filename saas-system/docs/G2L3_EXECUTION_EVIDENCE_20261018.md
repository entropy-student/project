# G2L3 Local Web and Affiliate Targeted Recovery — Execution Evidence

- Gate ID: `SAAS-G2L3-LOCAL-WEB-AFFILIATE-TARGETED-RECOVERY-20261018`
- Repository / branch: `entropy-student/project` / `main`
- Execution date: 2026-10-18 (Windows local timezone Asia/Singapore, UTC+08:00)
- Executor result: `PARTIAL / RETURN TO REVIEWER`
- Gate result: current direct Web paths respond; Affiliate remains unresolved.
- Handling: sanitized. No credentials, cookies, response bodies, account identifiers, or environment-variable values are included.

## Scope and target proof

- Target source HEAD: `e88e259b974f883913f68ac74a9b8377765d005d`; worktree was clean at the 04:26 UTC preflight.
- Local Windows target was the existing `saasvh-e88e259` Docker project and its existing Web/Postgres/Redis containers.
- This round performed read-only host/container HTTP probes, health/resource/log sampling, and a single targeted Affiliate browser observation. G2L2-accepted login, Dashboard, and Admin results were not re-tested.
- No installation, download, build, container restart/stop, database mutation, proxy/network setting change, cleanup, or action against another project was performed.

## Existing image, container, volume, and network identities

- Web: `saasvh-e88e259-web-1`, ID prefix `89c2efdb988b`; running, restart count 0, Docker OOMKilled false.
- Web tag `saasvh-e88e259-web` resolved to the running container's image ID `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef`.
- Compose image label was `sha256:88bb7e47c5fe94421967b98ade9e594e3faa7ebbddc373b9a23b8ab67597ddc4`. This is the known historical metadata difference described by the Gate, not evidence of image replacement.
- Postgres: ID prefix `ec10d96cf352`, healthy, restart count 0, OOMKilled false. Redis: ID prefix `35b25a5e68bf`, healthy, restart count 0, OOMKilled false.
- Existing project network: `saasvh-e88e259_default`. Existing mounts observed: Web volume `saasvh-e88e259_demo_state`, Postgres volume `saasvh-e88e259_preview_data`, and the existing Docker volume mounted at Redis `/data`. No volume contents were read.
- Preflight non-target snapshot: 0 running, 1 created, 34 exited. No Docker lifecycle/resource mutation was issued by this Executor; a post-run non-target inventory was not taken, so external workload delta is `UNKNOWN`.

## Historical HTTP 000 and current host/container comparison

The prior G2L2 evidence reports at least three host requests after 04:00 UTC returned status `000` with an empty response. That record does not include `curl.exe` exit codes or a raw failure class. Therefore the historical curl failure class is `UNKNOWN`; it is not possible to distinguish a curl empty-reply code from another failure based on that evidence.

The current Windows process environment has an HTTP proxy variable configured (value withheld). Windows Internet Settings reported system proxy disabled, auto-detect disabled, and no PAC URL configured. No proxy setting was changed. Since G2L2's recorded request did not document `--noproxy '*'`, proxy-path involvement is possible but unproven.

Windows listener for TCP 3003: `com.docker.backend`.

| Current request | curl exit / result | Connect | TTFB | Total |
|---|---:|---:|---:|---:|
| Host `curl.exe --noproxy '*'`, sample 1 | exit 0, HTTP 200 | 0.000794 s | 5.053256 s | 5.085036 s |
| Host `curl.exe --noproxy '*'`, sample 2 | exit 0, HTTP 200 | 0.001035 s | 0.259033 s | 0.304484 s |
| Existing Web container Node GET to `127.0.0.1:3003/` | HTTP 200 | — | 0.593 s | — |
| Host `curl.exe --noproxy '*'`, sample 3 | exit 0, HTTP 200 | 0.001133 s | 0.309532 s | 0.330094 s |
| Final host sample around 04:30 UTC | HTTP 200 | 0.000784 s | 0.209248 s | 0.227270 s |

Both independent paths succeeded, so the Gate's persistent dual-path no-response condition was not met. Web-only restart decision: `NO — restart preconditions not met`. Restart action count: 0. The container remains running.

## Web, database, Redis, Worker, and Affiliate results

- Web process was responsive on both host and in-container paths. Web has no Docker healthcheck. Postgres and Redis reported healthy.
- G2L2 Dashboard/Admin read UI result: `PASS / accepted in G2L2`; not repeated per this Gate. See [G2L2 execution evidence](https://github.com/entropy-student/project/blob/main/saas-system/docs/G2L2_EXECUTION_EVIDENCE_20261018.md).
- A desktop browser viewport of at least 1024 px was already authenticated (account identifier withheld). Direct navigation to `/account/affiliate` showed a blank page with no visible text. Reload then returned the browser to `/`; root body text length was 923 characters.
- Browser error evidence: 1 generic console error observed; sanitized class `UNKNOWN`; no matching known TypeError/tRPC/auth/router marker; component name and top two stack frames `NOT_CAPTURED`. The captured CDP window had no Affiliate-specific response or loading-failed event.
- Session-valid visual indicator: `true` (signed-in account menu was visible; account data withheld). Affiliate HTTP/query status, `isLoading`, `isError`, `eligible`, and `canActivate`: `UNKNOWN / NOT_CAPTURED`. No hidden auth/API endpoint, cookie, response body, or user record was inspected. Affiliate result: `UNRESOLVED`.
- Worker: no standalone Worker container was present. The recent 10-minute Web log sample had 1,140 lines, 0 worker-start markers, and 0 worker-error markers. This does not prove queue consumption or task success; Worker functionality remains `UNVERIFIED`.
- Conditional restart marker flags: `auth-secret=NOT_CHECKED`, `harness-preview-seeded=NOT_CHECKED`, `harness-admin-demo-v1=NOT_CHECKED`. Restart branch was not entered, so no marker was read. Startup DB-push/seed classification: `NOT_APPLICABLE — no restart or startup was triggered`.

## Resource and OOM evidence

| Sample (UTC) | Host available RAM | Web CPU | Web memory | OOM evidence |
|---|---:|---:|---:|---|
| 04:26 preflight | 2.15 GB | — | — | Docker OOMKilled false |
| 04:29:27 | 1.4 GB | 388.84% | 5.77 GiB / 7.397 GiB | Docker OOMKilled false; Windows System event 2004 count 0 in previous 10 min |
| ~04:30:10 (12:30 local) | 1,795 MB | 113.08% | 5.733 GiB / 7.397 GiB | Docker OOMKilled false; Windows System event 2004 count 0 in previous 10 min |

The earlier high CPU sample declined in the final sample; host available RAM increased, while Web memory remained near 5.7 GiB. This is recorded as resource pressure, not an observed OOM. The samples do not establish a cause for historical HTTP 000 or the Affiliate blank page.

## Change, payment, rollback, and Reviewer relay

- Exact Web-only restart action count: 0. No database push/seed, source/image change, install/download/build, Docker/volume/network change, or action against another project.
- Payment/provider action count: 0. No Stripe or other provider request or transaction.
- Rollback: none required. Existing Web/Postgres/Redis containers, image, network, and volumes remain in place; Web is running and host no-proxy HTTP returns 200.
- `OWNER_RELAY_NONE`: no Owner action requested.
- `EXECUTOR_RESULT`: current Web route is reachable without proxy and from inside Web; historical HTTP 000 root cause remains `UNKNOWN`; Affiliate stays blank/unresolved with HTTP/query and eligibility booleans not captured; Worker remains `UNVERIFIED`.
- Reviewer request: review the unresolved Affiliate route and determine the next smallest diagnostic/fix Gate. Execution stops here; no deployment-stage continuation.
