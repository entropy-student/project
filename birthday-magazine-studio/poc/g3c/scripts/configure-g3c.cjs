const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const project = 'birthday-magazine-g3c';
const composeFile = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/compose.yaml');
const artifacts = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/artifacts/reports');
const tempDir = path.join(repoRoot, 'birthday-magazine-studio/poc/g3c/.tmp');
const baseUrl = 'http://127.0.0.1:8147';

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

function packageHash(file) {
	if (!fs.existsSync(file) || fs.statSync(file).size < 1) throw new Error(`Missing official package ${path.basename(file)}. Run scripts/download-packages-g3c.ps1 first.`);
	return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}

function installPackage(packagePath, containerName, installArgs) {
	docker(['cp', packagePath, `${containerName}:/tmp/${path.basename(packagePath)}`]);
	try {
		wp(installArgs.map((value) => value.replace('{package}', `/tmp/${path.basename(packagePath)}`)));
	} finally {
		docker(['exec', '-u', '0', containerName, 'rm', '-f', `/tmp/${path.basename(packagePath)}`]);
	}
}

function createPage(title, slug, content) {
	return Number(wp(['post', 'create', '--post_type=page', `--post_title=${title}`, `--post_name=${slug}`, '--post_status=publish', `--post_content=${content}`, '--porcelain']));
}

function pageId(optionName, title, slug, content) {
	try {
		const current = Number(wp(['option', 'get', optionName]));
		if (current > 0) return current;
	} catch { /* Create the standard WooCommerce page below. */ }
	const id = createPage(title, slug, content);
	wp(['option', 'update', optionName, String(id)]);
	return id;
}

