<?php
// Read-only projection: no setup, configuration, account, order or content writes.
define('DISABLE_WP_CRON', true);
require '/var/www/html/wp-load.php';
$id = (int) get_option('page_on_front');
$home = get_post($id);
$groups = [];
foreach (parse_blocks($home->post_content) as $block) {
    if ($block['blockName'] === 'core/group') {
        $groups[] = ['class' => $block['attrs']['className'] ?? null, 'anchor' => $block['attrs']['anchor'] ?? null];
    }
}
$GLOBALS['wp_query'] = new WP_Query(['page_id' => $id]);
$template = get_page_template();
$owner = get_user_by('login', 'bms-owner');
$product = wc_get_product(1113);
$menus = [];
foreach (get_nav_menu_locations() as $location => $menu_id) {
    $menus[$location] = array_map(static fn($item) => ['label' => $item->title, 'url' => $item->url], wp_get_nav_menu_items($menu_id) ?: []);
}
$footer = get_post((int) get_option('bms_g3cr6r1_footer_id'));
echo wp_json_encode([
    'home_id' => $id, 'home_title' => $home->post_title,
    'home_sha256' => hash('sha256', $home->post_content), 'groups' => $groups,
    'preview_shortcode_present' => has_shortcode($home->post_content, 'bms_preview'),
    'gutenberg' => use_block_editor_for_post($home),
    'theme' => wp_get_theme()->get_stylesheet(), 'theme_version' => wp_get_theme()->get('Version'),
    'page_template_slug' => get_page_template_slug($id),
    'resolved_page_template' => str_replace(ABSPATH, '', $template),
    'wordpress' => $GLOBALS['wp_version'], 'woocommerce' => WC_VERSION,
    'menus' => $menus,
    'owner_administrator' => $owner && in_array('administrator', $owner->roles, true),
    'owner_edit_home' => $owner && user_can($owner, 'edit_post', $id),
    'owner_media' => $owner && user_can($owner, 'upload_files'),
    'owner_global_style' => $owner && user_can($owner, 'edit_theme_options'),
    'product' => ['id' => 1113, 'price' => $product->get_price(), 'currency' => get_woocommerce_currency(), 'virtual' => $product->is_virtual(), 'url' => get_permalink(1113)],
    'routes' => ['cart' => wc_get_cart_url(), 'checkout' => wc_get_checkout_url(), 'account' => wc_get_page_permalink('myaccount')],
    'checkout_guest_enabled' => get_option('woocommerce_enable_guest_checkout'),
    'checkout_signup_enabled' => get_option('woocommerce_enable_signup_and_login_from_checkout'),
    'footer_sha256' => $footer ? hash('sha256', $footer->post_content) : null,
    'theme_mods_sha256' => hash('sha256', wp_json_encode(get_theme_mods())),
    'order_count' => count(wc_get_orders(['return' => 'ids', 'limit' => -1])),
    'generation_jobs' => (int) get_option('bms_g3a_generation_job_count', 0),
    'product_model_calls' => (int) get_option('bms_g3a_model_call_count', 0),
    'active_plugins' => get_option('active_plugins'),
    'protected_runtime_hashes' => [
        'commerce_workspace' => hash_file('sha256', WP_PLUGIN_DIR . '/bms-g3a-commerce-loop/bms-g3a-commerce-loop.php'),
        'woocommerce_main' => hash_file('sha256', WP_PLUGIN_DIR . '/woocommerce/woocommerce.php'),
        'preview_php' => hash_file('sha256', WP_PLUGIN_DIR . '/bms-g3c-preview/birthday-magazine-poc.php'),
        'preview_js' => hash_file('sha256', WP_PLUGIN_DIR . '/bms-g3c-preview/preview.js'),
        'preview_css' => hash_file('sha256', WP_PLUGIN_DIR . '/bms-g3c-preview/magazine-preview.css'),
    ],
], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n";
