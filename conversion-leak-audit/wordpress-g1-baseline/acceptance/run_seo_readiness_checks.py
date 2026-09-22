from html.parser import HTMLParser
from pathlib import Path
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = ROOT.parent
BASE_URL = os.environ.get('CLA_G4_6_BASE_URL', 'http://127.0.0.1:8084').rstrip('/')
BASE_PARTS = urllib.parse.urlsplit(BASE_URL)
if BASE_PARTS.scheme != 'http' or BASE_PARTS.hostname not in {'127.0.0.1', 'localhost', '::1'}:
    raise SystemExit('CLA_G4_6_BASE_URL must be a local HTTP loopback URL; refusing non-local requests.')
DIRECT_OPENER = urllib.request.build_opener(urllib.request.ProxyHandler({}))
checks = []


def check(name, ok, detail=''):
    checks.append((name, bool(ok), detail))


class PublicPageParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.title_parts = []
        self.title_depth = 0
        self.visible_parts = []
        self.heading_parts = None
        self.headings = []
        self.h1_count = 0
        self.descriptions = []
        self.robots = []
        self.canonicals = []
        self.primary_links = []
        self.links = []
        self.scan_card_links = []
        self.nav_stack = []
        self.div_class_stack = []
        self.scan_card_depth = 0
        self.anchor_parts = None
        self.anchor_href = ''
        self.anchor_nav = ''
        self.anchor_in_scan_card = False
        self.skip_stack = []

    def handle_starttag(self, tag, attrs):
        values = dict(attrs)
        if tag in {'script', 'style', 'noscript', 'template'}:
            self.skip_stack.append(tag)
        if self.skip_stack:
            return

        if tag == 'div':
            classes = set((values.get('class') or '').split())
            self.div_class_stack.append(classes)
            if 'cla-g4-scan-card' in classes:
                self.scan_card_depth += 1
        if tag == 'title':
            self.title_depth += 1
        if tag == 'nav':
            self.nav_stack.append(values.get('aria-label', ''))
        if tag == 'meta':
            name = (values.get('name') or '').lower()
            if name == 'description':
                self.descriptions.append(values.get('content', ''))
            elif name == 'robots':
                self.robots.append(values.get('content', '').lower())
        if tag == 'link' and 'canonical' in (values.get('rel') or '').lower().split():
            self.canonicals.append(values.get('href', ''))
        if re.fullmatch(r'h[1-6]', tag):
            level = int(tag[1])
            if level == 1:
                self.h1_count += 1
            self.heading_parts = (level, [])
        if tag == 'a':
            self.anchor_parts = []
            self.anchor_href = values.get('href', '')
            self.anchor_nav = self.nav_stack[-1] if self.nav_stack else ''
            self.anchor_in_scan_card = self.scan_card_depth > 0
        for attr in ('aria-label', 'alt', 'title'):
            if values.get(attr):
                self.visible_parts.append(values[attr])

    def handle_endtag(self, tag):
        if self.skip_stack:
            if tag == self.skip_stack[-1]:
                self.skip_stack.pop()
            return
        if tag == 'title' and self.title_depth:
            self.title_depth -= 1
        if re.fullmatch(r'h[1-6]', tag) and self.heading_parts is not None:
            level, parts = self.heading_parts
            self.headings.append((level, ' '.join(' '.join(parts).split())))
            self.heading_parts = None
        if tag == 'a' and self.anchor_parts is not None:
            text = ' '.join(' '.join(self.anchor_parts).split())
            self.links.append((text, self.anchor_href))
            if self.anchor_in_scan_card:
                self.scan_card_links.append((text, self.anchor_href))
            if self.anchor_nav == 'Primary navigation':
                self.primary_links.append((text, self.anchor_href))
            self.anchor_parts = None
            self.anchor_in_scan_card = False
        if tag == 'div' and self.div_class_stack:
            classes = self.div_class_stack.pop()
            if 'cla-g4-scan-card' in classes:
                self.scan_card_depth -= 1
        if tag == 'nav' and self.nav_stack:
            self.nav_stack.pop()

    def handle_data(self, data):
        if self.skip_stack:
            return
        text = data.strip()
        if not text:
            return
        self.visible_parts.append(text)
        if self.title_depth:
            self.title_parts.append(text)
        if self.heading_parts is not None:
            self.heading_parts[1].append(text)
        if self.anchor_parts is not None:
            self.anchor_parts.append(text)

    @property
    def visible_text(self):
        return ' '.join(' '.join(self.visible_parts).split())

    @property
    def title(self):
        return ' '.join(' '.join(self.title_parts).split())


def fetch(path):
    request = urllib.request.Request(
        urllib.parse.urljoin(BASE_URL + '/', path.lstrip('/')),
        headers={'User-Agent': 'ConversionLeakAudit-G4.6-Readiness/1.0'},
    )
    try:
        with DIRECT_OPENER.open(request, timeout=20) as response:
            return response.status, response.read()
    except urllib.error.HTTPError as error:
        return error.code, error.read()