function main() {
	fs.mkdirSync(tempDir, { recursive: true });
	fs.mkdirSync(artifacts, { recursive: true });
	const runtime = {
		gate: 'G3C_UI_UX_PRODUCTIZATION',
		startedAtUtc: new Date().toISOString(),
		wordpressImage: 'wordpress:7.1.1-php8.3-apache',
		mariadbImage: 'mariadb:11.4.7',
		mailpitImage: 'axllent/mailpit:v1.31.2',
		components: {},
	};
	const wpContainer = `${project}-wpcli-1`;

	const wooZip = path.join(tempDir, 'woocommerce.11.1.2.zip');
	const wooUrl = 'https://downloads.wordpress.org/plugin/woocommerce.11.1.2.zip';
	runtime.components.woocommercePackage = { version: '11.1.2', source: wooUrl, license: 'GPL-3.0-or-later', sha256: packageHash(wooZip) };
	let installedWoo = '';
	try { installedWoo = wp(['plugin', 'get', 'woocommerce', '--field=version']); } catch { /* Install from the exact official package below. */ }
	if (installedWoo !== '11.1.2') installPackage(wooZip, wpContainer, ['plugin', 'install', '{package}', '--activate']);
	fs.rmSync(wooZip, { force: true });
	if (wp(['plugin', 'get', 'woocommerce', '--field=version']) !== '11.1.2') throw new Error('Installed WooCommerce is not the G3A-accepted 11.1.2 baseline.');

	const astraZip = path.join(tempDir, 'astra.4.13.11.zip');
	const astraUrl = 'https://downloads.wordpress.org/theme/astra.4.13.11.zip';
	runtime.components.astra = { version: '4.13.11', source: astraUrl, license: 'GPL-2.0-or-later', sha256: packageHash(astraZip), freeBoundary: 'official WordPress.org free theme; commercial Astra Pro not used' };
	installPackage(astraZip, wpContainer, ['theme', 'install', '{package}', '--activate']);
	fs.rmSync(astraZip, { force: true });
	if (wp(['theme', 'get', 'astra', '--field=version']) !== '4.13.11') throw new Error('Installed Astra version does not match the verified official free package.');

	const starterZip = path.join(tempDir, 'astra-sites.4.7.7.zip');
	const starterUrl = 'https://downloads.wordpress.org/plugin/astra-sites.4.7.7.zip';
	runtime.components.starterTemplates = { version: '4.7.7', source: starterUrl, license: 'GPL-2.0-or-later', sha256: packageHash(starterZip), freeBoundary: 'official WordPress.org plugin; free Gutenberg template import, no paid component' };
	installPackage(starterZip, wpContainer, ['plugin', 'install', '{package}', '--activate']);
	fs.rmSync(starterZip, { force: true });
	if (wp(['plugin', 'get', 'astra-sites', '--field=version']) !== '4.7.7') throw new Error('Installed Starter Templates version does not match the verified official free package.');

	wp(['plugin', 'activate', 'bms-g3c-preview', 'bms-g3c-commerce-loop']);
	wp(['config', 'set', 'BMS_G3C_LOCAL_ONLY', 'true', '--raw']);
	wp(['config', 'set', 'BMS_G3C_GENERATION_ENABLED', 'false', '--raw']);
	wp(['option', 'update', 'blog_public', '0']);
	wp(['option', 'update', 'blogname', 'Birthday Magazine Studio']);
	wp(['rewrite', 'structure', '/%postname%/']);
	wp(['rewrite', 'flush', '--hard']);

	const pages = {
		shop: pageId('woocommerce_shop_page_id', 'Shop', 'shop', '[products columns="2" limit="12"]'),
		cart: pageId('woocommerce_cart_page_id', 'Cart', 'cart', '[woocommerce_cart]'),
		checkout: pageId('woocommerce_checkout_page_id', 'Checkout', 'checkout', '[woocommerce_checkout]'),
		account: pageId('woocommerce_myaccount_page_id', 'My Account', 'my-account', '[woocommerce_my_account]'),
	};
	for (const [key, id] of Object.entries(pages)) {
		const optionName = key === 'account' ? 'woocommerce_myaccount_page_id' : `woocommerce_${key}_page_id`;
		wp(['option', 'update', optionName, String(id)]);
	}
	const options = {
		woocommerce_currency: 'USD',
		woocommerce_price_num_decimals: '2',
		woocommerce_default_country: 'US:CA',
		woocommerce_coming_soon: 'no',
		woocommerce_store_pages_only: 'no',
		woocommerce_store_address: '1 Synthetic Lane',
		woocommerce_store_city: 'Testville',
		woocommerce_store_postcode: '94103',
		woocommerce_calc_taxes: 'no',
		woocommerce_enable_guest_checkout: 'no',
		woocommerce_enable_signup_and_login_from_checkout: 'yes',
		woocommerce_enable_myaccount_registration: 'no',
		woocommerce_registration_generate_username: 'yes',
		woocommerce_registration_generate_password: 'yes',
	};
	for (const [name, value] of Object.entries(options)) wp(['option', 'update', name, value]);
	wp(['option', 'update', 'show_avatars', '0']);
	const productId = Number(wp(['eval', '$p = new WC_Product_Simple(); $p->set_name("Birthday Magazine — G3C Synthetic Preview"); $p->set_status("publish"); $p->set_catalog_visibility("visible"); $p->set_regular_price("39.99"); $p->set_virtual(true); $p->set_manage_stock(false); $p->set_tax_status("none"); $p->set_description("Local synthetic product-page proof. The checkout is not submitted and no payment is collected."); echo $p->save();']));
	wp(['option', 'update', 'bms_g3c_product_id', String(productId)]);
	wp(['option', 'update', 'bms_g3c_generation_job_count', '0']);
	wp(['option', 'update', 'bms_g3c_model_call_count', '0']);
	const pluginNames = wp(['plugin', 'list', '--field=name']).split(/\r?\n/).filter(Boolean);
	if (pluginNames.some((name) => /paypal|ppcp/i.test(name))) throw new Error('A PayPal/PPCP plugin is unexpectedly installed.');

	runtime.wordpress = wp(['core', 'version']);
	runtime.phpCli = docker(['exec', `${project}-wordpress-1`, 'php', '-r', 'echo PHP_VERSION;']);
	runtime.woocommerce = wp(['plugin', 'get', 'woocommerce', '--field=version']);
	runtime.mailpit = '1.31.2';
	runtime.mariadbServer = docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']);
	runtime.pages = pages;
	runtime.product = JSON.parse(wp(['eval', '$p = wc_get_product((int) get_option("bms_g3c_product_id")); echo wp_json_encode(["id" => $p->get_id(), "name" => $p->get_name(), "type" => $p->get_type(), "price" => $p->get_price(), "regularPrice" => $p->get_regular_price(), "virtual" => $p->is_virtual(), "downloadable" => $p->is_downloadable(), "manageStock" => $p->managing_stock(), "taxStatus" => $p->get_tax_status(), "needsShipping" => $p->needs_shipping(), "currency" => get_woocommerce_currency()]);']));
	runtime.settings = {
		guestCheckout: wp(['option', 'get', 'woocommerce_enable_guest_checkout']),
		checkoutAccountCreation: wp(['option', 'get', 'woocommerce_enable_signup_and_login_from_checkout']),
		separateMyAccountRegistration: wp(['option', 'get', 'woocommerce_enable_myaccount_registration']),
		localOnly: wp(['eval', 'echo defined("BMS_G3C_LOCAL_ONLY") && BMS_G3C_LOCAL_ONLY === true ? "true" : "false";']),
		generationEnabled: wp(['eval', 'echo defined("BMS_G3C_GENERATION_ENABLED") && BMS_G3C_GENERATION_ENABLED === false ? "false" : "unexpected";']),
		installedPaymentPlugins: pluginNames.filter((name) => /paypal|ppcp/i.test(name)),
	};
	runtime.urls = { home: baseUrl, product: wp(['eval', 'echo get_permalink((int) get_option("bms_g3c_product_id"));']), shop: wp(['option', 'get', 'woocommerce_shop_page_id']) };
	runtime.components.goodIssuePreview = { version: '0.2.0', source: 'G2A1 poc/g2a1/preview-plugin copied into G3C and adapted; browser-local preview retained', license: 'GPL-2.0-or-later' };
	runtime.components.commerceWorkspace = { version: '0.1.0', source: 'G3A poc/g3a/commerce-workspace-plugin copied into G3C; namespace adapted; generation disabled', license: 'GPL-2.0-or-later' };
	runtime.completedAtUtc = new Date().toISOString();
	fs.writeFileSync(path.join(artifacts, 'runtime-setup.json'), `${JSON.stringify(runtime, null, 2)}\n`, 'utf8');
	console.log(JSON.stringify({ setup: 'PASS', wordpress: runtime.wordpress, woocommerce: runtime.woocommerce, astra: runtime.components.astra.version, starterTemplates: runtime.components.starterTemplates.version, productId, paypalPlugins: runtime.settings.installedPaymentPlugins.length }));
}

try {
	main();
} catch (error) {
	console.error(error.stderr ? error.stderr.toString().trim() : error.message);
	process.exitCode = 1;
}
