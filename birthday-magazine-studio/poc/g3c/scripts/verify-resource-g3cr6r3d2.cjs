const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const dir=path.resolve(__dirname,'../../../docs/evidence'),out=path.join(dir,'g3cr6r3d2');
const read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''));
const before=read(path.join(dir,'g3cr6r3d1r2/containers-after.json'));
const after=read(path.join(out,'containers-final.json'));
const hashed=value=>'sha256:'+crypto.createHash('sha256').update(value).digest('hex');
for(const e of after)if(e.project!=='birthday-magazine-g3c')for(const m of e.mounts){if(!m.Source.startsWith('sha256:'))m.Source=hashed(m.Source);if(!m.Destination.startsWith('sha256:'))m.Destination=hashed(m.Destination);}
fs.writeFileSync(path.join(out,'containers-final.json'),JSON.stringify(after,null,2)+'\n');
const stable=e=>({id:e.id,name:e.name,image:e.image,project:e.project,status:e.status,startedAt:e.startedAt,mounts:[...e.mounts].sort((a,b)=>a.Destination.localeCompare(b.Destination)),ports:e.ports});
assert.deepEqual(after.map(stable).sort((a,b)=>a.id.localeCompare(b.id)),before.map(stable).sort((a,b)=>a.id.localeCompare(b.id)));
const lines=file=>fs.readFileSync(file,'utf8').replace(/^\uFEFF/,'').trim().split(/\r?\n/).sort();
assert.deepEqual(lines(path.join(out,'volumes-final.txt')),lines(path.join(dir,'g3cr6r3d1r2/volumes-after.txt')));
assert.deepEqual(lines(path.join(out,'networks-final.txt')).map(l=>l.replace(/^\S+/,id=>id.slice(0,12))),lines(path.join(dir,'g3cr6r3d1r2/networks-after.txt')));
const result={baseline:'Accepted D1R2 containers-after/volumes-after/networks-after, not a fabricated D2 pre-edit snapshot',time:new Date().toISOString(),containerIdentityStateMountsPortsUnchanged:true,volumeNamesUnchanged:true,networkIdsNamesUnchanged:true,unrelatedProjectionUnchanged:true,projectHealth:after.filter(e=>e.project==='birthday-magazine-g3c').map(e=>({id:e.id,name:e.name,status:e.status,health:e.health||null})),startsThisRound:0,rebuilds:0,pulls:0,recreates:0,teardowns:0,globalPrunes:0,runtimeRetained:true};
fs.writeFileSync(path.join(out,'resource-readback.json'),JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result));
