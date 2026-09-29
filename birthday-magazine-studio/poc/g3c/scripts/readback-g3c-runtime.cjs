const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const project = 'birthday-magazine-g3c';
const composeFile = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/compose.yaml');
const reportPath = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports/runtime-final-readback.json');
const setupPath = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports/runtime-setup.json');

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

const facts = JSON.parse(wp(['eval', '$p = wc_get_product((int) get_option("bms_g3c_product_id")); $active = (array) get_option("active_plugins", []); echo wp_json_encode(["wordpress" => get_bloginfo("version"), "php" => PHP_VERSION, "woocommerce" => WC()->version, "astra" => wp_get_theme("astra")->get("Version"), "localOnly" => defined("BMS_G3C_LOCAL_ONLY") && BMS_G3C_LOCAL_ONLY === true, "generationEnabled" => defined("BMS_G3C_GENERATION_ENABLED") ? BMS_G3C_GENERATION_ENABLED : null, "activePlugins" => $active, "paypalActive" => array_values(array_filter($active, static fn($plugin) => stripos($plugin, "paypal") !== false || stripos($plugin, "ppcp") !== false)), "generationJobCount" => (int) get_option("bms_g3c_generation_job_count", 0), "modelCallCount" => (int) get_option("bms_g3c_model_call_count", 0), "product" => $p ? ["id" => $p->get_id(), "type" => $p->get_type(), "price" => $p->get_price(), "virtual" => $p->is_virtual(), "currency" => get_woocommerce_currency(), "url" => get_permalink($p->get_id())] : null]);']));
const containerRows = docker(['ps', '--filter', `name=${project}`, '--format', '{{.Names}}|{{.Status}}|{{.Ports}}']).split(/\r?\n/).filter(Boolean).sort();
const mariadb = docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']);
facts.starterTemplates = wp(['plugin', 'get', 'astra-sites', '--field=version']);
const result = {
	capturedAtUtc: new Date().toISOString(),
	project,
	composeFile: 'birthday-magazine-studio/poc/g3c/compose.yaml',
	versions: { ...facts, mariadb, mailpit: '1.31.2' },
	projectContainers: containerRows,
	exposure: { wordpressBind: '127.0.0.1:8147', mailpitBind: '127.0.0.1:8148', mariadbHostPortPublished: false },
	initialWpCliFlagReadback: { localOnly: false, generationEnabled: null, cause: 'WORDPRESS_CONFIG_EXTRA was not provided to the wpcli service' },
	flagCorrection: 'wp config set BMS_G3C_LOCAL_ONLY true --raw; wp config set BMS_G3C_GENERATION_ENABLED false --raw',
};
fs.mkdirSync(path.dirname(reportPath), { recursive: true });
fs.writeFileSync(reportPath, `${JSON.stringify(result, null, 2)}\n`, 'utf8');
const setup = JSON.parse(fs.readFileSync(setupPath, 'utf8'));
setup.settings.localOnly = facts.localOnly;
setup.settings.generationEnabled = facts.generationEnabled;
setup.settings.installedPaymentPlugins = facts.paypalActive;
setup.initialWpCliFlagReadback = result.initialWpCliFlagReadback;
setup.finalReadBack = { capturedAtUtc: result.capturedAtUtc, source: 'artifacts/reports/runtime-final-readback.json' };
fs.writeFileSync(setupPath, `${JSON.stringify(setup, null, 2)}\n`, 'utf8');
console.log(JSON.stringify({ wordpress: facts.wordpress, woocommerce: facts.woocommerce, astra: facts.astra, starterTemplates: facts.starterTemplates, localOnly: facts.localOnly, generationEnabled: facts.generationEnabled, paypalActiveCount: facts.paypalActive.length, product: facts.product, containers: containerRows.length }));
