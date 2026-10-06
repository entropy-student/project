/* Homepage enhancement only. No network requests, cart/provider hooks or scroll interception. */
(function () {
    'use strict';
    const root = document.querySelector('body.home.page-id-939.mc-homira-home #post-939 .mc-home');
    if (!root || !window.matchMedia) return;
    const motion = window.matchMedia('(prefers-reduced-motion: no-preference)');
    const desktop = window.matchMedia('(min-width: 1100px) and (min-height: 650px)');
    const hero = root.querySelector('.mc-hero');
    const arrivals = root.querySelectorAll('.mc-section-heading, .mc-brand-copy, .mc-close-copy, .mc-faq h2, .mc-faq h3');
    const stage = root.querySelector('.mc-process-stage');
    const stack = stage && stage.querySelector('.mc-process-stack');
    const cards = stack ? Array.from(stack.querySelectorAll('.mc-step')) : [];
    let observer;
    let active = false;
    let frame = 0;
    let curtains;
    let heroWait = 0;
    let heroCleanup = 0;
    let heroFrame = 0;
    const heroImage = hero && hero.querySelector('img');

    function clamp(value) {
        return Math.min(1, Math.max(0, value));
    }

    function stopHeroWait() {
        window.clearTimeout(heroWait);
        heroWait = 0;
        if (heroImage) {
            heroImage.removeEventListener('load', revealHero);
            heroImage.removeEventListener('error', revealHero);
        }
    }

    function removeCurtains() {
        if (curtains) curtains.remove();
        curtains = null;
    }

    function clearHero() {
        stopHeroWait();
        window.clearTimeout(heroCleanup);
        window.cancelAnimationFrame(heroFrame);
        heroCleanup = 0;
        heroFrame = 0;
        removeCurtains();
        if (hero) hero.classList.remove('mc-hero-ready');
    }

    function revealHero() {
        stopHeroWait();
        if (!curtains || heroFrame) return;
        heroFrame = window.requestAnimationFrame(function () {
            heroFrame = 0;
            if (!motion.matches) {
                clearHero();
                return;
            }
            hero.classList.add('mc-hero-ready');
            heroCleanup = window.setTimeout(removeCurtains, 1800);
        });
    }

    function initHero() {
        if (!hero || !motion.matches) return;
        curtains = document.createElement('div');
        curtains.className = 'mc-hero-curtains';
        curtains.setAttribute('aria-hidden', 'true');
        for (let index = 0; index < 5; index += 1) {
            const curtain = document.createElement('span');
            curtain.className = 'mc-hero-curtain';
            curtain.style.setProperty('--mc-i', String(index));
            curtains.appendChild(curtain);
        }
        hero.appendChild(curtains);
        if (!heroImage || heroImage.complete) {
            revealHero();
        } else {
            heroImage.addEventListener('load', revealHero);
            heroImage.addEventListener('error', revealHero);
            heroWait = window.setTimeout(revealHero, 600);
        }
    }

    function updateProcess() {
        frame = 0;
        if (!active) return;
        // Measure the canonical grid first; offsets are unaffected by transforms.
        const bounds = stage.getBoundingClientRect();
        const stackWidth = stack.clientWidth;
        const stackHeight = stack.offsetHeight;
        const sizes = cards.map(function (card) {
            return { width: card.offsetWidth, height: card.offsetHeight, x: card.offsetLeft, y: card.offsetTop };
        });
        const distance = Math.max(1, bounds.height - 100 - stackHeight);
        const progress = clamp((100 - bounds.top) / distance);
        const spread = clamp((progress - 0.65) / 0.35);
        cards.forEach(function (card, index) {
            const size = sizes[index];
            const enter = clamp(progress / 0.65 * 4 - index);
            const x = (stackWidth / 2 - size.x - size.width / 2) * (1 - spread);
            const y = (stackHeight / 2 - size.y - size.height / 2 + (size.height + 70) * (1 - enter)) * (1 - spread);
            card.style.transform = 'translateX(' + x + 'px) translateY(' + y + 'px)';
            card.style.opacity = String(enter);
            card.style.zIndex = String(index + 1);
        });
    }

    function scheduleProcess() {
        if (active && !frame) frame = window.requestAnimationFrame(updateProcess);
    }

    function syncProcess() {
        active = false;
        window.cancelAnimationFrame(frame);
        frame = 0;
        if (stage) stage.classList.remove('mc-process-motion');
        cards.forEach(function (card) {
            card.style.removeProperty('transform');
            card.style.removeProperty('opacity');
            card.style.removeProperty('z-index');
        });
        active = motion.matches && desktop.matches && !!stage && !!stack && cards.length === 4;
        if (!active) return;
        stage.classList.add('mc-process-motion');
        scheduleProcess();
    }

    function syncMotion() {
        if (observer) observer.disconnect();
        root.classList.toggle('mc-motion', motion.matches);
        syncProcess();
        if (!motion.matches) {
            clearHero();
            return;
        }
        if (!('IntersectionObserver' in window)) {
            arrivals.forEach(function (node) { node.classList.add('mc-arrived'); });
            return;
        }
        observer = new window.IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (!entry.isIntersecting) return;
                entry.target.classList.add('mc-arrived');
                observer.unobserve(entry.target);
            });
        }, { threshold: 0.12 });
        arrivals.forEach(function (node) {
            if (!node.classList.contains('mc-arrived')) observer.observe(node);
        });
    }

    syncMotion();
    initHero();
    window.addEventListener('scroll', scheduleProcess, { passive: true });
    window.addEventListener('resize', syncProcess, { passive: true });
    [motion, desktop].forEach(function (query, index) {
        const listener = index === 0 ? syncMotion : syncProcess;
        if (query.addEventListener) query.addEventListener('change', listener);
        else query.addListener(listener);
    });
}());
