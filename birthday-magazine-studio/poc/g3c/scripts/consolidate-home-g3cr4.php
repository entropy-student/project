<?php

require '/var/www/html/wp-load.php';
require_once ABSPATH . 'wp-admin/includes/plugin.php';

$fail = static function ($message, $code = 1) {
	fwrite(STDERR, $message . "\n");
	exit($code);
};

$backup_path = '/tmp/g3cr4-pre-edit-backup.json';
$backup = is_file($backup_path) ? json_decode(file_get_contents($backup_path), true) : null;
$home_id = (int) get_option('page_on_front');
$home = get_post($home_id);
$theme = wp_get_theme();
$product = function_exists('wc_get_product') ? wc_get_product(1113) : false;
$active_plugins = (array) get_option('active_plugins', []);

if (!$backup || ($backup['format'] ?? '') !== 'g3cr4-pre-edit-backup-v1' || ($backup['home']['id'] ?? 0) !== 858) {
	$fail('G3CR4 backup precondition failed; Home was not changed.');
}
if ($home_id !== 858 || !$home || $home->post_status !== 'publish' || $home->post_type !== 'page') {
	$fail('G3CR4 Home page identity drift; Home was not changed.');
}
if (hash('sha256', $home->post_content) !== hash('sha256', (string) $backup['home']['content'])) {
	$fail('G3CR4 Home content changed after backup; Home was not changed.');
}
if ($theme->get_stylesheet() !== 'blocksy' || $theme->get('Version') !== '2.1.57') {
	$fail('G3CR4 Blocksy baseline drift; Home was not changed.');
}
if (!$product || !in_array('woocommerce/woocommerce.php', $active_plugins, true) || get_woocommerce_currency() !== 'USD' || (float) $product->get_price() !== 39.99 || !$product->is_virtual()) {
	$fail('G3CR4 WooCommerce product baseline drift; Home was not changed.');
}
if (!in_array('bms-g3c-preview/birthday-magazine-poc.php', $active_plugins, true)) {
	$fail('Good Issue preview plugin is not active; Home was not changed.');
}
foreach ([1106, 1107, 1108] as $image_id) {
	if (get_post_type($image_id) !== 'attachment' || !is_file((string) get_attached_file($image_id))) {
		$fail('A required synthetic sample image is unavailable; Home was not changed.');
	}
}

function g3cr4_block($name, $attrs, $html) {
	$json = $attrs ? ' ' . wp_json_encode($attrs, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) : '';
	return '<!-- wp:' . $name . $json . " -->\n" . $html . "\n<!-- /wp:" . $name . ' -->';
}

function g3cr4_group($class, $inner, $anchor = null) {
	$attrs = ['className' => $class];
	$id = '';
	if ($anchor) {
		$attrs['anchor'] = $anchor;
		$id = ' id="' . esc_attr($anchor) . '"';
	}
	$html = '<div class="wp-block-group ' . esc_attr($class) . '"' . $id . ">\n" . $inner . "\n</div>";
	return g3cr4_block('group', $attrs, $html);
}

function g3cr4_heading($level, $html, $class = '') {
	$attrs = ['level' => $level];
	$class_attr = 'wp-block-heading';
	if ($class) {
		$attrs['className'] = $class;
		$class_attr .= ' ' . $class;
	}
	return g3cr4_block('heading', $attrs, '<h' . $level . ' class="' . esc_attr($class_attr) . '">' . $html . '</h' . $level . '>');
}

function g3cr4_paragraph($text, $class = '') {
	$attrs = $class ? ['className' => $class] : [];
	$class_attr = $class ? ' class="' . esc_attr($class) . '"' : '';
	return g3cr4_block('paragraph', $attrs, '<p' . $class_attr . '>' . esc_html($text) . '</p>');
}

