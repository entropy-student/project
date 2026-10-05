// Cache-enabled read-back only; no routing, cache clearing, uploads or commerce actions.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {chromium}=require('playwright');
const project=path.resolve(__dirname,'../../..'),origin='http://127.0.0.1:8189';
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
async function run(){
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 const context=await browser.newContext({viewport:{width:2048,height:1152},reducedMotion:'reduce'}),page=await context.newPage(),responses=[];
 page.on('response',r=>{if(/\/(home|magazine-preview|frontend-reproduction)\.css\?/.test(r.url()))responses.push(r);});
 await page.goto(origin,{waitUntil:'networkidle'});await page.reload({waitUntil:'networkidle'});await page.evaluate(()=>document.fonts.ready);
 const styles=[];
 for(const file of ['home.css','magazine-preview.css']){
  const response=responses.findLast(r=>r.url().includes('/'+file+'?'));assert(response);assert.equal(response.status(),200);
  const bytes=await response.body(),source=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin',file));assert.equal(hash(bytes),hash(source));
  const version=new URL(response.url()).searchParams.get('ver');assert.equal(Number(version),Math.floor(fs.statSync(path.join(project,'poc/g3c/preview-plugin',file)).mtimeMs/1000));
  styles.push({file,url:response.url(),status:200,version,sourceSHA256:hash(source),deliveredSHA256:hash(bytes)});
 }
 const assets=[];
 for(const file of ['blank-cover.png','blank-spread.png','Manrope.ttf','DMSerifDisplay.ttf']){
  const r=await context.request.get(origin+'/wp-content/plugins/bms-g3c-preview/assets/preview-materials-20261006/'+file);assert.equal(r.status(),200);const b=await r.body(),source=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin/assets/preview-materials-20261006',file));assert.equal(hash(b),hash(source));assets.push({file,status:200,bytes:b.length,sha256:hash(b)});
 }
 const presets=[];
 for(const style of ['romantic','editorial','retro']){
  await page.locator('#bms-style').selectOption(style);await page.evaluate(()=>document.fonts.ready);
  presets.push(await page.locator('.bms-cover-masthead').evaluate((x,style)=>({style,font:getComputedStyle(x).fontFamily,fontLoaded:document.fonts.check(getComputedStyle(x).font),weight:getComputedStyle(x).fontWeight}),style));
 }
 assert(presets.every(x=>x.fontLoaded));assert.equal(new Set(presets.map(x=>x.font)).size,3);
 const paper=await page.locator('.bms-preview-cover').evaluate(x=>getComputedStyle(x).backgroundImage);assert(paper.includes('blank-cover.png'));
 const backing=await page.locator('#how-it-works .bms-contained-cover').evaluate(x=>({background:getComputedStyle(x).backgroundColor,padding:getComputedStyle(x).padding}));assert.equal(backing.background,'rgba(0, 0, 0, 0)');assert.equal(backing.padding,'0px');
 await page.locator('.bms-preview-local-cta').focus();assert.equal(await page.locator('.bms-preview-local-cta').evaluate(x=>getComputedStyle(x).outlineStyle),'solid');
 await page.goto(origin+'/make-your-magazine/',{waitUntil:'networkidle'});const response=responses.findLast(r=>r.url().includes('/frontend-reproduction.css?'));assert(response);const bytes=await response.body(),source=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin/frontend-reproduction.css'));assert.equal(hash(bytes),hash(source));styles.push({file:'frontend-reproduction.css',url:response.url(),status:response.status(),sourceSHA256:hash(source),deliveredSHA256:hash(bytes)});
 const age=await page.locator('[name="age"]').boundingBox(),birthday=await page.locator('[name="birthday"]').boundingBox();assert(Math.abs(age.y-birthday.y)<1);
 const report={browser:browser.version(),ordinaryCache:true,routing:false,cacheCleared:false,bypass:false,styles,assets,presets,paper,backing,ageBirthdayAligned:true,focusVisible:true,wooExcluded:true,addToCart:0,checkoutSubmissions:0};
 await browser.close();fs.writeFileSync(path.join(project,'docs/evidence/g3cr7v2r4-preview-materials/delivery.json'),JSON.stringify(report,null,2));console.log(JSON.stringify({ordinaryCache:'PASS',styles:styles.length,assets:assets.length,fonts:3,ageBirthdayAligned:true}));
}
run().catch(e=>{console.error(e.message);process.exitCode=1;});
