# G3CR7V2R1 — Stripe Soft-Tech Token Map

Implementation is limited to the Homepage Preview/core-entry and the existing intake/status continuation surfaces. Values are mapped from the project adapter and vendored `DESIGN.md`; no Stripe brand assets, marks, source code, or proprietary fonts are used.

| Implementation | DESIGN.md / adapter token | Value | Applied to |
|---|---|---|---|
| `--bms-ui-primary`, `--g3cr7-primary` | `colors.primary` | `#533afd` | Primary pill CTA, progress/current state, links and focus border |
| `--bms-ui-primary-deep`, `--g3cr7-primary-deep` | `colors.primary-deep` | `#4434d4` | Hover and subdued indigo status tags |
| `--bms-ui-primary-press`, `--g3cr7-primary-press` | `colors.primary-press` | `#2e2b8c` | Pressed primary action |
| `--g3cr7-primary-soft` | `colors.primary-soft` | `#665efd` | Reserved subtle product accent; not used as body text or CTA fill |
| `--g3cr7-primary-subdued` | `colors.primary-bg-subdued-hover` | `#b9b9f9` | Soft review accent and secondary-action hover border |
| `--g3cr7-dark` | `brand-dark-900` | `#1c1e54` | Reserved token; no dark shell added |
| `--bms-ui-ink`, `--g3cr7-ink` | `colors.ink` | `#0d253d` | Main UI text and headings |
| `--bms-ui-secondary`, `--g3cr7-secondary` | `colors.ink-secondary` | `#273951` | Supporting copy |
| `--bms-ui-muted`, `--g3cr7-muted` | `colors.ink-mute` | `#64748d` | Labels, helper copy and captions |
| `--bms-ui-canvas`, `--g3cr7-canvas` | `colors.canvas` | `#ffffff` | White panels, controls, preview and status card |
| `--bms-ui-soft`, `--g3cr7-soft` | `colors.canvas-soft` | `#f6f9fc` | App field/background |
| `--bms-ui-hairline`, `--g3cr7-line` | `colors.hairline` | `#e3e8ee` | Panel and timeline borders |
| `--bms-ui-input`, `--g3cr7-input-line` | `colors.hairline-input` | `#a8c3de` | Form-field borders |
| `0 1px 3px rgb(0 55 112 / 8%)` | Elevation Level 1 | same | Compact photo/status items |
| `0 8px 24px rgb(0 55 112 / 8%), 0 2px 6px rgb(0 55 112 / 4%)` | Elevation Level 2 | same | Main Preview/intake/status panels |
| `6px / 8px / 12px / 9999px` | `rounded.sm / md / lg / pill` | same | Inputs / compact surfaces / main cards / action buttons |
| `8 / 12 / 16 / 24 / 32 / 64px` | Spacing scale | same | Form gaps, panel padding and true section boundaries |

Typography uses the locally available UI sans stack (`Inter` only if supplied by the browser/system, then `-apple-system`, `BlinkMacSystemFont`, `Segoe UI`, `sans-serif`). No network font request or proprietary font asset is added. Form/status headings stay within the adapter's 20–32px product UI range. Serif and ivory styling remain scoped to the magazine mockup only.

The Home Preview intro uses a new project-authored abstract SVG mesh at `poc/g3c/preview-plugin/assets/g3cr7v2r1-soft-mesh.svg`. It contains only blurred color fields, is not copied from Stripe, and contains no illustration or human placeholder. Intake/status use flat `canvas-soft` and white surfaces.
