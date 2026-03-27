-- ============================================================
-- PRCS Leercultuur Scan — Supabase Database Schema
-- Voer dit uit in de Supabase SQL Editor (dashboard > SQL Editor)
-- ============================================================

-- 1. Scan-rondes (bijv. "Organisatie X — maart 2026")
create table scan_rondes (
  id uuid default gen_random_uuid() primary key,
  naam text not null,
  organisatie text,
  omschrijving text,
  actief boolean default true,
  aangemaakt_op timestamp with time zone default now()
);

-- 2. Uitnodigingen (unieke codes per deelnemer)
create table uitnodigingen (
  id uuid default gen_random_uuid() primary key,
  ronde_id uuid references scan_rondes(id) on delete cascade not null,
  code text unique not null,
  label text, -- optioneel: "Team Finance", "Afdeling HR", etc.
  gebruikt_op timestamp with time zone,
  aangemaakt_op timestamp with time zone default now()
);

-- 3. Resultaten (ingevulde scans)
create table resultaten (
  id uuid default gen_random_uuid() primary key,
  uitnodiging_id uuid references uitnodigingen(id) on delete set null,
  ronde_id uuid references scan_rondes(id) on delete cascade not null,
  respondent_naam text,
  organisatie_naam text,
  antwoorden jsonb not null,       -- {"0-0-0": 3, "0-0-1": 4, ...}
  scores jsonb not null,           -- {overall, domains[], subs[]}
  ingevuld_op timestamp with time zone default now()
);

-- 4. Indexen voor snelle queries
create index idx_uitnodigingen_code on uitnodigingen(code);
create index idx_uitnodigingen_ronde on uitnodigingen(ronde_id);
create index idx_resultaten_ronde on resultaten(ronde_id);
create index idx_resultaten_uitnodiging on resultaten(uitnodiging_id);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Schakel RLS in op alle tabellen
alter table scan_rondes enable row level security;
alter table uitnodigingen enable row level security;
alter table resultaten enable row level security;

-- Publieke leesrechten voor uitnodigingen (om code te valideren)
create policy "Uitnodigingen: publiek lezen op code"
  on uitnodigingen for select
  using (true);

-- Publieke schrijfrechten voor resultaten (deelnemers mogen invullen)
create policy "Resultaten: publiek invoegen"
  on resultaten for insert
  with check (true);

-- Publieke update op uitnodigingen (markeren als gebruikt)
create policy "Uitnodigingen: publiek updaten gebruikt_op"
  on uitnodigingen for update
  using (true)
  with check (true);

-- Admin (ingelogd) mag alles lezen
create policy "Scan_rondes: admin lezen"
  on scan_rondes for select
  using (auth.role() = 'authenticated');

create policy "Scan_rondes: admin invoegen"
  on scan_rondes for insert
  with check (auth.role() = 'authenticated');

create policy "Scan_rondes: admin updaten"
  on scan_rondes for update
  using (auth.role() = 'authenticated');

create policy "Scan_rondes: admin verwijderen"
  on scan_rondes for delete
  using (auth.role() = 'authenticated');

create policy "Resultaten: admin lezen"
  on resultaten for select
  using (auth.role() = 'authenticated');

create policy "Uitnodigingen: admin invoegen"
  on uitnodigingen for insert
  with check (auth.role() = 'authenticated');

create policy "Uitnodigingen: admin verwijderen"
  on uitnodigingen for delete
  using (auth.role() = 'authenticated');

-- Publiek mag actieve rondes lezen (voor code-validatie)
create policy "Scan_rondes: publiek actieve lezen"
  on scan_rondes for select
  using (actief = true);
