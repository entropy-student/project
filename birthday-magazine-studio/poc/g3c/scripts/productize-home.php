<?php
if (!defined('ABSPATH') || !class_exists('WooCommerce')) {
    fwrite(STDERR, "G3C requires the local WordPress/WooCommerce runtime.\n");
    exit(2);
}

function bms_g3c_plain($html): string {
    $html = preg_replace('#<style\b[^>]*>.*?</style>#is', '', (string) $html);
    $html = preg_replace('#<script\b[^>]*>.*?</script>#is', '', $html);
    $html = preg_replace('/<br\s*\/?>/i', ' ', $html);
    return trim(preg_replace('/\s+/', ' ', html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5, 'UTF-8')));
}

function bms_g3c_replace_tag(string $html, string $pattern, string $replacement): string {
    return preg_replace_callback($pattern, static function ($m) use ($replacement) {
        return $m[1] . $replacement . $m[3];
    }, $html, 1) ?? $html;
}

function bms_g3c_set_block_html(array &$block, string $html): void {
    $block['innerHTML'] = $html;
    if (empty($block['innerBlocks'])) {
        $block['innerContent'] = [$html];
    }
}

function bms_g3c_attachment_image(int $id): array {
    $full = wp_get_attachment_image_src($id, 'full');
    $metadata = wp_get_attachment_metadata($id) ?: [];
    $sizes = [];
    foreach (['thumbnail', 'medium', 'large'] as $size) {
        $src = wp_get_attachment_image_src($id, $size);
        if ($src) {
            $sizes[$size] = ['url' => $src[0], 'width' => $src[1], 'height' => $src[2], 'orientation' => $src[1] >= $src[2] ? 'landscape' : 'portrait'];
        }
    }
    if ($full) {
        $sizes['full'] = ['url' => $full[0], 'width' => $full[1], 'height' => $full[2], 'orientation' => $full[1] >= $full[2] ? 'landscape' : 'portrait'];
    }
    return [
        'id' => $id,
        'title' => 'Synthetic sample page',
        'url' => $full ? $full[0] : wp_get_attachment_url($id),
        'link' => wp_get_attachment_url($id),
        'alt' => 'Synthetic sample page — not a customer issue',
        'description' => 'Synthetic fixture used for the local G3C page preview.',
        'caption' => 'Synthetic sample page',
        'mime' => get_post_mime_type($id),
        'type' => 'image',
        'width' => $metadata['width'] ?? ($full[1] ?? 0),
        'height' => $metadata['height'] ?? ($full[2] ?? 0),
        'sizes' => $sizes,
        'postlink' => wp_get_attachment_link($id, 'full', false, false),
    ];
}

function bms_g3c_rewrite_img_tags(string $html, array $old_to_new): string {
    return preg_replace_callback('/<img\b[^>]*>/i', static function ($match) use ($old_to_new) {
        $tag = $match[0];
        $old_id = 0;
        if (preg_match('/\bwp-image-(\d+)\b/', $tag, $id_match)) {
            $old_id = (int) $id_match[1];
        } elseif (preg_match('/\bdata-id="(\d+)"/', $tag, $id_match)) {
            $old_id = (int) $id_match[1];
        }
        if (!$old_id || !isset($old_to_new[$old_id])) {
            return $tag;
        }
        $new_id = (int) $old_to_new[$old_id];
        $image = bms_g3c_attachment_image($new_id);
        $tag = preg_replace('/\s(?:srcset|sizes)="[^"]*"/i', '', $tag) ?? $tag;
        $set = static function (string $html, string $name, string $value): string {
            $escaped = esc_attr($value);
            if (preg_match('/\s' . preg_quote($name, '/') . '="[^"]*"/i', $html)) {
                return preg_replace('/\s' . preg_quote($name, '/') . '="[^"]*"/i', ' ' . $name . '="' . $escaped . '"', $html, 1) ?? $html;
            }
            return preg_replace('/\s*\/?>(?=$)/', ' ' . $name . '="' . $escaped . '"' . (str_ends_with(trim($html), '/>') ? ' /\>' : '>'), $html, 1) ?? $html;
        };
        foreach (['src' => $image['url'], 'data-link' => $image['url'], 'data-id' => (string) $new_id, 'alt' => $image['alt'], 'title' => $image['title'], 'width' => (string) $image['width'], 'height' => (string) $image['height']] as $name => $value) {
            $tag = $set($tag, $name, $value);
        }
        $tag = preg_replace('/\bwp-image-\d+\b/', 'wp-image-' . $new_id, $tag) ?? $tag;
        return $tag;
    }, $html) ?? $html;
}

