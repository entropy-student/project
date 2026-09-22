# G1 Acceptance Checklist

## Asset Gate

- [x] WordPress target version locked
- [x] SaasLauncher target version locked
- [x] project-local child theme exists
- [x] project-local MU plugin exists
- [x] Home / How it works / Demo / Pricing / FAQ / Blog content exists
- [x] disabled URL scan placeholder exists
- [x] Scanner integration absent
- [x] Payment integration absent
- [x] Docker local bootstrap prepared
- [x] seed script is idempotent by page slug
- [x] rollback documented

## Runtime Gate — must be proven in a WordPress-capable local environment

- [ ] WordPress 7.1 installed and health-readable
- [ ] SaasLauncher 2.0.18 active as parent / child active
- [ ] six pages read back from WordPress database
- [ ] Home is front page
- [ ] Site Editor can edit page/template content
- [ ] URL placeholder renders and remains disabled
- [ ] no Scanner HTTP call occurs
- [ ] no payment action occurs
- [ ] local screenshot/readback captured

Until these runtime checks pass:

`RETURN_G1_LOCAL_RUNTIME_UNAVAILABLE`
