# G3CR6R3D2R3 — Owner Runtime Motion Diagnostic

## Gate

~~~text
GATE_ID=G3CR6R3D2R3_OWNER_RUNTIME_MOTION_DIAGNOSTIC
OBJECTIVE=Determine why the Owner sees a fully static homepage even though automated normal-motion evidence proves the controller can run
MAX_ENDPOINT_THIS_ROUND=Read-only Owner-browser/runtime diagnosis + precise root-cause classification; no website mutation
MANDATORY_REVIEW_STOP=YES
TARGET_AND_SCOPE=Owner browser motion preference + current local homepage script presence/execution + relevant console/runtime facts
APPLICABLE_CRITICAL_CONSTRAINTS=APPLICATION_MUTATION_0; WORDPRESS_MUTATION_0; RUNTIME_MUTATION_0; PAYMENT_0; CHECKOUT_SUBMISSION_0; IMAGEGEN_0; PR64_MERGE_0
PREFLIGHT=Use retained local runtime only; do not rebuild/recreate/restart unless a later Reviewer Gate explicitly authorizes it
REQUIRED_EVIDENCE=Owner-browser matchMedia result; homepage body/home class state; home-motion.js script presence; script load status; basic computed-style/state evidence on one animated element
ACCEPTANCE_CRITERIA=Classify one of REDUCED_MOTION_ACTIVE / SCRIPT_NOT_LOADED / SCRIPT_NOT_EXECUTING / MOTION_RUNNING_BUT_NOT_PERCEPTIBLE / UNKNOWN with evidence
ROLLBACK_STATUS_OR_PLAN=Not applicable; diagnostic only
OWNER_ONLY_ACTIONS=Owner performs one bounded browser-console diagnostic and relays the sanitized output
REVIEWER_TO_EXECUTOR_RELAY=NO EXECUTOR MUTATION; diagnostic is Owner-local browser readback
EXECUTOR_TO_REVIEWER_RELAY=NONE
~~~

## Owner diagnostic

On `http://127.0.0.1:8189/`, open DevTools Console and run exactly:

~~~js
(() => {
  const home = document.querySelector('body.home .entry-content');
  const script = [...document.scripts].find(s => s.src.includes('home-motion.js'));
  const card = document.querySelector('.bms-focus-card');
  return {
    reducedMotion: matchMedia('(prefers-reduced-motion: reduce)').matches,
    homeFound: !!home,
    motionClass: !!home?.classList.contains('bms-motion-on'),
    motionScript: script?.src || null,
    cardTransform: card ? getComputedStyle(card).transform : null,
    cardTiltVar: card?.style.getPropertyValue('--card-tilt') || null,
    cardScaleVar: card?.style.getPropertyValue('--card-scale') || null
  };
})()
~~~

This is read-only. It does not change the page.

## Interpretation

- `reducedMotion:true` + `motionClass:false` => expected accessibility suppression; do not patch blindly.
- `reducedMotion:false` + `motionScript:null` => enqueue/load problem.
- script exists + `motionClass:false` => execution error/early return.
- `motionClass:true` and card variables change when scrolling => controller runs; perceived-motion strength is a design issue, not load failure.

Stop and return the exact object only.
