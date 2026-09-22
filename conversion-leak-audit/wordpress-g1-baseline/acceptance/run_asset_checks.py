from pathlib import Path
import json, re, sys

ROOT = Path(__file__).resolve().parents[1]
checks = []

def check(name, ok, detail=''):
    checks.append((name, bool(ok), detail))

required_pages = ['home','how-it-works','demo','pricing','faq','blog']
for slug in required_pages:
    p = ROOT / 'content/pages' / f'{slug}.html'
    check(f'page:{slug}', p.exists() and p.stat().st_size > 50, str(p))

mu = (ROOT/'wp-content/mu-plugins/conversion-leak-audit-baseline.php').read_text()
check('placeholder_shortcode_present', '[cla_scan_placeholder]' not in mu and 'cla_scan_placeholder_shortcode' in mu)
check('placeholder_disabled_input', 'disabled aria-disabled="true"' in mu)
check('placeholder_no_fetch', all(token not in mu.lower() for token in ['curl_', 'wp_remote_get', 'wp_remote_post', 'fetch(']))

home = (ROOT/'content/pages/home.html').read_text()
check('home_uses_placeholder', '[cla_scan_placeholder]' in home)
check('claim_boundary_present', 'cannot prove why your customers did not buy' in home)

pricing = (ROOT/'content/pages/pricing.html').read_text()
check('pricing_marks_unvalidated', 'planned launch price' in pricing and 'unvalidated' in pricing.lower())
check('payment_disabled', 'Checkout is intentionally disabled in G1' in pricing)

child_style = (ROOT/'wp-content/themes/conversion-leak-audit-child/style.css').read_text()
check('child_theme_parent', 'Template: saaslauncher' in child_style)
json.loads((ROOT/'wp-content/themes/conversion-leak-audit-child/theme.json').read_text())
check('theme_json_valid', True)

compose = (ROOT/'docker-compose.local.yml').read_text()
check('compose_no_vps_paths', '/srv/' not in compose)
check('compose_local_port', '${WP_PORT:-8080}:80' in compose)
check('compose_no_production_domain', 'spikersun.com' not in compose and 'bbroot.com' not in compose)

all_text = '\n'.join(p.read_text(errors='ignore') for p in ROOT.rglob('*') if p.is_file() and p.suffix in {'.md','.html','.php','.css','.json','.yml','.example','.sh','.ps1'})
check('no_scanner_endpoint', 'http://scanner' not in all_text and 'https://scanner' not in all_text)
check('no_live_secret_markers', all(x not in all_text for x in ['sk_live_', 'PAYPAL_CLIENT_SECRET=', 'STRIPE_SECRET_KEY=']))

failed = [x for x in checks if not x[1]]
for name, ok, detail in checks:
    print(('PASS' if ok else 'FAIL'), name, detail)
print(f'TOTAL={len(checks)} PASS={len(checks)-len(failed)} FAIL={len(failed)}')
sys.exit(1 if failed else 0)
