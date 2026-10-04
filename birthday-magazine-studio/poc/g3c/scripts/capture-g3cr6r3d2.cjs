const fs = require('node:fs');
const path = require('node:path');
const {chromium} = require('../.tmp/browser-tools/node_modules/playwright-core');
const dir=path.resolve(__dirname,'../../../docs/evidence/g3cr6r3d2');
const round=process.argv[2]||'round1';
const output=path.join(dir,round);
fs.mkdirSync(path.join(output,'screenshots'),{recursive:true});
const safe = s => {const u=new URL(s);return u.origin+u.pathname+u.hash;};
const base='http://127.0.0.1:8189';
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 const report={time:new Date().toISOString(),browser:browser.version(),round,runs:[],blocked:[],businessActions:0,previewActions:0};
 for(const [label,width,height] of [['desktop',1440,1000],['mobile',375,812]]){
  for(const mode of ['normal','reduced','no-js','motion-unavailable']){
   const context=await browser.newContext({viewport:{width,height},javaScriptEnabled:mode!=='no-js',reducedMotion:mode==='reduced'?'reduce':'no-preference'});
   await context.route('**/*',route=>{
    const req=route.request(),u=new URL(req.url());
    if(!['GET','HEAD'].includes(req.method())||u.searchParams.has('add-to-cart')||/paypal\./i.test(u.hostname)){
     report.blocked.push({method:req.method(),url:safe(req.url())});return route.abort();
    }
    if(mode==='motion-unavailable'&&u.pathname.endsWith('/home-motion.js'))return route.abort();
    return route.continue();
   });
   const page=await context.newPage(),errors=[],failures=[];
   page.on('pageerror',e=>errors.push(e.message.replace(/https?:\/\/\S+/g,'[URL]')));
   page.on('response',r=>{if(r.status()>=400)failures.push({status:r.status(),url:safe(r.url())});});
   const response=await page.goto(base+'/',{waitUntil:'domcontentloaded',timeout:60000});
   const prefix=label+'-'+mode;
   const shot=async name=>page.screenshot({path:path.join(output,'screenshots',prefix+'-'+name+'.png')});
   const probe=()=>page.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,
    groups:[...document.querySelectorAll('.entry-content>.wp-block-group')].map(e=>({class:e.className,id:e.id})),
    anchors:Object.fromEntries(['samples','preview','what-you-get','how-it-works','offer','faq'].map(id=>[id,document.querySelectorAll('#'+id).length])),
    heroCTA:!!document.querySelector('.bms-hero a[href="#preview"]'),previewCount:document.querySelectorAll('[data-bms-preview]').length,
    preview:{width:document.querySelector('[data-bms-preview]')?.getBoundingClientRect().width,layout:getComputedStyle(document.querySelector('.bms-preview-stage')).display,headlineFont:getComputedStyle(document.querySelector('.bms-preview-sheet h3')).fontFamily},
    motionEnabled:document.querySelector('.entry-content').classList.contains('bms-motion-on'),
    font:getComputedStyle(document.querySelector('.bms-hero h1')).fontFamily,
    headings:[...document.querySelectorAll('.bms-heading')].map(e=>({text:e.textContent.trim(),opacity:getComputedStyle(e).opacity,fontSize:getComputedStyle(e).fontSize,width:e.getBoundingClientRect().width})),
    links:[...document.querySelectorAll('.entry-content a')].map(e=>({text:e.textContent.trim(),href:e.getAttribute('href')})),
    brokenImages:[...document.images].filter(e=>e.getAttribute('src')&&e.complete&&!e.naturalWidth).map(e=>e.getAttribute('src').split('?')[0])}));
   const run={label,mode,width,height,status:response.status(),errors,failures,motionStates:[],sections:[],routes:[]};
   run.entranceEarly=await page.evaluate(()=>({time:performance.now(),imageOpacity:getComputedStyle(document.querySelector('.bms-focus-sharp')).opacity,imageFilter:getComputedStyle(document.querySelector('.bms-focus-sharp')).filter,titleTransform:getComputedStyle(document.querySelector('.bms-hero-message')).transform}));
   if(mode==='normal')await shot('entrance-early');
   await page.evaluate(async()=>{await document.fonts.ready;await Promise.race([Promise.all([...document.querySelectorAll('.bms-hero img')].map(e=>e.decode().catch(()=>{}))),new Promise(resolve=>setTimeout(resolve,5000))]);});await page.waitForTimeout(1900);
   run.entranceSettled=await page.evaluate(()=>({time:performance.now(),imageOpacity:getComputedStyle(document.querySelector('.bms-focus-sharp')).opacity,imageFilter:getComputedStyle(document.querySelector('.bms-focus-sharp')).filter,titleTransform:getComputedStyle(document.querySelector('.bms-hero-message')).transform}));
   run.initial=await probe();await shot('hero');
   for(const selector of ['#what-you-get','#preview','#how-it-works','#offer','#faq','#samples','.bms-closing']){
    const node=page.locator(selector);await node.evaluate(e=>scrollTo(0,e.getBoundingClientRect().top+scrollY));await page.waitForTimeout(1050);
    const geom=await node.evaluate(e=>({top:e.getBoundingClientRect().top,height:e.getBoundingClientRect().height,left:e.getBoundingClientRect().left,right:e.getBoundingClientRect().right}));
    run.sections.push({selector,...geom,scrollWidth:await page.evaluate(()=>document.documentElement.scrollWidth)});
    if(mode==='normal'){
     await shot(selector.replace(/^[#.]/,''));
     if(selector==='#preview')await page.locator('[data-bms-preview]').screenshot({path:path.join(output,'screenshots',prefix+'-preview-component.png')});
    }
   }
   if(mode==='normal'){
    const card=page.locator('.bms-focus-card').nth(1);
    const top=await card.evaluate(e=>e.getBoundingClientRect().top+scrollY);
    for(const offset of [height*.8,height*.35,-height*.1]){
     await page.evaluate(y=>scrollTo(0,y),top-offset);await page.waitForTimeout(200);
     run.motionStates.push(await card.evaluate(e=>({scrollY,transform:getComputedStyle(e).transform,tilt:e.style.getPropertyValue('--card-tilt'),scale:e.style.getPropertyValue('--card-scale')})));
     await shot('sample-state-'+run.motionStates.length);
    }
    await page.evaluate(()=>scrollTo(0,0));await page.waitForTimeout(300);
    const cta=page.locator('.bms-hero .bms-focus-link a');
    const state=()=>cta.evaluate(e=>({link:e.getAttribute('href'),label:e.textContent,first:getComputedStyle(e.querySelector('.bms-roll>span')).transform,second:getComputedStyle(e.querySelector('.bms-roll>span+span')).transform}));
    run.hoverBefore=await state();await cta.hover();await page.waitForTimeout(650);run.hoverAfter=await state();await shot('hover');
    await cta.focus();run.focus=await cta.evaluate(e=>({active:document.activeElement===e,outline:getComputedStyle(e).outlineStyle,outlineWidth:getComputedStyle(e).outlineWidth}));await shot('focus');
    if(label==='mobile'){
     const toggle=page.locator('#header .ct-header-trigger');await toggle.click();await page.waitForTimeout(650);
     run.mobileMenu=await page.evaluate(()=>({expanded:document.querySelector('#header .ct-header-trigger')?.getAttribute('aria-expanded'),panelActive:document.querySelector('#offcanvas')?.className,panelRect:document.querySelector('#offcanvas .ct-panel-inner')?.getBoundingClientRect().toJSON(),links:[...document.querySelectorAll('#offcanvas a')].map(e=>({text:e.textContent.trim(),href:e.getAttribute('href')})),scrollWidth:document.documentElement.scrollWidth}));
     await shot('menu-open');await page.keyboard.press('Escape');await page.waitForTimeout(450);run.mobileMenu.closed=await page.locator('#header .ct-header-trigger').getAttribute('aria-expanded');
    }
   }
   await page.evaluate(()=>scrollTo(0,0));await page.mouse.move(width-1,0);await page.waitForTimeout(1200);
   run.final=await probe();await page.screenshot({path:path.join(output,'screenshots',prefix+'-full.png'),fullPage:true});
   if(mode==='normal'){
    for(const [name,url] of [['product','/product/birthday-magazine/'],['cart','/cart/'],['checkout','/checkout/'],['account','/my-account/']]){
     const r=await page.goto(base+url,{waitUntil:'networkidle',timeout:60000});
     run.routes.push({name,status:r.status(),final:safe(page.url()),...await page.evaluate(()=>({width:innerWidth,scrollWidth:document.documentElement.scrollWidth,price:document.querySelector('.summary .price')?.textContent.trim(),motionScriptPresent:[...document.scripts].some(s=>s.src.includes('home-motion')),cartEmpty:!!document.querySelector('.cart-empty'),accountForm:!!document.querySelector('.woocommerce-form-login')}))});
     await page.screenshot({path:path.join(output,'screenshots',prefix+'-'+name+'.png'),fullPage:true});
    }
   }
   report.runs.push(run);await context.close();
  }
 }
 await browser.close();fs.writeFileSync(path.join(output,'browser.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report.runs.map(r=>({label:r.label,mode:r.mode,status:r.status,width:r.final.width,scrollWidth:r.final.scrollWidth,errors:r.errors,failures:r.failures,broken:r.final.brokenImages,preview:r.final.preview,menu:r.mobileMenu,hover:[r.hoverBefore,r.hoverAfter],motion:r.motionStates}))));
})().catch(e=>{console.error(e.message);process.exitCode=1;});
