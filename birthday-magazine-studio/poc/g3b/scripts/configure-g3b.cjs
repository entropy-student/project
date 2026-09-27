const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const repoRoot = path.resolve(__dirname, '../../../..');
const composeFile = path.join(repoRoot, 'birthday-magazine-studio/poc/g3b/compose.yaml');
const zipPath = path.join(repoRoot, 'birthday-magazine-studio/poc/g3b/.tmp/woocommerce.11.1.2.zip');
const artifacts = path.join(repoRoot, 'birthday-magazine-studio/poc/g3b/artifacts');
const project = 'birthday-magazine-g3b';
const container = `${project}-wpcli-1`;

function docker(args) {
	return execFileSync('docker', args, { cwd: repoRoot, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
}

function wp(args) {
	return docker(['compose', '-p', project, '-f', composeFile, 'exec', '-T', 'wpcli', 'wp', ...args]);
}

function setOption(name, value) {
	wp(['option', 'update', name, value]);
}

function createPage(title, slug, content) {
	return Number(wp(['post', 'create', '--post_type=page', `--post_title=${title}`, `--post_name=${slug}`, '--post_status=publish', `--post_content=${content}`, '--porcelain']));
}

function useWooPage(optionName, title, slug, content) {
	let id = 0;
	try { id = Number(wp(['option', 'get', optionName])); } catch { /* WooCommerce page may not exist yet. */ }
	if (id > 0) {
		wp(['post', 'update', String(id), `--post_title=${title}`, `--post_content=${content}`]);
		return id;
	}
	return createPage(title, slug, content);
}

function main() {
	if (!fs.existsSync(zipPath)) throw new Error('Official WooCommerce package is missing from the project-local temporary directory.');
	fs.mkdirSync(artifacts, { recursive: true });
	wp(['config', 'set', 'BMS_G3A_LOCAL_ONLY', 'true', '--raw']);
	wp(['config', 'set', 'BMS_G3A_GENERATION_ENABLED', 'false', '--raw']);
	const packageSha256 = crypto.createHash('sha256').update(fs.readFileSync(zipPath)).digest('hex');
	let woocommerceVersion = '';
	try {
		woocommerceVersion = wp(['plugin', 'get', 'woocommerce', '--field=version']);
	} catch {
		docker(['cp', zipPath, `${container}:/tmp/woocommerce.11.1.2.zip`]);
		wp(['plugin', 'install', '/tmp/woocommerce.11.1.2.zip', '--activate']);
		woocommerceVersion = wp(['plugin', 'get', 'woocommerce', '--field=version']);
	}
	docker(['exec', '-u', '0', container, 'rm', '-f', '/tmp/woocommerce.11.1.2.zip']);
	fs.rmSync(zipPath, { force: true });
	if (woocommerceVersion !== '11.1.2') throw new Error(`Unexpected WooCommerce version: ${woocommerceVersion}`);

	wp(['plugin', 'activate', 'bms-g2a1-preview', 'bms-g3a-commerce-loop']);
	wp(['option', 'update', 'blog_public', '0']);
	wp(['option', 'update', 'blogname', 'Birthday Magazine G3B Synthetic Local']);
	wp(['rewrite', 'structure', '/%postname%/']);
	wp(['rewrite', 'flush', '--hard']);

	const pages = {
		shop: useWooPage('woocommerce_shop_page_id', 'Shop', 'shop', '[products columns="2" limit="12"]'),
		cart: useWooPage('woocommerce_cart_page_id', 'Cart', 'cart', '[woocommerce_cart]'),
		checkout: useWooPage('woocommerce_checkout_page_id', 'Checkout', 'checkout', '[woocommerce_checkout]'),
		account: useWooPage('woocommerce_myaccount_page_id', 'My Account', 'my-account', '[woocommerce_my_account]'),
	};
	for (const [key, pageId] of Object.entries(pages)) {
		const optionName = key === 'account' ? 'woocommerce_myaccount_page_id' : `woocommerce_${key}_page_id`;
		setOption(optionName, String(pageId));
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
	for (const [name, value] of Object.entries(options)) setOption(name, value);
	setOption('show_avatars', '0');

	wp(['eval', '$settings = get_option("woocommerce_cheque_settings", []); $settings["enabled"] = "yes"; $settings["title"] = "Local test only — no payment"; $settings["description"] = "Synthetic G3A local test only; no money is collected."; $settings["instructions"] = "Local test only — no payment."; update_option("woocommerce_cheque_settings", $settings);']);

	const productId = Number(wp(['eval', '$p = new WC_Product_Simple(); $p->set_name("Birthday Magazine — G3B Synthetic Proof"); $p->set_status("publish"); $p->set_catalog_visibility("visible"); $p->set_regular_price("39.99"); $p->set_virtual(true); $p->set_manage_stock(false); $p->set_tax_status("none"); $p->set_description("Synthetic local commerce proof. No money is collected."); echo $p->save();']));
	setOption('bms_g3a_product_id', String(productId));
	const previewPage = createPage('Make a Birthday Magazine Preview', 'birthday-magazine-preview', `[bms_preview product_id=${productId}]`);
	setOption('bms_g3a_preview_page_id', String(previewPage));
	wp(['rewrite', 'flush', '--hard']);

	const product = JSON.parse(wp(['eval', '$p = wc_get_product((int) get_option("bms_g3a_product_id")); echo wp_json_encode(["id" => $p->get_id(), "name" => $p->get_name(), "type" => $p->get_type(), "price" => $p->get_price(), "regularPrice" => $p->get_regular_price(), "virtual" => $p->is_virtual(), "downloadable" => $p->is_downloadable(), "manageStock" => $p->managing_stock(), "taxStatus" => $p->get_tax_status(), "needsShipping" => $p->needs_shipping(), "currency" => get_woocommerce_currency()]);']));
	const runtime = {
		wordpress: wp(['core', 'version']),
		phpCli: docker(['exec', container, 'php', '-r', 'echo PHP_VERSION;']),
		woocommerce: woocommerceVersion,
		mailpit: '1.31.2',
		mariadbServer: docker(['exec', `${project}-db-1`, 'mariadb', '-N', '-uroot', '-e', 'SELECT VERSION();']),
		product,
		pages,
		pageUrls: Object.fromEntries(Object.entries(pages).map(([key, id]) => [key, wp(['eval', `echo get_permalink(${id});`])])),
		previewPage,
		woocommercePackage: {
			version: '11.1.2',
			source: 'https://downloads.wordpress.org/plugin/woocommerce.11.1.2.zip',
			sha256: packageSha256,
			license: 'GPL-3.0-or-later',
			packageRemovedAfterInstall: !fs.existsSync(zipPath),
			containerTemporaryCopyRemoved: docker(['exec', container, 'sh', '-lc', 'test ! -e /tmp/woocommerce.11.1.2.zip && echo yes']) === 'yes',
		},
		settings: {
			guestCheckout: wp(['option', 'get', 'woocommerce_enable_guest_checkout']),
			checkoutAccountCreation: wp(['option', 'get', 'woocommerce_enable_signup_and_login_from_checkout']),
			separateMyAccountRegistration: wp(['option', 'get', 'woocommerce_enable_myaccount_registration']),
			storeComingSoon: wp(['option', 'get', 'woocommerce_coming_soon']),
			storePagesOnly: wp(['option', 'get', 'woocommerce_store_pages_only']),
			localOnly: wp(['eval', 'echo defined("BMS_G3A_LOCAL_ONLY") && BMS_G3A_LOCAL_ONLY === true ? "true" : "false";']),
			generationEnabled: wp(['eval', 'echo defined("BMS_G3A_GENERATION_ENABLED") && BMS_G3A_GENERATION_ENABLED === false ? "false" : "unexpected";']),
			cheque: JSON.parse(wp(['eval', '$s = get_option("woocommerce_cheque_settings"); echo wp_json_encode(["enabled" => $s["enabled"] ?? "no", "title" => $s["title"] ?? ""]);'])),
		},
	};
	fs.writeFileSync(path.join(artifacts, 'runtime-setup.json'), `${JSON.stringify(runtime, null, 2)}\n`, 'utf8');
	console.log(JSON.stringify({ setup: 'PASS', productId, wordpress: runtime.wordpress, woocommerce: runtime.woocommerce, packageRemoved: runtime.woocommercePackage.packageRemovedAfterInstall }));
}

try {
	main();
} catch (error) {
	console.error(error.stderr ? error.stderr.toString().trim() : error.message);
	process.exitCode = 1;
}
