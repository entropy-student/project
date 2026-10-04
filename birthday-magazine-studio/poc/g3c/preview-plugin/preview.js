(function () {
  const root = document.querySelector('[data-bms-preview]');
  if (!root) return;
  const name = root.querySelector('[data-bms-input="name"]');
  const age = root.querySelector('[data-bms-input="age"]');
  const style = root.querySelector('[data-bms-input="style"]');
  const input = root.querySelector('[data-bms-file]');
  const status = root.querySelector('[data-bms-status]');
  const remove = root.querySelector('[data-bms-remove]');
  const uploadLabel = root.querySelector('[data-bms-upload-label]');
  const createLink = root.querySelector('[data-bms-create-link]');
  let photoUrl = '';
  function update() {
    const person = name.value.trim() || 'Someone special';
    const years = age.value ? Math.max(1, Math.min(120, Number(age.value))) : '';
    root.dataset.style = style.value;
    root.querySelector('[data-bms-name]').textContent = person;
    root.querySelector('[data-bms-age]').textContent = years ? `AGE ${years} · A VERY GOOD YEAR` : 'THE BIRTHDAY EDITION';
    root.querySelector('[data-bms-story]').textContent = `Here's to the moments that make you, you, ${person}. The familiar faces, the little joys, and the next chapter still to come.`;
    if (createLink) {
      const url = new URL(createLink.href, window.location.href);
      if (name.value.trim()) url.searchParams.set('recipient', name.value.trim());
      if (age.value) url.searchParams.set('age', age.value);
      url.searchParams.set('style', style.value);
      createLink.href = url.toString();
    }
  }
  function clearPhoto() {
    if (photoUrl) URL.revokeObjectURL(photoUrl);
    photoUrl = '';
    root.dataset.hasPhoto = 'false';
    input.value = '';
    root.querySelectorAll('[data-bms-image]').forEach(img => { img.removeAttribute('src'); img.hidden = true; });
    root.querySelectorAll('[data-bms-art], [data-bms-spread-art]').forEach(art => { art.hidden = false; });
    remove.hidden = true;
    uploadLabel.textContent = 'Choose their photo';
    status.textContent = 'Your preview works without a photo.';
  }
  name.addEventListener('input', update);
  age.addEventListener('input', update);
  style.addEventListener('change', update);
  remove.addEventListener('click', clearPhoto);
  input.addEventListener('change', async () => {
    const file = input.files?.[0];
    if (!file) return;
    clearPhoto();
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
      status.textContent = 'Choose a JPG, PNG or WebP image.';
      return;
    }
    const candidate = URL.createObjectURL(file);
    photoUrl = candidate;
    const probe = new Image();
    probe.src = candidate;
    try { await probe.decode(); } catch {
      if (photoUrl === candidate) { clearPhoto(); status.textContent = 'This image could not be opened. Choose another photo.'; }
      return;
    }
    if (photoUrl !== candidate) return;
    root.dataset.hasPhoto = 'true';
    root.querySelectorAll('[data-bms-image]').forEach(img => { img.src = candidate; img.hidden = false; });
    root.querySelectorAll('[data-bms-art], [data-bms-spread-art]').forEach(art => { art.hidden = true; });
    remove.hidden = false;
    uploadLabel.textContent = 'Replace photo';
    status.textContent = 'Photo selected · only in this browser';
  });
  window.addEventListener('pagehide', () => { if (photoUrl) URL.revokeObjectURL(photoUrl); });
  update();
})();
