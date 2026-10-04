<?php
/**
 * Plugin Name: Birthday Magazine G3C Preview
 * Description: Gift-led presentation and browser-local magazine preview.
 * Version: 0.3.0
 * License: GPL-2.0-or-later
 */
if (!defined('ABSPATH')) { exit; }

add_action('wp_enqueue_scripts', function () {
 wp_enqueue_style('bms-studio', plugins_url('studio.css', __FILE__), [], '0.3.0');
 if (is_front_page()) {
  wp_enqueue_style('bms-home', plugins_url('home.css', __FILE__), ['bms-studio'], '0.3.0');
  wp_enqueue_script('bms-home-motion', plugins_url('home-motion.js', __FILE__), [], '0.3.0', true);
 }
 $post = get_post();
 if (is_singular() && $post && has_shortcode($post->post_content, 'bms_preview')) {
  wp_enqueue_style('bms-magazine-preview', plugins_url('magazine-preview.css', __FILE__), ['bms-studio'], '0.3.0');
  wp_enqueue_script('bms-preview', plugins_url('preview.js', __FILE__), [], '0.3.0', true);
 }
}, 120);

// Supported Blocksy presentation hooks; no theme or license changes.
add_filter('blocksy:footer:copyright:value', function () {
 return '&copy; {current_year} Birthday Magazine Studio. A digital gift, made personal.';
});
add_action('blocksy:footer:before', function () {
 $footer = get_post(absint(get_option('bms_g3cr6r1_footer_id')));
 if ($footer && $footer->post_type === 'wp_block') {
  echo '<div class="bms-brand-footer">' . do_blocks($footer->post_content) . '</div>';
 }
});
add_filter('woocommerce_gallery_image_size', function ($size) {
 return get_the_ID() === 1113 ? 'full' : $size;
});
function bms_gift_route_intro($eyebrow, $title, $copy) {
 echo '<div class="bms-commerce-intro"><p class="bms-eyebrow">' . esc_html($eyebrow) . '</p><h2>' . esc_html($title) . '</h2><p>' . esc_html($copy) . '</p></div>';
}
add_action('woocommerce_before_cart', function () {
 bms_gift_route_intro('THE GIFT YOU CHOSE', 'A little closer to their big day.', 'Your personalized birthday magazine starts here.');
});
add_action('woocommerce_before_checkout_form', function () {
 bms_gift_route_intro('ONE THOUGHTFUL GIFT', 'Make this birthday theirs.', 'Complete your purchase, then continue in your private workspace.');
}, 5);
add_action('woocommerce_before_customer_login_form', function () {
 bms_gift_route_intro('YOUR PRIVATE SPACE', 'Their story, in good hands.', 'Sign in to continue with your birthday magazine.');
});
add_action('woocommerce_single_product_summary', function () {
 if (get_the_ID() === 1113) { echo '<p class="bms-eyebrow">A GIFT ONLY YOU COULD GIVE</p>'; }
}, 4);
add_action('woocommerce_after_add_to_cart_form', function () {
 if (get_the_ID() !== 1113) { return; }
 echo '<p class="bms-product-note">12-page digital PDF · Not a printed or shipped product</p><a class="bms-text-link" href="' . esc_url(home_url('/#preview')) . '">Try their free preview first &rarr;</a>';
});
add_action('woocommerce_after_single_product_summary', function () {
 if (get_the_ID() !== 1113) { return; }
 echo '<section class="bms-product-story"><div><p class="bms-eyebrow">MORE THAN A BIRTHDAY MESSAGE</p><h2>A whole issue.<br>One extraordinary person.</h2><p>A cover, a life in photographs, and the people and little moments that make them who they are. Bring the story into your private workspace after purchase.</p><p class="bms-fine">Fictional sample shown. Your purchase is a 12-page digital PDF.</p></div>';
 echo wp_get_attachment_image(1138, 'full');
 echo '</section>';
}, 5);

add_shortcode('bms_preview', function ($atts) {
 $atts = shortcode_atts(['product_id' => 1113], $atts, 'bms_preview');
 ob_start(); ?>
 <div class="bms-preview" data-bms-preview data-has-photo="false">
  <div class="bms-preview-controls">
   <div class="bms-preview-details">
    <div class="bms-field"><label for="bms-name">Their name</label><input id="bms-name" data-bms-input="name" maxlength="32" value="Taylor" autocomplete="off"></div>
    <div class="bms-field"><label for="bms-age">Age</label><input id="bms-age" data-bms-input="age" type="number" min="1" max="120" value="30" inputmode="numeric"></div>
    <div class="bms-field"><label for="bms-style">The mood</label><select id="bms-style" data-bms-input="style"><option value="romantic">Soft &amp; warm</option><option value="editorial">Bold editorial</option><option value="retro">Retro &amp; playful</option></select></div>
   </div>
   <div class="bms-preview-upload">
    <label class="bms-upload" for="bms-photo"><span aria-hidden="true">+</span><div><strong data-bms-upload-label>Choose their photo</strong><small>JPG, PNG or WebP · from your device</small></div><input id="bms-photo" data-bms-file type="file" accept="image/jpeg,image/png,image/webp"></label>
    <div class="bms-photo-actions"><p data-bms-status role="status" aria-live="polite">Your preview works without a photo.</p><button type="button" data-bms-remove hidden>Remove photo</button></div>
   </div>
  </div>
  <div class="bms-preview-stage">
   <div class="bms-preview-cover" data-bms-cover>
    <div class="bms-cover-masthead">GOOD ISSUE<small>THE BIRTHDAY EDITION</small></div>
    <div class="bms-cover-photo-frame"><img data-bms-image alt="Your browser-local cover photo" hidden><div class="bms-cover-art" data-bms-art><span>Just add<br>their photo.</span></div></div>
    <div class="bms-cover-headlines"><span>THE ONE AND ONLY</span><strong data-bms-name>Taylor</strong><small data-bms-age>AGE 30 · A VERY GOOD YEAR</small></div>
   </div>
   <div class="bms-preview-spread">
    <article class="bms-preview-sheet"><span class="bms-page-kicker">A VERY GOOD YEAR</span><h3>The story<br>so far.</h3><p data-bms-story></p><blockquote>Here's to being<br>beautifully you.</blockquote><small class="bms-page-number">04</small></article>
    <article class="bms-preview-sheet bms-photo-sheet"><div class="bms-spread-photo-frame"><img data-bms-image alt="Your browser-local sample spread photo" hidden><div class="bms-spread-art" data-bms-spread-art></div></div><div class="bms-photo-copy"><span class="bms-page-kicker">THE NEXT CHAPTER</span><h3>More life.<br>More stories.</h3><small>05</small></div></article>
   </div>
   <p class="bms-preview-annotation">Their name.<br>Their face.<br>Their very own issue.</p>
  </div>
  <div class="bms-preview-bottom"><p>Your photo stays in this browser. Nothing is uploaded.<br><span>Illustrative cover + sample spread, not the finished magazine.</span></p><a class="bms-coral-link" href="<?php echo esc_url(get_permalink(absint($atts['product_id']))); ?>">Make the complete 12-page issue <span>US$39.99 &rarr;</span></a></div>
 </div>
 <?php return ob_get_clean();
});