function g3cr4_image($id, $class, $alt) {
	$src = wp_get_attachment_image_url($id, 'full');
	if (!$src) {
		throw new RuntimeException('Required sample image URL is unavailable.');
	}
	$attrs = ['id' => $id, 'sizeSlug' => 'full', 'linkDestination' => 'none', 'className' => $class];
	$figure_class = 'wp-block-image size-full ' . $class;
	$html = '<figure class="' . esc_attr($figure_class) . '"><img src="' . esc_url($src) . '" alt="' . esc_attr($alt) . '" class="wp-image-' . (int) $id . '" /></figure>';
	return g3cr4_block('image', $attrs, $html);
}

function g3cr4_button($text, $url, $class) {
	$attrs = ['className' => $class];
	$html = '<div class="wp-block-button ' . esc_attr($class) . '"><a class="wp-block-button__link wp-element-button" href="' . esc_url($url) . '">' . esc_html($text) . '</a></div>';
	return g3cr4_block('button', $attrs, $html);
}

function g3cr4_button_row($text, $url, $class = 'g3cr4-actions', $button_class = 'g3cr4-button') {
	$attrs = ['className' => $class];
	return g3cr4_block('buttons', $attrs, '<div class="wp-block-buttons ' . esc_attr($class) . '">' . g3cr4_button($text, $url, $button_class) . '</div>');
}

function g3cr4_sample_card($image_id, $kicker, $title, $description) {
	$inner = g3cr4_paragraph($kicker, 'g3cr4-sample-kicker');
	$inner .= g3cr4_image($image_id, 'g3cr4-sample-image', 'Synthetic sample page — not a customer magazine.');
	$inner .= g3cr4_heading(3, esc_html($title), 'g3cr4-sample-title');
	$inner .= g3cr4_paragraph($description);
	return g3cr4_group('g3cr4-sample-card', $inner);
}

function g3cr4_step($number, $title, $description) {
	$inner = g3cr4_paragraph($number, 'g3cr4-step-number');
	$inner .= g3cr4_heading(3, esc_html($title));
	$inner .= g3cr4_paragraph($description);
	return g3cr4_group('g3cr4-step', $inner);
}

function g3cr4_faq($question, $answer) {
	$html = '<details class="wp-block-details g3cr4-faq-item"><summary>' . esc_html($question) . '</summary><p>' . esc_html($answer) . '</p></details>';
	return g3cr4_block('details', ['className' => 'g3cr4-faq-item'], $html);
}

function g3cr4_shortcode_count($blocks) {
	$count = 0;
	foreach ($blocks as $block) {
		if (($block['blockName'] ?? '') === 'core/shortcode' && str_contains((string) ($block['attrs']['text'] ?? ''), '[bms_preview')) {
			$count++;
		}
		if (!empty($block['innerBlocks'])) {
			$count += g3cr4_shortcode_count($block['innerBlocks']);
		}
	}
	return $count;
}

$product_url = get_permalink(1113);
$hero_copy = g3cr4_paragraph('A PERSONALIZED GIFT, MADE FOR THEM', 'g3cr4-eyebrow');
$hero_copy .= g3cr4_heading(1, 'A Birthday Magazine<br><em>Made About Them</em>', 'g3cr4-hero-title');
$hero_copy .= g3cr4_paragraph('Turn their photos and stories into a birthday keepsake made just for them. No design skills required.', 'g3cr4-hero-lede');
$hero_copy .= g3cr4_button_row('Create a Free Preview', '#preview');
$hero_copy .= g3cr4_paragraph('Browser-local preview · No design skills required', 'g3cr4-trust-line');
$hero_art = g3cr4_image(1106, 'g3cr4-hero-image', 'Synthetic birthday magazine cover sample.');
$hero_art .= g3cr4_paragraph('SYNTHETIC COVER SAMPLE · 12-PAGE DIGITAL ISSUE', 'g3cr4-hero-caption');
$hero_inner = g3cr4_group('g3cr4-hero-grid', g3cr4_group('g3cr4-hero-copy', $hero_copy) . g3cr4_group('g3cr4-hero-art', $hero_art));
$hero = g3cr4_group('g3cr4-section g3cr4-hero', $hero_inner, 'hero');

