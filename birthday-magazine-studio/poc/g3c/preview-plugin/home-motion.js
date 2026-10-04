/* Original D2 display-only controller. No Preview, forms, commerce or auth hooks. */
(() => {
  const home = document.querySelector('body.home .entry-content');
  if (!home) return;
  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');
  const mobile = window.matchMedia('(max-width: 700px)');
  const cards = [...home.querySelectorAll('.bms-focus-card')];
  const backgrounds = [...home.querySelectorAll('.bms-panel-background img')];
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
  const revealTargets = home.querySelectorAll('.bms-focus-copy > .bms-heading, .bms-focus-visual, .bms-dark-panel > .bms-heading, .bms-samples > .bms-heading');
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
  let scheduled = false;
  function render() {
    scheduled = false;
    if (reduced.matches) return;
    const height = window.innerHeight;
    const amount = mobile.matches ? 4 : 16;
    for (const card of cards) {
      const r = card.getBoundingClientRect();
      const progress = clamp((height - r.top) / (height + r.height), 0, 1);
      const distance = Math.abs(progress - .5) * 2;
      card.style.setProperty('--card-tilt', `${(progress - .5) * amount}deg`);
      card.style.setProperty('--card-scale', `${1 - distance * (mobile.matches ? .025 : .1)}`);
    }
    for (const image of backgrounds) {
      const r = image.parentElement.getBoundingClientRect();
      const progress = clamp((height - r.top) / (height + r.height), 0, 1);
      image.style.setProperty('--photo-y', mobile.matches ? '0px' : `${(progress - .5) * 42}px`);
    }
    if (closing) {
      const r = closing.getBoundingClientRect();
      const progress = clamp((height - r.top) / (height + r.height), 0, 1);
      closing.style.setProperty('--closing-reveal', `${clamp(progress * 150, 0, 100)}%`);
      closing.style.setProperty('--closing-left', mobile.matches ? '0px' : `${(progress - .5) * -120}px`);
      closing.style.setProperty('--closing-right', mobile.matches ? '0px' : `${(progress - .5) * 100}px`);
    }
  }
  const queue = () => {if (!scheduled) {scheduled = true; requestAnimationFrame(render);}};
  function applyPreference() {
    home.classList.toggle('bms-motion-on', !reduced.matches);
    if (reduced.matches) {
      for (const node of [...cards, ...backgrounds, closing].filter(Boolean)) node.removeAttribute('style');
    } else queue();
  }
  window.addEventListener('scroll', queue, {passive:true});
  window.addEventListener('resize', queue, {passive:true});
  reduced.addEventListener('change', applyPreference);
  applyPreference();
})();
