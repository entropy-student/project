<?php
require '/var/www/html/wp-load.php';
if (get_option('home') !== 'http://127.0.0.1:8189' || !get_option('bms_g3cr6r1_footer_id')) { exit(2); }
$home = get_post_field('post_content',858);
$blocks = parse_blocks($home);
$changed = false;
foreach ($blocks as &$block) {
 if (($block['attrs']['className'] ?? '') === 'bms-included' && ($block['attrs']['anchor'] ?? '') === 'included') {
  $block['attrs']['anchor'] = 'what-you-get';
  $block['innerHTML'] = str_replace('id="included"', 'id="what-you-get"', $block['innerHTML']);
  $block['innerContent'] = array_map(fn($part) => is_string($part) ? str_replace('id="included"', 'id="what-you-get"', $part) : $part, $block['innerContent']);
  $changed = true;
 }
}
unset($block);
if ($changed) { wp_update_post(wp_slash(['ID'=>858, 'post_content'=>serialize_blocks($blocks)])); }
echo 'EXISTING_MENU_ANCHOR_PRESERVED=' . ($changed ? 'YES' : 'ALREADY_ALIGNED') . "\n";
$palette = [];
foreach (['#c74e39','#a83d2c','#746760','#342a27','#dfcfc2','#f5ebdf','#fff9f2','#efd8ce'] as $index => $color) {
 $palette['color' . ($index + 1)] = ['color' => $color];
}
set_theme_mod('colorPalette', $palette);
echo "BLOCKSY_EDITABLE_GLOBAL_PALETTE=APPLIED\n";
