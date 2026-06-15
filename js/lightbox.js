document.querySelectorAll('figure img').forEach(img => {
  img.style.cursor = 'zoom-in';
  img.addEventListener('click', () => {
    document.getElementById('lightbox-img').src = img.src;
    document.getElementById('lightbox-img').alt = img.alt;
    document.getElementById('lightbox').style.display = 'block';
    document.body.style.overflow = 'hidden';
  });
});

function closeLightbox(e) {
  if (e && e.target === document.getElementById('lightbox-img')) return;
  document.getElementById('lightbox').style.display = 'none';
  document.body.style.overflow = '';
}

document.getElementById('lightbox').addEventListener('click', closeLightbox);
document.getElementById('lightbox-close').addEventListener('click', closeLightbox);
document.addEventListener('keydown', e => { if (e.key === 'Escape') closeLightbox(); });
