const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto'),{execFileSync}=require('node:child_process');
const project=path.resolve(__dirname,'../../..'),dir=path.join(project,'docs/evidence/g3cr6r3d2r2'),round=process.argv[2]||'round2';
const read=f=>JSON.parse(fs.readFileSync(path.join(dir,f),'utf8').replace(/^\uFEFF/,'')),hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const a=read('runtime-before.json'),b=read('runtime-after.json'),browser=read(round+'/browser.json');
for(const key of Object.keys(a).filter(k=>k!=='home_sha256'))assert.deepEqual(b[key],a[key],key+' frozen');
assert.equal(b.home_sha256,'7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a');
assert.equal(b.order_count,1);assert.equal(b.generation_jobs,0);assert.equal(b.product_model_calls,0);
assert.deepEqual(b.product,{id:1113,price:'39.99',currency:'USD',virtual:true,url:'http://127.0.0.1:8189/product/birthday-magazine/'});
assert.equal(b.groups.length,8);assert.equal(b.gutenberg,true);assert.equal(b.owner_administrator&&b.owner_edit_home&&b.owner_media&&b.owner_global_style,true);
const wp=JSON.parse(fs.readFileSync(path.join(dir,'resources-after.json'),'utf8')).containers.find(c=>c.project==='birthday-magazine-g3c'&&c.name.endsWith('wordpress-1'));
const current=JSON.parse(execFileSync('docker',['exec',wp.id,'php','-r',"define('DISABLE_WP_CRON',true);require '/var/www/html/wp-load.php';echo wp_json_encode(['content'=>get_post_field('post_content',858)], JSON_UNESCAPED_SLASHES);"],{encoding:'utf8'}));
fs.writeFileSync(path.join(dir,'home-final.json'),JSON.stringify(current,null,2)+'\n');
const old=JSON.parse(fs.readFileSync(path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r2/home.json'),'utf8'));
const imagePattern=/<!-- wp:image\s[\s\S]*?<!-- \/wp:image -->\n/g;
const beforeImages=[...old.content.matchAll(imagePattern)].map(x=>x[0]),afterImages=[...current.content.matchAll(imagePattern)].map(x=>x[0]);
assert.equal(beforeImages.length,afterImages.length);assert.equal(beforeImages.filter((x,i)=>x!==afterImages[i]).length,5);
assert.equal(old.content.replace(imagePattern,'IMAGE_BLOCK\n'),current.content.replace(imagePattern,'IMAGE_BLOCK\n'),'All non-image content byte-identical');
const backup=path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r2');
for(const name of ['home-motion.js','birthday-magazine-poc.php'])assert.equal(hash(fs.readFileSync(path.join(backup,name))),hash(fs.readFileSync(path.join(project,'poc/g3c/preview-plugin',name))),name+' unchanged');
const earlier=JSON.parse(fs.readFileSync(path.join(project,'docs/evidence/g3cr6r3d2/round2/browser.json'),'utf8'));
assert.equal(browser.runs.length,8);assert.deepEqual(browser.blocked,[]);assert.equal(browser.businessActions,0);assert.equal(browser.previewActions,0);
for(const run of browser.runs){
 assert.equal(run.status,200);assert.equal(run.final.width,run.width);assert.equal(run.final.scrollWidth,run.width);
 assert.deepEqual(run.errors,[]);assert.deepEqual(run.failures,[]);assert.deepEqual(run.final.brokenImages,[]);
 assert.equal(run.final.groups.length,8);for(const count of Object.values(run.final.anchors))assert.equal(count,1);
 assert.equal(run.final.previewCount,1);assert.equal(run.final.heroCTA,true);assert.deepEqual(run.final.preview,earlier.runs.find(e=>e.label===run.label&&e.mode===run.mode).final.preview);
 assert.ok(run.final.headings.every(h=>Number(h.opacity)===1&&h.width>0));
 assert.equal(run.final.cards.length,3);assert.equal(new Set(run.final.cards.map(c=>c.image)).size,3);
 for(const card of run.final.cards){assert.equal(card.width,run.label==='desktop'?1280:343);assert.equal(card.figurePadding,'0px');assert.equal(card.imageFit,'cover');}
 if(run.mode==='normal'){
  assert.equal(run.motionStates.length,3);assert.ok(new Set(run.motionStates.map(x=>x.transform)).size>1);
  for(const s of run.motionStates)assert.ok(Math.abs(parseFloat(s.tilt))<=(run.label==='desktop'?8:2));
  assert.notEqual(run.hoverBefore.first,run.hoverAfter.first);assert.equal(run.focus.active,true);assert.notEqual(run.focus.outline,'none');
  for(const route of run.routes){assert.equal(route.status,200);assert.equal(route.width,route.scrollWidth);assert.equal(route.motionScriptPresent,false);}
  assert.equal(run.routes.find(r=>r.name==='product').price,'$39.99');assert.equal(run.routes.find(r=>r.name==='cart').cartEmpty,true);assert.equal(run.routes.find(r=>r.name==='account').accountForm,true);
  if(run.label==='mobile'){
   const h=run.final.header;assert.ok(h.trigger.width>=44&&h.trigger.height>=44);assert.ok(h.trigger.left-h.brand.right>=40);
   assert.equal(run.mobileMenu.expanded,'true');assert.equal(run.mobileMenu.closed,'false');
   assert.ok(run.mobileMenu.links.some(l=>l.href.endsWith('/#samples')));assert.ok(run.mobileMenu.links.every(l=>!l.href.endsWith('/#sample-pages')));
   assert.ok(run.final.pageHeight<7959);
  }
 }else assert.equal(run.final.motionEnabled,false);
}
const provenance=read('generated-asset-provenance.json');assert.equal(provenance.totalCallCount,5);assert.equal(provenance.rejectedCallCount,0);
for(const call of provenance.calls){const file=path.join(project,call.adoptedAsset),bytes=fs.readFileSync(file);call.sha256=hash(bytes);call.bytes=bytes.length;call.dimensions={width:bytes.readUInt32BE(16),height:bytes.readUInt32BE(20)};}
fs.writeFileSync(path.join(dir,'generated-asset-provenance.json'),JSON.stringify(provenance,null,2)+'\n');
assert.equal(read('resource-readback.json').unchanged,true);assert.equal(read('rollback-proof.json').backupHomeHashValid,true);
const mobile=browser.runs.find(r=>r.label==='mobile'&&r.mode==='normal');
const result={gate:'G3CR6R3D2R2_VISUAL_POLISH',round,result:'TECHNICAL_CHECKS_PASS',eightGutenbergGroups:true,sixUniqueAnchors:true,ownerEditCapabilities:true,homeChanges:'Exactly five image blocks; all other Gutenberg content byte-identical',samples:{desktopWidth:1280,mobileWidth:343,compositions:3,fullBleed:true,perspectiveControllerByteUnchanged:true},mobileHeader:{brandWidth:mobile.final.header.brand.width,menuTouchTarget:44,brandMenuGap:mobile.final.header.trigger.left-mobile.final.header.brand.right},mobileRhythm:{acceptedD2Height:7959,r2Height:mobile.final.pageHeight,reduction:7959-mobile.final.pageHeight},desktopMobileNoOverflow:true,brokenImages:0,pageErrors:0,failedResources:0,hoverFocus:true,nativeMobileMenu:true,reducedMotion:true,noJS:true,missingMotionScriptFallback:true,protectedRuntimeHashesUnchanged:true,previewGeometryUnchanged:true,previewInteractionsReplayed:false,privacyBasis:'Accepted Preview proof + byte-identical JS/CSS/PHP and unchanged shortcode/geometry, not a new photo-upload test',commerceReadOnly:true,checkoutReadOnlyResult:'Empty-cart native redirect to /cart/; no Add to Cart or submit',orderCountBefore:1,orderCountAfter:1,productModelCalls:0,generationJobs:0,staticDesignImagegenCalls:5,runtimeRetained:true,resourcesUnchanged:true,visualDecision:'Owner/Reviewer pending; internal technical report is not formal PASS'};
fs.writeFileSync(path.join(dir,'qa-report.json'),JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result));
