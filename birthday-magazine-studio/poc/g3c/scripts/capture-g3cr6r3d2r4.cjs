const fs=require('node:fs'),path=require('node:path');
const {chromium}=require('../.tmp/browser-tools/node_modules/playwright-core');
const dir=path.resolve(__dirname,'../../../docs/evidence/g3cr6r3d2r4',process.argv[2]||'round1');
fs.mkdirSync(path.join(dir,'screenshots'),{recursive:true});
const safe=s=>{const u=new URL(s);return u.origin+u.pathname+u.hash;};
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 const report={time:new Date().toISOString(),browser:browser.version(),runs:[],blocked:[],previewInteractions:0,businessActions:0};
 for(const [label,width,height] of [['desktop',1440,1000],['mobile',375,812]])for(const mode of ['normal','reduced','no-js','motion-unavailable']){
  const context=await browser.newContext({viewport:{width,height},javaScriptEnabled:mode!=='no-js',reducedMotion:mode==='reduced'?'reduce':'no-preference'});
  await context.route('**/*',route=>{
   const req=route.request(),u=new URL(req.url());
   if(!['GET','HEAD'].includes(req.method())||u.searchParams.has('add-to-cart')||/paypal\./i.test(u.hostname)){report.blocked.push({method:req.method(),url:safe(req.url())});return route.abort();}
   if(mode==='motion-unavailable'&&u.pathname.endsWith('/home-motion.js'))return route.abort();
   return route.continue();
  });
  const page=await context.newPage(),run={label,mode,width,height,errors:[],failures:[],hero:[],splits:[],panels:[],cards:[],closing:[],routes:[]};
  page.on('pageerror',e=>run.errors.push(e.message.replace(/https?:\/\/\S+/g,'[URL]')));
  page.on('response',r=>{if(r.status()>=400)run.failures.push({status:r.status(),url:safe(r.url())});});
  run.status=(await page.goto('http://127.0.0.1:8189/',{waitUntil:'domcontentloaded',timeout:60000})).status();
  await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.querySelectorAll('.bms-hero img')].map(e=>e.decode().catch(()=>{})));});
  const shot=name=>page.screenshot({path:path.join(dir,'screenshots',`${label}-${mode}-${name}.png`)});
  const probe=selector=>page.locator(selector).evaluate(e=>{
   const css=getComputedStyle(e),r=e.getBoundingClientRect();
   let top=0;for(let n=e;n;n=n.offsetParent)top+=n.offsetTop;
   return {scrollY,time:performance.now(),layoutTop:top,layoutHeight:e.offsetHeight,rect:r.toJSON(),transform:css.transform,filter:css.filter,opacity:css.opacity,position:css.position,animation:css.animationName,playState:css.animationPlayState,vars:Object.fromEntries([...e.style].filter(k=>k.startsWith('--')).map(k=>[k,e.style.getPropertyValue(k)])),width:innerWidth,scrollWidth:document.documentElement.scrollWidth};
  });
  const scroll=async y=>{await page.evaluate(y=>scrollTo(0,y),y);await page.waitForTimeout(220);};
  const geometry=async selector=>{let loc=page.locator(selector);return loc.evaluate(e=>{let top=0;for(let n=e;n;n=n.offsetParent)top+=n.offsetTop;return {top,height:e.offsetHeight};});};
  const health=()=>page.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,pageHeight:document.documentElement.scrollHeight,motion:document.querySelector('.entry-content').classList.contains('bms-motion-on'),groups:document.querySelectorAll('.entry-content>.wp-block-group').length,anchors:Object.fromEntries(['samples','preview','what-you-get','how-it-works','offer','faq'].map(id=>[id,document.querySelectorAll('#'+id).length])),preview:{count:document.querySelectorAll('[data-bms-preview]').length,width:document.querySelector('[data-bms-preview]').getBoundingClientRect().width},heroCTA:!!document.querySelector('.bms-hero a[href="#preview"]'),broken:[...document.images].filter(e=>e.complete&&!e.naturalWidth&&e.getAttribute('src')).map(e=>e.getAttribute('src').split('?')[0]),sticky:!!document.querySelector('.bms-closing-sticky'),headings:[...document.querySelectorAll('.bms-heading')].map(e=>({text:e.textContent.trim(),opacity:getComputedStyle(e).opacity}))}));
  await page.waitForTimeout(2000);
  run.initial=await health();
  for(let i=0;i<(mode==='normal'?3:1);i++){
   if(i)await page.waitForTimeout(3300);
   run.hero.push({background:await probe('.bms-focus-background'),sharp:await probe('.bms-focus-sharp img'),message:await probe('.bms-hero-message')});await shot('hero-'+i);
  }
  if(mode==='normal'){
   for(const selector of ['#what-you-get','#how-it-works']){
    const g=await geometry(selector),states=[];
    for(const [name,p] of [['enter',.18],['mid',.5],['exit',.82]]){
     await scroll(g.top-height+p*(height+g.height));
     states.push({name,container:await probe(selector),image:await probe(selector+' .bms-focus-visual img'),copy:await probe(selector+' .bms-focus-copy')});
     await shot(selector.slice(1)+'-'+name);
    }
    run.splits.push({selector,states});
   }
   for(const selector of ['#preview .bms-focus-photo-panel','#offer']){
    const g=await geometry(selector),states=[];
    for(const [name,p] of [['enter',.2],['mid',.5],['exit',.8]]){
     await scroll(g.top-height+p*(height+g.height));states.push({name,panel:await probe(selector),image:await probe(selector+' .bms-panel-background img')});await shot((selector.startsWith('#preview')?'preview-panel':'offer-panel')+'-'+name);
    }
    run.panels.push({selector,states});
   }
   for(let i=0;i<3;i++){
    const selector=`.bms-focus-card:nth-of-type(${i+1})`;
    // Gutenberg direct group cards have the same tag as their section, no wrapper mutation.
    const loc=page.locator('.bms-focus-card').nth(i);
    const g=await loc.evaluate(e=>{let top=0;for(let n=e;n;n=n.offsetParent)top+=n.offsetTop;return {top,height:e.offsetHeight};}),states=[];
    for(const [name,p] of [['enter',.2],['mid',.5],['exit',.8]]){
     await scroll(g.top-height+p*(height+g.height));
     states.push({name,...await probe(selector)});await shot(`sample-${i+1}-${name}`);
    }
    run.cards.push(states);
   }
   const g=await geometry('.bms-closing');
   for(const [name,p] of [['early',.05],['mid',.5],['late',.95]]){
    await scroll(label==='desktop'?g.top+p*(g.height-height):g.top-100);
    run.closing.push({name,outer:await probe('.bms-closing'),inner:label==='desktop'?await probe('.bms-closing-sticky'):null,heading:await probe('.bms-closing .bms-heading'),left:await probe('.bms-closing-photo-left'),right:await probe('.bms-closing-photo-right'),cta:await probe('.bms-closing .bms-focus-link a')});await shot('closing-'+name);
   }
   run.heroPausedOffscreen=await probe('.bms-focus-background');
   await scroll(0);
   const cta=page.locator('.bms-hero .bms-focus-link a'),state=()=>cta.evaluate(e=>({href:e.getAttribute('href'),first:getComputedStyle(e.querySelector('.bms-roll>span')).transform,second:getComputedStyle(e.querySelector('.bms-roll>span+span')).transform}));
   run.hoverBefore=await state();await cta.hover();await page.waitForTimeout(650);run.hoverAfter=await state();await shot('hover');
   await cta.focus();run.focus=await cta.evaluate(e=>({active:document.activeElement===e,outline:getComputedStyle(e).outlineStyle}));await shot('focus');
   if(label==='mobile'){
    await page.locator('#header .ct-header-trigger').click();await page.waitForTimeout(650);run.menuOpen=await page.locator('#header .ct-header-trigger').getAttribute('aria-expanded');await shot('menu-open');await page.keyboard.press('Escape');await page.waitForTimeout(350);run.menuClosed=await page.locator('#header .ct-header-trigger').getAttribute('aria-expanded');
   }
   // Preference changes must restore ordinary layout, then recreate desktop sticky safely.
   await page.emulateMedia({reducedMotion:'reduce'});await page.waitForTimeout(150);run.preferenceReduced=await health();
   await page.emulateMedia({reducedMotion:'no-preference'});await page.waitForTimeout(150);run.preferenceRestored=await health();
  }
  for(const [name,selector] of [['preview-component','[data-bms-preview]'],['closing-static','.bms-closing']]){
   const g=await geometry(selector);await scroll(g.top);await shot(name);
  }
  await scroll(0);run.final=await health();await page.screenshot({path:path.join(dir,'screenshots',`${label}-${mode}-full.png`),fullPage:true});
  if(mode==='normal')for(const [name,url] of [['product','/product/birthday-magazine/'],['cart','/cart/'],['checkout','/checkout/'],['account','/my-account/']]){
   const r=await page.goto('http://127.0.0.1:8189'+url,{waitUntil:'networkidle',timeout:60000});run.routes.push({name,status:r.status(),final:safe(page.url()),...await page.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,price:document.querySelector('.summary .price')?.textContent.trim(),motionScriptPresent:[...document.scripts].some(s=>s.src.includes('home-motion')),cartEmpty:!!document.querySelector('.cart-empty'),accountForm:!!document.querySelector('.woocommerce-form-login')}))});await shot(name);
  }
  report.runs.push(run);await context.close();
 }
 await browser.close();fs.writeFileSync(path.join(dir,'browser.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report.runs.map(r=>({label:r.label,mode:r.mode,width:r.final.scrollWidth,sticky:r.final.sticky,errors:r.errors,failures:r.failures}))));
})().catch(e=>{console.error(e);process.exitCode=1;});
