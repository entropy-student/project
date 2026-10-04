<?php
require '/var/www/html/wp-load.php';
if (get_option('home') !== 'http://127.0.0.1:8189') { fwrite(STDERR, "RETURN_NOT_LOCAL_G3C\n"); exit(2); }
if (hash('sha256', get_post_field('post_content', 858)) !== 'b45daee18bb450e958614e756bcb000742ab6cb2cf727dc45aa25152eafcbbfb') {
 fwrite(STDERR, "RETURN_HOME_BASELINE_DRIFT\n"); exit(1);
}
$product = wc_get_product(1113);
if ($product->get_price() !== '39.99' || get_woocommerce_currency() !== 'USD' || !$product->is_virtual() || wp_get_theme()->get_stylesheet() !== 'blocksy') {
 fwrite(STDERR, "RETURN_PRODUCT_BASELINE_DRIFT\n"); exit(1);
}
function bms_block($type, $attrs, $html) {
 return '<!-- wp:' . $type . ($attrs ? ' ' . wp_json_encode($attrs, JSON_UNESCAPED_SLASHES) : '') . ' -->' . "\n" . $html . "\n" . '<!-- /wp:' . $type . ' -->' . "\n";
}
function bms_group($class, $html, $id = '') {
 return bms_block('group', array_filter(['className' => $class, 'anchor' => $id]), '<div' . ($id ? ' id="' . esc_attr($id) . '"' : '') . ' class="wp-block-group ' . esc_attr($class) . '">' . $html . '</div>');
}
function bms_p($text, $class = '') {
 return bms_block('paragraph', $class ? ['className' => $class] : [], '<p' . ($class ? ' class="' . esc_attr($class) . '"' : '') . '>' . $text . '</p>');
}
function bms_h($text, $level = 2, $class = '') {
 return bms_block('heading', array_filter(['level' => $level, 'className' => $class]), '<h' . $level . ' class="wp-block-heading' . ($class ? ' ' . esc_attr($class) : '') . '">' . $text . '</h' . $level . '>');
}
function bms_image($id, $alt, $class = '') {
 return bms_block('image', array_filter(['id' => $id, 'sizeSlug' => 'full', 'linkDestination' => 'none', 'className' => $class]), '<figure class="wp-block-image size-full' . ($class ? ' ' . esc_attr($class) : '') . '"><img src="' . esc_url(wp_get_attachment_url($id)) . '" alt="' . esc_attr($alt) . '" class="wp-image-' . $id . '"/></figure>');
}
function bms_button($text, $url) {
 $button = bms_block('button', [], '<div class="wp-block-button"><a class="wp-block-button__link wp-element-button" href="' . esc_url($url) . '">' . $text . '</a></div>');
 return bms_block('buttons', [], '<div class="wp-block-buttons">' . $button . '</div>');
}
function bms_inner($html) { return bms_group('bms-section-inner', $html); }
$purchase = get_permalink(1113);
$hero = bms_group('bms-hero', bms_p('FOR THEIR NEXT CHAPTER', 'bms-eyebrow')
 . bms_h('A birthday gift,<br>all about them.', 1)
 . bms_p('Turn the photos, stories and little things you love into their very own personalized birthday magazine.', 'bms-hero-copy')
 . bms_button('See their free preview &rarr;', '#preview')
 . bms_p('Made for one very special person. No design skills needed.', 'bms-fine')
 . bms_group('bms-hero-scene', bms_image(1137, 'Personalized Mira birthday magazine in a warm gift scene') . bms_p('12 pages.<br>One very special person.', 'bms-gift-note')));
$strip = bms_group('bms-value-strip', bms_p('A PERSONALIZED BIRTHDAY GIFT &nbsp; / &nbsp; 12-PAGE DIGITAL PDF &nbsp; / &nbsp; FREE PREVIEW, NO UPLOAD'));
$samples = bms_group('bms-samples', bms_inner(
 bms_p('A LITTLE LOOK INSIDE', 'bms-eyebrow') . bms_h('Not just a message.<br>A whole magazine.')
 . bms_p('A cover worth keeping. A story only you could tell. Picture their birthday, in print-inspired pages.', 'bms-section-copy')
 . bms_group('bms-gallery',
  bms_group('bms-gallery-spread', bms_image(1138, 'Birthday magazine editorial spread with friends and travel photographs') . bms_p('The moments that make a life. &mdash; Fictional sample spread'))
  . bms_group('bms-gallery-cover', bms_image(1139, 'Fictional Alex personalized birthday magazine cover') . bms_p('Their name on the cover. &mdash; Fictional sample')))), 'samples');
