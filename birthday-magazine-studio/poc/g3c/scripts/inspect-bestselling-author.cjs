const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require(path.resolve(__dirname, '../../g2b/node_modules/playwright'));

const repoRoot = path.resolve(__dirname, '../../../..');
const baseUrl = 'http://127.0.0.1:8147';
const passwordFile = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/.tmp/admin-password.txt');
const screenshots = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/screenshots');
const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
const searchTerm = process.argv.slice(2).join(' ') || 'Bestselling Author';

async function main() {
	const password = fs.readFileSync(passwordFile, 'utf8').trim();
	fs.mkdirSync(screenshots, { recursive: true });
	const browser = await chromium.launch({ headless: true, executablePath: chromePath });
	try {
		const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
		const networkFailures = [];
		const httpErrors = [];
		const externalResponses = [];
		const templateApiMetadata = [];
		page.on('requestfailed', (request) => {
			const url = new URL(request.url());
			networkFailures.push({ host: url.hostname, resourceType: request.resourceType(), method: request.method(), error: request.failure()?.errorText || 'unknown' });
		});
		page.on('response', (response) => {
			const host = new URL(response.url()).hostname;
			const responseInfo = { host, path: new URL(response.url()).pathname, status: response.status(), resourceType: response.request().resourceType() };
			if (response.status() >= 400) httpErrors.push(responseInfo);
			if (!['127.0.0.1', 'localhost'].includes(host)) externalResponses.push(responseInfo);
		});
		page.on('response', async (response) => {
			const host = new URL(response.url()).hostname;
			if (!['startertemplates.com', 'websitedemos.net'].includes(host) || response.request().resourceType() !== 'fetch') return;
			try {
				const payload = await response.json();
				const matches = [];
				const arrays = [];
				const visit = (value, key = 'root') => {
					if (Array.isArray(value)) {
						arrays.push({ key, count: value.length });
						for (const item of value) visit(item, key);
					} else if (value && typeof value === 'object') {
						const title = String(value.title || value.name || value.template_name || '');
						const slug = String(value.slug || value.id || value.template_id || '');
						if (/bestselling|author/i.test(`${title} ${slug}`)) matches.push({ title, slug, keys: Object.keys(value).slice(0, 24) });
						for (const [childKey, childValue] of Object.entries(value)) visit(childValue, childKey);
					}
				};
				visit(payload);
				templateApiMetadata.push({ host, status: response.status(), rootType: Array.isArray(payload) ? 'array' : typeof payload, rootKeys: payload && typeof payload === 'object' && !Array.isArray(payload) ? Object.keys(payload).slice(0, 30) : [], arrays: arrays.slice(0, 30), candidateMatches: matches.slice(0, 20) });
			} catch { /* Non-JSON image or resource response; no body is retained. */ }
		});
		await page.goto(`${baseUrl}/wp-login.php`, { waitUntil: 'domcontentloaded' });
		await page.locator('#user_login').fill('g3c-admin');
		await page.locator('#user_pass').fill(password);
		await page.locator('#wp-submit').click();
		await page.waitForURL((url) => new URL(url).pathname.includes('/wp-admin/'), { timeout: 20000 });
		await page.goto(`${baseUrl}/wp-admin/`, { waitUntil: 'domcontentloaded' });
		const starterLink = page.locator('#adminmenu a').filter({ hasText: /Starter Templates/i }).first();
		if (!(await starterLink.count())) throw new Error('Starter Templates did not add its expected WordPress admin menu entry.');
		const rawHref = await starterLink.getAttribute('href');
		const parsed = new URL(rawHref, baseUrl);
		const safeRoute = `${parsed.pathname}?page=${parsed.searchParams.get('page') || ''}`;
		await page.goto(`${baseUrl}/wp-admin/${safeRoute}`, { waitUntil: 'domcontentloaded' });
		await page.waitForLoadState('domcontentloaded');
		await page.waitForTimeout(6000);
		const templateEntry = page.getByRole('button', { name: 'Build with Templates', exact: true });
		if (!(await templateEntry.count())) throw new Error('The free Classic Starter Templates entry point is unavailable.');
		await templateEntry.click();
		await page.waitForTimeout(6000);
		const blockEditor = page.getByText('Block Editor', { exact: true });
		if (!(await blockEditor.count())) throw new Error('The free WordPress Block Editor choice is unavailable.');
		await blockEditor.click();
		await page.waitForTimeout(6000);
		const skipBuilderUpsell = page.getByText('Maybe Later', { exact: true });
		if (await skipBuilderUpsell.count()) {
			await skipBuilderUpsell.click();
			await page.waitForTimeout(6000);
		}
		const templateSearch = page.getByPlaceholder('Search for Starter Templates');
		await templateSearch.fill(searchTerm);
		await page.waitForTimeout(1000);
		await page.locator('.stc-site-order-filter .stc-toggle-dropdown-selected').click();
		await page.waitForTimeout(500);
		const sortOptionsAfterOpen = (await page.locator('body').innerText()).replace(/\s+/g, ' ').trim().slice(0, 2000);
		const latestFilter = page.getByText('Latest', { exact: true });
		const latestFilterCount = await latestFilter.count();
		const latestFilterMeta = latestFilterCount ? await latestFilter.evaluateAll((elements) => elements.map((element) => ({ tag: element.tagName, className: String(element.className || ''), html: element.outerHTML.slice(0, 400), parentHtml: element.parentElement?.outerHTML.slice(0, 900) }))) : [];
		if (latestFilterCount) await page.locator('.stc-site-order-filter .stc-toggle-dropdown-popup-item').filter({ hasText: /^Latest$/ }).click();
		const selectedSortAfterClick = await page.locator('.stc-site-order-filter .stc-toggle-dropdown-selected').innerText();
		const selectedSortAfterSearch = await page.locator('.stc-site-order-filter .stc-toggle-dropdown-selected').innerText();
		await page.waitForTimeout(6000);
		const bodyText = (await page.locator('body').innerText()).replace(/\s+/g, ' ').trim();
		const noMatch = bodyText.includes(`Your search - ${searchTerm} - did not match any Starter Templates.`);
		const result = noMatch ? 'RETURN_STARTER_IMPORT_FAILED' : 'TEMPLATE_RESULT_PRESENT_IMPORT_NOT_RUN';
		const buttonText = await page.locator('button').allInnerTexts();
		const inputs = await page.locator('input').evaluateAll((elements) => elements.map((element) => ({ type: element.type, placeholder: element.placeholder, value: element.value, ariaLabel: element.getAttribute('aria-label') })));
		const selects = await page.locator('select').evaluateAll((elements) => elements.map((element) => ({ value: element.value, options: Array.from(element.options, (option) => ({ label: option.textContent.trim(), value: option.value })) })));
		const dropdownMeta = await page.locator('body').evaluate((body) => Array.from(body.querySelectorAll('*')).filter((element) => ['All', 'Popular'].includes(element.textContent.trim()) && element.children.length === 0).map((element) => ({ text: element.textContent.trim(), tag: element.tagName, className: String(element.className || ''), parentTag: element.parentElement?.tagName, parentClass: String(element.parentElement?.className || ''), parentRole: element.parentElement?.getAttribute('role'), parentHasPopup: element.parentElement?.getAttribute('aria-haspopup') })));
		const report = {
			capturedAtUtc: new Date().toISOString(),
			result,
			plugin: 'Starter Templates 4.7.7',
			searchedTemplate: searchTerm,
			pageBuilder: 'Block Editor',
			selectedSort: selectedSortAfterSearch,
			importPerformed: false,
			aiBuilderSelected: false,
			adminRoute: safeRoute,
			pageTitle: await page.title(),
			visibleText: bodyText.slice(0, 8000),
			buttonLabels: buttonText.map((text) => text.trim()).filter(Boolean).slice(0, 100),
			inputs,
			selects,
			dropdownMeta,
			sortOptionsAfterOpen,
			selectedSortAfterClick,
			selectedSortAfterSearch,
			latestFilterCount,
			latestFilterMeta,
			networkFailures,
			httpErrors,
			externalResponses,
			templateApiMetadata,
		};
		fs.writeFileSync(path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports/starter-template-importer-inspection.json'), `${JSON.stringify(report, null, 2)}\n`, 'utf8');
		await page.screenshot({ path: path.join(screenshots, 'starter-template-importer.png'), fullPage: true });
		const resultEvidence = {
			capturedAtUtc: report.capturedAtUtc,
			gate: 'G3C_UI_UX_PRODUCTIZATION',
			result,
			requiredStarter: 'Bestselling Author',
			officialTemplatePage: 'https://wpastra.com/templates/bestselling-author-02/',
			officialPageListsTemplateAsFree: true,
			localImporter: {
				plugin: 'Starter Templates 4.7.7',
				pageBuilder: report.pageBuilder,
				selectedSort: report.selectedSort,
				exactSearchText: searchTerm,
				noMatch: result === 'RETURN_STARTER_IMPORT_FAILED',
				displayedMessage: noMatch ? `Your search - ${searchTerm} - did not match any Starter Templates.` : 'A result was present; this inspector does not import it.',
				catalogResponses: externalResponses.filter((response) => response.host === 'websitedemos.net').map(({ host, path, status, resourceType }) => ({ host, path, status, resourceType })),
				aiBuilderSelected: false,
				importPerformed: false,
			},
			priorPopularSearch: 'NO_MATCH',
			evidence: {
				inspector: 'scripts/inspect-bestselling-author.cjs',
				inspectionReport: 'artifacts/reports/starter-template-importer-inspection.json',
				screenshot: 'artifacts/screenshots/starter-template-importer.png',
			},
		};
		fs.writeFileSync(path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports/starter-import-result.json'), `${JSON.stringify(resultEvidence, null, 2)}\n`, 'utf8');
		console.log(JSON.stringify({ result, adminRoute: safeRoute, searchedTemplate: searchTerm, selectedSort: selectedSortAfterSearch, importPerformed: false, aiBuilderSelected: false, visibleText: bodyText.slice(0, 4000), networkFailures, httpErrors, externalResponses, templateApiMetadata }));
		if (noMatch) process.exitCode = 2;
	} finally {
		await browser.close();
	}
}

main().catch((error) => {
	console.error(error.message.replace(/https?:\/\/[^\s?]+\?[^\s]*/g, '[local URL redacted]'));
	process.exitCode = 1;
});
