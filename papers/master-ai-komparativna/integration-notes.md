# Integracija i korelacija sistema — beleške za master rad (komparativna analiza 4 AI implementacije)

> Autor: Luka Vidaković. Radni dokument (ne ulazi u build).
>
> Ovo je TREĆA istraživačka faza. Prve dve su dale: (a) literaturu i analitički
> okvir (`research-notes.md`) i (b) arhitekturu po komponenti
> (`architecture-notes.md`). Ovaj dokument opisuje kako sve komponente rade
> **ZAJEDNO kao jedan sistem** — što je metodološko opravdanje komparativnog
> okvira: 4 slučaja nisu 4 odvojena proizvoda, nego 4 konfiguracije ISTE
> platforme sa deljenim slojevima i jednim mernim instrumentom.
>
> Sve tvrdnje su iz STVARNOG koda / case-studija u `~/github/work/world/`
> (repo `world`) i sa `startai.tech/en/case-studies`, pregledano 2026-09-20.
> Ništa nije izmišljeno; gde nešto nije potvrđeno u kodu stoji **TODO**.
>
> **BEZBEDNOST:** namerno NE navodim ARN-ove, API ključeve, IP adrese, imena S3
> bucketa, konkretne imejl-adrese ni AWS account ID-jeve (naišao sam na njih u
> `scripts/atlas24h_lead_extraction.py` i `scripts/sales-voicebot/` — NE ulaze u
> rad). Opis je na nivou komponenti i tokova.

---

## 0. Teza ovog dokumenta (za sekciju „Sistem" i „Diskusija")

Četiri studije slučaja dele **jednu platformu**. Dva „runtime" proizvoda
(tekstualni chatbot, glasovni voicebot) opslužuju sve interakcije, a tri
zajednička sloja ih povezuju: (1) **RAG/KB** kao jedan izvor znanja, (2)
**notification/SES** kao jedan izlazni kanal za human-handoff i potvrde, (3)
**data-platform** kao jedan merni instrument. Peta veza je **poslovna
integracija između slučajeva**: CS1 (chatbot) proizvodi leadove koje CS2 (sales
voicebot) obrađuje. Zbog ovoga je poređenje 4 slučaja metodološki legitimno —
mere se preko istog instrumenta i istog klasifikacionog okvira.

```
                 ┌─────────────────────────────────────────────────────┐
                 │              ZAJEDNIČKI IZVOR ZNANJA                  │
                 │   agentcore-kb-onboarding  →  S3 FAISS indeksi        │
                 │   indices/atlas24h-chatbot/{faq,scraped} (+ tenant)   │
                 └───────────────▲───────────────────▲──────────────────┘
                                 │ čita              │ čita
        ┌────────────────────────┴───┐      ┌────────┴─────────────────────┐
        │  CHATBOT (tekst)           │      │  VOICEBOT (glas)             │
        │  agentcore-runtime         │      │  experimental/voicebot        │
        │  CS1 Atlas  · CS4 Health   │      │  CS2 sales · CS3 CS          │
        │  (multi-tenant TENANT_ID)  │      │  (isti image, AGENT_CONFIG)  │
        └───┬───────────────┬────────┘      └────┬──────────────┬──────────┘
            │ lead/potvrda  │ export             │ lead/potvrda │ export
            ▼               │                    ▼              │
   ┌─────────────────┐      │            ┌─────────────────┐    │
   │ NOTIFICATION-   │      │            │ SES (direktan,  │    │
   │ SERVICE         │      │            │ emailSender.ts) │    │
   │ API→SQS→SES     │      │            └─────────────────┘    │
   └────────┬────────┘      │                                   │
            │ (human handoff / potvrda za sve 4)                │
            ▼               ▼                                   ▼
         ┌──────────────────────────────────────────────────────────┐
         │      DATA-PLATFORM  (jedan merni instrument, sve 4)        │
         │  conversation-export (chatbot) + session-export (voicebot) │
         │  → Bedrock Nova analiza → analysis-tracker →               │
         │    comprehensive-aggregation → atlas-reports analizatori   │
         │  → BIL API (jedinstvene metrike, poređenje 4 slučaja)      │
         └──────────────────────────────────────────────────────────┘

        Poslovna integracija između slučajeva:
        CS1 chatbot  ── (kvalifikovan lead: ime/telefon/paket/vozilo) ──▶  CS2 sales voicebot
```