$preview = bms_group('bms-preview-chapter',
 bms_group('bms-chapter-heading', bms_p('THE FIRST LITTLE WOW', 'bms-eyebrow') . bms_h('Now, make it theirs.')
 . bms_p('Choose their photo. Add their name. See a cover and sample spread come to life &mdash; right here, for free.'))
 . bms_block('shortcode', [], '[bms_preview product_id="1113"]'), 'preview');
$features = '';
foreach ([
 ['Their own cover story', 'A personalized cover built around the person you are celebrating.'],
 ['A life in little moments', 'Photos, memories and the stories you bring to the private workspace.'],
 ['An editorial finish', 'A considered magazine layout, delivered as a 12-page digital PDF.'],
 ['A digital keepsake', 'US Letter format. Keep the file or print it yourself; printing and shipping are not included.'],
] as [$title, $copy]) { $features .= bms_group('bms-included-feature', bms_h($title, 3) . bms_p($copy)); }
$included = bms_group('bms-included', bms_inner(bms_group('bms-included-grid',
 bms_group('bms-included-visual', bms_p('THE COMPLETE ISSUE', 'bms-eyebrow') . bms_p('12', 'bms-big-number') . bms_h('Pages of<br>birthday goodness.') . bms_image(1138, 'Example of the magazine pages included in the digital gift'))
 . bms_group('bms-included-list', $features))), 'what-you-get');
$steps = '';
foreach ([
 ['01', 'Pick a photo you love.', 'Start with their face, their name and a birthday. A little inspiration goes a long way.'],
 ['02', 'Try the free preview.', 'See an illustrative cover and spread. Your photo stays in this browser.'],
 ['03', 'Make it a complete gift.', 'Purchase the 12-page digital magazine for US$39.99 through our secure WooCommerce checkout.'],
 ['04', 'Continue in your private workspace.', 'After purchase, add the photos and details for the complete magazine in your own workspace.'],
] as [$number, $title, $copy]) {
 $steps .= bms_group('bms-journey-step', bms_p($number, 'bms-step-number') . bms_group('bms-step-copy', bms_h($title, 3) . bms_p($copy)));
}
$how = bms_group('bms-how', bms_inner(bms_group('bms-how-grid',
 bms_group('bms-how-intro', bms_p('FROM A PHOTO TO A GIFT', 'bms-eyebrow') . bms_h('You bring<br>the person.<br>We bring<br>the pages.')
 . bms_p('No blank canvas. No design software. Just a thoughtful way to celebrate someone.'))
 . bms_group('bms-journey', $steps))), 'how-it-works');
$offer = bms_group('bms-offer', bms_inner(bms_p('A BIRTHDAY ONLY THEY COULD HAVE', 'bms-eyebrow')
 . bms_h('Give them<br>their own good issue.')
 . bms_p('Because the best gifts say: I see you. I know you. And there is so much to celebrate.', 'bms-offer-copy')
 . bms_p('US$39.99', 'bms-price') . bms_p('The complete 12-page digital PDF', 'bms-fine')
 . bms_button('Make their birthday magazine &rarr;', $purchase)
 . bms_p('Digital product only. Printing and shipping are not included.<br>Continue with your details in a private workspace after purchase.', 'bms-fine')
 . bms_image(1139, 'Alex birthday magazine sample', 'bms-offer-cover')), 'offer');
