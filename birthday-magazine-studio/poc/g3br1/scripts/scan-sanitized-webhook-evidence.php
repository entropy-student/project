<?php

/**
 * Read existing WooCommerce PayPal Payments logs without emitting raw log lines.
 * This script is read-only and only returns bounded event metadata and hashes.
 */

$log_directory = trailingslashit(wp_upload_dir()['basedir']) . 'wc-logs';
$files = glob($log_directory . '/woocommerce-paypal-payments-2026-09-27-*.log') ?: array();
$events = array();
$order_30_updates = array();

foreach ($files as $file) {
	$lines = @file($file, FILE_IGNORE_NEW_LINES);
	if (!is_array($lines)) {
		continue;
	}

	$current_event_index = null;
	foreach ($lines as $line) {
		$timestamp = null;
		if (preg_match('/^\[([^\]]+)\]/', $line, $time_match)) {
			$timestamp = $time_match[1];
		}

		if (preg_match('/Webhook\s+(\S+)\s+received of type\s+([A-Z0-9_.]+)\s+and by resource "([^"]+)"/', $line, $event_match)) {
			$events[] = array(
				'eventIdSha256' => hash('sha256', $event_match[1]),
				'eventType' => $event_match[2],
				'resourceType' => $event_match[3],
				'timestamp' => $timestamp,
				'handler' => null,
			);
			$current_event_index = count($events) - 1;
			continue;
		}

		if (null !== $current_event_index && preg_match('/Webhook is going to be handled by ([A-Z0-9_.]+)/', $line, $handler_match)) {
			$events[$current_event_index]['handler'] = $handler_match[1];
			continue;
		}

		if (preg_match('/Order (\d+) has been updated through PayPal/', $line, $order_match) && '30' === $order_match[1]) {
			$order_30_updates[] = array('orderId' => 30, 'timestamp' => $timestamp);
		}
	}
}

$payment_window_events = array_values(array_filter($events, static function (array $event): bool {
	$time = (string) $event['timestamp'];
	return false !== strpos($time, '17:3') || false !== strpos($time, '17:4') || false !== strpos($time, '17:5');
}));
$last_webhook = get_option('ppcp-last-webhook');
$stored_event_hash = is_array($last_webhook) && !empty($last_webhook['id'])
	? hash('sha256', (string) $last_webhook['id'])
	: null;
$stored_event_found = false;
foreach ($events as $event) {
	if ($stored_event_hash && hash_equals($stored_event_hash, $event['eventIdSha256'])) {
		$stored_event_found = true;
		break;
	}
}

echo wp_json_encode(array(
	'filesScanned' => count($files),
	'eventsInPaymentWindow' => $payment_window_events,
	'order30WebhookUpdateLogCount' => count($order_30_updates),
	'order30WebhookUpdateLogTimes' => $order_30_updates,
	'lastStoredWebhookEventIdSha256' => $stored_event_hash,
	'lastStoredEventFoundInPluginLog' => $stored_event_found,
), JSON_UNESCAPED_SLASHES);
