<?php
/**
 * Plugin Name: Birthday Magazine G3C Local Mailpit
 * Description: Routes local WordPress email into this project's private Mailpit container.
 * Version: 0.1.0
 * License: GPL-2.0-or-later
 */

if (!defined('ABSPATH') || !defined('BMS_G3C_LOCAL_ONLY') || BMS_G3C_LOCAL_ONLY !== true) {
	return;
}

add_action('phpmailer_init', static function ($mailer) {
	$mailer->isSMTP();
	$mailer->Host = 'mailpit';
	$mailer->Port = 1025;
	$mailer->SMTPAuth = false;
	$mailer->SMTPAutoTLS = false;
});
