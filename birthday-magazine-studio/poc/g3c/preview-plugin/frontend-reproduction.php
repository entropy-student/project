<?php
/**
 * G3CR7R1 local reproduction of the core intake and order-status surfaces.
 * Intake remains in browser memory; this file does not persist answers or photos.
 */
if (!defined('ABSPATH')) { exit; }

add_filter('the_content', function ($content) {
 if ((int) get_queried_object_id() !== 858) { return $content; }
 $product_url = get_permalink(1113);
 if (!$product_url || substr_count($content, 'href="' . esc_attr($product_url) . '"') !== 1) { return $content; }
 return str_replace('href="' . esc_attr($product_url) . '"', 'href="' . esc_url(home_url('/make-your-magazine/')) . '"', $content);
}, 99);

add_filter('body_class', function ($classes) {
 $post = get_post();
 if ($post && (has_shortcode($post->post_content, 'bms_g3cr7_intake') || has_shortcode($post->post_content, 'bms_g3cr7_status_fixture'))) {
  $classes[] = 'bms-g3cr7-app-page';
 }
 return $classes;
});

add_action('wp_enqueue_scripts', function () {
 $post = get_post();
 $has_app = $post && (has_shortcode($post->post_content, 'bms_g3cr7_intake') || has_shortcode($post->post_content, 'bms_g3cr7_status_fixture'));
 $is_order_received = function_exists('is_order_received_page') && is_order_received_page();
 if (!$has_app && !$is_order_received) { return; }
 wp_enqueue_style('bms-g3cr7-reproduction', plugins_url('frontend-reproduction.css', __FILE__), ['bms-studio'], filemtime(__DIR__ . '/frontend-reproduction.css'));
 if ($has_app && has_shortcode($post->post_content, 'bms_g3cr7_intake')) {
  wp_enqueue_script('bms-g3cr7-reproduction', plugins_url('frontend-reproduction.js', __FILE__), [], '0.1.0', true);
 }
}, 130);

