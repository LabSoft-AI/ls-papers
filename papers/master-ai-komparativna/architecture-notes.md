# Arhitektura sistema — beleške za master rad (komparativna analiza 4 AI implementacije)

> Autor: Luka Vidaković. Radni dokument (ne ulazi u build).
>
> Sve dole je iz STVARNOG koda, README-a i docs-a u
> `~/github/work/world/` (repo `world`), pregledano 2026-09-20. Ništa nije
> izmišljeno; gde nešto nije potvrđeno u kodu stoji **TODO**. Svaka komponenta
> ima naveden izvor (putanja u `world` repou).
>
> **BEZBEDNOST:** Namerno NE navodim ARN-ove, API ključeve, IP adrese
> (npr. Asterisk IP iz `ATLAS_VOICEBOT.md`), imena S3 bucketa, konkretne
> imejl-adrese primalaca ni SOS/telefon brojeve. Opis je na nivou komponenti i
> odnosa među njima. Konkretne vrednosti stoje u kodu — u rad idu samo kao
> „konfigurabilno preko Secrets Manager-a / env promenljivih".
>
> **ODNOS SA #15 (`papers/future-bme-startai/architecture-notes.md`):** onaj
> dokument opisuje SAMO chatbot (jedan slučaj, sažeto) + data-platform/notif.
> Ovaj dokument NADOGRAĐUJE: (a) dubinski chatbot (direct handler, model
> factory sa fallback lancem, hooks, strukturisani izlaz, session slojevi),
> (b) KOMPLETAN voicebot (telefonija, junior/supervisor, workflow framework,
> RAG), (c) dokaz da chatbot i voicebot DELE isti FAISS KB izvor, (d)
> data-platform kao jedinstven merni instrument za sve 4 studije, (e)
> notification-service. Ne ponavljam ono što je već u #15 osim kad produbljujem.

---

## 0. Mapa komponenti i kako se slažu u 4 studije slučaja

Četiri case studije koriste dva „runtime" proizvoda (chatbot i voicebot) i tri
zajednička sloja (RAG/KB, data-platform, notification).

| Sloj | Proizvod (izvor u `world`) | CS1 chat prodaja | CS2 sales voicebot | CS3 CS voicebot | CS4 healthcare chat |
|------|-----------------------------|:---:|:---:|:---:|:---:|
| Runtime (tekst) | `ap/products/agentcore-runtime/services/customer-agent` | ✅ (`atlas24h_chatbot`) | — | — | ✅ (`healthmedic_chatbot`) |
| Runtime (glas) | `experimental/voicebot` | — | ✅ (`chatSupervisorSalesSrb`) | ✅ (`chatSupervisorSerbian`) | — |
| RAG / KB | `ap/products/agentcore-kb-onboarding` | ✅ | (✅) | ✅ | ✅ |
| Merni instrument | `ap/products/data-platform` | ✅ | ✅ | ✅ | ✅ |
| Notifikacije | `ap/products/notification-service` + workflow SES | ✅ | ✅ | ✅ | ✅ |

Napomena: chatbot je **multi-tenant** (Atlas i HealthMedic su dva tenanta iste
kod-baze); voicebot je **konfiguracija agenata** (isti Docker image, različit
`AGENT_CONFIG` za sales vs CS). Ovo je ključna tačka za komparaciju: ista
platforma, različit modalitet i cilj.

---

## 1. CHATBOT — `agentcore-runtime` / `customer-agent`

Izvor: `ap/products/agentcore-runtime/services/customer-agent/`
(README.md, docs/API.md, docs/session-management.md, agent.py, model_factory.py,
hooks/, tools/atlas24h_chatbot/, tools/healthmedic_chatbot/, tools/rag_tools.py)

### 1.1 Osnova: AgentCore + Strands, multi-tenant

- Kontejner tipa **AWS Bedrock AgentCore** (`BedrockAgentCoreApp`), port 8080,
  jedna RPC ulazna tačka `@app.entrypoint` (`docs/API.md`).
- Orkestracija agenta preko **Strands Agents SDK** (Python): dekoratori alata
  (`@tool`), hooks, session menadžment.
