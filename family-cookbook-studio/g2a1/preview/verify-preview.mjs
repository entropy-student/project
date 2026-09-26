import {spawn} from 'node:child_process';
import {once} from 'node:events';
import {mkdir,readFile,writeFile,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join,resolve} from 'node:path';
import {pathToFileURL} from 'node:url';

const chrome=process.env.CHROME_PATH ?? 'C:/Users/34707/AppData/Local/ms-playwright/chromium-1187/chrome-win/chrome.exe';
const page=resolve(process.argv[2] ?? 'index.html');
const image=resolve(process.argv[3] ?? 'sample-local-image.svg');
const report=resolve(process.argv[4] ?? 'preview-observation.json');
const profile=join(tmpdir(),`family-cookbook-g2a1-chrome-${process.pid}`);
await mkdir(profile,{recursive:true});
const proc=spawn(chrome,['--headless=new','--no-first-run','--no-default-browser-check','--remote-debugging-port=0','--remote-allow-origins=*',`--user-data-dir=${profile}`,'about:blank'],{stdio:'ignore',windowsHide:true});
const childExit=once(proc,'exit').catch(()=>{});
let ws;
let closeBrowser;
try {
  const activeFile=join(profile,'DevToolsActivePort');
  let active='';
  for(let i=0;i<100;i++){
    try { active=await readFile(activeFile,'utf8'); if(active.includes('\n')) break; } catch {}
    await new Promise(r=>setTimeout(r,100));
  }
  if(!active) throw new Error('Chromium DevToolsActivePort did not appear');
  const port=Number(active.trim().split(/\r?\n/)[0]);
  const browserVersion=await (await fetch(`http://127.0.0.1:${port}/json/version`)).json();
  ws=new WebSocket(browserVersion.webSocketDebuggerUrl);
  await new Promise((resolve,reject)=>{ ws.addEventListener('open',resolve,{once:true}); ws.addEventListener('error',reject,{once:true}); });
  let serial=0; const pending=new Map(); const requests=[];
  ws.addEventListener('message',event=>{
    const message=JSON.parse(event.data);
    if(message.method==='Network.requestWillBeSent') requests.push(message.params.request.url);
    if(message.id&&pending.has(message.id)){ const p=pending.get(message.id); pending.delete(message.id); message.error?p.reject(new Error(message.error.message)):p.resolve(message.result); }
  });
  const send=(method,params={},sessionId)=>new Promise((resolve,reject)=>{
    const id=++serial; pending.set(id,{resolve,reject}); ws.send(JSON.stringify({id,method,params,sessionId}));
  });
  closeBrowser=()=>send('Browser.close');
  const {targetId}=await send('Target.createTarget',{url:'about:blank'});
  const {sessionId}=await send('Target.attachToTarget',{targetId,flatten:true});
  await send('Network.enable',{},sessionId); await send('Page.enable',{},sessionId); await send('Runtime.enable',{},sessionId);
  await send('Page.navigate',{url:pathToFileURL(page).href},sessionId);
  for(let i=0;i<100;i++){
    const v=await send('Runtime.evaluate',{expression:'document.readyState',returnByValue:true},sessionId);
    if(v.result?.value==='complete') break;
    await new Promise(r=>setTimeout(r,100));
  }
  await send('Runtime.evaluate',{expression:`(()=>{const f=document.querySelector('#family');f.value='Rivera Family';f.dispatchEvent(new Event('input',{bubbles:true}));const t=document.querySelector('#title');t.value='Sunday Table';t.dispatchEvent(new Event('input',{bubbles:true}));const s=document.querySelector('#style');s.value='sage';s.dispatchEvent(new Event('change',{bubbles:true}));})()`},sessionId);
  const {root}=await send('DOM.getDocument',{},sessionId);
  const {nodeId}=await send('DOM.querySelector',{nodeId:root.nodeId,selector:'#local-image'},sessionId);
  await send('DOM.setFileInputFiles',{files:[image],nodeId},sessionId);
  await new Promise(r=>setTimeout(r,500));
  const result=await send('Runtime.evaluate',{expression:'window.__previewEvidence()',returnByValue:true},sessionId);
  const pageEvidence={...result.result.value,documentUrl:'file://<local-preview>/index.html',imageSources:result.result.value.imageSources.map(()=> 'blob:<local-object-url>'),resourceEntries:result.result.value.resourceEntries.map(x=>x.startsWith('file:')?'file://<local-resource>':x.startsWith('blob:')?'blob:<local-object-url>':x)};
  const sanitizedRequests=requests.map(x=>x.startsWith('file:')?'file://<local-preview>/index.html':x.startsWith('blob:')?'blob:<local-object-url>':x);
  const evidence={browser:{product:browserVersion.Browser,protocol:browserVersion['Protocol-Version']},page:pageEvidence,devtoolsObservedRequests:sanitizedRequests,assertions:{twoPreviewSections:result.result.value.previewSections.length===2,localImageRead:result.result.value.localObjectUrl&&result.result.value.imageSources.length===2,noNetworkApiAttempts:Object.values(result.result.value.networkAttempts).every(x=>x===0),noHttpRequests:requests.every(x=>x.startsWith('file:')||x.startsWith('blob:')),noDownload:result.result.value.downloadLinks===0,noForm:result.result.value.forms===0}};
  evidence.assertions.all=Object.values(evidence.assertions).every(Boolean);
  await writeFile(report,JSON.stringify(evidence,null,2)+'\n');
  console.log(JSON.stringify(evidence,null,2));
  if(!evidence.assertions.all) process.exitCode=1;
} finally {
  try { closeBrowser?.(); } catch {}
  await Promise.race([childExit,new Promise(r=>setTimeout(r,3000))]);
  if(proc.exitCode===null) try { proc.kill(); } catch {}
  let cleaned=false;
  for(let i=0;i<10;i++){
    try { await rm(profile,{recursive:true,force:true}); cleaned=true; break; }
    catch { await new Promise(r=>setTimeout(r,200)); }
  }
  try { const saved=JSON.parse(await readFile(report,'utf8')); saved.cleanup={temporaryBrowserProfileRemoved:cleaned}; await writeFile(report,JSON.stringify(saved,null,2)+'\n'); if(!cleaned) process.exitCode=1; } catch {}
  try { ws?.close(); } catch {}
}
