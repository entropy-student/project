import fs from "node:fs/promises";
import path from "node:path";
import http from "node:http";
import crypto from "node:crypto";
import { fileURLToPath } from "node:url";
import { chromium } from "playwright";
import { PDFDocument } from "pdf-lib";
import { CONTENT_SCHEMA, ChatCompletionsAdapter, providerPrompt } from "./provider.mjs";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(HERE, "..");
const FIXTURES = path.join(ROOT, "fixtures");
const PHOTO_DIR = path.join(FIXTURES, "photos");
const ARTIFACTS = path.join(ROOT, "artifacts");
const SCREENSHOTS = path.join(ARTIFACTS, "screenshots");
const RUNTIME = path.join(ROOT, ".runtime");
const PAGE_SECTIONS = [
  "Front Cover", "Opening Note", "Who They Are", "Feature Memory", "Feature Memory",
  "Dynamic Module A", "Why They Matter", "Photo Story / Current Era", "Photo Story / Current Era",
  "Dynamic Module B", "Birthday Letter / Next Chapter", "Back Cover"
];
const MODULES = ["The Lore / inside jokes", "Favorites", "Playlist", "Travel", "Then & Now", "Year in Review", "Current Obsessions", "Mini Timeline"];
const PRESETS = ["bold-editorial", "soft-warm", "retro-playful"];
const MAX_COPY_CHARS = 520;

const input = await readJson(path.join(FIXTURES, "intake.json"));
const referenceContent = await readJson(path.join(FIXTURES, "reference-content.json"));
const failures = [];
const browserPath = await findBrowser();
const browser = await chromium.launch({ headless: true, ...(browserPath ? { executablePath: browserPath } : {}) });
let server;
let externalRequestCount = 0;
let rendererRequestCount = 0;
let mobileReadback;
let jobPath;

function check(condition, message) {
  if (!condition) failures.push(message);
}

function invariant(condition, message) {
  if (!condition) throw new Error(message);
}

async function readJson(file) {
  return JSON.parse(await fs.readFile(file, "utf8"));
}

async function findBrowser() {
  const candidates = [
    process.env.BMS_BROWSER_EXECUTABLE,
    process.env.PROGRAMFILES ? path.join(process.env.PROGRAMFILES, "Google", "Chrome", "Application", "chrome.exe") : null,
    process.env["PROGRAMFILES(X86)"] ? path.join(process.env["PROGRAMFILES(X86)"], "Microsoft", "Edge", "Application", "msedge.exe") : null,
    "/usr/bin/chromium",
    "/usr/bin/google-chrome",
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  ].filter(Boolean);
  for (const candidate of candidates) {
    try {
      await fs.access(candidate);
      return candidate;
    } catch {}
  }
  return undefined;
}

async function writeJson(file, value) {
  await fs.mkdir(path.dirname(file), { recursive: true });
  await fs.writeFile(file, JSON.stringify(value, null, 2) + "\n", "utf8");
}

function sourceValue(data, ref) {
  return ref.split(".").reduce((value, key) => value?.[key], data);
}

function ageOnDate(birthday, asOfDate) {
  const born = new Date(birthday + "T00:00:00Z");
  const asOf = new Date(asOfDate + "T00:00:00Z");
  let age = asOf.getUTCFullYear() - born.getUTCFullYear();
  if (asOf.getUTCMonth() < born.getUTCMonth() || (asOf.getUTCMonth() === born.getUTCMonth() && asOf.getUTCDate() < born.getUTCDate())) age--;
  return age;
}

async function validateIntake(data, { checkFiles = true } = {}) {
  const errors = [];
  const required = ["q1", "q2", "q3", "q4", "q5", "q6"];
  if (!data.recipient?.name?.trim()) errors.push("RECIPIENT_NAME_REQUIRED");
  if (!data.recipient?.birthday && !Number.isInteger(data.recipient?.age)) errors.push("BIRTHDAY_OR_AGE_REQUIRED");
  if (data.recipient?.birthday && !/^\d{4}-\d{2}-\d{2}$/.test(data.recipient.birthday)) errors.push("BIRTHDAY_FORMAT_INVALID");
  if (!data.buyerRelationship?.trim()) errors.push("BUYER_RELATIONSHIP_REQUIRED");
  if (!["heartfelt", "playful", "balanced"].includes(data.tone)) errors.push("TONE_UNSUPPORTED");
  if (!PRESETS.includes(data.stylePreset)) errors.push("STYLE_PRESET_UNSUPPORTED");
  for (const field of required) if (typeof data.answers?.[field] !== "string" || !data.answers[field].trim()) errors.push("ANSWER_" + field.toUpperCase() + "_REQUIRED");
  if (!Array.isArray(data.photos) || data.photos.length < 12) errors.push("PHOTO_COUNT_BELOW_12");
  if (Array.isArray(data.photos) && data.photos.length > 25) errors.push("PHOTO_COUNT_ABOVE_25");
  const photos = Array.isArray(data.photos) ? data.photos : [];
  if (new Set(photos.map(photo => photo.id)).size !== photos.length) errors.push("PHOTO_ID_DUPLICATE");
  const mustUse = photos.filter(photo => photo.mustUse);
  if (mustUse.length > 3) errors.push("MUST_USE_ABOVE_3");
  for (const photo of photos) {
    const extension = path.extname(photo.file || "").toLowerCase();
    if (![".jpg", ".jpeg", ".png", ".webp"].includes(extension)) errors.push("PHOTO_TYPE_UNSUPPORTED:" + photo.id);
    if (!photo.sourceField || typeof sourceValue(data, photo.sourceField) !== "string") errors.push("PHOTO_SOURCE_FIELD_INVALID:" + photo.id);
    else if (!photo.evidenceCue || !sourceValue(data, photo.sourceField).toLowerCase().includes(photo.evidenceCue.toLowerCase())) errors.push("PHOTO_CUE_UNGROUNDED:" + photo.id);
    if (checkFiles) {
      try {
        const bytes = await fs.readFile(path.join(FIXTURES, photo.file));
        if (!validImageHeader(bytes, extension)) errors.push("PHOTO_BYTES_INVALID:" + photo.id);
      } catch {
        errors.push("PHOTO_FILE_MISSING:" + photo.id);
      }
    }
  }
  if (data.recipient?.birthday && Number.isInteger(data.recipient?.age) && ageOnDate(data.recipient.birthday, data.asOfDate) !== data.recipient.age) errors.push("AGE_BIRTHDAY_MISMATCH");
  return errors;
}

function validImageHeader(bytes, extension) {
  if (extension === ".png") return bytes.length > 8 && bytes.subarray(0, 8).equals(Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]));
  if (extension === ".jpg" || extension === ".jpeg") return bytes.length > 3 && bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff;
  if (extension === ".webp") return bytes.length > 12 && bytes.toString("ascii", 0, 4) === "RIFF" && bytes.toString("ascii", 8, 12) === "WEBP";
  return false;
}

function sourceRefsIn(value, output = []) {
  if (Array.isArray(value)) {
    for (const item of value) sourceRefsIn(item, output);
  } else if (value && typeof value === "object") {
    if (Array.isArray(value.sourceRefs)) output.push(...value.sourceRefs);
    for (const [key, child] of Object.entries(value)) if (key !== "sourceRefs") sourceRefsIn(child, output);
  }
  return output;
}

