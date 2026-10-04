const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {chromium}=require('../.tmp/browser-tools/node_modules/playwright-core');
const out=path.resolve(__dirname,'../../../docs/evidence/g3cr6r3d2');
let browser;
(async()=>{
 browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});const runs=[];
 for(const width of [1440,375]){
  const context=await browser.newContext({viewport:{width,height:width===375?812:1000}});
  await context.route('**/*',r=>['GET','HEAD'].includes(r.request().method())?r.continue():r.abort());
  const page=await context.newPage();await page.goto('http://127.0.0.1:8189/',{waitUntil:'networkidle'});await page.waitForTimeout(1900);
  const state=await page.evaluate(()=>{
   const box=s=>document.querySelector(s).getBoundingClientRect();
   const frame=box('.bms-focus-frame'),heroTitle=box('.bms-hero-message h1'),closingPhoto=box('.bms-closing-photo-left'),closingTitle=box('.bms-closing h2');
   return {width:innerWidth,scrollWidth:document.documentElement.scrollWidth,heroGap:heroTitle.top-frame.bottom,closingLeftGap:closingTitle.top-closingPhoto.bottom,brandColor:getComputedStyle(document.querySelector('#header .site-title a')).color,spreadFit:getComputedStyle(document.querySelector('#what-you-get img')).objectFit,
    preservedPreviewInputs:document.querySelector('[data-bms-preview] input[type=file]').value,anchors:[...document.querySelectorAll('.entry-content>[id]')].map(e=>e.id)};
  });
  assert.equal(state.brandColor,'rgb(255, 255, 255)');assert.equal(state.spreadFit,'contain');assert.equal(state.scrollWidth,width);assert.ok(state.heroGap>0,'Hero boxes must not collide');assert.equal(state.preservedPreviewInputs,'');
  if(width===375){assert.ok(state.closingLeftGap>=12);await page.locator('#header .ct-header-trigger').click();await page.waitForTimeout(650);state.menu=await page.locator('#offcanvas .ct-panel-inner').evaluate(e=>({rect:e.getBoundingClientRect().toJSON(),radius:getComputedStyle(e).borderRadius}));assert.ok(state.menu.rect.height<712);assert.equal(state.menu.radius,'24px');await page.keyboard.press('Escape');state.menuClosed=await page.locator('#header .ct-header-trigger').getAttribute('aria-expanded');assert.equal(state.menuClosed,'false');}
  runs.push(state);await context.close();
 }
 await browser.close();fs.writeFileSync(path.join(out,'final-layout-probe.json'),JSON.stringify({runs,previewActions:0,businessActions:0},null,2)+'\n');console.log(JSON.stringify(runs));
})().catch(async e=>{if(browser)await browser.close();console.error(e.message);process.exitCode=1;});