---

## 1. END-TO-END TOK PO SLUČAJU

Za svaki slučaj: kako jedna interakcija (lead / konverzacija / poziv) putuje kroz
sistem, sa naznakom šta je potvrđeno u kodu, a šta na nivou case-studije/poslovnog
opisa.

### 1.1 CS1 — Atlas chatbot (tekst, inbound, prodaja)

Izvor koda: `agentcore-runtime/services/customer-agent/` (v. architecture-notes §1),
`tools/atlas24h_chatbot/{order_service.py,email_notifications.py}`.

Tok:

1. Korisnik piše u web chat → `@app.entrypoint invoke()` (AgentCore, port 8080).
2. Sesija (DynamoDB+S3, TTL 20min) → **direct handler** (brza, deterministička
   putanja za korake workflow-a) ili **pun Strands Agent** (Nova + tenant alati +
   deljeni RAG).
3. Grananje ishoda (iz CS1 case-studije, jul 2026):
   - **Kupovina u razgovoru:** `order_service.py` → Atlas/Kodit order API. To je „completed_sale"
     (potvrđeno preko produkcionog Atlas API-ja).
   - **Kvalifikovan lead (follow-up):** chatbot prikuplja ime/telefon/paket/vozilo
     → **email preko `email_notifications.py`** timu → lead ulazi u call-back red.
   - **Info/status:** rešeno u razgovoru (deflection tekstualnog kanala).
4. **Izlazni kanal (POTVRĐENO ovog puta):** `email_notifications.py` šalje preko
   **Notification Service-a** — `POST {NOTIFICATION_API_URL}/notify` sa
   `template_type` i `data`, non-blocking. → SQS FIFO → SES (v. §3.2). Telo
   sadrži i BIL link na razgovor (`{BIL_BASE_URL}/conversations/{tenant}/{env}/{session_id}`).
   > Ovo rešava TODO #4 iz architecture-notes: **chatbot ide preko
   > notification-service, NE direktno SES**. (Voicebot je suprotan — direktan SES.)
5. **Merenje:** sesija se izvozi u data-platform → `conversation_analyzer.py`
   klasifikuje `completed_sale | hot_lead | renewal | problem | info` (v. §4).

### 1.2 CS1 → CS2 — INTEGRACIJA IZMEĐU SLUČAJEVA (chatbot hrani voicebot)

Ovo je stvarna korelacija dva slučaja i **srž komparativne priče** o zajedničkom
prodajnom levku, a ne dva nezavisna proizvoda.

Izvor (case-study, doslovno, `websites/startai/.../atlas24h-sales-voicebot` +
`i18n/dictionaries/en.json`):

- Challenge: *„Atlas24h chatbot generates thousands of leads monthly. The sales
  team has limited call-back capacity. Leads that are not contacted within hours
  lose interest."*
- Solution, korak 1: **„Receives lead data from chatbot (name, phone, package
  interest, vehicle info)"**; korak 2: „Calls the lead within minutes";
  korak 3: „Presents the right package offer based on lead data"; poslednji
  korak: „Submits completed sale to Atlas order system. No human review needed."

Tok (end-to-end, spaja CS1 i CS2):

```
CS1 chatbot: lead (ime, telefon, paket, vozilo)
   → email_notifications.py → Notification Service → tim/red za pozivanje
   → [lead → outbound call lista]
   → CS2 sales voicebot poziva lead (Asterisk outbound)
   → prezentuje ponudu na osnovu lead podataka
   → workflowSubmitFields() prikupi sve → submitSalesData/startSalesWorkflow
   → Atlas order API (completed sale, bez čoveka)
```

**Granica potvrđenog (integritet):**
- POTVRĐENO: chatbot proizvodi leadove i šalje ih (email/notification-service);
  voicebot prikuplja podatke i šalje narudžbinu u Atlas order sistem
  (`workflowTools.ts` → `submitSalesData`); case-study eksplicitno kaže da
  voicebot „Receives lead data from chatbot".