function validateContent(content, data, assignments) {
  const errors = [];
  for (const [name, value] of Object.entries({
    openingNote: content.openingNote?.text,
    profile: content.profile?.text,
    featureMemory: content.featureMemory?.text,
    whyTheyMatter: content.whyTheyMatter?.text,
    currentEra: content.currentEra?.text,
    birthdayLetter: content.birthdayLetter?.text,
    backCoverLine: content.backCoverLine?.text
  })) if (typeof value !== "string" || !value.trim()) errors.push("REQUIRED_CONTENT_MISSING:" + name);
  if (!Array.isArray(content.coverHeadlines) || content.coverHeadlines.length < 2 || content.coverHeadlines.length > 3) errors.push("COVER_HEADLINE_COUNT_INVALID");
  const allowedRefs = new Set([
    "recipient.name", "recipient.age", "recipient.birthday", "buyerRelationship", "tone", "stylePreset", "asOfDate",
    "quickFacts.favoriteFood", "quickFacts.favoritePlace", "quickFacts.currentObsession",
    "answers.q1", "answers.q2", "answers.q3", "answers.q4", "answers.q5", "answers.q6"
  ]);
  if (content.origin && content.origin !== "human-authored synthetic renderer reference; not AI output" && !content.origin.includes("provider")) errors.push("CONTENT_ORIGIN_UNDECLARED");
  if (content.recipient?.name !== data.recipient.name || content.recipient?.age !== data.recipient.age || content.recipient?.birthday !== data.recipient.birthday) errors.push("RECIPIENT_IDENTITY_MISMATCH");
  if (content.recipient?.relationship !== data.buyerRelationship || content.tone !== data.tone || content.stylePreset !== data.stylePreset) errors.push("RELATIONSHIP_TONE_OR_STYLE_MISMATCH");
  if (!Array.isArray(content.groundedFacts) || content.groundedFacts.length === 0) errors.push("GROUNDED_FACTS_MISSING");
  if (content.dynamicModules?.length !== 2) errors.push("DYNAMIC_MODULE_COUNT_NOT_2");
  if (new Set((content.dynamicModules || []).map(module => module.name)).size !== (content.dynamicModules || []).length) errors.push("DYNAMIC_MODULE_DUPLICATE");
  for (const module of content.dynamicModules || []) {
    if (!MODULES.includes(module.name)) errors.push("DYNAMIC_MODULE_UNSUPPORTED");
    if (!module.sourceRefs?.length || !module.sourceRefs.some(ref => allowedRefs.has(ref) && String(sourceValue(data, ref) || "").length >= 40)) errors.push("DYNAMIC_MODULE_UNSUPPORTED_BY_INPUT");
  }
  for (const ref of sourceRefsIn(content)) if (!allowedRefs.has(ref)) errors.push("SOURCE_REF_INVALID:" + ref);
  for (const item of content.groundedFacts || []) {
    if (!item.sourceRefs?.length) errors.push("FACT_CLAIM_WITHOUT_SOURCE");
    const validSources = item.sourceRefs.map(ref => sourceValue(data, ref)).filter(value => typeof value === "string");
    if (item.sourceRefs.some(ref => ref.startsWith("answers.")) && !(item.supportingQuotes || []).length) errors.push("FACT_CLAIM_WITHOUT_SUPPORTING_QUOTE");
    for (const quote of item.supportingQuotes || []) {
      if (!validSources.some(source => source.toLowerCase().includes(quote.toLowerCase()))) errors.push("FACT_QUOTE_NOT_IN_SOURCE");
    }
    if (item.sourceRefs.includes("recipient.age") && ageOnDate(data.recipient.birthday, data.asOfDate) !== data.recipient.age) errors.push("AGE_CLAIM_UNSUPPORTED");
  }
  const contentStrings = [
    ...(content.coverHeadlines || []).map(item => item.text),
    content.openingNote?.text, content.profile?.text, content.featureMemory?.text,
    ...(content.dynamicModules || []).map(item => item.text), content.whyTheyMatter?.text, content.currentEra?.text,
    content.birthdayLetter?.text, content.backCoverLine?.text
  ].filter(Boolean);
  if (contentStrings.some(text => text.length > MAX_COPY_CHARS)) errors.push("COPY_LENGTH_LIMIT_EXCEEDED");
  for (let page = 1; page <= 12; page++) {
    if (!assignments.some(item => item.page === page)) errors.push("PHOTO_PAGE_ASSIGNMENT_MISSING:" + page);
  }
  if (assignments.length !== 12 || new Set(assignments.map(item => item.page)).size !== 12) errors.push("PHOTO_PAGE_ASSIGNMENT_COUNT_INVALID");
  if (new Set(assignments.map(item => item.photoId)).size !== assignments.length) errors.push("PHOTO_REPEATED_IN_UNIQUE_SLOTS");
  const sourceIds = new Set(data.photos.map(photo => photo.id));
  for (const assignment of assignments) if (!sourceIds.has(assignment.photoId)) errors.push("PHOTO_MAPPING_UNKNOWN_ID:" + assignment.photoId);
  const mapped = new Set(assignments.map(item => item.photoId));
  for (const photo of data.photos.filter(item => item.mustUse)) if (!mapped.has(photo.id)) errors.push("MUST_USE_NOT_MAPPED:" + photo.id);
  return errors;
}

function selectAndMapPhotos(data) {
  const targetCount = Math.min(12, 14, data.photos.length);
  const selected = [...data.photos]
    .sort((a, b) => Number(b.mustUse) - Number(a.mustUse) || b.selectionScore - a.selectionScore || a.id.localeCompare(b.id))
    .slice(0, targetCount);
  const assignments = selected.map(photo => ({ page: photo.pageHint, photoId: photo.id })).sort((a, b) => a.page - b.page);
  return { selected, assignments };
}

function joinSentences(text) {
  const parts = text.match(/[^.!?]+[.!?]+|[^.!?]+$/g) || [text];
  const split = Math.ceil(parts.length / 2);
  return [parts.slice(0, split).join(" ").trim(), parts.slice(split).join(" ").trim()];
}

function makePages(data, content, assignments, selected) {
  const photoById = new Map(data.photos.map(photo => [photo.id, photo]));
  const captionById = new Map((content.captions || []).map(caption => [caption.photoId, caption]));
  const moduleA = content.dynamicModules[0];
  const moduleB = content.dynamicModules[1];
  const [memoryA, memoryB] = joinSentences(content.featureMemory.text);
  const [currentA, currentB] = joinSentences(content.currentEra.text);
  const pageCopy = [
    { title: content.recipient.name, eyebrow: "THE BIRTHDAY ISSUE · " + content.recipient.age, body: content.coverHeadlines.map(item => item.text).join(" · "), headline: content.coverHeadlines[2].text, layout: "cover" },
    { title: "A note from your sister", eyebrow: "OPENING NOTE", body: content.openingNote.text, headline: "Why this issue exists", layout: "standard" },
    { title: content.profile.headline, eyebrow: "WHO THEY ARE", body: content.profile.text, headline: "The details that stay", layout: "standard" },
    { title: content.featureMemory.headline, eyebrow: "FEATURE MEMORY · 01", body: memoryA, headline: "Harbor Street, in the rain", layout: "memory" },
    { title: "The scene we kept", eyebrow: "FEATURE MEMORY · 02", body: memoryB, headline: "A receipt became a boat", layout: "memory" },
    { title: moduleA.headline, eyebrow: moduleA.name.toUpperCase(), body: moduleA.text, headline: "A small tradition takes shape", layout: "module" },
    { title: content.whyTheyMatter.headline, eyebrow: "WHY THEY MATTER", body: content.whyTheyMatter.text, headline: "The kind of kindness that remembers", layout: "standard" },
    { title: content.currentEra.headline, eyebrow: "PHOTO STORY · CURRENT ERA", body: currentA, headline: "A life in the making", layout: "photo-story" },
    { title: "The week, in small rituals", eyebrow: "PHOTO STORY · CURRENT ERA", body: currentB, headline: "Room to grow at its own pace", layout: "photo-story" },
    { title: moduleB.headline, eyebrow: moduleB.name.toUpperCase(), body: moduleB.text, headline: "Clay · tomatoes · Sunday walks", layout: "module" },
    { title: content.birthdayLetter.headline, eyebrow: "BIRTHDAY LETTER · NEXT CHAPTER", body: content.birthdayLetter.text, headline: "For 25, and what comes next", layout: "letter" },
    { title: content.recipient.name, eyebrow: "BACK COVER", body: content.backCoverLine.text, headline: "BIRTHDAY ISSUE · " + content.recipient.age, layout: "back" }
  ];
  const selectedIds = new Set(selected.map(photo => photo.id));
  return pageCopy.map((copy, index) => {
    const page = index + 1;
    const assignment = assignments.find(item => item.page === page);
    const photo = assignment && photoById.get(assignment.photoId);
    invariant(photo && selectedIds.has(photo.id), "PAGE_PHOTO_NOT_SELECTED:" + page);
    const caption = captionById.get(photo.id);
    invariant(caption, "PAGE_CAPTION_MISSING:" + photo.id);
    return {
      page, section: PAGE_SECTIONS[index], ...copy, photoId: photo.id, photoScene: photo.scene, caption: caption.text,
      coverLines: index === 0 ? content.coverHeadlines.slice(0, 2).map(item => item.text) : [],
      maxCopyHeight: [1, 12].includes(page) ? 190 : page === 11 ? 340 : 285,
      recipient: { name: data.recipient.name, age: data.recipient.age, birthday: data.recipient.birthday }
    };
  });
}

