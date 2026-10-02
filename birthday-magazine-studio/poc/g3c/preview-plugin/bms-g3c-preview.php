<?php
/**
 * Plugin Name: Birthday Magazine G3C Good Issue Preview
 * Description: Local-only G2A1 cover and sample-spread preview adapted for the G3C WordPress product page.
 * Version: 0.2.0
 * License: GPL-2.0-or-later
 */

if (!defined('ABSPATH')) {
	exit;
}

add_action('wp_enqueue_scripts', static function () {
	if (!is_singular()) {
		return;
	}

	$post = get_post();
	if (!$post || !has_shortcode($post->post_content, 'bms_preview')) {
		return;
	}

	wp_enqueue_style('bms-g3c-theme-overrides', content_url('bms-g3c-theme-overrides/g3c.css'), [], '0.1.0');
	wp_enqueue_style('bms-g3c-preview', plugins_url('preview.css', __FILE__), [], '0.2.0');
	wp_enqueue_script('bms-g3c-preview', plugins_url('preview.js', __FILE__), [], '0.2.0', true);
}, 99);

add_shortcode('bms_preview', static function ($atts) {
	$atts = shortcode_atts(['product_id' => 0], $atts, 'bms_preview');
	$product_id = absint($atts['product_id']);
	$buy_url = $product_id ? get_permalink($product_id) : wc_get_page_permalink('shop');

	ob_start();
	?>
	<section id="bms-preview" class="bms-page bms-preview-root" data-bms-preview aria-labelledby="bms-builder-title">
		<div class="bms-builder">
			<div class="bms-section-heading">
				<div><p class="bms-eyebrow">YOUR PRIVATE FREE PREVIEW</p><h2 id="bms-builder-title">Start with the cover.</h2></div>
				<p>Try a name, age and one optional photo. The cover and sample spread update in this browser.</p>
			</div>
			<div class="bms-workbench">
				<div class="bms-form-panel">
					<div class="bms-panel-top"><h3>Make it theirs</h3><span>FREE · NO ACCOUNT</span></div>
					<div class="bms-field"><label for="bms-name">Their name</label><input id="bms-name" data-bms-input="name" type="text" maxlength="32" value="Avery" autocomplete="off"></div>
					<div class="bms-field-row">
						<div class="bms-field"><label for="bms-age">Age</label><input id="bms-age" data-bms-input="age" type="number" min="1" max="120" value="32" inputmode="numeric"></div>
						<div class="bms-field"><label for="bms-style">Cover style</label><select id="bms-style" data-bms-input="style"><option value="editorial">Bold editorial</option><option value="romantic">Soft / warm</option><option value="retro">Retro / playful</option></select></div>
					</div>
					<div class="bms-field"><label for="bms-photo">One cover photo <span>OPTIONAL</span></label><label class="bms-upload" for="bms-photo"><strong>＋ Choose a photo on this device</strong><small>JPG, PNG or WebP · stays in this browser preview</small><input id="bms-photo" data-bms-file type="file" accept="image/jpeg,image/png,image/webp"></label><p class="bms-photo-status" data-bms-status>No photo selected. Your preview works without one.</p></div>
					<p class="bms-privacy"><b aria-hidden="true">◎</b><span>This optional photo is previewed through a browser-local URL. It is not uploaded to WordPress or a third party.</span></p>
				</div>
				<div class="bms-preview-panel">
					<div class="bms-preview-heading"><strong>Your first look</strong><span><i></i> LIVE PREVIEW</span></div>
					<div class="bms-spread-stage">
						<div class="bms-mini-cover" data-bms-cover>
							<img class="bms-cover-photo" data-bms-image alt="Selected local sample photo on the magazine cover" hidden>
							<div class="bms-cover-art" data-bms-art aria-hidden="true"><i></i><b></b><span></span></div><div class="bms-cover-shade"></div>
							<div class="bms-cover-masthead">GOOD ISSUE <small>THE BIRTHDAY EDITION</small></div>
							<div class="bms-cover-headlines"><span>THE ONE AND ONLY</span><strong data-bms-name>AVERY</strong><small data-bms-age>AGE 32 · IN THEIR PRIME</small></div>
						</div>
						<div class="bms-spread">
							<article class="bms-page-sheet"><span class="bms-page-kicker">A VERY GOOD YEAR</span><h3>The story so far.</h3><p data-bms-story>Thirty-two looks good on you, Avery. Here’s to everything you’ve made, the people who make you laugh, and the best chapters still ahead.</p><small>04</small></article>
							<article class="bms-page-sheet bms-photo-sheet"><div class="bms-spread-art" data-bms-spread-art></div><img class="bms-spread-photo" data-bms-image alt="Selected local sample photo on a sample spread" hidden><span class="bms-page-kicker">A NOTE FOR THE NEXT CHAPTER</span><h3>More life.<br>More stories.</h3><p>Keep making it your own.</p><small>05</small></article>
						</div>
					</div>
					<div class="bms-preview-foot"><span><b>01 COVER</b> + 01 SAMPLE SPREAD</span><span>INSTANT · NO AI</span></div>
				</div>
			</div>
			<div class="bms-unlock"><div><p class="bms-eyebrow">WHEN YOU’RE READY</p><h2>Make the full issue theirs.</h2><p>A 12-page digital birthday magazine, shaped around their stories and photos.</p></div><a class="bms-buy" href="<?php echo esc_url($buy_url); ?>">VIEW THE FULL MAGAZINE <strong>US$39.99 <span aria-hidden="true">↗</span></strong></a></div>
		</div>
	</section>
	<?php
	return ob_get_clean();
});
