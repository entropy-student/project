'use strict';

// Synthetic DOM/VM regression checks, not actual-browser or CSS/layout validation.
// Run: node motion-regression.test.cjs
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const vm = require('node:vm');

const sourcePath = path.resolve(__dirname,
    '../../frontend/home-skin/home.js');
const source = fs.readFileSync(sourcePath, 'utf8');
const rootSelector = 'body.home.page-id-939.mc-homira-home #post-939 .mc-home';

function harness({ reduced = false, width = 1440, height = 900, noObserver = false,
    noStage = false, legacyMedia = false } = {}) {
    const trace = [];
    function element() {
        const classes = new Set();
        const additions = [];
        return {
            additions,
            textContent: 'Readable homepage content',
            classList: {
                add(value) { additions.push(value); classes.add(value); },
                contains(value) { return classes.has(value); },
                toggle(value, on) { if (on) classes.add(value); else classes.delete(value); }
            },
            style: { removeProperty(value) {
                delete this[value === 'z-index' ? 'zIndex' : value];
            } }
        };
    }
    const root = element(), hero = element(), stage = element(), stack = element();
    const cards = Array.from({ length: 4 }, element);
    const arrivals = Array.from({ length: 3 }, element);
    const geometry = { top: 100, height: 1100, stackWidth: 1000, cardWidth: 220 };
    const frames = new Map(), listeners = new Map(), observers = [];
    let frameId = 0;
    const queries = [
        { matches: !reduced },
        { matches: width >= 1100 && height >= 650 }
    ];
    queries.forEach(query => {
        if (legacyMedia) query.addListener = callback => { query.change = callback; };
        else query.addEventListener = (type, callback) => {
            assert.equal(type, 'change'); query.change = callback;
        };
    });
    root.querySelector = selector => {
        assert(['.mc-hero', '.mc-process-stage'].includes(selector));
        return selector === '.mc-hero' ? hero : noStage ? null : stage;
    };
    root.querySelectorAll = selector => {
        assert.equal(selector, '.mc-section-heading, .mc-brand-copy, .mc-close-copy');
        return arrivals;
    };
    stage.querySelector = selector => { assert.equal(selector, '.mc-process-stack'); return stack; };
    stack.querySelectorAll = selector => { assert.equal(selector, '.mc-step'); return cards; };
    stage.getBoundingClientRect = () => {
        trace.push('stage'); return { top: geometry.top, height: geometry.height };
    };
    Object.defineProperty(stack, 'clientWidth', { get() {
        trace.push('stack'); return geometry.stackWidth;
    } });
    cards.forEach((card, index) => {
        Object.defineProperty(card, 'offsetWidth', { get() {
            trace.push('width' + index); return geometry.cardWidth;
        } });
        card.getBoundingClientRect = () => { throw Error('Must not read transformed card rectangles'); };
        let transform;
        Object.defineProperty(card.style, 'transform', {
            configurable: true,
            get() { return transform; },
            set(value) { trace.push('transform' + index); transform = value; }
        });
    });
    const window = {
        matchMedia(query) {
            if (query === '(prefers-reduced-motion: no-preference)') return queries[0];
            assert.equal(query, '(min-width: 1100px) and (min-height: 650px)');
            return queries[1];
        },
        requestAnimationFrame(callback) { frames.set(++frameId, callback); return frameId; },
        cancelAnimationFrame(id) { frames.delete(id); },
        addEventListener(type, callback, options) {
            assert(['scroll', 'resize'].includes(type));
            assert.equal(options.passive, true);
            listeners.set(type, callback);
        }
    };
    if (!noObserver) window.IntersectionObserver = class {
        constructor(callback, options) {
            assert.equal(options.threshold, 0.12);
            this.callback = callback; this.nodes = new Set(); observers.push(this);
        }
        observe(node) { this.nodes.add(node); }
        unobserve(node) { this.nodes.delete(node); }
        disconnect() { this.nodes.clear(); }
    };
    const context = vm.createContext({ window, document: { querySelector(selector) {
        assert.equal(selector, rootSelector); return root;
    } } });
    vm.runInContext(source, context, { filename: sourcePath, timeout: 1000 });
    assert.deepEqual(Object.keys(context).sort(), ['document', 'window']);
    return {
        root, hero, stage, cards, arrivals, geometry, frames, trace, observers,
        emit(type) { listeners.get(type)(); },
        flush() {
            const pending = [...frames.values()]; frames.clear();
            pending.forEach(callback => callback());
        },
        setReduced(value) { queries[0].matches = !value; queries[0].change(); },
        setViewport(w, h) {
            const matches = w >= 1100 && h >= 650;
            if (matches !== queries[1].matches) {
                queries[1].matches = matches; queries[1].change();
            }
            listeners.get('resize')();
        }
    };
}

