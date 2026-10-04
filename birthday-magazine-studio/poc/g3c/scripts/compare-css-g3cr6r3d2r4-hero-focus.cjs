// Offline CSSOM analysis on about:blank; no site request or screenshot.
const fs=require('node:fs'),path=require('node:path');
const {chromium}=require('../.tmp/browser-tools/node_modules/playwright-core');
const project=path.resolve(__dirname,'../../..'),dir=path.join(project,'docs/evidence/g3cr6r3d2r4-hero-focus');
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 try{
  const page=await browser.newPage();
  const result=await page.evaluate(([before,after])=>{
   const project=text=>{const sheet=new CSSStyleSheet();sheet.replaceSync(text);let styleRules=0;
    const walk=rules=>[...rules].flatMap(rule=>{
     if(rule.selectorText&&/bms-(hero|focus-background|focus-frame|focus-sharp|focus-tag|hero-message)/.test(rule.selectorText))return [];
     if(rule.name&&/^bms-focus-/.test(rule.name))return [];
     if(rule.selectorText){styleRules++;return[rule.cssText];}
     if(rule.cssRules){const children=walk(rule.cssRules);return children.length?[{condition:rule.conditionText||rule.name||rule.constructor.name,children}]:[];}
     return[rule.cssText];
    });return{rules:walk(sheet.cssRules),styleRules};
   };const a=project(before),b=project(after);return{equal:JSON.stringify(a)===JSON.stringify(b),styleRules:a.styleRules,baseline:a,current:b};
  },[fs.readFileSync(path.join(project,'poc/g3c/artifacts/backups/g3cr6r3d2r4-hero-focus/home.css'),'utf8'),fs.readFileSync(path.join(project,'poc/g3c/preview-plugin/home.css'),'utf8')]);
  fs.writeFileSync(path.join(dir,'non-hero-css-projection.json'),JSON.stringify({source:'Offline CSSOM; corrected style-rule handling; supersedes round2/browser.json nonHeroCss',...result},null,2)+'\n');
  console.log(JSON.stringify({equal:result.equal,styleRules:result.styleRules}));
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
