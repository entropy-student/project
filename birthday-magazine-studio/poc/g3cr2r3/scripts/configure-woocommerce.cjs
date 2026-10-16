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
const packagePath = path.join(temp, 'woocommerce.11.1.2.zip');
const docker = (args) => execFileSync('docker', args, { cwd: root, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim();
const wp = (args) => docker(['compose', '-p', project, '-f', compose, 'exec', '-T', 'wpcli', 'wp', ...args]);

function createPage(title, slug, content) {
	return Number(wp(['post', 'create', '--post_type=page', `--post_title=${title}`, `--post_name=${slug}`, '--post_status=publish', `--post_content=${content}`, '--porcelain']));
}

function usePage(optionName, title, slug, content) {
	let id = 0;
	try { id = Number(wp(['option', 'get', optionName])); } catch { /* Create WooCommerce pages below. */ }
	if (id > 0) {
		wp(['post', 'update', String(id), `--post_title=${title}`, `--post_content=${content}`]);
		return id;
	}
	return createPage(title, slug, content);
}

async function main() {
	fs.mkdirSync(temp, { recursive: true });
	fs.mkdirSync(reportDir, { recursive: true });
	if (!fs.existsSync(packagePath)) {
		execFileSync('powershell.exe', ['-NoProfile', '-Command', `Invoke-WebRequest -Uri 'https://downloads.wordpress.org/plugin/woocommerce.11.1.2.zip' -OutFile '${packagePath}' -TimeoutSec 120`], { cwd: root, stdio: ['ignore', 'pipe', 'pipe'] });
	}
	const bytes = fs.readFileSync(packagePath);
	const sha256 = crypto.createHash('sha256').update(bytes).digest('hex');
	const container = `${project}-wpcli-1`;
	const remote = '/tmp/woocommerce.11.1.2.zip';
	docker(['cp', packagePath, `${container}:${remote}`]);
	wp(['plugin', 'install', remote, '--activate']);
	docker(['exec', '-u', '0', container, 'rm', '-f', remote]);
	fs.rmSync(packagePath, { force: true });
	const wooVersion = wp(['plugin', 'get', 'woocommerce', '--field=version']);
	if (wooVersion !== '11.1.2') throw new Error(`Expected WooCommerce 11.1.2; found ${wooVersion}`);
	wp(['config', 'set', 'BMS_G3A_LOCAL_ONLY', 'true', '--raw']);
	wp(['config', 'set', 'BMS_G3A_GENERATION_ENABLED', 'false', '--raw']);
	wp(['plugin', 'activate', 'bms-g3a-commerce-loop']);
	wp(['option', 'update', 'blog_public', '0']);
	wp(['option', 'update', 'show_avatars', '0']);
	wp(['rewrite', 'structure', '/%postname%/']);
	wp(['rewrite', 'flush', '--hard']);
	const pages = {
		shop: usePage('woocommerce_shop_page_id', 'Shop', 'shop', '[products columns="2" limit="12"]'),
		cart: usePage('woocommerce_cart_page_id', 'Cart', 'cart', '[woocommerce_cart]'),
		checkout: usePage('woocommerce_checkout_page_id', 'Checkout', 'checkout', '[woocommerce_checkout]'),
		account: usePage('woocommerce_myaccount_page_id', 'My Account', 'my-account', '[woocommerce_my_account]'),
	};
	for (const [key, id] of Object.entries(pages)) {
		const option = key === 'account' ? 'woocommerce_myaccount_page_id' : `woocommerce_${key}_page_id`;
		wp(['option', 'update', option, String(id)]);
	}
	const options = {
		woocommerce_currency: 'USD',
		woocommerce_price_num_decimals: '2',
		woocommerce_default_country: 'US:CA',
		woocommerce_calc_taxes: 'no',
		woocommerce_enable_guest_checkout: 'no',
		woocommerce_enable_signup_and_login_from_checkout: 'yes',
		woocommerce_enable_myaccount_registration: 'no',
		woocommerce_registration_generate_username: 'yes',
		woocommerce_registration_generate_password: 'yes',
		woocommerce_coming_soon: 'no',
		woocommerce_store_pages_only: 'no',
	};
	for (const [name, value] of Object.entries(options)) wp(['option', 'update', name, value]);
	wp(['eval', '$s = get_option("woocommerce_cheque_settings", []); $s["enabled"] = "yes"; $s["title"] = "Local test only — no payment"; $s["description"] = "Synthetic compatibility canary. No payment is collected."; update_option("woocommerce_cheque_settings", $s);']);
	const productId = Number(wp(['eval', '$p = new WC_Product_Simple(); $p->set_name("Birthday Magazine — G3CR2R3 Synthetic Proof"); $p->set_status("publish"); $p->set_catalog_visibility("visible"); $p->set_regular_price("39.99"); $p->set_virtual(true); $p->set_manage_stock(false); $p->set_tax_status("none"); $p->set_description("Synthetic G3CR2R3 local compatibility canary. No payment is collected."); echo $p->save();']));
	wp(['option', 'update', 'bms_g3cr2r3_product_id', String(productId)]);
	const product = JSON.parse(wp(['eval', '$p = wc_get_product((int) get_option("bms_g3cr2r3_product_id")); echo wp_json_encode(["id" => $p->get_id(), "type" => $p->get_type(), "price" => $p->get_price(), "virtual" => $p->is_virtual(), "needsShipping" => $p->needs_shipping(), "currency" => get_woocommerce_currency(), "permalink" => get_permalink($p->get_id())]);']));
	const result = {
		woocommerce: { version: wooVersion, source: 'https://downloads.wordpress.org/plugin/woocommerce.11.1.2.zip', sha256, bytes: bytes.length, license: 'GPL-3.0-or-later' },
		product,
		pages: Object.fromEntries(Object.entries(pages).map(([key, id]) => [key, { id, url: wp(['eval', `echo get_permalink(${id});`]) }])),
		settings: { currency: wp(['option', 'get', 'woocommerce_currency']), guestCheckout: wp(['option', 'get', 'woocommerce_enable_guest_checkout']), checkoutAccountCreation: wp(['option', 'get', 'woocommerce_enable_signup_and_login_from_checkout']), payPalActions: 0, realMoneyActions: 0 },
		workspacePlugin: { slug: 'bms-g3a-commerce-loop', version: wp(['plugin', 'get', 'bms-g3a-commerce-loop', '--field=version']), active: wp(['plugin', 'get', 'bms-g3a-commerce-loop', '--field=status']) },
		wpLocalOnly: wp(['eval', 'echo defined("BMS_G3A_LOCAL_ONLY") && BMS_G3A_LOCAL_ONLY === true ? "true" : "false";']),
		generationEnabled: wp(['eval', 'echo defined("BMS_G3A_GENERATION_ENABLED") && BMS_G3A_GENERATION_ENABLED === false ? "false" : "unexpected";']),
	};
	fs.writeFileSync(path.join(reportDir, 'woocommerce-setup.json'), `${JSON.stringify(result, null, 2)}\n`);
	console.log(JSON.stringify({ result: 'PASS', woocommerce: wooVersion, product: product.id, currency: product.currency, price: product.price, virtual: product.virtual, pages: Object.keys(pages) }));
}

main().catch((error) => {
	console.error(error.stderr ? error.stderr.toString().trim() : error.message);
	process.exitCode = 1;
});
