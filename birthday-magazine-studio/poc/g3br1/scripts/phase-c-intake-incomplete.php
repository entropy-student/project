<?php

require_once __DIR__ . '/entitlement-adapter.php';

$evidence_path = '/tmp/g3br1-payment-reconciliation.json';
$evidence = is_readable($evidence_path) ? json_decode((string) file_get_contents($evidence_path), true) : null;
$facts_valid = is_array($evidence)
	&& 'READ_ONLY_RECONCILIATION_COMPLETE' === ($evidence['queryResult'] ?? '')
	&& 'READ_ONLY_VERIFIED' === ($evidence['querySemantics'] ?? '')
	&& 0 === (int) ($evidence['mutationCalls'] ?? -1)
	&& !empty($evidence['environment']['sandboxConnected'])
	&& empty($evidence['environment']['liveEnabled'])
	&& !empty($evidence['environment']['apiHostSandbox'])
	&& empty($evidence['environment']['apiHostProduction'])
	&& !empty($evidence['environment']['webhookVerificationEnabled'])
	&& 30 === (int) ($evidence['woocommerce']['orderId'] ?? 0)
	&& !empty($evidence['woocommerce']['paid'])
	&& '39.99' === ($evidence['woocommerce']['total'] ?? '')
	&& 'USD' === ($evidence['woocommerce']['currency'] ?? '')
	&& 'ppcp-gateway' === ($evidence['woocommerce']['paymentMethod'] ?? '')
	&& 'sandbox' === ($evidence['woocommerce']['paymentMode'] ?? '')
	&& 0 === (int) ($evidence['woocommerce']['refundCount'] ?? -1)
	&& !empty($evidence['providerOrder']['idMatchesWooMeta'])
	&& 'COMPLETED' === ($evidence['providerOrder']['status'] ?? '')
	&& 1 === (int) ($evidence['providerOrder']['captureCount'] ?? 0)
	&& 1 === (int) ($evidence['providerOrder']['completedCaptureCount'] ?? 0)
	&& '39.99' === ($evidence['providerOrder']['captureAmount'] ?? '')
	&& 'USD' === ($evidence['providerOrder']['captureCurrency'] ?? '')
	&& !empty($evidence['providerOrder']['purchaseUnitCustomIdMatchesWooOrder'])
	&& !empty($evidence['providerOrder']['woocommerceTransactionIdMatchesSingleCapture'])
	&& !empty($evidence['providerWebhookEvent']['idMatchesStoredReceipt'])
	&& !empty($evidence['providerWebhookEvent']['resourceIdMatchesProviderOrder'])
	&& !empty($evidence['providerWebhookEvent']['callbackCorrelationBasis'])
	&& empty($evidence['providerWebhookEvent']['simulationEvent'])
	&& !empty($evidence['reconciliation']['captureCardinalityOne'])
	&& !empty($evidence['reconciliation']['exactlyOneCompletedCapture'])
	&& !empty($evidence['reconciliation']['amountCurrencyCorrelation'])
	&& !empty($evidence['reconciliation']['noDuplicateCapture'])
	&& !empty($evidence['reconciliation']['callbackWebhookCorrelation'])
	&& empty($evidence['reconciliation']['refundAlreadyExists']);

$order = wc_get_order(30);
$prior_jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
$initial_action_count = bms_g3br1_generation_action_count();
$initial_cron_count = bms_g3br1_generation_cron_count();
$initial_model_calls = bms_g3br1_model_call_count();
$existing_g3a_job_count = (int) get_option('bms_g3a_generation_job_count', 0);

if (!$facts_valid || !$order instanceof WC_Order || !defined('BMS_G3A_GENERATION_ENABLED') || true === BMS_G3A_GENERATION_ENABLED || !empty($prior_jobs) || 0 !== $initial_action_count || 0 !== $initial_cron_count || 0 !== $initial_model_calls || 0 !== $existing_g3a_job_count || 0 !== count($order->get_refunds())) {
	echo wp_json_encode(array('result' => 'FAIL_CLOSED', 'reason' => 'PRECONDITION_FAILED', 'correlationEvidenceValid' => $facts_valid, 'order30Exists' => $order instanceof WC_Order), JSON_UNESCAPED_SLASHES);
	return;
}

$evidence_hash = hash_file('sha256', $evidence_path);
$order->update_meta_data('_bms_g3br1_provider_correlation_verified', 'yes');
$order->update_meta_data('_bms_g3br1_provider_order_id_sha256', (string) $evidence['providerOrder']['idSha256']);
$order->update_meta_data('_bms_g3br1_capture_id_sha256', (string) $evidence['providerOrder']['captureIdSha256']);
$order->update_meta_data('_bms_g3br1_payment_evidence_sha256', $evidence_hash);
$order->update_meta_data('_bms_g3br1_intake_state', 'incomplete');
$order->update_meta_data('_bms_g3br1_intake_fixture', 'synthetic-order-30');
$order->save_meta_data();

$evaluation = bms_g3br1_evaluate_entitlement(30, 'phase-c-paid-intake-incomplete');
$order = wc_get_order(30);
echo wp_json_encode(array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'phase' => 'C',
	'result' => empty($evaluation['eligible']) && 0 === $evaluation['canonicalJobCount'] && 0 === $evaluation['deferredGenerationActionCount'] && 0 === $evaluation['deferredGenerationCronCount'] && 0 === $evaluation['modelCallCount'] && 'incomplete' === (string) $order->get_meta('_bms_g3br1_intake_state') && 0 === count($order->get_refunds()) ? 'PASS' : 'FAIL',
	'orderId' => 30,
	'paid' => $order->is_paid(),
	'intakeState' => (string) $order->get_meta('_bms_g3br1_intake_state'),
	'providerCorrelationVerified' => 'yes' === (string) $order->get_meta('_bms_g3br1_provider_correlation_verified'),
	'paymentEvidenceSha256' => (string) $order->get_meta('_bms_g3br1_payment_evidence_sha256'),
	'eligible' => $evaluation['eligible'],
	'canonicalJobCount' => $evaluation['canonicalJobCount'],
	'deferredGenerationActionCount' => $evaluation['deferredGenerationActionCount'],
	'deferredGenerationCronCount' => $evaluation['deferredGenerationCronCount'],
	'modelCallCount' => $evaluation['modelCallCount'],
	'refundCount' => count($order->get_refunds()),
	'modelProviderInvoked' => false,
), JSON_UNESCAPED_SLASHES);
