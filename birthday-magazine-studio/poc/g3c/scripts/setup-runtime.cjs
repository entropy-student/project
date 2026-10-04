const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const projectRoot = path.resolve(__dirname, '..');
const composeFile = path.join(projectRoot, 'compose.yaml');
const tempDir = path.join(projectRoot, '.tmp');
const credentialFile = path.join(tempDir, 'local-owner-admin.json');
const project = 'birthday-magazine-g3c';
const baseUrl = 'http://127.0.0.1:8189';
const wpcli = `${project}-wpcli-1`;

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

function hasUser(login) {
	try {
		return wp(['user', 'get', login, '--field=ID']).trim().length > 0;
	} catch {
		return false;
	}
}

function waitForWpcli() {
	for (let attempt = 0; attempt < 60; attempt += 1) {
		try {
			docker(['exec', wpcli, 'sh', '-lc', 'test -f /var/www/html/wp-includes/version.php']);
			return;
		} catch {
			Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000);
		}
	}
	throw new Error('WordPress files did not become available in the isolated G3C runtime.');
}

function installCore() {
	try {
		wp(['core', 'is-installed']);
	} catch {
		fs.mkdirSync(tempDir, { recursive: true });
		const password = `${crypto.randomBytes(24).toString('base64url')}Aa7!`;
		wp([
			'core', 'install',
			`--url=${baseUrl}`,
			'--title=Birthday Magazine Studio — Local Owner Review',
			'--admin_user=bms-owner',
			`--admin_password=${password}`,
			'--admin_email=owner@birthday.invalid',
			'--skip-email',
		]);
		fs.writeFileSync(credentialFile, JSON.stringify({ user: 'bms-owner', password }), { mode: 0o600 });
	}

	if (!hasUser('bms-owner')) {
		const password = `${crypto.randomBytes(24).toString('base64url')}Aa7!`;
		wp(['user', 'create', 'bms-owner', 'owner@birthday.invalid', `--user_pass=${password}`, '--role=administrator']);
		fs.mkdirSync(tempDir, { recursive: true });
		fs.writeFileSync(credentialFile, JSON.stringify({ user: 'bms-owner', password }), { mode: 0o600 });
	}
	wp(['user', 'set-role', 'bms-owner', 'administrator']);
}

function installVersionedAssets() {
	wp(['theme', 'install', 'blocksy', '--version=2.1.57', '--activate']);
	wp(['plugin', 'install', 'blocksy-companion', '--version=2.1.57', '--activate']);
	wp(['plugin', 'install', 'simply-gallery-block', '--version=3.4.3', '--activate']);
	wp(['plugin', 'install', 'stackable-ultimate-gutenberg-blocks', '--version=3.20.2', '--activate']);
	wp(['plugin', 'install', 'wpforms-lite', '--version=2.0.2.1', '--activate']);
	wp(['plugin', 'install', 'woocommerce', '--version=11.1.2', '--activate']);
	wp(['plugin', 'activate', 'bms-g3c-preview', 'bms-g3a-commerce-loop']);
	wp(['config', 'set', 'BMS_G3A_LOCAL_ONLY', 'true', '--raw']);
	wp(['config', 'set', 'BMS_G3A_GENERATION_ENABLED', 'false', '--raw']);
	wp(['option', 'update', 'blog_public', '0']);
	wp(['option', 'update', 'show_avatars', '0']);
	wp(['rewrite', 'structure', '/%postname%/']);
	wp(['rewrite', 'flush', '--hard']);
}

function runtimeReadback() {
	const pluginSlugs = [
		'bms-g3c-preview', 'bms-g3a-commerce-loop', 'blocksy-companion',
		'simply-gallery-block', 'stackable-ultimate-gutenberg-blocks', 'wpforms-lite', 'woocommerce',
	];
	const plugins = pluginSlugs.map((slug) => ({
		slug,
		version: wp(['plugin', 'get', slug, '--field=version']),
		status: wp(['plugin', 'get', slug, '--field=status']),
	}));
	const result = {
		gate: 'G3C_BLOCKSY_WEDDING_PRODUCTIZATION',
		localUrl: baseUrl,
		adminUrl: `${baseUrl}/wp-admin/`,
		wordpress: wp(['core', 'version']),
		php: docker(['exec', `${project}-wordpress-1`, 'php', '-r', 'echo PHP_VERSION;']),
		mariadb: docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']),
		blocksy: wp(['theme', 'get', 'blocksy', '--field=version']),
		woocommerce: wp(['plugin', 'get', 'woocommerce', '--field=version']),
		owner: { login: 'bms-owner', role: wp(['user', 'get', 'bms-owner', '--field=roles']) },
		activePlugins: plugins,
		localOnly: wp(['eval', 'echo defined("BMS_G3A_LOCAL_ONLY") && BMS_G3A_LOCAL_ONLY === true ? "true" : "false";']),
		generationEnabled: wp(['eval', 'echo defined("BMS_G3A_GENERATION_ENABLED") && BMS_G3A_GENERATION_ENABLED === false ? "false" : "unexpected";']),
		credentialValuePersistedInReport: false,
	};
	const reportDir = path.join(projectRoot, 'artifacts/reports');
	fs.mkdirSync(reportDir, { recursive: true });
	fs.writeFileSync(path.join(reportDir, 'runtime-setup.json'), `${JSON.stringify(result, null, 2)}\n`, 'utf8');
	console.log(JSON.stringify({ setup: 'PASS', ownerAccount: 'bms-owner administrator exists', credentialsWrittenToIgnoredLocalFile: fs.existsSync(credentialFile), activePluginCount: plugins.length, wordpress: result.wordpress, woocommerce: result.woocommerce }));
}

function main() {
	waitForWpcli();
	installCore();
	installVersionedAssets();
	runtimeReadback();
}

try {
	main();
} catch (error) {
	console.error(error.stderr ? error.stderr.toString().trim() : error.message);
	process.exitCode = 1;
}