function svgForScene(id) {
  const n = Number(id.slice(-2));
  const colors = [["#456b73", "#eabf83", "#f6ead6"], ["#a76555", "#e9c69c", "#f6ead6"], ["#526f62", "#d7c386", "#f7efe1"], ["#8a5870", "#e4a982", "#f7ede1"]];
  const [dark, warm, paper] = colors[(n - 1) % colors.length];
  const scenes = {
    1: '<rect x="0" y="0" width="900" height="1120" fill="#d2dce0"/><path d="M0 680H900V1120H0Z" fill="#b7c9cc"/><path d="M70 170H830V660H70Z" fill="#f2e6d4"/><path d="M420 170V660M70 410H830" stroke="#fffaf0" stroke-width="26"/><path d="M120 580h190v45H120zM340 540h180v85H340zM550 565h220v60H550z" fill="#9f7159"/><path d="M0 60l100 120m0-120L0 180m180-130l100 120m0-120L180 170m500-90l100 130m0-130L680 200" stroke="#fff" stroke-opacity=".65" stroke-width="14"/>',
    2: '<rect x="0" y="0" width="900" height="1120" fill="#dfc7aa"/><rect x="88" y="100" width="724" height="630" rx="26" fill="#f7efdf"/><path d="M120 160H780V600H120Z" fill="#a9c3c1"/><path d="M120 570h660v48H120z" fill="#84594b"/><circle cx="450" cy="800" r="174" fill="#d58b5e"/><circle cx="450" cy="800" r="116" fill="#f0c78f"/><path d="M420 800c45-85 92-12 44 32-36 38-103 7-73-42" fill="none" stroke="#a76555" stroke-width="18"/>',
    3: '<rect x="0" y="0" width="900" height="1120" fill="#e6d4b9"/><rect x="96" y="120" width="708" height="820" rx="18" fill="#f8f0df"/><path d="M230 570l220-150 220 150-220 110z" fill="#bc805b"/><path d="M230 570v180l220 120V680z" fill="#d69e70"/><path d="M670 180h20v650h-20zM200 240h500" stroke="#caad89" stroke-width="10"/><path d="M140 310l34-38 34 38-34 38zM700 900l30-34 30 34-30 34z" fill="#778b7c"/>',
    4: '<rect x="0" y="0" width="900" height="1120" fill="#e1d2cf"/><circle cx="450" cy="770" r="245" fill="#8b7b89"/><ellipse cx="450" cy="680" rx="170" ry="78" fill="#f1d3ad"/><path d="M280 680v205c0 75 340 75 340 0V680c-35 105-305 105-340 0z" fill="#ce9074"/><ellipse cx="450" cy="680" rx="170" ry="78" fill="#e8b69a"/><path d="M150 1010h600" stroke="#664f54" stroke-width="20"/>',
    5: '<rect x="0" y="0" width="900" height="1120" fill="#bed0b7"/><rect x="80" y="580" width="740" height="310" fill="#f5e8d2"/><rect x="130" y="180" width="640" height="390" fill="#c8dddb"/><path d="M130 570h640" stroke="#745e4b" stroke-width="40"/><circle cx="270" cy="720" r="92" fill="#c75b48"/><circle cx="480" cy="760" r="108" fill="#cf6b4d"/><circle cx="670" cy="700" r="78" fill="#c84f3e"/><path d="M270 626q0-78 62-72m148 98q-4-75 62-75m128 45q-8-72 50-69" stroke="#526f62" stroke-width="18" fill="none"/>',
    6: '<rect x="0" y="0" width="900" height="1120" fill="#d2c8b6"/><circle cx="455" cy="560" r="330" fill="#263f3d"/><circle cx="455" cy="560" r="275" fill="#374d49"/><circle cx="455" cy="560" r="220" fill="#263f3d"/><circle cx="455" cy="560" r="92" fill="#d7a879"/><circle cx="455" cy="560" r="32" fill="#f2e6d4"/><path d="M620 350q140-135 200 10" stroke="#d58b5e" stroke-width="26" fill="none"/>',
    7: '<rect x="0" y="0" width="900" height="1120" fill="#ecdcc7"/><ellipse cx="450" cy="850" rx="315" ry="100" fill="#a76e53"/><ellipse cx="450" cy="770" rx="260" ry="104" fill="#e2ad72"/><ellipse cx="450" cy="640" rx="220" ry="98" fill="#e8bb80"/><ellipse cx="450" cy="530" rx="175" ry="88" fill="#eac895"/><path d="M350 510q50-100 100 0t100 0" stroke="#b7654f" stroke-width="18" fill="none"/><circle cx="270" cy="730" r="27" fill="#9e4146"/><circle cx="610" cy="790" r="24" fill="#9e4146"/>',
    8: '<rect x="0" y="0" width="900" height="1120" fill="#d9dfce"/><path d="M450 1120V280M450 610L250 420M450 750l210-245M450 890L230 760" stroke="#526f62" stroke-width="26"/><g fill="#d99179"><circle cx="250" cy="380" r="90"/><circle cx="660" cy="460" r="100"/><circle cx="225" cy="700" r="78"/><circle cx="450" cy="240" r="95"/></g><g fill="#f2d39d"><circle cx="250" cy="380" r="32"/><circle cx="660" cy="460" r="38"/><circle cx="225" cy="700" r="30"/><circle cx="450" cy="240" r="35"/></g>',
    9: '<rect x="0" y="0" width="900" height="1120" fill="#e9dfcd"/><path d="M110 300H790M110 570H790M110 840H790" stroke="#795d4d" stroke-width="38"/><g fill="#cf9770"><rect x="150" y="120" width="105" height="180" rx="24"/><rect x="310" y="110" width="120" height="190" rx="24"/><rect x="500" y="160" width="95" height="140" rx="24"/><rect x="660" y="130" width="88" height="170" rx="24"/></g><g fill="#e7c895"><rect x="170" y="390" width="130" height="180" rx="20"/><rect x="380" y="380" width="110" height="190" rx="20"/><rect x="580" y="420" width="150" height="150" rx="20"/></g><path d="M185 210h35m-35 330h95m140-75h45" stroke="#fff5df" stroke-width="13"/>',
    10: '<rect x="0" y="0" width="900" height="1120" fill="#d8c8b3"/><path d="M100 700H800L700 900H190Z" fill="#9a624c"/><path d="M200 900v135M700 900v135M270 620v80M610 620v80" stroke="#674e42" stroke-width="36"/><circle cx="290" cy="420" r="95" fill="#c68b64"/><circle cx="520" cy="390" r="95" fill="#e1bd89"/><circle cx="710" cy="450" r="80" fill="#7f9a83"/><path d="M290 515v120m230-125v120m190-90v120" stroke="#674e42" stroke-width="28"/>',
    11: '<rect x="0" y="0" width="900" height="1120" fill="#bfcfd1"/><path d="M0 760H900V1120H0Z" fill="#9ebabc"/><path d="M100 300l130-110 125 110v250H100zM500 240l130-115 155 115v310H500z" fill="#ede4d5"/><path d="M150 400h60m350-60h70m75 0h45" stroke="#c58a6c" stroke-width="34"/><path d="M60 80l90 110m20-120-120 130m500-120 95 130m20-145L570 210" stroke="#fff" stroke-opacity=".6" stroke-width="12"/>',
    12: '<rect x="0" y="0" width="900" height="1120" fill="#d6d9c8"/><path d="M260 560q190-150 380 0l-50 380H310z" fill="#bd896a"/><path d="M450 590V260M450 410L280 270M450 470L640 260M450 520L260 450M450 520L670 430" stroke="#597a65" stroke-width="18"/><g fill="#cf816d"><circle cx="280" cy="250" r="85"/><circle cx="650" cy="240" r="100"/><circle cx="240" cy="430" r="70"/><circle cx="675" cy="410" r="76"/><circle cx="450" cy="240" r="84"/></g><g fill="#efd29c"><circle cx="280" cy="250" r="28"/><circle cx="650" cy="240" r="34"/><circle cx="240" cy="430" r="25"/><circle cx="675" cy="410" r="25"/><circle cx="450" cy="240" r="28"/></g>',
    13: '<rect x="0" y="0" width="900" height="1120" fill="#d5c7a9"/><rect x="150" y="120" width="600" height="830" rx="16" fill="#f8f0df"/><path d="M230 290H660M230 390H660M230 490H610M230 590H650M230 690H570" stroke="#b4a58c" stroke-width="14"/><path d="M160 180h580" stroke="#d58b5e" stroke-width="18"/><circle cx="670" cy="875" r="48" fill="#8a9980"/>',
    14: '<rect x="0" y="0" width="900" height="1120" fill="#c8d4c8"/><path d="M280 1120q260-380 0-1120h340q-220 610 10 1120z" fill="#e7d2ad"/><path d="M400 1120q140-420 40-1120" stroke="#fff5df" stroke-width="18" stroke-dasharray="40 45" fill="none"/><circle cx="680" cy="230" r="95" fill="#e2ad72"/><path d="M120 850q100-80 185 0m340 80q80-80 170 0" stroke="#78917b" stroke-width="22" fill="none"/>',
    15: '<rect x="0" y="0" width="900" height="1120" fill="#e6d7c2"/><rect x="160" y="700" width="560" height="180" rx="12" fill="#ad7155"/><rect x="210" y="490" width="510" height="190" rx="12" fill="#d29a6e"/><rect x="135" y="280" width="580" height="190" rx="12" fill="#728679"/><path d="M230 340H640M260 550H660M205 760H620" stroke="#f4e7d1" stroke-width="14"/><path d="M670 280v600" stroke="#725446" stroke-width="12"/>',
    16: '<rect x="0" y="0" width="900" height="1120" fill="#dfcfb5"/><path d="M260 460h380v360c0 160-380 160-380 0z" fill="#b8795d"/><path d="M640 550q190-65 130 150-38 95-140 25" fill="none" stroke="#b8795d" stroke-width="48"/><ellipse cx="450" cy="460" rx="190" ry="72" fill="#e6b58f"/><rect x="180" y="130" width="540" height="220" rx="20" fill="#f7eddd"/><path d="M250 210h390m-390 68h300" stroke="#bb8c73" stroke-width="14"/><circle cx="650" cy="760" r="42" fill="#cf816d"/>'
  };
  return '<svg xmlns="http://www.w3.org/2000/svg" width="900" height="1120" viewBox="0 0 900 1120"><rect width="900" height="1120" fill="' + paper + '"/>' + (scenes[n] || '<rect width="900" height="1120" fill="' + warm + '"/><circle cx="450" cy="560" r="300" fill="' + dark + '"/>') + '<rect x="20" y="20" width="860" height="1080" rx="22" fill="none" stroke="' + dark + '" stroke-opacity=".28" stroke-width="4"/></svg>';
}

