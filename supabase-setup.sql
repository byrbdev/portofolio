-- ============================================================
-- SETUP DATABASE UNTUK PORTOFOLIO (Supabase)
-- Cara pakai: buka Supabase Dashboard -> SQL Editor -> New Query
-- -> paste semua isi file ini -> klik "Run"
-- ============================================================

create extension if not exists pgcrypto;

-- ============ TABEL: videos (karya TikTok & YouTube) ============
create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('tiktok','youtube')),
  source_url text not null,       -- link asli TikTok/YouTube (tombol "Lihat di TikTok/YouTube")
  video_path text,                -- path file .mp4 di storage (khusus TikTok, hasil upload admin)
  thumbnail_path text,            -- path gambar thumbnail di storage (opsional)
  youtube_id text,                -- ID video YouTube (khusus YouTube, dipakai untuk embed)
  title text,
  views bigint,
  likes bigint,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- ============ TABEL: handled_accounts (akun yang di-handle) ============
create table if not exists public.handled_accounts (
  id uuid primary key default gen_random_uuid(),
  platform text not null,
  name text not null,
  url text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- ============ ROW LEVEL SECURITY ============
alter table public.videos enable row level security;
alter table public.handled_accounts enable row level security;

-- Siapa saja (pengunjung website) boleh MEMBACA data
drop policy if exists "public read videos" on public.videos;
create policy "public read videos" on public.videos for select using (true);

drop policy if exists "public read handled" on public.handled_accounts;
create policy "public read handled" on public.handled_accounts for select using (true);

-- Hanya admin yang sudah login (authenticated) boleh tambah/ubah/hapus
drop policy if exists "admin write videos insert" on public.videos;
create policy "admin write videos insert" on public.videos for insert to authenticated with check (true);
drop policy if exists "admin write videos update" on public.videos;
create policy "admin write videos update" on public.videos for update to authenticated using (true) with check (true);
drop policy if exists "admin write videos delete" on public.videos;
create policy "admin write videos delete" on public.videos for delete to authenticated using (true);

drop policy if exists "admin write handled insert" on public.handled_accounts;
create policy "admin write handled insert" on public.handled_accounts for insert to authenticated with check (true);
drop policy if exists "admin write handled update" on public.handled_accounts;
create policy "admin write handled update" on public.handled_accounts for update to authenticated using (true) with check (true);
drop policy if exists "admin write handled delete" on public.handled_accounts;
create policy "admin write handled delete" on public.handled_accounts for delete to authenticated using (true);

-- ============ STORAGE BUCKET untuk file .mp4 & thumbnail ============
insert into storage.buckets (id, name, public)
values ('videos', 'videos', true)
on conflict (id) do nothing;

drop policy if exists "public read video files" on storage.objects;
create policy "public read video files" on storage.objects
  for select using (bucket_id = 'videos');

drop policy if exists "admin upload video files" on storage.objects;
create policy "admin upload video files" on storage.objects
  for insert to authenticated with check (bucket_id = 'videos');

drop policy if exists "admin update video files" on storage.objects;
create policy "admin update video files" on storage.objects
  for update to authenticated using (bucket_id = 'videos');

drop policy if exists "admin delete video files" on storage.objects;
create policy "admin delete video files" on storage.objects
  for delete to authenticated using (bucket_id = 'videos');

-- ============ SELESAI ============
-- Langkah selanjutnya: buat 1 user admin lewat
-- Dashboard -> Authentication -> Users -> Add User (isi email + password).
-- Email & password itu yang dipakai login di admin.html.
