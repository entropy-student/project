<?php
/**
 * Plugin Name: Conversion Leak Audit G4 Integration
 * Description: Local-only WordPress to Scanner integration for the G4 free loop.
 * Version: 0.1.0
 */

if (!defined('ABSPATH')) { exit; }

function cla_g4_scanner_base_url(): string {
    $configured = getenv('CLA_SCANNER_BASE_URL');
    if (!$configured && defined('CLA_SCANNER_BASE_URL')) {
        $configured = CLA_SCANNER_BASE_URL;
    }
    $base = untrailingslashit($configured ?: 'http://host.docker.internal:8000');
    $parts = wp_parse_url($base);
    $allowed_hosts = ['localhost', '127.0.0.1', '::1', 'host.docker.internal'];
    if (!$parts || empty($parts['scheme']) || !in_array(strtolower($parts['scheme']), ['http', 'https'], true)) {
        return '';
    }
    if (empty($parts['host']) || !in_array(strtolower($parts['host']), $allowed_hosts, true)) {
        return '';
    }
    return $base;
}

function cla_g4_scanner_request(string $method, string $path, ?array $body = null) {
    $base = cla_g4_scanner_base_url();
    if (!$base) {
        return new WP_Error('SCANNER_NOT_LOCAL', 'Local Scanner endpoint is not configured.', ['status' => 503]);
    }
    $args = [
        'method' => $method,
        'timeout' => 12,
        'redirection' => 0,
        // The endpoint is constrained above to the local Scanner allowlist.
        // WordPress otherwise rejects host.docker.internal after resolving it to a private address.
        'reject_unsafe_urls' => false,
        'headers' => ['Accept' => 'application/json'],
    ];
    if ($body !== null) {
        $args['headers']['Content-Type'] = 'application/json';
        $args['body'] = wp_json_encode($body);
    }
    $response = wp_remote_request($base . $path, $args);
    if (is_wp_error($response)) {
        return new WP_Error('SCANNER_UNAVAILABLE', 'The local Scanner could not be reached.', ['status' => 503]);
    }
    $status = (int) wp_remote_retrieve_response_code($response);
    $data = json_decode(wp_remote_retrieve_body($response), true);
    if ($status < 200 || $status >= 300) {
        $detail = is_array($data['detail'] ?? null) ? $data['detail'] : [];
        $code = sanitize_key((string) ($detail['code'] ?? 'SCANNER_REQUEST_FAILED'));
        return new WP_Error($code, 'The Scanner could not accept this request.', [
            'status' => $status >= 400 ? $status : 502,
            'scanner_code' => $code,
        ]);
    }
    if (!is_array($data)) {
        return new WP_Error('SCANNER_BAD_RESPONSE', 'The Scanner returned an unreadable response.', ['status' => 502]);
    }
    return new WP_REST_Response($data, $status);
}

function cla_g4_rest_permission(WP_REST_Request $request) {
    if (wp_verify_nonce($request->get_header('X-WP-Nonce'), 'wp_rest')) {
        return true;
    }
    return new WP_Error('CLA_REST_NONCE_REQUIRED', 'A valid local request token is required.', ['status' => 403]);
}

function cla_g4_create_scan(WP_REST_Request $request) {
    $url = trim((string) $request->get_param('url'));
    if ($url === '' || strlen($url) > 2048 || !filter_var($url, FILTER_VALIDATE_URL)) {
        return new WP_Error('INVALID_URL', 'Enter a valid public website URL.', ['status' => 400]);
    }
    $scheme = strtolower((string) wp_parse_url($url, PHP_URL_SCHEME));
    if (!in_array($scheme, ['http', 'https'], true)) {
        return new WP_Error('UNSUPPORTED_SCHEME', 'Only public http or https websites are supported.', ['status' => 400]);
    }
    return cla_g4_scanner_request('POST', '/v1/scans', ['url' => $url]);
}

function cla_g4_scan_id(WP_REST_Request $request): string {
    return strtolower((string) $request['id']);
}

function cla_g4_get_scan(WP_REST_Request $request) {
    $id = cla_g4_scan_id($request);
    if (!preg_match('/^[0-9a-f]{32}$/', $id)) {
        return new WP_Error('JOB_NOT_FOUND', 'Scan reference was not found.', ['status' => 404]);
    }
    return cla_g4_scanner_request('GET', '/v1/scans/' . rawurlencode($id));
}

