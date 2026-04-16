// ─── SUPABASE CONFIG ─────────────────────────────────────────────────────────
// Ganti dengan URL dan Key Supabase Anda
const SUPABASE_URL = 'https://jphbvcldbeqsoandkdus.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwaGJ2Y2xkYmVxc29hbmRrZHVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYzNDA4MzksImV4cCI6MjA5MTkxNjgzOX0.slgqTbwWEF2DNToxWjzdD9eDiIr4l2lp6IyFBsHn6NU';

const { createClient } = supabase;
const sb = createClient(SUPABASE_URL, SUPABASE_KEY);

// ─── AUTH GUARD ──────────────────────────────────────────────────────────────
async function requireAuth() {
  const { data: { session } } = await sb.auth.getSession();
  if (!session) {
    window.location.href = 'login.html';
    return null;
  }
  return session;
}

async function requireAdmin() {
  const role = localStorage.getItem('userRole');
  if (role !== 'admin') {
    showToast('Akses ditolak. Hanya Admin.', 'error');
    setTimeout(() => window.location.href = 'dashboard.html', 1500);
    return false;
  }
  return true;
}

// ─── LOGOUT ──────────────────────────────────────────────────────────────────
async function handleLogout() {
  await sb.auth.signOut();
  localStorage.clear();
  window.location.href = 'login.html';
}

// ─── TOAST ───────────────────────────────────────────────────────────────────
function showToast(msg, type = 'success') {
  let container = document.getElementById('toastContainer');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'fixed top-4 right-4 z-50 flex flex-col gap-2';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  const colors = {
    success: 'bg-emerald-900/90 text-emerald-300 border-emerald-700',
    error:   'bg-red-900/90 text-red-300 border-red-700',
    info:    'bg-blue-900/90 text-blue-300 border-blue-700',
    warn:    'bg-amber-900/90 text-amber-300 border-amber-700',
  };
  toast.className = `px-4 py-3 rounded-xl text-sm font-medium border backdrop-blur-sm transition-all duration-300 ${colors[type] || colors.info}`;
  toast.style.cssText = 'opacity:0;transform:translateX(20px);';
  toast.textContent = msg;
  container.appendChild(toast);

  requestAnimationFrame(() => {
    toast.style.opacity = '1';
    toast.style.transform = 'translateX(0)';
  });

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(20px)';
    setTimeout(() => toast.remove(), 300);
  }, 3500);
}

// ─── FORMAT CURRENCY ─────────────────────────────────────────────────────────
function formatRp(amount) {
  return 'Rp ' + Number(amount).toLocaleString('id-ID');
}

// ─── FORMAT DATE ─────────────────────────────────────────────────────────────
function formatDate(dateStr) {
  return new Date(dateStr).toLocaleDateString('id-ID', {
    day: '2-digit', month: 'short', year: 'numeric',
    hour: '2-digit', minute: '2-digit'
  });
}

// ─── NAV ACTIVE ─────────────────────────────────────────────────────────────
function setActiveNav(page) {
  document.querySelectorAll('[data-nav]').forEach(el => {
    el.classList.remove('bg-accent-soft', 'text-accent');
    el.classList.add('text-muted');
    if (el.dataset.nav === page) {
      el.classList.add('bg-accent-soft', 'text-accent');
      el.classList.remove('text-muted');
    }
  });
}
