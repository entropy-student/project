# Owner Decision — G3CR6R3D2 Image Generation Quality Priority

> Date: 2026-10-04

## Decision

~~~text
D2_DESIGN_TIME_IMAGE_GENERATION=AUTHORIZED
D2_IMAGE_GENERATION_PRIORITY=QUALITY_OVER_COST_MINIMIZATION
ARTIFICIAL_LOW_CALL_CAP=REMOVED
SCOPE=STATIC_HOMEPAGE_MARKETING_VISUALS_ONLY
RUNTIME_PREVIEW_MODEL_CALLS=0
FREE_PREVIEW_SERVER_PHOTO_UPLOADS=0
FREE_PREVIEW_EXTERNAL_IMAGE_POSTS=0
NEW_EXTERNAL_PAID_PROVIDER_OR_SECRET=NOT_AUTHORIZED
PRODUCTION_AI_PROVIDER=UNCHANGED
~~~

## Interpretation

The Owner explicitly authorizes design-time image generation during G3CR6R3D2 when it materially improves the homepage's visual quality, cohesion, or fidelity to the approved Focusly-inspired direction.

The Executor must **not** preserve weak or mismatched existing imagery merely to minimize generation count or cost. Existing owned assets should still be reused where they are genuinely strong enough, but visual quality takes priority over avoiding additional design-time generations.

This authorization is bounded to static homepage marketing/design assets for the current D2 implementation. It does not authorize:
- runtime or Free Preview model calls;
- server/external upload of shopper photos;
- production generation-provider changes;
- new external paid model accounts/API keys/Secrets;
- P1-P12 magazine generation;
- core Aha interaction implementation.

For each adopted generated asset, record:
- prompt/purpose;
- generation count;
- final file/path;
- where it is used;
- whether it replaced or supplemented an existing asset.

Rejected intermediate generations do not need to be committed as product assets, but the total generation call count for this Gate must still be recorded in execution evidence.
