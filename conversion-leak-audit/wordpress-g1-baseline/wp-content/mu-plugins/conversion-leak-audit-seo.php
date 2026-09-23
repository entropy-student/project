<?php
/**
 * Plugin Name: Conversion Leak Audit SEO Readiness
 * Description: Lightweight project-owned metadata and indexability rules.
 * Version: 0.1.0
 */

if (!defined('ABSPATH')) { exit; }

function cla_g46_is_scan_result_request(): bool {
    return is_front_page() && array_key_exists('scan_id', $_GET);
}

function cla_g46_current_page_slug(): string {
    if (is_front_page()) { return 'home'; }
    if (!is_page()) { return ''; }
    $page = get_queried_object();
    return ($page instanceof WP_Post) ? (string) $page->post_name : '';
}

function cla_g46_page_titles(): array {
    return [
        'home' => 'Free Ecommerce Conversion Audit | Conversion Leak Audit',
        'how-it-works' => 'How This Ecommerce Conversion Audit Works | Conversion Leak Audit',
        'demo' => 'Example Ecommerce Store Audit | Conversion Leak Audit',
        'faq' => 'Ecommerce Conversion Audit FAQ | Conversion Leak Audit',
    ];
}

function cla_g46_page_descriptions(): array {
    return [
        'home' => 'Get a free evidence-backed Top 3 from public storefront pages. No signup or admin access required.',
        'how-it-works' => 'Learn how this ecommerce conversion audit checks a limited set of public storefront pages, records evidence, and marks incomplete scans clearly.',
        'demo' => 'See a synthetic example ecommerce storefront audit with three evidence-backed findings, their sources, first moves, and limitations.',
        'faq' => 'Answers about the ecommerce conversion audit, public-page scanning, evidence, access, and scan limitations.',
    ];
}

function cla_g46_document_title(string $title): string {
    $slug = cla_g46_current_page_slug();
    $titles = cla_g46_page_titles();
    return $titles[$slug] ?? $title;
}
add_filter('pre_get_document_title', 'cla_g46_document_title', 100);

function cla_g46_output_page_metadata(): void {
    $slug = cla_g46_current_page_slug();
    $descriptions = cla_g46_page_descriptions();
    if (isset($descriptions[$slug])) {
        echo '<meta name="description" content="' . esc_attr($descriptions[$slug]) . '">' . "\n";
    }

    if (is_singular('page')) {
        $canonical = cla_g46_is_scan_result_request() ? home_url('/') : get_permalink(get_queried_object_id());
        if ($canonical) {
            echo '<link rel="canonical" href="' . esc_url($canonical) . '">' . "\n";
        }
    }
}
add_action('wp_head', 'cla_g46_output_page_metadata', 2);

function cla_g46_disable_core_canonical(): void {
    remove_action('wp_head', 'rel_canonical');
}
add_action('wp', 'cla_g46_disable_core_canonical', 1);

function cla_g46_robots(array $robots): array {
    $slug = cla_g46_current_page_slug();
    $noindex = cla_g46_is_scan_result_request() || in_array($slug, ['blog', 'pricing'], true);
    $indexable = isset(cla_g46_page_titles()[$slug]);

    if ($noindex) {
        unset($robots['index'], $robots['nofollow']);
        $robots['noindex'] = true;
        $robots['follow'] = true;
    } elseif ($indexable) {
        unset($robots['noindex'], $robots['nofollow']);
        $robots['index'] = true;
        $robots['follow'] = true;
    }

    return $robots;
}
add_filter('wp_robots', 'cla_g46_robots', 99);

function cla_g46_sitemap_post_types(array $post_types): array {
    return isset($post_types['page']) ? ['page' => $post_types['page']] : [];
}
add_filter('wp_sitemaps_post_types', 'cla_g46_sitemap_post_types');

function cla_g46_sitemap_provider($provider, string $name) {
    return in_array($name, ['users', 'taxonomies'], true) ? false : $provider;
}
add_filter('wp_sitemaps_add_provider', 'cla_g46_sitemap_provider', 10, 2);

function cla_g46_sitemap_entry($entry, WP_Post $post, string $post_type) {
    if ($post_type !== 'page') { return false; }

    $front_page_id = (int) get_option('page_on_front');
    $is_front_page = $front_page_id > 0 && (int) $post->ID === $front_page_id;
    $allowed_slug = in_array($post->post_name, ['how-it-works', 'demo', 'faq'], true);

    return ($is_front_page || $allowed_slug) ? $entry : false;
}
add_filter('wp_sitemaps_posts_entry', 'cla_g46_sitemap_entry', 10, 3);
