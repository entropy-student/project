<?php
/**
 * Plugin Name: Family Cookbook G2A1 Local Proof Adapter
 * Description: Ephemeral order-bound upload and private delivery adapter used only by the isolated G2A1 Actions testbed.
 * Version: 0.1.0
 */
if (!defined('ABSPATH')) { exit; }

final class FCS_G2A1_Proof_Adapter {
    private const META_KEY = '_fcs_g2a1_private_files';
    private const MAX_BYTES = 2097152;

    public static function boot(): void {
        add_action('rest_api_init', [self::class, 'routes']);
        add_shortcode('fcs_preview', [self::class, 'preview']);
        add_shortcode('fcs_order_proof', [self::class, 'order_proof']);
    }

    public static function routes(): void {
        register_rest_route('family-cookbook/v1', '/orders/(?P<order_id>\d+)/uploads', [
            'methods' => 'POST',
            'permission_callback' => [self::class, 'logged_in'],
            'callback' => [self::class, 'upload'],
        ]);
        register_rest_route('family-cookbook/v1', '/orders/(?P<order_id>\d+)/files/(?P<file_id>[a-f0-9-]+)', [
            'methods' => 'GET',
            'permission_callback' => [self::class, 'logged_in'],
            'callback' => [self::class, 'download'],
        ]);
    }

    public static function logged_in() {
        return is_user_logged_in()
            ? true
            : new WP_Error('fcs_auth_required', 'Authentication required.', ['status' => 401]);
    }

    private static function owned_order(int $order_id) {
        if (!function_exists('wc_get_order')) {
            return new WP_Error('fcs_woocommerce_required', 'WooCommerce order service unavailable.', ['status' => 503]);
        }
        $order = wc_get_order($order_id);
        if (!$order) {
            return new WP_Error('fcs_order_not_found', 'Order not found.', ['status' => 404]);
        }
        if ((int) $order->get_customer_id() !== get_current_user_id()) {
            return new WP_Error('fcs_order_forbidden', 'This order belongs to another user.', ['status' => 403]);
        }
        return $order;
    }

    private static function private_root(): string {
        $root = defined('FCS_PRIVATE_DIR') ? FCS_PRIVATE_DIR : sys_get_temp_dir() . '/family-cookbook-private';
        return rtrim($root, DIRECTORY_SEPARATOR);
    }

    private static function file_meta($order, string $file_id): ?array {
        $files = $order->get_meta(self::META_KEY, true);
        return is_array($files) && isset($files[$file_id]) && is_array($files[$file_id]) ? $files[$file_id] : null;
    }

    public static function upload(WP_REST_Request $request) {
        $order = self::owned_order((int) $request['order_id']);
        if (is_wp_error($order)) { return $order; }

        $files = $request->get_file_params();
        $file = $files['file'] ?? null;
        if (!is_array($file) || ($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            return new WP_Error('fcs_file_required', 'One upload file is required.', ['status' => 400]);
        }
        $size = (int) ($file['size'] ?? 0);
        if ($size < 1) {
            return new WP_Error('fcs_empty_file', 'Empty files are not accepted.', ['status' => 400]);
        }
        if ($size > self::MAX_BYTES) {
            return new WP_Error('fcs_file_too_large', 'Maximum file size is 2 MiB.', ['status' => 413]);
        }
        $tmp = (string) ($file['tmp_name'] ?? '');
        $name = sanitize_file_name((string) ($file['name'] ?? 'upload'));
        $checked = wp_check_filetype_and_ext($tmp, $name);
        $mime = (new finfo(FILEINFO_MIME_TYPE))->file($tmp);
        $allowed = ['image/png' => 'png', 'image/jpeg' => 'jpg'];
        if (!isset($allowed[$mime]) || ($checked['type'] ?? null) !== $mime) {
            return new WP_Error('fcs_file_type_denied', 'Only validated PNG or JPEG images are accepted.', ['status' => 415]);
        }
        $root = self::private_root();
        if (!wp_mkdir_p($root)) {
            return new WP_Error('fcs_private_storage_unavailable', 'Private storage unavailable.', ['status' => 500]);
        }
        $file_id = wp_generate_uuid4();
        $path = $root . DIRECTORY_SEPARATOR . $file_id . '.' . $allowed[$mime];
        if (!move_uploaded_file($tmp, $path)) {
            return new WP_Error('fcs_private_write_failed', 'Private storage write failed.', ['status' => 500]);
        }
        @chmod($path, 0600);
        $files = $order->get_meta(self::META_KEY, true);
        if (!is_array($files)) { $files = []; }
        $meta = [
            'id' => $file_id,
            'kind' => 'recipe_image',
            'path' => $path,
            'mime' => $mime,
            'bytes' => filesize($path),
            'sha256' => hash_file('sha256', $path),
        ];
        $files[$file_id] = $meta;
        $order->update_meta_data(self::META_KEY, $files);
        $order->save();
        return new WP_REST_Response([
            'access' => 'PASS',
            'order_id' => (int) $order->get_id(),
            'file_id' => $file_id,
            'mime' => $meta['mime'],
            'bytes' => $meta['bytes'],
            'sha256' => $meta['sha256'],
            'storage' => 'outside_document_root',
        ], 201);
    }

    public static function download(WP_REST_Request $request) {
        $order = self::owned_order((int) $request['order_id']);
        if (is_wp_error($order)) { return $order; }
        $file_id = sanitize_text_field((string) $request['file_id']);
        $meta = self::file_meta($order, $file_id);
        if (!$meta) {
            return new WP_Error('fcs_file_not_bound_to_order', 'File is not bound to this order.', ['status' => 404]);
        }
        $root = realpath(self::private_root());
        $path = realpath((string) ($meta['path'] ?? ''));
        if (!$root || !$path || !str_starts_with($path, $root . DIRECTORY_SEPARATOR) || !is_file($path)) {
            return new WP_Error('fcs_private_file_unavailable', 'Private file unavailable.', ['status' => 404]);
        }
        $bytes = file_get_contents($path);
        return new WP_REST_Response([
            'access' => 'PASS',
            'order_id' => (int) $order->get_id(),
            'file_id' => $file_id,
            'mime' => $meta['mime'],
            'bytes' => strlen($bytes),
            'sha256' => hash('sha256', $bytes),
            'content_base64' => base64_encode($bytes),
        ], 200);
    }

    public static function preview(): string {
        $url = plugins_url('preview/index.html', __FILE__);
        return '<section class="fcs-g2a1-preview"><h2>Browser-local cookbook preview</h2><iframe title="Browser-local cookbook preview" src="' . esc_url($url) . '" loading="eager"></iframe></section>';
    }

    public static function order_proof(): string {
        $config = [
            'restBase' => esc_url_raw(rest_url('family-cookbook/v1')),
            'nonce' => wp_create_nonce('wp_rest'),
        ];
        return '<section class="fcs-g2a1-order-proof"><label>Dummy order ID <input id="fcs-order-id" inputmode="numeric"></label><label>Recipe image <input id="fcs-file" type="file" accept="image/png,image/jpeg"></label><p>Local proof adapter: PNG/JPEG up to 2 MiB.</p></section><script>window.FCSProof=' . wp_json_encode($config) . ';</script><style>.fcs-g2a1-preview iframe{display:block;width:100%;height:980px;border:1px solid #ddd}.fcs-g2a1-order-proof{max-width:42rem;margin:auto;padding:1rem}.fcs-g2a1-order-proof label{display:block;margin:1rem 0}.fcs-g2a1-order-proof input{max-width:100%}</style>';
    }
}
FCS_G2A1_Proof_Adapter::boot();