add_shortcode('bms_g3cr7_intake', function () {
 $product_id = 1113;
 $checkout_url = function_exists('wc_get_checkout_url') ? wc_get_checkout_url() : home_url('/checkout/');
 $add_url = class_exists('WC_AJAX') ? WC_AJAX::get_endpoint('add_to_cart') : add_query_arg('wc-ajax', 'add_to_cart', home_url('/'));
 $product = function_exists('wc_get_product') ? wc_get_product($product_id) : false;
 ob_start(); ?>
 <section class="bms-g3cr7" aria-label="Create a birthday magazine" data-bms-g3cr7 data-add-url="<?php echo esc_url($add_url); ?>" data-checkout-url="<?php echo esc_url($checkout_url); ?>" data-product-id="<?php echo esc_attr($product_id); ?>">
  <header class="bms-g3cr7-intro"><p class="bms-g3cr7-kicker">THE FULL STORY</p><h1>Make a magazine<br><em>about their kind of wonderful.</em></h1><p>Five calm steps. Their photos, your memories, and the little details only you know.</p></header>
  <nav class="bms-g3cr7-progress" aria-label="Magazine intake steps"><ol>
   <li aria-current="step"><span>01</span><span>About them</span></li><li><span>02</span><span>Photos</span></li><li><span>03</span><span>Their story</span></li><li><span>04</span><span>Little things</span></li><li><span>05</span><span>Review</span></li>
  </ol><div class="bms-g3cr7-progress-track"><span data-progress-bar></span></div></nav>
  <div class="bms-g3cr7-card">
   <section class="bms-g3cr7-step" data-step="0" aria-labelledby="bms-step-about">
    <p class="bms-g3cr7-step-label">STEP 01 · THE PERSON AT THE HEART OF IT</p><h2 id="bms-step-about">First, tell us about them.</h2><p class="bms-g3cr7-help">A few simple facts help every page feel like it belongs to them.</p>
    <div class="bms-g3cr7-fields">
     <label class="bms-g3cr7-field bms-g3cr7-field-wide">Their name<input name="recipient_name" autocomplete="off" required></label>
     <label class="bms-g3cr7-field">Age<input name="age" type="number" min="1" max="120" inputmode="numeric" required></label>
     <label class="bms-g3cr7-field">Birthday <span class="bms-g3cr7-optional">optional if age is known</span><input name="birthday" type="date"></label>
     <label class="bms-g3cr7-field">Your relationship<select name="relationship" required><option value="">Choose one</option><option>Friend</option><option>Partner</option><option>Sibling</option><option>Parent</option><option>Child</option><option>Other family</option><option>Other</option></select></label>
     <label class="bms-g3cr7-field">The tone<select name="tone" required><option value="">Choose the feeling</option><option value="heartfelt">Heartfelt</option><option value="playful">Playful</option><option value="balanced">Balanced</option></select></label>
     <label class="bms-g3cr7-field bms-g3cr7-field-wide">Pronouns <span class="bms-g3cr7-optional">optional</span><input name="pronouns" autocomplete="off"></label>
    </div>
   </section>
   <section class="bms-g3cr7-step" data-step="1" aria-labelledby="bms-step-photos" hidden>
    <p class="bms-g3cr7-step-label">STEP 02 · THE PHOTOGRAPHS</p><h2 id="bms-step-photos">Bring their moments.</h2><p class="bms-g3cr7-help">Choose 12–25 JPG, PNG, or WebP images. Mark up to three must-use photos.</p>
    <label class="bms-g3cr7-drop" for="bms-g3cr7-files"><span aria-hidden="true">＋</span><strong>Choose photos from this device</strong><small>They stay in this browser in this local proof.</small><input id="bms-g3cr7-files" type="file" accept="image/jpeg,image/png,image/webp" multiple></label>
    <div class="bms-g3cr7-photo-meta"><span><strong data-photo-count>0</strong> of 12–25 selected</span><span><strong data-must-count>0</strong> of 3 marked must-use</span></div>
    <p class="bms-g3cr7-fixture-note">Local test uses fictional geometric PNG fixtures, not customer photographs.</p>
    <div class="bms-g3cr7-photo-grid" data-photo-grid aria-live="polite"></div><p class="bms-g3cr7-error" data-photo-error role="alert" hidden></p>
   </section>
   <section class="bms-g3cr7-step" data-step="2" aria-labelledby="bms-step-story" hidden>
    <p class="bms-g3cr7-step-label">STEP 03 · THE STORY ONLY YOU CAN TELL</p><h2 id="bms-step-story">What makes them them?</h2><p class="bms-g3cr7-help">A few sentences is plenty. Write naturally; we’ll shape the story later.</p>
    <label class="bms-g3cr7-field bms-g3cr7-field-stack">1. What makes them unmistakably them?<textarea name="q1" rows="4" required></textarea></label>
    <label class="bms-g3cr7-field bms-g3cr7-field-stack">2. Tell us one memory you always come back to.<textarea name="q2" rows="4" required></textarea></label>
    <label class="bms-g3cr7-field bms-g3cr7-field-stack">3. What do you admire or appreciate most about them — and why?<textarea name="q3" rows="4" required></textarea></label>
   </section>
   <section class="bms-g3cr7-step" data-step="3" aria-labelledby="bms-step-little" hidden>
    <p class="bms-g3cr7-step-label">STEP 04 · THE LITTLE THINGS</p><h2 id="bms-step-little">The details make it theirs.</h2><p class="bms-g3cr7-help">These are the bits a generic birthday card could never know.</p>
    <label class="bms-g3cr7-field bms-g3cr7-field-stack">4. What are the little things only people close to them know?<textarea name="q4" rows="4" required></textarea></label>
    <label class="bms-g3cr7-field bms-g3cr7-field-stack">5. What are they into right now?<textarea name="q5" rows="4" required></textarea></label>
    <label class="bms-g3cr7-field bms-g3cr7-field-stack">6. What do you want them to hear on this birthday?<textarea name="q6" rows="4" required></textarea></label>
    <details class="bms-g3cr7-quick-facts"><summary>Optional quick facts</summary><div class="bms-g3cr7-fields"><label class="bms-g3cr7-field">Favorite song<input name="favorite_song"></label><label class="bms-g3cr7-field">Favorite food or drink<input name="favorite_food"></label><label class="bms-g3cr7-field">Favorite place<input name="favorite_place"></label><label class="bms-g3cr7-field">Current obsession<input name="current_obsession"></label><label class="bms-g3cr7-field bms-g3cr7-field-wide">One phrase to include<input name="must_include"></label></div></details>
   </section>
   <section class="bms-g3cr7-step" data-step="4" aria-labelledby="bms-step-review" hidden>
    <p class="bms-g3cr7-step-label">STEP 05 · YOUR ISSUE, AT A GLANCE</p><h2 id="bms-step-review">Everything sounds like them.</h2><p class="bms-g3cr7-help">Review the details before continuing to the WooCommerce checkout.</p>
    <dl class="bms-g3cr7-review" data-review-summary></dl>
    <div class="bms-g3cr7-review-answers" data-review-answers></div>
    <aside class="bms-g3cr7-boundary"><strong>Local interface proof</strong><p>Answers and photos remain in this browser and are not saved to the server in this Gate. The next button verifies the WooCommerce checkout handoff only. Do not place an order.</p></aside>
    <p class="bms-g3cr7-price">Next step <span><?php echo $product ? wp_kses_post(wc_price($product->get_price())) : 'US$39.99'; ?> WooCommerce checkout</span></p>
    <button class="bms-g3cr7-button bms-g3cr7-checkout" type="button" data-checkout>Continue to WooCommerce checkout <span aria-hidden="true">↗</span></button>
    <p class="bms-g3cr7-error" data-checkout-error role="alert" hidden></p>
   </section>
   <div class="bms-g3cr7-nav"><button type="button" class="bms-g3cr7-back" data-back disabled>← Back</button><p data-step-count>Step 1 of 5</p><button type="button" class="bms-g3cr7-button" data-next>Continue <span aria-hidden="true">→</span></button></div>
  </div>
  <p class="bms-g3cr7-footnote">A personalized 12-page digital magazine · US Letter PDF · one bounded revision batch</p>
 </section>
 <?php return ob_get_clean();
});

