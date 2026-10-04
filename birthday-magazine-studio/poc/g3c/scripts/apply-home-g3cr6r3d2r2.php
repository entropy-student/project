<?php
// R2 presentation only. Fail closed against the accepted D2 Home.
define('DISABLE_WP_CRON', true);
require '/var/www/html/wp-load.php';
$before = get_post_field('post_content', 858);
if (get_option('page_on_front') != 858 || wp_get_theme()->get_stylesheet() !== 'blocksy'
    || hash('sha256', $before) !== '2e344d1edb45808d31e5e2ca8622a349dce6d58057acac424f1ed8538edbdc87') {
    throw new RuntimeException('R2 accepted baseline drift; do not replay');
}
$changes = [
    [1137, 'Fictional magazine gift scene', 'bms-panel-background', 'preview-memories-panel.png', 'Two fictional friends sharing printed memories; original illustrative photograph'],
    [1137, 'A birthday magazine gift, fictional sample shown', 'bms-panel-background', 'offer-birthday-panel.png', 'Fictional father and daughter celebrating a birthday; original illustrative photograph'],
    [1139, 'Fictional sample cover: Alex', 'bms-card-cover', 'sample-eli-cover.png', 'Fictional Eli birthday cover on a terracotta table; illustrative static sample'],
    [1138, 'Fictional editorial photo and story spread', '', 'sample-moments-spread.png', 'Fictional photo-story spread on a blue and yellow surface; illustrative static sample'],
    [1137, 'Fictional birthday magazine as a thoughtful gift', '', 'sample-lena-gift.png', 'Fictional Lena receiving a birthday magazine; illustrative static sample'],
];
$content = $before;
foreach ($changes as [$id, $oldAlt, $class, $file, $alt]) {
    $old = '<!-- wp:image ' . wp_json_encode(['id'=>$id,'sizeSlug'=>'full','linkDestination'=>'none','className'=>$class], JSON_UNESCAPED_SLASHES) . " -->\n"
        . '<figure class="wp-block-image size-full ' . $class . '"><img src="' . esc_url(wp_get_attachment_url($id)) . '" alt="' . esc_attr($oldAlt) . '" class="wp-image-' . $id . '" /></figure>' . "\n<!-- /wp:image -->\n";
    $asset = WP_PLUGIN_DIR . '/bms-g3c-preview/assets/g3cr6r3d2r2/' . $file;
    if (!is_file($asset) || substr_count($content, $old) !== 1) throw new RuntimeException('R2 exact image target/asset unavailable');
    $url = plugins_url('assets/g3cr6r3d2r2/' . $file, WP_PLUGIN_DIR . '/bms-g3c-preview/birthday-magazine-poc.php');
    $new = '<!-- wp:image ' . wp_json_encode(['sizeSlug'=>'full','linkDestination'=>'none','className'=>$class], JSON_UNESCAPED_SLASHES) . " -->\n"
        . '<figure class="wp-block-image size-full ' . $class . '"><img src="' . esc_url($url) . '" alt="' . esc_attr($alt) . '" /></figure>' . "\n<!-- /wp:image -->\n";
    $content = str_replace($old, $new, $content);
}
$result = wp_update_post(['ID'=>858,'post_content'=>$content], true);
if (is_wp_error($result)) throw new RuntimeException('R2 Home update failed');
echo wp_json_encode(['home'=>858,'before_sha256'=>hash('sha256',$before),'after_sha256'=>hash('sha256',get_post_field('post_content',858)),'image_replacements'=>count($changes),'menu_changes'=>0,'other_content_changes'=>0], JSON_PRETTY_PRINT) . "\n";
