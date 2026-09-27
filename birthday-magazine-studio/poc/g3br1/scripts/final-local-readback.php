<?php

require_once __DIR__ . '/entitlement-adapter.php';

$order = wc_get_order(30);
$jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
if (!is_array($jobs)) {
	$jobs = array();
}
$container = \WooCommerce\PayPalCommerce\PPCP::container();
$connection = $container->get('settings.connection-state');

$active_plugins = (array) get_option('active_plugins', array());
$result = array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'providerQueried' => false,
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
		'refundCount' => count($order->get_refunds()),
		'intakeState' => (string) $order->get_meta('_bms_g3br1_intake_state'),
		'providerCorrelationVerified' => 'yes' === (string) $order->get_meta('_bms_g3br1_provider_correlation_verified'),
		'providerOrderIdSha256' => (string) $order->get_meta('_bms_g3br1_provider_order_id_sha256'),
		'captureIdSha256' => (string) $order->get_meta('_bms_g3br1_capture_id_sha256'),
		'paymentEvidenceSha256' => (string) $order->get_meta('_bms_g3br1_payment_evidence_sha256'),
	) : array('exists' => false),
	'canonicalJobCount' => count($jobs),
	'canonicalJobs' => array_values($jobs),
	'g3aGenerationJobCounter' => (int) get_option('bms_g3a_generation_job_count', 0),
	'deferredGenerationActionCount' => bms_g3br1_generation_action_count(),
	'deferredGenerationCronCount' => bms_g3br1_generation_cron_count(),
	'entitlementEvaluationCount' => count((array) get_option('bms_g3br1_entitlement_evaluations', array())),
	'modelCallCount' => bms_g3br1_model_call_count(),
	'modelProviderInvoked' => false,
	'refundAlreadyExists' => $order instanceof WC_Order && count($order->get_refunds()) > 0,
	'readAtUtc' => gmdate('c'),
);

echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