def parse_page(path):
    status, body = fetch(path)
    parser = PublicPageParser()
    parser.feed(body.decode('utf-8', errors='replace'))
    return status, parser


routes = {
    'home': '/',
    'how-it-works': '/how-it-works/',
    'demo': '/demo/',
    'faq': '/faq/',
    'blog': '/blog/',
    'pricing': '/pricing/',
}
pages = {}
for slug, route in routes.items():
    status, parser = parse_page(route)
    pages[slug] = parser
    check(f'route:{slug}:http_200', status == 200, f'{route} HTTP {status}')

expected_titles = {
    'home': 'Free Ecommerce Conversion Audit | Conversion Leak Audit',
    'how-it-works': 'How This Ecommerce Conversion Audit Works | Conversion Leak Audit',
    'demo': 'Example Ecommerce Store Audit | Conversion Leak Audit',
    'faq': 'Ecommerce Conversion Audit FAQ | Conversion Leak Audit',
}
expected_descriptions = {
    'home': ['free top 3', 'public storefront pages', 'evidence', 'no admin access'],
    'how-it-works': ['ecommerce conversion audit', 'public storefront pages', 'evidence'],
    'demo': ['synthetic', 'example ecommerce storefront audit', 'evidence-backed'],
    'faq': ['ecommerce conversion audit', 'public-page scanning', 'limitations'],
}

for slug in expected_titles:
    parser = pages[slug]
    route = routes[slug]
    expected_canonical = urllib.parse.urljoin(BASE_URL + '/', route.lstrip('/'))
    check(f'{slug.upper().replace("-", "_")}_META', parser.title == expected_titles[slug] and len(parser.descriptions) == 1 and all(term in parser.descriptions[0].lower() for term in expected_descriptions[slug]), f'title={parser.title!r}; descriptions={parser.descriptions!r}')
    check(f'canonical:{slug}', len(parser.canonicals) == 1 and parser.canonicals[0].rstrip('/') == expected_canonical.rstrip('/'), f'canonical={parser.canonicals!r}')
    check(f'robots:indexable:{slug}', len(parser.robots) == 1 and 'noindex' not in parser.robots[0] and 'nofollow' not in parser.robots[0], f'robots={parser.robots!r}')
    levels = [level for level, _ in parser.headings]
    hierarchy_ok = parser.h1_count == 1 and bool(levels) and levels[0] == 1 and all(current <= previous + 1 for previous, current in zip(levels, levels[1:]))
    check(f'h1_sanity:{slug}', hierarchy_ok, f'h1={parser.h1_count}; headings={parser.headings!r}')

home_text = pages['home'].visible_text.lower()
check('message_readiness', 'evidence-first ecommerce conversion audit' in home_text and 'find friction that may be making customers hesitate' in home_text and 'free scan' in home_text and 'public pages' in home_text and 'evidence-backed top 3' in home_text and 'no admin access' in home_text)
check('home_sample_audit_cta', ('View sample audit', '/demo/') in pages['home'].scan_card_links, repr(pages['home'].scan_card_links))
check('BLOG_PRIMARY_NAV', not any('blog' in href.lower() or text.lower() == 'blog' for text, href in pages['home'].primary_links), repr(pages['home'].primary_links))
check('PRICING_PRIMARY_NAV', not any('pricing' in href.lower() or text.lower() == 'pricing' for text, href in pages['home'].primary_links), repr(pages['home'].primary_links))
check('primary_nav_order', [text for text, _ in pages['home'].primary_links] == ['Home', 'How it works', 'Demo', 'FAQ'], repr(pages['home'].primary_links))

how_text = pages['how-it-works'].visible_text.lower()
how_steps = [
    'confirm the public website address can be reached safely',
    'check a limited number of key storefront pages',
    'record what those pages actually show',
    'apply trusted checks that fit the pages reviewed',
    'show only issues supported by evidence',
    'clearly mark the scan as incomplete',
]
check('how_it_works_public_copy', all(step in how_text for step in how_steps) and 'what a public scan cannot know' in how_text)

demo_text = pages['demo'].visible_text
demo_ids = re.findall(r'\b(?:CORE-007|PHYS-002|PHYS-001)\b', demo_text)
demo_required = ['Synthetic Demo', '3 confirmed findings', '17 trusted checks', 'Observed fact:', 'Source / evidence:', 'First move:', 'Limitation:']
check('DEMO_PROOF', demo_ids == ['CORE-007', 'PHYS-002', 'PHYS-001'] and all(demo_text.count(label) >= (3 if label == 'Limitation:' else 1) for label in demo_required), f'finding_ids={demo_ids!r}')
check('DEMO_SCAN_CTA', ('Scan my store', '/#cla-g4-store-url') in pages['demo'].links)

