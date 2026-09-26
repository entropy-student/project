<?php
/**
 * Plugin Name: Birthday Magazine G2A1 Preview
 * Description: Local-only cover and sample-spread proof of concept for G2A1.
 * Version: 0.1.0
 * License: GPL-2.0-or-later
 */

if (!defined('ABSPATH')) {
	exit;
}

add_action('wp_enqueue_scripts', function () {
	if (!is_singular()) {
		return;
	}

	$post = get_post();
	if (!$post || !has_shortcode($post->post_content, 'bms_preview')) {
		return;
	}

	wp_enqueue_style('bms-g2a1-preview', plugins_url('preview.css', __FILE__), [], '0.1.1');
	wp_enqueue_style('bms-g2a1-routes', plugins_url('routes.css', __FILE__), ['bms-g2a1-preview'], '0.1.2');
	wp_enqueue_script('bms-g2a1-preview', plugins_url('preview.js', __FILE__), [], '0.1.0', true);
});

add_shortcode('bms_preview', function ($atts) {
	$atts = shortcode_atts(['product_id' => 0], $atts, 'bms_preview');
	$product_id = absint($atts['product_id']);
	$buy_url = $product_id ? get_permalink($product_id) : wc_get_page_permalink('shop');

	ob_start();
	?>
	<main class="bms-page" data-bms-preview>
		<div class="bms-ribbon">A gift with a point of view · Free browser preview</div>
		<header class="bms-header">
			<a class="bms-brand" href="#preview"><span class="bms-stamp">G</span> GOOD ISSUE</a>
			<a class="bms-header-link" href="#preview">MAKE A COVER <span>↘</span></a>
		</header>

		<section class="bms-intro" id="preview">
			<div>
				<p class="bms-eyebrow">THE PERSONAL EDITION · 2026</p>
				<h1>Make their life<br>the <em>cover story.</em></h1>
				<p class="bms-lede">A birthday magazine with their name on the cover and the good stuff inside. Start with a free, private preview.</p>
				<div class="bms-points"><span>Instant preview</span><span>Photo stays on this device</span><span>No AI calls</span></div>
			</div>
			<div class="bms-issue" aria-label="Sample birthday magazine cover">
				<div class="bms-issue-cover" data-bms-cover>
					<img class="bms-cover-photo" data-bms-image alt="Your local cover photo preview" hidden>
					<div class="bms-cover-art" data-bms-art aria-hidden="true"><i></i><b></b><span></span></div>
					<div class="bms-cover-shade"></div>
					<div class="bms-cover-masthead">GOOD ISSUE <small>THE BIRTHDAY EDITION</small></div>
					<div class="bms-cover-headlines"><span>THE ONE AND ONLY</span><strong data-bms-name>TAYLOR</strong><small data-bms-age>AGE 30 · IN THEIR PRIME</small></div>
				</div>
				<div class="bms-issue-caption"><b>NO. 01 / A VERY GOOD YEAR</b><span>MADE FOR SOMEONE SPECIAL</span></div>
			</div>
		</section>

		<div class="bms-ticker" aria-hidden="true">A LITTLE MORE PERSONAL <span>✳</span> A LOT MORE THEM <span>✳</span> MADE TO KEEP <span>✳</span></div>

		<section class="bms-builder" aria-labelledby="bms-builder-title">
			<div class="bms-section-heading">
				<div><p class="bms-eyebrow">YOUR FREE PREVIEW</p><h2 id="bms-builder-title">Start with the cover.</h2></div>
				<p>Change a few details and see the magazine come together right away.</p>
			</div>
			<div class="bms-workbench">
				<div class="bms-form-panel">
					<div class="bms-panel-top"><h3>Make it theirs</h3><span>01 / 03</span></div>
					<div class="bms-field"><label for="bms-name">Their name</label><input id="bms-name" data-bms-input="name" type="text" maxlength="32" value="Taylor" autocomplete="off"></div>
					<div class="bms-field-row">
						<div class="bms-field"><label for="bms-age">Age</label><input id="bms-age" data-bms-input="age" type="number" min="1" max="120" value="30" inputmode="numeric"></div>
						<div class="bms-field"><label for="bms-style">Cover style</label><select id="bms-style" data-bms-input="style"><option value="editorial">Bold editorial</option><option value="romantic">Soft romantic</option><option value="retro">Retro travel</option></select></div>
					</div>
					<div class="bms-field"><label for="bms-photo">One cover photo <span>OPTIONAL</span></label><label class="bms-upload" for="bms-photo"><strong>＋ Add a photo from this device</strong><small>JPG, PNG or WebP · used only in this browser preview</small><input id="bms-photo" data-bms-file type="file" accept="image/jpeg,image/png,image/webp"></label><p class="bms-photo-status" data-bms-status>No photo selected. Your preview works without one.</p></div>
					<p class="bms-privacy"><b>◎</b><span>Your selected photo is shown from a browser-local URL. This preview sends no photo to the site.</span></p>
				</div>
				<div class="bms-preview-panel">
					<div class="bms-preview-heading"><strong>Looking like a keeper.</strong><span><i></i> LIVE PREVIEW</span></div>
					<div class="bms-spread-stage">
						<div class="bms-mini-cover" data-bms-cover>
							<img class="bms-cover-photo" data-bms-image alt="Your local cover photo preview" hidden>
							<div class="bms-cover-art" data-bms-art aria-hidden="true"><i></i><b></b><span></span></div><div class="bms-cover-shade"></div>
							<div class="bms-cover-masthead">GOOD ISSUE <small>THE BIRTHDAY EDITION</small></div>
							<div class="bms-cover-headlines"><span>THE ONE AND ONLY</span><strong data-bms-name>TAYLOR</strong><small data-bms-age>AGE 30 · IN THEIR PRIME</small></div>
						</div>
						<div class="bms-spread">
							<article class="bms-page-sheet"><span class="bms-page-kicker">A VERY GOOD YEAR</span><h3>The story so far.</h3><p data-bms-story>Thirty looks good on you, Taylor. Here’s to everything you’ve made, the people who make you laugh, and the best chapters still ahead.</p><small>04</small></article>
							<article class="bms-page-sheet bms-photo-sheet"><div class="bms-spread-art" data-bms-spread-art></div><img class="bms-spread-photo" data-bms-image alt="Your local sample spread photo" hidden><span class="bms-page-kicker">A NOTE FOR THE NEXT CHAPTER</span><h3>More life.<br>More stories.</h3><p>Keep making it your own.</p><small>05</small></article>
						</div>
					</div>
					<div class="bms-preview-foot"><span><b>01 COVER</b> + 01 SAMPLE SPREAD</span><span>INSTANT · NO GENERATION WAIT</span></div>
				</div>
			</div>
			<div class="bms-unlock"><div><p class="bms-eyebrow">READY FOR THE FULL ISSUE?</p><h2>Unlock the full magazine.</h2><p>More pages, more room for their stories, and a keepsake made just for them.</p></div><a class="bms-buy" href="<?php echo esc_url($buy_url); ?>">UNLOCK FULL MAGAZINE <strong>US$39.99 <span>↗</span></strong></a></div>
		</section>
		<footer class="bms-footer"><span>GOOD ISSUE · MADE FOR THE PEOPLE YOU LOVE</span><span>YOUR PHOTO STAYS ON THIS DEVICE</span></footer>
	</main>
	<?php
	return ob_get_clean();
});