$questions = '';
foreach ([
 ['Is this a printed magazine?', 'Your purchase is a 12-page digital PDF in US Letter format. We do not print or ship a physical magazine. You can choose to print the PDF yourself.'],
 ['What do I get in the free preview?', 'An illustrative cover and sample spread using your browser-local photo and details. It is not the complete magazine or a final PDF.'],
 ['What happens after purchase?', 'Native WooCommerce checkout records your purchase. Continue adding your information in the private workspace linked to your account.'],
 ['Where does my preview photo go?', 'Nowhere. The free preview uses a temporary browser-local object URL. It does not upload your photo or send it to an AI model.'],
 ['Can I make it for someone else?', 'Yes. This is a gift for a specific person: a partner, a friend, a parent, or someone you want to celebrate.'],
 ['What should I have ready?', 'A photo, their name and a birthday to start. For the complete magazine, bring the photos and personal details you want to include.'],
] as [$title, $copy]) { $questions .= bms_group('bms-question', bms_h($title, 3) . bms_p($copy)); }
$faq = bms_group('bms-faq', bms_inner(bms_group('bms-faq-title', bms_h('A few good questions.') . bms_p('The details, before the big day.', 'bms-fine')) . bms_group('bms-faq-grid', $questions)), 'faq');
$content = $hero . $strip . $samples . $preview . $included . $how . $offer . $faq;
$id = wp_update_post(wp_slash(['ID' => 858, 'post_content' => $content]), true);
if (is_wp_error($id)) { fwrite(STDERR, $id->get_error_code()); exit(1); }
$footer = bms_group('bms-footer-content',
 bms_group('bms-footer-brand', bms_p('BIRTHDAY MAGAZINE STUDIO', 'bms-eyebrow') . bms_h('A life worth<br>celebrating.') . bms_p('A personal magazine. A thoughtful birthday gift.<br>A little reminder of how loved they are.'))
 . bms_group('bms-footer-links', bms_p('<a href="' . esc_url(home_url('/#preview')) . '">Free preview</a> &nbsp; / &nbsp; <a href="' . esc_url($purchase) . '">The magazine</a>')
 . bms_p('<a href="' . esc_url(home_url('/my-account/')) . '">My account</a> &nbsp; / &nbsp; <a href="' . esc_url(get_privacy_policy_url()) . '">Privacy policy</a>')
 . bms_p('12-page digital PDF. No printing or shipping.<br>US$39.99. Your free preview photo stays in your browser.')));
$footer_id = wp_insert_post(wp_slash(['post_type' => 'wp_block', 'post_status' => 'publish', 'post_title' => 'Birthday Magazine — Editable Brand Footer', 'post_content' => $footer]), true);
if (is_wp_error($footer_id)) { fwrite(STDERR, $footer_id->get_error_code()); exit(1); }
update_option('bms_g3cr6r1_footer_id', $footer_id);
$placements = get_theme_mod('footer_placements');
foreach ($placements['sections'] as &$section) {
 foreach ($section['rows'] as &$row) {
  if ($row['id'] === 'middle-row' || $row['id'] === 'top-row') {
   $row['columns'] = array_map(fn($column) => [], $row['columns']);
  } elseif ($row['id'] === 'bottom-row') { $row['columns'] = [['copyright']]; }
 }
 unset($row);
}
unset($section);
set_theme_mod('footer_placements', $placements);
$palette = [];
foreach (['#c74e39','#a83d2c','#746760','#342a27','#dfcfc2','#f5ebdf','#fff9f2','#efd8ce'] as $index => $color) {
 $palette['color' . ($index + 1)] = ['color' => $color];
}
set_theme_mod('colorPalette', $palette);
set_theme_mod('dynamic_css_file', 'inline');
// Public editorial copy only. Product identity, price and purchase logic are untouched.
wp_update_post(wp_slash(['ID' => 1113,
 'post_excerpt' => '<p>A personalized birthday magazine for one very special person. Turn your photos and stories into a thoughtful 12-page digital gift.</p><p>US Letter PDF · Private workspace after purchase · No printing or shipping.</p>',
 'post_content' => '<h2>Their birthday. Their own issue.</h2><p>A personalized 12-page digital magazine, made around the person you are celebrating. Begin with the browser-local free preview, then purchase and continue adding your photos and details in your private workspace.</p><p>Digital PDF in US Letter format. Printing and shipping are not included. The free cover and sample spread are illustrative and are not the finished magazine.</p>']));
echo wp_json_encode(['HOME_UPDATED' => 858, 'TOP_LEVEL_GROUPS' => 8, 'EDITABLE_FOOTER_ID' => $footer_id, 'PRODUCT_PRESENTATION_UPDATED' => 1113, 'ORDER_COUNT' => count(wc_get_orders(['return'=>'ids','limit'=>-1]))]) . "\n";
