<?php
// Supported Blocksy dynamic-CSS mode keeps Owner palette edits current; local G3C only.
require '/var/www/html/wp-load.php';
if (get_option('home') !== 'http://127.0.0.1:8189' || wp_get_theme()->get_stylesheet() !== 'blocksy') { exit(2); }
set_theme_mod('dynamic_css_file', 'inline');
echo "BLOCKSY_PRESENTATION_CSS_MODE=INLINE\n";
