const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),{execFileSync}=require('node:child_process');
const project=path.resolve(__dirname,'../../..'),backup=path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r2'),out=path.join(project,'docs/evidence/g3cr6r3d2r2');
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const read=f=>JSON.parse(fs.readFileSync(path.join(backup,f),'utf8'));
const home=read('home.json'),manifest=read('manifest.json');
if(home.id!==858||hash(home.content)!==manifest.homeSha256)throw Error('Rollback Home integrity failed');
for(const item of manifest.sources)if(hash(fs.readFileSync(path.join(backup,item.file)))!==item.sha256)throw Error('Rollback source integrity failed');
const apply=process.argv[2]==='--apply';
if(apply){
 const ids=execFileSync('docker',['ps','--filter','label=com.docker.compose.project=birthday-magazine-g3c','--filter','label=com.docker.compose.service=wordpress','-q'],{encoding:'utf8'}).trim();
 if(!ids||ids.includes('\n'))throw Error('Exact running WP target unavailable');
 const content64=Buffer.from(home.content).toString('base64');
 const php="define('DISABLE_WP_CRON',true);require '/var/www/html/wp-load.php';if(get_option('page_on_front')!=858||hash('sha256',get_post_field('post_content',858))!=='7369f833ad51a539e7205ee255cad11b236a28bf6b9e9f11a6e1d9cdc10a937a')throw new RuntimeException('Rollback runtime drift');$r=wp_update_post(['ID'=>858,'post_content'=>base64_decode('"+content64+"')],true);if(is_wp_error($r))throw new RuntimeException('Restore failed');echo hash('sha256',get_post_field('post_content',858));";
 const restored=execFileSync('docker',['exec',ids,'php','-r',php],{encoding:'utf8'}).trim();
 if(restored!==manifest.homeSha256)throw Error('Restored Home hash mismatch');
 for(const item of manifest.sources)fs.copyFileSync(path.join(backup,item.file),path.join(project,'poc/g3c/preview-plugin',item.file));
}
const report={mode:apply?'APPLIED':'DRY_RUN_ONLY',backupHomeHashValid:true,backupSourceHashesValid:true,restoresTo:'Accepted D2 Home/CSS, not pre-D2',homeId:858,homeSha256:manifest.homeSha256,newAssetsPolicy:'Five new static files remain inert/unreferenced; no upload/DB deletion',menuRestoreRequired:false,protectedBusinessMutation:false};
fs.writeFileSync(path.join(out,'rollback-proof.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
