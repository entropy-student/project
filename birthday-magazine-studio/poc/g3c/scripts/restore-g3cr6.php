<?php
require '/var/www/html/wp-load.php';
$backup = json_decode(file_get_contents($argv[1] ?? '/tmp/g3cr6-backup.json'), true);
$product_copy = json_decode(file_get_contents($argv[2] ?? '/tmp/g3cr6-product-copy-before.json'), true);
if (($backup['home']['id'] ?? 0) !== 858 || (int)get_option('page_on_front') !== 858 || !isset($product_copy['title'])) { exit(2); }
$result = wp_update_post(['ID'=>858,'post_content'=>wp_slash($backup['home']['content'])], true);
if (is_wp_error($result)) { exit(3); }
if ($backup['product_thumbnail_before']) { set_post_thumbnail(1113,$backup['product_thumbnail_before']); } else { delete_post_thumbnail(1113); }
wp_update_post(['ID'=>1113,'post_title'=>$product_copy['title'],'post_content'=>wp_slash($product_copy['content']),'post_excerpt'=>wp_slash($product_copy['excerpt'])]);
if (hash('sha256',get_post_field('post_content',858)) !== hash('sha256',$backup['home']['content'])) { exit(4); }
echo "Home and product image restored; restore preview-plugin-before files separately.\n";
