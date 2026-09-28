<?php

/**
 * One-shot G3BR1 refund through WooCommerce and the official PPCP gateway.
 * The persistent invocation marker deliberately blocks all repeat execution.
 */

require_once __DIR__ . '/entitlement-adapter.php';

$marker_key = 'bms_g3br1_phase_e_refund_invocation';
$marker = get_option($marker_key, null);
if (null !== $marker && false !== $marker) {
	echo wp_json_encode(array('result' => 'BLOCKED_INVOCATION_MARKER_EXISTS'));
	return;
}

$preflight_path = '/tmp/g3br1/phase-e-provider-preflight.json';
$preflight = is_readable($preflight_path) ? json_decode((string) file_get_contents($preflight_path), true) : null;
$preflight_time = is_array($preflight) && !empty($preflight['capturedAtUtc']) ? strtotime($preflight['capturedAtUtc']) : false;
$fresh = false !== $preflight_time && time() >= $preflight_time && (time() - $preflight_time) <= 900;
$order = wc_get_order(30);
$jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
$container = \WooCommerce\PayPalCommerce\PPCP::container();
$connection = $container->get('settings.connection-state');
$api_host = (string) $container->get('api.host');
$active_plugins = (array) get_option('active_plugins', array());
$payment_gateways = WC()->payment_gateways()->payment_gateways();
$refund_gateway_supported = isset($payment_gateways['ppcp-gateway']) && $payment_gateways['ppcp-gateway']->supports('refunds');
$job = is_array($jobs) && isset($jobs['order-30']) ? $jobs['order-30'] : null;
$preflight_checks = array(
	'freshReadOnlyProviderPreflight' => $fresh && 'READ_ONLY_VERIFIED' === ($preflight['querySemantics'] ?? '') && 0 === (int) ($preflight['mutationCalls'] ?? -1),
	'preflightCaptureOneCompleted' => $fresh && !empty($preflight['reconciliation']['captureCardinalityOne']) && !empty($preflight['reconciliation']['exactlyOneCompletedCapture']) && !empty($preflight['reconciliation']['amountCurrencyCorrelation']) && !empty($preflight['reconciliation']['noDuplicateCapture']) && !empty($preflight['reconciliation']['callbackWebhookCorrelation']),
	'sandboxConnected' => $connection->is_sandbox() && defined('PAYPAL_SANDBOX_API_URL') && $api_host === PAYPAL_SANDBOX_API_URL,
	'liveDisabled' => 'yes' !== strtolower((string) getenv('PAYPAL_LIVE_ENABLED')) && (!defined('PAYPAL_API_URL') || $api_host !== PAYPAL_API_URL),
	'officialPpcpActive' => in_array('woocommerce-paypal-payments/woocommerce-paypal-payments.php', $active_plugins, true),
	'officialPpcpGatewayRefundSupported' => $refund_gateway_supported,
	'orderPaidAndCorrelated' => $order instanceof WC_Order && $order->is_paid() && '39.99' === number_format((float) $order->get_total(), 2, '.', '') && 'USD' === $order->get_currency() && 'ppcp-gateway' === $order->get_payment_method() && 'sandbox' === (string) $order->get_meta('_ppcp_paypal_payment_mode') && 'yes' === (string) $order->get_meta('_bms_g3br1_provider_correlation_verified') && !empty($preflight['woocommerce']['providerOrderIdMetaSha256']) && hash_equals((string) $order->get_meta('_bms_g3br1_provider_order_id_sha256'), (string) $preflight['providerOrder']['idSha256']) && hash_equals((string) $order->get_meta('_bms_g3br1_capture_id_sha256'), (string) $preflight['providerOrder']['captures'][0]['idSha256']),
	'noPriorRefund' => $order instanceof WC_Order && 0 === count($order->get_refunds()) && 0 === (int) ($preflight['woocommerce']['refundCount'] ?? -1),
	'canonicalDeferredJobOne' => is_array($jobs) && 1 === count($jobs) && is_array($job) && 'generation-ready-deferred' === ($job['state'] ?? ''),
	'noDeferredActionOrCron' => 0 === bms_g3br1_generation_action_count() && 0 === bms_g3br1_generation_cron_count(),
	'noModelCalls' => 0 === bms_g3br1_model_call_count(),
	'noPriorInvocationMarker' => null === $marker || false === $marker,
);

if (in_array(false, $preflight_checks, true)) {
	echo wp_json_encode(array('result' => 'PREFLIGHT_DRIFT', 'checks' => $preflight_checks), JSON_UNESCAPED_SLASHES);
	return;
}

$invocation = array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'orderId' => 30,
	'amount' => '39.99',
	'currency' => 'USD',
	'refundPayment' => true,
	'path' => 'woocommerce_wc_create_refund_official_ppcp_gateway',
	'state' => 'invocation-started',
	'invokedAtUtc' => gmdate('c'),
);
if (!add_option($marker_key, $invocation, '', false)) {
	echo wp_json_encode(array('result' => 'BLOCKED_INVOCATION_MARKER_RACE'));
	return;
}

try {
	$refund = wc_create_refund(array(
		'order_id' => 30,
		'amount' => 39.99,
		'reason' => 'G3BR1 Owner-authorized full Sandbox refund',
		'line_items' => array(),
		'refund_payment' => true,
		'restock_items' => false,
	));
	$marker['state'] = is_wp_error($refund) ? 'woocommerce-returned-error' : 'woocommerce-returned-success';
	$marker['responseClass'] = is_wp_error($refund) ? 'WP_Error' : (is_object($refund) ? get_class($refund) : gettype($refund));
	if (is_wp_error($refund)) {
		$marker['errorCodeSha256'] = hash('sha256', (string) $refund->get_error_code());
	} elseif ($refund instanceof WC_Order_Refund) {
		$marker['wooRefundRecordCreated'] = true;
		$marker['wooRefundAmount'] = number_format(abs((float) $refund->get_amount()), 2, '.', '');
		$marker['wooRefundCurrency'] = $refund->get_currency();
		$marker['wooRefundPaymentFlag'] = (bool) $refund->get_refunded_payment();
	}
	$marker['returnedAtUtc'] = gmdate('c');
	update_option($marker_key, $marker, false);
	echo wp_json_encode(array(
		'result' => $marker['state'],
		'responseClass' => $marker['responseClass'],
		'wooRefundRecordCreated' => !empty($marker['wooRefundRecordCreated']),
		'wooRefundAmount' => $marker['wooRefundAmount'] ?? null,
		'wooRefundCurrency' => $marker['wooRefundCurrency'] ?? null,
		'wooRefundPaymentFlag' => $marker['wooRefundPaymentFlag'] ?? null,
		'refundInvocationCount' => 1,
		'retryPermitted' => false,
	), JSON_UNESCAPED_SLASHES);
} catch (Throwable $error) {
	$marker['state'] = 'invocation-result-ambiguous';
	$marker['errorClass'] = get_class($error);
	$marker['returnedAtUtc'] = gmdate('c');
	update_option($marker_key, $marker, false);
	echo wp_json_encode(array('result' => 'INVOCATION_RESULT_AMBIGUOUS', 'errorClass' => get_class($error), 'refundInvocationCount' => 1, 'retryPermitted' => false), JSON_UNESCAPED_SLASHES);
}
