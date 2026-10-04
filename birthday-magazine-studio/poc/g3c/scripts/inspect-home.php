<?php
function bms_blocks(array $blocks, string $path = ''): void {
  foreach ($blocks as $i => $b) {
    $name = $b['blockName'] ?: 'core/freeform';
    $where = $path . $i . '/' . $name;
    $html = preg_replace('#<style\\b[^>]*>.*?</style>#is', '', $b['innerHTML'] ?? '');
    $text = trim(preg_replace('/\\s+/', ' ', html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5)));
    $attrs = $b['attrs'] ?? [];
    $brief = [];
    foreach (['text','content','url','href','linkTarget','imageId','mediaId','title'] as $k) if (isset($attrs[$k]) && is_scalar($attrs[$k])) $brief[$k] = $attrs[$k];
    if (str_contains($name, 'heading') || str_contains($name, 'text') || str_contains($name, 'button') || $name === 'core/shortcode' || $name === 'core/image' || $name === 'image') {
      if ($text !== '' || $brief) echo wp_json_encode(['path'=>$where,'attrs'=>$brief,'text'=>mb_substr($text,0,260)], JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE) . "\n";
    }
    if (!empty($b['innerBlocks'])) bms_blocks($b['innerBlocks'], $where . '.');
  }
}
bms_blocks(parse_blocks(get_post_field('post_content', 858)));
