const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),assert=require('node:assert/strict');
const root=path.resolve(__dirname,'..'),out=path.resolve(root,'../../docs/evidence/g3cr6r3d2');
const read=file=>JSON.parse(fs.readFileSync(path.join(out,file),'utf8').replace(/^\uFEFF/,''));
const before=read('wordpress-before.json'),after=read('wordpress-after.json');
for(const field of ['home_id','gutenberg','theme','theme_version','page_template_slug','resolved_page_template','wordpress','woocommerce','owner_administrator','owner_edit_home','owner_media','owner_global_style','product','routes','checkout_guest_enabled','checkout_signup_enabled','footer_sha256','theme_mods_sha256','order_count','generation_jobs','product_model_calls','active_plugins'])assert.deepEqual(before[field],after[field],field+' drift');
for(const key of ['commerce_workspace','woocommerce_main','preview_js','preview_css'])assert.equal(before.protected_runtime_hashes[key],after.protected_runtime_hashes[key],key+' drift');
assert.equal(after.groups.length,8);assert.equal(after.preview_shortcode_present,true);
const original=fs.readFileSync(path.join(root,'artifacts/backups/g3cr6r3d2/birthday-magazine-poc.php'),'utf8').replace(/\r\n/g,'\n');
const current=fs.readFileSync(path.join(root,'preview-plugin/birthday-magazine-poc.php'),'utf8').replace(/\r\n/g,'\n');
const allowed="  wp_enqueue_script('bms-home-motion', plugins_url('home-motion.js', __FILE__), [], '0.3.0', true);\n";
assert.equal(current.replace(allowed,''),original,'PHP changed outside guarded enqueue');
const expectedURL='http://127.0.0.1:8189/#samples';
const changes=[];
for(const [location,items] of Object.entries(before.menus)){
 const now=after.menus[location];assert.equal(items.length,now.length);
 items.forEach((item,i)=>{if(JSON.stringify(item)!==JSON.stringify(now[i])){assert.equal(item.label,'Sample Pages');assert.equal(item.url,'http://127.0.0.1:8189/#sample-pages');assert.equal(now[i].url,expectedURL);changes.push(location);}});
}
assert.deepEqual(changes,['menu_mobile']);
const round=process.argv[2]||'round2';const browser=read(round+'/browser.json');
assert.equal(browser.runs.length,8);assert.equal(browser.blocked.length,0);
for(const run of browser.runs){
 assert.equal(run.status,200);assert.equal(run.final.width,run.width);assert.equal(run.final.scrollWidth,run.width);
 assert.equal(run.errors.length,0);assert.equal(run.failures.length,0);assert.equal(run.final.brokenImages.length,0);
 assert.equal(run.final.previewCount,1);assert.equal(run.final.groups.length,8);
 for(const count of Object.values(run.final.anchors))assert.equal(count,1);
 assert.ok(run.final.headings.every(h=>parseFloat(h.opacity)>.6));
 assert.equal(run.final.preview.width,run.width===1440?1120:335);
 assert.equal(run.final.motionEnabled,run.mode==='normal');
 if(run.mode==='normal'){
  assert.notEqual(run.entranceEarly.imageFilter,run.entranceSettled.imageFilter);
  assert.equal(run.entranceSettled.imageOpacity,'1');
  assert.equal(new Set(run.motionStates.map(s=>s.transform)).size,3);
  assert.notEqual(run.hoverBefore.first,run.hoverAfter.first);
  assert.equal(run.focus.active,true);assert.equal(run.focus.outline,'solid');
  assert.equal(run.routes.length,4);assert.ok(run.routes.every(r=>r.status===200&&!r.motionScriptPresent&&r.scrollWidth===r.width));
  assert.ok(run.routes.find(r=>r.name==='checkout').final.endsWith('/cart/'));
  if(run.label==='mobile'){assert.equal(run.mobileMenu.expanded,'true');assert.equal(run.mobileMenu.closed,'false');assert.ok(run.mobileMenu.links.some(l=>l.href===expectedURL));}
 }
}
const files=fs.readdirSync(path.join(out,round,'screenshots')).filter(f=>f.endsWith('.png')).map(file=>{
 const bytes=fs.readFileSync(path.join(out,round,'screenshots',file));
 assert.equal(bytes.subarray(1,4).toString(),'PNG');return{file,width:bytes.readUInt32BE(16),height:bytes.readUInt32BE(20),bytes:bytes.length,sha256:crypto.createHash('sha256').update(bytes).digest('hex')};
});
fs.writeFileSync(path.join(out,'screenshot-manifest.json'),JSON.stringify({round,files},null,2)+'\n');
const result={gate:'G3CR6R3D2_FOCUSLY_HOMEPAGE_IMPLEMENTATION',machine_regression:'PASS',visual_judgment:'INTERNAL_FINAL_REVIEW_SHIP_OFFICIAL_REVIEWER_PENDING',round,home:after.home_sha256,groups:8,requiredAnchors:6,
 previewJsCssUnchanged:true,previewShortcodeAndWooHooksUnchanged:true,previewInternalWidths:[1120,335],previewInteractionExercised:false,
 exactMenuObject:1098,menuChanges:changes,privacyPage:'DRAFT_NOT_LINKED',footerHashUnchanged:true,themeModsUnchanged:true,
 desktop1440:'PASS',mobile375:'PASS',motionScrollHoverFocus:'PASS',reducedMotion:'PASS',noJsStatic:'PASS',motionScriptUnavailable:'PASS',wooReadOnly:'PASS_EMPTY_CART_CHECKOUT_REDIRECT',
 orderCount:[before.order_count,after.order_count],generationJobs:after.generation_jobs,productModelCalls:after.product_model_calls,imagegenCalls:0,
 screenshotCount:files.length,modelActions:0,paypalActions:0,cartActions:0,checkoutSubmissions:0,orderCreations:0,productionDeployments:0,sharedInfraMutations:0,P1P12Changes:0,coreAhaChanges:0,mergePR:0,
 ownerGutenbergEditAccess:true,runtimeRetained:true,rollbackDry:read('rollback-dry-readback.json'),stopAtReviewer:true,ownerRelay:'NONE'};
fs.writeFileSync(path.join(out,'machine-acceptance.json'),JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result));
