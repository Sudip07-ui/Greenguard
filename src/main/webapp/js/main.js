/* GreenGuard – main.js */

// ── Sidebar toggle (mobile) ───────────────────────────────
document.addEventListener('DOMContentLoaded', () => {

  const hamburger = document.getElementById('hamburger');
  const sidebar   = document.getElementById('sidebar');
  const overlay   = document.getElementById('overlay');

  if (hamburger && sidebar) {
    hamburger.addEventListener('click', () => {
      sidebar.classList.toggle('open');

      if (overlay) {
        overlay.classList.toggle('show');
      }
    });
  }

  if (overlay) {
    overlay.addEventListener('click', () => {
      sidebar.classList.remove('open');
      overlay.classList.remove('show');
    });
  }

  // ── Active nav link ─────────────────────────────────────
  const currentPath = window.location.pathname;

  document.querySelectorAll('.nav-item').forEach(item => {

    const href = item.getAttribute('href');

    if (href && currentPath.includes(href)) {
      item.classList.add('active');
    }

  });

  // ── Photo preview on file input ─────────────────────────
  const photoInput   = document.getElementById('photoInput');
  const photoPreview = document.getElementById('photoPreview');

  if (photoInput && photoPreview) {

    photoInput.addEventListener('change', (e) => {

      const file = e.target.files[0];

      if (file) {

        const reader = new FileReader();

        reader.onload = (ev) => {

          photoPreview.src = ev.target.result;
          photoPreview.style.display = 'block';

        };

        reader.readAsDataURL(file);

      }

    });

  }

  // ── Geolocation fill ────────────────────────────────────
  const geoBtn = document.getElementById('geoBtn');

  if (geoBtn) {

    geoBtn.addEventListener('click', () => {

      if (!navigator.geolocation) {

        alert('Geolocation is not supported by your browser.');
        return;

      }

      geoBtn.textContent = '📍 Getting location…';
      geoBtn.disabled = true;

      navigator.geolocation.getCurrentPosition(

          (pos) => {

            const lat = pos.coords.latitude.toFixed(6);
            const lng = pos.coords.longitude.toFixed(6);

            const latInput = document.getElementById('latitude');
            const lngInput = document.getElementById('longitude');

            if (latInput) latInput.value = lat;
            if (lngInput) lngInput.value = lng;

            geoBtn.textContent = '✅ Location captured';
            geoBtn.disabled = false;

          },

          () => {

            alert('Could not get your location. Please enter it manually.');

            geoBtn.textContent = '📍 Use My Location';
            geoBtn.disabled = false;

          }

      );

    });

  }

  // ── Auto-dismiss alerts ─────────────────────────────────
  document.querySelectorAll('.alert[data-autodismiss]').forEach(alert => {

    setTimeout(() => {

      alert.style.transition = 'opacity .5s';
      alert.style.opacity = '0';

      setTimeout(() => {

        alert.remove();

      }, 500);

    }, 4000);

  });

  // ── Confirm delete / action ─────────────────────────────
  document.querySelectorAll('[data-confirm]').forEach(el => {

    el.addEventListener('click', (e) => {

      const msg =
          el.getAttribute('data-confirm') || 'Are you sure?';

      if (!confirm(msg)) {
        e.preventDefault();
      }

    });

  });

  // ── Table row click → href ──────────────────────────────
  document.querySelectorAll('tr[data-href]').forEach(row => {

    row.style.cursor = 'pointer';

    row.addEventListener('click', () => {

      window.location.href =
          row.getAttribute('data-href');

    });

  });

});
// ================= NOTIFICATIONS =================

document.addEventListener('DOMContentLoaded', () => {

  const bell =
      document.getElementById('notifBell');

  const dropdown =
      document.getElementById('notifDropdown');

  if (bell && dropdown) {

    bell.addEventListener('click', (e) => {

      e.stopPropagation();

      dropdown.classList.toggle('show');

    });

    document.addEventListener('click', () => {

      dropdown.classList.remove('show');

    });

    dropdown.addEventListener('click', (e) => {

      e.stopPropagation();

    });

  }

});