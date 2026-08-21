// ============================================================
// KONFIGURASI SUPABASE
// Isi 2 nilai di bawah ini dengan punya kamu:
// Dashboard Supabase -> Project Settings -> API
//   - "Project URL"      -> SUPABASE_URL
//   - "anon public" key  -> SUPABASE_ANON_KEY
// File ini dipakai bersama oleh index.html DAN admin.html.
// ============================================================
const SUPABASE_URL = 'https://sgrbgvmcqwrdkuuddlti.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNncmJndm1jcXdyZGt1dWRkbHRpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcyOTEwODUsImV4cCI6MjEwMjg2NzA4NX0.h_-5-tgDUsNGebMOBUo0SY2YJ2-kx0-xI6B2yZG_GJE';

// Bucket storage tempat file video/thumbnail disimpan (jangan diubah,
// harus sama dengan nama bucket di supabase-setup.sql)
const STORAGE_BUCKET = 'videos';

// --- Jangan diubah di bawah ini ---
const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

function publicFileUrl(path){
  if (!path) return '';
  return `${SUPABASE_URL}/storage/v1/object/public/${STORAGE_BUCKET}/${path}`;
}
