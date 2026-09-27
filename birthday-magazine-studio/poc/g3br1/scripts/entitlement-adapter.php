<?php

/**
 * CLI-only G3BR1 local entitlement proof adapter.
 * It persists one canonical ready-job audit row but never schedules or dispatches work.
 */

function bms_g3br1_generation_action_count(): int {
	global $wpdb;
	$table = $wpdb->prefix . 'actionscheduler_actions';
	$exists = $wpdb->get_var($wpdb->prepare('SHOW TABLES LIKE %s', $table)) === $table;
	if (!$exists) {
		return 0;
	}
	return (int) $wpdb->get_var($wpdb->prepare('SELECT COUNT(*) FROM `' . esc_sql($table) . '` WHERE hook LIKE %s OR hook LIKE %s', 'bms_g3a_generate%', 'bms_g3br1_generate%'));
}

function bms_g3br1_generation_cron_count(): int {
	$count = 0;
	foreach ((array) _get_cron_array() as $events) {
		foreach ((array) $events as $hook => $instances) {
			if (0 === strpos((string) $hook, 'bms_g3a_generate') || 0 === strpos((string) $hook, 'bms_g3br1_generate')) {
				$count += count((array) $instances);
			}
		}
	}
	return $count;
}

function bms_g3br1_model_call_count(): int {
	return (int) get_option('bms_g3a_model_call_count', 0) + (int) get_option('bms_g3br1_model_call_count', 0);
}

function bms_g3br1_evaluate_entitlement(int $order_id, string $reason): array {
	$order = wc_get_order($order_id);
	$jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
	if (!is_array($jobs)) {
		$jobs = array();
	}
	$job_key = 'order-' . $order_id;
	$provider_order_hash = $order instanceof WC_Order ? (string) $order->get_meta('_bms_g3br1_provider_order_id_sha256') : '';
	$capture_hash = $order instanceof WC_Order ? (string) $order->get_meta('_bms_g3br1_capture_id_sha256') : '';
	$checks = array(
		'order30Only' => 30 === $order_id,
		'orderExists' => $order instanceof WC_Order,
		'paid' => $order instanceof WC_Order && $order->is_paid(),
		'amountCurrency' => $order instanceof WC_Order && '39.99' === number_format((float) $order->get_total(), 2, '.', '') && 'USD' === $order->get_currency(),
		'sandboxPpcp' => $order instanceof WC_Order && 'ppcp-gateway' === $order->get_payment_method() && 'sandbox' === (string) $order->get_meta('_ppcp_paypal_payment_mode'),
		'providerCorrelationVerified' => $order instanceof WC_Order && 'yes' === (string) $order->get_meta('_bms_g3br1_provider_correlation_verified') && 64 === strlen($provider_order_hash) && 64 === strlen($capture_hash),
		'intakeComplete' => $order instanceof WC_Order && 'complete' === (string) $order->get_meta('_bms_g3br1_intake_state'),
		'notRefunded' => $order instanceof WC_Order && 0 === count($order->get_refunds()),
	);
	$eligible = !in_array(false, $checks, true);
	$created = false;
	if ($eligible && !isset($jobs[$job_key])) {
		$jobs[$job_key] = array(
			'canonicalJobIdSha256' => hash('sha256', 'birthday-magazine:g3br1:' . $job_key),
			'orderId' => $order_id,
			'state' => 'generation-ready-deferred',
			'providerOrderIdSha256' => $provider_order_hash,
			'captureIdSha256' => $capture_hash,
			'createdAtUtc' => gmdate('c'),
			'dispatchQueued' => false,
			'modelProviderInvoked' => false,
		);
		update_option('bms_g3br1_canonical_generation_jobs', $jobs, false);
		$created = true;
	}
	$evaluations = get_option('bms_g3br1_entitlement_evaluations', array());
	if (!is_array($evaluations)) {
		$evaluations = array();
	}
	$evaluations[] = array(
		'orderId' => $order_id,
		'reason' => sanitize_key($reason),
		'eligible' => $eligible,
		'canonicalJobCreated' => $created,
		'canonicalJobCount' => count($jobs),
		'deferredGenerationActionCount' => bms_g3br1_generation_action_count(),
		'deferredGenerationCronCount' => bms_g3br1_generation_cron_count(),
		'modelCallCount' => bms_g3br1_model_call_count(),
		'evaluatedAtUtc' => gmdate('c'),
	);
	update_option('bms_g3br1_entitlement_evaluations', $evaluations, false);
	return array(
		'checks' => $checks,
		'eligible' => $eligible,
		'canonicalJobCreated' => $created,
		'canonicalJobCount' => count($jobs),
		'canonicalJobIdSha256' => isset($jobs[$job_key]['canonicalJobIdSha256']) ? $jobs[$job_key]['canonicalJobIdSha256'] : null,
		'deferredGenerationActionCount' => bms_g3br1_generation_action_count(),
		'deferredGenerationCronCount' => bms_g3br1_generation_cron_count(),
		'modelCallCount' => bms_g3br1_model_call_count(),
	);
}