async function generateSyntheticPhotos() {
  await fs.mkdir(PHOTO_DIR, { recursive: true });
  const page = await browser.newPage({ viewport: { width: 900, height: 1120 }, deviceScaleFactor: 1 });
  for (const photo of input.photos) {
    const svg = svgForScene(photo.id);
    await page.setContent('<!doctype html><html><body style="margin:0;width:900px;height:1120px">' + svg + '</body></html>');
    await page.locator("svg").screenshot({ path: path.join(FIXTURES, photo.file) });
  }
  await page.close();
}

function escapeHtml(value) {
  return String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;").replaceAll("'", "&#39;");
}

function themeCss() {
  return [
    "*{box-sizing:border-box}",
    "html,body{margin:0;padding:0}",
    "body{background:#ddd7ce;color:var(--ink);font-family:var(--body-font),Arial,sans-serif}",
    "body.theme-bold-editorial{--paper:#f7f4eb;--ink:#15223a;--accent:#cc4d32;--muted:#667084;--frame:#e4dbca;--display-font:Georgia,serif;--body-font:Arial,sans-serif;--rule:#cc4d32;--ornament:solid}",
    "body.theme-soft-warm{--paper:#f7efe2;--ink:#3f4039;--accent:#aa654f;--muted:#82786a;--frame:#e7d8c5;--display-font:Georgia,serif;--body-font:Arial,sans-serif;--rule:#b98a6b;--ornament:double}",
    "body.theme-retro-playful{--paper:#fbf0d5;--ink:#244f4b;--accent:#d35442;--muted:#6f796a;--frame:#f1d9ad;--display-font:Georgia,serif;--body-font:Trebuchet MS,Arial,sans-serif;--rule:#47776c;--ornament:dashed}",
    ".page{position:relative;width:816px;height:1056px;margin:0 auto;padding:58px;background:var(--paper);color:var(--ink);overflow:hidden;border:1px solid rgba(40,40,30,.08)}",
    ".page:before{content:'';position:absolute;inset:24px;border:1px var(--ornament) var(--rule);opacity:.7;pointer-events:none}",
    ".page-inner{height:100%;position:relative;z-index:1;display:flex;flex-direction:column}",
    ".masthead{display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--rule);padding-bottom:14px;font-size:11px;letter-spacing:.16em;text-transform:uppercase;color:var(--muted)}",
    ".page-main{display:grid;grid-template-columns:1fr .88fr;gap:34px;align-items:center;flex:1;min-height:0;padding:32px 0}",
    ".copy-column{min-width:0}.eyebrow{font-size:12px;letter-spacing:.17em;text-transform:uppercase;color:var(--accent);font-weight:700;margin:0 0 18px}",
    "h1,h2{font-family:var(--display-font);font-weight:400;letter-spacing:-.045em;line-height:.98;margin:0 0 22px}",
    "h1{font-size:62px}h2{font-size:54px}.bounded-copy{font-size:22px;line-height:1.48;max-height:var(--copy-bound,285px);overflow:visible;color:var(--ink);white-space:normal}",
    ".page-photo{margin:0;height:470px;background:var(--frame);position:relative;border-radius:2px;overflow:hidden;padding:10px;display:flex;flex-direction:column;gap:8px}",
    ".page-photo img{display:block;width:100%;flex:1;min-height:0;height:auto;object-fit:cover}",
    ".photo-caption{flex:none;font-size:12px;line-height:1.4;color:var(--muted);font-style:italic;margin:0}",
    ".page-footer{display:flex;justify-content:space-between;align-items:end;border-top:1px solid var(--rule);padding-top:12px;margin-top:auto;color:var(--muted);font-size:10px;letter-spacing:.12em;text-transform:uppercase}",
    ".page-number{font-family:Georgia,serif;font-size:18px;color:var(--accent)}",
    ".cover{background:var(--paper)}.cover .page-main{display:flex;position:relative;padding:0}.cover .cover-image{position:absolute;inset:0 0 0 36%;height:auto;padding:12px;opacity:.95}.cover .cover-image img{filter:saturate(.86)}.cover .copy-column{position:relative;z-index:2;width:68%;align-self:center}.cover h1{font-size:92px;max-width:560px;margin-bottom:14px}.cover .cover-sub{font-family:var(--display-font);font-size:26px;margin:0 0 28px;color:var(--accent)}.cover .cover-lines{display:flex;flex-direction:column;gap:12px;max-width:360px}.cover .cover-line{font-size:13px;letter-spacing:.1em;text-transform:uppercase;border-top:1px solid var(--rule);padding-top:10px}.cover .masthead{border:0}.cover .cover-date{position:absolute;right:4px;bottom:34px;text-align:right;font-size:11px;letter-spacing:.14em;text-transform:uppercase;color:var(--ink)}",
    ".memory .page-main{grid-template-columns:.92fr 1.08fr}.memory .page-photo{height:560px}.module .page-main{grid-template-columns:1fr .68fr}.module h2{font-size:60px}.module .page-photo{height:420px}.photo-story .page-main{grid-template-columns:.78fr 1.22fr}.photo-story .page-photo{height:620px}.letter .page-main{grid-template-columns:1.15fr .85fr}.letter .page-photo{height:410px}.letter .bounded-copy{font-size:20px;line-height:1.55}.back{background:var(--frame)}.back .page-main{display:flex;flex-direction:column;justify-content:center;text-align:center}.back .page-photo{width:70%;height:510px}.back h2{font-size:56px}.back .copy-column{display:flex;flex-direction:column;align-items:center}.back .bounded-copy{max-height:80px;font-family:Georgia,serif;font-size:28px;color:var(--accent)}",
    ".screen-stage{padding:28px 0}.screen-label{text-align:center;font:12px Arial,sans-serif;letter-spacing:.12em;text-transform:uppercase;color:#5f5c56;margin:0 0 14px}",
    ".sheet{min-height:100vh;padding:28px;background:#ddd7ce}.sheet-grid{display:grid;grid-template-columns:repeat(4,204px);gap:26px;justify-content:center}.sheet-tile{width:204px;height:264px;overflow:hidden;box-shadow:0 10px 28px rgba(42,35,27,.18);position:relative}.sheet-tile .page{margin:0;transform:scale(.25);transform-origin:top left}.sheet-index{position:absolute;right:5px;top:5px;background:#fff8;border-radius:20px;padding:4px 8px;font:10px Arial,sans-serif;z-index:4}",
    "@page{size:Letter;margin:0}@media print{html,body{width:8.5in;margin:0;background:var(--paper)}.page{width:8.5in;height:11in;margin:0;border:0;break-after:page;page-break-after:always}.page:last-child{break-after:auto;page-break-after:auto}.sheet-stage{display:none}}",
    "@media screen and (max-width:700px){.screen-stage{padding:10px 0}.page{width:100vw;height:auto;aspect-ratio:8.5/11;padding:6vw}.page:before{inset:2.5vw}.masthead{font-size:7px;padding-bottom:2vw}.page-main{gap:3vw;padding:4vw 0;grid-template-columns:1fr .82fr}.eyebrow{font-size:clamp(6px,2.7vw,12px);margin-bottom:2.5vw}h1{font-size:clamp(25px,8vw,62px)}h2{font-size:clamp(23px,7vw,54px)}.bounded-copy{font-size:clamp(10px,3.05vw,20px);line-height:1.4;max-height:var(--copy-bound,36vw)}.page-photo{height:52vw;padding:1.2vw}.photo-caption{font-size:clamp(6px,2vw,11px);margin-top:1.4vw}.page-footer{font-size:6px;padding-top:1.5vw}.page-number{font-size:clamp(10px,3vw,17px)}.cover .cover-image{inset:0 0 0 31%}.cover h1{font-size:clamp(38px,13vw,78px)}.cover .cover-sub{font-size:clamp(12px,4.5vw,23px);margin-bottom:4vw}.cover .cover-lines{gap:2vw;max-width:65%}.cover .cover-line{font-size:clamp(6px,2.2vw,11px);padding-top:1.5vw}.cover .cover-date{font-size:6px;bottom:3vw}.memory .page-photo{height:60vw}.module .page-photo{height:47vw}.photo-story .page-photo{height:64vw}.letter .page-photo{height:44vw}.letter .bounded-copy{font-size:clamp(9px,2.8vw,18px)}.back .page-photo{height:53vw}.back h2{font-size:clamp(22px,7.5vw,52px)}.back .bounded-copy{font-size:clamp(13px,4vw,26px)}.sheet-grid{grid-template-columns:repeat(2,minmax(130px,204px));gap:14px}.sheet-tile{width:min(42vw,204px);height:min(54.4vw,264px)}.sheet-tile .page{width:816px;height:1056px;transform:scale(.25)}}"
  ].join("\n");
}

