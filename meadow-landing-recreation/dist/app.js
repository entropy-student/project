const meadow = document.querySelector('.meadow');
const base = document.querySelector('.world-base');
const reveal = document.querySelector('.world-reveal');
const toggle = document.querySelector('.theme-toggle');
const status = document.querySelector('#theme-status');
const canvas = document.querySelector('canvas');
const ctx = canvas.getContext('2d');
const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)');
const assetsReady = Promise.all([...document.querySelectorAll('.world img')].map(image => image.decode()));
let day = true;
let busy = false;
let hovered = false;
let width = 0, height = 0;
let pointer = { x: .5, y: .72 };
let smooth = { ...pointer };
let lastTime = 0;
let lastSpawn = 0;
let frameId;
const trail = [];

function resize() {
  const box = meadow.getBoundingClientRect();
  width = box.width; height = box.height;
  const dpr = Math.min(devicePixelRatio || 1, 2);
  canvas.width = Math.round(width * dpr);
  canvas.height = Math.round(height * dpr);
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  meadow.style.setProperty('--feather', `${Math.max(45, height * .105)}px`);
}
function setPointer(event) {
  const box = meadow.getBoundingClientRect();
  pointer = { x: (event.clientX - box.left) / width, y: (event.clientY - box.top) / height };
}
function setWorld(world, isDay) {
  const theme = isDay ? 'day' : 'night';
  world.querySelector('source').srcset = `assets/scene-mobile-${theme}.svg`;
  world.querySelector('.scene').src = `assets/scene-${theme}.svg`;
  world.querySelector('.wordmark').src = `assets/wordmark-${theme}.svg`;
}
function setInk(isDay) {
  meadow.style.setProperty('--ink', isDay ? '#303840' : '#cfd5e4');
  meadow.style.setProperty('--copy', isDay ? '#65778e' : '#8c92ac');
  meadow.style.setProperty('--muted', isDay ? '#7c8796' : '#8b93ac');
}
function updateTheme() {
  setInk(day);
  toggle.setAttribute('aria-label', day ? 'Switch to night' : 'Switch to daylight');
  status.textContent = `${day ? 'Daylight' : 'Night'} meadow. Click the landscape or press Space to change the light.`;
  meadow.dataset.theme = day ? 'day' : 'night';
}
async function changeLight(event) {
  if (busy) return;
  busy = true;
  await assetsReady;
  if (event?.clientX !== undefined && event.detail !== 0) setPointer(event);
  smooth = { ...pointer };
  meadow.style.setProperty('--x', `${pointer.x * 100}%`);
  meadow.style.setProperty('--y', `${pointer.y * 100}%`);
  const farthest = Math.hypot(Math.max(pointer.x, 1-pointer.x) * width, Math.max(pointer.y, 1-pointer.y) * height);
  reveal.style.opacity = '1';
  if (!reducedMotion.matches) {
    const start = performance.now();
    await new Promise(resolve => {
      function expand(time) {
        const t = Math.min((time - start) / 900, 1);
        const eased = 1 - Math.pow(1 - t, 2.6);
        meadow.style.setProperty('--radius', `${(farthest + height * .18) * eased}px`);
        if (t > .32) setInk(!day);
        if (t < 1) requestAnimationFrame(expand); else resolve();
      }
      requestAnimationFrame(expand);
    });
  }
  day = !day;
  setWorld(base, day);
  await Promise.all([...base.querySelectorAll('img')].map(image => image.decode()));
  reveal.style.opacity = '0';
  meadow.style.setProperty('--radius', '0px');
  setWorld(reveal, !day);
  updateTheme();
  busy = false;
}
meadow.addEventListener('pointermove', event => {
  if (event.pointerType === 'touch') return;
  setPointer(event);
  hovered = !event.target.closest('a,button,nav,.intro');
  const now = performance.now();
  if (hovered && pointer.y > .66 && now - lastSpawn > 35 && !reducedMotion.matches) {
    lastSpawn = now;
    for (let i = 0; i < 3; i++) {
      const phase = now * .013 + i * 2.4;
      trail.push({ x: pointer.x * width + Math.sin(phase) * 65, y: pointer.y * height + Math.cos(phase * 1.4) * 34, phase, born: now, size: 2 + (i + pointer.y) * 1.2 });
    }
    if (trail.length > 160) trail.splice(0, trail.length - 160);
  }
});
meadow.addEventListener('pointerleave', () => hovered = false);
meadow.addEventListener('click', event => {
  if (!event.target.closest('a,button,nav,.intro')) changeLight(event);
});
toggle.addEventListener('click', changeLight);
document.addEventListener('keydown', event => {
  if (event.code === 'Space' && !event.repeat && !document.querySelector('dialog').open && !event.target.closest('a,button,input,textarea')) {
    event.preventDefault(); changeLight();
  }
});

