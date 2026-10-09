const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const project = 'birthday-magazine-g3c';
const relativeTmp = 'birthday-magazine-studio/poc/g3c/.tmp';
const tmpPath = path.resolve(repoRoot, relativeTmp);
const expectedTmp = path.resolve(repoRoot, 'birthday-magazine-studio/poc/g3c/.tmp');
const reportsPath = path.resolve(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports');

function run(command, args) {
	return execFileSync(command, args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function readSnapshot(stage) {
	run(process.execPath, [path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/scripts/capture-docker-inventory.cjs'), stage]);
	return JSON.parse(fs.readFileSync(path.join(reportsPath, `docker-inventory-${stage}.json`), 'utf8'));
}

function stableFingerprint(inventory) {
	const stable = (values, normalize) => {
		if (!Array.isArray(values)) return values;
		const normalized = values.map(normalize).sort();
		return {
			count: normalized.length,
			sha256: require('node:crypto').createHash('sha256').update(normalized.join('\n')).digest('hex'),
		};
	};
	return {
		containers: stable(inventory.containers, (row) => {
			if (!row.includes('|')) return row;
			const [id, name, , ports = ''] = row.split('|');
			return [id, name, ports].join('|');
		}),
		volumes: stable(inventory.volumes, (row) => row),
		networks: stable(inventory.networks, (row) => row),
	};
}

if (tmpPath !== expectedTmp) throw new Error('Temporary path did not resolve to the exact approved target.');
const relativeResolved = path.relative(repoRoot, tmpPath);
if (!relativeResolved || relativeResolved.startsWith('..') || path.isAbsolute(relativeResolved)) throw new Error('Temporary path escapes the repository.');
const ignoreResult = require('node:child_process').spawnSync('git', ['check-ignore', '-q', '--', `${relativeTmp}/`], { cwd: repoRoot });
if (ignoreResult.status !== 0) throw new Error('Temporary directory is not ignored by Git.');

const before = JSON.parse(fs.readFileSync(path.join(reportsPath, 'docker-inventory-before.json'), 'utf8'));
if (before.stage !== 'before') throw new Error('Expected a pre-G3C Docker inventory snapshot.');
let removedTempFileCount = 0;
if (fs.existsSync(tmpPath)) {
	const tmpStat = fs.lstatSync(tmpPath);
	if (!tmpStat.isDirectory() || tmpStat.isSymbolicLink()) throw new Error('Temporary path is not a plain directory.');
	const allowedFiles = ['admin-password.txt', 'starter-onboarding.js'].sort();
	const actualFiles = fs.readdirSync(tmpPath).sort();
	if (actualFiles.join('\0') !== allowedFiles.join('\0')) throw new Error(`Unexpected temporary contents: ${actualFiles.join(', ')}`);
	for (const name of actualFiles) {
		const filePath = path.join(tmpPath, name);
		const stat = fs.lstatSync(filePath);
		if (!stat.isFile() || stat.isSymbolicLink()) throw new Error(`Temporary entry is not a plain file: ${name}`);
	}
	removedTempFileCount = actualFiles.length;
	for (const name of actualFiles) fs.unlinkSync(path.join(tmpPath, name));
	fs.rmdirSync(tmpPath);
} else {
	const previous = JSON.parse(fs.readFileSync(path.join(reportsPath, 'cleanup-readback.json'), 'utf8'));
	if (previous.temporaryDirectory?.path !== relativeTmp || previous.temporaryDirectory?.existsAfterCleanup !== false) {
		throw new Error('Temporary directory is absent without a matching prior guarded cleanup read-back.');
	}
	removedTempFileCount = previous.temporaryDirectory.removedFileCount;
}

run('docker', ['compose', '-p', project, '-f', 'birthday-magazine-studio/poc/g3c/compose.yaml', 'down', '--volumes', '--remove-orphans']);
const after = readSnapshot('after');
const beforeStableFingerprint = stableFingerprint(before.unrelatedResourceFingerprint);
const afterStableFingerprint = stableFingerprint(after.unrelatedResourceFingerprint);
const fingerprintUnchanged = JSON.stringify(beforeStableFingerprint) === JSON.stringify(afterStableFingerprint);
before.unrelatedResourceFingerprint = beforeStableFingerprint;
const imageFingerprint = (images) => Array.isArray(images) ? {
	count: images.length,
	sha256: require('node:crypto').createHash('sha256').update(images.slice().sort().join('\n')).digest('hex'),
} : images;
before.images = imageFingerprint(before.images);
after.images = imageFingerprint(after.images);
fs.writeFileSync(path.join(reportsPath, 'docker-inventory-before.json'), `${JSON.stringify(before, null, 2)}\n`, 'utf8');
fs.writeFileSync(path.join(reportsPath, 'docker-inventory-after.json'), `${JSON.stringify(after, null, 2)}\n`, 'utf8');
const projectResources = after.projectResources;
const projectResourcesGone = projectResources.containers.length === 0 && projectResources.volumes.length === 0 && projectResources.networks.length === 0;
const cleanup = {
	capturedAtUtc: new Date().toISOString(),
	gate: 'G3C_UI_UX_PRODUCTIZATION',
	cleanupScope: 'exact project compose down --volumes --remove-orphans; no global prune',
	temporaryDirectory: {
		path: relativeTmp,
		insideRepository: true,
		gitIgnored: true,
		notSymlinkOrReparsePoint: true,
		removedFileCount: removedTempFileCount,
		existsAfterCleanup: fs.existsSync(tmpPath),
	},
	projectResourcesAfter: projectResources,
	projectResourcesGone,
	unrelatedFingerprintBasis: 'container ID|name|published ports; volume name; network ID|name|driver|scope (container uptime/status excluded)',
	unrelatedFingerprintCounts: Object.fromEntries(Object.entries(beforeStableFingerprint).map(([key, values]) => [key, { before: values.length, after: afterStableFingerprint[key].length }])),
	unrelatedDockerResourceFingerprintUnchanged: fingerprintUnchanged,
	forbiddenActions: {
		globalPrune: false,
		paypalOrPayment: 0,
		productionAi: 0,
		sharedInfrastructureMutation: 0,
	},
};
fs.writeFileSync(path.join(reportsPath, 'cleanup-readback.json'), `${JSON.stringify(cleanup, null, 2)}\n`, 'utf8');
console.log(JSON.stringify({ tmpDirectoryExists: cleanup.temporaryDirectory.existsAfterCleanup, tmpFilesRemoved: removedTempFileCount, projectResourcesGone, unrelatedResourceFingerprintUnchanged: fingerprintUnchanged }));
if (!projectResourcesGone || !fingerprintUnchanged || cleanup.temporaryDirectory.existsAfterCleanup) process.exitCode = 1;
