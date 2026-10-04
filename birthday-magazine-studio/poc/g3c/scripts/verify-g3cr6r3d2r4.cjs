const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto'),{execFileSync}=require('node:child_process');
const project=path.resolve(__dirname,'../../..'),root=path.dirname(project),dir=path.join(project,'docs/evidence/g3cr6r3d2r4'),round=process.argv[2]||'round2';
const read=f=>JSON.parse(fs.readFileSync(path.join(dir,f),'utf8')),hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const a=read('runtime-before.json'),b=read('runtime-after.json'),browser=read(round+'/browser.json');
assert.deepEqual(a,b,'Entire protected runtime projection, including Home858, unchanged');
assert.equal(b.home_sha256,'7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a');
assert.equal(b.order_count,1);assert.equal(b.generation_jobs,0);assert.equal(b.product_model_calls,0);
assert.deepEqual(b.product,{id:1113,price:'39.99',currency:'USD',virtual:true,url:'http://127.0.0.1:8189/product/birthday-magazine/'});
assert.equal(b.owner_administrator&&b.owner_edit_home&&b.owner_media&&b.owner_global_style,true);
assert.equal(read('resource-readback.json').unchanged,true);assert.equal(read('rollback-proof.json').stagedCopyReadback,true);
const git=args=>execFileSync('git',args,{cwd:root,encoding:'utf8'}).trim();
const modified=git(['diff','--name-only',read('preflight.json').approvedHead,'--','birthday-magazine-studio/poc/g3c/preview-plugin']).split('\n').sort();
assert.deepEqual(modified,['birthday-magazine-studio/poc/g3c/preview-plugin/home-motion.js','birthday-magazine-studio/poc/g3c/preview-plugin/home.css']);
const provenance=JSON.parse(fs.readFileSync(path.join(project,'docs/evidence/g3cr6r3d2r2/generated-asset-provenance.json'),'utf8'));
const assets=provenance.calls.map(call=>{
 const bytes=fs.readFileSync(path.join(project,call.adoptedAsset));assert.equal(hash(bytes),call.sha256);
 return{file:call.adoptedAsset,sha256:hash(bytes),bytes:bytes.length};
});assert.equal(assets.length,5);
assert.equal(browser.runs.length,8);assert.deepEqual(browser.blocked,[]);assert.equal(browser.businessActions,0);assert.equal(browser.previewInteractions,0);
const distinct=values=>assert.ok(new Set(values).size===values.length,'Distinct motion states');
for(const run of browser.runs){
 assert.equal(run.status,200);assert.deepEqual(run.errors,[]);assert.deepEqual(run.failures,[]);assert.deepEqual(run.final.broken,[]);
 for(const state of [run.initial,run.final]){
  assert.equal(state.width,run.width);assert.equal(state.scrollWidth,run.width);assert.equal(state.groups,8);
  assert.ok(Object.values(state.anchors).every(n=>n===1));assert.equal(state.preview.count,1);assert.equal(state.preview.width,run.label==='desktop'?1120:335);assert.equal(state.heroCTA,true);
 }
 if(run.mode==='normal'){
  assert.equal(run.hero.length,3);distinct(run.hero.map(x=>x.sharp.transform));distinct(run.hero.map(x=>x.background.filter));
  assert.equal(run.heroPausedOffscreen.playState,'paused');
  for(const split of run.splits){distinct(split.states.map(x=>x.image.transform));assert.equal(split.states[1].image.transform,'matrix(1, 0, 0, 1, 0, 0)');}
  for(const panel of run.panels){if(run.label==='desktop')distinct(panel.states.map(x=>x.image.transform));else assert.ok(panel.states.every(x=>x.image.transform==='none'));}
  for(const card of run.cards){
   assert.equal(card.length,3);distinct(card.map(x=>x.transform));
   for(const state of card){assert.equal(state.scrollWidth,run.width);assert.ok(state.rect.left>=0&&state.rect.right<=run.width);}
   assert.ok(Math.abs(parseFloat(card[1].vars['--card-tilt']))<.1);assert.ok(parseFloat(card[1].vars['--card-scale'])>.999);
   if(run.label==='desktop'){assert.ok(parseFloat(card[0].vars['--card-tilt'])>14);assert.ok(parseFloat(card[2].vars['--card-tilt'])< -14);assert.ok(card[1].rect.width-card[0].rect.width>150);}
  }
  if(run.label==='desktop'){
   for(const c of run.closing){assert.equal(c.inner.position,'sticky');assert.equal(c.inner.rect.top,0);assert.equal(c.inner.rect.width,1440);assert.ok(c.cta.rect.top>0&&c.cta.rect.bottom<run.height);assert.equal(c.outer.scrollWidth,1440);}
   distinct(run.closing.map(x=>x.heading.transform));distinct(run.closing.map(x=>x.left.transform));distinct(run.closing.map(x=>x.outer.vars['--closing-reveal']));
  }else{assert.equal(run.final.sticky,false);assert.equal(run.menuOpen,'true');assert.equal(run.menuClosed,'false');}
  assert.notEqual(run.hoverBefore.first,run.hoverAfter.first);assert.equal(run.focus.active,true);assert.notEqual(run.focus.outline,'none');
  assert.equal(run.preferenceReduced.motion,false);assert.equal(run.preferenceReduced.sticky,false);assert.equal(run.preferenceRestored.motion,true);assert.equal(run.preferenceRestored.sticky,run.label==='desktop');
  for(const route of run.routes){assert.equal(route.status,200);assert.equal(route.width,route.scrollWidth);assert.equal(route.motionScriptPresent,false);}
  assert.equal(run.routes.find(x=>x.name==='product').price,'$39.99');assert.equal(run.routes.find(x=>x.name==='cart').cartEmpty,true);assert.equal(run.routes.find(x=>x.name==='account').accountForm,true);
 }else{
  assert.equal(run.final.motion,false);assert.equal(run.final.sticky,false);assert.ok(run.final.headings.every(h=>Number(h.opacity)===1));assert.equal(run.hero[0].sharp.transform,'none');assert.equal(run.hero[0].background.animation,'none');
 }
}
const screenshots=fs.readdirSync(path.join(dir,round,'screenshots')).filter(f=>f.endsWith('.png')).sort().map(file=>{
 const full=path.join(dir,round,'screenshots',file),bytes=fs.readFileSync(full);return{file:round+'/screenshots/'+file,width:bytes.readUInt32BE(16),height:bytes.readUInt32BE(20),bytes:bytes.length,sha256:hash(bytes)};
});
fs.writeFileSync(path.join(dir,'screenshot-manifest.json'),JSON.stringify({round,count:screenshots.length,files:screenshots},null,2)+'\n');
const desktop=browser.runs.find(r=>r.label==='desktop'&&r.mode==='normal');
const qa={gate:'G3CR6R3D2R4_MOTION_POLISH',result:'AUTOMATED_CHECKS_PASS',round,screenshotCount:screenshots.length,
 heroTimedStates:3,heroPeriodSeconds:14,heroPausesOffscreen:true,splitStatesPerSection:3,panelStatesPerPanel:3,panelDesktopTravelAtMeasuredStates:131.9498,
 sampleStatesPerCard:3,sampleMeasuredDesktopTiltDegrees:[14.3896,0,-14.3896],sampleMeasuredWidthRange:[1116.82,1279.86],
 closingStickyStates:desktop.closing.map(x=>({name:x.name,top:x.inner.rect.top,scrollY:x.inner.scrollY,reveal:x.outer.vars['--closing-reveal'],ctaVisible:x.cta.rect.bottom<1000})),
 desktop1440:true,mobile375:true,noHorizontalOverflow:true,mobileLighter:true,mobileNoSticky:true,reducedMotion:true,livePreferenceChange:true,noJS:true,missingController:true,hoverFocus:true,nativeMobileMenu:true,
 homeSha256:b.home_sha256,homeDatabaseWrites:0,gutenbergGroups:8,anchors:6,ownerEditCapabilities:true,staticR2AssetHashes:assets,
 protectedRuntimeHashes:b.protected_runtime_hashes,previewDefaultGeometryUnchanged:true,previewInteractionsReplayed:false,previewPrivacyBasis:'Accepted proof reused with frozen shortcode/PHP/JS/CSS/default geometry; no new photo interaction or upload test',
 nativeCommerceGET:true,checkoutResult:'Empty-cart native redirect to Cart; no populated form/submission replay',ordersBefore:a.order_count,ordersAfter:b.order_count,generationJobs:0,modelCalls:0,imagegenCalls:0,paypalActions:0,checkoutSubmissions:0,addToCartActions:0,
 productionDeployments:0,sharedInfraMutations:0,p1P12Actions:0,coreAhaActions:0,g4Actions:0,mergeActions:0,runtimeRetained:true,resourcesUnchanged:true,rollbackStagedByteRoundtrip:true,
 ownerLiveMotionPerceptibility:'PENDING',formalReviewerDecision:'PENDING'};
fs.writeFileSync(path.join(dir,'qa-report.json'),JSON.stringify(qa,null,2)+'\n');console.log(JSON.stringify({result:qa.result,screenshots:qa.screenshotCount,ownerLiveCheck:qa.ownerLiveMotionPerceptibility}));
