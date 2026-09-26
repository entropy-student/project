import {mkdir,writeFile} from 'node:fs/promises';
import {spawnSync} from 'node:child_process';
import {resolve,join} from 'node:path';
import {pathToFileURL} from 'node:url';

const out=resolve(process.argv[2] ?? 'fixtures');
const chrome=process.env.CHROME_PATH ?? 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const data=[
 ['F01','clear-print','print','none','Sunday Tomato Sauce',['INGREDIENTS','1/2 tsp salt','1/4 cup olive oil','1.5 tbsp tomato paste','350°F oven','Bake 15 min.']],
 ['F02','neat-handwriting','print','hand','Lemon Loaf',['INGREDIENTS','180 g flour','120 ml milk','2 tbsp lemon juice','Bake at 180°C for 35 min.']],
 ['F03','cursive-hard','script','hand','Grandma Ida Rolls',['INGREDIENTS','3 cups flour','1 tsp yeast','1 hr rise','Bake 22 min.']],
 ['F04','skew-phone-photo','hand','skew','Apple Dumplings',['INGREDIENTS','1/2 cup sugar','2 tbsp butter','1/4 tsp cinnamon','Bake 25 min.']],
 ['F05','shadow-phone-photo','hand','shadow','Sunday Beans',['INGREDIENTS','1.5 cups beans','750 ml water','1 tsp salt','Simmer 1 hr.']],
 ['F06','low-contrast','print','low','Orange Marmalade',['INGREDIENTS','500 g oranges','350 ml water','2 cups sugar','Cook 75 min.']],
 ['F07','mixed-layout','hand','none','Skillet Cornbread',['INGREDIENTS','1 cup cornmeal','1/2 cup flour','1 tbsp honey','METHOD','Stir dry ingredients, add milk, bake 20 min.']],
 ['F08','margin-note','hand','note','Plum Jam',['INGREDIENTS','2 kg plums','1/4 cup water','1 tsp lemon juice','METHOD','Stir often. (note: use the blue pot)']],
 ['F09','abbreviation','script','hand','Quick Gravy',['INGREDIENTS','2 tbsp flour','1 c milk','pinch black pepper','Stir 5 min.']],
 ['F10','multi-line','hand','none','Chicken Noodle Soup',['INGREDIENTS','450 g chicken','2 cups carrots','1/2 tsp thyme','8 cups stock','METHOD','Simmer 45 min; add noodles for 8 min.']],
 ['F11','fraction-critical','hand','none','Shortbread',['INGREDIENTS','1/2 tsp vanilla','1/4 cup sugar','1.5 cups flour','Bake 15 min.']],
 ['F12','quantity-adversarial','script','none','Cardamom Tea',['INGREDIENTS','1/2 tsp cardamom','2 cups water','METHOD','Steep 5 min.']],
 ['F13','temperature-fahrenheit','print','none','Roast Squash',['INGREDIENTS','1 tbsp oil','350°F oven','Roast 40 min.']],
 ['F14','temperature-celsius','print','none','Baked Pears',['INGREDIENTS','2 pears','180°C oven','Bake 25 min.']],
 ['F15','timing-short','hand','none','Garlic Toast',['INGREDIENTS','2 tbsp butter','Toast 15 min.']],
 ['F16','timing-long','hand','none','Slow Onion Soup',['INGREDIENTS','3 onions','Simmer 75 min.']],
 ['F17','unit-confusion','script','hand','Herb Dressing',['INGREDIENTS','1 tsp dried dill','1 tbsp vinegar','2 tbsp oil','Mix 2 min.']],
 ['F18','metric-critical','print','none','Berry Syrup',['INGREDIENTS','250 g berries','120 ml water','1/4 cup sugar','Cook 12 min.']],
 ['F19','mixed-language','hand','none','Bilingual Crêpes',['INGREDIENTS','1 cup flour / farine','1/2 tsp salt / sel','2 eggs / oeufs','Mélanger; cook 2 min per side.']],
 ['F20','ingredient-step-interleave','hand','note','Aunt May Casserole',['INGREDIENTS','2 cups rice','1 can tomatoes','1 tbsp oil','METHOD','Wash rice. (margin: rinse twice)','Bake at 350°F for 35 min.']]
].map(([id,fixture_class,render_mode,effect,title,lines])=>({id,fixture_class,render_mode,effect,title,lines:[`RECIPE: ${title}`,...lines],synthetic:true,source:'generated SVG fixture; no customer material'}));

const xml=s=>s.replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('"','&quot;');
await mkdir(out,{recursive:true});
for(const f of data){
  const handwritten=f.render_mode==='hand'||f.render_mode==='script';
  const font=handwritten?(f.render_mode==='script'?'Segoe Script,Comic Sans MS,cursive':'Segoe Print,Comic Sans MS,cursive'):'Georgia,serif';
  const ink=f.effect==='low'?'#aaa18f':'#332b25';
  const rotated=f.effect==='skew'?'transform="rotate(-3 640 800)"':'';
  const note=f.effect==='note'?'<text x="925" y="880" font-family="Segoe Print,cursive" font-size="25" fill="#905539" transform="rotate(-7 925 880)">blue pot</text>':'';
  const shade=f.effect==='shadow'?'<rect width="1280" height="1600" fill="url(#shade)"/>':'';
  const lines=f.lines.map((t,i)=>`<text x="110" y="${250+i*72}" font-family="${font}" font-size="${i===0||t==='INGREDIENTS'||t==='METHOD'?34:31}" fill="${ink}">${xml(t)}</text>`).join('\n');
  const svg=`<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="1600" viewBox="0 0 1280 1600"><defs><linearGradient id="shade"><stop offset="0" stop-color="#171717" stop-opacity=".42"/><stop offset=".48" stop-color="#171717" stop-opacity=".04"/><stop offset="1" stop-color="#171717" stop-opacity=".28"/></linearGradient></defs><rect width="1280" height="1600" fill="#faf7ef"/><rect x="42" y="42" width="1196" height="1516" rx="18" fill="none" stroke="#d8cbb8" stroke-width="4"/><g ${rotated}>${lines}${note}</g>${shade}</svg>`;
  await writeFile(join(out,`${f.id}.svg`),svg);
}
await writeFile(join(out,'fixtures.json'),JSON.stringify({dataset:'Family Cookbook Studio G2A1 synthetic fixtures',count:data.length,privacy:'synthetic only; no customer/family source material',fixtures:data},null,2)+'\n');
const failed=[];
for(const f of data){
  const svg=join(out,`${f.id}.svg`), png=join(out,`${f.id}.png`);
  const args=['--headless=new','--disable-gpu','--hide-scrollbars','--no-first-run','--no-default-browser-check','--window-size=1280,1600',`--screenshot=${png}`,pathToFileURL(svg).href];
  const p=spawnSync(chrome,args,{encoding:'utf8',timeout:30000,windowsHide:true});
  if(p.error||p.status!==0) failed.push({id:f.id,status:p.status,error:p.error?.message,stderr:(p.stderr||'').slice(-400)});
}
if(failed.length){console.error(JSON.stringify({rendered:data.length-failed.length,failed},null,2));process.exitCode=1;}
else console.log(JSON.stringify({rendered:data.length,output:out,source:'synthetic SVG rendered by local Chromium; no network'}));