function bms_g3cr7_order_state($order_id) {
 if (!function_exists('wc_get_order') || !absint($order_id)) { return 'not_found'; }
 $order = wc_get_order(absint($order_id));
 if (!$order || !is_a($order, 'WC_Order')) { return 'not_found'; }
 return $order->is_paid() ? 'payment_confirmed' : 'awaiting_payment';
}

function bms_g3cr7_render_order_status($order_id) {
 $state = bms_g3cr7_order_state($order_id);
 if ($state === 'not_found') { return; }
 if ($state === 'payment_confirmed') {
  echo '<section class="bms-g3cr7-thankyou"><p class="bms-g3cr7-kicker">PAYMENT CONFIRMED</p><h2>Your next chapter starts here.</h2><p>Your payment is confirmed. Magazine progress will appear in your private order workspace.</p></section>';
  return;
 }
 echo '<section class="bms-g3cr7-thankyou"><p class="bms-g3cr7-kicker">PAYMENT PENDING</p><h2>We are waiting for payment confirmation.</h2><p>Your magazine work has not started. The order status shown above is the WooCommerce record.</p></section>';
}
add_action('woocommerce_thankyou', 'bms_g3cr7_render_order_status', 30, 1);

add_shortcode('bms_g3cr7_status_fixture', function () {
 ob_start(); ?>
 <section class="bms-g3cr7-status-fixture" aria-label="Order progress visual fixture"><p class="bms-g3cr7-fixture-banner">LOCAL VISUAL QA FIXTURE · NOT AN ORDER · NO PAYMENT OR GENERATION</p><div class="bms-g3cr7-fixture-order-received"><p class="bms-g3cr7-fixture-banner">ORDER-RECEIVED CONTINUATION · VISUAL FIXTURE ONLY</p><section class="bms-g3cr7-thankyou"><p class="bms-g3cr7-kicker">PAYMENT PENDING · SAMPLE STATE</p><h2>We are waiting for payment confirmation.</h2><p>This sample does not represent a real order. Real payment status is read from the WooCommerce order.</p></section></div><p class="bms-g3cr7-kicker">A PRIVATE ORDER WORKSPACE</p><h1>One good story,<br><em>taking shape.</em></h1><p class="bms-g3cr7-status-lede">A visual sample of the progress language. Real payment status comes from WooCommerce; this fixture is not connected to an order.</p>
  <ol class="bms-g3cr7-timeline"><li class="is-done"><span>01</span><div><strong>Intake received</strong><p>Your story and selected photographs.</p></div><b>Sample</b></li><li class="is-done"><span>02</span><div><strong>Payment confirmed</strong><p>Confirmed by the WooCommerce order in a real flow.</p></div><b>Sample</b></li><li class="is-current"><span>03</span><div><strong>Designing the issue</strong><p>A visual-only progress state for review.</p></div><b>Fixture</b></li><li id="bms-g3cr7-ready" class="is-ready"><span>04</span><div><strong>Your proof is ready</strong><p>Review the complete magazine in your private workspace.</p></div><b>Fixture</b></li></ol>
  <p class="bms-g3cr7-footnote">This screen does not start a job, confirm payment, or create a magazine.</p>
 </section>
 <?php return ob_get_clean();
});