$sample_inner = g3cr4_paragraph('A FEW PAGES FROM A SYNTHETIC SAMPLE ISSUE', 'g3cr4-eyebrow');
$sample_inner .= g3cr4_heading(2, 'A magazine with them at the center.', 'g3cr4-section-title');
$sample_inner .= g3cr4_paragraph('A cover, a story-led feature, and a photo spread show the feel of the finished keepsake.', 'g3cr4-section-intro');
$sample_cards = g3cr4_sample_card(1106, '01 · FRONT COVER', 'The birthday issue', 'A personal cover built around one person.');
$sample_cards .= g3cr4_sample_card(1107, '04 · FEATURE MEMORY', 'A story worth keeping', 'A memory becomes an editorial feature.');
$sample_cards .= g3cr4_sample_card(1108, '08 · PHOTO STORY', 'The current chapter', 'Photos and details shape the magazine pages.');
$sample_inner .= g3cr4_group('g3cr4-sample-grid', $sample_cards);
$samples = g3cr4_group('g3cr4-section g3cr4-samples', $sample_inner, 'sample-pages');

$preview_inner = g3cr4_paragraph('TRY IT IN YOUR BROWSER', 'g3cr4-eyebrow');
$preview_inner .= g3cr4_heading(2, 'Create a free preview.', 'g3cr4-section-title');
$preview_inner .= g3cr4_paragraph('Add a name, age, style, and optionally one cover photo. The preview updates in this browser.', 'g3cr4-section-intro');
$shortcode = '[bms_preview product_id="1113"]';
$preview_inner .= g3cr4_block('shortcode', ['text' => $shortcode], '<div class="wp-block-shortcode">' . esc_html($shortcode) . '</div>');
$preview = g3cr4_group('g3cr4-section g3cr4-preview', $preview_inner, 'preview');

$what_inner = g3cr4_paragraph('THE FINISHED DIGITAL GIFT', 'g3cr4-eyebrow');
$what_inner .= g3cr4_heading(2, 'What you get.', 'g3cr4-section-title');
$what_inner .= g3cr4_paragraph('One personalized birthday magazine built around their photos and story.', 'g3cr4-section-intro');
$what_list = '<ul class="wp-block-list g3cr4-what-grid"><li><strong>12 pages.</strong><span>US Letter digital PDF.</span></li><li><strong>Story-led layouts.</strong><span>Their photos and answers shape the pages.</span></li><li><strong>One revision batch.</strong><span>One bounded set of requested changes.</span></li><li><strong>Private workspace.</strong><span>Account access to the order workspace.</span></li></ul>';
$what_inner .= g3cr4_block('list', ['className' => 'g3cr4-what-grid'], $what_list);
$what = g3cr4_group('g3cr4-section g3cr4-what', $what_inner, 'what-you-get');

$how_inner = g3cr4_paragraph('A SIMPLE FOUR-STEP FLOW', 'g3cr4-eyebrow');
$how_inner .= g3cr4_heading(2, 'How it works.', 'g3cr4-section-title');
$steps = g3cr4_step('01', 'Choose photos + answer prompts', 'Share the selected photos and a few short answers.');
$steps .= g3cr4_step('02', 'Create a free preview', 'See the cover and a sample spread in your browser.');
$steps .= g3cr4_step('03', 'Purchase through WooCommerce', 'Continue through the existing product and checkout path.');
$steps .= g3cr4_step('04', 'Continue in your workspace', 'Use the authenticated private order workspace.');
$how_inner .= g3cr4_group('g3cr4-step-grid', $steps);
$how = g3cr4_group('g3cr4-section g3cr4-how', $how_inner, 'how-it-works');

$offer_inner = g3cr4_paragraph('THE COMPLETE DIGITAL ISSUE', 'g3cr4-eyebrow');
$offer_inner .= g3cr4_heading(2, 'A thoughtful gift, made personal.', 'g3cr4-offer-title');
$offer_inner .= g3cr4_heading(3, 'US$39.99', 'g3cr4-price');
$offer_inner .= g3cr4_paragraph('One personalized 12-page US Letter digital magazine.', 'g3cr4-offer-copy');
$offer_inner .= g3cr4_button_row('Continue to the magazine', $product_url, 'g3cr4-actions', 'g3cr4-offer-button');
$offer = g3cr4_group('g3cr4-offer-card', $offer_inner);

