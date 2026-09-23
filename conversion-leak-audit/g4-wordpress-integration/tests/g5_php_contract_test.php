<?php

define('ABSPATH', '/wordpress/');
define('HOUR_IN_SECONDS', 3600);

class WP_Error {
    private string $code;
    private string $message;
    private array $data;
    public function __construct(string $code, string $message = '', array $data = []) { $this->code = $code; $this->message = $message; $this->data = $data; }
    public function get_error_code(): string { return $this->code; }
    public function get_error_message(): string { return $this->message; }
}

class WP_REST_Response {
    private $data;
    public function __construct($data, int $status = 200) { $this->data = $data; }
    public function get_data() { return $this->data; }
}

function add_action(...$args): void {}
function is_wp_error($value): bool { return $value instanceof WP_Error; }
function wp_json_encode($value) { return json_encode($value, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE); }
function sanitize_text_field(string $value): string { return trim(strip_tags($value)); }
function sanitize_key(string $value): string { return preg_replace('/[^a-z0-9_\-]/', '', strtolower($value)); }
function wp_parse_url(string $value, int $component = -1) { return parse_url($value, $component); }
function home_url(string $path = '/') { return ($GLOBALS['g5_home_url'] ?? 'http://localhost:8085') . $path; }
function wp_get_environment_type(): string { return $GLOBALS['g5_environment_type'] ?? 'local'; }
function register_rest_route(...$args): void {}
function wp_remote_post(string $url, array $args) { $GLOBALS['g5_remote_calls']++; $GLOBALS['g5_remote_args'][] = $args; return $GLOBALS['g5_remote_result']; }
function wp_remote_retrieve_response_code($response): int { return $response['status'] ?? 200; }
function wp_remote_retrieve_body($response): string { return $response['body'] ?? ''; }
function get_transient(string $key) { return $GLOBALS['g5_transients'][$key] ?? false; }
function set_transient(string $key, $value, int $ttl): bool { $GLOBALS['g5_transients'][$key] = $value; return true; }
function cla_g4_scanner_request(string $method, string $path) { return $GLOBALS['g5_scanner_responses'][$path] ?? new WP_Error('not_found', 'not found'); }

$GLOBALS['g5_remote_calls'] = 0;
$GLOBALS['g5_remote_args'] = [];
$GLOBALS['g5_remote_result'] = new WP_Error('http_request_failed', 'The request timed out.');
$GLOBALS['g5_transients'] = [];
$GLOBALS['g5_scanner_responses'] = [];
$GLOBALS['g5_tests_run'] = 0;

require_once __DIR__ . '/../conversion-leak-audit-g5.php';

function expect_true(bool $condition, string $message): void {
    $GLOBALS['g5_tests_run']++;
    if (!$condition) { throw new RuntimeException('FAIL ' . $message); }
    echo 'PASS ' . $message . PHP_EOL;
}

function expect_same($expected, $actual, string $message): void {
    expect_true($expected === $actual, $message . ' expected=' . var_export($expected, true) . ' actual=' . var_export($actual, true));
}

$scanId = '0123456789abcdef0123456789abcdef';
$report = [
    'requested_url' => 'https://store.example/private?token=must-not-reach-provider',
    'pages' => [
        ['requested_url' => 'https://store.example/products/x', 'facts' => ['raw_html' => '<secret>not model input</secret>']],
    ],
    'decisions' => [
        ['rule_id' => 'CORE-007', 'result' => 'ISSUE', 'message' => 'The visible product price was not found.', 'fact_refs' => ['page:0.facts.visible_price', 'selector:price']],
        ['rule_id' => 'PHYS-002', 'result' => 'PASS', 'message' => 'Not an issue.', 'fact_refs' => ['page:0.facts.shipping_links']],
        ['rule_id' => 'PHYS-001', 'result' => 'ISSUE', 'message' => 'Missing evidence.', 'fact_refs' => []],
    ],
];
$envelope = ['scan_id' => $scanId, 'status' => 'SUCCEEDED', 'report' => $report];
$input = cla_g5_issue_explanation_input($envelope, 'CORE-007');
expect_true(is_array($input), 'structured eligible issue input is built');
expect_true(!str_contains(wp_json_encode($input), 'store.example') && !str_contains(wp_json_encode($input), 'raw_html') && !str_contains(wp_json_encode($input), 'private?token'), 'provider input excludes URLs and raw page content');
expect_same('cla.issue-explanation.v1', $input['schema_version'], 'input schema is versioned');
expect_same(['page:0.facts.visible_price', 'selector:price'], $input['evidence_refs'], 'input preserves only evidence references');
expect_true(is_wp_error(cla_g5_issue_explanation_input($envelope, 'PHYS-002')), 'non-ISSUE is rejected');
expect_true(is_wp_error(cla_g5_issue_explanation_input($envelope, 'PHYS-001')), 'evidence-less ISSUE is rejected');
expect_true(is_wp_error(cla_g5_issue_explanation_input(['scan_id' => $scanId, 'status' => 'AUDIT_INCOMPLETE', 'report' => $report], 'CORE-007')), 'incomplete scan cannot be explained');
putenv('CLA_G5_LOCAL_PREVIEW=false');
expect_true(!cla_g5_local_preview_enabled(), 'local preview is disabled unless explicitly enabled');
putenv('CLA_G5_LOCAL_PREVIEW=true');
$GLOBALS['g5_environment_type'] = 'production';
expect_true(!cla_g5_local_preview_enabled(), 'local preview rejects non-local WordPress environments');
$GLOBALS['g5_environment_type'] = 'local';
$GLOBALS['g5_home_url'] = 'https://store.example';
expect_true(!cla_g5_local_preview_enabled(), 'local preview rejects non-loopback site URLs');
unset($GLOBALS['g5_home_url']);

