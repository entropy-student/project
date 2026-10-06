/* Homepage enhancement only. No network requests, cart/provider hooks or scroll interception. */
(function () {
    'use strict';
    const root = document.querySelector('body.home.page-id-939.mc-homira-home #post-939 .mc-home');
    if (!root || !window.matchMedia) return;
    const motion = window.matchMedia('(prefers-reduced-motion: no-preference)');
    const desktop = window.matchMedia('(min-width: 1100px) and (min-height: 650px)');
    const hero = root.querySelector('.mc-hero');
    const arrivals = root.querySelectorAll('.mc-section-heading, .mc-brand-copy, .mc-close-copy');
    const stage = root.querySelector('.mc-process-stage');
    const stack = stage && stage.querySelector('.mc-process-stack');
    const cards = stack ? Array.from(stack.querySelectorAll('.mc-step')) : [];
    let observer;
    let active = false;
    let frame = 0;

    function updateProcess() {
        frame = 0;
        if (!active) return;
        // Read natural grid sizes before writing any transforms; transformed rects drift.
        const bounds = stage.getBoundingClientRect();
        const stackWidth = stack.clientWidth;
        const widths = cards.map(function (card) { return card.offsetWidth; });
        const distance = Math.max(1, bounds.height - 100 - 430);
        const progress = Math.min(1, Math.max(0, (100 - bounds.top) / distance / 0.8));
        cards.forEach(function (card, index) {
            const targetCenter = widths[index] / 2 + index * (stackWidth - widths[index]) / 3;
            const x = (stackWidth / 2 - targetCenter) * (1 - progress);
            const y = (3 - index) * 18 * (1 - progress);
            card.style.transform = 'translateX(' + x + 'px) translateY(' + y + 'px)';
            card.style.zIndex = String(4 - index);
        });
    }

    function scheduleProcess() {
        if (active && !frame) frame = window.requestAnimationFrame(updateProcess);
    }

    function syncProcess() {
        active = motion.matches && desktop.matches && cards.length === 4;
        if (stage) stage.classList.toggle('mc-process-motion', active);
        if (active) {
            scheduleProcess();
        } else {
            window.cancelAnimationFrame(frame);
            frame = 0;
            cards.forEach(function (card) {
                card.style.removeProperty('transform');
                card.style.removeProperty('z-index');
            });
        }
    }

    function syncMotion() {
        if (observer) observer.disconnect();
        root.classList.toggle('mc-motion', motion.matches);
        syncProcess();
        if (!motion.matches) return;
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
    window.requestAnimationFrame(function () {
        if (hero) hero.classList.add('mc-hero-ready');
    });
    window.addEventListener('scroll', scheduleProcess, { passive: true });
    window.addEventListener('resize', scheduleProcess, { passive: true });
    [motion, desktop].forEach(function (query, index) {
        const listener = index === 0 ? syncMotion : syncProcess;
        if (query.addEventListener) query.addEventListener('change', listener);
        else query.addListener(listener);
    });
}());
