// Run from repository root. GET-only; no Preview/cart/checkout/account actions.
const fs = require('node:fs');
const path = require('node:path');
const {chromium} = require('../../../poc/g3c/.tmp/browser-tools/node_modules/playwright-core');
const out = __dirname;
const base = 'http://127.0.0.1:8189';
const safeUrl = value => { try {const u = new URL(value); return u.origin + u.pathname + u.hash;} catch {return 'UNPARSEABLE';} };
(async () => {
 const browser = await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 const report = {capturedAt:new Date().toISOString(),browser:browser.version(),viewports:[],blockedRequests:[],actions:{preview:0,addToCart:0,checkoutSubmission:0,accountLogin:0,paypal:0,model:0}};
 for (const [label,width,height] of [['desktop',1440,1000],['mobile',375,812]]) {
  const context = await browser.newContext({viewport:{width,height}});
  await context.route('**/*', async route => {
   const req = route.request(); const u = new URL(req.url());
   if (!['GET','HEAD'].includes(req.method()) || u.searchParams.has('add-to-cart') || /paypal\./i.test(u.hostname)) {
    report.blockedRequests.push({method:req.method(),url:safeUrl(req.url())}); return route.abort();
   }
   return route.continue();
  });
  const page = await context.newPage();
  const errors = []; const failures = [];
  page.on('pageerror', error => errors.push(error.message.replace(/https?:\/\/\S+/g,'[URL]')));
  page.on('response', res => {if(res.status()>=400)failures.push({url:safeUrl(res.url()),status:res.status()});});
  const response = await page.goto(base+'/',{waitUntil:'networkidle',timeout:60000});
  await page.evaluate(async()=>{await document.fonts.ready;});
  // Scroll only to load rendered image regions; never edit any control.
  await page.evaluate(async()=>{for(let y=0;y<document.body.scrollHeight;y+=700){window.scrollTo(0,y);await new Promise(r=>setTimeout(r,80));}window.scrollTo(0,0);});
  await page.waitForTimeout(400);
  await page.screenshot({path:path.join(out,'screenshots',label+'-home-full.png'),fullPage:true});
  await page.screenshot({path:path.join(out,'screenshots',label+'-home-hero.png')});
  await page.locator('#preview').screenshot({path:path.join(out,'screenshots',label+'-preview-presence.png')});
  const home = await page.evaluate(() => ({
   title:document.title,bodyClasses:document.body.className,innerWidth,scrollWidth:document.documentElement.scrollWidth,
   groups:[...document.querySelectorAll('.entry-content > .wp-block-group')].map(e=>({class:e.className,id:e.id,heading:e.querySelector('h1,h2')?.textContent.trim()})),
   anchors:[...document.querySelectorAll('.entry-content [id]')].map(e=>e.id),
   previewCount:document.querySelectorAll('[data-bms-preview]').length,
   previewHasPhoto:document.querySelector('[data-bms-preview]')?.dataset.hasPhoto,
   headerLinks:[...document.querySelectorAll('#header a')].map(e=>({label:e.textContent.trim(),href:e.getAttribute('href')})),
   menuControls:[...document.querySelectorAll('#header button')].map(e=>({label:e.getAttribute('aria-label'),expanded:e.getAttribute('aria-expanded')})),
   ctas:[...document.querySelectorAll('.entry-content a,.bms-brand-footer a')].map(e=>({label:e.textContent.trim(),href:e.getAttribute('href')})),
   brokenImages:[...document.images].filter(e=>!e.hidden&&getComputedStyle(e).display!=='none'&&e.getAttribute('src')&&e.complete&&e.naturalWidth===0).map(e=>({alt:e.alt,url:e.getAttribute('src').split('?')[0]})),
  }));
  const routes = [];
  for(const [name,url] of [['product','/product/birthday-magazine/'],['cart','/cart/'],['checkout','/checkout/'],['account','/my-account/']]) {
   const res=await page.goto(base+url,{waitUntil:'networkidle',timeout:60000});
   const chain=[];for(let r=res.request();r;r=r.redirectedFrom())chain.unshift({url:safeUrl(r.url()),method:r.method()});
   const dom=await page.evaluate(()=>({title:document.title,heading:document.querySelector('h1')?.textContent.trim(),innerWidth,scrollWidth:document.documentElement.scrollWidth,
    price:document.querySelector('.summary .price')?.textContent.trim(),addToCartControlPresent:!!document.querySelector('.single_add_to_cart_button'),
    cartEmpty:!!document.querySelector('.cart-empty'),checkoutFormPresent:!!document.querySelector('form.checkout'),accountLoginPresent:!!document.querySelector('form.woocommerce-form-login')}));
   routes.push({name,requested:base+url,status:res.status(),finalUrl:safeUrl(page.url()),redirectChain:chain,dom});
   await page.screenshot({path:path.join(out,'screenshots',label+'-'+name+'.png'),fullPage:true});
  }
  report.viewports.push({label,width,height,homeStatus:response.status(),home,routes,errors,failedResponses:failures});
  await context.close();
 }
 await browser.close();
 fs.writeFileSync(path.join(out,'browser-readback.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify({home:report.viewports.map(v=>({label:v.label,status:v.homeStatus,width:v.home.innerWidth,scrollWidth:v.home.scrollWidth,groups:v.home.groups.length,preview:v.home.previewCount,routes:v.routes.map(r=>({name:r.name,status:r.status,final:r.finalUrl}))})),blockedRequests:report.blockedRequests}));
})().catch(error=>{console.error(error.message);process.exitCode=1;});
