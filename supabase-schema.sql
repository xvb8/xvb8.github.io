create extension if not exists pgcrypto;

create table if not exists public.qa_items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  question text not null,
  answer text not null,
  position integer not null default 0,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.timer_items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  seconds integer not null check (seconds > 0),
  position integer not null default 0,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.timer_state (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  current_index integer not null default 0,
  elapsed integer not null default 0 check (elapsed >= 0),
  sound boolean not null default true,
  done boolean not null default false,
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists qa_items_owner_position_idx on public.qa_items (owner_id, position);
create index if not exists timer_items_owner_position_idx on public.timer_items (owner_id, position);

alter table public.qa_items enable row level security;
alter table public.timer_items enable row level security;
alter table public.timer_state enable row level security;

drop policy if exists qa_items_select_own on public.qa_items;
drop policy if exists qa_items_insert_own on public.qa_items;
drop policy if exists qa_items_update_own on public.qa_items;
drop policy if exists qa_items_delete_own on public.qa_items;

create policy qa_items_select_own on public.qa_items
  for select using (auth.uid() = owner_id);

create policy qa_items_insert_own on public.qa_items
  for insert with check (auth.uid() = owner_id);

create policy qa_items_update_own on public.qa_items
  for update using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy qa_items_delete_own on public.qa_items
  for delete using (auth.uid() = owner_id);

drop policy if exists timer_items_select_own on public.timer_items;
drop policy if exists timer_items_insert_own on public.timer_items;
drop policy if exists timer_items_update_own on public.timer_items;
drop policy if exists timer_items_delete_own on public.timer_items;

create policy timer_items_select_own on public.timer_items
  for select using (auth.uid() = owner_id);

create policy timer_items_insert_own on public.timer_items
  for insert with check (auth.uid() = owner_id);

create policy timer_items_update_own on public.timer_items
  for update using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy timer_items_delete_own on public.timer_items
  for delete using (auth.uid() = owner_id);

drop policy if exists timer_state_select_own on public.timer_state;
drop policy if exists timer_state_insert_own on public.timer_state;
drop policy if exists timer_state_update_own on public.timer_state;
drop policy if exists timer_state_delete_own on public.timer_state;

create policy timer_state_select_own on public.timer_state
  for select using (auth.uid() = owner_id);

create policy timer_state_insert_own on public.timer_state
  for insert with check (auth.uid() = owner_id);

create policy timer_state_update_own on public.timer_state
  for update using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

create policy timer_state_delete_own on public.timer_state
  for delete using (auth.uid() = owner_id);