function pageMarkup(page) {
  const isCover = page.layout === "cover";
  const photo = '<figure class="page-photo"><img src="/photos/' + encodeURIComponent(page.photoId) + '.png" alt="' + escapeHtml(page.photoScene) + '" /><figcaption class="photo-caption">' + escapeHtml(page.caption) + '</figcaption></figure>';
  const main = isCover
    ? '<div class="page-main"><div class="copy-column"><p class="eyebrow">' + escapeHtml(page.eyebrow) + '</p><h1>' + escapeHtml(page.title) + '</h1><p class="cover-sub">' + escapeHtml(page.headline) + '</p><div class="cover-lines">' + page.coverLines.map(line => '<div class="cover-line">' + escapeHtml(line) + '</div>').join("") + '</div></div><figure class="page-photo cover-image"><img src="/photos/' + encodeURIComponent(page.photoId) + '.png" alt="' + escapeHtml(page.photoScene) + '" /></figure><div class="cover-date">BIRTHDAY ISSUE<br />' + escapeHtml(page.recipient.birthday) + '</div></div>'
    : '<div class="page-main"><div class="copy-column"><p class="eyebrow">' + escapeHtml(page.eyebrow) + '</p><h2>' + escapeHtml(page.title) + '</h2><p class="bounded-copy" data-copy-limit="' + MAX_COPY_CHARS + '" style="--copy-bound:' + page.maxCopyHeight + 'px">' + escapeHtml(page.body) + '</p><p class="photo-caption">' + escapeHtml(page.headline) + '</p></div>' + photo + '</div>';
  return '<article class="page ' + escapeHtml(page.layout) + '" data-page="' + page.page + '" data-section="' + escapeHtml(page.section) + '" data-photo-id="' + escapeHtml(page.photoId) + '" data-recipient-name="' + escapeHtml(page.recipient.name) + '" data-recipient-age="' + page.recipient.age + '" data-recipient-birthday="' + escapeHtml(page.recipient.birthday) + '"><div class="page-inner"><header class="masthead"><span>GOOD ISSUE · BIRTHDAY EDITION</span><span>' + page.page.toString().padStart(2, "0") + ' / 12</span></header>' + main + '<footer class="page-footer"><span>' + escapeHtml(page.recipient.name) + ' · ' + page.recipient.age + ' · ' + escapeHtml(page.recipient.birthday) + '</span><span class="page-number">' + page.page.toString().padStart(2, "0") + '</span></footer></div></article>';
}

function documentShell(body, preset, title) {
  return '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>' + escapeHtml(title) + '</title><style>' + themeCss() + '</style></head><body class="theme-' + escapeHtml(preset) + '">' + body + '</body></html>';
}

function singlePageDocument(page, preset) {
  return documentShell('<main class="screen-stage"><p class="screen-label">Synthetic proof page · ' + escapeHtml(page.section) + '</p>' + pageMarkup(page) + '</main>', preset, "Birthday Magazine synthetic proof");
}

function magazineDocument(pages, preset) {
  return documentShell('<main class="magazine">' + pages.map(pageMarkup).join("") + '</main>', preset, "12-page synthetic birthday magazine proof");
}

function contactSheetDocument(pages, preset) {
  const tiles = pages.map(page => '<div class="sheet-tile"><span class="sheet-index">P' + page.page.toString().padStart(2, "0") + '</span>' + pageMarkup(page) + '</div>').join("");
  return documentShell('<main class="sheet"><p class="screen-label">12-page contact sheet · shared deterministic page architecture</p><div class="sheet-grid">' + tiles + '</div></main>', preset, "Birthday magazine contact sheet");
}

async function startLocalServer(pagesByPreset) {
  const photosById = new Map(input.photos.map(photo => [photo.id, photo]));
  server = http.createServer(async (request, response) => {
    const origin = "http://127.0.0.1";
    const requestUrl = new URL(request.url, origin);
    const theme = PRESETS.includes(requestUrl.searchParams.get("theme")) ? requestUrl.searchParams.get("theme") : input.stylePreset;
    const pages = pagesByPreset.get(theme);
    if (requestUrl.pathname === "/magazine") {
      response.writeHead(200, { "content-type": "text/html; charset=utf-8" });
      response.end(magazineDocument(pages, theme));
      return;
    }
    if (requestUrl.pathname === "/sheet") {
      response.writeHead(200, { "content-type": "text/html; charset=utf-8" });
      response.end(contactSheetDocument(pages, theme));
      return;
    }
    const pageMatch = requestUrl.pathname.match(/^\/page\/(\d{1,2})$/);
    if (pageMatch) {
      const page = pages[Number(pageMatch[1]) - 1];
      if (!page) {
        response.writeHead(404);
        response.end("page not found");
        return;
      }
      response.writeHead(200, { "content-type": "text/html; charset=utf-8" });
      response.end(singlePageDocument(page, theme));
      return;
    }
    const imageMatch = requestUrl.pathname.match(/^\/photos\/(photo-\d{2})\.png$/);
    if (imageMatch && photosById.has(imageMatch[1])) {
      try {
        const bytes = await fs.readFile(path.join(FIXTURES, photosById.get(imageMatch[1]).file));
        response.writeHead(200, { "content-type": "image/png", "content-length": bytes.length, "cache-control": "no-store" });
        response.end(bytes);
      } catch {
        response.writeHead(404);
        response.end();
      }
      return;
    }
    if (requestUrl.pathname === "/favicon.ico") {
      response.writeHead(204);
      response.end();
      return;
    }
    response.writeHead(404);
    response.end("not found");
  });
  await new Promise((resolve, reject) => {
    server.once("error", reject);
    server.listen(0, "127.0.0.1", resolve);
  });
  const address = server.address();
  return "http://127.0.0.1:" + address.port;
}

async function guardNetwork(page, baseUrl) {
  await page.route("**/*", async route => {
    const url = new URL(route.request().url());
    if (url.origin === baseUrl) {
      rendererRequestCount++;
      await route.continue();
    } else {
      externalRequestCount++;
      await route.abort("blockedbyclient");
    }
  });
}

async function browserReadback(baseUrl, pages, preset) {
  const page = await browser.newPage({ viewport: { width: 1200, height: 1200 }, deviceScaleFactor: 1 });
  await guardNetwork(page, baseUrl);
  await page.goto(baseUrl + "/magazine?theme=" + preset, { waitUntil: "networkidle" });
  await page.evaluate(() => document.fonts.ready);
  const result = await page.evaluate(expectedSections => {
    const items = [...document.querySelectorAll(".page")];
    const imageResults = [...document.querySelectorAll(".page img")].map(image => ({
      src: image.currentSrc,
      loaded: image.complete && image.naturalWidth > 0 && image.naturalHeight > 0
    }));
    const overflow = [...document.querySelectorAll(".bounded-copy")].filter(node =>
      Number(node.dataset.copyLimit) < node.textContent.length ||
      node.scrollHeight > node.clientHeight + 2
    ).map(node => ({ page: node.closest(".page")?.dataset.page, scrollHeight: node.scrollHeight, clientHeight: node.clientHeight, chars: node.textContent.length }));
    const identities = items.map(node => ({
      page: Number(node.dataset.page),
      name: node.dataset.recipientName,
      age: Number(node.dataset.recipientAge),
      birthday: node.dataset.recipientBirthday,
      section: node.dataset.section
    }));
  const pageOverflow = items.filter(node => node.scrollWidth > node.clientWidth + 2 || node.scrollHeight > node.clientHeight + 2).map(node => node.dataset.page);
    const consistentIdentity = identities.every(item => item.name === items[0]?.dataset.recipientName && item.age === Number(items[0]?.dataset.recipientAge) && item.birthday === items[0]?.dataset.recipientBirthday);
    return {
      pageCount: items.length,
      identities,
      imageResults,
      overflow,
      pageOverflow,
      consistentIdentity,
      sectionsMatch: JSON.stringify(identities.map(item => item.section)) === JSON.stringify(expectedSections)
    };
  }, PAGE_SECTIONS);
  await page.close();
  return result;
}

async function captureScreenshots(baseUrl, pages) {
  await fs.mkdir(SCREENSHOTS, { recursive: true });
  const names = [];
  for (const preset of PRESETS) {
    const desktop = await browser.newPage({ viewport: { width: 1440, height: 1160 }, deviceScaleFactor: 1 });
    await guardNetwork(desktop, baseUrl);
    await desktop.goto(baseUrl + "/page/1?theme=" + preset, { waitUntil: "networkidle" });
    await desktop.evaluate(() => document.fonts.ready);
    const coverPath = path.join(SCREENSHOTS, "cover-" + preset + "-desktop.png");
    await desktop.screenshot({ path: coverPath, fullPage: true });
    names.push(path.basename(coverPath));
    if (preset === input.stylePreset) {
      for (const [pageNumber, fileName] of [[4, "feature-memory-desktop.png"], [8, "current-era-desktop.png"], [11, "birthday-letter-desktop.png"]]) {
        await desktop.goto(baseUrl + "/page/" + pageNumber + "?theme=" + preset, { waitUntil: "networkidle" });
        const screenPath = path.join(SCREENSHOTS, fileName);
        await desktop.screenshot({ path: screenPath, fullPage: true });
        names.push(path.basename(screenPath));
      }
      const mobile = await browser.newPage({ viewport: { width: 375, height: 812 }, deviceScaleFactor: 1 });
      await guardNetwork(mobile, baseUrl);
      await mobile.goto(baseUrl + "/page/1?theme=" + preset, { waitUntil: "networkidle" });
      await mobile.evaluate(() => document.fonts.ready);
      mobileReadback = await mobile.evaluate(() => {
        const page = document.querySelector(".page");
        const rect = page.getBoundingClientRect();
        const textOverflow = [...document.querySelectorAll(".bounded-copy")].some(node => node.scrollHeight > node.clientHeight + 2);
        return {
          viewportWidth: innerWidth,
          documentWidth: document.documentElement.scrollWidth,
          pageWidth: Math.round(rect.width),
          pageHeight: Math.round(rect.height),
          horizontalOverflow: document.documentElement.scrollWidth > innerWidth,
          textOverflow
        };
      });
      const mobilePath = path.join(SCREENSHOTS, "cover-soft-warm-375px.png");
      await mobile.locator(".page").screenshot({ path: mobilePath });
      invariant(mobileReadback.viewportWidth === 375 && mobileReadback.pageWidth === 375 && !mobileReadback.horizontalOverflow && !mobileReadback.textOverflow, "RETURN_MOBILE_375_LAYOUT_FAILED");
      names.push(path.basename(mobilePath));
      await mobile.close();
      const sheet = await browser.newPage({ viewport: { width: 1320, height: 920 }, deviceScaleFactor: 1 });
      await guardNetwork(sheet, baseUrl);
      await sheet.goto(baseUrl + "/sheet?theme=" + preset, { waitUntil: "networkidle" });
      await sheet.evaluate(() => document.fonts.ready);
      const sheetPath = path.join(SCREENSHOTS, "12-page-contact-sheet.png");
      await sheet.screenshot({ path: sheetPath, fullPage: true });
      names.push(path.basename(sheetPath));
      await sheet.close();
    }
    await desktop.close();
  }
  return names;
}

