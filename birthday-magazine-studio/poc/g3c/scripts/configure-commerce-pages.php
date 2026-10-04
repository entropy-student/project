<?php
if (!defined('ABSPATH') || !class_exists('WooCommerce')) {
	fwrite(STDERR, "G3C requires the local WordPress/WooCommerce runtime.\n");
	exit(2);
}

$pages = [
	'cart' => ['woocommerce_cart_page_id', 'Cart', 'cart', '[woocommerce_cart]'],
	'checkout' => ['woocommerce_checkout_page_id', 'Checkout', 'checkout', '[woocommerce_checkout]'],
	'account' => ['woocommerce_myaccount_page_id', 'My Account', 'my-account', '[woocommerce_my_account]'],
];

foreach ($pages as $key => [$option, $title, $slug, $shortcode]) {
	$page_id = absint(get_option($option));
	$page = $page_id ? get_post($page_id) : null;
	if (!$page || $page->post_type !== 'page') {
		$page_id = wp_insert_post([
			'post_type' => 'page',
			'post_status' => 'publish',
			'post_title' => $title,
			'post_name' => $slug,
			'post_content' => $shortcode,
		]);
		if (is_wp_error($page_id)) {
			fwrite(STDERR, $page_id->get_error_message() . "\n");
			exit(3);
		}
		update_option($option, $page_id);
	} else {
		wp_update_post([
			'ID' => $page_id,
			'post_title' => $title,
			'post_name' => $slug,
			'post_content' => $shortcode,
		]);
	}
	$pages[$key] = ['id' => $page_id, 'url' => get_permalink($page_id), 'shortcode' => $shortcode];
}

foreach ([
	'woocommerce_currency' => 'USD',
	'woocommerce_price_num_decimals' => '2',
	'woocommerce_default_country' => 'US:CA',
	'woocommerce_coming_soon' => 'no',
	'woocommerce_store_pages_only' => 'no',
	'woocommerce_calc_taxes' => 'no',
	'woocommerce_enable_guest_checkout' => 'no',
	'woocommerce_enable_signup_and_login_from_checkout' => 'yes',
	'woocommerce_enable_myaccount_registration' => 'no',
	'woocommerce_registration_generate_username' => 'yes',
	'woocommerce_registration_generate_password' => 'yes',
] as $option => $value) {
	update_option($option, $value);
}

$gateway = get_option('woocommerce_cheque_settings', []);
$gateway['enabled'] = 'yes';
$gateway['title'] = 'Local test only — no payment';
$gateway['description'] = 'Synthetic local G3C path only; no money is collected.';
$gateway['instructions'] = 'Local test only — no payment.';
update_option('woocommerce_cheque_settings', $gateway);

flush_rewrite_rules();

$owner = get_user_by('login', 'bms-owner');
$result = [
	'pages' => $pages,
	'currency' => get_woocommerce_currency(),
	'guest_checkout' => get_option('woocommerce_enable_guest_checkout'),
	'checkout_account_creation' => get_option('woocommerce_enable_signup_and_login_from_checkout'),
	'separate_myaccount_registration' => get_option('woocommerce_enable_myaccount_registration'),
	'account_username_password_generated' => get_option('woocommerce_registration_generate_username') === 'yes' && get_option('woocommerce_registration_generate_password') === 'yes',
	'local_check_gateway' => ['enabled' => $gateway['enabled'], 'title' => $gateway['title']],
	'owner_role' => $owner ? (wp_roles()->get_names()[$owner->roles[0] ?? ''] ?? null) : null,
	'paypal_plugin_active' => is_plugin_active('woocommerce-paypal-payments/woocommerce-paypal-payments.php'),
	'payment_submitted' => false,
];
echo wp_json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . "\n";
