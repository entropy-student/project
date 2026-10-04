// Restore only D2 Home/menu/source. Dry by default; never resets a database/volume.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),cp=require('node:child_process');
const root=path.resolve(__dirname,'..'),backupDir=path.join(root,'artifacts/backups/g3cr6r3d2');
const manifest=JSON.parse(fs.readFileSync(path.join(backupDir,'backup-manifest.json'),'utf8').replace(/^\uFEFF/,''));
for(const item of manifest.files){
 const bytes=fs.readFileSync(path.join(backupDir,item.file));
 if(crypto.createHash('sha256').update(bytes).digest('hex')!==item.sha256)throw Error('Backup hash mismatch: '+item.file);
}
const backup=JSON.parse(fs.readFileSync(path.join(backupDir,'content-menu-backup.json'),'utf8').replace(/^\uFEFF/,''));
const mode=process.argv.includes('--apply')?'apply':'dry';
const php=fs.readFileSync(path.join(__dirname,'restore-home-g3cr6r3d2.php'),'utf8');
// The PHP program is command code; restoration data only travels on stdin.
const r=cp.spawnSync('docker',['exec','-i','21892d72baeb','php','-r',php.replace(/^<\?php\s*/, '')],{input:JSON.stringify({mode,backup}),encoding:'utf8'});
if(r.status!==0)throw Error('Rollback helper failed: '+r.stderr);
const result=JSON.parse(r.stdout);
if(mode==='apply'){
 for(const file of ['home.css','birthday-magazine-poc.php'])fs.copyFileSync(path.join(backupDir,file),path.join(root,'preview-plugin',file));
 if(!manifest.home_motion_previously_exists){
  const target=path.resolve(root,'preview-plugin/home-motion.js');
  if(target!==path.join(root,'preview-plugin','home-motion.js'))throw Error('Source path guard failed');
  if(fs.existsSync(target))fs.unlinkSync(target);
 }
 // New homepage font assets are inert after source rollback; retain their licensed package.
}
console.log(JSON.stringify({...result,source_backup_hashes_verified:true,source_action:mode==='apply'?'restored_exact_two_files_removed_new_controller':'dry_no_source_write'},null,2));