$queue = cla_g5_fix_queue(['decisions' => [
    ['rule_id' => 'CORE-001', 'result' => 'ISSUE', 'message' => 'A public page was not available.', 'fact_refs' => ['page:0.status']],
    ['rule_id' => 'PHYS-001', 'result' => 'ISSUE', 'message' => 'Return information was not found.', 'fact_refs' => ['page:0.facts.return_links']],
    ['rule_id' => 'CORE-007', 'result' => 'ISSUE', 'message' => 'Price was not visible.', 'fact_refs' => ['page:0.facts.visible_price']],
    ['rule_id' => 'CORE-001', 'result' => 'ISSUE', 'message' => 'Duplicate issue.', 'fact_refs' => ['page:0.status']],
    ['rule_id' => 'CORE-002', 'result' => 'ISSUE', 'message' => 'Purchase action was not usable.', 'fact_refs' => ['page:0.facts.direct_purchase_signal']],
    ['rule_id' => 'CORE-004', 'result' => 'ISSUE', 'message' => 'No traceable evidence.', 'fact_refs' => ['untrusted-ref']],
    ['rule_id' => 'PHYS-002', 'result' => 'PASS', 'message' => 'Shipping was found.', 'fact_refs' => ['page:0.facts.shipping_links']],
]]);
expect_same(['CORE-007', 'PHYS-001', 'CORE-001', 'CORE-002'], array_column($queue, 'rule_id'), 'queue keeps Top 3 preference then original report order while dropping duplicates and ineligible decisions');
expect_same([1, 2, 3, 4], array_column($queue, 'position'), 'queue positions are contiguous display positions');
expect_true($queue[3]['first_move'] !== $queue[2]['first_move'], 'rule-specific deterministic first moves are supplied');
expect_true($queue[0]['evidence_refs'] === ['page:0.facts.visible_price'], 'queue evidence references remain traceable');

$safe = [
    'summary' => 'The Scanner observed: The visible product price was not found.',
    'why_it_may_matter' => 'This observation may leave a question about the documented purchase journey unresolved.',
    'recommended_next_step' => $input['first_move'],
    'caveat' => $input['limitation'],
];
expect_true(cla_g5_output_guard($safe, $input), 'safe structured output passes');
expect_true(!cla_g5_output_guard(array_merge($safe, ['extra' => 'new finding']), $input), 'unexpected output fields are rejected');
expect_true(!cla_g5_output_guard(array_merge($safe, ['summary' => 'This will recover $50 of revenue.']), $input), 'invented revenue claim is rejected');
expect_true(!cla_g5_output_guard(array_merge($safe, ['summary' => 'Google Analytics proves this issue affects every visitor.']), $input), 'invented evidence source is rejected');
expect_true(!cla_g5_output_guard(array_merge($safe, ['summary' => 'Related rule PHYS-002 caused a conversion lift.']), $input), 'changed rule id and causal lift claim are rejected');
expect_true(!cla_g5_output_guard(array_merge($safe, ['why_it_may_matter' => 'The page:9 selector:secret-data confirms a root cause.']), $input), 'invented evidence reference is rejected');

$GLOBALS['g5_scanner_responses']['/v1/scans/' . $scanId] = new WP_REST_Response(['id' => str_repeat('f', 32), 'status' => 'SUCCEEDED']);
expect_true(is_wp_error(cla_g5_fetch_report_envelope($scanId)), 'mismatched scan id fails closed');
$GLOBALS['g5_scanner_responses']['/v1/scans/' . $scanId] = new WP_REST_Response(['id' => $scanId, 'status' => 'SUCCEEDED']);
$GLOBALS['g5_scanner_responses']['/v1/scans/' . $scanId . '/report'] = new WP_REST_Response(['scan_id' => str_repeat('f', 32), 'decisions' => []]);
expect_true(is_wp_error(cla_g5_fetch_report_envelope($scanId)), 'mismatched report id fails closed');