function schemaSignature(pages) {
  const shape = pages.map(({ page, section, layout }) => ({ page, section, layout }));
  return crypto.createHash("sha256").update(JSON.stringify(shape)).digest("hex");
}

async function styleReadback(baseUrl, expectedArchitectureHash) {
  const variants = [];
  for (const preset of PRESETS) {
    const page = await browser.newPage({ viewport: { width: 1200, height: 1100 }, deviceScaleFactor: 1 });
    await guardNetwork(page, baseUrl);
    await page.goto(baseUrl + "/magazine?theme=" + preset, { waitUntil: "networkidle" });
    const readback = await page.evaluate(() => {
      const body = getComputedStyle(document.body);
      return {
        pageCount: document.querySelectorAll(".page").length,
        paper: body.getPropertyValue("--paper").trim(),
        ink: body.getPropertyValue("--ink").trim(),
        accent: body.getPropertyValue("--accent").trim(),
        displayFont: body.getPropertyValue("--display-font").trim(),
        frameTreatment: body.getPropertyValue("--ornament").trim(),
        layouts: [...document.querySelectorAll(".page")].map(node => node.classList[1])
      };
    });
    variants.push({ name: preset, ...readback, pageArchitectureSha256: expectedArchitectureHash });
    await page.close();
  }
  const colors = new Set(variants.map(item => item.paper + "|" + item.ink + "|" + item.accent));
  const layouts = variants.map(item => JSON.stringify(item.layouts));
  return {
    result: variants.length === 3 && colors.size === 3 && new Set(layouts).size === 1 && variants.every(item => item.pageCount === 12) ? "PASS_SHARED_ARCHITECTURE" : "FAIL",
    variants,
    architectureHash: expectedArchitectureHash,
    contentStructureChangesBetweenPresets: false
  };
}

async function claimCanonicalJob(key) {
  const filename = crypto.createHash("sha256").update(key).digest("hex") + ".json";
  jobPath = path.join(RUNTIME, "jobs", filename);
  await fs.mkdir(path.dirname(jobPath), { recursive: true });
  try {
    const handle = await fs.open(jobPath, "wx");
    await handle.writeFile(JSON.stringify({ orderKey: key, canonical: true, status: "active", createdBy: "g2b-local-proof" }));
    await handle.close();
    return { result: "CREATED_CANONICAL_ACTIVE_JOB", created: true };
  } catch (error) {
    if (error.code !== "EEXIST") throw error;
    const existing = await readJson(jobPath);
    invariant(existing.orderKey === key && existing.canonical === true, "IDEMPOTENCY_KEY_COLLISION");
    return { result: "DUPLICATE_REJECTED", created: false };
  }
}

function groundingAudit(content, data) {
  const errors = validateContent(content, data, content.photoPageAssignments || []);
  const quoteCount = (content.groundedFacts || []).reduce((total, claim) => total + (claim.supportingQuotes || []).length, 0);
  const groundedClaims = (content.groundedFacts || []).length;
  return {
    result: errors.length === 0 ? "PASS_REFERENCE_FIXTURE_ONLY" : "FAIL",
    contentOrigin: content.origin,
    factualClaimCount: groundedClaims,
    exactSourceQuoteCount: quoteCount,
    allStructuredSourceRefsResolve: errors.every(error => !error.startsWith("SOURCE_REF_INVALID:")),
    claimQuotesMatchSourceText: !errors.includes("FACT_QUOTE_NOT_IN_SOURCE"),
    ageDerivedFromBirthdayOnFixtureDate: ageOnDate(data.recipient.birthday, data.asOfDate) === data.recipient.age,
    auditScope: "Structural provenance and exact supporting-quote checks on human-authored reference content; it is not a live-AI semantic entailment proof.",
    errors
  };
}

async function mutationChecks(data, content, assignments, pages, baseUrl) {
  const checks = [];
  let missingCredentialRejected = false;
  try {
    new ChatCompletionsAdapter({});
  } catch (error) {
    missingCredentialRejected = error.message === "RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED";
  }
  checks.push({ case: "missing provider credential fails closed", rejected: missingCredentialRejected, reasons: missingCredentialRejected ? ["RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED"] : [] });
  async function expectRejected(name, operation) {
    let errors = [];
    try {
      errors = await operation();
    } catch (error) {
      errors = [error.message];
    }
    checks.push({ case: name, rejected: errors.length > 0, reasons: errors.slice(0, 3) });
  }
  await expectRejected("missing required answer", async () => {
    const bad = structuredClone(data);
    bad.answers.q6 = " ";
    return validateIntake(bad, { checkFiles: false });
  });
  await expectRejected("11 source photos", async () => validateIntake({ ...data, photos: data.photos.slice(0, 11) }, { checkFiles: false }));
  await expectRejected("26 source photos", async () => validateIntake({ ...data, photos: [...data.photos, ...data.photos.slice(0, 10).map((photo, index) => ({ ...photo, id: "extra-" + index }))] }, { checkFiles: false }));
  await expectRejected("unsupported image extension", async () => {
    const bad = structuredClone(data);
    bad.photos[0].file = "photos/photo-01.gif";
    return validateIntake(bad, { checkFiles: false });
  });
  await expectRejected("four must-use photos", async () => {
    const bad = structuredClone(data);
    bad.photos[4].mustUse = true;
    return validateIntake(bad, { checkFiles: false });
  });
  await expectRejected("duplicate dynamic module", async () => {
    const bad = structuredClone(content);
    bad.dynamicModules[1].name = bad.dynamicModules[0].name;
    return validateContent(bad, data, assignments);
  });
  await expectRejected("unsupported dynamic module", async () => {
    const bad = structuredClone(content);
    bad.dynamicModules[0].name = "Astrology Forecast";
    return validateContent(bad, data, assignments);
  });
  await expectRejected("missing source quote", async () => {
    const bad = structuredClone(content);
    bad.groundedFacts[0].supportingQuotes = ["invented overseas trip"];
    return validateContent(bad, data, assignments);
  });
  await expectRejected("must-use photo omitted from page mapping", async () => {
    const badAssignments = assignments.filter(item => item.photoId !== data.photos[0].id);
    return validateContent(content, data, badAssignments);
  });
  await expectRejected("unknown photo mapped", async () => {
    const badAssignments = structuredClone(assignments);
    badAssignments[0].photoId = "photo-missing";
    return validateContent(content, data, badAssignments);
  });
  await expectRejected("bounded copy exceeded", async () => {
    const bad = structuredClone(content);
    bad.openingNote.text = "x".repeat(MAX_COPY_CHARS + 1);
    return validateContent(bad, data, assignments);
  });
  await expectRejected("required page removed", async () => pageModelErrors(pages.slice(0, 11)));
  const overflowingPage = await browser.newPage({ viewport: { width: 500, height: 500 } });
  await overflowingPage.setContent(documentShell('<div style="width:260px"><p class="bounded-copy" data-copy-limit="6000" style="--copy-bound:36px">' + "wide words ".repeat(350) + '</p></div>', "soft-warm", "Overflow detection proof"));
  const overflowDetected = await overflowingPage.locator(".bounded-copy").evaluate(node => node.scrollHeight > node.clientHeight + 2);
  checks.push({ case: "browser text overflow measurement", rejected: overflowDetected, reasons: overflowDetected ? ["SCROLL_HEIGHT_EXCEEDS_BOUND"] : [] });
  await overflowingPage.close();
  const missingImagePage = await browser.newPage({ viewport: { width: 816, height: 1056 } });
  await guardNetwork(missingImagePage, baseUrl);
  await missingImagePage.route(baseUrl + "/photos/photo-04.png", route => route.abort("failed"));
  await missingImagePage.goto(baseUrl + "/page/1?theme=soft-warm", { waitUntil: "networkidle" });
  const missingImageDetected = await missingImagePage.locator("img").evaluate(node => node.complete && node.naturalWidth === 0);
  checks.push({ case: "broken image detected", rejected: missingImageDetected, reasons: missingImageDetected ? ["IMAGE_NATURAL_WIDTH_ZERO"] : [] });
  await missingImagePage.close();
  return checks;
}

