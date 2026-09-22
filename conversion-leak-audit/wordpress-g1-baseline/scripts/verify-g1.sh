#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

DC=(docker compose -f docker-compose.local.yml)
WP=("${DC[@]}" --profile tools run --rm wpcli)

fail=0
report=acceptance/G1_RUNTIME_READBACK.txt
: > "$report"

log() { printf '%s\n' "$*" | tee -a "$report"; }
check() {
  local name="$1"; shift
  if "$@" >/tmp/cla-g1-check.out 2>/tmp/cla-g1-check.err; then
    log "PASS $name $(tr '\n' ' ' </tmp/cla-g1-check.out | sed 's/[[:space:]]\+$//')"
  else
    log "FAIL $name $(tr '\n' ' ' </tmp/cla-g1-check.err | sed 's/[[:space:]]\+$//')"
    fail=$((fail+1))
  fi
}

check wordpress_version "${WP[@]}" core version
check parent_theme_version "${WP[@]}" theme get saaslauncher --field=version
check child_theme_active "${WP[@]}" theme status conversion-leak-audit-child --status=active

for slug in home how-it-works demo pricing faq blog; do
  check "page_${slug}" "${WP[@]}" post list --post_type=page --name="$slug" --post_status=publish --field=ID
 done

check home_front_page "${WP[@]}" eval 'echo get_option("show_on_front").":".get_option("page_on_front");'

port="${WP_PORT:-8080}"
html="$(curl -fsS "http://localhost:${port}/")" || { log 'FAIL home_http'; fail=$((fail+1)); html=''; }
if grep -q 'data-cla-g1-placeholder="true"' <<<"$html" && grep -q 'aria-disabled="true"' <<<"$html"; then
  log 'PASS placeholder_rendered_disabled'
else
  log 'FAIL placeholder_rendered_disabled'
  fail=$((fail+1))
fi
if grep -q 'Your store may not need more traffic' <<<"$html"; then
  log 'PASS project_home_content_rendered'
else
  log 'FAIL project_home_content_rendered'
  fail=$((fail+1))
fi
if grep -q 'cla-baseline-style-css' <<<"$html"; then
  log 'PASS child_style_loaded'
else
  log 'FAIL child_style_loaded'
  fail=$((fail+1))
fi
if grep -qi 'Sample Page' <<<"$html"; then
  log 'FAIL sample_page_removed'
  fail=$((fail+1))
else
  log 'PASS sample_page_removed'
fi
if grep -Eqi 'scanner[^<]{0,20}(connected|running)|checkout[^<]{0,20}(pay|purchase)' <<<"$html"; then
  log 'FAIL no_scanner_or_payment_activation'
  fail=$((fail+1))
else
  log 'PASS no_scanner_or_payment_activation'
fi

if [ "$fail" -eq 0 ]; then
  log 'PASS_CANDIDATE_G1_WORDPRESS_LOCAL_BASELINE'
  exit 0
fi
log "RETURN_G1_RUNTIME_READBACK_FAILED count=$fail"
exit 1
