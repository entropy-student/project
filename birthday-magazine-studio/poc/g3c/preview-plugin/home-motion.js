/* Original D2 display-only controller. No Preview, forms, commerce or auth hooks. */
(() => {
  const home = document.querySelector('body.home .entry-content');
  if (!home) return;
  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');
  const mobile = window.matchMedia('(max-width: 700px)');
  const cards = [...home.querySelectorAll('.bms-focus-card')];
  const backgrounds = [...home.querySelectorAll('.bms-panel-background img')];
  const splits = [...home.querySelectorAll('.bms-focus-split')];
  const hero = home.querySelector('.bms-hero');
  const closing = home.querySelector('.bms-closing');
  const clamp = (value, min, max) => Math.max(min, Math.min(max, value));
  const phase = (value, start, end) => clamp((value - start) / (end - start), 0, 1);
  const ease = value => value * value * (3 - 2 * value);
  // Hero-only photographic enhancement. Each sharp/blur pair shares the same
  // full-scene coordinates; the lens clips the scene, never drags a small image.
  const finePointer = window.matchMedia('(hover: hover) and (pointer: fine)');
  const heroAnimations = [];
  const lens = hero?.querySelector('.bms-focus-frame');
  let focusReady = false, focusFrame = 0, lensGeometry;
  const focusPoint = {x:0,y:0}, focusTarget = {x:0,y:0};
  let adaptHero = () => {};
  function paintFocus() {
    if (!lensGeometry) return;
    const {width,height,left,top,w,h,radius} = lensGeometry;
    hero.style.setProperty('--focus-x', `${focusPoint.x}px`);
    hero.style.setProperty('--focus-y', `${focusPoint.y}px`);
    hero.style.setProperty('--focus-clip', `inset(${top+focusPoint.y}px ${width-left-w-focusPoint.x}px ${height-top-h-focusPoint.y}px ${left+focusPoint.x}px round ${radius})`);
  }
  function measureFocus() {
    if (!focusReady) return;
    const width = hero.clientWidth, height = hero.querySelector('.bms-hero-focus-canvas').clientHeight;
    const w = lens.offsetWidth, h = lens.offsetHeight, top = lens.offsetTop;
    lensGeometry = {width,height,w,h,top,left:(width-w)/2,radius:getComputedStyle(lens).borderRadius,
      maxX:Math.max(0,(width-w)/2-24),
      minY:24-top,
      maxY:height-top-h-24};
    focusPoint.x=focusPoint.y=focusTarget.x=focusTarget.y=0;
    paintFocus();
  }
  function followFocus() {
    focusFrame=0;
    if (!focusReady || reduced.matches || mobile.matches || !finePointer.matches || !heroVisible || document.hidden) return;
    focusPoint.x+=(focusTarget.x-focusPoint.x)*.15;
    focusPoint.y+=(focusTarget.y-focusPoint.y)*.15;
    const moving=Math.abs(focusTarget.x-focusPoint.x)+Math.abs(focusTarget.y-focusPoint.y)>.1;
    if (!moving) {focusPoint.x=focusTarget.x;focusPoint.y=focusTarget.y;}
    paintFocus();
    if (moving) focusFrame=requestAnimationFrame(followFocus);
  }
  function queueFocus() {if (!focusFrame) focusFrame=requestAnimationFrame(followFocus);}
  async function prepareHeroFocus() {
    const first=hero?.querySelector('.bms-focus-background img'),second=cards[2]?.querySelector('img');
    if (!first || !second || !lens || !Element.prototype.animate || !CSS.supports('clip-path','inset(0 round 24px)')) return;
    const pictures=[first,second].map(source=>{
      const image=new Image();image.src=source.src;image.alt='';image.loading='eager';image.decoding='async';return image;
    });
    try {await Promise.all(pictures.map(image=>image.decode()));} catch {return;}
    const stage=document.createElement('div'),canvas=document.createElement('div');
    stage.className='bms-hero-photo-stage';canvas.className='bms-hero-focus-canvas';
    stage.setAttribute('aria-hidden','true');canvas.setAttribute('aria-hidden','true');
    for (const container of [stage,canvas]) pictures.forEach((picture,i)=>{
      const image=picture.cloneNode();image.className=`bms-hero-photo bms-hero-photo-${i?'b':'a'}`;container.append(image);
    });
    hero.prepend(stage);hero.insertBefore(canvas,lens);
    const opacity=[{offset:0,opacity:1},{offset:.44,opacity:1},{offset:.47,opacity:0},{offset:.94,opacity:0},{offset:.97,opacity:1},{offset:1,opacity:1}];
    const zoom=[{offset:0,transform:'scale(1)'},{offset:.4,transform:'scale(1)'},{offset:.45,transform:'scale(1.08)'},{offset:.5,transform:'scale(1)'},{offset:.9,transform:'scale(1)'},{offset:.95,transform:'scale(1.08)'},{offset:1,transform:'scale(1)'}];
    const focus=[{offset:0,blur:0},{offset:.4,blur:0},{offset:.435,blur:1},{offset:.465,blur:1},{offset:.5,blur:0},{offset:.9,blur:0},{offset:.935,blur:1},{offset:.965,blur:1},{offset:1,blur:0}];
    const timing={duration:20000,iterations:Infinity,easing:'linear'};
    const add=(node,frames)=>{const animation=node.animate(frames.map(f=>({...f,easing:'ease-in-out'})),timing);heroAnimations.push(animation);return animation;};
    const scales=[];
    for (const container of [stage,canvas]) [...container.children].forEach((image,i)=>{
      add(image,opacity.map(f=>({...f,opacity:i?1-f.opacity:f.opacity})));
      scales.push(add(image,zoom));
    });
    const backgroundFocus=add(stage,[]),windowFocus=add(canvas,[]);
    adaptHero=()=>{
      const small=mobile.matches;
      scales.forEach(animation=>animation.effect.setKeyframes(zoom.map(f=>({...f,transform:small?f.transform.replace('1.08','1.035'):f.transform,easing:'ease-in-out'}))));
      backgroundFocus.effect.setKeyframes(focus.map(f=>({offset:f.offset,filter:`blur(${(small?8:10)+f.blur*(small?6:10)}px)`,easing:'ease-in-out'})));
      windowFocus.effect.setKeyframes(focus.map(f=>({offset:f.offset,filter:`blur(${f.blur*(small?6:12)}px)`,easing:'ease-in-out'})));
    };
    adaptHero();
    const origin=document.timeline.currentTime;
    heroAnimations.forEach(animation=>{animation.startTime=origin;});
    focusReady=true;
    hero.classList.toggle('bms-hero-focus-on',!reduced.matches);
    measureFocus();syncHero();
    // Listen across the Hero's visual field, including the separate Header.
    window.addEventListener('pointermove',event=>{
      if (event.pointerType==='touch'||mobile.matches||!finePointer.matches||reduced.matches||!lensGeometry) return;
      const rect=hero.getBoundingClientRect(),g=lensGeometry;
      const inside=event.clientX>=rect.left&&event.clientX<=rect.right&&event.clientY>=rect.top&&event.clientY<=rect.bottom;
      focusTarget.x=inside?clamp(event.clientX-rect.left-g.width/2,-g.maxX,g.maxX):0;
      focusTarget.y=inside?clamp(event.clientY-rect.top-g.top-g.h/2,g.minY,g.maxY):0;
      queueFocus();
    },{passive:true});
    window.addEventListener('pointerout',event=>{if (!event.relatedTarget) {focusTarget.x=focusTarget.y=0;queueFocus();}});
  }
  // Decorative label duplicate; the link keeps one accessible name and target.
  document.querySelectorAll('body.home #header .menu > li > a, body.home .bms-focus-link > a').forEach(link => {
    if (link.children.length || !link.textContent.trim()) return;
    const label = document.createElement('span');
    label.className = 'bms-roll';
    const text = document.createElement('span');
    text.textContent = link.textContent;
    const duplicate = text.cloneNode(true);
    duplicate.setAttribute('aria-hidden', 'true');
    label.append(text, duplicate);
    link.replaceChildren(label);
  });
  const revealTargets = home.querySelectorAll('.bms-dark-panel > .bms-heading, .bms-samples > .bms-heading');
  let observer;
  if ('IntersectionObserver' in window) {
    observer = new IntersectionObserver(entries => {
      for (const entry of entries) if (entry.isIntersecting) {
        entry.target.classList.add('bms-in-view');
        observer.unobserve(entry.target);
      }
    }, {threshold: .12});
    revealTargets.forEach(node => {node.classList.add('bms-reveal');observer.observe(node);});
  }
  // Presentation-only wrapper; no Gutenberg/DB writes. Removed for static modes.
  let sticky;
  function syncClosing() {
    if (!closing) return;
    if (!reduced.matches && !mobile.matches && !sticky) {
      sticky = document.createElement('div');
      sticky.className = 'bms-closing-sticky';
      sticky.append(...closing.childNodes);
      closing.append(sticky);
    } else if ((reduced.matches || mobile.matches) && sticky) {
      sticky.replaceWith(...sticky.childNodes);
      sticky = null;
    }
  }
  // offsetTop follows layout boxes, never the transformed card's projection.
  const layoutTop = node => {
    let y = 0;
    for (let n = node; n; n = n.offsetParent) y += n.offsetTop;
    return y;
  };
  const progress = node => clamp((innerHeight - (layoutTop(node) - scrollY)) / (innerHeight + node.offsetHeight), 0, 1);
  let scheduled = false;
  function render() {
    scheduled = false;
    if (reduced.matches) return;
    // Read geometry together, then write CSS variables; no per-frame idle loop.
    const cardStates = cards.map(progress);
    const splitStates = splits.map(progress);
    const panelStates = backgrounds.map(image => {
      const panel = image.closest('.bms-focus-photo-panel');
      return scrollY - (layoutTop(panel) - (innerHeight - panel.offsetHeight) / 2);
    });
    const closingState = closing ? clamp((scrollY - layoutTop(closing)) / Math.max(1, closing.offsetHeight - innerHeight), 0, 1) : 0;
    const small = mobile.matches;
    cards.forEach((card, i) => {
      const p = cardStates[i];
      // Distinct arrival, flat reading plateau, and departure; no scroll hijack.
      const entering = 1 - ease(phase(p, .08, .40));
      const leaving = ease(phase(p, .60, .92));
      const distance = entering + leaving;
      card.style.setProperty('--card-tilt', `${(entering - leaving) * (small ? 4 : 30)}deg`);
      card.style.setProperty('--card-scale', `${1 - distance * (small ? .045 : .24)}`);
      card.style.setProperty('--card-y', `${(entering - leaving) * (small ? 14 : 90)}px`);
      card.style.setProperty('--card-depth', `${-distance * (small ? 0 : 180)}px`);
    });
    splits.forEach((split, i) => {
      const p = splitStates[i], entering = 1 - ease(phase(p, .08, .45));
      const leaving = ease(phase(p, .72, 1));
      split.style.setProperty('--split-scale', `${1 + entering * (small ? .045 : .24) + leaving * .04}`);
      split.style.setProperty('--split-y', `${entering * (small ? 18 : 72) - leaving * (small ? 8 : 24)}px`);
      split.style.setProperty('--split-inset', `${entering * (small ? 3 : 12)}%`);
      split.style.setProperty('--copy-y', `${entering * (small ? 18 : 48)}px`);
      split.style.setProperty('--copy-opacity', `${1 - entering * .35}`);
    });
    // Compensate scroll one-for-one over a bounded 360px interval. The image
    // stays in viewport while its text panel moves; local overscan covers edges.
    backgrounds.forEach((image, i) => image.style.setProperty('--photo-y', small ? '0px' : `${clamp(panelStates[i], -180, 180)}px`));
    if (closing) {
      const left = ease(phase(closingState, .05, .28));
      const title = ease(phase(closingState, .22, .64));
      const right = ease(phase(closingState, .55, .82));
      closing.style.setProperty('--closing-reveal', `${small ? 100 : title * 100}%`);
      closing.style.setProperty('--closing-left-opacity', `${small ? .6 : left}`);
      closing.style.setProperty('--closing-right-opacity', `${small ? .6 : right}`);
      closing.style.setProperty('--closing-left', small ? '0px' : `${(1 - left) * 100 - closingState * 35}px`);
      closing.style.setProperty('--closing-right', small ? '0px' : `${(1 - right) * 100 - closingState * 25}px`);
      closing.style.setProperty('--closing-text-y', small ? '0px' : `${(1 - title) * 28}px`);
    }
  }
  const queue = () => {if (!scheduled) {scheduled = true; requestAnimationFrame(render);}};
  function applyPreference() {
    home.classList.toggle('bms-motion-on', !reduced.matches);
    if (focusReady) {hero.classList.toggle('bms-hero-focus-on',!reduced.matches);adaptHero();measureFocus();}
    syncClosing();
    if (reduced.matches) {
      for (const node of [...cards, ...splits, ...backgrounds, closing].filter(Boolean)) {
        for (const name of [...node.style]) if (/^--(card-|split-|copy-|photo-|closing-)/.test(name)) node.style.removeProperty(name);
      }
    } else queue();
  }
  // The focus loop sleeps offscreen/when the tab is hidden; CTA never moves.
  let heroVisible = true;
  const syncHero = () => {
    const awake=heroVisible&&!document.hidden&&!reduced.matches;
    hero?.classList.toggle('bms-focus-awake',awake);
    heroAnimations.forEach(animation=>awake?animation.play():animation.pause());
    if (!awake&&focusFrame) {cancelAnimationFrame(focusFrame);focusFrame=0;}
  };
  if (hero && 'IntersectionObserver' in window) {
    new IntersectionObserver(entries => {heroVisible = entries[0].isIntersecting; syncHero();}, {threshold:0}).observe(hero);
  }
  document.addEventListener('visibilitychange', syncHero);
  window.addEventListener('scroll', queue, {passive:true});
  window.addEventListener('resize', queue, {passive:true});
  window.addEventListener('resize', measureFocus, {passive:true});
  reduced.addEventListener('change', () => {applyPreference(); syncHero();});
  mobile.addEventListener('change', applyPreference);
  applyPreference();
  syncHero();
  prepareHeroFocus();
})();