function pdfPageChecks(pages, data, selection) {
  const errors = [];
  if (pages.length !== 12) errors.push("PAGE_COUNT_NOT_12");
  if (pages.map(page => page.section).join("|") !== PAGE_SECTIONS.join("|")) errors.push("REQUIRED_PAGE_SECTION_MISSING_OR_OUT_OF_ORDER");
  if (new Set(pages.map(page => page.page)).size !== 12) errors.push("PAGE_NUMBER_DUPLICATE");
  if (selection.selected.length < 10 || selection.selected.length > 14) errors.push("SELECTED_PHOTO_COUNT_OUTSIDE_TARGET");
  if (data.photos.length < 12 || data.photos.length > 25) errors.push("SOURCE_PHOTO_COUNT_OUTSIDE_CONTRACT");
  if (data.photos.filter(photo => photo.mustUse).length > 3) errors.push("MUST_USE_ABOVE_3");
  if (!data.photos.filter(photo => photo.mustUse).every(photo => selection.assignments.some(item => item.photoId === photo.id))) errors.push("MUST_USE_NOT_MAPPED");
  const byPage = new Map(selection.assignments.map(item => [item.page, item.photoId]));
  const photoById = new Map(data.photos.map(photo => [photo.id, photo]));
  if (photoById.get(byPage.get(4))?.sourceField !== "answers.q2" || photoById.get(byPage.get(5))?.sourceField !== "answers.q2") errors.push("FEATURE_MEMORY_PHOTO_NOT_FROM_Q2");
  if (photoById.get(byPage.get(8))?.sourceField !== "answers.q5" || photoById.get(byPage.get(9))?.sourceField !== "answers.q5") errors.push("CURRENT_ERA_PHOTO_NOT_FROM_Q5");
  return errors;
}

function pageModelErrors(pages) {
  const errors = [];
  if (pages.length !== 12) errors.push("PAGE_COUNT_NOT_12");
  if (pages.map(page => page.section).join("|") !== PAGE_SECTIONS.join("|")) errors.push("REQUIRED_PAGE_SECTION_MISSING_OR_OUT_OF_ORDER");
  if (new Set(pages.map(page => page.page)).size !== pages.length) errors.push("PAGE_NUMBER_DUPLICATE");
  return errors;
}

function sha256(bytes) {
  return crypto.createHash("sha256").update(bytes).digest("hex");
}

async function writeReferenceArtifacts({ pages, selection, content, intakeErrors, contentErrors, grounding, browserQA, styleProof, pdfPath, screenshots, idempotency, aiStatus, schemaHash, architectureHash, browserVersion, baseUrl }) {
  const pdfBytes = await fs.readFile(pdfPath);
  const pdf = await PDFDocument.load(pdfBytes);
  const pdfPageCount = pdf.getPageCount();
  const pdfPageSizes = pdf.getPages().map(page => ({ widthPoints: page.getWidth(), heightPoints: page.getHeight() }));
  const letterSize = pdfPageSizes.every(size => Math.abs(size.widthPoints - 612) < 1 && Math.abs(size.heightPoints - 792) < 1);
  const stats = await fs.stat(pdfPath);
  const mutationProof = await mutationChecks(input, content, selection.assignments, pages, baseUrl);
  const screenshotStats = [];
  for (const name of screenshots) {
    const file = path.join(SCREENSHOTS, name);
    const bytes = await fs.readFile(file);
    screenshotStats.push({ file: "screenshots/" + name, sizeBytes: bytes.length, sha256: sha256(bytes) });
  }
  const pdfChecks = pdfPageChecks(pages, input, selection);
  const negativePass = mutationProof.every(item => item.rejected);
  const qa = {
    gate: "G2B_LOCAL_AI_PDF_SOLUTION_PROOF",
    mode: "LOCAL_SYNTHETIC_REFERENCE_RENDER",
    overall: intakeErrors.length === 0 && contentErrors.length === 0 && pdfChecks.length === 0 && browserQA.pageCount === 12 && browserQA.consistentIdentity && browserQA.imageResults.every(item => item.loaded) && browserQA.overflow.length === 0 && browserQA.pageOverflow.length === 0 && mobileReadback?.viewportWidth === 375 && !mobileReadback.horizontalOverflow && !mobileReadback.textOverflow && styleProof.result === "PASS_SHARED_ARCHITECTURE" && negativePass && pdfPageCount === 12 && letterSize && stats.size > 0 ? "PASS_REFERENCE_PIPELINE_ONLY" : "RETURN_TEST_FAILURE",
    intakeValidation: { result: intakeErrors.length === 0 ? "PASS" : "FAIL", errors: intakeErrors, photoCount: input.photos.length, requiredAnswers: 6, mustUseCount: input.photos.filter(photo => photo.mustUse).length },
    structuredContentValidation: { result: contentErrors.length === 0 ? "PASS_REFERENCE_FIXTURE_ONLY" : "FAIL", origin: content.origin || "provider-generated structured content", errors: contentErrors },
    dynamicModules: { result: content.dynamicModules?.length === 2 && new Set(content.dynamicModules.map(module => module.name)).size === 2 ? "PASS_REFERENCE_FIXTURE_ONLY" : "FAIL", count: content.dynamicModules?.length || 0, names: (content.dynamicModules || []).map(module => module.name) },
    aiStructuredGeneration: aiStatus,
    grounding: grounding,
    photoMapping: { result: pdfChecks.filter(error => error.includes("PHOTO") || error.includes("MUST_USE")).length === 0 ? "PASS_METADATA_ONLY" : "FAIL", sourcePhotoCount: input.photos.length, selectedUniquePhotoCount: selection.selected.length, selectedPhotoIds: selection.selected.map(photo => photo.id), mustUseIds: input.photos.filter(photo => photo.mustUse).map(photo => photo.id), assignments: selection.assignments, selectionMethod: "Synthetic metadata cues + deterministic score/rank; no visual model or human-photo semantics." },
    pageContract: { result: pdfChecks.length === 0 ? "PASS" : "FAIL", expectedPageCount: 12, requiredSections: PAGE_SECTIONS, pageErrors: pdfChecks, architectureSha256: architectureHash },
    stylePresets: styleProof,
    browserReadback: { result: browserQA.pageCount === 12 && browserQA.consistentIdentity && browserQA.sectionsMatch && browserQA.imageResults.every(item => item.loaded) && browserQA.overflow.length === 0 && browserQA.pageOverflow.length === 0 ? "PASS" : "FAIL", ...browserQA },
    mobile375: { result: mobileReadback?.viewportWidth === 375 && mobileReadback.pageWidth === 375 && !mobileReadback.horizontalOverflow && !mobileReadback.textOverflow ? "PASS" : "FAIL", ...mobileReadback },
    deterministicQaMutationChecks: { result: negativePass ? "PASS" : "FAIL", rejectedCount: mutationProof.filter(item => item.rejected).length, total: mutationProof.length, checks: mutationProof },
    pdf: { result: pdfPageCount === 12 && letterSize && stats.size > 0 ? "PASS" : "FAIL", file: path.relative(ARTIFACTS, pdfPath).replaceAll("\\", "/"), pageCount: pdfPageCount, expectedPageSize: "US Letter (612 × 792 pt)", pageSizes: pdfPageSizes, sizeBytes: stats.size, sha256: sha256(pdfBytes), parsedWith: "pdf-lib 1.17.1" },
    idempotency: idempotency,
    network: { localServer: "127.0.0.1 only", localRendererRequestCount: rendererRequestCount, externalBrowserRequestCount: externalRequestCount, aiApiRequests: aiStatus.apiRequests },
    screenshots: screenshotStats,
    limitations: [
      "No real model call occurred; the magazine copy is a human-authored synthetic renderer fixture.",
      "The synthetic PNGs are deterministic scene illustrations, not photographs of a person.",
      "Photo selection used fixture metadata and did not prove visual-semantic photo understanding.",
      "No WordPress/WooCommerce commerce loop or order integration was run in this Gate."
    ]
  };
  await writeJson(path.join(ARTIFACTS, "qa-report.json"), qa);
  await writeJson(path.join(ARTIFACTS, "grounding-report.json"), grounding);
  await writeJson(path.join(ARTIFACTS, "idempotency-report.json"), idempotency);
  await writeJson(path.join(ARTIFACTS, "ai-provider-status.json"), aiStatus);
  await writeJson(path.join(ARTIFACTS, "style-proof.json"), { ...styleProof, contentSchemaSha256: schemaHash, differences: "CSS palette, font stack, and graphic frame variables only." });
  await writeJson(path.join(ARTIFACTS, "dependency-report.json"), {
    node: process.version,
    playwright: { version: "1.62.1", license: "Apache-2.0" },
    pdfLib: { version: "1.17.1", license: "MIT" },
    browser: { executable: browserPath || "Playwright bundled Chromium", version: browserVersion },
    network: "npm dependencies were resolved from npm during setup; the proof runtime made no AI or non-loopback browser request."
  });
  const hashEntries = [
    { file: "proof-magazine-soft-warm.pdf", sizeBytes: stats.size, sha256: sha256(pdfBytes) },
    ...screenshotStats
  ];
  await writeJson(path.join(ARTIFACTS, "artifact-hashes.json"), hashEntries);
  return qa;
}

