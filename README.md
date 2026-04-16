# 🛒 KasirKu POS — Point of Sale System

Aplikasi kasir modern untuk cafe / UMKM berbasis web. Single-file HTML, Vanilla JS, Tailwind CSS, dan Supabase.

---

## 📁 Struktur File

```
pos-cafe/
├── login.html         # Halaman login
├── dashboard.html     # Dashboard & statistik
├── kasir.html         # Halaman transaksi kasir
├── produk.html        # Manajemen produk
├── transaksi.html     # Riwayat transaksi
├── user.html          # Manajemen user (admin only)
├── app.js             # Shared utilities (Supabase client, helpers)
├── schema.sql         # SQL schema untuk Supabase
└── README.md
```

---

## 🚀 Setup Cepat

### 1. Buat Project Supabase
1. Buka [supabase.com](https://supabase.com) → New Project
2. Catat **Project URL** dan **anon/public key**

### 2. Setup Database
1. Buka Supabase Dashboard → **SQL Editor**
2. Paste isi `schema.sql` → klik **Run**

### 3. Konfigurasi Auth
Di Supabase Dashboard → **Authentication → Settings**:
- Disable email confirmation (untuk development): **Enable email confirmations → OFF**
- Atau konfigurasikan SMTP untuk production

### 4. Ganti Konfigurasi di Kode
Buka **`app.js`** dan ganti:
```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';    // ← ganti ini
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY'; // ← dan ini
```

Sama juga di `login.html` (baris paling atas di `<script>`).

### 5. Buat User Admin Pertama
Di Supabase Dashboard → **Authentication → Users** → **Add User**:
- Email: `admin@cafe.com`
- Password: bebas

Lalu di **SQL Editor**, jalankan:
```sql
UPDATE public.users SET role = 'admin' WHERE email = 'admin@cafe.com';
```

---

## 🚢 Deploy ke Vercel

### Cara 1: Drag & Drop
1. Buka [vercel.com](https://vercel.com)
2. Drag folder `pos-cafe/` ke dashboard Vercel
3. Deploy otomatis!

### Cara 2: Git
```bash
cd pos-cafe
git init
git add .
git commit -m "Initial commit"
# Push ke GitHub, lalu connect di Vercel
```

Tidak perlu `vercel.json` — semua file HTML bisa diakses langsung.

---

## ✨ Fitur

| Fitur | Status |
|-------|--------|
| Login/Logout (Supabase Auth) | ✅ |
| Role: Admin & Kasir | ✅ |
| Dashboard + Grafik 7 hari | ✅ |
| Manajemen Produk (CRUD) | ✅ |
| Kasir dengan keranjang | ✅ |
| Pembayaran: Cash, Transfer, E-Wallet | ✅ |
| Hitung kembalian otomatis | ✅ |
| Riwayat transaksi + filter | ✅ |
| Export CSV | ✅ |
| Print struk | ✅ |
| Notifikasi toast | ✅ |
| Mobile-first responsive | ✅ |
| Manajemen user (Admin) | ✅ |

---

## 🛠 Teknologi

- **HTML5** — Single page, no build tool
- **Tailwind CSS** via CDN
- **Supabase JS** via CDN (Auth + Database)
- **Chart.js** via CDN (grafik dashboard)
- **Google Fonts** — DM Sans + DM Mono

---

## 💡 Tips

- Untuk **upload gambar produk**, aktifkan Supabase Storage dan upload ke bucket `products`
- Untuk **hapus user dari Auth** (bukan hanya tabel), gunakan Supabase **Admin API** dengan service_role key (jangan expose di frontend!)
- Tambahkan `?debug=true` ke URL untuk melihat log console

---

## 📞 Support

Dikembangkan oleh **IBDIGITAL ID** untuk keperluan UMKM lokal Indonesia.
