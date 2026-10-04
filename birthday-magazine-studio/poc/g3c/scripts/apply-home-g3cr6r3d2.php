<?php
// D2 only: Home858 presentation and one positively identified menu URL.
define('DISABLE_WP_CRON', true);
require '/var/www/html/wp-load.php';
if (get_option('page_on_front') != 858 || wp_get_theme()->get_stylesheet() !== 'blocksy') {
    throw new RuntimeException('D2 target drift');
}
$home = get_post(858);
if (hash('sha256', $home->post_content) !== '3f678c490ff78f91d0918aacf4edd236d58500dced0a3ac229f0c865e86e1269') {
    throw new RuntimeException('D2 pre-change Home drift; do not replay');
}
if (get_post_meta(1098, '_menu_item_url', true) !== home_url('/#sample-pages')) {
    throw new RuntimeException('D2 exact menu1098 drift');
}
function d2_block($name, $attrs, $html) {
    return '<!-- wp:' . $name . ($attrs ? ' ' . wp_json_encode($attrs, JSON_UNESCAPED_SLASHES) : '') . " -->\n" . $html . "\n<!-- /wp:$name -->\n";
}
function d2_group($class, $content, $anchor = null) {
    $attrs = ['className' => $class];
    if ($anchor) $attrs['anchor'] = $anchor;
    return d2_block('group', $attrs, '<div' . ($anchor ? ' id="' . $anchor . '"' : '') . ' class="wp-block-group ' . $class . '">' . $content . '</div>');
}
function d2_p($text, $class = 'bms-copy') {
    return d2_block('paragraph', ['className' => $class], '<p class="' . $class . '">' . $text . '</p>');
}
function d2_h($text, $level = 2, $class = 'bms-heading') {
    return d2_block('heading', ['level' => $level, 'className' => $class], '<h' . $level . ' class="wp-block-heading ' . $class . '">' . $text . '</h' . $level . '>');
}
function d2_image($id, $alt, $class = '') {
    return d2_block('image', ['id' => $id, 'sizeSlug' => 'full', 'linkDestination' => 'none', 'className' => $class], '<figure class="wp-block-image size-full ' . $class . '"><img src="' . esc_url(wp_get_attachment_url($id)) . '" alt="' . esc_attr($alt) . '" class="wp-image-' . $id . '" /></figure>');
}
function d2_button($label, $url) {
    return d2_block('buttons', [], '<div class="wp-block-buttons">' . d2_block('button', ['className' => 'bms-focus-link'], '<div class="wp-block-button bms-focus-link"><a class="wp-block-button__link wp-element-button" href="' . esc_url($url) . '">' . $label . '</a></div>') . '</div>');
}
$product = get_permalink(1113);
$hero = d2_group('bms-hero',
    d2_image(1137, 'Fictional Mira birthday magazine and open spread, styled as a gift', 'bms-focus-background') .
    d2_group('bms-focus-frame', d2_image(1137, 'A personalized magazine, made about one person', 'bms-focus-sharp') . d2_p('Their story. In focus.', 'bms-focus-tag')) .
    d2_group('bms-hero-message', d2_h('A birthday magazine.<br><em>Made about them.</em>', 1) . d2_p('Their photos. Their stories. A gift only you could give.') . d2_button('Create a free preview', '#preview') . d2_p('Browser-local preview · No design skills needed', 'bms-focus-note')) .
    d2_p('Fictional sample magazine · 12-page digital PDF', 'bms-hero-caption'));
$included = d2_group('bms-included bms-focus-split',
    d2_image(1138, 'An illustrative story spread with fictional photos', 'bms-focus-visual') .
    d2_group('bms-focus-copy', d2_h('Your person.<br><em>Our pages.</em>') .
        d2_p('Turn the photos and stories you know by heart into a personalized 12-page birthday magazine. A cover, a life in photographs, and the little things that make them who they are.') .
        d2_p('A digital keepsake in US Letter PDF format. Story-driven layouts, your photographs, and one bounded revision batch. No printing or shipping.') .
        d2_button('Look inside', '#samples')), 'what-you-get');
$preview = d2_group('bms-preview-chapter',
    d2_group('bms-focus-photo-panel', d2_image(1137, 'Fictional magazine gift scene', 'bms-panel-background') .
        d2_group('bms-dark-panel', d2_h('The first little<br><em>wow.</em>') .
            d2_p('Choose one photo. Add their name. See a cover and sample spread come to life — right here, for free.') . d2_p('Your photo stays in this browser. Nothing is uploaded.', 'bms-panel-note'))) .
    d2_group('bms-preview-surface', d2_block('shortcode', [], '[bms_preview product_id="1113"]')), 'preview');