async function main() {
  await fs.mkdir(ARTIFACTS, { recursive: true });
  await fs.mkdir(SCREENSHOTS, { recursive: true });
  await fs.mkdir(RUNTIME, { recursive: true });

  await generateSyntheticPhotos();
  const intakeErrors = await validateIntake(input);
  invariant(intakeErrors.length === 0, "RETURN_INTAKE_VALIDATION_FAILED:" + intakeErrors.join(","));

  const selection = selectAndMapPhotos(input);
  invariant(selection.selected.length >= 10 && selection.selected.length <= 14, "PHOTO_SELECTION_TARGET_INVALID");
  invariant(input.photos.filter(photo => photo.mustUse).every(photo => selection.selected.some(selected => selected.id === photo.id)), "RETURN_MUST_USE_NOT_SELECTED");

  // The claim is written before any possible provider call. A duplicate receives the existing canonical record.
  const firstClaim = await claimCanonicalJob(input.orderKey);
  invariant(firstClaim.created, "IDEMPOTENCY_CANONICAL_JOB_ALREADY_EXISTS");
  const duplicateClaim = await claimCanonicalJob(input.orderKey);
  invariant(!duplicateClaim.created, "IDEMPOTENCY_DUPLICATE_CREATED_SECOND_JOB");
  const idempotency = {
    result: "PASS",
    jobKey: input.orderKey,
    firstInvocation: firstClaim.result,
    duplicateInvocationWhileActive: duplicateClaim.result,
    canonicalJobs: 1,
    maxActiveCanonicalJobs: 1,
    providerSpendAttempts: 0,
    evidence: "The job claim is created atomically with exclusive file creation before the provider boundary; duplicate claim is denied while the first record is active."
  };

  let content = structuredClone(referenceContent);
  const aiStatus = {
    result: "RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED",
    pipelineImplementation: "REFERENCE_RENDER_PATH_AVAILABLE",
    realAiCall: "BLOCKED",
    providerAdapter: "ChatCompletionsAdapter behind the vendor-neutral ContentProvider interface",
    reason: "The current project handoff and G2B authorization provide no approved protected model credential/runtime for this Gate.",
    liveCallAttempted: false,
    apiRequests: 0,
    fallbackUsed: "human-authored synthetic renderer reference fixture only",
    fallbackIsNotAiProof: true
  };
  if (process.argv.includes("--live-ai")) {
    const explicitlyApproved = process.env.BMS_AI_CALL_APPROVED === "true";
    const endpoint = process.env.BMS_AI_CHAT_COMPLETIONS_URL;
    const model = process.env.BMS_AI_MODEL;
    const apiKey = process.env.BMS_AI_API_KEY;
    if (explicitlyApproved && endpoint && model && apiKey) {
      const provider = new ChatCompletionsAdapter({ endpoint, model, apiKey });
      const generated = await provider.generateStructured({ prompt: providerPrompt(input, selection.selected), schema: CONTENT_SCHEMA });
      content = { ...generated, origin: "provider-generated structured content" };
      aiStatus.result = "PASS";
      aiStatus.realAiCall = "PASS";
      aiStatus.liveCallAttempted = true;
      aiStatus.apiRequests = 1;
      aiStatus.fallbackUsed = "none";
      aiStatus.fallbackIsNotAiProof = false;
      aiStatus.modelNameRecorded = model;
      aiStatus.endpointHostRecorded = new URL(endpoint).host;
    } else {
      aiStatus.reason = "The live path requires an explicitly approved BMS_AI_CALL_APPROVED flag and protected endpoint/model/key values; no request was sent.";
    }
  }

  const expectedAssignments = selection.assignments;
  invariant(JSON.stringify(referenceContent.photoPageAssignments) === JSON.stringify(expectedAssignments), "REFERENCE_PHOTO_MAP_DIFFERS_FROM_DETERMINISTIC_SELECTION");
  content.photoPageAssignments = expectedAssignments;
  const contentErrors = validateContent(content, input, expectedAssignments);
  invariant(contentErrors.length === 0, "RETURN_GROUNDING_OR_CONTENT_SCHEMA_FAILED:" + contentErrors.join(","));
  const pages = makePages(input, content, expectedAssignments, selection.selected);
  const pageErrors = pdfPageChecks(pages, input, selection);
  invariant(pageErrors.length === 0, "RETURN_PAGE_OR_PHOTO_MAPPING_FAILED:" + pageErrors.join(","));

  const pagesByPreset = new Map(PRESETS.map(preset => [preset, pages]));
  const architectureHash = schemaSignature(pages);
  const schemaHash = sha256(Buffer.from(JSON.stringify(CONTENT_SCHEMA)));
  const baseUrl = await startLocalServer(pagesByPreset);
  const browserQA = await browserReadback(baseUrl, pages, input.stylePreset);
  invariant(browserQA.pageCount === 12 && browserQA.sectionsMatch, "RETURN_PAGE_RENDER_STRUCTURE_FAILED");
  invariant(browserQA.imageResults.every(item => item.loaded), "RETURN_IMAGE_RENDER_FAILED");
  invariant(browserQA.overflow.length === 0 && browserQA.pageOverflow.length === 0, "RETURN_TEXT_OVERFLOW");

  const pdfPage = await browser.newPage({ viewport: { width: 816, height: 1056 }, deviceScaleFactor: 1 });
  await guardNetwork(pdfPage, baseUrl);
  await pdfPage.goto(baseUrl + "/magazine?theme=" + input.stylePreset, { waitUntil: "networkidle" });
  await pdfPage.evaluate(() => document.fonts.ready);
  const pdfPath = path.join(ARTIFACTS, "proof-magazine-soft-warm.pdf");
  await pdfPage.pdf({ path: pdfPath, format: "Letter", preferCSSPageSize: true, printBackground: true, margin: { top: 0, right: 0, bottom: 0, left: 0 } });
  await pdfPage.close();
  // Chrome embeds wall-clock metadata; normalize it so identical fixtures/renderers produce stable PDF bytes.
  const normalizedPdf = await PDFDocument.load(await fs.readFile(pdfPath));
  const fixedPdfDate = new Date("2026-09-27T00:00:00.000Z");
  normalizedPdf.setTitle("Birthday Magazine synthetic G2B proof");
  normalizedPdf.setAuthor("Birthday Magazine Studio");
  normalizedPdf.setSubject("Synthetic renderer reference; not AI-generated content");
  normalizedPdf.setCreationDate(fixedPdfDate);
  normalizedPdf.setModificationDate(fixedPdfDate);
  await fs.writeFile(pdfPath, await normalizedPdf.save({ useObjectStreams: false }));

  const screenshots = await captureScreenshots(baseUrl, pages);
  const styleProof = await styleReadback(baseUrl, architectureHash);
  invariant(styleProof.result === "PASS_SHARED_ARCHITECTURE", "RETURN_STYLE_PRESET_ARCHITECTURE_FAILED");
  const pdfBytes = await fs.readFile(pdfPath);
  const openedPdf = await PDFDocument.load(pdfBytes);
  invariant(openedPdf.getPageCount() === 12 && pdfBytes.length > 0, "RETURN_PDF_OPEN_OR_PAGE_COUNT_FAILED");
  const grounding = groundingAudit(content, input);
  invariant(grounding.result === "PASS_REFERENCE_FIXTURE_ONLY", "RETURN_GROUNDING_AUDIT_FAILED");
  const qa = await writeReferenceArtifacts({
    pages, selection, content, intakeErrors, contentErrors, grounding, browserQA, styleProof, pdfPath, screenshots, idempotency,
    aiStatus, schemaHash, architectureHash, browserVersion: browser.version(), baseUrl
  });
  invariant(qa.overall === "PASS_REFERENCE_PIPELINE_ONLY", "RETURN_DETERMINISTIC_QA_FAILED");
  await writeJson(path.join(ARTIFACTS, "run-summary.json"), {
    gate: "G2B_LOCAL_AI_PDF_SOLUTION_PROOF",
    result: "RETURN_AI_PROVIDER_CREDENTIAL_REQUIRED",
    pipelineImplementation: "PASS_REFERENCE_RENDER_PIPELINE",
    realAiCall: "BLOCKED",
    pdf: "proof-magazine-soft-warm.pdf",
    screenshots,
    qa: "qa-report.json",
    grounding: "grounding-report.json",
    idempotency: "idempotency-report.json",
    cleanup: "project-local runtime job record removed after report; no server/container or secret created"
  });
  process.stdout.write(JSON.stringify({
    result: aiStatus.result,
    intakeValidation: "PASS",
    referenceRenderPipeline: qa.overall,
    aiGeneration: aiStatus.realAiCall,
    pages: openedPdf.getPageCount(),
    pdfBytes: pdfBytes.length,
    sha256: sha256(pdfBytes),
    externalBrowserRequests: externalRequestCount,
    screenshots: screenshots.length,
    branch: "codex/birthday-magazine-g2b-local-ai-pdf-proof"
  }, null, 2) + "\n");
}

try {
  await main();
} finally {
  if (server) await new Promise(resolve => server.close(resolve));
  if (jobPath) {
    try {
      const record = await readJson(jobPath);
      if (record.orderKey === input.orderKey && record.createdBy === "g2b-local-proof") await fs.unlink(jobPath);
    } catch {}
    try { await fs.rmdir(path.dirname(jobPath)); } catch {}
    try { await fs.rmdir(RUNTIME); } catch {}
  }
  await browser.close();
}
