<?php
/** G3CR7 presentation-only frontend shells. No persistence or generation. */
if (!defined('ABSPATH')) { exit; }
function bms7_create(): string { return add_query_arg('bms_surface','intake',home_url('/')); }
function bms7_checkout(): string {
 $base=function_exists('wc_get_checkout_url')?wc_get_checkout_url():home_url('/');
 return add_query_arg(['add-to-cart'=>1113,'quantity'=>1],$base);
}
function bms7_assets(): void {
 wp_enqueue_style('bms7-flow',plugins_url('frontend-flow.css',__FILE__),[],'0.1.0');
 wp_enqueue_style('bms7-intake',plugins_url('frontend-intake.css',__FILE__),['bms7-flow'],'0.1.0');
 wp_enqueue_script('bms7-flow',plugins_url('frontend-flow.js',__FILE__),[],'0.1.0',true);
 wp_enqueue_script('bms7-intake-ui',plugins_url('frontend-intake-ui.js',__FILE__),['bms7-flow'],'0.1.0',true);
 wp_enqueue_script('bms7-intake',plugins_url('frontend-intake.js',__FILE__),['bms7-intake-ui'],'0.1.0',true);
 wp_add_inline_script('bms7-flow','window.BMS7='.wp_json_encode(['create'=>bms7_create(),'checkout'=>bms7_checkout()]).';','before');
}
add_action('wp_enqueue_scripts',static function(){
 $s=isset($_GET['bms_surface'])?sanitize_key(wp_unslash($_GET['bms_surface'])):'';
 $received=function_exists('is_order_received_page')&&is_order_received_page();
 if(is_front_page()||in_array($s,['intake','status'],true)||$received){bms7_assets();}
},130);
function bms7_doc(string $surface): void {
 $title=$surface==='intake'?'Create their birthday issue':'Your birthday issue';
 ?><!doctype html><html <?php language_attributes(); ?>><head><meta charset="<?php bloginfo('charset'); ?>"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="robots" content="noindex,nofollow"><title><?php echo esc_html($title); ?> — Good Issue</title><?php wp_head(); ?></head><body class="bms7"><main id="bms7-root" data-bms7-surface="<?php echo esc_attr($surface); ?>"></main><?php wp_footer(); ?></body></html><?php
}
add_action('template_redirect',static function(){
 if(is_admin())return;
 $s=isset($_GET['bms_surface'])?sanitize_key(wp_unslash($_GET['bms_surface'])):'';
 if(in_array($s,['intake','status'],true)){status_header(200);nocache_headers();bms7_doc($s);exit;}
},0);
add_action('woocommerce_thankyou',static function($order_id){
 if(!$order_id)return;
 echo '<div class="bms7-order-status" data-bms7-order-status data-order-id="'.esc_attr((string)absint($order_id)).'"></div>';
},20);
