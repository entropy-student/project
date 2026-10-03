<?php
/**
 * Plugin Name: Birthday Magazine G3A Commerce Workspace
 * Description: Local proof of WooCommerce order-bound workspace ownership. Generation is deliberately absent.
 * Version: 0.1.0
 * License: GPL-2.0-or-later
 */

if (!defined('ABSPATH') || !defined('BMS_G3A_LOCAL_ONLY') || BMS_G3A_LOCAL_ONLY !== true) {
	return;
}

add_action('init', static function () {
	add_rewrite_tag('%bms_g3a_order%', '([0-9]+)');
	add_rewrite_rule('^birthday-workspace/([0-9]+)/?$', 'index.php?bms_g3a_order=$matches[1]', 'top');
});

register_activation_hook(__FILE__, static function () {
	flush_rewrite_rules();
	if (get_option('bms_g3a_generation_job_count', false) === false) {
		add_option('bms_g3a_generation_job_count', 0, '', false);
	}
	if (get_option('bms_g3a_model_call_count', false) === false) {
		add_option('bms_g3a_model_call_count', 0, '', false);
	}
});

register_deactivation_hook(__FILE__, 'flush_rewrite_rules');

function bms_g3a_block_generation_scheduling($pre, ...$details) {
	if (!defined('BMS_G3A_GENERATION_ENABLED') || BMS_G3A_GENERATION_ENABLED !== false) {
		return $pre;
	}

	$hook = $details[0] ?? null;
	if (is_object($hook) && isset($hook->hook)) {
		$hook = $hook->hook;
	}
	if (is_string($hook) && strpos($hook, 'bms_g3a_generate') === 0) {
		return new WP_Error('bms_g3a_generation_disabled', 'Generation is disabled in G3A local commerce proof.');
	}
	return $pre;
}

add_filter('pre_schedule_event', 'bms_g3a_block_generation_scheduling', 10, 2);
foreach (['pre_as_schedule_single_action', 'pre_as_schedule_unique_action', 'pre_as_schedule_recurring_action', 'pre_as_schedule_cron_action', 'pre_as_enqueue_async_action'] as $schedule_filter) {
	add_filter($schedule_filter, 'bms_g3a_block_generation_scheduling', 10, 6);
}

function bms_g3a_bind_workspace_to_order($order_id): void {
	$order = wc_get_order($order_id);
	if (!$order || $order->get_customer_id() < 1) {
		return;
	}

	$order->update_meta_data('_bms_g3a_workspace_order_id', (string) $order->get_id());
	$order->update_meta_data('_bms_g3a_workspace_owner_id', (string) $order->get_customer_id());
	$order->save_meta_data();
}

add_action('woocommerce_checkout_order_processed', 'bms_g3a_bind_workspace_to_order', 100, 1);
add_action('woocommerce_order_status_changed', static function ($order_id) {
	bms_g3a_bind_workspace_to_order($order_id);
}, 100, 1);

add_filter('woocommerce_my_account_my_orders_actions', static function ($actions, $order) {
	if (!$order instanceof WC_Order || get_current_user_id() !== (int) $order->get_customer_id()) {
		return $actions;
	}

	if ((string) $order->get_meta('_bms_g3a_workspace_owner_id') !== (string) get_current_user_id()) {
		return $actions;
	}

	$actions['birthday_workspace'] = [
		'url' => home_url('/birthday-workspace/' . $order->get_id() . '/'),
		'name' => __('Open Birthday Magazine workspace', 'bms-g3a'),
	];
	return $actions;
}, 10, 2);

add_action('template_redirect', static function () {
	$order_id = absint(get_query_var('bms_g3a_order'));
	if (!$order_id) {
		return;
	}

	if (!is_user_logged_in()) {
		status_header(403);
		nocache_headers();
		wp_die(esc_html__('A signed-in order owner is required.', 'bms-g3a'), '', ['response' => 403]);
	}

	$order = wc_get_order($order_id);
	$current_user_id = get_current_user_id();
	$bound_order_id = $order ? (string) $order->get_meta('_bms_g3a_workspace_order_id') : '';
	$bound_owner_id = $order ? (string) $order->get_meta('_bms_g3a_workspace_owner_id') : '';
	if (!$order || $bound_order_id !== (string) $order_id || $bound_owner_id !== (string) $current_user_id || (int) $order->get_customer_id() !== $current_user_id) {
		status_header(403);
		nocache_headers();
		wp_die(esc_html__('This workspace is not available to this account.', 'bms-g3a'), '', ['response' => 403]);
	}

	status_header(200);
	nocache_headers();
	$recipient = get_user_by('id', $current_user_id);
	?>
	<!doctype html>
	<html lang="en">
	<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Birthday Magazine Workspace</title></head>
	<body style="margin:0;background:#f4f0e9;color:#1d1b19;font:16px/1.5 system-ui,sans-serif">
	<main data-bms-g3a-workspace data-order-id="<?php echo esc_attr((string) $order_id); ?>" data-owner-id="<?php echo esc_attr((string) $current_user_id); ?>" style="max-width:760px;margin:8vh auto;padding:36px;background:#fff;border:1px solid #ded8cf">
		<p style="letter-spacing:.12em;text-transform:uppercase;font-size:12px">GOOD ISSUE · PRIVATE ORDER WORKSPACE</p>
		<h1>Your Birthday Magazine</h1>
		<p>Order #<?php echo esc_html((string) $order_id); ?> is linked to this signed-in account.</p>
		<p>Owner: <?php echo esc_html($recipient ? $recipient->user_email : ''); ?></p>
		<p>Generation is disabled for the G3A local commerce proof. No intake or generation job has been created.</p>
		<a href="<?php echo esc_url(wc_get_page_permalink('myaccount')); ?>">Return to My Account</a>
	</main>
	</body>
	</html>
	<?php
	exit;
}, 0);
