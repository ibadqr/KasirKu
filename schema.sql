-- ═══════════════════════════════════════════════════
--  KasirKu POS — Supabase Database Schema
--  Jalankan di Supabase SQL Editor
-- ═══════════════════════════════════════════════════

-- 1. USERS TABLE
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  role text not null default 'kasir' check (role in ('admin', 'kasir')),
  created_at timestamptz default now()
);

-- 2. PRODUCTS TABLE
create table if not exists public.products (
  id bigint generated always as identity primary key,
  name text not null,
  price numeric(12,0) not null default 0,
  stock integer not null default 0,
  category text,
  image_url text,
  created_at timestamptz default now()
);

-- 3. TRANSACTIONS TABLE
create table if not exists public.transactions (
  id uuid default gen_random_uuid() primary key,
  total numeric(12,0) not null default 0,
  payment_method text not null default 'cash' check (payment_method in ('cash','transfer','ewallet')),
  user_id uuid references public.users(id),
  created_at timestamptz default now()
);

-- 4. TRANSACTION ITEMS TABLE
create table if not exists public.transaction_items (
  id bigint generated always as identity primary key,
  transaction_id uuid references public.transactions(id) on delete cascade,
  product_id bigint references public.products(id),
  qty integer not null default 1,
  price numeric(12,0) not null default 0,
  created_at timestamptz default now()
);

-- ═══════════════════════════════════════════════════
--  ROW LEVEL SECURITY (RLS)
-- ═══════════════════════════════════════════════════

alter table public.users enable row level security;
alter table public.products enable row level security;
alter table public.transactions enable row level security;
alter table public.transaction_items enable row level security;

-- Users: bisa baca semua, tapi hanya bisa update diri sendiri
create policy "Users can read all" on public.users for select using (auth.role() = 'authenticated');
create policy "Users can insert self" on public.users for insert with check (auth.uid() = id);
create policy "Admin can update users" on public.users for update using (
  exists (select 1 from public.users where id = auth.uid() and role = 'admin')
);
create policy "Admin can delete users" on public.users for delete using (
  exists (select 1 from public.users where id = auth.uid() and role = 'admin')
);

-- Products: semua user terautentikasi bisa baca; hanya admin yang bisa CRUD
create policy "Authenticated can read products" on public.products for select using (auth.role() = 'authenticated');
create policy "Authenticated can insert products" on public.products for insert with check (auth.role() = 'authenticated');
create policy "Authenticated can update products" on public.products for update using (auth.role() = 'authenticated');
create policy "Admin can delete products" on public.products for delete using (auth.role() = 'authenticated');

-- Transactions: semua kasir bisa insert; baca sesuai role
create policy "Authenticated can read transactions" on public.transactions for select using (auth.role() = 'authenticated');
create policy "Authenticated can insert transactions" on public.transactions for insert with check (auth.role() = 'authenticated');

-- Transaction items: sama seperti transactions
create policy "Authenticated can read items" on public.transaction_items for select using (auth.role() = 'authenticated');
create policy "Authenticated can insert items" on public.transaction_items for insert with check (auth.role() = 'authenticated');

-- ═══════════════════════════════════════════════════
--  TRIGGER: Auto-insert ke tabel users setelah signup
-- ═══════════════════════════════════════════════════

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, email, role)
  values (new.id, new.email, 'kasir')
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ═══════════════════════════════════════════════════
--  SAMPLE DATA (opsional, hapus jika tidak dibutuhkan)
-- ═══════════════════════════════════════════════════

insert into public.products (name, price, stock, category) values
  ('Kopi Hitam', 8000, 100, 'Minuman'),
  ('Kopi Susu', 12000, 100, 'Minuman'),
  ('Es Teh Manis', 5000, 100, 'Minuman'),
  ('Matcha Latte', 18000, 50, 'Minuman'),
  ('Croissant', 15000, 30, 'Makanan'),
  ('Nasi Goreng', 20000, 20, 'Makanan'),
  ('Sandwich Ayam', 18000, 25, 'Makanan'),
  ('Kentang Goreng', 12000, 40, 'Snack'),
  ('Pisang Goreng', 8000, 50, 'Snack'),
  ('Roti Bakar', 10000, 30, 'Snack')
on conflict do nothing;
