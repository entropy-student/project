# Story Image Runner — Research Notes

Last reviewed: 2026-09-22

## Observable reference architecture

Public implementations demonstrate that batch image generation can be orchestrated through a user's already signed-in browser session using:

```text
local queue/bridge
→ browser extension
→ owned ChatGPT tab
→ prompt submission
→ fresh-image detection
→ deterministic export
→ manifest/status
```

Useful behavioral references:

- `fortun8te/simpletics-imagegen`: visible README describes local bridge, background-tab ownership, dry-run/health/status/abort, typed errors, reference images, aspect ratios, manifests, and batch jobs.
- `yuyou-dev/ChatGPT-Bridge`: public README describes a signed-in ChatGPT browser workflow and states MIT licensing.
- `HelicopterHelicopter/gpt-imagegen-plugin`: public project describes a visible signed-in browser session controlled from a Node CLI/plugin.

## License rule

The Simpletics repository root did not visibly present a license during review. Treat it as **architecture research only**, not copyable source.

If an MIT-licensed reference is reused later, the Executor must record:

- exact repository;
- exact files/components reused;
- license;
- retained notices/attribution;
- modifications.

Default: implement G1 clean-room from project contracts.

## Deliberate deviations from observed projects

This project starts more conservatively:

- G1 has no real generation;
- safe mode is mandatory and default-on;
- concurrency is fixed at 1 initially;
- no anti-bot/stealth work;
- no account/session extraction;
- no automatic retry after rate limiting;
- first live action is a separately reviewed single-image canary.

These are project safety/governance choices, not claims about upstream behavior.
