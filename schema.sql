-- الصق الملف كله مرة واحدة في Supabase > SQL Editor ثم Run

create table menu_items (
  id bigint generated always as identity primary key,
  category text not null,
  name text not null,
  price numeric not null,
  image_url text,
  available boolean not null default true,
  sort int not null default 0
);

create table orders (
  id bigint generated always as identity primary key,
  table_no text not null,
  items jsonb not null,
  total numeric not null,
  status text not null default 'new',
  created_at timestamptz not null default now()
);

alter table menu_items enable row level security;
alter table orders enable row level security;

-- الزبون: يقرأ المنيو ويرسل طلب فقط
create policy "menu read" on menu_items for select using (true);
create policy "order insert" on orders for insert to anon, authenticated with check (status = 'new');

-- الإدارة (بعد تسجيل الدخول): تعديل المنيو وقراءة الطلبات وتحديثها
create policy "menu admin" on menu_items for all to authenticated using (true) with check (true);
create policy "order admin" on orders for all to authenticated using (true) with check (true);

-- تفعيل وصول الطلبات لحظياً لشاشة الكاشير
alter publication supabase_realtime add table orders;
