const fs = require('fs');
const path = require('path');
const assert = require('assert/strict');
const crypto = require('crypto');
const { chromium } = require('../.tmp/browser-tools/node_modules/playwright-core');
const base = path.resolve(__dirname, '..');
const shots = path.join(base, 'artifacts/screenshots/g3cr6');
const origin = 'http://127.0.0.1:8189';
const sample = path.join(base, 'theme-overrides/g3cr6/synthetic-preview-portrait.png');
const secondSample = path.join(base, 'preview-plugin/assets/g3cr6/sample-cover.png');
fs.mkdirSync(shots, {recursive:true});
const report = {gate:'G3CR6_FRONTEND_EXPERIENCE_BRAND_REDESIGN', errors:[], pages:[], preview:[], network:[], checkoutSubmitted:false};
let watch = false;
async function open(page, route) {
 const r = await page.goto(origin+route,{waitUntil:'domcontentloaded'});
 assert.equal(r.status(),200,route);
 await page.waitForLoadState('networkidle',{timeout:12000}).catch(()=>{});
 // Load all images before full-page captures, including images below the fold.
 await page.evaluate(async()=>{document.querySelectorAll('img').forEach(i=>{i.loading='eager';}); await document.fonts.ready; await Promise.all([...document.images].map(i=>i.decode().catch(()=>{})));});
}
async function shot(page, name, selector) {
 const target=selector ? page.locator(selector).first() : page;
 await target.screenshot({path:path.join(shots,name), ...(selector ? {} : {fullPage:true}), animations:'disabled'});
}
async function geometry(page,kind) {
 const g=await page.evaluate(()=>({width:document.documentElement.scrollWidth,viewport:innerWidth,brokenImages:[...document.images].filter(i=>i.getAttribute('src')&&!i.hidden&&(!i.complete||!i.naturalWidth)).length}));
 assert.ok(g.width<=g.viewport,`${kind} overflow ${JSON.stringify(g)}`);
 assert.equal(g.brokenImages,0,`${kind} broken image`);
 report.pages.push({kind,...g});
}
async function preview(page,label) {
 watch=true;
 const start=report.network.length;
 await page.locator('[data-bms-input="name"]').fill('Morgan');
 await page.locator('[data-bms-input="age"]').fill('42');
 await page.locator('[data-bms-input="style"]').selectOption('romantic');
 assert.equal(await page.locator('[data-bms-name]').innerText(),'Morgan');
 assert.match(await page.locator('[data-bms-age]').innerText(),/42/);
 assert.equal(await page.locator('[data-bms-preview]').getAttribute('data-style'),'romantic');
 await page.locator('[data-bms-file]').setInputFiles(sample);
 await page.waitForFunction(()=>[...document.querySelectorAll('[data-bms-image]')].every(i=>!i.hidden&&i.src.startsWith('blob:')&&i.naturalWidth>0));
 const first=await page.locator('[data-bms-image]').first().getAttribute('src');
 const check=await page.evaluate(()=>{
  const root=document.querySelector('[data-bms-preview]');
  const cover=root.querySelector('.bms-mini-cover');
  const frame=root.querySelector('.bms-cover-photo-frame');
  const title=root.querySelector('.bms-cover-headlines');
  const photo=root.querySelector('.bms-spread-photo-frame');
  const copy=root.querySelector('.bms-photo-copy');
  return {coverFrameSeparate:frame.offsetTop+frame.offsetHeight<=title.offsetTop+1,spreadFrameSeparate:photo.offsetTop+photo.offsetHeight<=copy.offsetTop+1,blobImages:[...root.querySelectorAll('[data-bms-image]')].every(i=>i.src.startsWith('blob:')),width:root.scrollWidth,clientWidth:root.clientWidth,workbenchColumns:getComputedStyle(root.querySelector('.bms-workbench')).gridTemplateColumns,coverTextContained:cover.scrollHeight<=cover.clientHeight+1,coverPhotoFit:getComputedStyle(root.querySelector('.bms-cover-photo')).objectFit};
 });
 assert.ok(check.coverFrameSeparate&&check.spreadFrameSeparate&&check.blobImages&&check.coverTextContained,JSON.stringify(check));
 assert.ok(check.width<=check.clientWidth+1);
 await shot(page,label==='desktop'?'05-desktop-preview-photo.png':'10-mobile-preview-photo-375.png','.g3cr4-preview');
 await page.locator('[data-bms-file]').setInputFiles(secondSample);
 await page.waitForFunction(old=>document.querySelector('[data-bms-image]').src!==old&&!document.querySelector('[data-bms-image]').hidden,first);
 assert.equal(await page.evaluate(async old=>{try{await fetch(old);return false;}catch{return true;}},first),true,'old blob revoked');
 await page.locator('[data-bms-remove]').click();
 assert.equal(await page.locator('[data-bms-image]').first().isVisible(),false);
 await page.locator('[data-bms-file]').setInputFiles({name:'invalid.txt',mimeType:'text/plain',buffer:Buffer.from('synthetic')});
 assert.match(await page.locator('[data-bms-status]').innerText(),/JPG/);
 await page.locator('[data-bms-file]').setInputFiles({name:'corrupt.png',mimeType:'image/png',buffer:Buffer.from('not an image')});
 await page.waitForFunction(()=>document.querySelector('[data-bms-status]').textContent.includes('could not be opened'));
 assert.equal(await page.locator('[data-bms-image]').first().isVisible(),false);
 await page.locator('[data-bms-input="style"]').selectOption('retro');
 assert.equal(await page.locator('[data-bms-preview]').getAttribute('data-style'),'retro');
 const requests=report.network.slice(start);
 assert.ok(requests.every(r=>r.scheme==='blob'||(r.origin===origin&&r.method==='GET'&&['script','stylesheet'].includes(r.resourceType))),JSON.stringify(requests));
 report.preview.push({viewport:label,...check,select:true,replace:true,remove:true,invalidTypeRejected:true,corruptImageRejected:true,revokedOldBlob:true,nameAgeStyleUpdates:true,localStaticGetRequests:requests.filter(r=>r.scheme==='http').length,photoUploadRequests:0,externalImageRequests:0,modelRequests:0});
 watch=false;
}
async function add(page) {
 const pending=page.waitForResponse(r=>r.request().method()==='POST'&&new URL(r.url()).pathname==='/product/birthday-magazine/');
 await page.locator('button.single_add_to_cart_button').click();
 const r=await pending; const data=await r.json();assert.equal(data.success,true);return {status:r.status(),success:true};
}
async function main() {
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 const context=await browser.newContext({viewport:{width:1440,height:1000}});
 const page=await context.newPage();
 page.on('pageerror',e=>report.errors.push(String(e)));
 page.on('request',r=>{if(watch){const blob=r.url().startsWith('blob:'); const url=new URL(r.url());report.network.push({method:r.method(),scheme:blob?'blob':url.protocol.replace(':',''),origin:blob?'browser-local':url.origin,path:blob?'<local-object-url>':url.pathname,resourceType:r.resourceType()});}});
 page.on('response',r=>{if(r.status()===404) report.errors.push('404 '+new URL(r.url()).pathname);});
 await open(page,'/');
 assert.ok(await page.evaluate(()=>document.querySelector('h1').getBoundingClientRect().top>=document.querySelector('#header .ct-container').getBoundingClientRect().bottom),'desktop hero under header');
 await geometry(page,'desktop-home');
 assert.equal(await page.locator('.g3cr4-section').count(),6);
 await shot(page,'01-desktop-home.png');
 await shot(page,'02-desktop-hero.png','.g3cr4-hero');
 await shot(page,'03-desktop-samples.png','.g3cr4-samples');
 await shot(page,'04-desktop-preview-empty.png','.g3cr4-preview');
 await shot(page,'06-desktop-offer-faq.png','.g3cr4-offer-faq');
 await preview(page,'desktop');
 await page.setViewportSize({width:375,height:812});
 await open(page,'/');await geometry(page,'mobile-home');
 assert.ok(await page.evaluate(()=>document.querySelector('h1').getBoundingClientRect().top>=document.querySelector('#header [data-device="mobile"] .ct-container').getBoundingClientRect().bottom),'mobile hero under header');
 await shot(page,'07-mobile-home-375.png');
 await shot(page,'08-mobile-hero-375.png','.g3cr4-hero');
 await shot(page,'09-mobile-preview-empty-375.png','.g3cr4-preview');
 await shot(page,'11-mobile-offer-faq-375.png','.g3cr4-offer-faq');
 await preview(page,'mobile375');
 await page.setViewportSize({width:1440,height:1000});
 await open(page,'/product/birthday-magazine/');
 assert.match(await page.locator('.summary .price').innerText(),/39\.99/);
 report.nativeAddToCart=await add(page);
 const routes=[['product','/product/birthday-magazine/'],['cart','/cart/'],['checkout','/checkout/'],['account','/my-account/']];
 let n=12;
 for(const [kind,route] of routes){
  for(const width of [1440,375]){
   await page.setViewportSize({width,height:width===375?812:1000});await open(page,route);await geometry(page,kind+'-'+width);
   const selector={product:'.single_add_to_cart_button',cart:'.checkout-button',checkout:'#place_order',account:'.woocommerce-form-login button[type=submit]'}[kind];
   const box=await page.locator(selector).boundingBox();assert.ok(box&&box.width>0&&box.x>=0&&box.x+box.width<=width);
   if(kind==='checkout')assert.equal(await page.locator('form.checkout').count(),1);
   if(kind==='account')assert.equal(await page.locator('form.woocommerce-form-login').count(),1);
   await shot(page,`${String(n++).padStart(2,'0')}-${width===375?'mobile':'desktop'}-${kind}${width===375?'-375':''}.png`);
  }
 }
 await page.setViewportSize({width:1440,height:1000}); await open(page,'/cart/');
 await page.locator('.cart_item input.qty:visible').fill('2');
 await page.locator('button[name=update_cart]:visible').click();
 await page.waitForTimeout(1500); await open(page,'/cart/');
 assert.equal(await page.locator('.cart_item input.qty:visible').inputValue(),'2');
 assert.match(await page.locator('.cart_totals').innerText(),/79\.98/);
 await page.locator('.cart_item a.remove:visible').click();await page.waitForTimeout(1000);await open(page,'/cart/');
 assert.equal(await page.locator('.cart_item').count(),0);
 report.cartQuantityUpdate=true;report.cartRemove=true;
 const denied=await page.goto(origin+'/birthday-workspace/1131/');assert.equal(denied.status(),403);report.guestWorkspaceHttpStatus=403;
 report.screenshots=fs.readdirSync(shots).filter(n=>n.endsWith('.png')).map(name=>{const bytes=fs.readFileSync(path.join(shots,name));return {name,sizeBytes:bytes.length,sha256:crypto.createHash('sha256').update(bytes).digest('hex')};});
 assert.equal(report.screenshots.length,19);
 assert.equal(report.errors.length,0);
 fs.writeFileSync(path.join(base,'artifacts/reports/g3cr6-browser.json'),JSON.stringify(report,null,2)+'\n');
 await browser.close();
 console.log(JSON.stringify({screenshots:report.screenshots.length,preview:report.preview,pages:report.pages,cartUpdate:report.cartQuantityUpdate,cartRemove:report.cartRemove,errors:report.errors},null,2));
}
main().catch(e=>{console.error(e);process.exit(1);});
