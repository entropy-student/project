// Owner-approved reference reproduction: presentation only, never commerce/provider.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const crypto=require('node:crypto');
const project=path.resolve(__dirname,'../../..'),repo=path.dirname(project);
const baseline='f84470a70137d1bd77b58567a9be608b82e1b750';
const container='birthday-magazine-g3c-wordpress-1';
const mount=JSON.parse(execFileSync('docker',['inspect','--format','{{json .Mounts}}',container])).find(x=>x.Destination==='/var/www/html/wp-content/plugins/bms-g3c-preview');
assert(mount&&mount.Type==='bind','Existing project Preview bind required');
const runtime=mount.Source.replace(/^\/run\/desktop\/mnt\/host\/([a-z])\//i,(_,drive)=>drive.toUpperCase()+':/');
assert(fs.existsSync(path.join(runtime,'magazine-preview.css')),'Windows mount source must be accessible');
const source=path.join(project,'poc/g3c/preview-plugin');
const backup=path.join(project,'poc/g3c/.tmp/preview-gift-20261005');
const evidence=path.join(project,'docs/evidence/g3cr7v2r4-preview-gift');
const files=['magazine-preview.css','birthday-magazine-poc.php'];
const hash=x=>crypto.createHash('sha256').update(x).digest('hex');
const norm=x=>x.toString().replace(/\r\n/g,'\n');
function state(){return JSON.parse(execFileSync('docker',['exec','-i',container,'php'],{encoding:'utf8',input:"<?php define('DISABLE_WP_CRON',true);require '/var/www/html/wp-load.php';$owner=get_user_by('login','bms-owner');echo wp_json_encode(['homeSHA256'=>hash('sha256',get_post_field('post_content',858)),'themeModsSHA256'=>hash('sha256',wp_json_encode(get_theme_mods())),'ownerEdit'=>user_can($owner,'edit_post',858),'gutenberg'=>use_block_editor_for_post(858),'orders'=>count(wc_get_orders(['return'=>'ids','limit'=>-1])),'jobs'=>(int)get_option('bms_g3a_generation_job_count',0),'modelCalls'=>(int)get_option('bms_g3a_model_call_count',0)]);"}));}
assert.equal(execFileSync('docker',['inspect','--format','{{.Id}}',container]).toString().trim(),'21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00');
assert.equal(execFileSync('docker',['inspect','--format','{{.State.Running}}',container]).toString().trim(),'true');
const mode=process.argv[2];
if(mode==='backup'){
 assert(!fs.existsSync(backup),'Never overwrite rollback');
 assert.equal(execFileSync('git',['rev-parse','HEAD'],{cwd:repo}).toString().trim(),baseline);
 fs.mkdirSync(backup,{recursive:true});fs.mkdirSync(evidence,{recursive:true});
 const entries=[];
 for(const file of files)for(const role of ['source','runtime']){
  const p=path.join(role==='source'?source:runtime,file),bytes=fs.readFileSync(p),dest=path.join(backup,role,file);
  assert.equal(norm(bytes),norm(execFileSync('git',['show',baseline+':birthday-magazine-studio/poc/g3c/preview-plugin/'+file],{cwd:repo})));
  fs.mkdirSync(path.dirname(dest),{recursive:true});fs.writeFileSync(dest,bytes);entries.push({role,file,sha256:hash(bytes),mtime:fs.statSync(p).mtimeMs});
 }
 const before=state();assert(before.ownerEdit&&before.gutenberg);
 fs.writeFileSync(path.join(backup,'manifest.json'),JSON.stringify({baseline,container,runtime,files:entries,before},null,2));
 console.log(JSON.stringify({backup,before}));
}else if(mode==='publish'){
 const manifest=JSON.parse(fs.readFileSync(path.join(backup,'manifest.json')));
 assert.deepEqual(state(),manifest.before,'WordPress state drift');
 for(const file of files){
  assert.equal(hash(fs.readFileSync(path.join(runtime,file))),manifest.files.find(x=>x.role==='runtime'&&x.file===file).sha256,'Runtime drift');
  fs.copyFileSync(path.join(source,file),path.join(runtime,file));const s=fs.statSync(path.join(source,file));fs.utimesSync(path.join(runtime,file),s.atime,s.mtime);
 }
 const assets='assets/preview-gift-20261005';assert(!fs.existsSync(path.join(runtime,assets)),'Never overwrite local-only assets');
 fs.cpSync(path.join(source,assets),path.join(runtime,assets),{recursive:true});
 console.log(JSON.stringify({published:true}));
}else if(mode==='verify'){
 const manifest=JSON.parse(fs.readFileSync(path.join(backup,'manifest.json'))),after=state();assert.deepEqual(after,manifest.before);
 const changed=[...files,...fs.readdirSync(path.join(source,'assets/preview-gift-20261005')).map(x=>'assets/preview-gift-20261005/'+x)];
 const identities=changed.map(file=>{const a=hash(fs.readFileSync(path.join(source,file))),b=hash(fs.readFileSync(path.join(runtime,file)));assert.equal(a,b);return{file,sourceSHA256:a,runtimeSHA256:b,exact:true};});
 const protectedFiles=['preview.js','frontend-reproduction.js','frontend-reproduction.php','frontend-reproduction.css','home.css','home-motion.js','studio.css'];
 const frozen=protectedFiles.map(file=>{const original=execFileSync('git',['show',baseline+':birthday-magazine-studio/poc/g3c/preview-plugin/'+file],{cwd:repo}),s=fs.readFileSync(path.join(source,file)),r=fs.readFileSync(path.join(runtime,file));assert.equal(norm(s),norm(original));assert.equal(norm(r),norm(original));return{file,normalizedSHA256:hash(norm(s)),unchanged:true};});
 const prior=norm(fs.readFileSync(path.join(backup,'source/birthday-magazine-poc.php'))),current=norm(fs.readFileSync(path.join(source,'birthday-magazine-poc.php')));
 assert.equal(current.split("add_shortcode('bms_preview'")[0],prior.split("add_shortcode('bms_preview'")[0]);assert.equal(current.split("require_once __DIR__")[1],prior.split("require_once __DIR__")[1]);
 const priorCSS=norm(fs.readFileSync(path.join(backup,'source/magazine-preview.css'))),currentCSS=norm(fs.readFileSync(path.join(source,'magazine-preview.css')));
 assert.equal(currentCSS.split('/* Owner-approved gift reference:')[0],priorCSS.split('/* Owner-approved Preview emphasis;')[0]);
 const verifiedBackups=manifest.files.map(x=>{assert.equal(hash(fs.readFileSync(path.join(backup,x.role,x.file))),x.sha256);return{...x,verified:true};});
 const report={baseline,container,before:manifest.before,after,identities,frozen,verifiedBackups,homeAndThemeUnchanged:true,businessPHPOutsideShortcodeUnchanged:true,cssBeforeHomeGiftOverrideUnchanged:true,runtimeRetained:true,backupPath:backup,paymentActions:0,checkoutSubmissions:0,productModelCalls:0};
 fs.writeFileSync(path.join(evidence,'runtime-boundary.json'),JSON.stringify(report,null,2));console.log(JSON.stringify({exact:true,homeAndThemeUnchanged:true,orders:after.orders,jobs:after.jobs,modelCalls:after.modelCalls}));
}else throw Error('Use backup, publish or verify');
