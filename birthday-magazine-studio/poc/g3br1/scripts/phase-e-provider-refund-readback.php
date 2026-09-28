<?php

/**
 * Read-only G3BR1 provider refund reconciliation via PPCP Order GET.
 * Emits allowlisted facts and hashes only.
 */

$result = array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'querySemantics' => 'READ_ONLY_VERIFIED',
	'readOnlyOperation' => 'official_ppcp_OrderEndpoint_order_GET',
	'mutationCalls' => 0,
	'orderId' => 30,
	'readAtUtc' => gmdate('c'),
);

try {
	$order = wc_get_order(30);
	$container = \WooCommerce\PayPalCommerce\PPCP::container();
	$connection = $container->get('settings.connection-state');
	$api_host = (string) $container->get('api.host');
	$result['sandbox'] = $connection->is_sandbox() && defined('PAYPAL_SANDBOX_API_URL') && $api_host === PAYPAL_SANDBOX_API_URL;
	$result['liveDisabled'] = 'yes' !== strtolower((string) getenv('PAYPAL_LIVE_ENABLED')) && (!defined('PAYPAL_API_URL') || $api_host !== PAYPAL_API_URL);
	if (!$order instanceof WC_Order || !$result['sandbox'] || !$result['liveDisabled']) {
		$result['queryResult'] = 'LOCAL_ORDER_OR_ENVIRONMENT_GUARD_FAILED';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}

	$provider_order_id = (string) $order->get_meta('_ppcp_paypal_order_id');
	$provider_order = $container->get('api.endpoint.order')->order($order);
	$purchase_units = $provider_order->purchase_units();
	$captures = array();
	$provider_refunds = array();
	$unit_amounts = array();
	foreach ($purchase_units as $unit) {
		$unit_amount = $unit->amount();
		$unit_amounts[] = array(
			'value' => number_format((float) $unit_amount->value(), 2, '.', ''),
			'currency' => $unit_amount->currency_code(),
		);
		$payments = $unit->payments();
		foreach ($payments ? $payments->captures() : array() as $capture) {
			$amount = $capture->amount();
			$captures[] = array(
				'idSha256' => hash('sha256', (string) $capture->id()),
				'status' => $capture->status()->name(),
				'amount' => number_format((float) $amount->value(), 2, '.', ''),
				'currency' => $amount->currency_code(),
			);
		}
		foreach ($payments ? $payments->refunds() : array() as $refund) {
			$amount = $refund->amount();
			$provider_refunds[] = array(
				'idSha256' => hash('sha256', (string) $refund->id()),
				'status' => $refund->status()->name(),
				'amount' => number_format((float) $amount->value(), 2, '.', ''),
				'currency' => $amount->currency_code(),
			);
		}
	}

	$ppcp_refund_ids = $order->get_meta(\WooCommerce\PayPalCommerce\WcGateway\Gateway\PayPalGateway::REFUNDS_META_KEY, true);
	$ppcp_refund_hashes = array_map(static function ($id): string { return hash('sha256', (string) $id); }, is_array($ppcp_refund_ids) ? array_values($ppcp_refund_ids) : array());
	$provider_refund_hashes = array_column($provider_refunds, 'idSha256');
	sort($ppcp_refund_hashes);
	sort($provider_refund_hashes);
	$woo_refunds = $order->get_refunds();
	$woo_refund_facts = array();
	foreach ($woo_refunds as $woo_refund) {
		$woo_refund_facts[] = array(
			'amount' => number_format(abs((float) $woo_refund->get_amount()), 2, '.', ''),
			'currency' => $woo_refund->get_currency(),
			'refundedPaymentFlag' => (bool) $woo_refund->get_refunded_payment(),
		);
	}

	$capture_hash = (string) $order->get_meta('_bms_g3br1_capture_id_sha256');
	$provider_capture_matches = 1 === count($captures) && hash_equals($capture_hash, $captures[0]['idSha256']);
	$woo_refund_amount_pass = 1 === count($woo_refund_facts) && '39.99' === $woo_refund_facts[0]['amount'] && 'USD' === $woo_refund_facts[0]['currency'] && !empty($woo_refund_facts[0]['refundedPaymentFlag']);
	$provider_refund_pass = 1 === count($provider_refunds) && 'COMPLETED' === $provider_refunds[0]['status'] && '39.99' === $provider_refunds[0]['amount'] && 'USD' === $provider_refunds[0]['currency'];
	$result['providerOrder'] = array(
		'idSha256' => hash('sha256', (string) $provider_order->id()),
		'idMatchesWooMeta' => '' !== $provider_order_id && hash_equals(hash('sha256', $provider_order_id), hash('sha256', (string) $provider_order->id())),
		'status' => $provider_order->status()->name(),
		'purchaseUnitCount' => count($purchase_units),
		'purchaseUnitAmounts' => $unit_amounts,
		'captureCount' => count($captures),
		'captures' => $captures,
	);
	$result['providerRefunds'] = $provider_refunds;
	$result['providerRefundCardinality'] = count($provider_refunds);
	$result['providerRefundCompleted'] = $provider_refund_pass;
	$result['wooRefundRecordCount'] = count($woo_refunds);
	$result['wooRefunds'] = $woo_refund_facts;
	$result['refundAmountCurrencyCorrelation'] = 1 === count($unit_amounts) && '39.99' === $unit_amounts[0]['value'] && 'USD' === $unit_amounts[0]['currency'] && $woo_refund_amount_pass && $provider_refund_pass;
	$result['refundIdMatchesPpcpStoredIds'] = 1 === count($provider_refund_hashes) && $provider_refund_hashes === $ppcp_refund_hashes;
	$result['refundCorrelation'] = $result['providerOrder']['idMatchesWooMeta'] && $provider_capture_matches && 1 === count($woo_refunds) && $result['refundIdMatchesPpcpStoredIds'];
	$result['duplicateRefund'] = count($provider_refunds) > 1 || count($woo_refunds) > 1;
	$result['refundRevocationPreconditions'] = $result['sandbox'] && $result['liveDisabled'] && 1 === count($captures) && $provider_capture_matches && $provider_refund_pass && $woo_refund_amount_pass && 1 === count($woo_refunds) && $result['refundIdMatchesPpcpStoredIds'] && !$result['duplicateRefund'];
	$result['queryResult'] = 'READ_ONLY_REFUND_READBACK_COMPLETE';
	echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
} catch (Throwable $error) {
	$result['queryResult'] = 'READBACK_ERROR';
	$result['errorClass'] = get_class($error);
	echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
}
