<?php

/**
 * One-shot, read-only reconciliation of existing WooCommerce order #30.
 * Uses the official PPCP order GET and one PayPal webhook-event GET only.
 * Provider identifiers are compared in memory and emitted as SHA-256 only.
 */

$result = array(
	'gate' => 'G3BR1_SANDBOX_PAYMENT_RECONCILIATION_ENTITLEMENT_REFUND',
	'querySemantics' => 'READ_ONLY_VERIFIED',
	'providerQueryCount' => 0,
	'providerQueryCountScope' => 'two explicit GET operations per invocation; excludes a possible PPCP bearer refresh and internal read retry',
	'orderId' => 30,
	'mutationCalls' => 0,
);

try {
	$order = wc_get_order(30);
	$container = \WooCommerce\PayPalCommerce\PPCP::container();
	$connection = $container->get('settings.connection-state');
	$api_host = (string) $container->get('api.host');
	$result['sandboxConnected'] = $connection->is_sandbox();
	$result['liveEnabled'] = 'yes' === strtolower((string) getenv('PAYPAL_LIVE_ENABLED'));
	$result['apiHostSandbox'] = defined('PAYPAL_SANDBOX_API_URL') && $api_host === PAYPAL_SANDBOX_API_URL;
	$result['apiHostProduction'] = defined('PAYPAL_API_URL') && $api_host === PAYPAL_API_URL;
	$result['webhookVerificationEnabled'] = !defined('PAYPAL_WEBHOOK_REQUEST_VERIFICATION') || (bool) PAYPAL_WEBHOOK_REQUEST_VERIFICATION;

	if (!$order instanceof WC_Order) {
		$result['queryResult'] = 'ORDER_NOT_FOUND';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}

	$transaction_id = (string) $order->get_transaction_id();
	$paypal_order_id = (string) $order->get_meta('_ppcp_paypal_order_id');
	$result['woocommerce'] = array(
		'exists' => true,
		'status' => $order->get_status(),
		'paid' => $order->is_paid(),
		'total' => number_format((float) $order->get_total(), 2, '.', ''),
		'currency' => $order->get_currency(),
		'paymentMethod' => $order->get_payment_method(),
		'paymentMode' => (string) $order->get_meta('_ppcp_paypal_payment_mode'),
		'transactionIdSha256' => $transaction_id ? hash('sha256', $transaction_id) : null,
		'providerOrderIdMetaSha256' => $paypal_order_id ? hash('sha256', $paypal_order_id) : null,
		'refundCount' => count($order->get_refunds()),
	);

	if (!$result['sandboxConnected'] || !$result['apiHostSandbox'] || $result['apiHostProduction'] || $result['liveEnabled'] || !$result['webhookVerificationEnabled']) {
		$result['queryResult'] = 'ENVIRONMENT_OR_WEBHOOK_GUARD_FAILED';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}
	if (!$order->is_paid() || '39.99' !== number_format((float) $order->get_total(), 2, '.', '') || 'USD' !== $order->get_currency() || 'ppcp-gateway' !== $order->get_payment_method() || 'sandbox' !== (string) $order->get_meta('_ppcp_paypal_payment_mode') || !$paypal_order_id) {
		$result['queryResult'] = 'WOO_ORDER_INVARIANT_FAILED';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}

	$storage = $container->get('webhook.last-webhook-storage');
	$stored_webhook = $storage->get_data();
	$stored_event_id = is_array($stored_webhook) && isset($stored_webhook['id']) ? (string) $stored_webhook['id'] : '';
	$simulation = get_option('ppcp-webhook-simulation');
	$simulation_event_id = is_array($simulation) && isset($simulation['id']) ? (string) $simulation['id'] : '';
	$result['storedWebhook'] = array(
		'present' => '' !== $stored_event_id,
		'eventIdSha256' => $stored_event_id ? hash('sha256', $stored_event_id) : null,
		'receivedAtUtc' => is_array($stored_webhook) && isset($stored_webhook['received_time']) ? gmdate('c', (int) $stored_webhook['received_time']) : null,
		'simulationOptionPresent' => is_array($simulation) && !empty($simulation),
		'simulationEventIdSha256' => $simulation_event_id ? hash('sha256', $simulation_event_id) : null,
		'storedEventMatchesSimulation' => '' !== $stored_event_id && '' !== $simulation_event_id && hash_equals($stored_event_id, $simulation_event_id),
	);
	if ('' === $stored_event_id) {
		$result['queryResult'] = 'NO_STORED_WEBHOOK_EVENT';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}

	// Official PPCP OrderEndpoint::order() is GET-only; capture() is a separate POST and is never called.
	$endpoint = $container->get('api.endpoint.order');
	$provider_order = $endpoint->order($order);
	$result['providerQueryCount']++;
	$provider_order_id = (string) $provider_order->id();
	$provider_units = $provider_order->purchase_units();
	$capture_facts = array();
	$provider_amounts = array();
	$custom_id_matches = array();
	foreach ($provider_units as $unit) {
		$unit_amount = $unit->amount();
		$provider_amounts[] = array(
			'value' => number_format((float) $unit_amount->value(), 2, '.', ''),
			'currency' => $unit_amount->currency_code(),
		);
		$custom_id_matches[] = (string) $unit->custom_id() === (string) $order->get_id();
		$payments = $unit->payments();
		foreach ($payments ? $payments->captures() : array() as $capture) {
			$capture_amount = $capture->amount();
			$capture_facts[] = array(
				'idSha256' => hash('sha256', (string) $capture->id()),
				'status' => $capture->status()->name(),
				'amount' => number_format((float) $capture_amount->value(), 2, '.', ''),
				'currency' => $capture_amount->currency_code(),
			);
		}
	}
	$result['providerOrder'] = array(
		'idSha256' => hash('sha256', $provider_order_id),
		'idMatchesWooMeta' => hash_equals(hash('sha256', $paypal_order_id), hash('sha256', $provider_order_id)),
		'status' => $provider_order->status()->name(),
		'purchaseUnitCount' => count($provider_units),
		'purchaseUnitAmounts' => $provider_amounts,
		'purchaseUnitCustomIdMatchesWooOrder' => in_array(true, $custom_id_matches, true),
		'captureCount' => count($capture_facts),
		'completedCaptureCount' => count(array_filter($capture_facts, static function (array $capture): bool { return 'COMPLETED' === $capture['status']; })),
		'captures' => $capture_facts,
		'woocommerceTransactionIdMatchesSingleCapture' => 1 === count($capture_facts) && !empty($result['woocommerce']['transactionIdSha256']) && hash_equals($result['woocommerce']['transactionIdSha256'], $capture_facts[0]['idSha256']),
	);

	// Read exactly the event already stored by PPCP. This is GET only; no resend endpoint is called.
	$bearer = $container->get('api.bearer')->bearer()->token();
	$event_url = rtrim($api_host, '/') . '/v1/notifications/webhooks-events/' . rawurlencode($stored_event_id);
	$event_response = wp_remote_get($event_url, array(
		'method' => 'GET',
		'headers' => array('Authorization' => 'Bearer ' . $bearer, 'Accept' => 'application/json'),
		'timeout' => 30,
		'redirection' => 0,
		'limit_response_size' => 1048576,
	));
	$result['providerQueryCount']++;
	if (is_wp_error($event_response)) {
		$result['queryResult'] = 'WEBHOOK_EVENT_QUERY_ERROR';
		$result['eventQueryErrorClass'] = 'WP_Error';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}
	$event_http_status = (int) wp_remote_retrieve_response_code($event_response);
	$event_body = json_decode((string) wp_remote_retrieve_body($event_response), true);
	$result['eventHttpStatus'] = $event_http_status;
	if (200 !== $event_http_status || !is_array($event_body)) {
		$result['queryResult'] = 'WEBHOOK_EVENT_QUERY_ERROR';
		echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
		return;
	}

	$event_payload = isset($event_body['webhook_event']) && is_array($event_body['webhook_event']) ? $event_body['webhook_event'] : $event_body;
	$resource = isset($event_payload['resource']) && is_array($event_payload['resource']) ? $event_payload['resource'] : array();
	$related_ids = isset($resource['supplementary_data']['related_ids']) && is_array($resource['supplementary_data']['related_ids']) ? $resource['supplementary_data']['related_ids'] : array();
	$event_amount = isset($resource['amount']) && is_array($resource['amount']) ? $resource['amount'] : array();
	$event_id = isset($event_payload['id']) ? (string) $event_payload['id'] : '';
	$event_status = isset($resource['status']) ? (string) $resource['status'] : '';
	$event_type = isset($event_payload['event_type']) ? (string) $event_payload['event_type'] : '';
	$event_resource_type = isset($event_payload['resource_type']) ? (string) $event_payload['resource_type'] : '';
	$resource_id = isset($resource['id']) ? (string) $resource['id'] : '';
	$event_capture_id = 'capture' === strtolower($event_resource_type) ? $resource_id : '';
	$event_order_id = isset($related_ids['order_id']) ? (string) $related_ids['order_id'] : '';
	$event_purchase_units = isset($resource['purchase_units']) && is_array($resource['purchase_units']) ? $resource['purchase_units'] : array();
	$event_custom_id = isset($resource['custom_id']) ? (string) $resource['custom_id'] : '';
	if ('' === $event_custom_id && isset($event_purchase_units[0]['custom_id'])) {
		$event_custom_id = (string) $event_purchase_units[0]['custom_id'];
	}
	$event_amount_value = isset($event_amount['value']) ? number_format((float) $event_amount['value'], 2, '.', '') : null;
	$event_currency = isset($event_amount['currency_code']) ? (string) $event_amount['currency_code'] : '';
	$matching_capture_count = count(array_filter($capture_facts, static function (array $capture) use ($event_capture_id): bool {
		return '' !== $event_capture_id && hash_equals($capture['idSha256'], hash('sha256', $event_capture_id));
	}));
	$result['providerWebhookEvent'] = array(
		'idMatchesStoredReceipt' => '' !== $event_id && hash_equals($stored_event_id, $event_id),
		'idSha256' => $event_id ? hash('sha256', $event_id) : null,
		'eventType' => $event_type,
		'resourceType' => $event_resource_type,
		'resourceStatus' => $event_status,
		'resourceIdSha256' => $resource_id ? hash('sha256', $resource_id) : null,
		'resourceIdMatchesProviderOrder' => '' !== $resource_id && hash_equals($provider_order_id, $resource_id),
		'captureIdSha256' => $event_capture_id ? hash('sha256', $event_capture_id) : null,
		'captureMatchesProviderOrder' => 1 === $matching_capture_count,
		'orderIdSha256' => $event_order_id ? hash('sha256', $event_order_id) : null,
		'orderIdMatchesProviderOrder' => ('' !== $event_order_id && hash_equals($provider_order_id, $event_order_id)) || ('CHECKOUT.ORDER.APPROVED' === $event_type && 'checkout-order' === strtolower($event_resource_type) && '' !== $resource_id && hash_equals($provider_order_id, $resource_id)),
		'customIdMatchesWooOrder' => (string) $order->get_id() === $event_custom_id,
		'purchaseUnitCount' => count($event_purchase_units),
		'amount' => $event_amount_value,
		'currency' => $event_currency,
		'createdAtUtc' => isset($event_payload['create_time']) ? (string) $event_payload['create_time'] : null,
	);

	$result['reconciliation'] = array(
		'captureCardinalityOne' => 1 === count($capture_facts),
		'exactlyOneCompletedCapture' => 1 === count($capture_facts) && 'COMPLETED' === $capture_facts[0]['status'],
		'amountCurrencyCorrelation' => 1 === count($provider_amounts) && '39.99' === $provider_amounts[0]['value'] && 'USD' === $provider_amounts[0]['currency'] && 1 === count($capture_facts) && '39.99' === $capture_facts[0]['amount'] && 'USD' === $capture_facts[0]['currency'] && '39.99' === $result['woocommerce']['total'] && 'USD' === $result['woocommerce']['currency'],
		'noDuplicateCapture' => 1 === count($capture_facts),
		'callbackWebhookCorrelation' => !empty($result['storedWebhook']['present']) && !empty($result['webhookVerificationEnabled']) && empty($result['storedWebhook']['storedEventMatchesSimulation']) && !empty($result['providerWebhookEvent']['idMatchesStoredReceipt']) && !empty($result['providerWebhookEvent']['orderIdMatchesProviderOrder']) && 1 === count($capture_facts) && !empty($result['providerOrder']['idMatchesWooMeta']) && !empty($result['providerOrder']['woocommerceTransactionIdMatchesSingleCapture']) && (('CHECKOUT.ORDER.APPROVED' === $event_type && 'checkout-order' === strtolower($event_resource_type)) || ('PAYMENT.CAPTURE.COMPLETED' === $event_type && 'capture' === strtolower($event_resource_type) && 'COMPLETED' === $event_status && !empty($result['providerWebhookEvent']['captureMatchesProviderOrder']))),
	);
	$result['queryResult'] = 'READ_ONLY_RECONCILIATION_COMPLETE';
} catch (Throwable $error) {
	// Deliberately omit exception text: PPCP or provider failures may include sensitive data.
	$result['queryResult'] = 'QUERY_ERROR';
	$result['errorClass'] = get_class($error);
}

echo wp_json_encode($result, JSON_UNESCAPED_SLASHES);