$faq_inner = g3cr4_heading(2, 'Questions, answered.', 'g3cr4-faq-title');
$faq_inner .= g3cr4_faq('What will I receive?', 'A personalized 12-page US Letter digital PDF.');
$faq_inner .= g3cr4_faq('Do I need design experience?', 'No. Share photos and answers; the magazine follows a fixed page structure.');
$faq_inner .= g3cr4_faq('Does the free preview upload my photo?', 'No. The optional cover photo is previewed from a browser-local object URL. The free preview makes no AI calls.');
$faq_inner .= g3cr4_faq('Why is an account required?', 'An authenticated account is required to access the private order workspace.');
$faq_inner .= g3cr4_faq('What is included in the revision?', 'The US$39.99 product includes one bounded revision batch.');
$faq_inner .= g3cr4_faq('How long are project files kept?', 'After final delivery, source photos and working files are deleted within 24 hours. The final PDF remains available for 72 hours.');
$offer_faq = g3cr4_group('g3cr4-faq-list', $faq_inner);
$offer_faq = g3cr4_group('g3cr4-offerfaq-grid', $offer . $offer_faq);
$offer_faq = g3cr4_group('g3cr4-section g3cr4-offer-faq', $offer_faq, 'offer-faq');

$sections = [$hero, $samples, $preview, $what, $how, $offer_faq];
$content = implode("\n\n", $sections);
$parsed = array_values(array_filter(parse_blocks($content), static fn($block) => !empty($block['blockName'])));
if (count($parsed) !== 6 || array_filter($parsed, static fn($block) => $block['blockName'] !== 'core/group')) {
	$fail('G3CR4 generated Home content did not parse as six Gutenberg sections: ' . wp_json_encode([
		'count' => count($parsed),
		'blocks' => array_map(static fn($block) => $block['blockName'] ?? null, $parsed),
	]));
}
if (substr_count($content, 'g3cr4-sample-card') !== 6 || g3cr4_shortcode_count($parsed) !== 1 || stripos($content, 'wedding') !== false || stripos($content, 'spacer') !== false) {
	$fail('G3CR4 Home content did not meet section, sample, or legacy-content limits: ' . wp_json_encode([
		'sample_card_class_occurrences' => substr_count($content, 'g3cr4-sample-card'),
		'preview_shortcode_blocks' => g3cr4_shortcode_count($parsed),
		'wedding_copy_present' => stripos($content, 'wedding') !== false,
		'spacer_copy_present' => stripos($content, 'spacer') !== false,
	]));
}

$updated = wp_update_post(['ID' => $home_id, 'post_content' => wp_slash($content)], true);
if (is_wp_error($updated)) {
	$fail('WordPress did not save the consolidated Home content.');
}
$saved = get_post_field('post_content', $home_id);
$saved_blocks = array_values(array_filter(parse_blocks($saved), static fn($block) => !empty($block['blockName'])));
if ((int) $updated !== $home_id || count($saved_blocks) !== 6 || !has_shortcode($saved, 'bms_preview') || g3cr4_shortcode_count(parse_blocks($saved)) !== 1) {
	$fail('G3CR4 Home post read-back failed after save.');
}

echo wp_json_encode([
	'updated' => true,
	'page_id' => $home_id,
	'page_title' => get_the_title($home_id),
	'page_editor' => 'Gutenberg core blocks + one preview shortcode block',
	'primary_section_count' => count($saved_blocks),
	'sample_cards_desktop' => 3,
	'sample_cards_mobile' => 2,
	'preview_shortcode_count' => g3cr4_shortcode_count(parse_blocks($saved)),
	'product_url' => $product_url,
	'product_id' => 1113,
	'product_price_usd' => $product->get_price(),
	'product_virtual' => $product->is_virtual(),
	'wordpress_version' => $GLOBALS['wp_version'],
	'theme' => $theme->get('Name'),
	'theme_version' => $theme->get('Version'),
	'home_content_sha256' => hash('sha256', $saved),
], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . "\n";