function bms_g3c_rewrite_blocks(array &$blocks, array $image_map, string $product_url, int &$card_copy_count, int &$curabitur_count): void {
    foreach ($blocks as &$block) {
        $name = $block['blockName'] ?? '';
        $plain = bms_g3c_plain($block['innerHTML'] ?? '');
        $html = $block['innerHTML'] ?? '';

        if ($name === 'stackable/heading') {
            $heading = null;
            if (stripos($plain, 'fairytale') !== false) $heading = 'A Birthday<br>Magazine for Them';
            elseif (stripos($plain, 'Juliet') !== false || stripos($plain, 'Wedding') !== false) $heading = 'Birthday Person<br>Their Story';
            elseif ($plain === 'Photo Gallery') $heading = 'People & Memories';
            elseif ($plain === 'Pricing Plans') $heading = 'What You Get';
            elseif ($plain === 'Standart') $heading = '12-page digital issue';
            elseif ($plain === 'Premium') $heading = 'Made from their story';
            elseif ($plain === 'Platinum') $heading = 'One revision batch';
            elseif (strtolower($plain) === 'the stories') $heading = 'How It Works';
            elseif (stripos($plain, 'Dream Wedding') !== false) $heading = 'Create a Free Preview';
            if ($heading !== null) {
                $html = bms_g3c_replace_tag($html, '/(<h[1-6]\b[^>]*>)(.*?)(<\/h[1-6]>)/is', $heading);
                bms_g3c_set_block_html($block, $html);
            }
        } elseif ($name === 'stackable/text') {
            $replacement = null;
            if (stripos($plain, 'Once in a while') !== false) $replacement = 'Turn their photos and stories into a birthday magazine made just for them.';
            elseif (stripos($plain, 'Etiam convallis') !== false) $replacement = 'A thoughtful digital keepsake, shaped around the details and memories that make one person unmistakably themselves.';
            elseif (stripos($plain, 'Fusce ac condimentum') !== false) $replacement = 'A birthday issue brings their story, favorite people and everyday moments together in one place.';
            elseif (stripos($plain, 'marry the person') !== false) $replacement = 'A good story lives in the people, small details and moments that make someone unmistakably them.';
            elseif (stripos($plain, 'Purus velit') !== false) $replacement = 'Synthetic sample spreads show the editorial direction; each real issue will be based on the buyer’s own answers and photos.';
            elseif (stripos($plain, 'Curabitur') !== false) {
                $curabitur_count++;
                $replacement = $curabitur_count === 1
                    ? 'One US$39.99 purchase includes a 12-page US Letter digital PDF and one bounded revision batch.'
                    : 'A simple path from sample preview to a private WooCommerce order workspace.';
            } elseif (stripos($plain, 'Interview the couple') !== false) {
                $cards = [
                    'A fixed 12-page, story-led layout delivered as a digital US Letter PDF.',
                    'Personalized editorial copy and page mapping use the buyer’s answers and selected photos.',
                    'Includes one bounded revision batch for small factual, tone or photo changes.',
                ];
                $replacement = $cards[$card_copy_count] ?? $cards[2];
                $card_copy_count++;
            }
            if ($replacement !== null) {
                $html = bms_g3c_replace_tag($html, '/(<p\b[^>]*>)(.*?)(<\/p>)/is', esc_html($replacement));
                bms_g3c_set_block_html($block, $html);
            }
        } elseif ($name === 'stackable/button') {
            if ($plain === 'Learn More') {
                $html = preg_replace('/href="[^"]*"/i', 'href="#preview"', $html, 1) ?? $html;
                $html = str_replace('Learn More', 'See the free preview', $html);
                bms_g3c_set_block_html($block, $html);
            } elseif ($plain === 'SELECT') {
                $html = preg_replace('/href="[^"]*"/i', 'href="' . esc_url($product_url) . '"', $html, 1) ?? $html;
                $html = str_replace('SELECT', 'Unlock — US$39.99', $html);
                bms_g3c_set_block_html($block, $html);
            }
        }

        if ($name === 'stackable/image') {
            $old_id = absint($block['attrs']['imageId'] ?? 0);
            if (isset($image_map[$old_id])) {
                $new_id = (int) $image_map[$old_id];
                $image = bms_g3c_attachment_image($new_id);
                $block['attrs']['imageId'] = (string) $new_id;
                $block['attrs']['imageUrl'] = $image['url'];
                $block['attrs']['imageWidthAttribute'] = (int) $image['width'];
                $block['attrs']['imageHeightAttribute'] = (int) $image['height'];
            }
        } elseif ($name === 'core/image') {
            $old_id = absint($block['attrs']['id'] ?? 0);
            if (isset($image_map[$old_id])) $block['attrs']['id'] = (int) $image_map[$old_id];
        } elseif (str_starts_with($name, 'pgcsimplygalleryblock/')) {
            if (!empty($block['attrs']['images']) && is_array($block['attrs']['images'])) {
                foreach ($block['attrs']['images'] as &$gallery_image) {
                    $old_id = absint($gallery_image['id'] ?? 0);
                    if (!isset($image_map[$old_id])) continue;
                    $gallery_image = array_merge($gallery_image, bms_g3c_attachment_image((int) $image_map[$old_id]));
                }
                unset($gallery_image);
            }
            if (!empty($block['attrs']['galleryData'])) {
                $gallery_data = json_decode((string) $block['attrs']['galleryData'], true);
                if (is_array($gallery_data)) {
                    $gallery_data['externalLink'] = false;
                    $gallery_data['externalLinkDefName'] = 'Sample page';
                    $block['attrs']['galleryData'] = wp_json_encode($gallery_data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
                }
            }
        }

        if (!empty($block['innerContent'])) {
            foreach ($block['innerContent'] as &$part) {
                if (is_string($part)) $part = bms_g3c_rewrite_img_tags($part, $image_map);
            }
            unset($part);
            if (empty($block['innerBlocks'])) $block['innerHTML'] = implode('', array_filter($block['innerContent'], 'is_string'));
        }
        if (!empty($block['innerBlocks'])) bms_g3c_rewrite_blocks($block['innerBlocks'], $image_map, $product_url, $card_copy_count, $curabitur_count);
    }
    unset($block);
}

function bms_g3c_replace_dynamic_blocks(array &$blocks, string $product_id): void {
    $steps = <<<'BLOCKS'
<!-- wp:columns {"className":"bms-how-it-works"} -->
<div class="wp-block-columns bms-how-it-works"><!-- wp:column -->
<div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">01 — Choose photos and answer a few questions</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Share a few details and select the photos you want in the story.</p><!-- /wp:paragraph --></div><!-- /wp:column -->
<!-- wp:column --><div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">02 — Create a free preview</h3><!-- /wp:heading --><!-- wp:paragraph --><p>See an instant cover and one sample spread in this browser.</p><!-- /wp:paragraph --></div><!-- /wp:column -->
<!-- wp:column --><div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">03 — Unlock the full issue</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Purchase through WooCommerce and continue in the private order workspace.</p><!-- /wp:paragraph --></div><!-- /wp:column --></div>
<!-- /wp:columns -->
BLOCKS;
    $preview = '<!-- wp:shortcode -->[bms_preview product_id="' . absint($product_id) . '"]<!-- /wp:shortcode -->';
    $out = [];
    foreach ($blocks as $block) {
        $name = $block['blockName'] ?? '';
        $plain = bms_g3c_plain($block['innerHTML'] ?? '');
        if ($name === 'core/shortcode' && str_contains($plain, 'blocksy_posts')) {
            $out = array_merge($out, parse_blocks($steps));
            continue;
        }
        if ($name === 'wpforms/form-selector') {
            $out = array_merge($out, parse_blocks($preview));
            continue;
        }
        if (!empty($block['innerBlocks'])) bms_g3c_replace_dynamic_blocks($block['innerBlocks'], $product_id);
        $out[] = $block;
    }
    $blocks = $out;
}

function bms_g3c_remove_wedding_icon(array &$blocks): void {
    $kept = [];
    foreach ($blocks as $block) {
        $is_wedding_swan = ($block['blockName'] ?? '') === 'stackable/icon' && ($block['attrs']['uniqueId'] ?? '') === 'f95d48b';
        if ($is_wedding_swan) continue;
        if (!empty($block['innerBlocks']) && !empty($block['innerContent'])) {
            $new_children = [];
            $new_content = [];
            $child_index = 0;
            foreach ($block['innerContent'] as $chunk) {
                if (is_string($chunk)) {
                    $new_content[] = $chunk;
                    continue;
                }
                $child = $block['innerBlocks'][$child_index++] ?? null;
                if (!is_array($child)) continue;
                $children = [$child];
                bms_g3c_remove_wedding_icon($children);
                if (!$children) continue;
                $new_children[] = $children[0];
                $new_content[] = null;
            }
            $block['innerBlocks'] = $new_children;
            $block['innerContent'] = $new_content;
        }
        $kept[] = $block;
    }
    $blocks = $kept;
}

$product = wc_get_product(wc_get_product_id_by_sku('BMS-G3C-LOCAL-3999'));
if (!$product) {
    $product_id = wp_insert_post(['post_type' => 'product', 'post_status' => 'publish', 'post_title' => 'Personalized Birthday Magazine — 12-page digital PDF', 'post_name' => 'birthday-magazine']);
    if (is_wp_error($product_id)) { fwrite(STDERR, $product_id->get_error_message() . "\n"); exit(3); }
    $product = new WC_Product_Simple($product_id);
} else {
    $product_id = $product->get_id();
}
$product->set_name('Personalized Birthday Magazine — 12-page digital PDF');
$product->set_slug('birthday-magazine');
$product->set_sku('BMS-G3C-LOCAL-3999');
$product->set_regular_price('39.99');
$product->set_virtual(true);
$product->set_downloadable(false);
$product->set_manage_stock(false);
$product->set_catalog_visibility('visible');
$product->set_short_description('A 12-page US Letter digital birthday magazine, made from photos and stories.');
$product->set_description('Synthetic local G3C product listing. Purchase path only; no payment is submitted during this gate.');
if (wp_attachment_is_image(1106)) $product->set_image_id(1106);
$product->set_status('publish');
$product->save();
$product_id = $product->get_id();
$product_url = get_permalink($product_id);

update_option('woocommerce_currency', 'USD');
update_option('woocommerce_enable_guest_checkout', 'no');
update_option('woocommerce_enable_signup_and_login_from_checkout', 'yes');
update_option('woocommerce_enable_myaccount_registration', 'yes');
update_option('woocommerce_calc_taxes', 'no');
update_option('blogname', 'Birthday Magazine Studio');
update_option('blogdescription', 'Turn photos and stories into a birthday magazine.');
update_option('show_on_front', 'page');
update_option('page_on_front', 858);
update_option('blog_public', 0);

$home = get_post(858);
if (!$home || $home->post_name !== 'home') { fwrite(STDERR, "Imported Wedding Home page 858 not found.\n"); exit(4); }
$content = $home->post_content;
if (!has_shortcode($content, 'bms_preview')) {
    $hero_copy = 'Once in a while, right in the middle of an ordinary life, love gives us a fairytale';
    $hero_pos = strpos($content, $hero_copy);
    $hero_close = $hero_pos === false ? false : strpos($content, '<!-- /wp:stackable/text -->', $hero_pos);
    if ($hero_close === false) { fwrite(STDERR, "Wedding hero text block anchor was not found.\n"); exit(5); }
    $hero_close += strlen('<!-- /wp:stackable/text -->');
    $hero_cta = '<!-- wp:buttons {"className":"bms-hero-actions"} --><div class="wp-block-buttons bms-hero-actions"><!-- wp:button --><div class="wp-block-button"><a class="wp-block-button__link wp-element-button" href="#preview">Create a Free Preview</a></div><!-- /wp:button --></div><!-- /wp:buttons -->';
    $content = substr($content, 0, $hero_close) . $hero_cta . substr($content, $hero_close);
    $blocks = parse_blocks($content);
    bms_g3c_remove_wedding_icon($blocks);
    $copy_count = 0;
    $curabitur_count = 0;
    $image_map = [56=>1106, 55=>1107, 54=>1108, 126=>1109, 135=>1106, 136=>1107, 137=>1108, 138=>1109, 139=>1110, 140=>1111, 177=>1106, 180=>1110, 185=>1111, 184=>1112];
    bms_g3c_rewrite_blocks($blocks, $image_map, $product_url, $copy_count, $curabitur_count);
    if ($copy_count !== 3 || $curabitur_count !== 2) { fwrite(STDERR, "Wedding content structure differed from the inspected source; card or intro copy count mismatch.\n"); exit(6); }
    bms_g3c_replace_dynamic_blocks($blocks, (string) $product_id);
    $sample_cover = home_url('/wp-content/plugins/bms-g3c-preview/assets/birthday-magazine-cover.svg');
    foreach ($blocks as &$top_block) {
        if (($top_block['attrs']['uniqueId'] ?? '') === 'cf247fd') {
            $top_block['attrs']['blockBackgroundMediaUrl'] = $sample_cover;
        }
    }
    unset($top_block);
    $serialized = serialize_blocks($blocks);
    $serialized = str_replace('http://127.0.0.1:8189/wp-content/uploads/2022/05/hero-image-home@2x.webp', $sample_cover, $serialized);
    $hero_css = '.stk-cf247fd{background-color:#28303a!important;background-image:linear-gradient(90deg,rgba(23,27,35,.94) 0%,rgba(23,27,35,.84) 45%,rgba(23,27,35,.08) 100%),url("' . esc_url_raw($sample_cover) . '")!important;background-size:cover,auto 68%!important;background-position:center,right 7% center!important;background-repeat:no-repeat,no-repeat!important}.stk-block-heading.stk-436ce8b .stk-block-heading__text{text-align:left!important;font-size:clamp(40px,3.4vw,46px)!important;line-height:1.02!important;max-width:660px!important}.stk-38dc668 .stk-block-text__text{text-align:left!important;max-width:650px!important;margin-right:auto!important;margin-left:0!important}.bms-hero-actions .wp-block-button__link{background:#ed593c!important;color:#fff!important;border:0!important;border-radius:0!important;padding:15px 22px!important;font-weight:750!important}body.home #header a{color:#fff!important}@media(max-width:767px){.stk-cf247fd{background-position:center,right -24px bottom!important;background-size:cover,auto 43%!important;padding-top:150px!important;padding-bottom:80px!important}.stk-block-heading.stk-436ce8b .stk-block-heading__text{font-size:clamp(42px,11vw,60px)!important;line-height:1.02!important;max-width:330px!important}.stk-38dc668 .stk-block-text__text{max-width:300px!important}}';
    $serialized = preg_replace_callback('/<style>(.*?)<\/style>/is', static function ($m) use ($hero_css) { return '<style>' . $m[1] . $hero_css . '</style>'; }, $serialized, 1) ?? $serialized;
    $serialized = str_replace('id="photo-gallery"', 'id="sample-pages"', $serialized);
    $serialized = str_replace('id="pricing-plans"', 'id="what-you-get"', $serialized);
    $serialized = str_replace('id="the-stories"', 'id="how-it-works"', $serialized);
    $serialized = str_replace('id="lets-talk-about-your-dream-wedding"', 'id="preview-section"', $serialized);
    $serialized = str_replace('your-fairytale-br-starts-right-here', 'home-hero', $serialized);

    $sample_heading = <<<'BLOCKS'
<!-- wp:heading {"level":2,"anchor":"sample-issue"} --><h2 class="wp-block-heading" id="sample-issue">A look inside a synthetic sample issue</h2><!-- /wp:heading --><!-- wp:paragraph --><p>These sample pages use fictional test content and show the shared 12-page layout.</p><!-- /wp:paragraph -->
BLOCKS;
    $sample_blocks = parse_blocks($sample_heading);
    $serialized_blocks = parse_blocks($serialized);
    $insert_at = null;
    foreach ($serialized_blocks as $index => $top_block) {
        if (str_contains(serialize_block($top_block), 'wp-image-1112')) { $insert_at = $index; break; }
    }
    if ($insert_at !== null) array_splice($serialized_blocks, $insert_at, 0, $sample_blocks);
    else { fwrite(STDERR, "Synthetic sample cover row was not found.\n"); exit(7); }
    $serialized = serialize_blocks($serialized_blocks);

    $faq = <<<'BLOCKS'
<!-- wp:group {"className":"bms-faq","layout":{"type":"constrained"}} -->
<div class="wp-block-group bms-faq"><!-- wp:heading {"level":2,"anchor":"faq"} --><h2 class="wp-block-heading" id="faq">Frequently Asked Questions</h2><!-- /wp:heading -->
<!-- wp:details --><details class="wp-block-details"><summary>What is a Birthday Magazine?</summary><p>A personalized 12-page digital birthday magazine made from the buyer’s answers and selected photos.</p></details><!-- /wp:details -->
<!-- wp:details --><details class="wp-block-details"><summary>What will I receive?</summary><p>A 12-page US Letter PDF, including a front cover and back cover.</p></details><!-- /wp:details -->
<!-- wp:details --><details class="wp-block-details"><summary>Do I need design experience?</summary><p>No. The magazine follows a fixed page structure; you share the photos and stories instead of designing pages in Canva.</p></details><!-- /wp:details -->
<!-- wp:details --><details class="wp-block-details"><summary>Does the free preview upload my photo?</summary><p>No. The optional single cover photo is previewed from a browser-local object URL. The preview does not send it to the site and makes no AI calls.</p></details><!-- /wp:details -->
<!-- wp:details --><details class="wp-block-details"><summary>Why do I need an account?</summary><p>An authenticated account is required to access the private order workspace and order-bound proof and delivery.</p></details><!-- /wp:details -->
<!-- wp:details --><details class="wp-block-details"><summary>What is included in the revision?</summary><p>US$39.99 includes one bounded revision batch for small factual, tone or wording changes and photo swaps of up to three images.</p></details><!-- /wp:details -->
<!-- wp:details --><details class="wp-block-details"><summary>How long are photos and the final PDF kept?</summary><p>After final delivery, source photos and working files are deleted within 24 hours. The final PDF remains available for 72 hours.</p></details><!-- /wp:details --></div>
<!-- /wp:group -->
BLOCKS;
    $serialized .= "\n" . $faq . "\n";
    $result = wp_update_post(['ID' => 858, 'post_content' => wp_slash($serialized)], true);
    if (is_wp_error($result)) { fwrite(STDERR, $result->get_error_message() . "\n"); exit(8); }
}

$mods = get_theme_mod('header_placements', []);
if (isset($mods['sections']) && is_array($mods['sections'])) {
    foreach ($mods['sections'] as &$section) {
        if (isset($section['items']) && is_array($section['items'])) {
            foreach ($section['items'] as $item_index => &$item) {
                if (($item['id'] ?? '') === 'logo') {
                    foreach (['desktop', 'tablet', 'mobile'] as $device) {
                        $item['values']['custom_logo'][$device] = 0;
                        $item['values']['transparent_logo'][$device] = 0;
                    }
                    $item['values']['has_site_title'] = 'yes';
                }
                if (($item['id'] ?? '') === 'button') {
                    $item['values']['header_button_text'] = 'CREATE A FREE PREVIEW';
                    $item['values']['header_button_link'] = home_url('/#preview');
                }
                if (($item['id'] ?? '') === 'text') {
                    $header_text = (string) ($item['values']['header_text'] ?? '');
                    if (str_contains($header_text, 'footer-logo.svg') || str_contains($header_text, 'logo-dark.svg')) {
                        unset($section['items'][$item_index]);
                    }
                }
            }
            unset($item);
            $section['items'] = array_values($section['items']);
        }
        unset($section);
    }
    unset($section);
}
if (isset($mods['sections']) && is_array($mods['sections'])) {
    foreach ($mods['sections'] as &$section) {
        foreach (['desktop', 'mobile'] as $device) {
            if (empty($section[$device]) || !is_array($section[$device])) continue;
            foreach ($section[$device] as &$row) {
                if (!empty($row['placements']) && is_array($row['placements'])) {
                    foreach ($row['placements'] as &$placement) {
                        $remove_items = [];
                        if (($device === 'desktop' && ($row['id'] ?? '') === 'middle-row' && in_array($placement['id'] ?? '', ['start', 'end-middle'], true)) || ($device === 'mobile' && ($row['id'] ?? '') === 'offcanvas' && ($placement['id'] ?? '') === 'start')) {
                            $remove_items = ['socials', 'menu-secondary'];
                        }
                        $remove_items[] = 'text';
                        $placement['items'] = array_values(array_diff($placement['items'] ?? [], $remove_items));
                    }
                    unset($placement);
                }
            }
            unset($row);
        }
    }
    unset($section);
}
unset($section);
set_theme_mod('header_placements', $mods);

$widgets = get_option('widget_text', []);
if (isset($widgets[1])) { $widgets[1]['title'] = ''; $widgets[1]['text'] = ''; }
if (isset($widgets[2])) { $widgets[2]['title'] = 'About the magazine'; $widgets[2]['text'] = '<p>A story-led birthday magazine, shaped by the photos and details that matter to you.</p>'; }
if (isset($widgets[3])) { $widgets[3]['title'] = 'Quick Links'; $widgets[3]['text'] = '<ul><li><a href="' . esc_url(home_url('/#what-you-get')) . '">What You Get</a></li><li><a href="' . esc_url(home_url('/#how-it-works')) . '">How It Works</a></li><li><a href="' . esc_url(home_url('/#preview')) . '">Free Preview</a></li><li><a href="' . esc_url(wc_get_page_permalink('myaccount')) . '">My Account</a></li></ul>'; }
if (isset($widgets[4])) { $widgets[4]['title'] = ''; $widgets[4]['text'] = ''; }
update_option('widget_text', $widgets, false);
$sidebars_widgets = get_option('sidebars_widgets', []);
if (!empty($sidebars_widgets['ct-footer-sidebar-2'])) {
    $sidebars_widgets['ct-footer-sidebar-2'] = array_values(array_diff($sidebars_widgets['ct-footer-sidebar-2'], ['block-1']));
    update_option('sidebars_widgets', $sidebars_widgets, false);
}

$menus = [
    17 => [1101=>['Home', home_url('/')], 1103=>['What You Get', home_url('/#what-you-get')]],
    18 => [1100=>['How It Works', home_url('/#how-it-works')], 1104=>['FAQ', home_url('/#faq')], 1105=>['Free Preview', home_url('/#preview')]],
    19 => [1095=>['Home', home_url('/')], 1099=>['What You Get', home_url('/#what-you-get')], 1098=>['Sample Pages', home_url('/#sample-pages')], 1094=>['How It Works', home_url('/#how-it-works')], 1096=>['FAQ', home_url('/#faq')], 1097=>['Free Preview', home_url('/#preview')]],
];
foreach ($menus as $menu_id => $items) {
    foreach ($items as $item_id => [$title, $url]) {
        wp_update_nav_menu_item($menu_id, $item_id, ['menu-item-title' => $title, 'menu-item-url' => $url, 'menu-item-status' => 'publish', 'menu-item-type' => 'custom', 'menu-item-object' => 'custom']);
    }
}
wp_update_nav_menu_item(17, 1102, ['menu-item-status' => 'draft']);

$owner = get_user_by('login', 'bms-owner');
$plugin_versions = [];
foreach (['blocksy-companion','woocommerce','simply-gallery-block','stackable-ultimate-gutenberg-blocks','wpforms-lite'] as $slug) {
    $plugin = get_plugins('/' . $slug);
    $plugin_versions[$slug] = $plugin ? reset($plugin)['Version'] : null;
}
$report = [
    'page_id' => 858,
    'page_title' => get_the_title(858),
    'page_type' => get_post_type(858),
    'product_id' => $product_id,
    'product_url' => $product_url,
    'product_price' => $product->get_price(),
    'product_virtual' => $product->is_virtual(),
    'currency' => get_woocommerce_currency(),
    'guest_checkout' => get_option('woocommerce_enable_guest_checkout'),
    'checkout_account_creation' => get_option('woocommerce_enable_signup_and_login_from_checkout'),
    'owner_role' => $owner ? (wp_roles()->get_names()[$owner->roles[0] ?? ''] ?? null) : null,
    'productized_page_block_count' => count(parse_blocks(get_post_field('post_content', 858))),
    'preview_shortcode_present' => has_shortcode(get_post_field('post_content', 858), 'bms_preview'),
    'gutenberg_page' => true,
    'payPal_plugin_active' => is_plugin_active('woocommerce-paypal-payments/woocommerce-paypal-payments.php'),
    'model_calls' => 0,
];
echo wp_json_encode($report, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . "\n";