function cla_g4_get_report(WP_REST_Request $request) {
    $id = cla_g4_scan_id($request);
    if (!preg_match('/^[0-9a-f]{32}$/', $id)) {
        return new WP_Error('JOB_NOT_FOUND', 'Scan reference was not found.', ['status' => 404]);
    }
    return cla_g4_scanner_request('GET', '/v1/scans/' . rawurlencode($id) . '/report');
}

function cla_g4_register_rest_routes(): void {
    register_rest_route('cla/v1', '/scans', [
        'methods' => WP_REST_Server::CREATABLE,
        'callback' => 'cla_g4_create_scan',
        'permission_callback' => 'cla_g4_rest_permission',
        'args' => ['url' => ['required' => true]],
    ]);
    register_rest_route('cla/v1', '/scans/(?P<id>[0-9a-f]{32})', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'cla_g4_get_scan',
        'permission_callback' => 'cla_g4_rest_permission',
    ]);
    register_rest_route('cla/v1', '/scans/(?P<id>[0-9a-f]{32})/report', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'cla_g4_get_report',
        'permission_callback' => 'cla_g4_rest_permission',
    ]);
}
add_action('rest_api_init', 'cla_g4_register_rest_routes');

function cla_g4_scan_app_shortcode(): string {
    $api_root = rest_url('cla/v1');
    $nonce = wp_create_nonce('wp_rest');
    $html = '<section class="cla-g4-app" data-cla-g4-app data-api-root="' . esc_attr($api_root) . '" data-api-nonce="' . esc_attr($nonce) . '">';
    $html .= '<div class="cla-g4-scan-card">';
    $html .= '<div class="cla-g4-kicker">FREE PUBLIC SCAN</div>';
    $html .= '<h2>See the first three points worth checking.</h2>';
    $html .= '<p class="cla-g4-muted">Public pages only. No admin access, no install, and no changes to your site.</p>';
    $html .= '<form class="cla-g4-form" data-cla-scan-form novalidate>'; 
    $html .= '<label for="cla-g4-store-url">Store URL</label>';
    $html .= '<div class="cla-g4-form-row"><input id="cla-g4-store-url" name="url" type="url" inputmode="url" autocomplete="url" placeholder="https://yourstore.com" required><button type="submit" data-cla-submit>Scan my store</button></div>';
    $html .= '<p class="cla-g4-field-message" data-cla-field-message role="alert" hidden></p>';
    $html .= '</form>';
    $html .= '<div class="cla-g4-trust-row" aria-label="Scan boundaries"><span>Public pages only</span><span>No admin access</span><span>No install</span><span>No website changes</span></div>';
    $html .= '</div>';
    $html .= '<div class="cla-g4-progress" data-cla-progress hidden aria-live="polite">';
    $html .= '<div class="cla-g4-kicker">SCAN PROGRESS</div><h2 data-cla-progress-title>Checking access</h2><p class="cla-g4-muted" data-cla-progress-copy>Only public-page states returned by the Scanner are shown.</p>';
    $html .= '<ol class="cla-g4-progress-list">';
    $html .= '<li data-phase="CHECKING_ACCESS">Checking access</li><li data-phase="READING_PAGES">Reading pages</li><li data-phase="MATCHING_EVIDENCE">Analyzing with trusted rules</li><li data-phase="PRIORITIZING">Finalizing results</li>';
    $html .= '</ol><p class="cla-g4-scan-reference" data-cla-scan-reference hidden></p></div>';
    $html .= '<div class="cla-g4-feedback" data-cla-feedback hidden role="status"></div>';
    $html .= '<section class="cla-g4-results" data-cla-results hidden aria-live="polite"></section>';
    $html .= '</section>';
    return $html;
}

function cla_g4_register_shortcodes(): void {
    remove_shortcode('cla_scan_placeholder');
    add_shortcode('cla_scan_placeholder', 'cla_g4_scan_app_shortcode');
    add_shortcode('cla_scan_app', 'cla_g4_scan_app_shortcode');
}
add_action('init', 'cla_g4_register_shortcodes', 20);

function cla_g4_enqueue_assets(): void {
    if (is_admin()) { return; }
    wp_enqueue_style('cla-g4-integration', content_url('mu-plugins/conversion-leak-audit-g4.css'), [], '0.4.0');
    wp_enqueue_script('cla-g4-integration', content_url('mu-plugins/conversion-leak-audit-g4.js'), [], '0.4.0', true);
}
add_action('wp_enqueue_scripts', 'cla_g4_enqueue_assets', 20);
