(function(){
function init(){
 var r=document.querySelector('[data-bms7-surface="intake"]'),f=r&&r.querySelector('form');if(!f)return;
 var pages=[].slice.call(r.querySelectorAll('[data-page]')),inds=[].slice.call(r.querySelectorAll('[data-ind]'));
 var prev=r.querySelector('[data-prev]'),next=r.querySelector('[data-next]'),pay=r.querySelector('[data-pay]'),err=r.querySelector('[data-err]');
 var input=r.querySelector('[data-files]'),grid=r.querySelector('[data-photos]'),count=r.querySelector('[data-count]');
 var photos=[],stars=new Set(),step=0;
 function show(n){
  step=Math.max(0,Math.min(4,n));pages.forEach(function(x,i){x.classList.toggle('on',i===step)});
  inds.forEach(function(x,i){x.classList.toggle('on',i===step);x.classList.toggle('done',i<step)});
  r.querySelector('[data-cur]').textContent=step+1;r.querySelector('[data-bar]').style.width=((step+1)*20)+'%';
  prev.disabled=step===0;next.hidden=step===4;pay.hidden=step!==4;err.textContent='';
  if(step===4)review();window.scrollTo(0,0)
 }
 function valid(){
  if(step===1&&photos.length<12){err.textContent='Add at least 12 photos before continuing.';return false}
  var req=[].slice.call(pages[step].querySelectorAll('[required]'));
  for(var i=0;i<req.length;i++){var x=req[i];if(!String(x.value||'').trim()){err.textContent='Complete the required fields before continuing.';x.focus();return false}}
  err.textContent='';return true
 }
 function render(){
  grid.innerHTML='';
  photos.forEach(function(p,i){
   var c=document.createElement('div');c.className='bms7-photo'+(stars.has(i)?' star':'');
   c.innerHTML='<img alt="Selected photo '+(i+1)+'"><button type="button" class="bms7-star">'+(stars.has(i)?'★ Must':'☆ Must')+'</button><button type="button" class="bms7-remove">×</button>';
   c.querySelector('img').src=p.url;
   c.querySelector('.bms7-star').onclick=function(){if(stars.has(i))stars.delete(i);else if(stars.size<3)stars.add(i);else{err.textContent='You can star up to 3 must-use photos.';return}err.textContent='';render()};
   c.querySelector('.bms7-remove').onclick=function(){URL.revokeObjectURL(p.url);photos.splice(i,1);var ns=new Set();stars.forEach(function(v){if(v<i)ns.add(v);else if(v>i)ns.add(v-1)});stars=ns;render()};
   grid.appendChild(c)
  });count.textContent=photos.length
 }
 input.onchange=function(){
  var a=[].slice.call(input.files||[]).filter(function(x){return ['image/jpeg','image/png','image/webp'].indexOf(x.type)>-1});
  var room=25-photos.length;a.slice(0,room).forEach(function(x){photos.push({file:x,url:URL.createObjectURL(x)})});
  if(a.length>room)err.textContent='Maximum 25 photos. Extra selections were ignored.';input.value='';render()
 };
 function review(){
  r.querySelector('[data-rname]').textContent=f.elements.recipient_name.value.trim()||'—';
  r.querySelector('[data-rcount]').textContent=photos.length;r.querySelector('[data-rstars]').textContent=stars.size
 }
 prev.onclick=function(){show(step-1)};next.onclick=function(){if(valid())show(step+1)};
 pay.onclick=function(e){if(!valid())e.preventDefault()};
 window.addEventListener('pagehide',function(){photos.forEach(function(p){URL.revokeObjectURL(p.url)})});show(0)
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init);else init()
})();