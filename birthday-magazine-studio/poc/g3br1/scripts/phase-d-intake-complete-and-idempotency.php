<?php

require_once __DIR__ . '/entitlement-adapter.php';

$order = wc_get_order(30);
$jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
if (!$order instanceof WC_Order || 'incomplete' !== (string) $order->get_meta('_bms_g3br1_intake_state') || 'yes' !== (string) $order->get_meta('_bms_g3br1_provider_correlation_verified') || 0 !== count((array) $jobs) || 0 !== bms_g3br1_generation_action_count() || 0 !== bms_g3br1_generation_cron_count() || 0 !== bms_g3br1_model_call_count() || 0 !== count($order->get_refunds())) {
	echo wp_json_encode(array('result' => 'FAIL_CLOSED', 'reason' => 'PHASE_C_PRECONDITION_FAILED'), JSON_UNESCAPED_SLASHES);
	return;
}

$order->update_meta_data('_bms_g3br1_intake_state', 'complete');
$order->save_meta_data();
$evaluations = array();
$evaluations[] = bms_g3br1_evaluate_entitlement(30, 'phase-d-intake-complete');
$evaluations[] = bms_g3br1_evaluate_entitlement(30, 'workspace-refresh');
$evaluations[] = bms_g3br1_evaluate_entitlement(30, 'order-revisit');
$evaluations[] = bms_g3br1_evaluate_entitlement(30, 'explicit-reevaluation');

$replay_result = null;
add_action('bms_g3br1_safe_entitlement_event_replay', static function (int $order_id, string $event_id_hash) use (&$replay_result): void {
	if (64 !== strlen($event_id_hash)) {
		return;
	}
	$replay_result = bms_g3br1_evaluate_entitlement($order_id, 'duplicate-safe-local-event-replay');
}, 10, 2);
do_action('bms_g3br1_safe_entitlement_event_replay', 30, 'c07c00099b4f95784c2706837a00523415fbe91f0e710ab103d458978e2c6611');
if (is_array($replay_result)) {
	$evaluations[] = $replay_result;
}

$final_order = wc_get_order(30);
$final_jobs = get_option('bms_g3br1_canonical_generation_jobs', array());
$all_eligible = 0 === count(array_filter($evaluations, static function (array $evaluation): bool { return empty($evaluation['eligible']); }));
$created_once = 1 === count(array_filter($evaluations, static function (array $evaluation): bool { return !empty($evaluation['canonicalJobCreated']); }));
$counts_stable = 1 === count((array) $final_jobs)
	&& count((array) $final_jobs) === $evaluations[count($evaluations) - 1]['canonicalJobCount']
	&& 0 === bms_g3br1_generation_action_count()
	&& 0 === bms_g3br1_generation_cron_count()
	&& 0 === bms_g3br1_model_call_count()
	&& 0 === count($final_order->get_refunds());
$pass = 'complete' === (string) $final_order->get_meta('_bms_g3br1_intake_state') && $all_eligible && $created_once && $counts_stable && 5 === count($evaluations);

$summary = array_map(static function (array $evaluation): array {
	return array(
		'eligible' => $evaluation['eligible'],
		'canonicalJobCreated' => $evaluation['canonicalJobCreated'],
		'canonicalJobCount' => $evaluation['canonicalJobCount'],
		'deferredGenerationActionCount' => $evaluation['deferredGenerationActionCount'],
		'deferredGenerationCronCount' => $evaluation['deferredGenerationCronCount'],
		'modelCallCount' => $evaluation['modelCallCount'],
	);
}, $evaluations);

echo wp_json_encode(array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'phase' => 'D',
	'result' => $pass ? 'PASS' : 'FAIL',
	'orderId' => 30,
	'intakeState' => (string) $final_order->get_meta('_bms_g3br1_intake_state'),
	'canonicalJobCount' => count((array) $final_jobs),
	'canonicalJobIdSha256' => isset($final_jobs['order-30']['canonicalJobIdSha256']) ? $final_jobs['order-30']['canonicalJobIdSha256'] : null,
	'jobState' => isset($final_jobs['order-30']['state']) ? $final_jobs['order-30']['state'] : null,
	'jobStore' => 'WordPress option bms_g3br1_canonical_generation_jobs, keyed uniquely by order ID',
	'canonicalJobDispatchQueued' => false,
	'deferredGenerationActionCount' => bms_g3br1_generation_action_count(),
	'deferredGenerationCronCount' => bms_g3br1_generation_cron_count(),
	'evaluationCount' => count($evaluations),
	'onlyFirstEvaluationCreatedJob' => $created_once,
	'allEvaluationsEligible' => $all_eligible,
	'idempotencyPass' => $pass,
	'evaluations' => $summary,
	'modelCallCount' => bms_g3br1_model_call_count(),
	'modelProviderInvoked' => false,
	'refundCount' => count($final_order->get_refunds()),
), JSON_UNESCAPED_SLASHES);
