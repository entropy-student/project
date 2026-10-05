const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const crypto = require('node:crypto');
const { chromium } = require('playwright');
const project = path.resolve(__dirname, '../../..');
const phase = process.argv[2];
assert(['before', 'after', 'confirm'].includes(phase));
const out = path.join(project, 'docs/evidence/g3cr7v2r4-preview-focus', phase);
fs.mkdirSync(out, { recursive: true });
const origin = 'http://127.0.0.1:8189';
const fixture = path.join(project, 'poc/g3c/preview-plugin/assets/g3cr6r3d2r2/sample-eli-cover.png');
const states = [], manifests = [], network = [];
const hash = b => crypto.createHash('sha256').update(b).digest('hex');
async function save(page, name, width, full = false) {
 const file = `${name}-${width}.png`;
 await (full ? page : page.locator('#preview')).screenshot({ path: path.join(out, file), animations: 'disabled', ...(full && { fullPage: true }) });
 const bytes = fs.readFileSync(path.join(out, file));
 manifests.push({ file, bytes: bytes.length, sha256: hash(bytes), viewport: width, fullPage: full });
 const g = await page.locator('#preview').evaluate(root => {
  const pick = s => { const el=root.querySelector(s); if(!el)return null; const r=el.getBoundingClientRect(),c=getComputedStyle(el); return { width:r.width,height:r.height,x:r.x,font:c.fontSize,weight:c.fontWeight,color:c.color,background:c.backgroundColor,display:c.display,grid:c.gridTemplateColumns }; };
  const r=root.getBoundingClientRect(),c=getComputedStyle(root);
  return { viewport:innerWidth,scrollWidth:document.documentElement.scrollWidth,sectionHeight:r.height,background:c.backgroundColor,grid:c.gridTemplateColumns,heading:pick('.bms-heading'),emphasis:pick('.bms-heading strong'),controls:pick('.bms-preview-controls'),stage:pick('.bms-preview-stage'),cover:pick('.bms-preview-cover'),spread:pick('.bms-preview-spread'),input:pick('#bms-name'),cta:pick('.bms-coral-link'),blank: [...root.querySelectorAll('[data-bms-art],[data-bms-spread-art]')].map(x=>({ text:x.textContent.trim(),backgroundImage:getComputedStyle(x).backgroundImage })),broken:[...root.querySelectorAll('img')].filter(x=>x.getClientRects().length&&!x.hidden&&(!x.complete||!x.naturalWidth)).length };
 });
 states.push({ name, ...g });
 assert(g.scrollWidth <= width); assert.equal(g.broken,0);
}
async function run() {
 const browser=await chromium.launch({headless:true,executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'});
 for(const width of [2048,1440,375]) {
  const context=await browser.newContext({viewport:{width,height:width===375?812:1152},deviceScaleFactor:1,reducedMotion:'reduce'});
  const n={width,nonGET:0,externalImages:0,pageErrors:[]};
  await context.route('**/*',route=>{ const r=route.request(); if(!['GET','HEAD'].includes(r.method())){n.nonGET++;return route.abort();} if(r.resourceType()==='image'&&/^https?:/.test(r.url())&&new URL(r.url()).origin!==origin)n.externalImages++;return route.continue(); });
  const page=await context.newPage(); page.on('pageerror',e=>n.pageErrors.push(e.message));
  await page.goto(origin,{waitUntil:'networkidle'});await page.locator('#preview').scrollIntoViewIfNeeded();
  const outside=await page.locator('.entry-content > .wp-block-group:not(#preview)').evaluateAll(xs=>xs.map(x=>{const r=x.getBoundingClientRect(),s=getComputedStyle(x);return{id:x.id,class:x.className,width:r.width,height:r.height,padding:s.padding,background:s.backgroundColor,font:s.fontFamily};}));
  await save(page,'preview-empty',width);
  if(width===1440)await save(page,'home-context',width,true);
  await page.locator('#bms-name').fill('Taylor');await page.locator('#bms-age').fill('30');
  for(const mood of ['editorial','retro','romantic']){await page.locator('#bms-style').selectOption(mood);assert.equal(await page.locator('[data-bms-preview]').getAttribute('data-style'),mood);}
  await page.locator('[data-bms-file]').setInputFiles(fixture);
  await page.waitForFunction(()=>document.querySelector('[data-bms-preview]').dataset.hasPhoto==='true');
  assert((await page.locator('[data-bms-image]').first().getAttribute('src')).startsWith('blob:'));
  await save(page,'preview-photo',width);
  const textOverlap=await page.evaluate(()=>[['.bms-cover-photo-frame','.bms-cover-headlines'],['.bms-spread-photo-frame','.bms-photo-copy']].some(([a,b])=>{const x=document.querySelector(a),y=document.querySelector(b);return x.offsetParent===y.offsetParent&&Math.min(x.offsetLeft+x.offsetWidth,y.offsetLeft+y.offsetWidth)-Math.max(x.offsetLeft,y.offsetLeft)>1&&Math.min(x.offsetTop+x.offsetHeight,y.offsetTop+y.offsetHeight)-Math.max(x.offsetTop,y.offsetTop)>1;}));
  assert.equal(textOverlap,false);
  await page.locator('[data-bms-remove]').click();assert.equal(await page.locator('[data-bms-image]').first().getAttribute('src'),null);
  await page.locator('[data-bms-file]').setInputFiles(fixture);await page.waitForFunction(()=>document.querySelector('[data-bms-preview]').dataset.hasPhoto==='true');await page.locator('[data-bms-remove]').click();
  const cta=await page.locator('.bms-coral-link').evaluate(x=>({text:x.textContent.trim(),path:new URL(x.href).pathname}));assert.equal(cta.path,'/make-your-magazine/');
  if(phase!=='before') {assert(await page.locator('.bms-heading strong').isVisible());assert.equal(await page.locator('.bms-preview-controls-title').count(),1);assert.equal(await page.locator('.bms-preview-controls-title').textContent(),'Try it for free');}
  network.push({...n,outside,cta,blob:true,replaceRemove:true,textOverlap:false,moodPreserved:true});await context.close();
 }
 if(phase!=='before')for(const width of [1440,375]) {
  const context=await browser.newContext({viewport:{width,height:width===375?812:1152},javaScriptEnabled:false});const page=await context.newPage();await page.goto(origin,{waitUntil:'networkidle'});await save(page,'preview-no-js',width);assert(await page.locator('.bms-heading strong').isVisible());await context.close();
 }
 await browser.close();assert(network.every(x=>!x.nonGET&&!x.externalImages&&!x.pageErrors.length));
 if(phase!=='before'){const before=JSON.parse(fs.readFileSync(path.join(out,'../before/readback.json')));for(const n of network)assert.deepEqual(n.outside,before.network.find(x=>x.width===n.width).outside);assert(states.filter(x=>x.name==='preview-empty').every(x=>x.blank.every(y=>y.text===''&&y.backgroundImage==='none')));}
 const data={phase,states,network,screenshots:manifests,checkoutSubmissions:0,modelCalls:0,paymentActions:0,photoUploads:0};fs.writeFileSync(path.join(out,'readback.json'),JSON.stringify(data,null,2));console.log(JSON.stringify({phase,screenshotCount:manifests.length,overflow:false,uploads:0,out}));
}
run().catch(e=>{console.error(e.message);process.exit(1);});
