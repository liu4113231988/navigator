-- 起航导航：Supabase 数据库初始化脚本
-- 在 Supabase Dashboard -> SQL Editor 中完整执行一次即可。
-- 说明：所有数据都绑定 auth.uid()，并启用 RLS，浏览器前端只需 Publishable key。

create table if not exists public.nav_categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 40),
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, name)
);

create table if not exists public.nav_sites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.nav_categories(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 60),
  url text not null check (char_length(url) between 8 and 500),
  description text check (description is null or char_length(description) <= 120),
  icon_url text,
  is_favorite boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, url)
);

create index if not exists nav_categories_user_sort_idx
  on public.nav_categories(user_id, sort_order, created_at);

create index if not exists nav_sites_user_category_sort_idx
  on public.nav_sites(user_id, category_id, sort_order, created_at);

create index if not exists nav_sites_user_favorite_idx
  on public.nav_sites(user_id, is_favorite);

alter table public.nav_categories enable row level security;
alter table public.nav_sites enable row level security;

-- 为了让脚本可以安全重复执行，先删除同名策略。
drop policy if exists "nav_categories_select_own" on public.nav_categories;
drop policy if exists "nav_categories_insert_own" on public.nav_categories;
drop policy if exists "nav_categories_update_own" on public.nav_categories;
drop policy if exists "nav_categories_delete_own" on public.nav_categories;
drop policy if exists "nav_sites_select_own" on public.nav_sites;
drop policy if exists "nav_sites_insert_own" on public.nav_sites;
drop policy if exists "nav_sites_update_own" on public.nav_sites;
drop policy if exists "nav_sites_delete_own" on public.nav_sites;

-- categories policies
create policy "nav_categories_select_own"
  on public.nav_categories for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "nav_categories_insert_own"
  on public.nav_categories for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

create policy "nav_categories_update_own"
  on public.nav_categories for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "nav_categories_delete_own"
  on public.nav_categories for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- sites policies
create policy "nav_sites_select_own"
  on public.nav_sites for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "nav_sites_insert_own"
  on public.nav_sites for insert
  to authenticated
  with check (
    (select auth.uid()) = user_id
    and exists (
      select 1
      from public.nav_categories c
      where c.id = category_id
        and c.user_id = (select auth.uid())
    )
  );

create policy "nav_sites_update_own"
  on public.nav_sites for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check (
    (select auth.uid()) = user_id
    and exists (
      select 1
      from public.nav_categories c
      where c.id = category_id
        and c.user_id = (select auth.uid())
    )
  );

create policy "nav_sites_delete_own"
  on public.nav_sites for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- Data API permissions. RLS 仍会继续限制到当前登录用户自己的行。
grant select, insert, update, delete on table public.nav_categories to authenticated;
grant select, insert, update, delete on table public.nav_sites to authenticated;

-- 不给 anon 角色开放数据表权限；未登录用户不能读取导航数据。
revoke all on table public.nav_categories from anon;
revoke all on table public.nav_sites from anon;