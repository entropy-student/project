const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { chromium } = require(path.resolve(__dirname, '../../g2b/node_modules/playwright'));

const repoRoot = path.resolve(__dirname, '../../../..');
const project = 'birthday-magazine-g3c';
const baseUrl = 'http://127.0.0.1:8147';
const composeFile = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/compose.yaml');
const tempDir = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/.tmp');
const passwordFile = path.join(tempDir, 'admin-password.txt');
const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

async function main() {
	fs.mkdirSync(tempDir, { recursive: true });
	const adminPassword = `${crypto.randomBytes(24).toString('base64url')}Aa7!`;
	const browser = await chromium.launch({ headless: true, executablePath: chromePath, args: ['--no-proxy-server'] });
	try {
		const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
		await page.goto(`${baseUrl}/wp-admin/install.php`, { waitUntil: 'domcontentloaded' });
		const languageForm = page.locator('body.language-chooser form');
		if (await languageForm.count()) {
			await languageForm.locator('input[type="submit"],button[type="submit"]').first().click();
			await page.waitForSelector('#weblog_title', { timeout: 20000 });
		}
		if (await page.locator('#weblog_title').count()) {
			await page.locator('#weblog_title').fill('Birthday Magazine Studio — Local G3C');
			await page.locator('#user_login').fill('g3c-admin');
			await page.locator('#pass1').fill(adminPassword);
			await page.locator('#admin_email').fill('site-admin@birthday.invalid');
			const weakPasswordConfirmation = page.locator('#pw-weak');
			if (await weakPasswordConfirmation.count() && !(await weakPasswordConfirmation.isChecked())) await weakPasswordConfirmation.check();
			await Promise.all([
				page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 20000 }),
				page.locator('#submit').click(),
			]);
			const confirmation = (await page.locator('body').innerText()).replace(/\s+/g, ' ').trim();
			if (!confirmation.toLowerCase().includes('success')) throw new Error('WordPress first-run did not return its success confirmation.');
		} else if (!(await page.locator('body').innerText()).includes('Already Installed')) {
			throw new Error('WordPress install flow is not at the language or site setup step.');
		}

		const compose = ['compose', '-p', project, '-f', composeFile];
		docker([...compose, 'exec', '-T', 'wpcli', 'wp', 'user', 'update', 'g3c-admin', `--user_pass=${adminPassword}`]);
		fs.writeFileSync(passwordFile, adminPassword, { encoding: 'utf8', mode: 0o600 });
		console.log(JSON.stringify({ wordpressInstall: 'PASS', adminUser: 'g3c-admin', credentialStoredOnlyInIgnoredTmp: true }));
	} finally {
		await browser.close();
	}
}

main().catch((error) => {
	console.error(error.stderr ? error.stderr.toString().trim() : error.message);
	process.exitCode = 1;
});