function assertStatic(h) {
    assert.equal(h.stage.classList.contains('mc-process-motion'), false);
    for (const card of h.cards) {
        assert.equal(card.style.transform, undefined);
        assert.equal(card.style.zIndex, undefined);
        assert.equal(card.textContent, 'Readable homepage content');
    }
    assert.equal(h.frames.size, 0);
}

function assertTransforms(h, xs, ys) {
    assert.deepEqual(h.cards.map(card => card.style.transform),
        xs.map((x, index) => `translateX(${x}px) translateY(${ys[index]}px)`));
}

test('synthetic: absent homepage root is a strict no-op', () => {
    let rootQueries = 0;
    const context = vm.createContext({
        document: { querySelector(selector) {
            assert.equal(selector, rootSelector); rootQueries++; return null;
        } },
        window: new Proxy({}, { get() { throw Error('Window accessed without homepage root'); } })
    });
    vm.runInContext(source, context, { filename: sourcePath, timeout: 1000 });
    assert.equal(rootQueries, 1);
    assert.deepEqual(Object.keys(context).sort(), ['document', 'window']);
});

test('synthetic: initial reduced motion leaves all four cards static', () => {
    const h = harness({ reduced: true }); h.flush();
    assert.equal(h.root.classList.contains('mc-motion'), false);
    assert.equal(h.observers.length, 0);
    h.emit('scroll'); h.emit('resize');
    assertStatic(h);
    assert.deepEqual(h.trace, []);
    assert(h.hero.classList.contains('mc-hero-ready'));
});

test('synthetic: unavailable IntersectionObserver marks content ready/readable', () => {
    const h = harness({ noObserver: true }); h.flush();
    for (const node of h.arrivals) {
        assert(node.classList.contains('mc-arrived'));
        assert.equal(node.textContent, 'Readable homepage content');
        assert.equal(node.style.opacity, undefined);
        assert.equal(node.style.visibility, undefined);
        assert.equal(node.style.display, undefined);
    }
    assert(h.hero.classList.contains('mc-hero-ready'));
    assert(h.stage.classList.contains('mc-process-motion'));
    // Actual visibility also depends on CSS and is outside this synthetic suite.
});

test('synthetic: desktop start, midpoint and 80%-completion transforms', () => {
    const h = harness(); h.flush();
    assert(h.root.classList.contains('mc-motion'));
    assert(h.stage.classList.contains('mc-process-motion'));
    assertTransforms(h, [390, 130, -130, -390], [54, 36, 18, 0]);
    assert.deepEqual(h.cards.map(card => card.style.zIndex), ['4', '3', '2', '1']);
    h.geometry.top = -128; h.emit('scroll'); h.flush();
    assertTransforms(h, [195, 65, -65, -195], [27, 18, 9, 0]);
    h.geometry.top = -356; h.emit('scroll'); h.flush();
    assertTransforms(h, [0, 0, 0, 0], [0, 0, 0, 0]);
    h.geometry.top = -800; h.emit('scroll'); h.flush();
    assertTransforms(h, [0, 0, 0, 0], [0, 0, 0, 0]);
});

