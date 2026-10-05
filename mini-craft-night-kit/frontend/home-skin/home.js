/* Homepage enhancement only. No network requests, cart/provider hooks or scroll interception. */
(function () {
    'use strict';
    const root = document.querySelector('body.home.page-id-939.mc-homira-home #post-939 .mc-home');
    if (!root || !window.matchMedia || !('IntersectionObserver' in window)) return;
    const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');
    let observer;
    function syncMotion() {
        if (observer) observer.disconnect();
        root.classList.toggle('mc-motion', !reduced.matches);
        if (reduced.matches) return;
        observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('mc-arrived');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.12 });
        root.querySelectorAll('.mc-section-heading, .mc-experience, .mc-brand-copy, .mc-close-copy').forEach(function (node) {
            observer.observe(node);
        });
    }
    syncMotion();
    if (reduced.addEventListener) reduced.addEventListener('change', syncMotion);
}());
