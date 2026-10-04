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
