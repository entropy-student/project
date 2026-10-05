<?php
/**
 * Mini Craft Home Skin — K10B. Presentation only; page 939 public front page.
 * Native theme/navigation/Woo behavior remains owned by existing code.
 */
defined('ABSPATH') || exit;
function mini_craft_home_skin_is_target() {
    return !is_admin() && is_front_page() && 939 === (int) get_queried_object_id();
}
add_filter('body_class', function ($classes) {
    if (mini_craft_home_skin_is_target()) {
        $classes[] = 'mc-homira-home';
    }
    return $classes;
});
add_action('wp_enqueue_scripts', function () {
    if (!mini_craft_home_skin_is_target()) {
        return;
    }
    $dir = __DIR__ . '/mini-craft-home-skin/';
    $url = content_url('/mu-plugins/mini-craft-home-skin/');
    wp_enqueue_style('mini-craft-home-skin', $url . 'home.css', array(), substr(hash_file('sha256', $dir . 'home.css'), 0, 16));
    wp_enqueue_script('mini-craft-home-skin', $url . 'home.js', array(), substr(hash_file('sha256', $dir . 'home.js'), 0, 16), true);
}, 100);
