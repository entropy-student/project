<?php
/**
 * Plugin Name: Conversion Leak Audit Baseline
 * Description: G1 local-only project baseline helpers. No Scanner integration and no payment actions.
 * Version: 0.1.0
 */

if (!defined('ABSPATH')) { exit; }

function cla_scan_placeholder_shortcode(): string {
    $html = '<div class="cla-scan-shell" data-cla-g1-placeholder="true">';
    $html .= '<strong>Free store scan</strong>';
    $html .= '<form class="cla-scan-form" onsubmit="return false" aria-label="Store URL scan placeholder">';
    $html .= '<label class="screen-reader-text" for="cla-store-url">Store URL</label>';
    $html .= '<input id="cla-store-url" type="url" placeholder="https://yourstore.com" disabled aria-disabled="true">';
    $html .= '<button type="button" disabled aria-disabled="true">Scan my store</button>';
    $html .= '</form>';
    $html .= '<p class="cla-scan-note">G1 placeholder only. Scanner connection is intentionally disabled until G4.</p>';
    $html .= '</div>';
    return $html;
}
add_shortcode('cla_scan_placeholder', 'cla_scan_placeholder_shortcode');

function cla_baseline_enqueue_style(): void {
    $child = get_stylesheet_directory_uri() . '/style.css';
    wp_enqueue_style('cla-baseline-style', $child, [], '0.1.0');
}
add_action('wp_enqueue_scripts', 'cla_baseline_enqueue_style');
