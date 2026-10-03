<?php
if (!defined('ABSPATH') || !class_exists('WooCommerce')) {
	fwrite(STDERR, "G3C requires the local WordPress/WooCommerce runtime.\n");
	exit(2);
}

$test_users = [
	'buyer_a' => ['login' => 'bms-g3c-buyer-a', 'email' => 'buyer-a@birthday.invalid', 'password' => getenv('BMS_G3C_TEST_A_PASS') ?: ''],
	'buyer_b' => ['login' => 'bms-g3c-buyer-b', 'email' => 'buyer-b@birthday.invalid', 'password' => getenv('BMS_G3C_TEST_B_PASS') ?: ''],
];
foreach ($test_users as $label => &$details) {
	$user = get_user_by('login', $details['login']);
	if (!$user) {
		if ($details['password'] === '') {
			fwrite(STDERR, "Synthetic test-user password was not provided.\n");
			exit(3);
		}
		$user_id = wp_insert_user([
			'user_login' => $details['login'],
			'user_email' => $details['email'],
			'user_pass' => $details['password'],
			'role' => 'customer',
		]);
		if (is_wp_error($user_id)) {
			fwrite(STDERR, $user_id->get_error_message() . "\n");
			exit(4);
		}
		$user = get_user_by('id', $user_id);
	}
	$details = ['id' => (int) $user->ID, 'role' => $user->roles[0] ?? null];
}
unset($details);

$order_id = absint(get_option('bms_g3c_workspace_test_order_id'));
$order = $order_id ? wc_get_order($order_id) : false;
if (!$order) {
	$buyer = get_user_by('id', $test_users['buyer_a']['id']);
	$product = wc_get_product(1113);
	if (!$buyer || !$product) {
		fwrite(STDERR, "Synthetic Buyer A or G3C product is missing.\n");
		exit(5);
	}
	$order = wc_create_order(['customer_id' => $buyer->ID, 'created_via' => 'g3c-local-workspace-regression']);
	if (is_wp_error($order)) {
		fwrite(STDERR, $order->get_error_message() . "\n");
		exit(6);
	}
	$order->add_product($product, 1);
	$order->set_currency('USD');
	$order->set_payment_method('');
	$order->calculate_totals();
	$order->update_status('on-hold', 'Synthetic G3C workspace regression fixture; no payment submitted.', false);
	$order->update_meta_data('_bms_g3a_workspace_order_id', (string) $order->get_id());
	$order->update_meta_data('_bms_g3a_workspace_owner_id', (string) $buyer->ID);
	$order->save();
	$order_id = $order->get_id();
	update_option('bms_g3c_workspace_test_order_id', $order_id, false);
}

$result = [
	'fixture' => 'synthetic-local-workspace-regression',
	'order_id' => (int) $order_id,
	'order_status' => $order->get_status(),
	'order_total' => $order->get_total(),
	'currency' => $order->get_currency(),
	'paid' => $order->is_paid(),
	'payment_method' => $order->get_payment_method(),
	'workspace_order_binding' => $order->get_meta('_bms_g3a_workspace_order_id'),
	'workspace_owner_binding' => $order->get_meta('_bms_g3a_workspace_owner_id'),
	'buyers' => $test_users,
	'generation_job_count' => (int) get_option('bms_g3a_generation_job_count', 0),
	'model_call_count' => (int) get_option('bms_g3a_model_call_count', 0),
	'paypal_plugin_active' => is_plugin_active('woocommerce-paypal-payments/woocommerce-paypal-payments.php'),
	'payment_submitted' => false,
];
echo wp_json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . "\n";
