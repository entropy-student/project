(() => {
  const root = document.querySelector('[data-bms-g3cr7]');
  if (!root) return;
  const steps = [...root.querySelectorAll('[data-step]')];
  const progressItems = [...root.querySelectorAll('.bms-g3cr7-progress li')];
  const next = root.querySelector('[data-next]');
  const back = root.querySelector('[data-back]');
  const count = root.querySelector('[data-step-count]');
  const progress = root.querySelector('[data-progress-bar]');
  const fileInput = root.querySelector('#bms-g3cr7-files');
  const grid = root.querySelector('[data-photo-grid]');
  const photoError = root.querySelector('[data-photo-error]');
  const photoCount = root.querySelector('[data-photo-count]');
  const mustCount = root.querySelector('[data-must-count]');
  const checkout = root.querySelector('[data-checkout]');
  const checkoutError = root.querySelector('[data-checkout-error]');
  const photos = [];
  let activeStep = 0;

  function showError(target, message) {
    target.textContent = message;
    target.hidden = !message;
  }

  function selectedMustUse() {
    return photos.filter(photo => photo.mustUse).length;
  }

  function renderPhotos() {
    grid.replaceChildren();
    photos.forEach((photo, index) => {
      const figure = document.createElement('figure');
      figure.className = 'bms-g3cr7-photo';
      const image = document.createElement('img');
      image.src = photo.url;
      image.alt = `Synthetic local test image ${String(index + 1).padStart(2, '0')}`;
      const caption = document.createElement('figcaption');
      const label = document.createElement('label');
      const check = document.createElement('input');
      check.type = 'checkbox';
      check.checked = photo.mustUse;
      check.setAttribute('aria-label', `Mark image ${index + 1} must-use`);
      check.addEventListener('change', () => {
        if (check.checked && selectedMustUse() >= 3) {
          check.checked = false;
          showError(photoError, 'Choose no more than three must-use photos.');
          return;
        }
        photo.mustUse = check.checked;
        showError(photoError, '');
        renderPhotos();
      });
      label.append(check, document.createTextNode('Must use'));
      const remove = document.createElement('button');
      remove.type = 'button';
      remove.className = 'bms-g3cr7-remove';
      remove.textContent = 'Remove';
      remove.setAttribute('aria-label', `Remove image ${index + 1}`);
      remove.addEventListener('click', () => {
        URL.revokeObjectURL(photo.url);
        photos.splice(index, 1);
        renderPhotos();
      });
      caption.append(label, remove);
      figure.append(image, caption);
      grid.append(figure);
    });
    photoCount.textContent = String(photos.length);
    mustCount.textContent = String(selectedMustUse());
    const limitReached = selectedMustUse() >= 3;
    grid.querySelectorAll('input[type="checkbox"]:not(:checked)').forEach(check => { check.disabled = limitReached; });
  }

  function fileIsSupported(file) {
    const extension = file.name.split('.').pop().toLowerCase();
    return ['image/jpeg', 'image/png', 'image/webp'].includes(file.type) || ['jpg', 'jpeg', 'png', 'webp'].includes(extension);
  }

  fileInput.addEventListener('change', () => {
    const incoming = [...fileInput.files];
    fileInput.value = '';
    if (!incoming.length) return;
    const supported = incoming.filter(fileIsSupported);
    const rejected = incoming.length - supported.length;
    if (photos.length + supported.length > 25) {
      showError(photoError, 'Choose no more than 25 images in total. No new images were added.');
      return;
    }
    supported.forEach(file => photos.push({ file, url: URL.createObjectURL(file), mustUse: false }));
    renderPhotos();
    showError(photoError, rejected ? 'Unsupported files were skipped. Choose JPG, PNG, or WebP.' : '');
  });

  function validateStep(index) {
    const panel = steps[index];
    if (index === 0) {
      const fields = [...panel.querySelectorAll('[required]')];
      const invalid = fields.find(field => !field.value.trim?.() && field.type !== 'number' || !field.checkValidity());
      if (invalid) { invalid.reportValidity(); return false; }
    }
    if (index === 1) {
      if (photos.length < 12 || photos.length > 25) {
        showError(photoError, 'Choose 12–25 supported images before continuing.');
        fileInput.focus();
        return false;
      }
      if (selectedMustUse() > 3) { showError(photoError, 'Choose no more than three must-use photos.'); return false; }
      showError(photoError, '');
    }
    if (index === 2 || index === 3) {
      const invalid = [...panel.querySelectorAll('textarea[required]')].find(field => !field.value.trim());
      if (invalid) { invalid.focus(); invalid.reportValidity(); return false; }
    }
    return true;
  }

  function refreshReview() {
    const get = name => root.querySelector(`[name="${name}"]`).value.trim();
    const rows = [
      ['Birthday person', get('recipient_name')], ['Age', get('age')],
      ['Relationship', get('relationship')], ['Tone', get('tone')],
      ['Photos', `${photos.length} local images · ${selectedMustUse()} must-use`]
    ];
    if (get('birthday')) rows.splice(2, 0, ['Birthday', get('birthday')]);
    if (get('pronouns')) rows.push(['Pronouns', get('pronouns')]);
    ['favorite_song', 'favorite_food', 'favorite_place', 'current_obsession', 'must_include'].forEach(name => {
      if (get(name)) rows.push([name.replaceAll('_', ' '), get(name)]);
    });
    const summary = root.querySelector('[data-review-summary]');
    summary.replaceChildren();
    rows.forEach(([label, value]) => {
      const row = document.createElement('div');
      const term = document.createElement('dt');
      const detail = document.createElement('dd');
      term.textContent = label;
      detail.textContent = value;
      row.append(term, detail);
      summary.append(row);
    });
    const answers = root.querySelector('[data-review-answers]');
    answers.replaceChildren();
    const prompts = [
      'Unmistakably them', 'A memory to return to', 'What you admire',
      'The little things', 'What they are into now', 'What to hear this birthday'
    ];
    prompts.forEach((prompt, index) => {
      const block = document.createElement('div');
      block.className = 'bms-g3cr7-review-answer';
      const title = document.createElement('strong');
      const answer = document.createElement('p');
      title.textContent = `${index + 1}. ${prompt}`;
      answer.textContent = get(`q${index + 1}`);
      block.append(title, answer);
      answers.append(block);
    });
  }

  function setStep(index) {
    activeStep = Math.max(0, Math.min(steps.length - 1, index));
    steps.forEach((step, i) => { step.hidden = i !== activeStep; });
    progressItems.forEach((item, i) => {
      item.classList.toggle('is-complete', i < activeStep);
      if (i === activeStep) item.setAttribute('aria-current', 'step');
      else item.removeAttribute('aria-current');
    });
    progress.style.width = `${((activeStep + 1) / steps.length) * 100}%`;
    count.textContent = `Step ${activeStep + 1} of ${steps.length}`;
    back.disabled = activeStep === 0;
    next.hidden = activeStep === steps.length - 1;
    root.querySelector('.bms-g3cr7-nav').hidden = activeStep === steps.length - 1;
    if (activeStep === steps.length - 1) refreshReview();
    const heading = steps[activeStep].querySelector('h2');
    if (heading) { heading.tabIndex = -1; heading.focus({ preventScroll: true }); }
  }

  next.addEventListener('click', () => {
    if (validateStep(activeStep)) setStep(activeStep + 1);
  });
  back.addEventListener('click', () => setStep(activeStep - 1));

  checkout.addEventListener('click', async () => {
    for (let i = 0; i < steps.length - 1; i++) {
      if (!validateStep(i)) { setStep(i); return; }
    }
    checkout.disabled = true;
    checkout.textContent = 'Opening WooCommerce checkout…';
    showError(checkoutError, '');
    try {
      const body = new URLSearchParams({ product_id: root.dataset.productId, quantity: '1' });
      const response = await fetch(root.dataset.addUrl, {
        method: 'POST', credentials: 'same-origin',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
        body
      });
      const result = await response.json();
      if (!response.ok || result.error) throw new Error('WooCommerce could not add the product to the cart.');
      window.location.assign(root.dataset.checkoutUrl);
    } catch {
      checkout.disabled = false;
      checkout.textContent = 'Continue to WooCommerce checkout ↗';
      showError(checkoutError, 'The native checkout handoff did not complete. Please use the product page to continue.');
    }
  });

  window.addEventListener('pagehide', () => photos.forEach(photo => URL.revokeObjectURL(photo.url)));
})();
