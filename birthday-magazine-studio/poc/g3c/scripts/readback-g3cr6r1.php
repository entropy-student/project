<?php
require '/var/www/html/wp-load.php';
require_once ABSPATH . 'wp-admin/includes/plugin.php';
$home = get_post(858);
$product = wc_get_product(1113);
$owner = get_user_by('login', 'bms-owner');
$blocks = parse_blocks($home->post_content);
$images = [];
$classes = [];
$walk = function ($nodes) use (&$walk, &$images, &$classes) {
    foreach ($nodes as $node) {
        if (($node['blockName'] ?? '') === 'core/image') $images[] = $node['attrs']['id'];
        if (isset($node['attrs']['className'])) $classes[] = $node['attrs']['className'];
        $walk($node['innerBlocks'] ?? []);
    }
};
$walk($blocks);
$result = [
    'home_id' => 858,
    'home_sha256' => hash('sha256', $home->post_content),
    'top_level_groups' => count(array_filter($blocks, fn($b) => ($b['blockName'] ?? '') === 'core/group')),
    'core_block_roundtrip' => hash('sha256', do_blocks($home->post_content)) === hash('sha256', do_blocks(serialize_blocks($blocks))),
    'classes' => $classes,
    'image_ids' => $images,
    'image_files_exist' => array_map(fn($id) => is_file(get_attached_file($id)), $images),
    'gutenberg' => use_block_editor_for_post(858),
    'owner_administrator' => in_array('administrator', $owner->roles, true),
    'owner_edit_home' => user_can($owner, 'edit_post', 858),
    'owner_media' => user_can($owner, 'upload_files'),
    'owner_global_style' => user_can($owner, 'edit_theme_options'),
    'owner_reorder_major_sections' => use_block_editor_for_post(858) && user_can($owner, 'edit_post', 858),
    'product' => ['id' => 1113, 'price' => $product->get_price(), 'currency' => get_woocommerce_currency(), 'virtual' => $product->is_virtual(), 'thumbnail' => get_post_thumbnail_id(1113)],
    'wordpress' => $GLOBALS['wp_version'],
    'woocommerce' => WC_VERSION,
    'theme' => wp_get_theme()->get_stylesheet(),
    'blocksy' => wp_get_theme()->get('Version'),
    'active_plugins' => get_option('active_plugins'),
    'order_count' => count(wc_get_orders(['return' => 'ids', 'limit' => -1])),
    'generation_jobs' => (int) get_option('bms_g3a_generation_job_count', 0),
    'product_model_calls' => (int) get_option('bms_g3a_model_call_count', 0),
    'counter_options_present' => get_option('bms_g3a_generation_job_count', false) !== false,
    'footer_placements' => get_theme_mod('footer_placements'),
    'editable_global_palette' => get_theme_mod('colorPalette'),
    'editable_footer_id' => (int) get_option('bms_g3cr6r1_footer_id', 0),
    'protected_runtime_hashes' => [
        'commerce_workspace' => hash_file('sha256', WP_PLUGIN_DIR . '/bms-g3a-commerce-loop/bms-g3a-commerce-loop.php'),
        'woocommerce_main' => hash_file('sha256', WP_PLUGIN_DIR . '/woocommerce/woocommerce.php'),
        'mailpit_mu' => hash_file('sha256', WPMU_PLUGIN_DIR . '/00-g3a-local-mailpit.php'),
    ],
];
if (($argv[1] ?? '') === 'snapshot') {
    $result['presentation_rollback'] = [
        'home' => ['id' => 858, 'content' => $home->post_content],
        'product' => ['id' => 1113, 'title' => get_post_field('post_title', 1113), 'content' => get_post_field('post_content', 1113), 'excerpt' => get_post_field('post_excerpt', 1113), 'thumbnail' => get_post_thumbnail_id(1113)],
        'theme_mods' => get_theme_mods(),
    ];
}
echo wp_json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n";
