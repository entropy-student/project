<?php
/**
 * Local disposable G2A1R1 test wiring. This only routes WordPress mail to the
 * Mailpit service on the project-scoped Compose network (SMTP is not host-published).
 */

if (!defined('ABSPATH')) {
	exit;
}

add_action('phpmailer_init', static function ($mailer) {
	if (!defined('BMS_G2A1R1_MAILPIT') || BMS_G2A1R1_MAILPIT !== true) {
		return;
	}

	$mailer->isSMTP();
	$mailer->Host = 'mailpit';
	$mailer->Port = 1025;
	$mailer->SMTPAuth = false;
	$mailer->SMTPAutoTLS = false;
});
