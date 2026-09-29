const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const reports = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports');
const project = 'birthday-magazine-g3c';

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function rows(format) {
	const result = docker(format.args);
	return result ? result.split(/\r?\n/).filter(Boolean).sort() : [];
}

function digestRows(values) {
	return { count: values.length, sha256: crypto.createHash('sha256').update([...values].sort().join('\n')).digest('hex') };
}

function capture(stage) {
	const allContainers = rows({ args: ['ps', '-a', '--format', '{{.ID}}|{{.Names}}|{{.Status}}|{{.Ports}}'] });
	const volumes = rows({ args: ['volume', 'ls', '--format', '{{.Name}}'] });
	const networks = rows({ args: ['network', 'ls', '--format', '{{.ID}}|{{.Name}}|{{.Driver}}|{{.Scope}}'] });
	const images = rows({ args: ['image', 'ls', '--format', '{{.ID}}|{{.Repository}}:{{.Tag}}'] });
	const ownContainerPrefix = `${project}-`;
	const ownVolumePrefix = `${project}_`;
	const ownNetworkPrefix = `${project}_`;
	const unrelatedContainers = allContainers.filter((row) => !row.split('|')[1]?.startsWith(ownContainerPrefix));
	const unrelatedVolumes = volumes.filter((name) => !name.startsWith(ownVolumePrefix));
	const unrelatedNetworks = networks.filter((row) => !row.split('|')[1]?.startsWith(ownNetworkPrefix));
	const unrelatedStableContainers = unrelatedContainers.map((row) => {
		const [id, name, , ports = ''] = row.split('|');
		return [id, name, ports].join('|');
	});
	const status = {
		capturedAtUtc: new Date().toISOString(),
		stage,
		dockerClientServerVersion: docker(['version', '--format', '{{.Client.Version}}|{{.Server.Version}}']),
		composeVersion: docker(['compose', 'version', '--short']),
		projectResources: {
			containers: allContainers.filter((row) => row.split('|')[1]?.startsWith(ownContainerPrefix)),
			volumes: volumes.filter((name) => name.startsWith(ownVolumePrefix)),
			networks: networks.filter((row) => row.split('|')[1]?.startsWith(ownNetworkPrefix)),
		},
		unrelatedResourceFingerprint: {
			containers: digestRows(unrelatedStableContainers),
			volumes: digestRows(unrelatedVolumes),
			networks: digestRows(unrelatedNetworks),
		},
		images: digestRows(images),
	};
	return status;
}

const [stage] = process.argv.slice(2);
if (!['before', 'after'].includes(stage)) throw new Error('Pass exactly one stage: before or after.');
fs.mkdirSync(reports, { recursive: true });
const snapshot = capture(stage);
fs.writeFileSync(path.join(reports, `docker-inventory-${stage}.json`), `${JSON.stringify(snapshot, null, 2)}\n`, 'utf8');
console.log(JSON.stringify({ stage, projectContainers: snapshot.projectResources.containers.length, projectVolumes: snapshot.projectResources.volumes.length, projectNetworks: snapshot.projectResources.networks.length, unrelatedContainerCount: snapshot.unrelatedResourceFingerprint.containers.length }));
