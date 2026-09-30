<?php
$content = file_get_contents('/tmp/g3c-home-original.html');
$content = preg_replace('/^\xEF\xBB\xBF/', '', $content);
$result = wp_update_post(['ID' => 858, 'post_content' => wp_slash($content)], true);
if (is_wp_error($result)) { fwrite(STDERR, $result->get_error_message()."\n"); exit(2); }
echo json_encode(['restored_page_id'=>858,'bytes'=>strlen($content),'contains_original_hero'=>str_contains($content,'Your Fairytale'),'contains_preview'=>has_shortcode($content,'bms_preview')], JSON_PRETTY_PRINT)."\n";
