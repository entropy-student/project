<?php
if (!defined('ABSPATH')) { exit; }
if (!class_exists('WooCommerce') || !function_exists('wc_create_order')) {
    fwrite(STDERR, "WooCommerce is not active\n");
    exit(2);
}
$user_a_password = getenv('FCS_USER_A_PASSWORD');
$user_b_password = getenv('FCS_USER_B_PASSWORD');
if (!$user_a_password || !$user_b_password) { fwrite(STDERR, "Test users were not configured\n"); exit(2); }

function fcs_make_user(string $login, string $password): int {
    $id = username_exists($login);
    if (!$id) {
        $id = wp_create_user($login, $password, $login . '@example.invalid');
        if (is_wp_error($id)) { throw new RuntimeException($id->get_error_message()); }
    }
    wp_update_user(['ID' => (int) $id, 'role' => 'customer']);
    return (int) $id;
}

function fcs_make_order(int $user_id, $product): int {
    $order = wc_create_order(['customer_id' => $user_id]);
    $order->add_product($product, 1);
    $order->set_status('pending');
    $order->calculate_totals();
    $order->save();
    return (int) $order->get_id();
}

$user_a = fcs_make_user('fcs-dummy-a', $user_a_password);
$user_b = fcs_make_user('fcs-dummy-b', $user_b_password);
$product = new WC_Product_Simple();
$product->set_name('Synthetic G2A1 test item');
$product->set_status('publish');
$product->set_catalog_visibility('hidden');
$product->set_regular_price('1.00');
$product->set_virtual(true);
$product_id = $product->save();
$order_a = fcs_make_order($user_a, wc_get_product($product_id));
$order_b = fcs_make_order($user_b, wc_get_product($product_id));

$root = defined('FCS_PRIVATE_DIR') ? FCS_PRIVATE_DIR : sys_get_temp_dir() . '/family-cookbook-private';
if (!wp_mkdir_p($root)) { throw new RuntimeException('Unable to create private test directory'); }
$file_id = wp_generate_uuid4();
$content = "BT /F1 16 Tf 72 720 Td (Synthetic private delivery proof) Tj ET";
$objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
    '<< /Length ' . strlen($content) . " >>\nstream\n" . $content . "\nendstream",
];
$pdf = "%PDF-1.4\n";
$offsets = [0];
foreach ($objects as $i => $body) {
    $offsets[] = strlen($pdf);
    $pdf .= ($i + 1) . " 0 obj\n" . $body . "\nendobj\n";
}
$xref = strlen($pdf);
$pdf .= "xref\n0 " . (count($objects) + 1) . "\n0000000000 65535 f \n";
for ($i = 1; $i <= count($objects); $i++) { $pdf .= sprintf("%010d 00000 n \n", $offsets[$i]); }
$pdf .= "trailer\n<< /Size " . (count($objects) + 1) . " /Root 1 0 R >>\nstartxref\n" . $xref . "\n%%EOF\n";
$pdf_path = $root . DIRECTORY_SEPARATOR . $file_id . '.pdf';
file_put_contents($pdf_path, $pdf);
@chmod($pdf_path, 0600);
$order = wc_get_order($order_a);
$files = $order->get_meta('_fcs_g2a1_private_files', true);
if (!is_array($files)) { $files = []; }
$files[$file_id] = [
    'id' => $file_id,
    'kind' => 'synthetic_pdf_delivery',
    'path' => $pdf_path,
    'mime' => 'application/pdf',
    'bytes' => filesize($pdf_path),
    'sha256' => hash_file('sha256', $pdf_path),
];
$order->update_meta_data('_fcs_g2a1_private_files', $files);
$order->save();

$preview_id = wp_insert_post(['post_type' => 'page', 'post_status' => 'publish', 'post_title' => 'G2A1 Local Preview', 'post_name' => 'fcs-local-preview', 'post_content' => '[fcs_preview]']);
$proof_id = wp_insert_post(['post_type' => 'page', 'post_status' => 'publish', 'post_title' => 'G2A1 Order Proof', 'post_name' => 'fcs-order-proof', 'post_content' => '[fcs_order_proof]']);
$out = [
    'wordpress_version' => get_bloginfo('version'),
    'woocommerce_version' => defined('WC_VERSION') ? WC_VERSION : null,
    'mariadb_version' => $wpdb->get_var('SELECT VERSION()'),
    'kadence_version' => wp_get_theme('kadence')->get('Version'),
    'user_a_id' => $user_a,
    'user_b_id' => $user_b,
    'order_a_id' => $order_a,
    'order_b_id' => $order_b,
    'delivery_file_id' => $file_id,
    'delivery_sha256' => hash('sha256', $pdf),
    'delivery_bytes' => strlen($pdf),
    'preview_url' => get_permalink($preview_id),
    'proof_url' => get_permalink($proof_id),
    'storage_location' => 'container /tmp outside /var/www/html document root',
];
file_put_contents('/fcs-out/wp-test-ids.json', wp_json_encode($out, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
echo wp_json_encode(['setup' => 'complete', 'versions' => ['wordpress' => $out['wordpress_version'], 'woocommerce' => $out['woocommerce_version'], 'kadence' => $out['kadence_version']], 'orders_created' => 2, 'payment' => 'none']) . "\n";