- **TODO / NEPOTVRĐENO u kodu:** tačan MEHANIZAM prosleđivanja lead liste
  voicebotu (kako lista pozива stiže do Asterisk outbound dialera). U
  `experimental/voicebot` kodu NEMA modula za prijem lead liste / outbound
  dialing (grep `lead|outbound|dial|call-list` = nema orkestratora pozivanja) —
  aplikacija je vođena dolaznim SIP pozivom, pa outbound listu gura sloj IZVAN
  app koda (Asterisk / eksterna integracija). Postoji `scripts/sales-voicebot/`
  i `scripts/atlas24h_lead_extraction.py` (ekstrakcija leadova iz S3), ali to su
  reporting skripte, ne runtime handoff. **Potvrditi tačan lead→dialer put pre
  nego što se u radu tvrdi automatska veza; za sada opisati kao poslovnu
  integraciju potvrđenu case-studijom + zajednički order API.**

### 1.3 CS2 — Atlas sales voicebot (glas, outbound, prodaja)

Izvor: `experimental/voicebot/` (architecture-notes §2), `AGENT_CONFIG=chatSupervisorSalesSrb`.

Tok:

1. Outbound poziv ka lead-u (Asterisk/SIP; izvor liste = eksterno, v. §1.2 TODO).
2. Poziv preuzima `call-flow-integration` → `headless-realtime-session`
   (junior `gpt-realtime-mini` glas I/O; supervisor `gpt-4.1` rezonovanje/alati).
3. Supervisor: RAG (`atlasKnowledgeBase.ts`, Atlas KB), `atlasGetUserPackages`,
   `priceChecker`, prezentacija ponude.
