<?php

require '/var/www/html/wp-load.php';

$backup_path = $argv[1] ?? '/tmp/g3cr4-pre-edit-backup.json';
$backup = is_file($backup_path) ? json_decode(file_get_contents($backup_path), true) : null;
$home_id = (int) get_option('page_on_front');

if (!$backup || ($backup['format'] ?? '') !== 'g3cr4-pre-edit-backup-v1' || $home_id !== 858 || ($backup['home']['id'] ?? 0) !== 858) {
	fwrite(STDERR, "G3CR4 restore identity check failed.\n");
	exit(1);
}

$result = wp_update_post([
	'ID' => $home_id,
	'post_title' => $backup['home']['title'],
	'post_status' => $backup['home']['status'],
	'post_content' => wp_slash($backup['home']['content']),
], true);

if (is_wp_error($result)) {
	fwrite(STDERR, "G3CR4 Home restore failed.\n");
	exit(2);
}

$keys = [
	'nav_menu_locations', 'colorPalette', 'site_background', 'header_placements', 'footer_placements',
	'custom_logo', 'h1Typography', 'h2Typography', 'h3Typography', 'h4Typography', 'h5Typography',
	'h6Typography', 'rootTypography', 'buttonHoverEffect', 'buttonColor', 'buttonRadius',
	'buttonTextColor', 'buttonMinHeight',
];
foreach ($keys as $key) {
	if (array_key_exists($key, $backup['blocksy_theme_mods'])) {
		set_theme_mod($key, $backup['blocksy_theme_mods'][$key]);
	} else {
		remove_theme_mod($key);
	}
}

$restored = get_post_field('post_content', $home_id);
if (hash('sha256', $restored) !== hash('sha256', (string) $backup['home']['content'])) {
	fwrite(STDERR, "G3CR4 Home restore read-back failed.\n");
	exit(3);
}

echo wp_json_encode(['restored' => true, 'home_id' => $home_id, 'theme_mod_keys_restored' => count($keys)], JSON_PRETTY_PRINT) . "\n";
