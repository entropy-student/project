import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const output = path.join(root, 'dist-static');
const origin = new URL(process.env.HALO_LOCAL_URL || 'http://127.0.0.1:8090/');
const publicHost = 'spikersun.com';
const blockedPaths = [/^\/console(?:\/|$)/i, /^\/login(?:\/|$)/i, /^\/apis(?:\/|$)/i, /^\/actuator(?:\/|$)/i];
const assetExtensions = /\.(?:avif|bmp|css|eot|gif|ico|jpeg|jpg|js|json|map|mjs|mp3|mp4|ogg|otf|pdf|png|svg|txt|wasm|webm|webp|woff2?|xml|ttf)$/i;
const pageQueue = [new URL('/', origin)];
const queuedPages = new Set();
const queuedAssets = new Map();
const writtenPages = new Set();
const exportedPages = new Set();
const missing = [];
const missingAssets = [];

async function fetchHalo(url) {
  // Halo 的健康检查可能早于插件初始化完成，短暂 5xx 先重试再决定终止。
  for (let attempt = 0; attempt < 4; attempt += 1) {
    const response = await fetch(url);
    if (response.status < 500 || attempt === 3) return response;
    await new Promise((resolve) => setTimeout(resolve, 1000 * (attempt + 1)));
  }
}

function localUrl(raw, base) {
  let url;
  try { url = new URL(raw, base); } catch { return null; }
  if (!['http:', 'https:'].includes(url.protocol)) return null;
  if (url.hostname !== origin.hostname && url.hostname !== publicHost && url.hostname !== 'localhost') return null;
  url.hostname = origin.hostname;
  url.protocol = origin.protocol;
  url.port = origin.port;
  return url;
}

function staticRoute(url) {
  const pathname = decodeURI(url.pathname);
  if (!url.search) return pathname;
  const query = Buffer.from(url.search.slice(1)).toString('base64url');
  return `${pathname.replace(/\/$/, '')}/__query/${query}`;
}

function filePath(url, isPage = false) {
  let route = isPage ? staticRoute(url) : decodeURI(url.pathname);
  if (route === '/') route = '/index.html';
  else if ((isPage && !assetExtensions.test(route)) || route.endsWith('/')) route = `${route.replace(/\/$/, '')}/index.html`;
  const target = path.resolve(output, `.${route.replaceAll('/', path.sep)}`);
  if (!target.startsWith(`${output}${path.sep}`) && target !== path.join(output, 'index.html')) {
    throw new Error(`Unsafe output path: ${route}`);
  }
  return target;
}

function normalizeAsset(raw, base) {
  const url = localUrl(raw, base);
  if (!url) return null;
  url.hash = '';
  url.search = '';
  return url;
}

function addPage(raw, base) {
  const url = localUrl(raw, base);
  if (!url || blockedPaths.some((pattern) => pattern.test(url.pathname))) return;
  url.hash = '';
  const key = `${url.pathname}${url.search}`;
  if (!queuedPages.has(key)) {
    queuedPages.add(key);
    pageQueue.push(url);
  }
}

function addAsset(raw, base) {
  const url = normalizeAsset(raw, base);
  if (url?.pathname === '/halo-tracker.js') return;
  if (url && !queuedAssets.has(url.pathname)) queuedAssets.set(url.pathname, url);
}

function extractAttrs(html, tag, attribute) {
  const values = [];
  const tagRegex = new RegExp(`<(${tag})\\b[^>]*>`, 'gi');
  const attrRegex = new RegExp(`\\b${attribute}\\s*=\\s*(["'])(.*?)\\1`, 'i');
  for (const match of html.matchAll(tagRegex)) {
    const value = match[0].match(attrRegex)?.[2];
    if (value) values.push(value);
  }
  return values;
}

function staticHref(raw, base) {
  const url = localUrl(raw, base);
  if (!url) return raw;
  const route = staticRoute(url);
  return `${route}${url.hash}`;
}

