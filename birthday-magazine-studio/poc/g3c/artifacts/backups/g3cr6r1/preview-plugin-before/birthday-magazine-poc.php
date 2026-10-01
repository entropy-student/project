<?php
/**
 * Plugin Name: Birthday Magazine G3C Preview
 * Description: Embedded Good Issue-style browser-local cover and sample-spread preview for G3C.
 * Version: 0.2.0
 * License: GPL-2.0-or-later
 */

if (!defined('ABSPATH')) {
	exit;
}

add_action('wp_enqueue_scripts', function () {
	wp_enqueue_style('bms-g3cr4-footer', plugins_url('g3cr4-footer.css', __FILE__), [], '0.1.0');
});

add_action('wp_enqueue_scripts', function () {
	if (!is_singular()) {
		return;
	}

	$post = get_post();
	if (!$post || !has_shortcode($post->post_content, 'bms_preview')) {
		return;
	}

	wp_enqueue_style('bms-g3c-preview', plugins_url('preview.css', __FILE__), [], '0.2.0');
	wp_enqueue_style('bms-g3c-routes', plugins_url('routes.css', __FILE__), ['bms-g3c-preview'], '0.2.0');
	wp_enqueue_style('bms-g3c-mobile', plugins_url('mobile.css', __FILE__), ['bms-g3c-routes'], '0.2.0');
	if (is_front_page()) {
		wp_enqueue_style('bms-g3cr4-home', plugins_url('g3cr4-home.css', __FILE__), ['bms-g3c-mobile'], '0.1.0');
	}
	wp_enqueue_style('bms-g3cr5-preview', plugins_url('g3cr5-preview.css', __FILE__), ['bms-g3c-mobile'], '0.1.0');
	wp_enqueue_script('bms-g3c-preview', plugins_url('preview.js', __FILE__), [], '0.2.0', true);
});

add_action('wp_enqueue_scripts', function () {
	if (!function_exists('is_woocommerce')) {
		return;
	}

	if (is_woocommerce() || is_cart() || is_checkout() || is_account_page()) {
		wp_enqueue_style('bms-g3cr5-commerce', plugins_url('g3cr5-commerce.css', __FILE__), [], '0.1.0');
	}
}, 99);

add_action('wp_enqueue_scripts', function () {
 wp_enqueue_style('bms-g3cr6-brand', plugins_url('g3cr6-brand.css', __FILE__), [], '0.1.0');
}, 120);

// Preserve native Woo gallery behavior while showing the complete marketing image.
add_filter('woocommerce_gallery_image_size', function ($size) {
 return get_the_ID() === 1113 ? 'full' : $size;
});

add_shortcode('bms_preview', function ($atts) {
 $atts = shortcode_atts(['product_id'=>1113], $atts, 'bms_preview');
 ob_start(); ?>
 <section class="bms-page" data-bms-preview>
 <div class="bms-workbench">
 <div class="bms-form-panel">
 <div class="bms-panel-top"><h3>Make it theirs.</h3><span>FREE PREVIEW</span></div>
 <p class="bms-form-intro">One photo. A few details. Their own cover story.</p>
 <div class="bms-field"><label for="bms-name">Their name</label><input id="bms-name" data-bms-input="name" maxlength="32" value="Taylor" autocomplete="off"></div>
 <div class="bms-field-row"><div class="bms-field"><label for="bms-age">Age</label><input id="bms-age" data-bms-input="age" type="number" min="1" max="120" value="30" inputmode="numeric"></div><div class="bms-field"><label for="bms-style">Magazine style</label><select id="bms-style" data-bms-input="style"><option value="editorial">Bold Editorial</option><option value="romantic">Soft / Warm</option><option value="retro">Retro / Playful</option></select></div></div>
 <div class="bms-field"><label for="bms-photo">Cover photo <span>OPTIONAL</span></label><label class="bms-upload" for="bms-photo"><span class="bms-upload-symbol" aria-hidden="true">↑</span><strong data-bms-upload-label>Choose a photo</strong><small>JPG, PNG or WebP · from this device</small><input id="bms-photo" data-bms-file type="file" accept="image/jpeg,image/png,image/webp"></label><div class="bms-photo-actions"><p class="bms-photo-status" data-bms-status role="status" aria-live="polite">Your preview works without a photo.</p><button type="button" data-bms-remove hidden>Remove photo</button></div></div>
 <p class="bms-privacy">Your photo stays in this browser. Nothing is uploaded.</p>
 </div>
 <div class="bms-preview-panel"><div class="bms-preview-heading"><strong>Their very own issue.</strong><span>LIVE PREVIEW</span></div>
 <div class="bms-spread-stage">
 <div class="bms-mini-cover" data-bms-cover><div class="bms-cover-masthead">GOOD ISSUE <small>THE BIRTHDAY EDITION</small></div><div class="bms-cover-photo-frame"><img class="bms-cover-photo" data-bms-image alt="Your browser-local cover photo" hidden><div class="bms-cover-art" data-bms-art aria-hidden="true"></div></div><div class="bms-cover-headlines"><span>THE ONE AND ONLY</span><strong data-bms-name>TAYLOR</strong><small data-bms-age>AGE 30 · A VERY GOOD YEAR</small></div></div>
 <div class="bms-spread"><article class="bms-page-sheet"><span class="bms-page-kicker">A VERY GOOD YEAR</span><h3>The story<br>so far.</h3><p data-bms-story></p><small>04</small></article><article class="bms-page-sheet bms-photo-sheet"><div class="bms-spread-photo-frame"><div class="bms-spread-art" data-bms-spread-art></div><img class="bms-spread-photo" data-bms-image alt="Your browser-local sample spread photo" hidden></div><div class="bms-photo-copy"><span class="bms-page-kicker">THE NEXT CHAPTER</span><h3>More life.<br>More stories.</h3><p>Keep making it your own.</p><small>05</small></div></article></div>
 </div><p class="bms-preview-foot">Cover + sample spread · Illustrative preview, not the finished magazine</p>
 <a class="bms-preview-purchase" href="<?php echo esc_url(get_permalink(absint($atts['product_id']))); ?>">Make the complete 12-page issue <span>US$39.99 →</span></a>
 </div></div></section>
 <?php return ob_get_clean();
});
