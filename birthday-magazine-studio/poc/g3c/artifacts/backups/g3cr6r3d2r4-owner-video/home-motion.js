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
    const panelStates = backgrounds.map(image => progress(image.parentElement));
    const closingState = closing ? clamp((scrollY - layoutTop(closing)) / Math.max(1, closing.offsetHeight - innerHeight), 0, 1) : 0;
    const small = mobile.matches;
    cards.forEach((card, i) => {
      const p = cardStates[i], distance = Math.abs(p - .5) * 2;
      card.style.setProperty('--card-tilt', `${(.5 - p) * (small ? 8 : 48)}deg`);
      card.style.setProperty('--card-scale', `${1 - distance * (small ? .045 : .22)}`);
      card.style.setProperty('--card-y', `${(.5 - p) * (small ? 28 : 160)}px`);
      card.style.setProperty('--card-depth', `${-distance * (small ? 0 : 140)}px`);
    });
    splits.forEach((split, i) => {
      const p = splitStates[i], distance = Math.abs(p - .5) * 2;
      split.style.setProperty('--split-scale', `${1 + distance * (small ? .045 : .2)}`);
      split.style.setProperty('--split-y', `${(.5 - p) * (small ? 28 : 100)}px`);
      split.style.setProperty('--copy-y', `${Math.max(0, .5 - p) * (small ? 24 : 72)}px`);
      split.style.setProperty('--copy-opacity', `${1 - Math.max(0, .5 - p) * .45}`);
    });
    backgrounds.forEach((image, i) => image.style.setProperty('--photo-y', small ? '0px' : `${(panelStates[i] - .5) * 220}px`));
    if (closing) {
      closing.style.setProperty('--closing-reveal', `${small ? 100 : 10 + closingState * 90}%`);
      closing.style.setProperty('--closing-left', small ? '0px' : `${(closingState - .5) * -220}px`);
      closing.style.setProperty('--closing-right', small ? '0px' : `${(closingState - .5) * 200}px`);
      closing.style.setProperty('--closing-text-y', small ? '0px' : `${(1 - closingState) * 32}px`);
    }
  }
  const queue = () => {if (!scheduled) {scheduled = true; requestAnimationFrame(render);}};
  function applyPreference() {
    home.classList.toggle('bms-motion-on', !reduced.matches);
    syncClosing();
    if (reduced.matches) {
      for (const node of [...cards, ...splits, ...backgrounds, closing].filter(Boolean)) {
        for (const name of [...node.style]) if (/^--(card-|split-|copy-|photo-|closing-)/.test(name)) node.style.removeProperty(name);
      }
    } else queue();
  }
  // The focus loop sleeps offscreen/when the tab is hidden; CTA never moves.
  let heroVisible = true;
  const syncHero = () => hero?.classList.toggle('bms-focus-awake', heroVisible && !document.hidden && !reduced.matches);
  if (hero && 'IntersectionObserver' in window) {
    new IntersectionObserver(entries => {heroVisible = entries[0].isIntersecting; syncHero();}, {threshold:0}).observe(hero);
  }
  document.addEventListener('visibilitychange', syncHero);
  window.addEventListener('scroll', queue, {passive:true});
  window.addEventListener('resize', queue, {passive:true});
  reduced.addEventListener('change', () => {applyPreference(); syncHero();});
  mobile.addEventListener('change', applyPreference);
  applyPreference();
  syncHero();
})();
