// Owner-authorized Preview-only presentation update. No commerce/provider action.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { execFileSync } = require('node:child_process');
const assert = require('node:assert/strict');
const project = path.resolve(__dirname, '../../..');
const source = path.join(project, 'poc/g3c/preview-plugin');
const backup = path.join(project, 'poc/g3c/.tmp/preview-focus-20261005');
const evidence = path.join(project, 'docs/evidence/g3cr7v2r4-preview-focus');
const container = 'birthday-magazine-g3c-wordpress-1';
const hash = data => crypto.createHash('sha256').update(data).digest('hex');
const runtime = JSON.parse(fs.readFileSync(path.join(project, 'poc/g3c/.tmp/g3cr7v2r4-rollback/manifest.json'))).runtime;
const files = ['magazine-preview.css', 'birthday-magazine-poc.php'];
function wp(code) {
 return JSON.parse(execFileSync('docker', ['exec', '-i', container, 'php'], { input: "<?php define('DISABLE_WP_CRON', true); require '/var/www/html/wp-load.php';\n" + code, encoding: 'utf8', maxBuffer: 4 * 1024 * 1024 }));
}
function state() {
 return wp(`$home=get_post(858); $owner=get_user_by('login','bms-owner'); $blocks=parse_blocks($home->post_content); $preview=array_values(array_filter($blocks,fn($b)=>($b['attrs']['anchor']??'')==='preview')); if(count($preview)!==1){throw new Exception('Unique preview Group required');} $block=serialize_block($preview[0]); if(substr_count($home->post_content,$block)!==1){throw new Exception('Exact serialized preview range required');} echo wp_json_encode(['homeContent'=>$home->post_content,'previewBlock'=>$block,'homeSHA256'=>hash('sha256',$home->post_content),'outsidePreviewSHA256'=>hash('sha256',str_replace($block,'',$home->post_content)),'themeModsSHA256'=>hash('sha256',wp_json_encode(get_theme_mods())),'ownerEdit'=>user_can($owner,'edit_post',858),'gutenberg'=>use_block_editor_for_post(858),'orders'=>count(wc_get_orders(['return'=>'ids','limit'=>-1])),'jobs'=>(int)get_option('bms_g3a_generation_job_count',0),'modelCalls'=>(int)get_option('bms_g3a_model_call_count',0),'groups'=>count(array_filter($blocks,fn($b)=>$b['blockName']==='core/group'))],JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES);`);
}
function checkContainer() {
 assert.equal(execFileSync('docker', ['inspect', '--format', '{{.Id}}', container]).toString().trim(), '21892d72baebe6157fbeab15ad6a1e3949cf4663ca55b45360c3f4eb1f052f00');
 assert.equal(execFileSync('docker', ['inspect', '--format', '{{.State.Running}}', container]).toString().trim(), 'true');
}
checkContainer();
const mode = process.argv[2];
if (mode === 'backup') {
 assert(!fs.existsSync(backup), 'Never overwrite the pre-write backup');
 fs.mkdirSync(backup, { recursive: true }); fs.mkdirSync(evidence, { recursive: true });
 const before = state(); assert(before.ownerEdit && before.gutenberg);
 fs.writeFileSync(path.join(backup, 'wordpress-before.json'), JSON.stringify(before, null, 2));
 fs.writeFileSync(path.join(evidence, 'home-preview-before.html'), before.previewBlock);
 const entries = [];
 for (const file of files) for (const role of ['source', 'runtime']) {
  const original = path.join(role === 'source' ? source : runtime, file), dest = path.join(backup, role, file);
  fs.mkdirSync(path.dirname(dest), { recursive: true }); fs.copyFileSync(original, dest);
  entries.push({ role, file, sha256: hash(fs.readFileSync(original)), mtime: fs.statSync(original).mtimeMs });
 }
 fs.writeFileSync(path.join(backup, 'manifest.json'), JSON.stringify({ baseline: '1bb5dedde256ad84fec02d7350430f051492ed0f', container, runtime, files: entries }, null, 2));
 console.log(JSON.stringify({ backup, previewBlock: before.previewBlock, ownerEdit: before.ownerEdit, gutenberg: before.gutenberg }));
} else if (mode === 'apply') {
 const before = JSON.parse(fs.readFileSync(path.join(backup, 'wordpress-before.json'))), current = state();
 assert.equal(current.homeSHA256, before.homeSHA256, 'Home drift: stop rather than overwrite');
 let next = before.previewBlock;
 const substitutions = [
  [/<h2 class="wp-block-heading bms-heading">[\s\S]*?<\/h2>/g, '<h2 class="wp-block-heading bms-heading">Their name. Their photo.<br><strong>Their birthday magazine.</strong></h2>'],
  [/<p class="bms-copy">[\s\S]*?<\/p>/g, '<p class="bms-copy">Add their name and choose a photo. Watch their cover and sample spread come to life, instantly.</p>'],
  [/<p class="bms-panel-note">[\s\S]*?<\/p>/g, '<p class="bms-panel-note"><strong>Free preview.</strong> <strong>Instant update.</strong> Your photo stays in your browser.</p>']
 ];
 for (const [pattern, replacement] of substitutions) { assert.equal([...next.matchAll(pattern)].length, 1); next = next.replace(pattern, replacement); }
 const content = before.homeContent.replace(before.previewBlock, next);
 const updated = wp(`$expected='${before.homeSHA256}'; if(hash('sha256',get_post_field('post_content',858))!==$expected){throw new Exception('Concurrent Home drift');} $content=base64_decode('${Buffer.from(content).toString('base64')}'); $id=wp_update_post(['ID'=>858,'post_content'=>wp_slash($content)],true); if(is_wp_error($id)){throw new Exception($id->get_error_message());} echo wp_json_encode(['id'=>$id]);`);
 assert.equal(updated.id, 858);
 const after = state(); assert.equal(after.outsidePreviewSHA256, before.outsidePreviewSHA256);
 fs.writeFileSync(path.join(evidence, 'home-preview-after.html'), after.previewBlock);
 for (const file of files) {
  const entry = JSON.parse(fs.readFileSync(path.join(backup, 'manifest.json'))).files.find(x => x.file === file && x.role === 'runtime');
  assert.equal(hash(fs.readFileSync(path.join(runtime, file))), entry.sha256, 'Mounted file drift');
  fs.copyFileSync(path.join(source, file), path.join(runtime, file));
  const stat = fs.statSync(path.join(source, file)); fs.utimesSync(path.join(runtime, file), stat.atime, stat.mtime);
 }
 console.log(JSON.stringify({ appliedPreviewOnly: true, homeId: 858 }));
} else if (mode === 'verify') {
 const before = JSON.parse(fs.readFileSync(path.join(backup, 'wordpress-before.json'))), after = state();
 for (const key of ['outsidePreviewSHA256', 'themeModsSHA256', 'ownerEdit', 'gutenberg', 'orders', 'jobs', 'modelCalls', 'groups']) assert.deepEqual(after[key], before[key], key);
 const identities = files.map(file => { const a=fs.readFileSync(path.join(source,file)), b=fs.readFileSync(path.join(runtime,file)); assert.equal(hash(a),hash(b)); return { file, sourceSHA256:hash(a), runtimeSHA256:hash(b), exact:true }; });
 const report = { baseline:'1bb5dedde256ad84fec02d7350430f051492ed0f', homeId:858, before:{...before,homeContent:undefined,previewBlock:undefined}, after:{...after,homeContent:undefined,previewBlock:undefined}, identities, runtimeRetained:true, backupPath:backup, otherHomeSectionsUnchanged:true, checkoutSubmissions:0, paymentActions:0, imageGeneration:0 };
 fs.writeFileSync(path.join(evidence, 'scope-runtime-readback.json'), JSON.stringify(report,null,2));
 console.log(JSON.stringify(report));
} else throw Error('Use backup, apply or verify');
