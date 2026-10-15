(function () {
  const root = document.querySelector('[data-bms-preview]');
  if (!root) return;

  const fields = {
    name: root.querySelector('[data-bms-input="name"]'),
    age: root.querySelector('[data-bms-input="age"]'),
    style: root.querySelector('[data-bms-input="style"]'),
    file: root.querySelector('[data-bms-file]'),
  };
  const status = root.querySelector('[data-bms-status]');
  let photoUrl = '';

  function update() {
    const name = fields.name.value.trim() || 'Someone special';
    const age = fields.age.value ? Math.max(1, Math.min(120, Number(fields.age.value))) : '';
    root.dataset.style = fields.style.value;
    root.querySelectorAll('[data-bms-name]').forEach((node) => { node.textContent = name.toUpperCase(); });
    root.querySelectorAll('[data-bms-age]').forEach((node) => { node.textContent = age ? `AGE ${age} · IN THEIR PRIME` : 'THE BIRTHDAY EDITION'; });
    const story = root.querySelector('[data-bms-story]');
    story.textContent = age ? `${age} looks good on you, ${name}. Here’s to everything you’ve made, the people who make you laugh, and the best chapters still ahead.` : `Here’s to everything you’ve made, the people who make you laugh, and the best chapters still ahead, ${name}.`;
  }

  fields.name.addEventListener('input', update);
  fields.age.addEventListener('input', update);
  fields.style.addEventListener('change', update);
  fields.file.addEventListener('change', () => {
    const file = fields.file.files && fields.file.files[0];
    if (photoUrl) URL.revokeObjectURL(photoUrl);
    photoUrl = '';
    if (!file) {
      root.querySelectorAll('[data-bms-image]').forEach((img) => { img.removeAttribute('src'); img.hidden = true; });
      root.querySelectorAll('[data-bms-art], [data-bms-spread-art]').forEach((art) => { art.hidden = false; });
      status.textContent = 'No photo selected. Your preview works without one.';
      return;
    }
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
      fields.file.value = '';
      status.textContent = 'Choose one JPG, PNG or WebP image.';
      return;
    }
    photoUrl = URL.createObjectURL(file);
    root.querySelectorAll('[data-bms-image]').forEach((img) => { img.src = photoUrl; img.hidden = false; });
    root.querySelectorAll('[data-bms-art], [data-bms-spread-art]').forEach((art) => { art.hidden = true; });
    status.textContent = `${file.name} · browser-local preview only`;
  });
  window.addEventListener('pagehide', () => { if (photoUrl) URL.revokeObjectURL(photoUrl); });
  update();
})();
