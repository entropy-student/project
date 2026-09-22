<?php
if (!defined('ABSPATH')) { fwrite(STDERR, "Run via wp eval-file.\n"); exit(1); }

$root = dirname(__DIR__);
$pages = [
    ['Home', 'home', 'home.html'],
    ['How it works', 'how-it-works', 'how-it-works.html'],
    ['Demo', 'demo', 'demo.html'],
    ['Pricing', 'pricing', 'pricing.html'],
    ['FAQ', 'faq', 'faq.html'],
    ['Blog', 'blog', 'blog.html'],
];

function cla_upsert_page($title, $slug, $file, $root) {
    $existing = get_page_by_path($slug, OBJECT, 'page');
    $content = file_get_contents($root . '/content/pages/' . $file);
    $postarr = [
        'post_title' => $title,
        'post_name' => $slug,
        'post_content' => $content,
        'post_status' => 'publish',
        'post_type' => 'page',
    ];
    if ($existing) { $postarr['ID'] = $existing->ID; }
    $id = wp_insert_post($postarr, true);
    if (is_wp_error($id)) { throw new RuntimeException($id->get_error_message()); }
    return $id;
}

$ids = [];
foreach ($pages as [$title, $slug, $file]) {
    $ids[$slug] = cla_upsert_page($title, $slug, $file, $root);
}
update_option('show_on_front', 'page');
update_option('page_on_front', $ids['home']);
update_option('page_for_posts', 0);
update_option('blogname', 'Conversion Leak Audit');
update_option('blogdescription', 'Find observable store leaks before buying more traffic.');
update_option('permalink_structure', '/%postname%/');
flush_rewrite_rules(false);

// Remove WordPress starter content so parent theme page-list navigation does not expose noise.
$sample = get_page_by_path('sample-page', OBJECT, 'page');
if ($sample) { wp_delete_post($sample->ID, true); }
$hello = get_page_by_path('hello-world', OBJECT, 'post');
if ($hello) { wp_delete_post($hello->ID, true); }

// Keep the Blog entry as a normal editable page during G1. Real post-index behavior is not needed yet.
update_option('page_for_posts', 0);

echo json_encode(['seeded' => array_keys($ids), 'front_page_id' => $ids['home']], JSON_PRETTY_PRINT) . "\n";
