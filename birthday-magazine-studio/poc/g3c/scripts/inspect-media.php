<?php
function walk(array $blocks): void { foreach ($blocks as $b) { $name=$b['blockName']??''; if (str_contains($name,'gallery') || $name==='core/image' || $name==='stackable/image') { $imgs=[]; preg_match_all('/<img\\b[^>]*>/is',$b['innerHTML']??'',$m); foreach(($m[0]??[]) as $tag)$imgs[]=$tag; echo wp_json_encode(['block'=>$name,'attrs'=>$b['attrs']??[],'images'=>$imgs],JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE)."\n";} if(!empty($b['innerBlocks']))walk($b['innerBlocks']); }}
walk(parse_blocks(get_post_field('post_content',858)));
