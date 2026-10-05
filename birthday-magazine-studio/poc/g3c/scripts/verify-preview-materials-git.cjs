// Verify committed evidence and source against local files, without runtime writes.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),assert=require('node:assert/strict');
const {execFileSync}=require('node:child_process');
const project=path.resolve(__dirname,'../../..'),repo=path.dirname(project),prefix='birthday-magazine-studio/',evidence=path.join(project,'docs/evidence/g3cr7v2r4-preview-materials');
const hash=b=>crypto.createHash('sha256').update(b).digest('hex'),norm=b=>b.toString().replace(/\r\n/g,'\n');
const sha=execFileSync('git',['rev-parse',process.argv[2]||'HEAD'],{cwd:repo}).toString().trim();
function blob(file){return execFileSync('git',['show',sha+':'+prefix+file],{cwd:repo,maxBuffer:32*1024*1024});}
const images=JSON.parse(fs.readFileSync(path.join(evidence,'image-manifest.json'))).map(x=>{const b=blob('docs/evidence/g3cr7v2r4-preview-materials/'+x.file);assert.equal(hash(b),x.sha256);return{file:x.file,committedSHA256:hash(b),verified:true};});
const assets=JSON.parse(fs.readFileSync(path.join(evidence,'asset-manifest.json'))).assets.map(x=>{const b=blob('poc/g3c/preview-plugin/assets/preview-materials-20261006/'+x.file),s=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin/assets/preview-materials-20261006',x.file));if(x.file.endsWith('.txt'))assert.equal(norm(b),norm(s));else assert.equal(hash(b),x.sha256);return{file:x.file,localSHA256:hash(s),committedSHA256:hash(b),newlineNormalizedText:x.file.endsWith('.txt'),verified:true};});
const sources=['home.css','magazine-preview.css','frontend-reproduction.css','birthday-magazine-poc.php'].map(file=>{const b=blob('poc/g3c/preview-plugin/'+file),s=fs.readFileSync(path.join(project,'poc/g3c/preview-plugin',file));assert.equal(norm(b),norm(s));return{file,localSHA256:hash(s),committedSHA256:hash(b),newlineNormalizedEquivalent:true};});
fs.writeFileSync(path.join(evidence,'git-readback.json'),JSON.stringify({implementationCommit:sha,images,assets,sources,allVerified:true,gitGlobalConfigChanged:false},null,2));console.log(JSON.stringify({implementationCommit:sha,images:images.length,assets:assets.length,sources:sources.length,allVerified:true}));