function drawFlower(particle, opacity, age) {
  const bloom = Math.min(age / 180, 1);
  const r = particle.size * bloom;
  const x = particle.x + Math.sin(age * .002 + particle.phase) * 2;
  const y = particle.y;
  ctx.globalAlpha = opacity * .8;
  ctx.strokeStyle = '#5c793d'; ctx.lineWidth = .8;
  ctx.beginPath(); ctx.moveTo(x, y + r * 3); ctx.lineTo(x, y); ctx.stroke();
  ctx.fillStyle = particle.phase % 3 > 1.5 ? '#bba2df' : '#edf0e9';
  for (let petal = 0; petal < 6; petal++) {
    const angle = petal * Math.PI / 3 + particle.phase;
    ctx.beginPath(); ctx.ellipse(x + Math.cos(angle) * r * .8, y + Math.sin(angle) * r * .45, r * .85, r * .38, angle, 0, Math.PI * 2); ctx.fill();
  }
  ctx.fillStyle = '#e5cb6b'; ctx.beginPath(); ctx.ellipse(x, y, r * .42, r * .25, 0, 0, Math.PI * 2); ctx.fill();
  ctx.globalAlpha = 1;
}
function animate(time) {
  const dt = Math.min((time - lastTime) / 16.67, 3) || 1;
  lastTime = time;
  smooth.x += (pointer.x - smooth.x) * .17 * dt;
  smooth.y += (pointer.y - smooth.y) * .17 * dt;
  ctx.clearRect(0, 0, width, height);
  if (!reducedMotion.matches) {
    for (let i = trail.length - 1; i >= 0; i--) {
      const p = trail[i];
      const age = Math.max(0, time - p.born);
      if (age > 2600) { trail.splice(i, 1); continue; }
      const alpha = Math.min(age / 100, 1) * Math.pow(1 - age / 2600, .65);
      drawFlower(p, alpha, age);
      if (!day) {
        ctx.shadowColor = '#e5eb97'; ctx.shadowBlur = 14;
        ctx.fillStyle = `rgba(237,240,159,${alpha * .65})`;
        ctx.beginPath(); ctx.arc(p.x + Math.sin(age * .003 + p.phase) * 16, p.y - age * .025, 1.5, 0, Math.PI * 2); ctx.fill();
        ctx.shadowBlur = 0;
      }
    }
    if (!day && hovered && pointer.y > .63) {
      const x = smooth.x * width, y = smooth.y * height;
      const glow = ctx.createRadialGradient(x, y, 1, x, y, Math.max(45, width * .045));
      glow.addColorStop(0, '#fffac5d0'); glow.addColorStop(.12, '#fff7b660'); glow.addColorStop(.45, '#e2ea6630'); glow.addColorStop(1, '#e2ea6600');
      ctx.globalCompositeOperation = 'screen';
      ctx.fillStyle = glow; ctx.fillRect(0, 0, width, height);
      ctx.globalCompositeOperation = 'source-over';
    }
  }
  frameId = requestAnimationFrame(animate);
}
document.addEventListener('visibilitychange', () => {
  cancelAnimationFrame(frameId);
  if (!document.hidden) { lastTime = 0; frameId = requestAnimationFrame(animate); }
});
const dialog = document.querySelector('dialog');
const copy = {
  'features': 'Save what is worth reading. Come back when you have the space for it.',
  'quiet-hours': 'Let the day slow down. Move through the meadow, then click to change the light. You can also use the light button or press Space.',
  'about': 'A quiet place for a loud internet. A little room to pause, read, and return.',
  'field-guide': 'Move across the grass to wake the flowers and fireflies. Click anywhere in the landscape to change the light. On a touch screen, just tap.',
};
document.querySelectorAll('a[href^="#"]').forEach(link => {
  link.addEventListener('click', event => {
    event.preventDefault(); hovered = false;
    document.querySelector('#dialog-title').textContent = link.textContent.trim() || link.getAttribute('aria-label');
    document.querySelector('#dialog-copy').textContent = copy[link.hash.slice(1)] || 'A little more room for what matters. For now, take a moment in the meadow.';
    dialog.showModal();
  });
});
document.querySelectorAll('.close,.back').forEach(button => button.addEventListener('click', () => dialog.close()));
dialog.addEventListener('click', event => { if (event.target === dialog) {
  const b = dialog.getBoundingClientRect();
  if (event.clientX < b.left || event.clientX > b.right || event.clientY < b.top || event.clientY > b.bottom) dialog.close();
} });

new ResizeObserver(resize).observe(meadow);
resize(); updateTheme();
frameId = requestAnimationFrame(animate);
