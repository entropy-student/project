const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const root = path.resolve(__dirname, '../../../..');
const base = path.join(root, 'birthday-magazine-studio/poc/g3cr2r3');
const temp = path.join(base, '.tmp');
const reportDir = path.join(base, 'artifacts/reports');
const compose = path.join(base, 'compose.yaml');
const project = 'birthday-magazine-g3cr2r3';
const wpcli = (args) => docker(['compose', '-p', project, '-f', compose, 'exec', '-T', 'wpcli', 'wp', ...args]);

function docker(args) {
	return execFileSync('docker', args, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

async function download(name, url) {
	const response = await fetch(url);
	if (!response.ok) throw new Error(`${name} download returned HTTP ${response.status}`);
	const bytes = Buffer.from(await response.arrayBuffer());
	const file = path.join(temp, name);
	fs.writeFileSync(file, bytes);
	return { file, bytes: bytes.length, sha256: crypto.createHash('sha256').update(bytes).digest('hex'), source: url };
}

async function pluginPackage(slug) {
	const query = new URLSearchParams({ action: 'plugin_information', 'request[slug]': slug });
	const response = await fetch(`https://api.wordpress.org/plugins/info/1.2/?${query}`);
	if (!response.ok) throw new Error(`WordPress.org metadata for ${slug} returned HTTP ${response.status}`);
	const metadata = await response.json();
	if (!metadata.version || !metadata.download_link) throw new Error(`WordPress.org metadata for ${slug} is incomplete`);
	const packageInfo = await download(`${slug}.${metadata.version}.zip`, metadata.download_link);
	return { ...packageInfo, slug, version: metadata.version, license: metadata.license || 'GPL-compatible WordPress.org plugin; exact license field not returned' };
}

async function main() {
	fs.mkdirSync(temp, { recursive: true });
	fs.mkdirSync(reportDir, { recursive: true });
	const blocksy = await download('blocksy.2.1.57.zip', 'https://downloads.wordpress.org/theme/blocksy.2.1.57.zip');
	const companion = await download('blocksy-companion.2.1.57.zip', 'https://downloads.wordpress.org/plugin/blocksy-companion.2.1.57.zip');
	const dependencyPackages = [];
	for (const slug of ['simply-gallery-block', 'stackable-ultimate-gutenberg-blocks', 'wpforms-lite']) dependencyPackages.push(await pluginPackage(slug));
	const password = `${crypto.randomBytes(32).toString('base64url')}Aa7!`;
	fs.writeFileSync(path.join(temp, 'local-admin.json'), JSON.stringify({ user: 'g3cr2r3-admin', password }), { mode: 0o600 });
	try {
		wpcli(['core', 'is-installed']);
	} catch {
		wpcli(['core', 'install', '--url=http://127.0.0.1:8187', '--title=Birthday Magazine G3CR2R3 Synthetic Local', '--admin_user=g3cr2r3-admin', `--admin_password=${password}`, '--admin_email=site-admin@birthday.invalid', '--skip-email']);
	}
	for (const packageInfo of [blocksy, companion]) {
		const dest = `/tmp/${path.basename(packageInfo.file)}`;
		const exactVersion = packageInfo === blocksy ? '2.1.57' : '2.1.57';
		const installedVersion = (() => {
			try { return packageInfo === blocksy ? wpcli(['theme', 'get', 'blocksy', '--field=version']) : wpcli(['plugin', 'get', 'blocksy-companion', '--field=version']); }
			catch { return ''; }
		})();
		if (installedVersion !== exactVersion) {
			docker(['cp', packageInfo.file, `${project}-wpcli-1:${dest}`]);
			if (packageInfo === blocksy) wpcli(['theme', 'install', dest, '--activate']);
			else wpcli(['plugin', 'install', dest, '--activate']);
		}
		docker(['exec', '-u', '0', `${project}-wpcli-1`, 'rm', '-f', dest]);
	}
	const plugins = [];
	for (const packageInfo of dependencyPackages) {
		const dest = `/tmp/${path.basename(packageInfo.file)}`;
		let installedVersion = '';
		try { installedVersion = wpcli(['plugin', 'get', packageInfo.slug, '--field=version']); } catch { /* Plugin is not installed yet. */ }
		if (installedVersion !== packageInfo.version) {
			docker(['cp', packageInfo.file, `${project}-wpcli-1:${dest}`]);
			wpcli(['plugin', 'install', dest, '--activate']);
		} else {
			wpcli(['plugin', 'activate', packageInfo.slug]);
		}
		docker(['exec', '-u', '0', `${project}-wpcli-1`, 'rm', '-f', dest]);
		const licenses = { 'simply-gallery-block': 'GPL-2.0', 'stackable-ultimate-gutenberg-blocks': 'GPL-3.0', 'wpforms-lite': 'GPL-2.0-or-later' };
		plugins.push({ slug: packageInfo.slug, version: wpcli(['plugin', 'get', packageInfo.slug, '--field=version']), status: wpcli(['plugin', 'get', packageInfo.slug, '--field=status']), source: packageInfo.source, sha256: packageInfo.sha256, bytes: packageInfo.bytes, license: licenses[packageInfo.slug] });
	}
	wpcli(['option', 'update', 'blog_public', '0']);
	wpcli(['option', 'update', 'show_avatars', '0']);
	wpcli(['rewrite', 'structure', '/%postname%/']);
	wpcli(['rewrite', 'flush', '--hard']);
	const result = {
		gate: 'G3CR2R3_BLOCKSY_WEDDING_IMPORT_WOOCOMMERCE_CANARY',
		wordpress: wpcli(['core', 'version']),
		php: docker(['exec', `${project}-wordpress-1`, 'php', '-r', 'echo PHP_VERSION;']),
		mariadb: docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']),
		blocksy: { version: wpcli(['theme', 'get', 'blocksy', '--field=version']), status: wpcli(['theme', 'get', 'blocksy', '--field=status']), source: blocksy.source, sha256: blocksy.sha256, bytes: blocksy.bytes, license: 'GPL-2.0-or-later' },
		companion: { version: wpcli(['plugin', 'get', 'blocksy-companion', '--field=version']), status: wpcli(['plugin', 'get', 'blocksy-companion', '--field=status']), source: companion.source, sha256: companion.sha256, bytes: companion.bytes, license: 'GPL-2.0-or-later' },
		dependencies: plugins,
		runtime: { composeProject: project, wordpressUrl: 'http://127.0.0.1:8187', phpVersion: docker(['exec', `${project}-wordpress-1`, 'php', '-r', 'echo PHP_VERSION;']) },
		passwordPersistedInEvidence: false,
	};
	fs.writeFileSync(path.join(reportDir, 'runtime-install.json'), `${JSON.stringify(result, null, 2)}\n`);
	for (const packageInfo of [blocksy, companion, ...dependencyPackages]) fs.rmSync(packageInfo.file, { force: true });
	console.log(JSON.stringify({ setup: 'PASS', wordpress: result.wordpress, blocksy: result.blocksy.version, companion: result.companion.version, dependencies: plugins }));
}

main().catch((error) => {
	console.error(error.stderr ? error.stderr.toString().trim() : error.message);
	process.exitCode = 1;
});
