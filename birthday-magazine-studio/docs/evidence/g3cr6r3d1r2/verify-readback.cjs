const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const read = file => JSON.parse(fs.readFileSync(path.join(__dirname,file),'utf8').replace(/^\uFEFF/,''));
const before=read('wordpress-before.json'), after=read('wordpress-after.json'), browser=read('browser-readback.json');
const cb=read('containers-before.json'), ca=read('containers-after.json');
// Docker inspect does not guarantee mount-list ordering.
const sort = a => a.map(c=>({...c,mounts:[...c.mounts].sort((x,y)=>x.Destination.localeCompare(y.Destination))})).sort((x,y)=>x.id.localeCompare(y.id));
const other = a => sort(a.filter(c=>c.project!=='birthday-magazine-g3c'));
const lines = f => fs.readFileSync(path.join(__dirname,f),'utf8').trim().split(/\r?\n/).sort();
assert.deepEqual(before,after,'WordPress read projection changed');
assert.equal(before.home_sha256,'3f678c490ff78f91d0918aacf4edd236d58500dced0a3ac229f0c865e86e1269');
assert.equal(before.groups.length,8);
assert.equal(before.gutenberg,true);
assert.equal(before.owner_administrator,true);
assert.equal(before.preview_shortcode_present,true);
assert.equal(before.product.price,'39.99');
assert.equal(before.product.currency,'USD');
assert.equal(before.product.virtual,true);
assert.deepEqual(other(cb),other(ca));
assert.deepEqual(sort(cb).map(c=>({id:c.id,mounts:c.mounts,image:c.image})),sort(ca).map(c=>({id:c.id,mounts:c.mounts,image:c.image})));
assert.deepEqual(lines('volumes-before.txt'),lines('volumes-after.txt'));
assert.deepEqual(lines('networks-before.txt'),lines('networks-after.txt'));
assert.ok(read('source-correlation.json').every(f=>f.match));
for(const v of browser.viewports){
 assert.equal(v.homeStatus,200);assert.equal(v.home.innerWidth,v.width);assert.equal(v.home.scrollWidth,v.width);
 assert.equal(v.home.previewCount,1);assert.equal(v.home.previewHasPhoto,'false');
 assert.equal(v.home.groups.length,8);assert.equal(v.errors.length,0);assert.equal(v.failedResponses.length,0);assert.equal(v.home.brokenImages.length,0);
 assert.ok(v.routes.every(r=>r.status===200));
 assert.ok(v.routes.find(r=>r.name==='cart').dom.cartEmpty);
 assert.ok(v.routes.find(r=>r.name==='checkout').finalUrl.endsWith('/cart/'));
 assert.ok(v.routes.find(r=>r.name==='account').dom.accountLoginPresent);
}
assert.equal(browser.blockedRequests.length,0);
assert.equal(read('checkout-redirect.json').status,302);
assert.equal(read('checkout-redirect.json').location,'http://127.0.0.1:8189/cart/');
assert.ok(Object.values(browser.actions).every(n=>n===0));
const files=fs.readdirSync(path.join(__dirname,'screenshots')).filter(f=>f.endsWith('.png')).sort().map(file=>{
 const bytes=fs.readFileSync(path.join(__dirname,'screenshots',file));assert.equal(bytes.subarray(1,4).toString(),'PNG');
 return {file,bytes:bytes.length,width:bytes.readUInt32BE(16),height:bytes.readUInt32BE(20),sha256:crypto.createHash('sha256').update(bytes).digest('hex')};
});
assert.equal(files.length,14);
fs.writeFileSync(path.join(__dirname,'screenshot-manifest.json'),JSON.stringify(files,null,2)+'\n');
const result={gate:'G3CR6R3D1R2_LOCAL_HOMEPAGE_READBACK_CLOSURE',result:'PASS_CANDIDATE',approvedHead:'48191f6f0b95eb4be169746f8eac9c1d7ca5365a',main:'abc5216da1c29841aeca58fb1c4ef653c19a0017',localSyncMerge:'ce8df2b0a34bf8206fe4d5acec24a7387c4f7192',
 sourceProjectMatchesApprovedHead:true,focuslyEvidenceReused:66,previewInteraction:'KEEP_AS_IS_NOT_EXERCISED',
 homeReadback:'PASS_1440_AND_375',runtimeContainersRecreated:0,runtimeContainersStarted:['361d58eb5454','21892d72baeb','35d286e7af50'],dockerDesktopStartedByExecutor:false,
 wpcli:'RETAINED_STOPPED',unrelatedContainerProjectionUnchanged:true,allContainerIdentitiesMountsImagesUnchanged:true,volumeNamesUnchanged:true,networkIdsNamesUnchanged:true,
 wordpressProjectionUnchanged:true,orderCountBefore:before.order_count,orderCountAfter:after.order_count,generationJobs:after.generation_jobs,productModelCalls:after.product_model_calls,
 checkoutEvidence:'GET_302_TO_EMPTY_CART_200_NO_FORM_CLAIM',screenshotCount:files.length,
 knownIssues:['Stored mobile-menu Sample Pages target #sample-pages absent; current section is #samples','Rendered footer Privacy policy href empty'],
 limits:['No fresh Preview interaction/network privacy test; accepted evidence and identical source hashes reused','No account login or private workspace authorization replay; unchanged accepted guard hash reused','Only application/option/order-count projection checked, not whole-database bitwise identity; normal runtime housekeeping not claimed absent'],
 actions:{frontendMutation:0,wordpressContentMutation:0,themeChange:0,cartChange:0,checkoutSubmission:0,orderCreation:0,paypal:0,model:0,build:0,pull:0,recreate:0,volumeReset:0,migration:0,globalDockerConfiguration:0,sharedInfra:0,deployment:0,mergePR:0,D2:0,G4:0},stopAtReviewer:true,ownerRelay:'NONE'};
fs.writeFileSync(path.join(__dirname,'closure-status.json'),JSON.stringify(result,null,2)+'\n');
console.log(JSON.stringify(result));