4. `workflowStartIntent('sales_purchase')` → `workflowSubmitFields()` prikuplja i
   validira (ime/telefon/tablice/adresa+poštanski/JMBG ako „Moj Paket").
5. Kompletno → **narudžbina u Atlas order sistem** (case-study: „Submits completed
   sale to Atlas order system") + **SES email potvrda** (`emailSender.ts`, direktan
   SES, samo za SIP pozive) sa BIL transkript/audio linkom.
6. `session-export.ts` → Lambda `voicebot-session-export-{env}` → data-platform.
7. Merenje: `sales_voicebot_analyzer.py` (`.log` fajlovi, closing fraze +
   `startSalesWorkflow`/`submitSalesData` + `Outcome: completed`) → „143 prodaje / 6,5%".

### 1.4 CS3 — Atlas CS voicebot (glas, inbound, podrška)

Izvor: `experimental/voicebot/`, `AGENT_CONFIG=chatSupervisorSerbian`.

Tok:

1. Dolazni poziv (korisnik zove) → Asterisk → SIP server → `call-flow-integration`.
2. Junior/Supervisor kao gore; RAG isti Atlas KB (deljen sa chatbotom, §2).
3. Grananje:
   - Rešeno u pozivu (status članstva / cene / obnova) → **deflection**.
   - `ENABLED_INTENTS` van opsega ili prodajna prilika → `transferToHuman()`
     (Asterisk blind transfer na ljudskog agenta).
4. `session-export.ts` → ista Lambda → data-platform.
5. Merenje: `cc_voicebot_analyzer.py` (markeri `transferToHuman`, package check) →
   udeo rešenih bez čoveka = **deflection 49,3%**.

### 1.5 CS4 — HealthMedic chatbot (tekst, inbound, zdravstvo/zakazivanje)

Izvor: `tools/healthmedic_chatbot/` (architecture-notes §1.5).

Tok:

1. Pacijent piše u web chat → isti AgentCore runtime, `TENANT_ID=healthmedic`.
2. `doctor_lookup.py` (pretraga lekara), workflow za zahtev za termin, cene, usluge.
3. Zahtev za termin → **email preko `healthmedic_chatbot/email_notifications.py`**
   poliklinici (kao lead/handoff). **TODO:** potvrditi da i HealthMedic ide preko
   notification-service (Atlas potvrđeno; HealthMedic verovatno isti obrazac —
   otvoriti `healthmedic_chatbot/email_notifications.py` i potvrditi).
4. Merenje: chatbot analiza u data-platform (isti generički Nova sloj; da li
   postoji HealthMedic-specifičan analizator kao atlas-reports — **TODO**, za sada
   generičke metrike: broj konverzacija, udeo termina 37%, sentiment 96,8%).
5. Next phase (case-study): direktna integracija kalendara (potvrda termina u
   razgovoru) + višejezičnost — trenutno se termin PROSLEĐUJE timu, ne potvrđuje
   u razgovoru. Bitno za tačnost: CS4 danas nema „zatvaranje u kanalu" kao CS1/CS2.

---

## 2. ZAJEDNIČKI vs SPECIFIČNI SLOJEVI

### 2.1 Šta dele sva 4 slučaja (zajednički slojevi)

| Sloj | Proizvod | Kako je deljen | Dokaz |
|------|----------|----------------|-------|
| **RAG / KB** | `agentcore-kb-onboarding` | Jedan Step Functions pipeline gradi FAISS indekse u S3; svi klijenti čitaju iste `indices/{tenant}/{faq,scraped}` | architecture-notes §3.3; `rag_tools.py` + `atlasKnowledgeBase.ts` čitaju isti prefiks za Atlas |
| **Notification / SES** | `notification-service` + `emailSender.ts` | Zajednički izlazni kanal za human-handoff i potvrde u sve 4 studije | §3.2 (chatbot preko notification-service; voicebot direktan SES) |
| **Data-platform** | `ap/products/data-platform` | Jedan merni instrument: oba modaliteta izvoze konverzacije; ista Nova analiza + deljeni klasifikacioni okvir | architecture-notes §4; §3.3 ovde |
| **Session-export** | chatbot `conversation-export` + voicebot `session-export` | Dva izvora, jedan ulaz u data-platform (jedinstven „conversation" zapis) | architecture-notes §2.6, §4.5 |

### 2.2 Šta je specifično po modalitetu (runtime slojevi)

| Aspekt | CHATBOT (CS1, CS4) | VOICEBOT (CS2, CS3) |
|--------|--------------------|--------------------|
| Runtime | AWS Bedrock AgentCore + Strands (Python) | Next.js/TS + OpenAI Realtime (Docker/PM2) |
| Model | Nova (per-tenant, fallback lanac) | junior `gpt-realtime-mini` + supervisor `gpt-4.1` |
| Broj agenata | jedan agent | dva (junior/supervisor) |
| I/O sloj | tekst + strukturisani UI (dugmad, upload) | telefonija: Asterisk/SIP/RTP, G.711 μ-law, barge-in |
| Konfiguracija slučaja | `TENANT_ID` (multi-tenant kod-baza) | `AGENT_CONFIG` (isti Docker image) |
| Jedinica analize | sesija chata (TTL/idle export) | jedan poziv (`call_id`) |
| Email put | **notification-service** (SQS→SES) | **direktan SES** (`emailSender.ts`) |

Ključna poruka za rad: **ista platforma, dve ose varijacije** — modalitet
(tekst/glas) i konfiguracija (tenant/agent-config). To je ono što čini poređenje
kontrolisanim: infrastruktura znanja i merenja je ista, menja se modalitet i cilj.

---

## 3. DATA-PLATFORMA KAO ZAJEDNIČKA MERNA RAVAN (opravdanje komparacije)

### 3.1 Jedan ulaz, dva izvora

- Chatbot → `conversation-export` Lambda (idle export sesija u S3 data lake).
- Voicebot → `session-export.ts` → Lambda `voicebot-session-export-{env}` →
  `SessionExportData` (`call_outcome: completed|transferred|dropped|error`, poruke,
  trajanje, `agent_config`, metapodaci).
- Oba se slivaju u data-platform kao jedinstven „conversation" zapis.

### 3.2 Zajednički izlazni kanal (asimetrija koju treba tačno navesti)

- **Chatbot (POTVRĐENO):** `email_notifications.py` → `POST /notify`
  (Notification Service) → SQS FIFO (DLQ, 3 retrija) → SES → DynamoDB log.
- **Voicebot (POTVRĐENO ranije):** `emailSender.ts` → **direktan AWS SES**
  (realni send samo za SIP pozive; web sesije se loguju).
- Zajedničko: krajnji kanal je SES, svrha je „human handoff / potvrda". Put se
  razlikuje (kroz servis vs direktno) — navesti kao inženjersku nijansu, ne kao
  kontradikciju.

### 3.3 Jedan analitički okvir za tekst i glas (tehnički temelj komparacije)

Iz `data-platform/services/atlas-reports/` (architecture-notes §4.3):

- Generička analiza (Bedrock Nova structured output): sentiment / topics /
  quality / resolution — **identična za oba modaliteta**.
- Atlas analizatori **DELE kod**: `cc_voicebot_analyzer.py` i
  `sales_voicebot_analyzer.py` importuju `COMPLETION_MARKERS`, `PACKAGE_PRICES`,
  `PROBLEM_MARKERS`, `ConversationResult` iz `conversation_analyzer.py` (chatbot).
  → isti klasifikacioni okvir (`completed_sale | hot_lead | renewal | problem |
  info`) primenjen i na tekst i na glas, ista revenue logika (isti cenovnik).
- **Zaključak (metodologija):** pošto se sve 4 studije mere kroz JEDAN instrument
  sa DELJENIM klasifikatorom, „automation/resolution rate" je izračunat na isti
  način bez obzira na modalitet → poređenje je metodološki branjivo uprkos
  površinski neuporedivim primarnim metrikama.

### 3.4 Ograničenja mernog instrumenta (za pošteno navođenje)

- `message_count = 0` bug (#310, mart 2026) — **TODO:** potvrditi da li je rešen
  pre mernog perioda (maj–avg 2026); ako nije, navesti kao ograničenje pouzdanosti.
- Konflikt interesa: autor je implementator; produkcioni podaci bez kontrolne
  grupe (v. research-notes). Merni instrument transparentno opisan → brojke su
  proverljiv inženjerski artefakt, ali ne zamenjuju nezavisnu reviziju.

---

## 4. VEZA SA ZAJEDNIČKIM ANALITIČKIM OKVIROM (automation rate)

Iz research-notes, ključni metodološki problem: metrike nisu direktno uporedive
(konverzija 61,4% ≠ deflection 49,3% ≠ 143 prodaje ≠ 751 termin). Rešenje:
**„automation rate" (udeo interakcija rešenih bez čoveka) kao zajednička osa +
domenske sekundarne metrike.**

Kako deljena data-platforma ovo OMOGUĆAVA (a ne samo predlaže):

- Deljeni klasifikator (§3.3) svaku interakciju u sva 4 slučaja svrsta u
  „rešeno bez čoveka" vs „prosleđeno čoveku / nezavršeno" na isti način:
  - CS1: `completed_sale` + `info` rešeni u chatu → automatizovano; `hot_lead`
    (follow-up) → delimično (traži čoveka/voicebot).
  - CS2: `Outcome: completed` bez čoveka u zatvaranju → automatizovano (case-study:
    „No human review needed").
  - CS3: rešeno u pozivu vs `transferToHuman` → direktno daje deflection = automation.
  - CS4: rešeno u chatu vs zahtev za termin prosleđen timu → automation vs handoff.
- Sekundarne (domenske) metrike ostaju uz zajedničku osu: konverzija/prihod (CS1,
  CS2, prodaja), deflection/ušteda (CS3, podrška), udeo termina/sentiment (CS4,
  zdravstvo).

Predlog jedinstvene tabele za rad (osa + sekundarne):

| Slučaj | Automation rate (zajednička osa) | Sekundarna (domenska) | Handoff signal |
|--------|----------------------------------|-----------------------|----------------|
| CS1 chatbot | udeo rešeno/kupljeno u chatu | konverzija 61,4%, prihod | email lead → tim/voicebot |
| CS2 sales voicebot | udeo `completed` bez čoveka | 143 prodaje, 6,5% | (autonomno; SOS→transfer) |
| CS3 CS voicebot | deflection 49,3% | ušteda €200K+, obim +52% | `transferToHuman` |
| CS4 healthcare | udeo rešeno u chatu | 751 termin (37%), sentiment 96,8% | email termin → poliklinika |

> **TODO (za pisca):** tačan brojilac/imenilac „automation rate" po slučaju
> definisati iz data-platform metrika (BIL) — ovde je okvir, ne konačne cifre.
> Za CS1/CS4 „automation" se izvodi iz klasifikatora; za CS2/CS3 iz
> `call_outcome`/transfer markera. Uskladiti definiciju „interakcije" (sesija vs
> poziv) — v. architecture-notes §4.5.

---

## 5. PREDLOG DIJAGRAMA ZA RAD

Autor / ls-git prave stvarne dijagrame kasnije; ovde je specifikacija sadržaja.
Postoje gotovi PlantUML/SVG u `experimental/voicebot/docs/diagrams/` (adaptirati,
OBAVEZNO ukloniti IP-jeve/hostove).

### Dijagram A — Sistemski dijagram cele platforme (OBAVEZAN, glavni)

Tip: komponentni/blok dijagram (C4 „container" nivo).
Sadržaj:
- Dva runtime bloka: **Chatbot** (AgentCore+Strands, multi-tenant) i **Voicebot**
  (Next.js+OpenAI Realtime, Asterisk/SIP/RTP), sa oznakom koja 2 slučaja svaki nosi
  (CS1/CS4 vs CS2/CS3).
- Tri deljena sloja povezana na oba runtime-a: **RAG/KB** (jedan izvor, strelice
  „čita"), **Notification/SES**, **Data-platform**.
- Poslovna strelica **CS1 → CS2** („lead: ime/telefon/paket/vozilo").
- Strelice izvoza: chatbot `conversation-export` i voicebot `session-export` →
  data-platform → BIL API.
- Legenda: puna linija = potvrđeno u kodu; isprekidana = poslovna integracija
  (CS1→CS2 dialer put, TODO).
- BEZ ARN/IP/bucket imena — samo nazivi komponenti.

### Dijagram B — Sekvencni dijagram end-to-end (OBAVEZAN za CS1→CS2)

Tip: UML sequence.
Akteri/učesnici: Korisnik → Chatbot (invoke) → order API / Notification Service →
[lead red] → Sales Voicebot (Asterisk poziv) → Junior/Supervisor → Atlas order
API → SES potvrda → Data-platform.
Cilj: vizuelno pokazati da je prodajni levak jedan tok kroz dva modaliteta.
Napomena: korak „lead red → voicebot dialer" označiti kao isprekidan/TODO dok se
mehanizam ne potvrdi.

### Dijagram C — (opciono) Komparativni „automation rate" okvir

Tip: shema/matrica 2×2 (modalitet × cilj) ili tabela iz §4 kao figura.
Cilj: metodološki prikaz zajedničke ose + domenskih sekundarnih metrika.

### Dijagram D — (opciono) Voicebot glasovni cevovod

Tip: sekvenca/komponentni. Sadržaj: Asterisk/SIP → RTP (G.711) → WebSocket →
junior (realtime) → supervisor (gpt-4.1) → alati/RAG. Adaptirati iz
`docs/diagrams/` voicebota (ukloniti IP-jeve). Podupire sekciju arhitekture i
kontrast modaliteta.

---

## 6. NOVO POTVRĐENO u ovoj fazi (ažuriranje TODO liste iz architecture-notes)

- ✅ **Chatbot email put (architecture-notes TODO #4):** Atlas chatbot šalje preko
  **Notification Service-a** (`POST {NOTIFICATION_API_URL}/notify`,
  `template_type`+`data`, non-blocking), ne direktno SES. Voicebot ostaje direktan
  SES. (Izvor: `atlas24h_chatbot/email_notifications.py`, funkcija `_notify`.)
- ✅ **CS1→CS2 lead integracija:** potvrđena na nivou case-studije doslovno
  („Receives lead data from chatbot (name, phone, package interest, vehicle
  info)") + zajednički Atlas order API kao tačka zatvaranja.

## 7. Preostali TODO (integritet — ne izmišljati)

1. **CS1→CS2 mehanizam handoff-a:** kako lead lista stiže do voicebot outbound
   dialera (nema u app kodu; verovatno Asterisk/eksterni sloj). Potvrditi pre nego
   što se tvrdi automatska runtime veza; do tada opisati kao poslovnu integraciju.
2. **HealthMedic email put (CS4):** potvrditi da `healthmedic_chatbot/
   email_notifications.py` ide preko notification-service (kao Atlas).
3. **HealthMedic analiza u data-platform:** ima li tenant-specifičan analizator
   (kao atlas-reports) ili samo generičke Nova metrike — utiče na to koliko se CS4
   uklapa u „automation rate" osu.
4. **`message_count=0` bug (#310):** rešen pre maj–avg 2026? (pouzdanost metrika).
5. **conversation-export Lambda (chatbot):** tačan izvorni fajl u agentcore-runtime
   (parametri idle>10min) — nasleđeno.
6. **Automation rate cifre:** definisati brojilac/imenilac po slučaju iz BIL-a.

## 8. Bezbednosna napomena

U rad NE unositi: ARN-ove, API ključeve, imena S3 bucketa (naišao u
`atlas24h_lead_extraction.py`), AWS account ID-jeve, Asterisk IP/portove,
imejl-adrese primalaca, secret imena. Sve opisati na nivou komponenti
(„Notification Service preko SQS/SES", „SIP/RTP ka Asterisk PBX-u", „konfiguracija
preko Secrets Manager-a"). Ovaj dokument se toga drži.
