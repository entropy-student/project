<?php
// Default dry mode proves compatibility; apply is an explicit later rollback action.
define('DISABLE_WP_CRON', true);
require '/var/www/html/wp-load.php';
$envelope = json_decode(stream_get_contents(STDIN), true, 512, JSON_THROW_ON_ERROR);
$backup = $envelope['backup'];
$dry = ($envelope['mode'] ?? 'dry') === 'dry';
if ((int)$backup['home']['id'] !== 858 || (int)get_option('page_on_front') !== 858) throw new RuntimeException('Home target mismatch');
if (hash('sha256', $backup['home']['content']) !== $backup['home']['sha256']) throw new RuntimeException('Backup integrity failure');
if (count($backup['target_menu_items']) !== 1 || (int)$backup['target_menu_items'][0]['id'] !== 1098) throw new RuntimeException('Menu cardinality mismatch');
$item = get_post(1098);
if (!$item || $item->post_type !== 'nav_menu_item' || $item->post_title !== $backup['target_menu_items'][0]['title']) throw new RuntimeException('Menu identity mismatch');
$groups = count(array_filter(parse_blocks($backup['home']['content']), fn($b) => $b['blockName'] === 'core/group'));
if ($groups !== 8 || !has_shortcode($backup['home']['content'], 'bms_preview')) throw new RuntimeException('Backup block compatibility failure');
if (!$dry) {
    $result = wp_update_post(['ID' => 858, 'post_content' => $backup['home']['content']], true);
    if (is_wp_error($result)) throw new RuntimeException($result->get_error_message());
    update_post_meta(1098, '_menu_item_url', $backup['target_menu_items'][0]['url']);
}
echo wp_json_encode(['mode' => $dry ? 'dry_no_write' : 'apply', 'integrity' => true, 'home_id' => 858, 'restorable_groups' => $groups, 'preview_present' => true, 'menu_id' => 1098, 'restore_hash' => $backup['home']['sha256'], 'write_count' => $dry ? 0 : 2], JSON_PRETTY_PRINT);
