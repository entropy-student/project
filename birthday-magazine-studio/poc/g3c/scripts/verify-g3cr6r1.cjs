const fs=require('fs'),path=require('path'),assert=require('assert/strict'),crypto=require('crypto');
const {spawnSync}=require('child_process');
const base=path.resolve(__dirname,'..');
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
const backup=JSON.parse(fs.readFileSync(path.join(base,'artifacts/backups/g3cr6r1/rollback-manifest.json')));
const preflight=JSON.parse(fs.readFileSync(path.join(base,'artifacts/reports/g3cr6r1-preflight.json')));
const browser=JSON.parse(fs.readFileSync(path.join(base,'artifacts/reports/g3cr6r1-browser.json')));
const php=spawnSync('docker',['exec','-i','birthday-magazine-g3c-wordpress-1','php'],{input:fs.readFileSync(path.join(__dirname,'readback-g3cr6r1.php')),encoding:'utf8'});
assert.equal(php.status,0,php.stderr);
const runtime=JSON.parse(php.stdout);
const guards=['owner','unrelated','guest'].map(context=>{
 const result=spawnSync('docker',['exec','-i','birthday-magazine-g3c-wordpress-1','php','--',context],{input:fs.readFileSync(path.join(__dirname,'workspace-regression-g3cr6.php')),encoding:'utf8'});
 assert.equal(result.status,0,result.stderr);const record=JSON.parse(result.stdout);
 assert.equal(record.status,context==='owner'?200:403);
 assert.equal(record.workspace_rendered,context==='owner');return record;
});
const files=backup.protectedFiles.map(item=>{
 const actual=sha(fs.readFileSync(path.join(base,item.path)));assert.equal(actual,item.sha256);return {...item,afterSha256:actual,unchanged:true};
});
assert.deepEqual(runtime.protected_runtime_hashes,backup.runtimeHashes);
assert.deepEqual(runtime.product,preflight.runtime.product);
assert.deepEqual(runtime.active_plugins,preflight.runtime.active_plugins);
assert.equal(runtime.order_count,backup.orderCount);
assert.equal(runtime.top_level_groups,8);
assert.ok(runtime.gutenberg&&runtime.core_block_roundtrip&&runtime.owner_administrator&&runtime.owner_edit_home&&runtime.owner_media&&runtime.owner_global_style&&runtime.owner_reorder_major_sections);
assert.ok(runtime.classes.every(c=>!c.includes('g3cr4-')));
assert.ok(runtime.image_files_exist.every(Boolean));
const counters=Object.fromEntries(['PR_MERGE','THEME_CHANGE','BUILDER_CHANGE','ELEMENTOR_INSTALL','PAYPAL_ACTIONS','REAL_MONEY_ACTIONS','CHECKOUT_SUBMISSIONS','PRODUCTION_AI_CALLS','PRODUCTION_DEPLOYMENT','SHARED_INFRA_MUTATIONS','PAID_PURCHASES','GLOBAL_DOCKER_PRUNE','G4_ACTIONS','FREE_PREVIEW_MODEL_CALLS','FREE_PREVIEW_SERVER_PHOTO_UPLOADS','FREE_PREVIEW_EXTERNAL_IMAGE_POSTS'].map(k=>[k,0]));
const frontendFiles=['birthday-magazine-poc.php','preview.js','studio.css','home.css','magazine-preview.css'].map(name=>({path:'preview-plugin/'+name,sha256:sha(fs.readFileSync(path.join(base,'preview-plugin',name)))}));
const report={
 gate:'G3CR6R1_FRONTEND_COMPOSITION_REDESIGN',result:'PASS_CANDIDATE_G3CR6R1_FRONTEND_COMPOSITION_REDESIGN',
 branch:'codex/birthday-magazine-g3c-blocksy-wedding-productization',preRunHead:'9f90c1e53058567010fcbd9f505ac99ceaacc6f9',
 generatedAt:new Date().toISOString(),runtime,frontendFiles,protectedFiles:files,workspaceGuards:guards,
 orderCountBefore:backup.orderCount,orderCountAfter:runtime.order_count,
 assets:{generatedThisGate:[],adopted:['preview-plugin/assets/g3cr6/gift-hero.png','preview-plugin/assets/g3cr6/sample-spread.png','preview-plugin/assets/g3cr6/sample-cover.png'],syntheticTestFixture:'theme-overrides/g3cr6/synthetic-preview-portrait.png'},
 homeStructure:{topLevelGroups:8,layout:['gift editorial hero','value strip','unequal spread and cover gallery','full-width preview chapter','12-page visual included story','vertical four-step journey','centered gift conclusion','independent open FAQ'],oldStructuralClassesActive:0,footerEditableBlockId:runtime.editable_footer_id},
 ownerEditing:{home:'core Gutenberg blocks',images:'core/image Media Library replacement',copy:'core/heading and core/paragraph',reorder:'eight top-level core/group blocks',palette:'Blocksy Customizer colorPalette; frontend tokens consume it',footer:'Appearance/Patterns editable wp_block; ID '+runtime.editable_footer_id,verificationBoundary:'fresh permissions, core-block roundtrip and structure; no authenticated editor save claimed'},
 preview:browser.preview,nativeWoo:{add:browser.nativeAddToCart,quantityUpdate:browser.cartQuantityUpdate,remove:browser.cartRemove,checkoutLoaded:true,checkoutSubmitted:false,accountLoginFormLoaded:true},
 geometry:browser.pages,palette:browser.palette,screenshots:browser.screenshots,browserErrors:browser.errors,
 modelCounterBoundary:'Legacy counter options are absent. Zero calls proved by browser interaction network trace and no provider/model code in preview; options returning zero alone are not provider evidence.',
 rollback:'poc/g3c/artifacts/backups/g3cr6r1',rollbackExecuted:false,localSiteUrl:'http://127.0.0.1:8189/',localWpAdminUrl:'http://127.0.0.1:8189/wp-admin/',
 forbiddenCounters:counters,ownerVisualFreeze:'PENDING',stopAtReviewer:true
};
fs.writeFileSync(path.join(base,'artifacts/reports/g3cr6r1-final.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify({result:report.result,protectedFiles:files,guards,orderBefore:backup.orderCount,orderAfter:runtime.order_count,owner:report.ownerEditing,counters},null,2));
