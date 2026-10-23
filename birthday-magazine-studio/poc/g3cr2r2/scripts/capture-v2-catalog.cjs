const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const base = path.join(repoRoot, 'birthday-magazine-studio/poc/g3cr2r2');
const composeFile = path.join(base, 'compose.yaml');
const reports = path.join(base, 'artifacts/reports');
const project = 'birthday-magazine-g3cr2r2';

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024, stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function sanitize(value, key = '') {
	if (/(?:api.?key|secret|password|authorization|cookie|access.?token|refresh.?token|session|license_id|install_id)/i.test(key)) return '[REDACTED]';
	if (Array.isArray(value)) return value.map((item) => sanitize(item));
	if (value && typeof value === 'object') return Object.fromEntries(Object.entries(value).map(([childKey, childValue]) => [childKey, sanitize(childValue, childKey)]));
	if (typeof value === 'string' && /^https?:\/\//i.test(value) && /[?&](?:api.?key|secret|token|cookie|license_id|install_id)=/i.test(value)) {
		return value.replace(/([?&](?:api.?key|secret|token|cookie|license_id|install_id)=)[^&#]*/ig, '$1[REDACTED]');
	}
	return value;
}

function findWeddingRecords(value, found = []) {
	if (Array.isArray(value)) {
		for (const item of value) findWeddingRecords(item, found);
	} else if (value && typeof value === 'object') {
		if (value.name === 'Wedding') found.push(value);
		for (const [key, child] of Object.entries(value)) if (key !== 'name') findWeddingRecords(child, found);
	}
	return found;
}

function main() {
	const stdout = docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', 'eval-file', '/opt/g3cr2r2/scripts/query-v2-catalog.php']);
	const query = JSON.parse(stdout);
	fs.mkdirSync(reports, { recursive: true });
	const sourceJson = query.response_json;
	const variants = sourceJson === null ? [] : findWeddingRecords(sourceJson);
	const gutenberg = variants.filter((record) => typeof record.builder === 'string' && record.builder.toLowerCase() === 'gutenberg');
	const report = {
		capturedAtUtc: new Date().toISOString(),
		gate: 'G3CR2R2_BLOCKSY_WEDDING_V2_CATALOG_CLOSURE',
		request: { url: 'https://startersites.io?route=v2/demo/get_all&companion_version=2.1.57', method: 'GET', caller: 'WordPress wp_remote_get()', authParametersSent: false },
		http_status: query.http_status,
		wp_error: query.wp_error,
		response_body_bytes: query.response_body_bytes,
		response_body_sha256: query.response_body_sha256,
		json_decoded: query.json_decoded,
		json_error: query.json_error ?? null,
		catalog_json: sanitize(sourceJson),
		wedding_variants: variants.map((record) => sanitize(record)),
		wedding_variant_count: variants.length,
		wedding_gutenberg_record_count: gutenberg.length,
		wedding_gutenberg_records: gutenberg.map((record) => sanitize(record)),
		query_success: query.http_status === 200 && query.wp_error === null && query.json_decoded === true,
	};
	fs.writeFileSync(path.join(reports, 'v2-catalog-response.json'), `${JSON.stringify(report, null, 2)}\n`, 'utf8');
	fs.writeFileSync(path.join(reports, 'wedding-variants.json'), `${JSON.stringify({ requested_demo: 'Wedding', variants: report.wedding_variants, exact_gutenberg_records: report.wedding_gutenberg_records }, null, 2)}\n`, 'utf8');
	console.log(JSON.stringify({ httpStatus: report.http_status, wpError: report.wp_error && { code: report.wp_error.code, message: report.wp_error.message }, jsonDecoded: report.json_decoded, weddingVariantCount: variants.length, weddingBuilders: variants.map((record) => record.builder ?? null), gutenbergRecordCount: gutenberg.length, gutenbergPlugins: gutenberg.length === 1 ? gutenberg[0].plugins ?? null : null, report: 'poc/g3cr2r2/artifacts/reports/v2-catalog-response.json' }));
}

main();
