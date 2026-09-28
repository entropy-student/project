<?php

/**
 * Sanitized local-only G3BR1 final read-back after refund and revocation.
 * Makes no provider or model calls and performs no writes.
 */

require_once __DIR__ . '/entitlement-adapter.php';

$order = wc_get_order(30);
$jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
$job = is_array($jobs) && isset($jobs['order-30']) ? $jobs['order-30'] : array();
$invocation = get_option('bms_g3br1_phase_e_refund_invocation', array());
$refunds = $order instanceof WC_Order ? $order->get_refunds() : array();
$woo_refunds = array();
foreach ($refunds as $refund) {
	$woo_refunds[] = array(
		'amount' => number_format(abs((float) $refund->get_amount()), 2, '.', ''),
		'currency' => $refund->get_currency(),
		'refundedPaymentFlag' => (bool) $refund->get_refunded_payment(),
	);
}
$container = \WooCommerce\PayPalCommerce\PPCP::container();
$connection = $container->get('settings.connection-state');
$active_plugins = (array) get_option('active_plugins', array());
$marker_valid = is_array($invocation)
	&& 'woocommerce-returned-success' === ($invocation['state'] ?? '')
	&& 'WC_Order_Refund' === ($invocation['responseClass'] ?? '')
	&& true === ($invocation['wooRefundRecordCreated'] ?? false)
	&& '39.99' === ($invocation['wooRefundAmount'] ?? '')
	&& 'USD' === ($invocation['wooRefundCurrency'] ?? '')
	&& true === ($invocation['wooRefundPaymentFlag'] ?? false);
$result = array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'providerQueried' => false,
	'modelProviderInvoked' => false,
	'sandboxConnected' => $connection->is_sandbox(),
	'liveEnabled' => 'yes' === strtolower((string) getenv('PAYPAL_LIVE_ENABLED')),
	'officialPpcpActive' => in_array('woocommerce-paypal-payments/woocommerce-paypal-payments.php', $active_plugins, true),
	'order30' => $order instanceof WC_Order ? array(
		'exists' => true,
		'status' => $order->get_status(),
		'paid' => $order->is_paid(),
		'total' => number_format((float) $order->get_total(), 2, '.', ''),
		'currency' => $order->get_currency(),
		'paymentMode' => (string) $order->get_meta('_ppcp_paypal_payment_mode'),
		'refundCount' => count($refunds),
		'totalRefunded' => number_format(abs((float) $order->get_total_refunded()), 2, '.', ''),
		'paymentTransactionIdSha256' => hash('sha256', (string) $order->get_transaction_id()),
		'providerOrderIdSha256' => (string) $order->get_meta('_bms_g3br1_provider_order_id_sha256'),
		'captureIdSha256' => (string) $order->get_meta('_bms_g3br1_capture_id_sha256'),
		'entitlementState' => (string) $order->get_meta('_bms_g3br1_entitlement_state'),
	) : array('exists' => false),
	'wooRefunds' => $woo_refunds,
	'canonicalJobCount' => count((array) $jobs),
	'canonicalJob' => array(
		'idSha256' => (string) ($job['canonicalJobIdSha256'] ?? ''),
		'state' => $job['state'] ?? null,
		'entitlementState' => $job['entitlementState'] ?? null,
		'dispatchQueued' => $job['dispatchQueued'] ?? null,
		'modelProviderInvoked' => $job['modelProviderInvoked'] ?? null,
	),
	'refundInvocation' => array(
		'markerExists' => is_array($invocation) && !empty($invocation),
		'state' => $invocation['state'] ?? null,
		'invocationCount' => $marker_valid ? 1 : 0,
		'orderId' => $marker_valid ? 30 : null,
		'amount' => $invocation['wooRefundAmount'] ?? null,
		'currency' => $invocation['wooRefundCurrency'] ?? null,
		'refundPayment' => $invocation['wooRefundPaymentFlag'] ?? null,
		'path' => $marker_valid ? 'woocommerce_wc_create_refund_official_ppcp_gateway' : null,
		'executedHelperSha256' => is_file(__DIR__ . '/phase-e-execute-one-refund.php') ? hash_file('sha256', __DIR__ . '/phase-e-execute-one-refund.php') : null,
		'markerValid' => $marker_valid,
		'invokedAtUtc' => $invocation['invokedAtUtc'] ?? null,
		'returnedAtUtc' => $invocation['returnedAtUtc'] ?? null,
	),
	'deferredGenerationActionCount' => bms_g3br1_generation_action_count(),
	'deferredGenerationCronCount' => bms_g3br1_generation_cron_count(),
	'modelCallCount' => bms_g3br1_model_call_count(),
	'readAtUtc' => gmdate('c'),
);
$result['refundRevocationLocalPass'] = true === $result['sandboxConnected']
	&& false === $result['liveEnabled']
	&& true === $result['officialPpcpActive']
	&& !empty($result['order30']['exists'])
	&& 'refunded' === $result['order30']['status']
	&& '39.99' === $result['order30']['total']
	&& '39.99' === $result['order30']['totalRefunded']
	&& 'USD' === $result['order30']['currency']
	&& 'sandbox' === $result['order30']['paymentMode']
	&& 1 === $result['order30']['refundCount']
	&& 'revoked' === $result['order30']['entitlementState']
	&& 1 === $result['canonicalJobCount']
	&& 'cancelled' === $result['canonicalJob']['state']
	&& 'revoked' === $result['canonicalJob']['entitlementState']
	&& $marker_valid
	&& 1 === $result['refundInvocation']['invocationCount']
	&& 0 === $result['deferredGenerationActionCount']
	&& 0 === $result['deferredGenerationCronCount']
	&& 0 === $result['modelCallCount']
	&& false === $result['canonicalJob']['modelProviderInvoked'];
echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
