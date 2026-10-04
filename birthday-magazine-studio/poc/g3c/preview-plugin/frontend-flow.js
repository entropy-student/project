(function(){
function brand(){return '<a class="bms7-brand" href="/"><i>GI</i><span><strong>GOOD ISSUE</strong><small>Birthday Magazine Studio</small></span></a>'}
function home(){
 var u=window.BMS7&&BMS7.create;if(!u)return;
 document.querySelectorAll('.bms-offer .wp-block-button__link').forEach(function(a){a.href=u});
 var p=document.querySelector('.bms-offer .bms-dark-panel');
 if(p&&!p.querySelector('.bms7-entry')){
  var e=document.createElement('div');e.className='bms7-entry';e.setAttribute('aria-label','How it works');
  e.innerHTML='<span><i></i><b>01 · Tell us</b>Photos + a few stories</span><span><i></i><b>02 · Checkout</b>Pay when everything is ready</span><span><i></i><b>03 · Receive</b>Your 12-page issue</span>';
  var b=p.querySelector('.wp-block-buttons');b?p.insertBefore(e,b):p.appendChild(e)
 }
}
function statusCard(id,ready){
 return '<section class="bms7-status-card"><div class="bms7-art"><div class="bms7-mag">GOOD<br>ISSUE</div></div><div class="bms7-copy"><p class="bms7-k">'+(ready?'YOUR ISSUE IS READY':'WE HAVE EVERYTHING WE NEED')+'</p><h1>'+(ready?'Their birthday issue is ready.':'We’re making their birthday issue.')+'</h1><p>'+(ready?'The complete magazine is ready for your private review.':'Payment is confirmed. The order is now moving through the generation pipeline.')+'</p>'+(id?'<p><b>Order #'+id+'</b></p>':'')+'<ol class="bms7-pipe"><li class="done"><span>✓</span><div><strong>Intake received</strong><small>Photos and stories are together.</small></div></li><li class="done"><span>✓</span><div><strong>Payment confirmed</strong><small>Generation is unlocked.</small></div></li><li class="'+(ready?'done':'live')+'"><span>'+(ready?'✓':'3')+'</span><div><strong>Designing the issue</strong><small>Writing, selecting and composing.</small></div></li><li class="'+(ready?'done':'')+'"><span>'+(ready?'✓':'4')+'</span><div><strong>Final quality check</strong><small>Names, images and layout.</small></div></li><li class="'+(ready?'live':'')+'"><span>5</span><div><strong>Ready to review</strong><small>The complete issue appears in your private viewer.</small></div></li></ol>'+(ready?'<a class="bms7-btn" href="/my-account/orders/">Open my magazine <span>→</span></a>':'<div class="bms7-status-foot"><i class="bms7-dot"></i><span>Generation status shell · production worker is not enabled in this Gate</span></div>')+'</div></section>'
}
function status(){
 var root=document.querySelector('[data-bms7-surface="status"]');
 if(root){
  var q=new URLSearchParams(location.search),ready=q.get('state')==='ready',id=q.get('order_id')||'';
  root.innerHTML='<div class="bms7-status-wrap"><header class="bms7-status-head">'+brand()+'</header><div class="bms7-status-main">'+statusCard(id,ready)+'</div></div>'
 }
 document.querySelectorAll('[data-bms7-order-status]').forEach(function(el){el.innerHTML=statusCard(el.dataset.orderId||'',false)})
}
document.addEventListener('DOMContentLoaded',function(){home();status()})
})();