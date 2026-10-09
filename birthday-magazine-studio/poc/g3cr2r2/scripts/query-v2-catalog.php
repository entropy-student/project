<?php
$url = 'https://startersites.io?route=v2/demo/get_all&companion_version=2.1.57';
$response = wp_remote_get($url, [
	'timeout' => 45,
	'redirection' => 3,
	'headers' => ['Accept' => 'application/json'],
]);

if (is_wp_error($response)) {
	echo wp_json_encode([
		'request_url' => $url,
		'http_status' => null,
		'wp_error' => [
			'code' => $response->get_error_code(),
			'message' => $response->get_error_message(),
		],
		'response_body_bytes' => 0,
		'response_body_sha256' => null,
		'json_decoded' => false,
		'response_json' => null,
	], JSON_UNESCAPED_SLASHES);
	return;
}

$body = wp_remote_retrieve_body($response);
$decoded = json_decode($body, true);
echo wp_json_encode([
	'request_url' => $url,
	'http_status' => wp_remote_retrieve_response_code($response),
	'wp_error' => null,
	'response_body_bytes' => strlen($body),
	'response_body_sha256' => hash('sha256', $body),
	'json_decoded' => json_last_error() === JSON_ERROR_NONE,
	'json_error' => json_last_error() === JSON_ERROR_NONE ? null : json_last_error_msg(),
	'response_json' => $decoded,
], JSON_UNESCAPED_SLASHES | JSON_INVALID_UTF8_SUBSTITUTE);