- **Multi-tenant preko `TENANT_ID`** — sve se rezolvuje dinamički (README,
  „Multi-Tenancy"):

  | Komponenta | Rezolucija |
  |-----------|------------|
  | Alati | `tools/{tenant_id}/` (npr. `atlas24h_chatbot`, `healthmedic_chatbot`) |
  | Session manager | `session/{tenant_id}_session_manager.py` → `SessionManager`, fallback `TenantSessionManager` |
  | Direct handler | `tools/{tenant_id}/direct_handler.py` → `try_handle_direct(...)` |
  | System prompt | S3 config po tenantu (`{tenant_id}/config.json`), interpolacija `{current_time}`, `{workflow_context}`, `{context}` |

  Za rad je bitno: **CS1 (Atlas) i CS4 (HealthMedic) su ISTA kod-baza**, samo
  drugi `TENANT_ID` — to je jak argument za „ista platforma, drugi domen".

### 1.2 Tok `invoke()` — direct handler vs pun agent

Iz README „How It Works" + `docs/API.md`:

1. Payload: `prompt` (ili alias `message`), `session_id` (opciono), `browser_data`,
   `attachments`.
2. Sesija se kreira/čita preko tenant session managera (DynamoDB-backed).
3. **Direct handler (brza putanja)** — pokušava se PRVI. Čita `agent_state` i
   rukuje strukturisanim koracima workflow-a **bez instanciranja punog LLM
   agenta** (jeftino, deterministički). Ako ne matchuje →
4. **Pun Strands Agent** sa: tenant system prompt (iz S3), tenant alati + deljeni
   RAG alat, hooks, opcioni strukturisani izlaz.
5. Odgovor se snima u sesiju; vraća `result`, `session_id`, `timestamp`, opciono
   `structured_data` i `request_documents`.

> Merno-metodološki važno (za validnost brojki u radu): deo interakcija (npr.
> koraci prikupljanja podataka u prodajnom toku) NE prolazi kroz LLM nego kroz
> direct handler — pa „broj poziva modela" ≠ „broj poruka".

### 1.3 Model (Nova) i model factory sa fallback lancem

Izvor: `model_factory.py`, README „Environment Variables".

- **Default model:** README/`API.md` navode `eu.amazon.nova-pro-v1:0`, ALI
  `model_factory.py` ima `DEFAULT_MODEL_ID = "global.amazon.nova-2-lite-v1:0"`.
  → **Nekonzistentnost u izvorima.** Stварni model je per-tenant iz S3 configa
  (`model` polje).  **TODO:** potvrditi tačan model koji je Atlas sales chatbot
  koristio maj–jul 2026 iz Atlas S3 config-a (nasleđeni TODO iz #15). Ne upisivati
  „nova-pro" kao sigurno dok se ne potvrdi.
- **Multi-provider factory:** `model` u tenant configu može biti:
  - string → `BedrockModel` (bez fallback-a), ili
  - dict `{"primary": {...}, "fallback": [...]}` → primarni + lanac rezervi.
  - Provajderi: `bedrock`, `bedrock_invoke` (Qwen preko Bedrock), `openai`,
    `openai_compatible` (npr. DeepSeek). OpenAI ključ iz Secrets Manager-a.
  - Podrška za Bedrock **prompt caching** (samo Claude modeli; za druge se
    ignoriše uz upozorenje).
  - `create_models()` pokušava primarni, pa rezerve — ako primarni padne, agent
    i dalje služi zahteve preko fallback modela.
- Za rad: bitna poruka je da je izbor modela **konfiguracija, ne hard-kod** —
  arhitektura je model-agnostična sa Nova kao podrazumevanim Bedrock izborom.

### 1.4 Alati Atlas tenanta (`tools/atlas24h_chatbot/`)

Datoteke: `atlas_tools.py`, `tools.py` (60KB), `direct_handler.py` (64KB),
`package_service.py`, `order_service.py`, `workflows.py`, `policy_tools.py`,
`email_notifications.py`.

- `atlas_tools.py`:
  - `lookup_user_packages(user_phone, licence_plate)` — provera statusa paketa;
    **zahteva telefon I tablice** (privatnost), unakrsna provera da telefon i
    tablice pripadaju istom korisniku; NIKAD ne vraća ime/imejl/adresu agentu
    (privacy pravila u `atlas24h_chatbot/README.md`).
  - `lookup_user_packages_by_jmbg(user_phone, jmbg)` — za „Moj Paket" korisnike
    bez vozila (telefon + JMBG, 13 cifara).
  - `check_package_prices()` — cene sa API-ja, fallback na HTML scraping sajta;
    striktno pravilo „nikad ne odgovaraj o cenama bez poziva ovog alata"
    (anti-halucinacija cena).
  - Normalizacija telefona (RS format) i tablica; validacija preko `phonenumbers`.
- `order_service.py` — kreiranje narudžbine preko Atlas/Kodit API-ja: mapiranje paketa (ShortName↔UUID),
  tipa vozila, načina plaćanja (kartica/uplatnica), promo koda, platforme
  (web/mobile). Ovo je „kupovina u razgovoru" iz CS1.
- Cene paketa (RSD) su u kodu (Internacionalni+ 10.990, Nacionalni 4.990,
  Guma 3.490, Moj 5.490, …) — isti cenovnik koristi i data-platform analizator.

### 1.5 Alati HealthMedic tenanta (CS4) — kontrast domena

Izvor: `tools/healthmedic_chatbot/` (tools.py, workflows.py, doctor_lookup.py,
email_notifications.py).

- Postoji poseban tenant za polikliniku: `doctor_lookup.py` (pretraga lekara),
  workflow za zakazivanje/termine, imejl notifikacije.
- Potvrđuje CS4 kao istu platformu (AgentCore+Strands) u drugom domenu
  (zdravstvo, zakazivanje) — direktna paralela chatbotu za prodaju.
- **TODO:** detaljno pročitati `healthmedic_chatbot/tools.py` i `workflows.py`
  ako rad traži dubinski opis toka zakazivanja (za sada potvrđeno da postoji i
  koje datoteke ga čine).

### 1.6 Session management (slojevi)

Izvor: `docs/session-management.md`, `session/`.

- Protokol `SessionManagerProtocol` (create/register/get/add_message/
  get_conversation_context/build_context_string/mark_session_completed).
- Backendi:
  - `LocalFileSessionManager` — JSON na disku (lokalni razvoj, bez AWS).
  - `TenantSessionManager` — **DynamoDB + S3** (default). Sesije/poruke u
    zasebnim DynamoDB tabelama po tenantu, GSI po timestamp-u; **TTL sesije 20
    min** (produžava se na svaku poruku), **TTL poruke 7 dana**. Alias
    `AnonymousSessionManager`.
  - `BaseSessionManager` — dodaje ekstrakciju profila korisnika.
  - `IvanicSessionManager` — primer tenant-override (hvatanje parametara alata).
- Za rad bitno: definicija „sesije/konverzacije" u chatbotu je tehnički vezana za
  DynamoDB sesiju + TTL — treba je uskladiti sa data-platform definicijom
  konverzacije (v. §4).

### 1.7 Hooks (Strands)

Izvor: `hooks/`.

- `tool_limit_hook.py` — `ToolLimitHook(max_calls)`; broji pozive alata i baca
  grešku kad se pređe `MAX_TOOL_CALLS` (default 5). Sprečava beskonačne petlje /
  troškove.
- `tool_capture_hook.py` — `ToolParameterCaptureHook`; hvata parametre poziva
  alata i ažurira profil korisnika u session manageru (ako podržava capture).
- `direct_response_hook.py` — `DirectResponseHook`; presreće rezultat alata sa
  `direct_response: True` i hvata poruku + `structured_data` + `request_documents`
  → izlaz ide korisniku bez dodatnog LLM rezonovanja. (Komentar u kodu: NE
  zaustavlja Strands event-loop — raniji pokušaj `stop_event_loop` iz #1766 je
  vraćen jer je lomio sekvencijalne pozive alata, #1797.)
- Dodatno prisutni: `grammar_correction_hook.py`, `prompt_reduction_hook.py`,
  `enforce_list_models_hook.py` (specifično za Ivanic/list_models tok).

### 1.8 Strukturisani izlaz (bogate UI komponente)

Izvor: `docs/API.md`, README „Structured Output".

- Kad je `structured_output_enabled` u tenant configu: agent vraća `structured_data`
  tipa `confirmation | choice | rating | date | time | datetime`, plus
  `request_documents` (`DocumentUploadSpecs`).
- Konvencija strukturisanog ULAZA: klijent vraća `STRUCTURED:<value>:<label>`
  (agent skida prefiks).
- Za rad: ovo je razlika modaliteta — chatbot ima UI afordanse (dugmad, izbor,
  upload dokumenata) kojih voicebot (glas) nema; deo „komparacije modaliteta".

### 1.9 RAG alat u chatbotu (isti KB izvor kao voicebot — v. §3)

Izvor: `tools/rag_tools.py`.

- `query_knowledge_base(upit)` — deljeni Strands alat.
- Učitava **dva FAISS indeksa iz S3**: `indices/{TENANT_ID}/faq` i
  `indices/{TENANT_ID}/scraped` (iz `CONFIG_BUCKET`), OpenAI embeddings
  (ključ iz Secrets Manager).
- Hibridno pretraživanje: prvo FAQ (viši prioritet/trust), pa scraped; FAQ
  odgovori imaju prednost nad scraped sadržajem.
- **Sanitizacija protiv prompt-injection**: regex uklanja pokušaje override-a
  instrukcija (EN i SR varijante, ChatML/Llama role tokene, HTML/script) iz
  preuzetog sadržaja pre nego što uđe u kontekst modela.
- Integritet: verifikacija SHA-256 checksum-a indeksa pri preuzimanju iz S3.

---

## 2. VOICEBOT — `experimental/voicebot` (+ `ap/products/voicebot`)

Izvor: `experimental/voicebot/` (README.md, src/README.md, src/config/models.ts,
src/call-center/*, src/app/agentConfigs/*, src/lib/*, docs/*),
`ap/products/voicebot/services/session-export/handler.py`.

Stack: **Next.js 15 / React 19 / TypeScript**, `@openai/agents` (Realtime API +
Agents SDK), Node `ws`/`net`/`dgram`. Deploy kao Docker + PM2. Isti Docker image
za CS i sales voicebot (razlika je `AGENT_CONFIG`).

### 2.1 Telefonija: Asterisk / SIP / RTP

Izvor: `src/call-center/`, `src/README.md`, `docs/ASTERISK_INTEGRATION_GUIDE.md`.

- **SIP server** (`sip-server.ts`) — Asterisk integracija; **UDP primarno**,
  **TCP fallback**. Rukuje kompletnim SIP životnim ciklusom
  (OPTIONS → INVITE → 100 Trying → 180 Ringing → 200 OK + SDP → ACK → BYE),
  RFC 3261. (Konkretan Asterisk IP i port stoje u kodu/docs — NE upisujem.)
- **SIP client** (`sip-client.ts`) — obrada dolaznih poziva, praćenje stanja,
  most ka WebSocket audio toku.
- **RTP audio handler** (`rtp-audio-handler.ts`) — konverzija između RTP paketa i
  PCM16; **G.711 μ-law** enkod/dekod; dvosmerni tok (SIP ↔ WebSocket); RTP portovi
  u opsegu (u kodu). Barge-in podržan (korisnik prekida AI usred rečenice —
  čisti audio red).
- **WebSocket audio server** (`websocket-server.ts`, port 8081) — realtime PCM16
  streaming, upravljanje više paralelnih sesija.
- **Call-flow-integration** (`call-flow-integration.ts`) — glavni orkestrator:
  koordinira SIP klijent, WebSocket server, RTP handler; EventEmitter „ready"
  obrazac za startovanje servisa.
- `openai-audio-processor.ts` — alternativni put obrade audija preko WebSocket
  transporta; obrada audio delta i transkripcije.

Za rad: ovo je celokupna razlika u odnosu na chatbot — telefonski I/O sloj
(PBX/SIP/RTP/kodek/latencija) koji tekstualni chatbot nema. Postoje i gotovi
PlantUML/SVG dijagrami u `docs/diagrams/` (npr. `asterisk-system-architecture`,
`container-diagram`, `data-flow`, `typescript-execution-flow`) — kandidati za
figure u radu (adaptirati, ne kopirati bukvalno; ukloniti IP-jeve).

### 2.2 Junior / Supervisor obrazac (dva agenta)

Izvor: `src/config/models.ts`, `src/app/agentConfigs/chatSupervisorSerbian/`
(index.ts = junior, supervisorAgent.ts = supervisor).

- **Modeli (centralno, `src/config/models.ts`):**
  ```
  realtime:    'gpt-realtime-mini'      // junior — glas I/O (STT+TTS, niska latencija)
  transcribe:  'gpt-4o-mini-transcribe' // transkripcija
  supervisor:  'gpt-4.1'                // rezonovanje + pozivi alata
  guardrails:  'gpt-4o-mini'            // izlazni guardrails
  ```
  > **NAPOMENA / ISPRAVKA prethodne beleške (#16 research-notes):** kod NAVODI
  > `gpt-realtime-mini` (ne „gpt-4o-realtime"). README u proznom delu pominje
  > „gpt-4o-realtime" i „realtime-mini". U rad upisati vrednosti iz
  > `models.ts` kao merodavne (`gpt-realtime-mini`, `gpt-4.1`), uz napomenu da
  > je izbor modela centralizovan/promenljiv. Supervisor = `gpt-4.1` potvrđeno.
- **Junior agent** (`chatAgent`, `RealtimeAgent`, glas „sage"): vodi prirodan
  glasovni razgovor, ali je namerno „ograničen" — za skoro sve pozива
  `getNextResponseFromSupervisor`. Instrukcije eksplicitno zabranjuju da junior
  izgovori reč „supervisor"/„alat"/„sistem" ili da sam ponavlja cifre/kodove
  (glasovni model nije pouzdan za cifre) — umesto toga prosleđuje supervizoru
  koji vraća formatiranu potvrdu.
- **Supervisor agent** (`supervisorAgent.ts`, `gpt-4.1`): ima ceo transkript,
  poziva alate, vraća „doslovni" odgovor koji junior čita. Sadrži poslovna
  pravila (SOS eskalacija na ljudskog agenta ODMAH, kada koristiti koji alat,
  potvrda identifikatora, zabrana izmišljanja podataka za uplatu, itd.).
- Varijante scenarija (`src/app/agentConfigs/`): `chatSupervisorSerbian` (CS3,
  korisnička podrška), `chatSupervisorSalesSrb` (CS2, prodaja — mimikuje obrasce
  Atlas prodajnog tima iz analize ~2.716 uspešnih transkripata, v.
  `docs/SALES_PATTERNS_ANALYSIS.md`), `chatSupervisorBosnian` (bosanska
  varijanta), plus demo `chatSupervisor` i `customerServiceRetail`.
- `guardrails.ts` + `endCallTool.ts` po scenariju (izlazni moderation, završetak
  poziva).

### 2.3 Alati (supervisorov set)

Izvor: `src/lib/tools/` (atlasTools.ts, workflowTools.ts, policyTools.ts,
priceChecker.ts), `src/lib/api/` (atlasApiClient, packageService).

- **`atlasTools.ts`:**
  - `atlasGetUserPackages(params)` — provera paketa preko realnog Atlas API-ja
    (telefon fuzzy / broj ugovora / tablice exact); keš paketa; mock fallback
    (`ATLAS_MOCK_MODE`); vraća samo aktivne pakete + datum + iskorišćene
    asistencije, bez ličnih podataka. Prefiks „[OBAVEZNO PROČITAJ DOSLOVNO]"
    tera junior-a da pročita rezultat tačno.
  - `atlasGetContractInfo(packageId, phone)` — PDF ugovora.
  - `atlasGetCallerName(phone)` — ime za personalizaciju (preskače test podatke).
  - `transferToHuman()` — blind transfer ka ljudskom agentu (Asterisk ekstenzija).
- **`policyTools.ts`** — `getAtlasPackagePolicy(...)` (pokriće/teritorija paketa).
- **`priceChecker.ts`** — provera cena.
- **`workflowTools.ts`** — v. §2.4.

### 2.4 Workflow framework (intents, validators, SES email)

Izvor: `src/lib/workflows/` (config.ts, validators.ts, emailSender.ts,
workflowState.ts, index.ts) + `src/lib/tools/workflowTools.ts`.

- **Intenti** (`config.ts`, `ENABLED_INTENTS`): voicebot autonomno rukuje samo:
  `purchase_new`, `renew_extend`, `sales_purchase`, `sales_renewal`.
  Svi ostali intenti (prenos paketa, promena tablica, reaktivacija, promena
  adrese, prijava problema) → **transfer na ljudskog agenta** (nisu „enabled").
- **Required fields po intentu** (`BASE_FIELDS`): npr. `sales_purchase` traži
  `package_selection, full_name, phone, vehicle_brand, vehicle_plates, address`;
  `renew_extend` samo `package_selection`. Dinamičko polje: `jmbg` se dodaje kad
  je paket „Moj Paket".
- **Tok** (`workflowTools.ts`): `workflowStartIntent()` postavlja intent, prefill
  iz caller podataka, vraća prvo polje; `workflowSubmitFields()` validira, čuva,
  vraća sledeće polje ili — kad je kompletno — **šalje imejl i vraća
  zatvaranje**. Prihvaćeni identifikatori traže glasovnu potvrdu
  (`needsVoiceConfirm`), a supervisor vodi potvrdu preko juniora.
- **Validatori** (`validators.ts`): telefon (`isValidSerbianPhone`), email (uz
  `normalizeEmail` — transliteracija ćirilice u latinicu, zamena glasovnih
  artefakata „tačka"→`.`, „et/majmun"→`@`), tablice (4–12 znakova), **JMBG (13
  cifara)**, godište, način plaćanja, adresa (mora sadržati poštanski broj — 5
  cifara). Ovo je „intent + slot filling" (veza sa literaturom: task-oriented
  dialogue, budzianowski2018multiwoz iz research-notes).
- **Email sender** (`emailSender.ts`): formatira prikupljene podatke + link na
  BIL transkript + audio snimak + call log; šalje preko **AWS SES**. Realni
  imejl se šalje SAMO za SIP pozive (`callId` postavljen); web sesije se samo
  loguju. Rutiranje primalaca zavisi od env-a i tipa (kvalifikovani lead-ovi vs
  izmene ugovora vs interni). Konkretne adrese su u kodu — **NE upisivati u rad**.

### 2.5 RAG u voicebotu (`atlasKnowledgeBase.ts`) — deli KB sa chatbotom

Izvor: `src/lib/rag/atlasKnowledgeBase.ts`.

- `queryKnowledgeBase(query)` — server-only modul; učitava FAISS iz S3:
  **`indices/atlas24h-chatbot/faq` i `indices/atlas24h-chatbot/scraped`**
  (`TENANT_ID = 'atlas24h-chatbot'` je hard-kodiran u modulu), OpenAI embeddings
  (ključ `OPENAI_API_KEY_VOICEBOT` iz Secrets Manager).
- Hibridno: FAQ prvo (visok prag pouzdanosti > 0.95 → direktan odgovor), pa
  scraped; glasovno-optimizovano (kratki odgovori, proza, bez lista).
- **KLJUČNO za §3:** voicebot čita **isti S3 index prefiks** (`atlas24h-chatbot`)
  koji gradi `agentcore-kb-onboarding` i koji chatbot čita preko
  `indices/{TENANT_ID}/…`. Dakle CS voicebot i Atlas chatbot dele isti KB izvor.

### 2.6 Sesija bez UI + izvoz sesije

Izvor: `src/call-center/headless-realtime-session.ts`, `session-export.ts`,
`session-recording-email.ts`; `ap/products/voicebot/services/session-export/handler.py`.

- `headless-realtime-session.ts` — OpenAI Realtime sesija bez UI (za telefon):
  fetch ephemeralnog ključa, autentikacija, audio streaming + transkripcija,
  Chat-Supervisor obrazac.
- `session-export.ts` — po završetku poziva asinhrono (Event invoke) poziva
  Lambda `voicebot-session-export-{env}` sa `SessionExportData` (call_id,
  caller_number, start/end, duration_seconds, language, agent_config,
  `call_outcome: completed|transferred|dropped|error`, messages, audio_url,
  bil_transcript_url, metadata: sip_call_id, audio_chunks_processed,
  barge_in_count). **CS i sales voicebot koriste ISTU Lambdu**; razlika po
  `TENANT_ID` u payload-u.
- `ap/products/voicebot/services/session-export/handler.py` — Lambda koja upisuje
  sesiju u Data Platform (ulaz za §4).

### 2.7 Deploy workflow-ovi (CI/CD)

Izvor: README + `experimental/voicebot/{voicebot.yaml, sales-voicebot.yaml}`
(CloudFormation) + `.github/workflows/`.

- CS voicebot: `voicebot.yaml`, deploy `voicebot-{development,staging,production}-deploy`.
- Sales voicebot: zaseban EC2 (`sales-voicebot.yaml`), isti Docker image, env
  `AGENT_CONFIG=chatSupervisorSalesSrb`, deploy
  `sales-voicebot-{...}-production-deploy`.
- Session export: `voicebot-session-export-production-deploy` (Lambda iz §2.6).
- **TODO:** tačna imena workflow YAML-ova u `.github/workflows/` nisam otvarao
  fajl-po-fajl (README ih parafrazira); potvrditi tačne nazive ako se citiraju.

---

## 3. ZAJEDNIČKI RAG / KNOWLEDGE BASE — `agentcore-kb-onboarding`

Izvor: `ap/products/agentcore-kb-onboarding/README.md` (+ services/).

### 3.1 Šta radi

Automatski KB pipeline (Step Functions), po tenantu:

1. **DiscoverURLs** (kb-scraper Lambda, discovery) — nabraja URL-ove sajta tenanta.
2. **ParallelScraping** (Map, do 5 paralelnih Lambdi, batch 350) — Playwright
   scraping; **SHA-256 hash po strani → preskače nepromenjeno**.
3. **ProcessFaqImprovements** (faq-improvements Lambda) — iz „dislike" feedback-a
   korisnika LLM odlučuje: ažuriraj/kreiraj/preskoči FAQ.
4. **BuildFAISSIndices** (faiss-embedder Lambda): detekcija brisanja; **price
   detection** (regex pre-filter → GPT-4o-mini structured output →
   auto-update cena u `faq_runtime.json` ili flag „needs_review"); inkrementalni
   FAQ indeks (LangChain `index()` + **DynamoDB RecordManager**); inkrementalni
   scraped indeks (samo izmenjene strane); izveštaj u S3.
5. **SendNotification** (SNS) — email sa statistikom.

### 3.2 FAQ base/runtime split + RecordManager

- `faq.json` (base, iz Gita, nikad se ne menja u runtime-u) + `faq_runtime.json`
  (runtime override-i: cene, feedback poboljšanja). Pri indeksiranju se spajaju
  (runtime gazi base po normalizovanom pitanju; nove runtime FAQ se dodaju).
- **DynamoDB RecordManager** prati indeksirane dokumente za inkrementalne
  update-ove; poseban `faq_hash#{tenant}` zapis (SHA-256 spojenog FAQ) da
  preskoči re-indeksiranje kad je nepromenjeno.
- REST API (API Gateway, `X-Api-Key`): update / rebuild / fresh-build /
  faq-rebuild / status / FAQ CRUD.

### 3.3 S3 layout i deljenje KB-a (odgovor na pitanje „dele li isti izvor")

```
tenants/{tenant_id}/  ← agentcore_config.json, faq.json, faq_runtime.json, scraped_data/*.md, kb_state/reports/…
indices/{tenant_id}/faq/       ← index.faiss, index.pkl, docstore.json
indices/{tenant_id}/scraped/   ← index.faiss, index.pkl, docstore.json
```

- Pipeline generiše i `docstore.json` **baš zbog TypeScript (voicebot)
  kompatibilnosti** (Python pickle nije kompatibilan sa Node FAISS). To je jasan
  trag da su isti indeksi namenjeni i Python chatbotu i TS voicebotu.
- **Chatbot** (`rag_tools.py`) čita `indices/{TENANT_ID}/{faq,scraped}` iz
  `CONFIG_BUCKET`.
- **Voicebot** (`atlasKnowledgeBase.ts`) čita `indices/atlas24h-chatbot/{faq,scraped}`.
- **ZAKLJUČAK:** za Atlas tenant (`atlas24h-chatbot`) chatbot i (CS) voicebot
  **dele isti FAISS KB izvor** — isti S3 prefiks, isti pipeline ga gradi.
  Chatbot dodatno koristi Python `.pkl`, voicebot rekonstruiše store iz
  `docstore.json`. → Jedan izvor istine za znanje, dva klijenta.
- **Nijansa (za tačnost u radu):** voicebot je hard-kodiran na `atlas24h-chatbot`
  KB, dok je chatbot generički po `TENANT_ID`. Sales voicebot koristi isti KB
  modul (Atlas), pa i on deli taj izvor. HealthMedic (CS4) ima svoj tenant KB
  (`indices/{healthmedic-tenant}`) koji koristi samo chatbot (nema voicebot).
  **TODO:** potvrditi tačan `TENANT_ID` HealthMedic KB-a iz njegovog configa.

---

## 4. DATA PLATFORMA — `data-platform` (MERNI INSTRUMENT za sve 4 studije)

Izvor: `ap/products/data-platform/` (docs/ARCHITECTURE_REVIEW.md,
services/atlas-reports/*, services/comprehensive-aggregation/*,
services/analysis-tracker/*, services/conversations/*).

### 4.1 Zašto je ovo merni instrument

Sve brojke u sve 4 studije (konverzija, deflection, hot lead-ovi, prihod,
trajanje) NE dolaze iz ad-hoc brojanja nego iz ovog per-tenant sistema koji
analizira konverzacije i chatbota I voicebota. Ako se to eksplicitno opiše, brojke
postaju proverljiv inženjerski artefakt (bitno zbog konflikta interesa /
odsustva kontrolne grupe navedenog u research-notes).

### 4.2 Generička analiza (Bedrock Nova, structured output)

Izvor: `docs/ARCHITECTURE_REVIEW.md` („Executive Summary", „System Architecture").

- Per-tenant sistem za **automatsku analizu konverzacija preko Amazon Bedrock
  Nova sa structured output (Tool Use)**.
- Tipovi analize (po fajlu prompta u `prompts/`): **sentiment, topics, quality,
  resolution**. Trajanje se računa iz timestamp-ova (nije zasebna analiza).
- Pipeline (state machine → analysis-tracker → comprehensive-aggregation):
  1. Svaka analiza (sentiment/topics/quality/resolution) se snimi u S3 output.
  2. `analysis-tracker` (DynamoDB) atomično prati koje su gotove; kad su sve
     gotove (set poređenje, uslovni update da tačno JEDNA Lambda okine dalje) →
     EventBridge „All Analyses Completed".
  3. `comprehensive-aggregation` učita sve analize + konverzaciju, izračuna
     trajanje, generiše ukrštene uvide, **business_impact scoring** (lead_score,
     urgency, conversion probability), i **agregira metrike tenanta
     (hourly/daily/weekly/monthly)** + custom metrike po tenantu.
- Konverzacije se migriraju/uvoze iz AgentCore bucketa (chatbot) i iz voicebot
  session-export Lambde (§2.6) → jedinstven ulaz za oba modaliteta.
- **Poznati problem (transparentnost merenja):** `ARCHITECTURE_REVIEW.md` (mart
  2026, issue #310) dokumentuje bug gde `message_count` ispada 0 u agregaciji
  iako je u S3 tačan → BIL je vraćao pogrešan `total_messages`. Ovo treba pošteno
  navesti kao ograničenje mernog instrumenta u periodu; **TODO:** potvrditi da li
  je popravljeno pre merног perioda case-studija (maj–avg 2026).

### 4.3 Atlas-specifični analizatori (klasifikacija ishoda)

Izvor: `services/atlas-reports/` — ovo je „poslovni" merni sloj koji daje baš
brojke iz research-notes (completed sale / hot lead / renewal / problem / info).

- **`conversation_analyzer.py` (CHATBOT, CS1):**
  - Ulaz: konverzacija iz S3 (`metadata.agent_state.atlas24h_workflow`,
    `data.messages`).
  - Detekcija namere PRVENSTVENO iz `agent_state` workflow-a (`intent`,
    `collected_data`), fallback iz teksta.
  - **Completion markeri** (tekstualni potpis uspešne narudžbine): „zahtev
    primljen", „narudžbina je primljena", „aktivacija paketa", … ; „qualified
    lead" marker; problem markeri.
  - Klasifikacija → `completed_sale | hot_lead | renewal | problem | info | other`
    (funkcija `_classify` po signalima intent/completed/confirmed/has_phone).
  - Agregacija (`aggregate_results` → `DailyMetrics`): completed_sales, hot_leads,
    renewals, reported_problems, packages_sold, **estimated_revenue** (preko
    `PACKAGE_PRICES` cenovnika — istog kao u chatbot kodu), trajanja.
- **`cc_voicebot_analyzer.py` (CS3, inbound CS voicebot):**
  - Ulaz: JSON sesija (isti oblik + voicebot polja: `caller_number`,
    `duration_seconds`, `call_outcome`).
  - Dodatni markeri: renewal, **transferToHuman**, package check.
  - Klasa/intent: renewal / problem / transfer / check / info; broji
    `transfers_to_human`, `package_checks`, trajanja → **deflection** se izvodi
    kao udeo rešenih bez čoveka (CS3 „49,3%").
  - **Deli kod sa chatbot analizatorom** (importuje `COMPLETION_MARKERS`,
    `PACKAGE_PRICES`, `PROBLEM_MARKERS`, `ConversationResult`) — isti
    klasifikacioni okvir za tekst i glas. Ovo je tehnička osnova za „zajednički
    analitički okvir" iz research-notes.
- **`sales_voicebot_analyzer.py` (CS2, outbound sales voicebot):**
  - Ulaz: **`.log` fajlovi** iz S3 (recordings bucket) — metapodaci (caller,
    Outcome completed/abandoned, Total duration), TRANSCRIPT sekcija, TOOL CALLS
    sekcija.
  - Completed sale se detektuje kombinacijom: closing fraze („ugovor stiže na
    email", „aktivacija paketa je najranije 48h", …) + prisustvo podataka
    (email/adresa) + `Outcome: completed` + tool pozivi
    `startSalesWorkflow`/`submitSalesData`.
  - Klasa: `completed_sale | hot_lead | other`; paket iz tool poziva (pouzdanije)
    ili teksta; cena iz `PACKAGE_PRICES` → daje „143 prodaje / 6,5%" tip metrike.
- **`report_builder_atlas.py` / `lambda_function.py`** — sklapaju dnevne/periodne
  izveštaje; `atlas_api.py` (PHONE_PATTERN, normalize_phone), `atlas24h-hot-leads`
  servis.

### 4.4 BIL API + servisi za dashboard

- **BIL REST API** (`X-Api-Key`) za dashboarde: `dashboard-metrics`,
  `conversations`, `conversation-details`, `conversation-search`, `trends`,
  `weekly-report`, `tenant-authorizer`. Bazni URL BIL-a je u kodu (u rad ide kao
  „BIL dashboard", bez host-a).
- `conversation-migrator` / `backfill-processor` — uvoz istorijskih konverzacija.

### 4.5 Definicija „konverzacije" (merno-metodološki)

- Chatbot: `conversation-export` Lambda (iz #15 beleški; svakih ~5 min eksportuje
  sesije idle >10 min u S3 data lake, cleanup ~30 min) — sprečava „session
  splitting". **TODO:** potvrditi tačan izvorni fajl te Lambde u
  `agentcore-runtime` (u #15 je referisano; nije ponovo otvarano ovde).
- Voicebot: jedna „konverzacija" = jedan poziv (`call_id`, `SessionExportData`).
- Za rad: eksplicitno navesti da je jedinica analize različita po modalitetu
  (sesija chata vs poziv) — deo „neuporedivosti metrika" koju rad rešava
  zajedničkim okvirom (automation/resolution rate).

---

## 5. NOTIFICATION-SERVICE — `notification-service` (+ workflow SES)

Izvor: `ap/products/notification-service/README.md`;
voicebot `src/lib/workflows/emailSender.ts`; chatbot `tools/*/email_notifications.py`.

### 5.1 Generički async notification servis

- Tok: **API Lambda → SQS FIFO (DLQ, 3 retrija) → email-sender Lambda → AWS SES.**
  Svaki uspešan send se loguje u DynamoDB (GSI `date-timestamp-index` za upite po
  datumu). Runtime Python 3.12, API Gateway (SAM).
- `POST /notify`: `notification_type` (email/sms), `recipients/cc/bcc`,
  `template_type`, `data` (subject, name, cta…). Max 50 primalaca po zahtevu.
  Odgovor 202 sa `notification_id`.

### 5.2 Kako chatbot i voicebot šalju leadove/potvrde

- **Voicebot** (`emailSender.ts`): po završetku workflow-a šalje **direktno preko
  AWS SES** (ne nužno preko notification-service) — telo sadrži prikupljene
  podatke + BIL transkript link + audio + call log. Rutiranje primalaca po env-u
  i tipu zahteva: kvalifikovani sales lead-ovi → prodajni tim; izmene
  ugovora/problem → administracija; interne kopije. (Adrese u kodu — NE u rad.)
  Realni SES send samo za SIP pozive; web sesije se loguju.
- **Chatbot** (`tools/{tenant}/email_notifications.py` po tenantu: atlas24h,
  healthmedic, auto_rad, ivanic, regos): šalje kvalifikovane leadove / potvrde
  narudžbine timu. **TODO:** potvrditi da li chatbot ide preko
  `notification-service` (SQS/SES) ili direktno SES kao voicebot — nisam otvarao
  `atlas24h_chatbot/email_notifications.py` u detalje (18KB). Za sada: potvrđeno
  da postoji per-tenant email sloj; put (SQS vs direktan SES) TODO.
- Za rad: obe implementacije koriste SES kao krajnji kanal za „human handoff"
  (kvalifikovan lead / potvrda) — zajednički izlazni sloj za sve 4 studije.

---

## 6. Sažetak arhitekture po komponenti (za sekciju „Sistem")

- **Chatbot (CS1, CS4):** Bedrock AgentCore + Strands, multi-tenant preko
  `TENANT_ID`; direct handler (deterministička brza putanja) vs pun LLM agent;
  model factory (Nova default na Bedrock, konfigurabilni fallback lanac
  OpenAI/Qwen/DeepSeek); hooks (tool limit, param capture, direct response);
  strukturisani UI izlaz; DynamoDB+S3 sesije; deljeni FAISS RAG alat sa
  anti-injection sanitizacijom.
- **Voicebot (CS2, CS3):** Next.js/TS + OpenAI Realtime; Asterisk/SIP/RTP
  telefonija (UDP/TCP, G.711 μ-law, barge-in); junior (`gpt-realtime-mini`) /
  supervisor (`gpt-4.1`) obrazac; workflow framework (intents, required fields,
  validatori telefon/email/tablice/JMBG/adresa, SES email); deljeni Atlas FAISS
  KB; headless realtime sesija; session-export u data-platform; isti Docker image
  za CS i sales (razlika `AGENT_CONFIG`).
- **RAG/KB (`agentcore-kb-onboarding`):** Step Functions pipeline (scraping sa
  SHA-256 skip, price detection GPT-4o-mini, FAQ base/runtime + DynamoDB
  RecordManager, inkrementalni FAISS). Chatbot i (CS/sales) voicebot za Atlas
  **dele isti S3 index izvor** (`indices/atlas24h-chatbot/{faq,scraped}`).
- **Data-platform (merni instrument, sve 4):** Bedrock Nova structured output
  (sentiment/topics/quality/resolution) + comprehensive-aggregation
  (business_impact, metrike hourly→monthly) + Atlas-specifični analizatori koji
  DELE klasifikacioni okvir za tekst i glas (completed_sale/hot_lead/renewal/
  problem/info; deflection, revenue iz cenovnika) + BIL API za dashboarde.
- **Notification (`notification-service` + workflow SES):** async API→SQS FIFO→
  SES→DynamoDB log; voicebot šalje leadove/potvrde direktno preko SES; chatbot
  per-tenant email sloj (put SQS vs SES = TODO). Zajednički izlazni kanal za
  human handoff u sve 4 studije.

---

## 7. TODO / NEPROVERENO (integritet — ne izmišljati)

1. **Model chatbota (maj–jul 2026, Atlas):** README kaže `nova-pro`,
   `model_factory.py` default `nova-2-lite`; stvarni model je iz Atlas S3 configa.
   Potvrditi tačan `model` iz Atlas tenant configa pre upisa. (Nasleđeno iz #15.)
2. **Voicebot modeli:** upisati vrednosti iz `src/config/models.ts`
   (`gpt-realtime-mini`, `gpt-4o-mini-transcribe`, `gpt-4.1`, `gpt-4o-mini`) kao
   merodavne; prozni README pominje „gpt-4o-realtime" — ne mešati. Supervisor
   `gpt-4.1` potvrđen.
3. **HealthMedic KB tenant:** potvrditi tačan `TENANT_ID`/index prefiks
   HealthMedic KB-a (CS4) iz njegovog configa.
4. **Chatbot email put:** da li `atlas24h_chatbot/email_notifications.py` (i
   healthmedic) šalju preko `notification-service` (SQS/SES) ili direktno SES —
   otvoriti fajl (18KB) i potvrditi. Voicebot je potvrđeno direktan SES.
5. **conversation-export Lambda (chatbot):** potvrditi tačan izvorni fajl/putanju
   u `agentcore-runtime` (parametri idle>10min, cleanup ~30min iz #15).
6. **data-platform `message_count=0` bug (#310, mart 2026):** potvrditi da li je
   rešen pre mernog perioda studija (maj–avg 2026) — utiče na pouzdanost metrika;
   navesti kao ograničenje ako nije potvrđeno.
7. **Deploy workflow imena:** tačni nazivi YAML-ova u
   `experimental/voicebot/.github/workflows/` (voicebot-production-deploy,
   sales-voicebot-production-deploy, voicebot-session-export-production-deploy)
   — README ih parafrazira; potvrditi ako se citiraju doslovno.
8. **HealthMedic tok zakazivanja (CS4):** dubinski pročitati
   `tools/healthmedic_chatbot/{tools.py,workflows.py,doctor_lookup.py}` ako rad
   traži detaljan opis (za sada potvrđeno postojanje i uloga fajlova).
9. **Figure:** postoje gotovi PlantUML/SVG dijagrami u
   `experimental/voicebot/docs/diagrams/` — adaptirati za rad (obavezno ukloniti
   IP adrese/hostove), NE kopirati bukvalno.

## 8. Bezbednosna napomena (za pisca rada)

U tekst rada NE unositi: ARN-ove, API ključeve, imena S3 bucketa, Asterisk IP
i portove, konkretne imejl-adrese primalaca, SOS/telefon brojeve iz koda. Sve to
opisati na nivou komponenti („preko AWS Secrets Manager", „SIP/RTP ka Asterisk
PBX-u", „SES na definisanu listu primalaca"). Ovaj dokument se toga drži.
