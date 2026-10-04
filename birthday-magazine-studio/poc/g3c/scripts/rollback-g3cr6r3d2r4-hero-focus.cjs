const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const project=path.resolve(__dirname,'../../..'),backup=path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r4-hero-focus'),out=path.join(project,'docs/evidence/g3cr6r3d2r4-hero-focus');
const hash=b=>crypto.createHash('sha256').update(b).digest('hex');
const manifest=JSON.parse(fs.readFileSync(path.join(backup,'manifest.json'),'utf8')),home=JSON.parse(fs.readFileSync(path.join(backup,'home.json'),'utf8'));
if(home.id!==858||hash(home.content)!==manifest.homeSha256)throw Error('Backup Home integrity failed');
for(const item of manifest.sources)if(hash(fs.readFileSync(path.join(backup,item.file)))!==item.sha256)throw Error('Backup source integrity failed');
// Exercise copy/read-back into an isolated project-local staging directory.
const temp=fs.mkdtempSync(path.join(out,'rollback-check-'));
try {
 for(const file of ['home.css','home-motion.js']){
  fs.copyFileSync(path.join(backup,file),path.join(temp,file));
  if(hash(fs.readFileSync(path.join(temp,file)))!==manifest.sources.find(s=>s.file===file).sha256)throw Error('Restored byte mismatch');
 }
}finally{for(const file of ['home.css','home-motion.js'])if(fs.existsSync(path.join(temp,file)))fs.unlinkSync(path.join(temp,file));fs.rmdirSync(temp);}
const apply=process.argv[2]==='--apply';
if(apply){
 // No DB/API call: R4 has no persistent Home or menu changes to revert.
 for(const file of ['home.css','home-motion.js'])fs.copyFileSync(path.join(backup,file),path.join(project,'poc/g3c/preview-plugin',file));
}
const report={mode:apply?'APPLIED':'STAGED_BYTE_ROUNDTRIP_ONLY',backupHomeHashValid:true,backupSourceHashesValid:true,stagedCopyReadback:true,restoresTo:'Prior Owner-video R4 198aed6 motion/presentation',homeSha256:manifest.homeSha256,restoredFiles:['home.css','home-motion.js'],homeDatabaseMutation:false,menusMutation:false,assetsMutation:false,liveRollbackExecuted:apply};
fs.writeFileSync(path.join(out,'rollback-proof.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
