<?php

$order = wc_get_order(30);
$transaction_id = $order instanceof WC_Order ? (string) $order->get_transaction_id() : '';
$matches = array();
if ('' !== $transaction_id) {
	foreach (wc_get_orders(array('limit' => -1, 'return' => 'objects')) as $candidate) {
		if ($candidate instanceof WC_Order && hash_equals($transaction_id, (string) $candidate->get_transaction_id())) {
			$matches[] = (int) $candidate->get_id();
		}
	}
}
sort($matches);

echo wp_json_encode(array(
	'order30Exists' => $order instanceof WC_Order,
	'transactionIdSha256' => $transaction_id ? hash('sha256', $transaction_id) : null,
	'wooOrdersMatchingTransactionId' => count($matches),
	'matchingWooOrderIds' => $matches,
), JSON_UNESCAPED_SLASHES);
