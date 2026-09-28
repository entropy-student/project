<?php

$container = \WooCommerce\PayPalCommerce\PPCP::container();
$stored = $container->get('webhook.last-webhook-storage')->get_data();
$event_id = is_array($stored) && isset($stored['id']) ? (string) $stored['id'] : '';
$received_at = is_array($stored) && isset($stored['received_time']) ? (int) $stored['received_time'] : 0;
$upload_dir = wp_upload_dir();
$files = glob(trailingslashit($upload_dir['basedir']) . 'wc-logs/woocommerce-paypal-payments-*.log') ?: array();
$exact_event_lines = 0;
$event_types = array();
$handler_dispatch_window = 0;
$handler_success_window = 0;
$order_processed_window = 0;
$event_failure_lines = 0;

foreach ($files as $file) {
	$handle = fopen($file, 'rb');
	if (!$handle) {
		continue;
	}
	while (($line = fgets($handle)) !== false) {
		$timestamp_text = strtok($line, ' ');
		$line_timestamp = is_string($timestamp_text) ? strtotime($timestamp_text) : false;
		$near_receipt = false !== $line_timestamp && 15 >= abs($line_timestamp - $received_at);
		if ('' !== $event_id && false !== strpos($line, $event_id)) {
			$exact_event_lines++;
			if (preg_match('/received of type ([A-Z.]+)/', $line, $matches)) {
				$event_types[$matches[1]] = true;
			}
			if (false !== stripos($line, 'could not find handler') || false !== stripos($line, 'not found in webhook event') || false !== stripos($line, 'failed to process wc order') || false !== stripos($line, 'webhook verification failed')) {
				$event_failure_lines++;
			}
		}
		if ($near_receipt && false !== stripos($line, 'webhook is going to be handled by')) {
			$handler_dispatch_window++;
		}
		if ($near_receipt && false !== stripos($line, 'webhook has been handled by')) {
			$handler_success_window++;
		}
		if ($near_receipt && false !== stripos($line, 'has been processed after approval in paypal')) {
			$order_processed_window++;
		}
	}
	fclose($handle);
}

echo wp_json_encode(array(
	'ppcpLogFilesScanned' => count($files),
	'exactStoredEventIdLogOccurrences' => $exact_event_lines,
	'eventTypesMatchedByLog' => array_keys($event_types),
	'handlerDispatchLinesWithin15SecondsOfReceipt' => $handler_dispatch_window,
	'handlerSuccessLinesWithin15SecondsOfReceipt' => $handler_success_window,
	'orderProcessedAfterApprovalLinesWithin15SecondsOfReceipt' => $order_processed_window,
	'failureLinesContainingExactStoredEventId' => $event_failure_lines,
	'rawIdsOrLogLinesEmitted' => false,
), JSON_UNESCAPED_SLASHES);
