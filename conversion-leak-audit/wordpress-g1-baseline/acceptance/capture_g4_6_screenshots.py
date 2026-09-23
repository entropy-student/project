from pathlib import Path
import os
from playwright.sync_api import sync_playwright


BASE_URL = os.environ.get('CLA_G4_6_BASE_URL', 'http://127.0.0.1:8084').rstrip('/')
OUTPUT = Path(__file__).resolve().parents[2] / 'docs' / 'evidence' / 'g4-6-screenshots'
OUTPUT.mkdir(parents=True, exist_ok=True)


with sync_playwright() as playwright:
    browser = playwright.chromium.launch(args=['--no-proxy-server'])
    context = browser.new_context(viewport={'width': 1440, 'height': 900}, device_scale_factor=1, reduced_motion='reduce')
    page = context.new_page()

    page.goto(BASE_URL + '/', wait_until='networkidle')
    page.screenshot(path=str(OUTPUT / '01-home-message-proof.png'), animations='disabled')

    page.goto(BASE_URL + '/demo/', wait_until='networkidle')
    page.screenshot(path=str(OUTPUT / '02-demo-proof.png'), full_page=True, animations='disabled')

    page.goto(BASE_URL + '/how-it-works/', wait_until='networkidle')
    page.screenshot(path=str(OUTPUT / '03-how-it-works-public-copy.png'), full_page=True, animations='disabled')

    page.goto(BASE_URL + '/', wait_until='networkidle')
    page.locator('.cla-site-header').screenshot(path=str(OUTPUT / '04-nav-without-blog-pricing.png'), animations='disabled')

    context.close()
    browser.close()

print(f'SCREENSHOTS={OUTPUT}')
