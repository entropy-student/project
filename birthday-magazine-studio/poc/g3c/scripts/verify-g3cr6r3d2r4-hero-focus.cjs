const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const project=path.resolve(__dirname,'../../..'),evidence=path.join(project,'docs/evidence/g3cr6r3d2r4-hero-focus');
const round=process.argv[2]||'round2',read=file=>JSON.parse(fs.readFileSync(path.join(evidence,file),'utf8'));
const browser=read(round+'/browser.json'),before=read('runtime-before.json'),after=read('runtime-after.json');
const checks=[],check=(name,value)=>checks.push({name,result:value?'PASS':'FAIL'});
const close=(a,b,t=.15)=>Math.abs(a-b)<=t,number=s=>parseFloat(s),norm=s=>s.replace(/\r\n/g,'\n');
const digest=b=>crypto.createHash('sha256').update(b).digest('hex');
check('protected_runtime_identical',JSON.stringify(before)===JSON.stringify(after));
check('docker_project_and_unrelated_resources_identical',read('resource-readback.json').unchanged);
check('rollback_byte_roundtrip',read('rollback-proof.json').stagedCopyReadback);
check('owner_gutenberg_edit_capabilities',after.gutenberg&&after.owner_administrator&&after.owner_edit_home&&after.owner_media&&after.owner_global_style);
check('orders_jobs_model_frozen',after.order_count===1&&after.generation_jobs===0&&after.product_model_calls===0);
check('product_1113_virtual_39_99_usd',after.product.id===1113&&after.product.price==='39.99'&&after.product.currency==='USD'&&after.product.virtual);
const backup=path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r4-hero-focus'),current=path.join(project,'poc/g3c/preview-plugin');
const oldJS=norm(fs.readFileSync(path.join(backup,'home-motion.js'),'utf8')),newJS=norm(fs.readFileSync(path.join(current,'home-motion.js'),'utf8'));
const nonHero=s=>s.slice(s.indexOf('  // Decorative label duplicate'),s.indexOf('  function applyPreference()'));
check('non_hero_scroll_hover_reveal_js_exact',nonHero(oldJS)===nonHero(newJS));
check('non_hero_css_rule_projection_exact',read('non-hero-css-projection.json').equal===true&&read('non-hero-css-projection.json').styleRules>100);
check('preview_php_exact',digest(fs.readFileSync(path.join(backup,'birthday-magazine-poc.php')))===digest(fs.readFileSync(path.join(current,'birthday-magazine-poc.php'))));
const assets=JSON.parse(fs.readFileSync(path.join(project,'docs/evidence/g3cr6r3d2r2/generated-asset-provenance.json'),'utf8')).calls;
check('five_owned_r2_assets_unchanged',assets.every(a=>digest(fs.readFileSync(path.join(project,a.adoptedAsset)))===a.sha256));
check('eight_browser_modes',browser.runs.length===8);
check('no_browser_business_or_preview_interactions',browser.businessActions===0&&browser.previewInteractions===0&&browser.blocked.length===0);
for(const run of browser.runs){
 const prefix=run.label+'_'+run.mode,health=[run.initial,run.final];
 check(prefix+'_home_resource_health',run.status===200&&!run.errors.length&&!run.failures.length&&health.every(h=>h.width===h.scrollWidth&&!h.broken.length));
 check(prefix+'_gutenberg_anchors_preview',health.every(h=>h.groups===8&&Object.values(h.anchors).every(n=>n===1)&&h.preview.count===1&&h.preview.width===(run.label==='desktop'?1120:335)));
 if(run.mode!=='normal'){
  check(prefix+'_static_complete',!run.default.enhanced&&run.default.originalSharpVisibility==='visible'&&run.default.copyOpacity==='1'&&run.default.ctaHref==='#preview');
  if(run.mode==='reduced')check(prefix+'_animations_paused',run.default.background.every(p=>p.animations.every(a=>a.state==='paused')));
  continue;
 }
 const all=[run.default,...run.pointer,run.pointerReturn,...run.states];
 const a=run.states.find(s=>s.name==='a-clear'),b=run.states.find(s=>s.name==='b-clear'),returned=run.states.find(s=>s.name==='a-return');
 check(prefix+'_two_real_owned_images',new Set(a.background.map(p=>p.src)).size===2&&a.background[0].src.endsWith('/g3cr6-gift-hero.png')&&a.background[1].src.endsWith('/sample-lena-gift.png'));
 check(prefix+'_clear_a_b_a_cycle',a.background[0].opacity==='1'&&b.background[1].opacity==='1'&&returned.background[0].opacity==='1'&&[a,b,returned].every(s=>s.windowFilter==='blur(0px)'));
 check(prefix+'_blur_zoom_only_transitions',run.states.filter(s=>s.name==='a-to-b'||s.name==='b-to-a').every(s=>number(s.windowFilter.slice(5))>=(run.label==='desktop'?10:5)&&number(s.background[0].opacity)>0&&number(s.background[0].opacity)<1&&number(s.background[0].transform.slice(7))>1.02));
 check(prefix+'_same_scene_coordinates',all.every(s=>JSON.stringify(s.stage)===JSON.stringify(s.canvas)&&s.background.every((p,i)=>JSON.stringify(p.rect)===JSON.stringify(s.sharp[i].rect)&&p.transform===s.sharp[i].transform&&p.opacity===s.sharp[i].opacity&&p.objectPosition===s.sharp[i].objectPosition)));
 check(prefix+'_paired_animation_clocks',all.every(s=>{const clocks=[...s.background,...s.sharp].flatMap(p=>p.animations.map(a=>a.time));return Math.max(...clocks)-Math.min(...clocks)<.1;}));
 check(prefix+'_window_bounded_above_copy',all.every(s=>s.frame.left>=23&&s.frame.right<=run.width-23&&s.frame.bottom<=s.copy.top-18));
 check(prefix+'_copy_cta_fixed',all.every(s=>JSON.stringify(s.copy)===JSON.stringify(run.default.copy)&&JSON.stringify(s.cta)===JSON.stringify(run.default.cta)&&s.copyOpacity==='1'&&s.ctaHref==='#preview'));
 check(prefix+'_focus_and_pause',run.focus.active&&run.focus.outline==='solid'&&run.offscreen.background.every(p=>p.animations.every(a=>a.state==='paused')));
 check(prefix+'_live_reduced_restored',!run.liveReduced.enhanced&&run.liveReduced.originalSharpVisibility==='visible'&&run.liveReduced.background.every(p=>p.animations.every(a=>a.state==='paused'))&&run.liveRestored.enhanced);
 if(run.label==='desktop'){
  check(prefix+'_pointer_horizontal_and_vertical_follow',number(run.pointer[1].focusX)-number(run.pointer[0].focusX)>350&&number(run.pointer[2].focusY)-number(run.pointer[0].focusY)>90);
  check(prefix+'_pointer_leave_recentres',Math.abs(number(run.pointerReturn.focusX))<.1&&Math.abs(number(run.pointerReturn.focusY))<.1);
 }else{
  check(prefix+'_fixed_mobile_window',all.every(s=>number(s.focusX)===0&&number(s.focusY)===0&&s.frame.width===327&&s.frame.height===276&&s.canvas.height===480));
  check(prefix+'_native_mobile_menu',run.menuOpen==='true'&&run.menuClosed==='false');
 }
 check(prefix+'_woo_get_only_routes',run.routes.length===4&&run.routes.every(r=>r.status===200&&r.width===r.scrollWidth&&!r.motionScriptPresent)&&run.routes[0].price==='$39.99'&&run.routes[1].cartEmpty&&run.routes[2].url.endsWith('/cart/')&&run.routes[3].accountForm);
}
const screenshots=fs.readdirSync(path.join(evidence,round,'screenshots')).filter(f=>f.endsWith('.png')).map(file=>{const bytes=fs.readFileSync(path.join(evidence,round,'screenshots',file));return{file:round+'/screenshots/'+file,bytes:bytes.length,sha256:digest(bytes)};});
fs.writeFileSync(path.join(evidence,'screenshot-manifest.json'),JSON.stringify({round,count:screenshots.length,files:screenshots},null,2)+'\n');
const failures=checks.filter(c=>c.result!=='PASS');
const report={gate:'G3CR6R3D2R4_MOTION_POLISH',iteration:'Owner-approved Hero-only two-image pointer focus',result:failures.length?'RETURN_HERO_FOCUS_VERIFICATION':'AUTOMATED_CHECKS_PASS',round,
 checks,screenshotCount:screenshots.length,heroPeriodSeconds:20,clearHoldSecondsPerImage:8,transitionSeconds:2,newImagegenCalls:0,
 limitations:['Headless Edge verifies states/geometry, not physical-device frame rate or Owner visual acceptance.','Checkout GET follows native empty-cart redirect; no populated checkout or cart mutation exercised.','Preview interactions and authenticated workspace not repeated; unchanged hashes correlate accepted evidence.'],
 uiRepairBatches:0,harnessNote:'Round1 initial capture stopped on duplicate brand locator; scoped locator fixed before full round1. Offline CSS projection corrected for CSSStyleRule.cssRules after round2; non-hero-css-projection.json is authoritative. No app change followed inspection.',
 productModelCalls:0,paypalActions:0,checkoutSubmissions:0,ownerVisualFreeze:'PENDING',runtimeRetained:true};
fs.writeFileSync(path.join(evidence,'qa-report.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({result:report.result,checks:checks.length,screenshots:screenshots.length,failures}));
if(failures.length)process.exitCode=1;
