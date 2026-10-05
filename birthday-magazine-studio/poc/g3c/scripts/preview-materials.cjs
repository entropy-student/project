// Owner-approved frontend finish. No WordPress content, order or provider writes.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {execFileSync}=require('node:child_process');
const project=path.resolve(__dirname,'../../..'),repo=path.dirname(project),baseline='66b0cf0088d60e77469513ac6ed36ab7b8a9b5f5';
const container='birthday-magazine-g3c-wordpress-1',source=path.join(project,'poc/g3c/preview-plugin');
const mount=JSON.parse(execFileSync('docker',['inspect','--format','{{json .Mounts}}',container])).find(x=>x.Destination==='/var/www/html/wp-content/plugins/bms-g3c-preview');
assert(mount&&mount.Type==='bind');
const runtime=mount.Source.replace(/^\/run\/desktop\/mnt\/host\/([a-z])\//i,(_,d)=>d.toUpperCase()+':/');
const backup=path.join(project,'poc/g3c/.tmp/preview-materials-20261006'),evidence=path.join(project,'docs/evidence/g3cr7v2r4-preview-materials');
const files=['magazine-preview.css','home.css','birthday-magazine-poc.php','frontend-reproduction.css'];
const hash=x=>crypto.createHash('sha256').update(x).digest('hex'),norm=x=>x.toString().replace(/\r\n/g,'\n');
function state(){return JSON.parse(execFileSync('docker',['exec','-i',container,'php'],{encoding:'utf8',input:"<?php define('DISABLE_WP_CRON',true);require '/var/www/html/wp-load.php';$owner=get_user_by('login','bms-owner');echo wp_json_encode(['homeSHA256'=>hash('sha256',get_post_field('post_content',858)),'themeModsSHA256'=>hash('sha256',wp_json_encode(get_theme_mods())),'ownerEdit'=>user_can($owner,'edit_post',858),'gutenberg'=>use_block_editor_for_post(858),'orders'=>count(wc_get_orders(['return'=>'ids','limit'=>-1])),'jobs'=>(int)get_option('bms_g3a_generation_job_count',0),'modelCalls'=>(int)get_option('bms_g3a_model_call_count',0)]);"}));}
assert.equal(execFileSync('docker',['inspect','--format','{{.State.Running}}',container]).toString().trim(),'true');
const mode=process.argv[2];
if(mode==='backup'){
 assert(!fs.existsSync(backup),'Never overwrite rollback');assert.equal(execFileSync('git',['rev-parse','HEAD'],{cwd:repo}).toString().trim(),baseline);
 fs.mkdirSync(backup,{recursive:true});fs.mkdirSync(evidence,{recursive:true});const entries=[];
 for(const file of files)for(const role of ['source','runtime']){
  const p=path.join(role==='source'?source:runtime,file),b=fs.readFileSync(p),original=execFileSync('git',['show',baseline+':birthday-magazine-studio/poc/g3c/preview-plugin/'+file],{cwd:repo});
  assert.equal(norm(b),norm(original),'Source/runtime drift: '+file);const dest=path.join(backup,role,file);fs.mkdirSync(path.dirname(dest),{recursive:true});fs.writeFileSync(dest,b);entries.push({file,role,sha256:hash(b),mtime:fs.statSync(p).mtimeMs});
 }
 const before=state();assert(before.ownerEdit&&before.gutenberg);const id=execFileSync('docker',['inspect','--format','{{.Id}}',container]).toString().trim();
 fs.writeFileSync(path.join(backup,'manifest.json'),JSON.stringify({baseline,container,id,runtime,files:entries,before},null,2));console.log(JSON.stringify({backup,before}));
}else if(mode==='publish'){
 const m=JSON.parse(fs.readFileSync(path.join(backup,'manifest.json')));assert.deepEqual(state(),m.before);
 for(const file of files){assert.equal(hash(fs.readFileSync(path.join(runtime,file))),m.files.find(x=>x.file===file&&x.role==='runtime').sha256,'Runtime drift');fs.copyFileSync(path.join(source,file),path.join(runtime,file));const t=fs.statSync(path.join(source,file));fs.utimesSync(path.join(runtime,file),t.atime,t.mtime);}
 const assets='assets/preview-materials-20261006';assert(!fs.existsSync(path.join(runtime,assets)));fs.cpSync(path.join(source,assets),path.join(runtime,assets),{recursive:true});console.log('Scoped candidate published');
}else if(mode==='verify'){
 const m=JSON.parse(fs.readFileSync(path.join(backup,'manifest.json'))),after=state();assert.deepEqual(after,m.before);assert.equal(execFileSync('docker',['inspect','--format','{{.Id}}',container]).toString().trim(),m.id);
 const identities=[...files,...fs.readdirSync(path.join(source,'assets/preview-materials-20261006')).map(x=>'assets/preview-materials-20261006/'+x)].map(file=>{const a=hash(fs.readFileSync(path.join(source,file))),b=hash(fs.readFileSync(path.join(runtime,file)));assert.equal(a,b);return{file,sourceSHA256:a,runtimeSHA256:b,exact:true};});
 const frozen=['preview.js','frontend-reproduction.js','frontend-reproduction.php','home-motion.js','studio.css'].map(file=>{const b=norm(execFileSync('git',['show',baseline+':birthday-magazine-studio/poc/g3c/preview-plugin/'+file],{cwd:repo}));assert.equal(norm(fs.readFileSync(path.join(source,file))),b);assert.equal(norm(fs.readFileSync(path.join(runtime,file))),b);return{file,normalizedSHA256:hash(b),unchanged:true};});
 const prior=norm(fs.readFileSync(path.join(backup,'source/birthday-magazine-poc.php'))),current=norm(fs.readFileSync(path.join(source,'birthday-magazine-poc.php')));
 const strip=s=>s.replace("['bms-studio'], filemtime(__DIR__ . '/home.css')","['bms-studio'], '0.3.0'").replace('>The style</label>','>The mood</label>');assert.equal(strip(current),prior,'Only stylesheet cache version and display label permitted');
 const copies=m.files.map(x=>{assert.equal(hash(fs.readFileSync(path.join(backup,x.role,x.file))),x.sha256);return{...x,verified:true};});
 const report={baseline,container,before:m.before,after,identities,frozen,verifiedBackups:copies,PHPOnlyHomeCSSVersionAndStyleLabel:true,homeAndThemeUnchanged:true,runtimeRetained:true,wooExcluded:true,ordersChanged:0,paymentActions:0,modelCalls:0};fs.writeFileSync(path.join(evidence,'runtime-boundary.json'),JSON.stringify(report,null,2));console.log(JSON.stringify({exact:true,homeAndThemeUnchanged:true,orders:after.orders,jobs:after.jobs,modelCalls:after.modelCalls}));
}else throw Error('Use backup, publish or verify');