function collectHtml(html, pageUrl) {
  const markup = html.replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, ' ').replace(/<style\b[^>]*>[\s\S]*?<\/style>/gi, ' ');
  for (const raw of extractAttrs(markup, 'a|area', 'href')) addPage(raw, pageUrl);
  for (const tag of ['link', 'script', 'img', 'source', 'video', 'audio', 'iframe', 'object', 'input']) {
    for (const raw of extractAttrs(html, tag, tag === 'link' ? 'href' : 'src')) {
      const url = localUrl(raw, pageUrl);
      if (url && assetExtensions.test(url.pathname)) addAsset(raw, pageUrl);
      else if (tag === 'link' && url && /(?:rss|sitemap)/i.test(raw)) addAsset(raw, pageUrl);
    }
  }
  for (const raw of extractAttrs(html, 'meta', 'content')) {
    if (/^https?:/i.test(raw)) addAsset(raw, pageUrl);
  }
  for (const raw of extractAttrs(html, 'img|source', 'srcset')) {
    for (const item of raw.split(',')) addAsset(item.trim().split(/\s+/)[0], pageUrl);
  }
  const inlineCss = [
    ...[...html.matchAll(/<style\b[^>]*>([\s\S]*?)<\/style>/gi)].map((match) => match[1]),
    ...[...markup.matchAll(/\bstyle\s*=\s*(["'])(.*?)\1/gi)].map((match) => match[2]),
  ].join('\n');
  for (const raw of inlineCss.matchAll(/url\(\s*["']?([^"')]+)["']?\s*\)/gi)) addAsset(raw[1], pageUrl);
}

function collectAssetReferences(body, contentType, assetUrl) {
  const text = body.toString('utf8');
  if (/css/i.test(contentType) || assetUrl.pathname.endsWith('.css')) {
    for (const match of text.matchAll(/url\(\s*["']?([^"')]+)["']?\s*\)/gi)) addAsset(match[1], assetUrl);
    for (const match of text.matchAll(/@import\s+(?:url\()?\s*["']([^"']+)["']/gi)) addAsset(match[1], assetUrl);
  } else if (/(?:javascript|ecmascript)/i.test(contentType) || /\.(?:m?js)$/i.test(assetUrl.pathname)) {
    for (const match of text.matchAll(/(?:\bfrom\s*|\bimport\s*(?:\(\s*)?)["']([^"']+)["']/gi)) {
      if (/^(?:\.{1,2}\/|\/|https?:\/\/)/.test(match[1])) addAsset(match[1], assetUrl);
    }
  } else if (/xml/i.test(contentType) || assetUrl.pathname.endsWith('.xml')) {
    for (const match of text.matchAll(/<loc>(.*?)<\/loc>/gi)) addPage(match[1].trim(), assetUrl);
  }
}

function htmlText(html) {
  return html
    .replace(/<script\b[^>]*>[\s\S]*?<\/script>/gi, ' ')
    .replace(/<style\b[^>]*>[\s\S]*?<\/style>/gi, ' ')
    .replace(/<noscript\b[^>]*>[\s\S]*?<\/noscript>/gi, ' ')
    .replace(/<[^>]+>/g, ' ')
    .replace(/&nbsp;|&#160;/gi, ' ')
    .replace(/&amp;/gi, '&').replace(/&quot;/gi, '"').replace(/&#39;|&apos;/gi, "'")
    .replace(/&lt;/gi, '<').replace(/&gt;/gi, '>')
    .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)))
    .replace(/&#x([\da-f]+);/gi, (_, n) => String.fromCodePoint(parseInt(n, 16)))
    .replace(/\s+/g, ' ').trim();
}

function makeSearchItem(html, route) {
  if (!/^\/archives\/[^/]+\/?$/.test(route)) return null;
  const title = html.match(/<h1\b[^>]*>([\s\S]*?)<\/h1>/i)?.[1]
    || html.match(/<meta\s+property="og:title"\s+content="([^"]*)"/i)?.[1]
    || html.match(/<title[^>]*>([\s\S]*?)<\/title>/i)?.[1]
    || route.split('/').filter(Boolean).at(-1);
  const description = html.match(/<meta\s+name="description"\s+content="([^"]*)"/i)?.[1] || '';
  const text = htmlText(html);
  return { title: htmlText(title), permalink: `https://${publicHost}${route}`, description: htmlText(description || text).slice(0, 240), content: text.slice(0, 8000) };
}

function rewriteXml(body) {
  return Buffer.from(body.toString('utf8')
    .replace(/<img\b[^>]*telemetry\.gif[^>]*>/gi, '')
    .replace(/<enclosure\b[^>]*\/?>/gi, '')
    .replaceAll('http://127.0.0.1:8090', `https://${publicHost}`)
    .replaceAll('http://localhost:8090', `https://${publicHost}`)
    .replaceAll('http://halo:8090', `https://${publicHost}`), 'utf8');
}

function rewritePage(html, pageUrl) {
  let result = html.replace(/<script\b[^>]*\bsrc=["'](?:https?:\/\/[^"']+)?\/halo-tracker\.js[^"']*["'][^>]*>\s*<\/script>/gi, '');
  result = result.replace(/<(a|area)\b([^>]*?)\bhref=(["'])(.*?)\3/gi, (whole, tag, before, quote, href) => {
    const route = staticHref(href, pageUrl);
    return `<${tag}${before}href=${quote}${route}${quote}`;
  });
  result = result.replaceAll('http://127.0.0.1:8090', `https://${publicHost}`).replaceAll('http://localhost:8090', `https://${publicHost}`);
  const searchPatch = `<script>${searchAdapter}</script>`;
  return result.includes('</head>') ? result.replace('</head>', `${searchPatch}</head>`) : `${searchPatch}${result}`;
}

const searchAdapter = `(function(){
  var original=window.fetch.bind(window), endpoint='/apis/api.halo.run/v1alpha1/indices/-/search', cache;
  window.fetch=function(input,init){
    var raw=typeof input==='string'?input:input&&input.url||'', url;
    try{url=new URL(raw,location.href)}catch(_){return original(input,init)}
    if(url.pathname!==endpoint)return original(input,init);
    var body={};try{body=JSON.parse((init&&init.body)||'{}')}catch(_){}
    var keyword=String(body.keyword||'').trim().toLocaleLowerCase();
    if(!keyword)return Promise.resolve(new Response(JSON.stringify({hits:[]}),{headers:{'Content-Type':'application/json'}}));
    cache=cache||original('/search-index.json').then(function(r){return r.json()});
    return cache.then(function(items){
      var terms=keyword.split(/\\s+/),hits=items.filter(function(item){var text=(item.title+' '+item.content).toLocaleLowerCase();return terms.every(function(term){return text.includes(term)})}).slice(0,20).map(function(item){
        var text=item.description&&item.description.toLocaleLowerCase().includes(terms[0])?item.description:item.content||'', lower=text.toLocaleLowerCase(), at=lower.indexOf(terms[0]), start=Math.max(0,at-70), snippet=text.slice(start,start+220);
        if(at>=0){var left=at-start,right=left+terms[0].length;snippet=snippet.slice(0,left)+'<mark>'+snippet.slice(left,right)+'</mark>'+snippet.slice(right)}
        return {title:item.title,permalink:item.permalink,description:snippet||item.description};
      });
      return new Response(JSON.stringify({hits:hits}),{headers:{'Content-Type':'application/json'}});
    });
  };
})();`;

await rm(output, { recursive: true, force: true });
await mkdir(output, { recursive: true });
const searchItems = [];
let pageCount = 0;

while (pageQueue.length) {
  const requested = pageQueue.shift();
  const routeKey = `${requested.pathname}${requested.search}`;
  if (writtenPages.has(routeKey)) continue;
  writtenPages.add(routeKey);
  const targetUrl = new URL(`${requested.pathname}${requested.search}`, origin);
  let response;
  try { response = await fetchHalo(targetUrl); }
  catch (error) { throw new Error(`Cannot read Halo page ${targetUrl.pathname}: ${error.message}`); }
  if (response.status === 404) { missing.push(requested.pathname); continue; }
  if (!response.ok) throw new Error(`Halo returned HTTP ${response.status} for ${requested.pathname}`);
  const contentType = response.headers.get('content-type') || '';
  const body = Buffer.from(await response.arrayBuffer());
  const destination = filePath(requested, true);
  await mkdir(path.dirname(destination), { recursive: true });
  if (/html/i.test(contentType)) {
    const html = body.toString('utf8');
    collectHtml(html, requested);
    const route = staticRoute(requested);
    const searchItem = makeSearchItem(html, route);
    if (searchItem) searchItems.push(searchItem);
    await writeFile(destination, rewritePage(html, requested), 'utf8');
  } else {
    let outputBody = body;
    if (/xml/i.test(contentType) || requested.pathname.endsWith('.xml')) outputBody = rewriteXml(body);
    await writeFile(destination, outputBody);
    collectAssetReferences(body, contentType, requested);
  }
  pageCount += 1;
  exportedPages.add(routeKey);
}

const assets = [...queuedAssets.values()];
const scheduledAssets = new Set(assets.map((asset) => asset.pathname));
for (let offset = 0; offset < assets.length;) {
  const batch = assets.slice(offset, offset + 8);
  await Promise.all(batch.map(async (assetUrl) => {
    const destination = filePath(assetUrl);
    if (await readFile(destination).then(() => true).catch(() => false)) return;
    try {
      const response = await fetchHalo(new URL(`${assetUrl.pathname}${assetUrl.search}`, origin));
      if (!response.ok) { missingAssets.push(`${assetUrl.pathname} (HTTP ${response.status})`); return; }
      const body = Buffer.from(await response.arrayBuffer());
      await mkdir(path.dirname(destination), { recursive: true });
      const type = response.headers.get('content-type') || '';
      const outputBody = /xml/i.test(type) || assetUrl.pathname.endsWith('.xml') ? rewriteXml(body) : body;
      await writeFile(destination, outputBody);
      collectAssetReferences(body, type, assetUrl);
    } catch (error) {
      missingAssets.push(`${assetUrl.pathname} (${error.message})`);
    }
  }));
  offset += batch.length;
  for (const asset of queuedAssets.values()) {
    if (!scheduledAssets.has(asset.pathname)) {
      scheduledAssets.add(asset.pathname);
      assets.push(asset);
    }
  }
}

if (missingAssets.length) throw new Error(`静态资源导出不完整，已停止部署：${missingAssets.join(', ')}`);

const sitemapPath = path.join(output, 'sitemap.xml');
const sitemap = await readFile(sitemapPath, 'utf8').catch(() => null);
if (sitemap) {
  await writeFile(sitemapPath, sitemap.replace(/<url\b[^>]*>[\s\S]*?<\/url>/gi, (entry) => {
    const location = entry.match(/<loc>(.*?)<\/loc>/i)?.[1];
    const url = location && localUrl(location, origin);
    return url && exportedPages.has(`${url.pathname}${url.search}`) ? entry : '';
  }), 'utf8');
}

await writeFile(path.join(output, 'search-index.json'), JSON.stringify(searchItems, null, 2), 'utf8');
await writeFile(path.join(output, '404.html'), `<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>页面不存在 · SPW</title><style>body{margin:0;min-height:100vh;display:grid;place-items:center;background:#080b12;color:#eee7d8;font:16px system-ui,sans-serif}main{text-align:center;padding:3rem}a{color:#ef9a8b}</style><main><p>SPW / JOURNAL</p><h1>这个页面暂时不存在</h1><a href="/">返回首页</a></main></html>`, 'utf8');

console.log(`静态站生成完成：${pageCount} 个页面，${queuedAssets.size} 个资源，${searchItems.length} 篇文章已加入搜索索引。`);
if (missing.length) console.log(`源站不存在或未能读取的链接（不会阻止生成）：${[...new Set(missing)].join(', ')}`);
