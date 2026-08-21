# Panduan Setup — Portofolio dengan Supabase

Sistem lama (Google Apps Script + Sheet) sudah diganti total dengan **Supabase**
(database + storage file). Video TikTok sekarang di-upload sebagai file `.mp4`
mentahan, disimpan di storage sendiri, lalu diputar pakai tag `<video>` bawaan
browser — bukan iframe TikTok lagi. Jadi lebih ringan dan tidak butuh cookie
pihak ketiga apa pun untuk bisa jalan.

File di paket ini:
- `index.html` — website publik (yang dilihat pengunjung)
- `admin.html` — dashboard admin (untuk kamu, input data)
- `supabase-config.js` — 1 file config yang dipakai bareng oleh index.html & admin.html
- `supabase-setup.sql` — script SQL untuk membuat tabel & aturan keamanan di Supabase

---

## 1. Buat project Supabase (gratis)

1. Buka **[supabase.com](https://supabase.com)** → **Start your project** → daftar/login (bisa pakai akun GitHub/Google).
2. Klik **New Project**.
   - Isi nama project bebas, misal `portofolio-rifqi`.
   - Isi **Database Password** — simpan baik-baik (bukan password login admin, ini password database).
   - Pilih region terdekat (misal **Southeast Asia (Singapore)**).
   - Klik **Create new project**, tunggu ± 1-2 menit sampai selesai provisioning.

## 2. Jalankan SQL setup (buat tabel + storage)

1. Di sidebar kiri project, klik **SQL Editor** → **New query**.
2. Buka file `supabase-setup.sql` dari paket ini, copy semua isinya, paste ke editor.
3. Klik **Run** (atau `Ctrl+Enter`).
4. Kalau sukses tanpa error, berarti tabel `videos`, `handled_accounts`, dan storage bucket `videos` sudah jadi otomatis lengkap dengan aturan keamanannya (Row Level Security).

## 3. Buat akun login admin

1. Di sidebar, klik **Authentication** → **Users** → **Add user** → **Create new user**.
2. Isi email dan password yang mau kamu pakai untuk login ke `admin.html`.
3. Pastikan opsi **Auto Confirm User** dicentang (supaya tidak perlu verifikasi email).
4. Klik **Create user**.

> Ini satu-satunya cara membuat akun admin — tidak ada form pendaftaran publik di `admin.html`, jadi aman dari orang asing yang coba daftar sendiri.

## 4. Ambil URL & API Key project

1. Di sidebar, klik ikon gear **Project Settings** → **API**.
2. Catat 2 nilai ini:
   - **Project URL** (contoh: `https://abcxyzproject.supabase.co`)
   - **anon public** key (kunci panjang di bagian "Project API keys")

## 5. Isi `supabase-config.js`

Buka file `supabase-config.js`, ganti baris ini dengan nilai kamu:

```js
const SUPABASE_URL = 'https://abcxyzproject.supabase.co';
const SUPABASE_ANON_KEY = 'isi-anon-public-key-di-sini';
```

Simpan. File ini dipakai bersama oleh `index.html` dan `admin.html`, jadi cukup diisi sekali.

## 6. (Opsional tapi disarankan) Naikkan batas ukuran file upload

Supabase Storage secara default membatasi ukuran file per-upload (biasanya 50MB
di tier gratis). Video TikTok umumnya kecil (di bawah itu), tapi kalau ada yang
lebih besar:

1. Sidebar → **Storage** → klik bucket **videos** → **Edit bucket**.
2. Naikkan **File size limit** sesuai kebutuhan (batas maksimum tergantung plan Supabase kamu).

## 7. Upload ke hosting

Upload 4 file ini ke folder yang sama di hosting kamu (Netlify, Vercel, cPanel, dsb — bebas, tidak perlu server khusus karena semuanya jalan di browser):
- `index.html`
- `admin.html`
- `supabase-config.js`
- (file `Code.gs` dan `start-server.bat` dari sistem lama sudah tidak dipakai lagi, boleh diabaikan/dihapus)

## 8. Cara pakai sehari-hari

- Buka `admin.html`, login pakai email & password yang dibuat di langkah 3.
- Tab **Video Karya**:
  - Pilih tipe **TikTok** → upload file `.mp4`, opsional thumbnail gambar, isi link TikTok asli (untuk tombol "Lihat di TikTok"), judul/views/likes opsional.
  - Pilih tipe **YouTube** → cukup tempel link YouTube-nya, tetap tampil sebagai embed player YouTube seperti biasa.
  - Klik **Simpan Video** — otomatis langsung muncul di `index.html`.
  - Klik **Edit** di daftar untuk mengubah data, atau **Hapus** untuk menghapus (file di storage ikut terhapus).
- Tab **Akun Di-handle**: sama, tambah/edit/hapus akun yang ditampilkan di section "Akun yang Pernah Saya Handle".

## Catatan keamanan

- Pengunjung biasa hanya bisa **membaca** data (lihat video & daftar akun) — tidak bisa mengubah apa pun, walau tahu URL Supabase & anon key (anon key memang publik by design, dibatasi lewat Row Level Security yang sudah diatur di `supabase-setup.sql`).
- Hanya user yang **login** (lewat `admin.html`) yang bisa tambah/ubah/hapus data, karena aturan RLS membatasi insert/update/delete hanya untuk `authenticated`.
- Jangan bagikan link `admin.html` secara publik supaya tidak jadi sasaran percobaan brute-force login (walau tetap butuh password yang benar).
