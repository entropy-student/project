# G2L3 Local Web and Affiliate Targeted Recovery — Execution Evidence

- Gate: `G2L3_LOCAL_WEB_AFFILIATE_TARGETED_RECOVERY_GATE_20261018.md`
- Repository / branch: `entropy-student/project` / `main`
- Execution date: 2026-10-18 (local Windows timezone: Asia/Singapore, UTC+08:00)
- Status: `PARTIAL — CURRENT WEB PATH RESPONDS; AFFILIATE RESULT UNKNOWN/UNRESOLVED`
- Handling: sanitized. No credentials, cookies, response bodies, account identifiers, or environment-variable values included.

## Scope

Read-only diagnostics of the existing fixed Velobase preview and the Affiliate route. No installation, download, build, container restart, database mutation, proxy/network setting change, or change to another project was performed. Dashboard/Admin were accepted in the G2L2 review and were not re-tested. No payment provider or Stripe request was made; no payment action occurred.

## Deployment identity and workload

- Fixed source checkout: `e88e259b974f883913f68ac74a9b8377765d005d`; checkout was clean at the 04:26 UTC preflight.
- Existing Web container: `saasvh-e88e259-web-1`, ID prefix `89c2efdb988b`, running; restart count 0; Docker OOMKilled false.
- Web image tag `saasvh-e88e259-web` resolved to image ID/digest `sha256:9ab2468decb483e8941b18ce99570a1cf51677b3bb4c0c11024c1d6ea79364ef`.
- Compose image label was `sha256:88bb7e47c5fe94421967b98ade9e594e3faa7ebbddc373b9a23b8ab67597ddc4`; this metadata differs from the resolved image digest and, as the Gate notes, is historical metadata rather than evidence of image substitution.
- Existing Postgres container ID prefix `ec10d96cf352`: healthy, restart count 0, OOMKilled false. Existing Redis ID prefix `35b25a5e68bf`: healthy, restart count 0, OOMKilled false.
- Existing network: `saasvh-e88e259_default`. Existing persistent volumes observed: `saasvh-e88e259_demo_state` (Web), `saasvh-e88e259_preview_data` (Postgres), and the existing Docker volume mounted at Redis `/data`. No volume contents or secret values were read.
- All three target containers remained running. Non-target container counts during both pre- and post-samples: running 0, created 1, exited 34. No Docker lifecycle or resource mutation was performed.

## HTTP, proxy, and port-forward diagnosis

The Windows listener for TCP 3003 was `com.docker.backend`. The current process environment has an HTTP proxy variable configured (value withheld); Windows Internet Settings reported system proxy disabled and auto-detect disabled, with no PAC URL configured. No proxy setting was changed.

| Path and sample | Result | Connect | TTFB | Total |
|---|---:|---:|---:|---:|
| Windows host, `curl.exe --noproxy '*'`, 1 | HTTP 200 | 0.000794 s | 5.053256 s | 5.085036 s |
| Windows host, `curl.exe --noproxy '*'`, 2 | HTTP 200 | 0.001035 s | 0.259033 s | 0.304484 s |
| Existing Web container, Node GET to `127.0.0.1:3003/` | HTTP 200 | — | 0.593 s | — |
| Windows host, `curl.exe --noproxy '*'`, 3 | HTTP 200 | 0.001133 s | 0.309532 s | 0.330094 s |
| Windows host, final sample around 04:30 UTC | HTTP 200 | 0.000784 s | 0.209248 s | 0.227270 s |

The no-proxy Windows requests and the in-container request both succeeded, so the Gate’s persistent dual-path no-response condition was not met. No Web restart was authorized by those observations and none was executed (restart count/action count: 0).

**Historical HTTP 000 cause: UNKNOWN.** The previous G2L2 probe did not bypass the current process-level HTTP proxy variable, so proxy-path involvement is possible, but there is no evidence proving that it caused the earlier result. Current direct host access, Docker port forwarding, and in-container Web response all work.

## Affiliate and Worker

- A desktop browser session at a viewport of at least 1024 px was already authenticated. The account identifier is intentionally omitted.
- Direct navigation to `/account/affiliate` rendered a blank page with no visible text. Reload then returned the browser to `/` (home-page body text length observed: 923 characters).
- A generic browser console error was present, but its sanitized class did not identify a known application/auth/router error. The captured CDP window contained no Affiliate-specific response or loading-failed event. No Affiliate response body, hidden auth endpoint, cookie, or user record was inspected.
- Affiliate HTTP/query status and the UI booleans `isLoading`, `isError`, `eligible`, and `canActivate`: `UNKNOWN / NOT CAPTURED`. This evidence cannot distinguish a route/render defect from an unobserved client-side query issue.
- Affiliate outcome: `UNRESOLVED`; no application state was changed.
- The Web container’s recent 10-minute log sample had 1,140 lines; sanitized counts were 9 Affiliate-related lines, 0 worker-start markers, 0 worker-error markers, and 0 OOM-pattern matches. No standalone Worker container was present. A dedicated Worker health signal was not captured; Worker status is `UNKNOWN`.
- No auth-secret or seed marker file was read. Those Gate checks apply to the conditional restart branch, which was not entered.

## Resource and stability samples

All timestamps below are UTC; the final PowerShell sample was run at approximately 04:30 UTC (12:30 local, UTC+08:00).

| Sample | Host available RAM | Web CPU | Web memory | OOM evidence |
|---|---:|---:|---:|---|
| 04:26 preflight | 2.15 GB | — | — | Docker OOMKilled false |
| 04:29:27 | 1.4 GB | 388.84% | 5.77 GiB / 7.397 GiB | Docker OOMKilled false; 0 Windows System event 2004 in prior 10 min |
| ~04:30:10 | 1,795 MB | 113.08% | 5.733 GiB / 7.397 GiB | Docker OOMKilled false; 0 Windows System event 2004 in prior 10 min |

The CPU sample declined between the last two observations, and host available RAM increased in the final sample. The elevated earlier CPU/memory readings are recorded as resource pressure; no OOM or Windows resource-exhaustion event was observed. They do not establish the cause of the historical HTTP 000 or the Affiliate blank page.

## Changes, rollback, and handoff

- Web restart: not performed (0).
- Docker/image/source rebuild, install, database push/seed, proxy/network changes, volume changes, or other-project changes: none.
- Payment/Stripe/provider access or transactions: none (0).
- Rollback: not required; the original containers, image, network, and persistent volumes remain in place. The Web container remains running and host no-proxy HTTP returns 200.
- Reviewer action requested: assess the unresolved Affiliate route and the historical HTTP 000, whose cause remains unknown. No automatic deployment-stage continuation was performed.