$how = d2_group('bms-how bms-focus-split',
    d2_image(1139, 'Fictional Alex magazine cover', 'bms-focus-visual bms-contained-cover') .
    d2_group('bms-focus-copy', d2_h('You bring<br><em>the person.</em>') . d2_p('We bring the pages. No blank canvas, no design software. A thoughtful way to tell their story.') .
        d2_group('bms-focus-steps',
            d2_p('<strong>Choose photos + answer prompts</strong><br>Start with the people, moments and little details you know best.') .
            d2_p('<strong>Create a free preview</strong><br>Try an illustrative cover and sample spread before purchase.') .
            d2_p('<strong>Purchase through WooCommerce</strong><br>The complete 12-page digital magazine is US$39.99.') .
            d2_p('<strong>Continue in your private workspace</strong><br>Sign in after purchase to continue with your order.'))), 'how-it-works');
$offer = d2_group('bms-offer bms-focus-photo-panel bms-panel-right',
    d2_image(1137, 'A birthday magazine gift, fictional sample shown', 'bms-panel-background') .
    d2_group('bms-dark-panel', d2_h('Give them<br><em>their own issue.</em>') .
        d2_p('One person. One very good story. A personalized 12-page digital birthday magazine.') . d2_p('US$39.99', 'bms-focus-price') .
        d2_button('Make their birthday magazine', $product) . d2_p('Digital PDF only. Continue in a private account workspace after purchase.', 'bms-panel-note')), 'offer');
$faq = d2_group('bms-faq', d2_h('A few good<br><em>questions.</em>') . d2_group('bms-focus-faq-grid',
    d2_group('bms-focus-question', d2_h('What will I receive?', 3) . d2_p('A personalized 12-page US Letter digital PDF. The free preview is illustrative, not the finished magazine.')) .
    d2_group('bms-focus-question', d2_h('Do I need design experience?', 3) . d2_p('No. Choose photos and answer the story prompts. You do not need to design the pages yourself.')) .
    d2_group('bms-focus-question', d2_h('Does the free preview upload my photo?', 3) . d2_p('No. The selected preview photo stays browser-local. It is not sent to WordPress or an external image service.')) .
    d2_group('bms-focus-question', d2_h('Why do I need an account?', 3) . d2_p('Your authenticated account gives you access to your private order workspace.')) .
    d2_group('bms-focus-question', d2_h('Can I request changes?', 3) . d2_p('The product includes one bounded revision batch.')) .
    d2_group('bms-focus-question', d2_h('How long are files kept?', 3) . d2_p('Source and intermediate assets are deleted within 24 hours after final delivery or approval. The final PDF is retained for 72 hours.'))), 'faq');
$samples = d2_group('bms-samples', d2_h('Magazine<br><em>moments.</em>') . d2_p('A little look inside. Fictional samples, shown for illustration.') .
    d2_group('bms-focus-card', d2_image(1139, 'Fictional sample cover: Alex', 'bms-card-cover') . d2_p('The cover', 'bms-card-label')) .
    d2_group('bms-focus-card', d2_image(1138, 'Fictional editorial photo and story spread') . d2_p('The story', 'bms-card-label')) .
    d2_group('bms-focus-card', d2_image(1137, 'Fictional birthday magazine as a thoughtful gift') . d2_p('The gift', 'bms-card-label')), 'samples');
$closing = d2_group('bms-value-strip bms-closing',
    d2_image(1139, 'Fictional magazine cover', 'bms-closing-photo bms-closing-photo-left') .
    d2_group('bms-closing-copy', d2_h('Make their next<br><em>chapter a good one.</em>') . d2_button('Create a free preview', '#preview') . d2_p('A personalized magazine. A birthday worth remembering.')) .
    d2_image(1138, 'Fictional story spread', 'bms-closing-photo bms-closing-photo-right'));
$content = $hero . $included . $preview . $how . $offer . $faq . $samples . $closing;
foreach (['samples', 'preview', 'what-you-get', 'how-it-works', 'offer', 'faq'] as $anchor) {
    if (substr_count($content, 'id="' . $anchor . '"') !== 1) throw new RuntimeException('D2 anchor mismatch');
}
$result = wp_update_post(['ID' => 858, 'post_content' => $content], true);
if (is_wp_error($result)) throw new RuntimeException($result->get_error_message());
update_post_meta(1098, '_menu_item_url', home_url('/#samples'));
echo wp_json_encode(['home_id' => 858, 'home_sha256' => hash('sha256', get_post_field('post_content', 858)), 'menu_item' => 1098, 'old_url' => home_url('/#sample-pages'), 'new_url' => get_post_meta(1098, '_menu_item_url', true), 'privacy_link_changed' => false, 'groups' => count(array_filter(parse_blocks($content), fn($b) => $b['blockName'] === 'core/group'))], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
