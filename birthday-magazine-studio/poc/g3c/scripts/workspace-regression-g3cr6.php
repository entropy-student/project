<?php
// Read-only test of the existing template_redirect guard; no credentials/cookies created.
require '/var/www/html/wp-load.php';
$context = $argv[1] ?? '';
if (!in_array($context, ['owner', 'unrelated', 'guest'], true)) { exit(2); }
$order_id = (int) get_option('bms_g3c_workspace_test_order_id');
$order = wc_get_order($order_id);
$user = $context === 'owner' ? get_user_by('id', $order->get_customer_id()) : ($context === 'unrelated' ? get_user_by('login', 'bms-g3c-buyer-b') : null);
if (!$order || ($context !== 'guest' && !$user)) { exit(3); }
wp_set_current_user($user ? $user->ID : 0);
set_query_var('bms_g3a_order', $order_id);
$status = 200;
add_filter('status_header', function ($header, $code) use (&$status) { $status = $code; return $header; }, 10, 2);
$body = '';
ob_start(function ($buffer) use (&$body) { $body .= $buffer; return ''; });
register_shutdown_function(function () use ($context, &$status, &$body) {
    while (ob_get_level()) { ob_end_flush(); }
    echo wp_json_encode(['context'=>$context,'status'=>$status,'workspace_rendered'=>str_contains($body,'data-bms-g3a-workspace'),'test_boundary'=>'existing PHP template_redirect handler; in-memory synthetic identity; no HTTP login/session proof','persistent_mutations'=>0], JSON_PRETTY_PRINT) . "\n";
});
do_action('template_redirect');
