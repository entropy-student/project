const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),{execFileSync}=require('node:child_process');
const root=path.resolve(__dirname,'../../../..'),project=path.join(root,'birthday-magazine-studio'),phase=process.argv[2]||'before';
if(!['before','after'].includes(phase))throw Error('Invalid phase');
const evidence=path.join(project,'docs/evidence/g3cr6r3d2r4'),backup=path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r4');
if(phase==='before'&&fs.existsSync(backup))throw Error('Do not overwrite accepted pre-write rollback/evidence');
const run=(exe,args)=>execFileSync(exe,args,{cwd:root,encoding:'utf8',maxBuffer:16*1024*1024}).trim();
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
fs.mkdirSync(evidence,{recursive:true});
const ids=run('docker',['ps','-aq']).split(/\s+/).filter(Boolean);
// Request metadata only: never fetch container Env or credential-bearing config.
const projection='{"Id":{{json .Id}},"Name":{{json .Name}},"Config":{"Image":{{json .Config.Image}},"Labels":{"com.docker.compose.project":{{json (index .Config.Labels "com.docker.compose.project")}},"com.docker.compose.service":{{json (index .Config.Labels "com.docker.compose.service")}}}},"State":{"Status":{{json .State.Status}},"StartedAt":{{json .State.StartedAt}},"Health":{{if (index .State "Health")}}{"Status":{{json (index (index .State "Health") "Status")}}}{{else}}null{{end}}},"Mounts":{{json .Mounts}},"NetworkSettings":{"Ports":{{json .NetworkSettings.Ports}}}}';
const objects=run('docker',['inspect','--format',projection,...ids]).split('\n').map(line=>JSON.parse(line));
const containers=objects.map(e=>({id:e.Id,name:e.Name,image:e.Config.Image,project:e.Config.Labels?.['com.docker.compose.project']||null,state:e.State.Status,startedAt:e.State.StartedAt,health:e.State.Health?.Status||null,mounts:e.Mounts.map(m=>({type:m.Type,name:m.Name||null,sourceHash:hash(m.Source),destinationHash:hash(m.Destination),rw:m.RW})).sort((a,b)=>a.destinationHash.localeCompare(b.destinationHash)),ports:e.NetworkSettings.Ports})).sort((a,b)=>a.id.localeCompare(b.id));
const wp=objects.find(e=>e.Config.Labels?.['com.docker.compose.project']==='birthday-magazine-g3c'&&e.Config.Labels?.['com.docker.compose.service']==='wordpress');
if(!wp||wp.State.Status!=='running')throw Error('Current WP runtime unavailable; no rebuild permitted');
let php=fs.readFileSync(path.join(project,'docs/evidence/g3cr6r3d1r2/readback.php'),'utf8').replace(/^<\?php\s*/,'');
const wpState=JSON.parse(run('docker',['exec',wp.Id,'php','-r',php]));
const resources={containers,volumes:run('docker',['volume','ls','--format','{{.Name}}']).split('\n').sort(),networks:run('docker',['network','ls','--format','{{.ID}} {{.Name}}']).split('\n').sort()};
fs.writeFileSync(path.join(evidence,'runtime-'+phase+'.json'),JSON.stringify(wpState,null,2)+'\n');
fs.writeFileSync(path.join(evidence,'resources-'+phase+'.json'),JSON.stringify(resources,null,2)+'\n');
if(phase==='before'){
 if(wpState.home_id!==858||wpState.home_sha256!=='7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a')throw Error('Accepted D2 Home drift');
 fs.mkdirSync(backup,{recursive:true});
 const home=JSON.parse(run('docker',['exec',wp.Id,'php','-r',"define('DISABLE_WP_CRON',true); require '/var/www/html/wp-load.php'; echo wp_json_encode(['id'=>858,'content'=>get_post_field('post_content',858)], JSON_UNESCAPED_SLASHES);"]));
 fs.writeFileSync(path.join(backup,'home.json'),JSON.stringify(home,null,2)+'\n');
 const files=['home.css','home-motion.js','birthday-magazine-poc.php'];
 const sources=files.map(file=>{const bytes=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin',file));fs.writeFileSync(path.join(backup,file),bytes);return{file,sha256:hash(bytes),bytes:bytes.length};});
 fs.writeFileSync(path.join(backup,'.gitattributes'),'*.css -text\n*.js -text\n*.php -text\n');
 fs.writeFileSync(path.join(backup,'manifest.json'),JSON.stringify({branch:run('git',['branch','--show-current']),head:run('git',['rev-parse','HEAD']),homeSha256:hash(home.content),sources,menus:wpState.menus,newAssetDirectoryPreviouslyAbsent:!fs.existsSync(path.join(project,'poc/g3c/preview-plugin/assets/g3cr6r3d2r4')),rollbackTarget:'Accepted D2R2 static and motion state; not pre-D2'},null,2)+'\n');
}else{
 const before=JSON.parse(fs.readFileSync(path.join(evidence,'resources-before.json'),'utf8'));
 before.containers.forEach(c=>c.mounts.sort((a,b)=>a.destinationHash.localeCompare(b.destinationHash)));
 const unchanged=JSON.stringify(resources)===JSON.stringify(before);
 fs.writeFileSync(path.join(evidence,'resource-readback.json'),JSON.stringify({unchanged,runtimeRetained:true,starts:0,rebuilds:0,pulls:0,recreates:0,teardowns:0,globalPrunes:0},null,2)+'\n');
 if(!unchanged)throw Error('Resource projection drift');
}
console.log(JSON.stringify({phase,homeSha256:wpState.home_sha256,wp:wpState.wordpress,woo:wpState.woocommerce,orders:wpState.order_count,modelCalls:wpState.product_model_calls,backup:phase==='before'?backup:undefined}));
