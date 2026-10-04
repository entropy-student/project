<?php
/**
 * CLI-only local page seed for the G3CR7R1 visual/runtime proof.
 * Creates static shortcode pages only; never receives intake data or photos.
 */
if (PHP_SAPI !== 'cli' || getenv('BMS_G3CR7R1_LOCAL_ONLY') !== '1') {
 fwrite(STDERR, "Set BMS_G3CR7R1_LOCAL_ONLY=1 and run from CLI in the local WordPress container.\n");
 exit(1);
}
require_once dirname(__DIR__, 3) . '/wp-load.php';

$pages = [
 ['post_title' => 'Make their birthday magazine', 'post_name' => 'make-your-magazine', 'post_content' => "<!-- wp:shortcode -->\n[bms_g3cr7_intake]\n<!-- /wp:shortcode -->"],
 ['post_title' => 'Magazine status preview — local fixture', 'post_name' => 'magazine-status-preview', 'post_content' => "<!-- wp:shortcode -->\n[bms_g3cr7_status_fixture]\n<!-- /wp:shortcode -->"]
];
$result = [];
foreach ($pages as $page) {
 $existing = get_page_by_path($page['post_name'], OBJECT, 'page');
 if ($existing) {
  $result[] = ['slug' => $page['post_name'], 'id' => $existing->ID, 'action' => 'EXISTS_UNCHANGED'];
  continue;
 }
 $id = wp_insert_post(array_merge($page, ['post_type' => 'page', 'post_status' => 'publish']), true);
 if (is_wp_error($id)) {
  fwrite(STDERR, $id->get_error_message() . "\n");
  exit(1);
 }
 $result[] = ['slug' => $page['post_name'], 'id' => $id, 'action' => 'CREATED'];
}
echo wp_json_encode($result, JSON_PRETTY_PRINT) . "\n";
