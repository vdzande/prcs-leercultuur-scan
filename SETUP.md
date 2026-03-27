# PRCS Leercultuur Scan — Setup Handleiding

## Wat heb je nodig?

1. **Supabase account** (gratis) — database en authenticatie
2. **Vercel account** (gratis) — hosting op scan.prcs.nl
3. **DNS-toegang** bij je domeinbeheerder van prcs.nl

---

## Stap 1: Supabase instellen

### Account aanmaken
1. Ga naar [supabase.com](https://supabase.com) en klik "Start your project"
2. Log in met je GitHub account (vdzande)
3. Klik "New project"
4. Kies een naam (bijv. `prcs-leercultuur-scan`)
5. Kies een sterk database-wachtwoord en bewaar dit!
6. Regio: **West EU (Frankfurt)** voor snelheid
7. Klik "Create new project" en wacht ~2 minuten

### Database schema aanmaken
1. Ga in Supabase naar **SQL Editor** (linker menu)
2. Klik "New query"
3. Kopieer de volledige inhoud van `setup.sql` en plak deze in de editor
4. Klik "Run" — je ziet "Success" bij elke stap

### Admin-gebruiker aanmaken
1. Ga naar **Authentication** > **Users** in het Supabase dashboard
2. Klik "Add user" > "Create new user"
3. Vul in:
   - Email: `rutger@vrij-spreken.nl` (of een ander admin-adres)
   - Password: kies een sterk wachtwoord
4. Klik "Create user"

### API-sleutels ophalen
1. Ga naar **Settings** > **API** in het Supabase dashboard
2. Kopieer:
   - **Project URL** (lijkt op `https://abcdefg.supabase.co`)
   - **anon/public key** (lange string die begint met `eyJ...`)

### Sleutels invullen in de code
Open de bestanden `index.html` en `admin.html` en vervang bovenaan:
```js
const SUPABASE_URL = 'https://JOUW-PROJECT.supabase.co';   // ← Project URL
const SUPABASE_ANON_KEY = 'JOUW-ANON-KEY';                 // ← anon key
```

---

## Stap 2: Vercel instellen

### Account aanmaken en repo koppelen
1. Ga naar [vercel.com](https://vercel.com) en log in met je GitHub account
2. Klik "Add New..." > "Project"
3. Selecteer de repository `prcs-leercultuur-scan`
4. Framework Preset: **Other** (het is een statische site)
5. Klik "Deploy"
6. Na ~30 seconden is je site live op `prcs-leercultuur-scan.vercel.app`

Elke keer dat je code pusht naar GitHub wordt de site automatisch bijgewerkt.

---

## Stap 3: Domein koppelen (scan.prcs.nl)

### In Vercel
1. Ga naar je project in Vercel
2. Klik **Settings** > **Domains**
3. Vul in: `scan.prcs.nl`
4. Vercel toont een DNS-record dat je moet toevoegen

### Bij je domeinbeheerder (waar prcs.nl geregistreerd is)
1. Log in bij je domeinbeheerder (TransIP, Antagonist, of wie het is)
2. Ga naar DNS-instellingen voor prcs.nl
3. Voeg een **CNAME-record** toe:
   - Naam/Host: `scan`
   - Type: `CNAME`
   - Waarde: `cname.vercel-dns.com`
4. Sla op en wacht 5-30 minuten

### Verifiëren
1. Ga terug naar Vercel > Settings > Domains
2. Het domein zou nu "Valid Configuration" moeten tonen
3. HTTPS wordt automatisch ingesteld door Vercel

---

## Klaar! Zo gebruik je het

### Als beheerder
1. Ga naar `scan.prcs.nl/admin.html`
2. Log in met je admin e-mail en wachtwoord
3. Maak een nieuwe scanronde aan
4. Kopieer de uitnodigingslinks en verstuur ze

### Als deelnemer
1. Open de ontvangen link (bijv. `scan.prcs.nl/?code=Xk9mT3pQ`)
2. Vul je naam in en start de scan
3. Doorloop de 30 vragen en bekijk je resultaten
4. Resultaten worden automatisch opgeslagen

### Resultaten bekijken
1. Ga naar het admin-dashboard
2. Selecteer de scanronde
3. Bekijk gemiddelden, radar chart en individuele resultaten
4. Exporteer naar CSV voor verdere analyse

---

## Veelgestelde vragen

**Kan ik de Supabase-sleutels veilig in de code laten staan?**
Ja, de `anon key` is bedoeld voor client-side gebruik. De Row Level Security (RLS) policies zorgen ervoor dat gebruikers alleen kunnen wat ze mogen (invullen + code valideren). Admin-functies vereisen inloggen.

**Wat als ik meer beheerders wil?**
Maak extra gebruikers aan in Supabase > Authentication > Users.

**Hoeveel scans kan ik gratis doen?**
Supabase free tier: 500MB database, 50.000 rijen. Dat is genoeg voor duizenden scans.
Vercel free tier: 100GB bandbreedte per maand. Ruim voldoende.

**Kan ik de scan ook zonder uitnodigingscode laten invullen?**
Ja, op de codepagina staat een "Direct invullen zonder code" link. Resultaten worden dan opgeslagen zonder koppeling aan een ronde.