test('synthetic: reverse native scroll returns cards to the initial stack', () => {
    const h = harness(); h.flush();
    h.geometry.top = -356; h.emit('scroll'); h.flush();
    h.geometry.top = -128; h.emit('scroll'); h.flush();
    assertTransforms(h, [195, 65, -65, -195], [27, 18, 9, 0]);
    h.geometry.top = 200; h.emit('scroll'); h.flush();
    assertTransforms(h, [390, 130, -130, -390], [54, 36, 18, 0]);
});

test('synthetic: breakpoint changes remove styles/class and cancel pending work', () => {
    const h = harness(); h.flush();
    for (const [width, height] of [[1099, 900], [1440, 649]]) {
        h.emit('scroll'); assert.equal(h.frames.size, 1);
        h.setViewport(width, height); assertStatic(h);
        h.emit('scroll'); h.emit('resize'); assertStatic(h);
        h.setViewport(1100, 650); h.flush();
        assert(h.stage.classList.contains('mc-process-motion'));
        assertTransforms(h, [390, 130, -130, -390], [54, 36, 18, 0]);
    }
    assert.deepEqual(h.hero.additions, ['mc-hero-ready']);
});

test('synthetic: changing reduced motion cleans up and preserves one-time hero readiness', () => {
    const h = harness(); h.flush(); h.emit('scroll');
    h.setReduced(true); assertStatic(h);
    assert.equal(h.root.classList.contains('mc-motion'), false);
    assert.equal(h.observers[0].nodes.size, 0);
    h.setReduced(false); h.flush();
    assert(h.root.classList.contains('mc-motion'));
    assertTransforms(h, [390, 130, -130, -390], [54, 36, 18, 0]);
    assert.deepEqual(h.hero.additions, ['mc-hero-ready']);
});

test('synthetic: resize uses new natural sizes, coalesces events and reads before writes', () => {
    const h = harness(); h.flush(); h.trace.length = 0;
    Object.assign(h.geometry, { stackWidth: 1240, cardWidth: 280, height: 1260, top: -192 });
    h.emit('resize'); h.emit('scroll'); h.emit('resize');
    assert.equal(h.frames.size, 1); h.flush();
    assertTransforms(h, [240, 80, -80, -240], [27, 18, 9, 0]);
    assert.deepEqual(h.trace, ['stage', 'stack', 'width0', 'width1', 'width2', 'width3',
        'transform0', 'transform1', 'transform2', 'transform3']);
    assert.equal(h.frames.size, 0);
    assert.deepEqual(h.hero.additions, ['mc-hero-ready']);
});

test('synthetic: observer arrivals occur once and exclude gallery cards', () => {
    const h = harness(); h.flush(); const observer = h.observers[0];
    assert.equal(observer.nodes.size, 3);
    observer.callback([{ isIntersecting: false, target: h.arrivals[0] }]);
    assert.equal(h.arrivals[0].classList.contains('mc-arrived'), false);
    observer.callback([{ isIntersecting: true, target: h.arrivals[0] }]);
    assert(h.arrivals[0].classList.contains('mc-arrived'));
    assert.equal(observer.nodes.has(h.arrivals[0]), false);
    h.setReduced(true); h.setReduced(false); h.flush();
    assert.equal(h.observers[1].nodes.has(h.arrivals[0]), false);
});

test('synthetic: missing stage and legacy media-query listeners are supported', () => {
    const missing = harness({ noStage: true }); missing.flush();
    assertStatic(missing); assert.deepEqual(missing.trace, []);
    assert(missing.hero.classList.contains('mc-hero-ready'));
    assert.equal(missing.observers[0].nodes.size, 3);
    const legacy = harness({ legacyMedia: true }); legacy.flush();
    legacy.setReduced(true); assertStatic(legacy);
});
