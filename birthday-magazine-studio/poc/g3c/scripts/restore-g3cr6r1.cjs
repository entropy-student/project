const fs=require('fs');
const path=require('path');
const crypto=require('crypto');
const {spawnSync}=require('child_process');
const base=path.resolve(__dirname,'..');
const backup=path.join(base,'artifacts/backups/g3cr6r1');
if(process.argv[2]!=='--restore-presentation')throw new Error('Explicit --restore-presentation required; local G3C only.');
const bytes=fs.readFileSync(path.join(backup,'presentation-before.json'));
const manifest=JSON.parse(fs.readFileSync(path.join(backup,'rollback-manifest.json')));
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
if(sha(bytes)!==manifest.presentationSha256)throw new Error('Rollback checksum mismatch.');
for(const item of manifest.sourceFiles){
 const source=path.join(backup,'preview-plugin-before',item.name);
 if(sha(fs.readFileSync(source))!==item.sha256)throw new Error('Rollback plugin checksum mismatch.');
}
const snapshot=JSON.parse(bytes).presentation_rollback;
const php='<?php require "/var/www/html/wp-load.php"; $s=json_decode(base64_decode("'+Buffer.from(JSON.stringify(snapshot)).toString('base64')+'"),true); if(wp_get_theme()->get_stylesheet()!=="blocksy"||wc_get_product(1113)->get_price()!=="39.99")exit(2); wp_update_post(wp_slash(["ID"=>858,"post_content"=>$s["home"]["content"]]));wp_update_post(wp_slash(["ID"=>1113,"post_title"=>$s["product"]["title"],"post_content"=>$s["product"]["content"],"post_excerpt"=>$s["product"]["excerpt"]]));set_post_thumbnail(1113,$s["product"]["thumbnail"]);update_option("theme_mods_blocksy",$s["theme_mods"]);delete_option("bms_g3cr6r1_footer_id");echo "LOCAL_PRESENTATION_RESTORED\n";';
const r=spawnSync('docker',['exec','-i','birthday-magazine-g3c-wordpress-1','php'],{input:php,encoding:'utf8'});
if(r.status!==0)throw new Error('WordPress presentation restore failed: '+r.stderr);
for(const item of manifest.sourceFiles)fs.copyFileSync(path.join(backup,'preview-plugin-before',item.name),path.join(base,'preview-plugin',item.name));
console.log(r.stdout.trim());
console.log('Protected commerce backend, orders, accounts, jobs and runtime topology were not restored or modified.');
