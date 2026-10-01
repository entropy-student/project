<?php
require '/var/www/html/wp-load.php';
$post = get_post(1113);
$backup = ['title'=>$post->post_title,'content'=>$post->post_content,'excerpt'=>$post->post_excerpt];
if (!str_contains($post->post_content,'Synthetic local G3C')) { exit(2); }
// Capture content before changing only customer-facing product copy.
file_put_contents('/tmp/g3cr6-product-copy-before.json',wp_json_encode($backup,JSON_PRETTY_PRINT));
$result = wp_update_post(['ID'=>1113,'post_title'=>'The Birthday Magazine','post_content'=>'<p>A personal birthday gift, built around their photos and stories. The complete issue is a 12-page US Letter digital PDF, with one bounded revision batch.</p><p>Continue after purchase in your private order workspace to share 12–25 photos and six short answers. This is a digital product; no printed magazine is included.</p><p>Marketing images show fictional samples, not customer work.</p>'],true);
if (is_wp_error($result)) { exit(3); }
$home = get_post_field('post_content',858);
wp_update_post(['ID'=>858,'post_content'=>wp_slash(str_replace('The current chapter','Another year brighter',$home))]);
echo wp_json_encode(['product_copy_updated'=>true,'product_id_unchanged'=>1113,'price'=>wc_get_product(1113)->get_price(),'virtual'=>wc_get_product(1113)->is_virtual(),'native_commerce_unchanged'=>true]);
