const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const base = path.join(repoRoot, 'birthday-magazine-studio/poc/g3cr2r2');
const composeFile = path.join(base, 'compose.yaml');
const tmp = path.join(base, '.tmp');
const reports = path.join(base, 'artifacts/reports');
const project = 'birthday-magazine-g3cr2r2';
const wpCli = `${project}-wpcli-1`;

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', maxBuffer: 16 * 1024 * 1024, stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

function main() {
	const themeZip = path.join(tmp, 'blocksy.2.1.57.zip');
	const companionZip = path.join(tmp, 'blocksy-companion.2.1.57.zip');
	if (!fs.existsSync(themeZip) || !fs.existsSync(companionZip)) throw new Error('Official Blocksy package files are missing from the guarded local .tmp directory.');

	const adminPassword = `${crypto.randomBytes(28).toString('base64url')}Aa7!`;
	try {
		wp(['core', 'is-installed']);
	} catch {
		wp(['core', 'install', '--url=http://127.0.0.1:8177', '--title=Birthday Magazine G3CR2R2 Synthetic Local', '--admin_user=g3cr2r2-admin', `--admin_password=${adminPassword}`, '--admin_email=site-admin@birthday.invalid', '--skip-email']);
	}
	adminPassword.replace(/./g, '\0');
	wp(['config', 'set', 'BMS_G3A_LOCAL_ONLY', 'true', '--raw']);
	wp(['config', 'set', 'BMS_G3A_GENERATION_ENABLED', 'false', '--raw']);
	wp(['option', 'update', 'blog_public', '0']);
	wp(['option', 'update', 'show_avatars', '0']);
	docker(['cp', themeZip, `${wpCli}:/tmp/blocksy.2.1.57.zip`]);
	docker(['cp', companionZip, `${wpCli}:/tmp/blocksy-companion.2.1.57.zip`]);
	wp(['theme', 'install', '/tmp/blocksy.2.1.57.zip', '--force']);
	wp(['plugin', 'install', '/tmp/blocksy-companion.2.1.57.zip', '--activate']);
	docker(['exec', '-u', '0', wpCli, 'rm', '-f', '/tmp/blocksy.2.1.57.zip', '/tmp/blocksy-companion.2.1.57.zip']);
	wp(['theme', 'activate', 'blocksy']);
	wp(['plugin', 'activate', 'blocksy-companion']);

	const theme = JSON.parse(wp(['theme', 'get', 'blocksy', '--format=json']));
	const companion = JSON.parse(wp(['plugin', 'get', 'blocksy-companion', '--format=json']));
	const runtime = {
		capturedAtUtc: new Date().toISOString(),
		gate: 'G3CR2R2_BLOCKSY_WEDDING_V2_CATALOG_CLOSURE',
		wordpress: wp(['core', 'version']),
		php: docker(['exec', wpCli, 'php', '-r', 'echo PHP_VERSION;']),
		wpCli: docker(['exec', wpCli, 'wp', '--version', '--allow-root']),
		mariadb: docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']),
		theme: { name: 'Blocksy', version: theme.version, status: theme.status, source: 'https://downloads.wordpress.org/theme/blocksy.2.1.57.zip', sha256: crypto.createHash('sha256').update(fs.readFileSync(themeZip)).digest('hex'), license: 'GNU General Public License v2 or later' },
		companion: { name: 'Blocksy Companion', version: companion.version, status: companion.status, source: 'https://downloads.wordpress.org/plugin/blocksy-companion.2.1.57.zip', sha256: crypto.createHash('sha256').update(fs.readFileSync(companionZip)).digest('hex'), license: 'GPLv2 or later' },
		otherPlugins: JSON.parse(wp(['plugin', 'list', '--format=json'])).map((plugin) => ({ name: plugin.name, status: plugin.status, version: plugin.version })),
		secretsPersisted: false,
	};
	if (runtime.wordpress !== '7.1.1' || runtime.mariadb.split('-')[0] !== '11.4.7' || theme.version !== '2.1.57' || companion.version !== '2.1.57' || theme.status !== 'active' || companion.status !== 'active') {
		throw new Error('Runtime version/activation read-back did not match the frozen G3CR2 baseline.');
	}
	fs.mkdirSync(reports, { recursive: true });
	fs.writeFileSync(path.join(reports, 'runtime-versions.json'), `${JSON.stringify(runtime, null, 2)}\n`, 'utf8');
	console.log(JSON.stringify({ result: 'PASS', wordpress: runtime.wordpress, mariadb: runtime.mariadb, blocksy: theme.version, companion: companion.version, activePlugins: runtime.otherPlugins.filter((plugin) => plugin.status === 'active').map((plugin) => plugin.name) }));
}

main();
