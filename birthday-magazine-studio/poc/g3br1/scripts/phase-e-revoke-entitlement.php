<?php

/**
 * Local-only entitlement revocation, gated by sanitized provider refund proof.
 * Does not contact a payment or model provider.
 */

require_once __DIR__ . '/entitlement-adapter.php';

$proof_path = '/tmp/g3br1/phase-e-provider-refund-readback.json';
$proof = is_readable($proof_path) ? json_decode((string) file_get_contents($proof_path), true) : null;
$proof_time = is_array($proof) && !empty($proof['readAtUtc']) ? strtotime($proof['readAtUtc']) : false;
$proof_fresh = false !== $proof_time && time() >= $proof_time && (time() - $proof_time) <= 600;
$order = wc_get_order(30);
$jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
$job_key = 'order-30';
$job = is_array($jobs) && isset($jobs[$job_key]) ? $jobs[$job_key] : null;
$container = \WooCommerce\PayPalCommerce\PPCP::container();
$connection = $container->get('settings.connection-state');
$active_plugins = (array) get_option('active_plugins', array());
$proof_pass = is_array($proof)
	&& 'READ_ONLY_VERIFIED' === ($proof['querySemantics'] ?? '')
	&& 0 === (int) ($proof['mutationCalls'] ?? -1)
	&& 'READ_ONLY_REFUND_READBACK_COMPLETE' === ($proof['queryResult'] ?? '')
	&& !empty($proof['refundRevocationPreconditions'])
	&& 1 === (int) ($proof['providerRefundCardinality'] ?? 0)
	&& !empty($proof['providerRefundCompleted'])
	&& !empty($proof['refundAmountCurrencyCorrelation'])
	&& !empty($proof['refundCorrelation'])
	&& empty($proof['duplicateRefund']);
$checks = array(
	'freshSanitizedProviderRefundProof' => $proof_fresh && $proof_pass,
	'sandboxConnected' => $connection->is_sandbox(),
	'liveDisabled' => 'yes' !== strtolower((string) getenv('PAYPAL_LIVE_ENABLED')),
	'officialPpcpActive' => in_array('woocommerce-paypal-payments/woocommerce-paypal-payments.php', $active_plugins, true),
	'exactWooRefundOne' => $order instanceof WC_Order && 1 === count($order->get_refunds()) && '39.99' === number_format(abs((float) $order->get_total_refunded()), 2, '.', '') && 'USD' === $order->get_currency(),
	'jobStillCanonicalAndDeferred' => is_array($jobs) && 1 === count($jobs) && is_array($job) && 'generation-ready-deferred' === ($job['state'] ?? ''),
	'actionsAndCronAlreadyZero' => 0 === bms_g3br1_generation_action_count() && 0 === bms_g3br1_generation_cron_count(),
	'modelCallsStillZero' => 0 === bms_g3br1_model_call_count(),
);

if (in_array(false, $checks, true)) {
	echo wp_json_encode(array('result' => 'REVOCATION_PRECONDITION_FAILED', 'checks' => $checks), JSON_UNESCAPED_SLASHES);
	return;
}

$now = gmdate('c');
$jobs[$job_key]['state'] = 'cancelled';
$jobs[$job_key]['entitlementState'] = 'revoked';
$jobs[$job_key]['revokedAtUtc'] = $now;
$jobs[$job_key]['revocationReason'] = 'one-full-woocommerce-ppcp-sandbox-refund-confirmed';
$jobs[$job_key]['dispatchQueued'] = false;
$jobs[$job_key]['modelProviderInvoked'] = false;
update_option('bms_g3br1_canonical_generation_jobs', $jobs, false);
$order->update_meta_data('_bms_g3br1_entitlement_state', 'revoked');
$order->update_meta_data('_bms_g3br1_entitlement_revoked_at_utc', $now);
$order->save();

$final_jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
$final_job = is_array($final_jobs) && isset($final_jobs[$job_key]) ? $final_jobs[$job_key] : array();
$result = array(
	'result' => 'PASS',
	'canonicalJobCount' => count((array) $final_jobs),
	'canonicalJobState' => $final_job['state'] ?? null,
	'generationEntitlement' => (string) $order->get_meta('_bms_g3br1_entitlement_state'),
	'deferredGenerationActionCount' => bms_g3br1_generation_action_count(),
	'deferredGenerationCronCount' => bms_g3br1_generation_cron_count(),
	'modelCallCount' => bms_g3br1_model_call_count(),
	'modelProviderInvoked' => false,
	'auditRecordPreserved' => is_array($final_job) && !empty($final_job['canonicalJobIdSha256']),
	'readAtUtc' => gmdate('c'),
);
$result['result'] = 1 === $result['canonicalJobCount'] && 'cancelled' === $result['canonicalJobState'] && 'revoked' === $result['generationEntitlement'] && 0 === $result['deferredGenerationActionCount'] && 0 === $result['deferredGenerationCronCount'] && 0 === $result['modelCallCount'] && $result['auditRecordPreserved'] ? 'PASS' : 'FAIL';
echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
