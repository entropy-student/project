const fs=require('node:fs'),path=require('node:path');
const {chromium}=require('../.tmp/browser-tools/node_modules/playwright-core');
const dir=path.resolve(__dirname,'../../../docs/evidence/g3cr6r3d2r4-hero-focus',process.argv[2]||'round1');
fs.mkdirSync(path.join(dir,'screenshots'),{recursive:true});
const safe=url=>{const u=new URL(url);return u.origin+u.pathname+u.hash;};
let browser;
(async()=>{
 browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 const report={time:new Date().toISOString(),browser:browser.version(),runs:[],blocked:[],previewInteractions:0,businessActions:0};
 for(const [label,width,height] of [['desktop',1440,1000],['mobile',375,812]])for(const mode of ['normal','reduced','no-js','motion-unavailable']){
  const context=await browser.newContext({viewport:{width,height},javaScriptEnabled:mode!=='no-js',reducedMotion:mode==='reduced'?'reduce':'no-preference'});
  await context.route('**/*',route=>{
   const req=route.request(),u=new URL(req.url());
   if(!['GET','HEAD'].includes(req.method())||u.searchParams.has('add-to-cart')||/paypal\./i.test(u.hostname)){report.blocked.push({method:req.method(),url:safe(req.url())});return route.abort();}
   if(mode==='motion-unavailable'&&u.pathname.endsWith('/home-motion.js'))return route.abort();
   return route.continue();
  });
  const page=await context.newPage(),run={label,mode,width,height,errors:[],failures:[],states:[],pointer:[],routes:[]};
  if(label==='desktop'&&mode==='normal'){
   report.nonHeroCss=await page.evaluate(([before,after])=>{
    const project=text=>{const sheet=new CSSStyleSheet();sheet.replaceSync(text);
     const walk=rules=>[...rules].flatMap(rule=>{
      if(rule.selectorText&&/bms-(hero|focus-background|focus-frame|focus-sharp|focus-tag|hero-message)/.test(rule.selectorText))return [];
      if(rule.name&&/^bms-focus-/.test(rule.name))return [];
      if(rule.selectorText)return[rule.cssText];
      if(rule.cssRules){const children=walk(rule.cssRules);return children.length?[{condition:rule.conditionText||rule.name||rule.constructor.name,children}]:[];}
      return[rule.cssText];
     });return walk(sheet.cssRules);
    };const a=project(before),b=project(after);return{equal:JSON.stringify(a)===JSON.stringify(b),baselineRules:a.length,currentRules:b.length};
   },[fs.readFileSync(path.resolve(__dirname,'../artifacts/backups/g3cr6r3d2r4-hero-focus/home.css'),'utf8'),fs.readFileSync(path.resolve(__dirname,'../preview-plugin/home.css'),'utf8')]);
  }
  page.on('pageerror',e=>run.errors.push(e.message.replace(/https?:\/\/\S+/g,'[URL]')));
  page.on('response',r=>{if(r.status()>=400)run.failures.push({status:r.status(),url:safe(r.url())});});
  run.status=(await page.goto('http://127.0.0.1:8189/',{waitUntil:'domcontentloaded',timeout:60000})).status();
  await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.querySelectorAll('.bms-hero img')].map(e=>e.decode().catch(()=>{})));});
  const shot=name=>page.screenshot({path:path.join(dir,'screenshots',`${label}-${mode}-${name}.png`)});
  const probe=()=>page.evaluate(()=>{
   const hero=document.querySelector('.bms-hero'),rect=e=>e?.getBoundingClientRect().toJSON(),css=e=>e?getComputedStyle(e):null;
   const stage=hero.querySelector('.bms-hero-photo-stage'),canvas=hero.querySelector('.bms-hero-focus-canvas'),frame=hero.querySelector('.bms-focus-frame'),copy=hero.querySelector('.bms-hero-message');
   const photos=node=>node?[...node.querySelectorAll('img')].map(e=>({src:e.src.split('?')[0],rect:rect(e),opacity:css(e).opacity,transform:css(e).transform,objectPosition:css(e).objectPosition,animations:e.getAnimations().map(a=>({time:a.currentTime,state:a.playState}))})):[];
   return{time:performance.now(),scrollY,hero:rect(hero),frame:rect(frame),frameTransform:css(frame).transform,
    enhanced:hero.classList.contains('bms-hero-focus-on'),clip:css(canvas)?.clipPath,canvas:rect(canvas),stage:rect(stage),
    backgroundFilter:css(stage)?.filter,windowFilter:css(canvas)?.filter,background:photos(stage),sharp:photos(canvas),
    copy:rect(copy),copyOpacity:css(copy).opacity,cta:rect(copy.querySelector('a')),ctaHref:copy.querySelector('a').getAttribute('href'),
    originalSharpVisibility:css(hero.querySelector('.bms-focus-sharp')).visibility,focusX:hero.style.getPropertyValue('--focus-x'),focusY:hero.style.getPropertyValue('--focus-y'),
    width:innerWidth,scrollWidth:document.documentElement.scrollWidth};
  });
  const health=()=>page.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,pageHeight:document.documentElement.scrollHeight,
   groups:document.querySelectorAll('.entry-content>.wp-block-group').length,anchors:Object.fromEntries(['samples','preview','what-you-get','how-it-works','offer','faq'].map(id=>[id,document.querySelectorAll('#'+id).length])),
   preview:{count:document.querySelectorAll('[data-bms-preview]').length,width:document.querySelector('[data-bms-preview]').getBoundingClientRect().width},
   broken:[...document.images].filter(e=>e.complete&&!e.naturalWidth&&e.getAttribute('src')).map(e=>e.getAttribute('src').split('?')[0])}));
  await page.waitForTimeout(1800);
  if(mode==='normal')await page.waitForSelector('.bms-hero-focus-on',{timeout:15000});
  run.initial=await health();run.default=await probe();await shot('hero-default');
  if(mode==='normal'){
   for(const [name,x,y] of [['left',45,210],['right',width-45,360],['bottom',width-30,600]]){
    await page.mouse.move(x,y);await page.waitForTimeout(600);run.pointer.push({name,...await probe()});await shot('pointer-'+name);
   }
   await page.locator('#header [data-device="'+(label==='desktop'?'desktop':'mobile')+'"] .site-title a').hover();await page.waitForTimeout(650);run.pointerReturn=await probe();await shot('pointer-return');
   for(const [name,from,to] of [['a-clear',500,7500],['a-to-b',9050,9250],['b-clear',11000,12500],['b-to-a',19050,19250],['a-return',500,1500]]){
    await page.waitForFunction(([from,to])=>{const t=Number(document.querySelector('.bms-hero-photo-a').getAnimations()[0].currentTime)%20000;return t>=from&&t<=to;},[from,to],{polling:30,timeout:23000});
    run.states.push({name,...await probe()});await shot(name);
   }
   const cta=page.locator('.bms-hero-message .bms-focus-link a');
   await cta.hover();await page.waitForTimeout(600);await shot('cta-hover');
   await cta.focus();run.focus=await cta.evaluate(e=>({active:document.activeElement===e,outline:getComputedStyle(e).outlineStyle}));await shot('cta-focus');
   if(label==='mobile'){
    await page.locator('#header .ct-header-trigger').click();await page.waitForTimeout(450);run.menuOpen=await page.locator('#header .ct-header-trigger').getAttribute('aria-expanded');await shot('menu-open');
    await page.keyboard.press('Escape');await page.waitForTimeout(300);run.menuClosed=await page.locator('#header .ct-header-trigger').getAttribute('aria-expanded');
   }
   await page.emulateMedia({reducedMotion:'reduce'});await page.waitForTimeout(150);run.liveReduced=await probe();await shot('live-reduced');
   await page.emulateMedia({reducedMotion:'no-preference'});await page.waitForTimeout(150);run.liveRestored=await probe();
   await page.locator('[data-bms-preview]').scrollIntoViewIfNeeded();await page.waitForTimeout(250);run.offscreen=await probe();await shot('preview-frozen');
  }
  // Static proof and one whole-page frame; no photo interaction or commerce mutation.
  await page.evaluate(()=>scrollTo(0,0));await page.waitForTimeout(200);run.final=await health();
  await page.screenshot({path:path.join(dir,'screenshots',`${label}-${mode}-full.png`),fullPage:true});
  if(mode==='normal')for(const [name,url] of [['product','/product/birthday-magazine/'],['cart','/cart/'],['checkout','/checkout/'],['account','/my-account/']]){
   const r=await page.goto('http://127.0.0.1:8189'+url,{waitUntil:'networkidle',timeout:60000});
   run.routes.push({name,status:r.status(),url:safe(page.url()),...await page.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,price:document.querySelector('.summary .price')?.textContent.trim(),motionScriptPresent:[...document.scripts].some(s=>s.src.includes('home-motion')),cartEmpty:!!document.querySelector('.cart-empty'),accountForm:!!document.querySelector('.woocommerce-form-login')}))});await shot(name);
  }
  report.runs.push(run);await context.close();
 }
 await browser.close();fs.writeFileSync(path.join(dir,'browser.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report.runs.map(r=>({label:r.label,mode:r.mode,width:r.final.scrollWidth,errors:r.errors,failures:r.failures}))));
})().catch(async e=>{console.error(e);if(browser)await browser.close();process.exitCode=1;});
