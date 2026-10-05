// Ordinary-cache delivery read-back; no orders, uploads, cache clearing or WP writes.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {chromium}=require('playwright');
const project=path.resolve(__dirname,'../../..'),origin='http://127.0.0.1:8189';
const hash=x=>crypto.createHash('sha256').update(x).digest('hex');
async function run(){
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 const context=await browser.newContext({viewport:{width:2048,height:1152},reducedMotion:'reduce'});
 const page=await context.newPage(),responses=[];
 page.on('response',r=>{if(r.url().includes('/magazine-preview.css'))responses.push(r);});
 await page.goto(origin,{waitUntil:'networkidle'});await page.reload({waitUntil:'networkidle'});await page.evaluate(()=>document.fonts.ready);
 const response=responses.at(-1);assert(response);
 const bytes=await response.body(),source=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin/magazine-preview.css'));
 assert.equal(hash(bytes),hash(source));assert.equal(response.status(),200);
 const tokens=await page.locator('#preview').evaluate(x=>{const h=x.querySelector('.bms-heading'),s=x.querySelector('.bms-heading strong');return{field:getComputedStyle(x).backgroundColor,backgroundImage:getComputedStyle(x).backgroundImage,headingFont:getComputedStyle(h).fontFamily,headingWeight:getComputedStyle(h).fontWeight,emphasis:getComputedStyle(s).color,fontLoaded:document.fonts.check('600 40px "BMS Gift Serif"'),scrollWidth:document.documentElement.scrollWidth,viewport:innerWidth};});
 assert(tokens.backgroundImage.includes('gift-backdrop.png'));assert(tokens.headingFont.includes('BMS Gift Serif'));assert(tokens.fontLoaded);assert.equal(tokens.headingWeight,'600');assert.equal(tokens.emphasis,'rgb(113, 63, 93)');assert(tokens.scrollWidth<=tokens.viewport);
 const assets=[];
 for(const file of ['gift-backdrop.png','PlayfairDisplay.ttf']){
  const r=await context.request.get(origin+'/wp-content/plugins/bms-g3c-preview/assets/preview-gift-20261005/'+file);
  assert.equal(r.status(),200);const b=await r.body(),s=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin/assets/preview-gift-20261005',file));assert.equal(hash(b),hash(s));assets.push({file,status:r.status(),bytes:b.length,sha256:hash(b)});
 }
 const a=page.locator('.bms-preview-local-cta');await a.focus();const focus=await a.evaluate(x=>getComputedStyle(x).outlineStyle);assert.equal(focus,'solid');
 const before=await a.evaluate(x=>getComputedStyle(x).backgroundColor);await a.hover();const hover=await a.evaluate(x=>getComputedStyle(x).backgroundColor);assert.notEqual(before,hover);
 const routes=[];
 for(const route of ['/make-your-magazine/','/product/birthday-magazine/','/cart/','/checkout/','/my-account/']){
  const p=await context.newPage();const r=await p.goto(origin+route,{waitUntil:'networkidle'});routes.push({requested:route,status:r.status(),finalPath:new URL(p.url()).pathname});assert.equal(r.status(),200);await p.close();
 }
 await browser.close();
 const data={browser:browser.version(),ordinaryCache:true,routing:false,cacheCleared:false,bypass:false,cssURL:response.url(),status:response.status(),sourceSHA256:hash(source),deliveredSHA256:hash(bytes),tokens,assets,focusVisible:true,hoverFeedback:true,routes,addToCart:0,checkoutSubmissions:0};
 fs.writeFileSync(path.join(project,'docs/evidence/g3cr7v2r4-preview-gift/delivery.json'),JSON.stringify(data,null,2));console.log(JSON.stringify({ordinaryCacheDelivery:'PASS',font:'PASS',assets:assets.length,routes:routes.length}));
}
run().catch(e=>{console.error(e.message);process.exitCode=1;});