putenv('CLA_G5_LOCAL_PREVIEW=true');
putenv('CLA_G5_LLM_ENABLED=true');
putenv('CLA_G5_LLM_PROVIDER=json_http');
putenv('CLA_G5_LLM_ENDPOINT=http://localhost:9000/explain');
putenv('CLA_G5_LLM_API_KEY=test-only');
putenv('CLA_G5_LLM_MODEL=fake-model');
$GLOBALS['g5_remote_calls'] = 0;
$GLOBALS['g5_remote_result'] = new WP_Error('http_request_failed', 'The request timed out.');
$timeout = cla_g5_explanation_response($scanId, $input);
expect_same('fallback', $timeout['status'], 'provider timeout returns deterministic fallback');
expect_same('timeout', $timeout['reason'], 'timeout fallback is classified');
expect_same(1, $GLOBALS['g5_remote_calls'], 'provider has no retry loop');
expect_same(8, $GLOBALS['g5_remote_args'][0]['timeout'], 'provider timeout is bounded to eight seconds');
expect_same(0, $GLOBALS['g5_remote_args'][0]['redirection'], 'provider redirects are disabled');
$providerBody = json_decode($GLOBALS['g5_remote_args'][0]['body'], true);
expect_true(strlen($GLOBALS['g5_remote_args'][0]['body']) <= 4096, 'provider request payload remains under four kilobytes');
expect_same(300, $providerBody['max_output_tokens'], 'provider generation is capped at three hundred tokens');

putenv('CLA_G5_LLM_MODEL=fake-model-malformed');
$GLOBALS['g5_remote_result'] = ['status' => 200, 'body' => 'not-json'];
$malformed = cla_g5_explanation_response($scanId, $input);
expect_same('fallback', $malformed['status'], 'malformed JSON falls back');
expect_same('malformed_output', $malformed['reason'], 'malformed JSON has a bounded failure reason');

putenv('CLA_G5_LLM_MODEL=fake-model-schema');
$GLOBALS['g5_remote_result'] = ['status' => 200, 'body' => json_encode(['output' => array_merge($safe, ['extra' => 'unsupported'])])];
$badSchema = cla_g5_explanation_response($scanId, $input);
expect_same('fallback', $badSchema['status'], 'malformed output schema falls back');
expect_same('guard_rejected', $badSchema['reason'], 'invalid output schema is rejected before rendering');

putenv('CLA_G5_LLM_MODEL=fake-model-error');
$GLOBALS['g5_remote_result'] = ['status' => 503, 'body' => '{}'];
$providerError = cla_g5_explanation_response($scanId, $input);
expect_same('provider_unavailable', $providerError['reason'], 'provider HTTP errors fall back');

putenv('CLA_G5_LLM_ENDPOINT=http://example.com/explain');
expect_true(is_wp_error(cla_g5_provider()), 'non-local insecure provider endpoint is rejected');
$beforeUnsafeCall = $GLOBALS['g5_remote_calls'];
$unsafeEndpoint = cla_g5_explanation_response($scanId, $input);
expect_same('provider_unavailable', $unsafeEndpoint['reason'], 'unsafe endpoint uses local fallback');
expect_same($beforeUnsafeCall, $GLOBALS['g5_remote_calls'], 'unsafe endpoint is never contacted');

putenv('CLA_G5_LLM_ENDPOINT=http://localhost:9000/explain');
putenv('CLA_G5_LLM_PROVIDER=fake');
$GLOBALS['g5_transients'] = [];
$GLOBALS['g5_remote_result'] = [];
$fake = cla_g5_explanation_response($scanId, $input);
expect_same('explained', $fake['status'], 'deterministic fake provider succeeds');
expect_same('deterministic_fake', $fake['provider'], 'fake provider identity remains explicit');
$cached = cla_g5_explanation_response($scanId, $input);
expect_true($cached['cached'] === true, 'immutable issue explanation is reused within the same scan');
expect_true(!str_contains(wp_json_encode($GLOBALS['g5_transients']), 'test-only'), 'provider API key is not persisted in explanation records');

putenv('CLA_G5_LLM_ENABLED=false');
putenv('CLA_G5_LLM_PROVIDER=none');
$missing = cla_g5_explanation_response($scanId, $input);
expect_same('fallback', $missing['status'], 'missing provider degrades gracefully');
expect_same('provider_unavailable', $missing['reason'], 'missing provider uses public fallback reason');

$count = $GLOBALS['g5_tests_run'];
echo "TOTAL={$count} PASS={$count} FAIL=0" . PHP_EOL;