result_id = 'a' * 32
status, result_page = parse_page('/?scan_id=' + result_id)
canonical_home = urllib.parse.urljoin(BASE_URL + '/', '')
result_metadata = ' '.join([result_page.title, *result_page.descriptions]).lower()
check('SCAN_RESULT_NOINDEX', status == 200 and len(result_page.robots) == 1 and 'noindex' in result_page.robots[0], f'HTTP {status}; robots={result_page.robots!r}')
check('SCAN_RESULT_CANONICAL_HOME', len(result_page.canonicals) == 1 and result_page.canonicals[0].rstrip('/') == canonical_home.rstrip('/'), f'canonical={result_page.canonicals!r}')
check('scan_result_seo_is_static', result_id not in result_metadata and 'scan result' not in result_metadata and 'evidence' not in result_page.title.lower())

for slug in ('blog', 'pricing'):
    parser = pages[slug]
    check(f'{slug.upper()}_NOINDEX', len(parser.robots) == 1 and 'noindex' in parser.robots[0], repr(parser.robots))

status, sitemap_body = fetch('/wp-sitemap.xml')
sitemap_paths = []
if status == 200:
    sitemap_xml = ET.fromstring(sitemap_body)
    sitemap_paths = [node.text or '' for node in sitemap_xml.findall('.//{*}loc')]
check('SITEMAP_HTTP', status == 200, f'HTTP {status}')
page_sitemaps = [url for url in sitemap_paths if 'wp-sitemap-posts-page-' in url]
provider_names = [re.search(r'wp-sitemap-([a-z]+)', url).group(1) for url in sitemap_paths if re.search(r'wp-sitemap-([a-z]+)', url)]
sitemap_content_ok = len(page_sitemaps) == 1 and provider_names == ['posts']
if sitemap_content_ok:
    child_status, child_body = fetch(page_sitemaps[0])
    sitemap_content_ok = child_status == 200
    if child_status == 200:
        page_xml = ET.fromstring(child_body)
        locations = [node.text or '' for node in page_xml.findall('.//{*}loc')]
        actual_paths = {urllib.parse.urlsplit(url).path.rstrip('/') or '/' for url in locations}
        expected_paths = {'/', '/how-it-works', '/demo', '/faq'}
        sitemap_content_ok = actual_paths == expected_paths and len(locations) == 4
        sitemap_content_ok = sitemap_content_ok and not any(token in child_body.decode('utf-8', errors='replace').lower() for token in ['blog', 'pricing', 'sample-page', 'hello-world', 'scan_id'])
check('SITEMAP_CONTENT', sitemap_content_ok, repr(sitemap_paths))
check('BLOG_SITEMAP_EXCLUDED', 'blog' not in repr(sitemap_paths) and (not page_sitemaps or 'blog' not in sitemap_body.decode('utf-8', errors='replace').lower()))
check('PRICING_SITEMAP_EXCLUDED', 'pricing' not in repr(sitemap_paths) and (not page_sitemaps or 'pricing' not in sitemap_body.decode('utf-8', errors='replace').lower()))

robots_status, robots_body = fetch('/robots.txt')
robots_text = robots_body.decode('utf-8', errors='replace')
robots_lines = [line.strip().lower() for line in robots_text.splitlines()]
robots_disallow_all = any(re.fullmatch(r'disallow\s*:\s*/\s*', line) for line in robots_lines)
robots_blocks_unfinished = any(re.match(r'disallow\s*:\s*/(blog|pricing)(?:/|\s|$)', line) for line in robots_lines)
check('ROBOTS_READINESS', robots_status == 200 and not robots_disallow_all and not robots_blocks_unfinished, f'HTTP {robots_status}; {robots_text!r}')

public_text = ' '.join(pages[slug].visible_text for slug in routes)
internal_terms = re.findall(r'\b(?:G[1-5](?:\.\d+)?|V1|gate|frozen rules?|internal milestone|normalized facts|context gates|frozen set)\b', public_text, flags=re.IGNORECASE)
check('PUBLIC_INTERNAL_TERMS', not internal_terms, repr(internal_terms))
starter_copy = re.search(r'\b(?:Sample Page|Hello world)\b', public_text, flags=re.IGNORECASE)
check('no_starter_or_duplicate_template_copy', starter_copy is None and pages['home'].h1_count == 1 and home_text.count('find friction that may be making customers hesitate') == 1)

integration_js = (PROJECT_ROOT / 'g4-wordpress-integration' / 'conversion-leak-audit-g4.js').read_text(encoding='utf-8')
required_events = ['landing_view', 'scan_started', 'top3_viewed', 'paid_expansion_viewed']
events_present = all(re.search(r"emit\(\s*['\"]" + re.escape(event) + r"['\"]", integration_js) for event in required_events)
check('ANALYTICS_CONTRACT', events_present and not re.search(r"emit\(\s*['\"](?:checkout_started|payment_completed)['\"]", integration_js), repr(required_events))

failed = [item for item in checks if not item[1]]
for name, ok, detail in checks:
    print(('PASS' if ok else 'FAIL'), name, detail)
print(f'TOTAL={len(checks)} PASS={len(checks) - len(failed)} FAIL={len(failed)}')
sys.exit(1 if failed else 0)
