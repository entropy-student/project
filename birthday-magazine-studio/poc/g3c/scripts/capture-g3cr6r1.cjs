const fs = require('fs');
const path = require('path');
const assert = require('assert/strict');
const crypto = require('crypto');
const {spawnSync} = require('child_process');
const {chromium} = require('../.tmp/browser-tools/node_modules/playwright-core');
const base = path.resolve(__dirname, '..');
const shots = path.join(base, 'artifacts/screenshots/g3cr6r1');
const origin = 'http://127.0.0.1:8189';
const report = {gate:'G3CR6R1_FRONTEND_COMPOSITION_REDESIGN',errors:[],pages:[],preview:[],network:[],checkoutSubmitted:false};
let watch = false;
const sha = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
function readback() {
 const r=spawnSync('docker',['exec','-i','birthday-magazine-g3c-wordpress-1','php'],{input:fs.readFileSync(path.join(__dirname,'readback-g3cr6r1.php')),encoding:'utf8'});
 assert.equal(r.status,0,r.stderr); return JSON.parse(r.stdout);
}
async function open(page,route) {
 const r=await page.goto(origin+route,{waitUntil:'networkidle'});assert.equal(r.status(),200,route);
 await page.evaluate(async()=>{document.querySelectorAll('img').forEach(i=>i.loading='eager');await document.fonts.ready;await Promise.all([...document.images].map(i=>i.decode().catch(()=>{})));});
}
async function shot(page,name,selector) {
 await (selector?page.locator(selector).first():page).screenshot({path:path.join(shots,name),...(selector?{}:{fullPage:true}),animations:'disabled'});
}
async function region(page,name,first,last) {
 const clip=await page.evaluate(([a,b])=>{
  const start=document.querySelector(a).getBoundingClientRect();
  const end=document.querySelector(b).getBoundingClientRect();
  return {x:0,y:Math.max(0,start.top+scrollY),width:innerWidth,height:Math.ceil(end.bottom-start.top)};
 },[first,last]);
 await page.screenshot({path:path.join(shots,name),fullPage:true,clip,animations:'disabled'});
}
async function geometry(page,kind) {
 const g=await page.evaluate(()=>({width:document.documentElement.scrollWidth,viewport:innerWidth,brokenImages:[...document.images].filter(i=>i.getAttribute('src')&&!i.hidden&&(!i.complete||!i.naturalWidth)).length}));
 assert.ok(g.width<=g.viewport,kind+' overflow '+JSON.stringify(g));assert.equal(g.brokenImages,0,kind+' broken image');report.pages.push({kind,...g});
}
async function preview(page,label) {
 watch=true; const start=report.network.length;
 await page.locator('[data-bms-input="name"]').fill('Morgan');
 await page.locator('[data-bms-input="age"]').fill('42');
 await page.locator('[data-bms-input="style"]').selectOption('romantic');
 assert.equal(await page.locator('[data-bms-name]').innerText(),'Morgan');
 assert.match(await page.locator('[data-bms-age]').innerText(),/42/);
 await page.locator('[data-bms-file]').setInputFiles(path.join(base,'theme-overrides/g3cr6/synthetic-preview-portrait.png'));
 await page.waitForFunction(()=>[...document.querySelectorAll('[data-bms-image]')].every(i=>!i.hidden&&i.src.startsWith('blob:')&&i.naturalWidth>0));
 const first=await page.locator('[data-bms-image]').first().getAttribute('src');
 const check=await page.evaluate(()=>{
  const root=document.querySelector('[data-bms-preview]');
  const spread=root.querySelector('.bms-preview-spread');
  return {spreadContentContained:spread.scrollHeight<=spread.clientHeight+1,blobImages:[...root.querySelectorAll('[data-bms-image]')].every(i=>i.src.startsWith('blob:')),width:root.scrollWidth,clientWidth:root.clientWidth,photoFit:getComputedStyle(root.querySelector('[data-bms-image]')).objectFit};
 });
 // Compare untransformed local offsets: rotated magazines have overlapping bounding rectangles.
 const local=await page.evaluate(()=>{
  const r=document.querySelector('[data-bms-preview]'),f=r.querySelector('.bms-cover-photo-frame'),t=r.querySelector('.bms-cover-headlines'),p=r.querySelector('.bms-spread-photo-frame'),c=r.querySelector('.bms-photo-copy');
  return {cover:f.offsetTop+f.offsetHeight<=t.offsetTop+1,spread:p.offsetTop+p.offsetHeight<=c.offsetTop+1};
 });
 assert.ok(local.cover&&local.spread&&check.blobImages&&check.spreadContentContained,JSON.stringify({check,local}));
 assert.ok(check.width<=check.clientWidth+1);
 await shot(page,label==='desktop'?'05-desktop-preview-photo.png':'12-mobile-preview-photo-375.png','.bms-preview-chapter');
 await page.locator('[data-bms-file]').setInputFiles(path.join(base,'preview-plugin/assets/g3cr6/sample-cover.png'));
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
 report.preview.push({viewport:label,...check,localOffsets:local,select:true,replace:true,remove:true,invalidTypeRejected:true,corruptImageRejected:true,revokedOldBlob:true,nameAgeStyleUpdates:true,photoUploadRequests:0,externalImagePosts:0,modelRequests:0});
 watch=false;
}
async function main() {
 fs.mkdirSync(shots,{recursive:true});
 const before=readback();report.runtimeBefore=before;
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 try {
 const context=await browser.newContext({viewport:{width:1440,height:1000}});
 const page=await context.newPage();
 page.on('pageerror',e=>report.errors.push(String(e)));
 page.on('request',r=>{if(watch){const u=new URL(r.url());report.network.push({method:r.method(),scheme:u.protocol.replace(':',''),origin:u.protocol==='blob:'?'browser-local':u.origin,path:u.protocol==='blob:'?'<local-object-url>':u.pathname,resourceType:r.resourceType()});}});
 page.on('response',r=>{if(r.status()===404)report.errors.push('404 '+new URL(r.url()).pathname);});
 await open(page,'/');await geometry(page,'desktop-home');
 const palette=await page.evaluate(()=>({coral:getComputedStyle(document.documentElement).getPropertyValue('--theme-palette-color-1').trim(),preview:getComputedStyle(document.querySelector('.bms-preview-chapter')).backgroundColor,hero:getComputedStyle(document.querySelector('.bms-hero')).backgroundColor}));
 assert.equal(palette.coral,'#c74e39');assert.equal(palette.preview,'rgb(239, 216, 206)');assert.equal(palette.hero,'rgb(255, 249, 242)');report.palette=palette;
 assert.ok(await page.evaluate(()=>document.querySelector('h1').getBoundingClientRect().top>=document.querySelector('#header').getBoundingClientRect().bottom));
 assert.equal(await page.locator('#what-you-get').count(),1);
 assert.equal(await page.locator('.g3cr4-section').count(),0);
 assert.equal(await page.locator('.entry-content>.wp-block-group').count(),8);
 assert.equal(await page.locator('body').innerText().then(t=>t.includes('CreativeThemes')),false);
 await shot(page,'01-desktop-full-home.png');
 await shot(page,'02-desktop-hero.png','.bms-hero');
 await shot(page,'03-desktop-samples.png','.bms-samples');
 await shot(page,'04-desktop-preview-empty.png','.bms-preview-chapter');
 await region(page,'06-desktop-included-how.png','.bms-included','.bms-how');
 await region(page,'07-desktop-offer-faq-footer.png','.bms-offer','#footer');
 await preview(page,'desktop');
 await page.setViewportSize({width:375,height:812});await open(page,'/');await geometry(page,'mobile-home-375');
 assert.ok(await page.evaluate(()=>document.querySelector('h1').getBoundingClientRect().top>=document.querySelector('#header').getBoundingClientRect().bottom));
 await shot(page,'08-mobile-full-home-375.png');
 await shot(page,'09-mobile-hero-375.png','.bms-hero');
 await shot(page,'10-mobile-samples-375.png','.bms-samples');
 await shot(page,'11-mobile-preview-empty-375.png','.bms-preview-chapter');
 await region(page,'13-mobile-offer-footer-375.png','.bms-offer','#footer');
 await preview(page,'mobile375');
 await page.setViewportSize({width:1440,height:1000});await open(page,'/product/birthday-magazine/');
 assert.match(await page.locator('.summary .price').innerText(),/39\.99/);
 const pending=page.waitForResponse(r=>r.request().method()==='POST'&&new URL(r.url()).pathname==='/product/birthday-magazine/');
 await page.locator('button.single_add_to_cart_button').click();
 const added=await pending; assert.equal((await added.json()).success,true);
 report.nativeAddToCart={status:added.status(),success:true};
 let n=14;
 for(const [kind,route] of [['product','/product/birthday-magazine/'],['cart','/cart/'],['checkout','/checkout/'],['account','/my-account/']]) {
  for(const width of [1440,375]) {
   await page.setViewportSize({width,height:width===375?812:1000});await open(page,route);await geometry(page,kind+'-'+width);
   const selector={product:'.single_add_to_cart_button',cart:'.checkout-button',checkout:'#place_order',account:'.woocommerce-form-login button[type=submit]'}[kind];
   const box=await page.locator(selector).boundingBox();assert.ok(box&&box.x>=0&&box.x+box.width<=width,kind+' native button');
   if(kind==='checkout')assert.equal(await page.locator('form.checkout').count(),1);
   if(kind==='account')assert.equal(await page.locator('form.woocommerce-form-login').count(),1);
   await shot(page,String(n++).padStart(2,'0')+'-'+(width===375?'mobile':'desktop')+'-'+kind+(width===375?'-375':'')+'.png');
  }
 }
 await page.setViewportSize({width:1440,height:1000});await open(page,'/cart/');
 await page.locator('.cart_item input.qty:visible').fill('2');
 await page.locator('button[name=update_cart]:visible').click();
 await page.waitForTimeout(1200);await open(page,'/cart/');
 assert.equal(await page.locator('.cart_item input.qty:visible').inputValue(),'2');
 assert.match(await page.locator('.cart_totals').innerText(),/79\.98/);
 await page.locator('.cart_item a.remove:visible').click();
 await page.waitForTimeout(1000);await open(page,'/cart/');assert.equal(await page.locator('.cart_item').count(),0);
 report.cartQuantityUpdate=true;report.cartRemove=true;
 const denied=await page.goto(origin+'/birthday-workspace/1131/');assert.equal(denied.status(),403);report.guestWorkspaceHttpStatus=403;
 report.runtimeAfter=readback();assert.equal(report.runtimeAfter.order_count,before.order_count);
 assert.deepEqual(report.runtimeAfter.protected_runtime_hashes,before.protected_runtime_hashes);
 report.screenshots=fs.readdirSync(shots).filter(n=>n.endsWith('.png')).map(name=>{const bytes=fs.readFileSync(path.join(shots,name));return {name,sizeBytes:bytes.length,sha256:sha(bytes)};});
 assert.equal(report.screenshots.length,21);assert.equal(report.errors.length,0,JSON.stringify(report.errors));
 fs.writeFileSync(path.join(base,'artifacts/reports/g3cr6r1-browser.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify({screenshots:21,pages:report.pages,preview:report.preview,orderBefore:before.order_count,orderAfter:report.runtimeAfter.order_count,errors:report.errors},null,2));
 } finally { await browser.close(); }
}
main().catch(e=>{console.error(e);process.exit(1);});
