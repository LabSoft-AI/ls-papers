# Arhitektura sistema — beleške za Future-BME rad

> Autor: Luka Vidaković. Radni dokument (ne ulazi u build). Sve dole je iz
> stvarnog koda i README-a u `~/github/work/world/ap/products/`. Ništa nije
> izmišljeno; gde nešto treba potvrditi stoji TODO.
>
> Svrha: rad nije samo poslovni case study (brojke prodaje) nego naučni rad —
> zato mora opisati ARHITEKTURU AI chatbota i podatkovnu platformu za analizu
> konverzacija koja stoji iza metrika. To je tehnički doprinos/artefakt.

## Zašto ovo ulazi u rad

Future-BME rad (Atlas24h AI Sales Chatbot) treba sekciju „Sistem / Arhitektura"
između Metoda i Rezultata: opisati KAKO je chatbot izgrađen i KAKO se meri, da
bi produkcione brojke (61% konverzija, €113.722) bile proverljive i ponovljive
kao inženjerski artefakt, a ne samo tvrdnja.

## Komponente sistema (4 proizvoda)

### 1. agentcore-runtime / customer-agent — sam chatbot
Izvor: `ap/products/agentcore-runtime/services/customer-agent/`

- Multi-tenant AI customer/sales agent na **AWS Bedrock AgentCore** +
  **Strands Agents SDK** (Python). Tenant se bira preko `TENANT_ID`.
- Atlas24h je jedan tenant: `tools/atlas24h_chatbot/` (atlas_tools, tools,
  package_service, order_service, workflows, direct_handler, email_notifications).
- Tok `invoke()`: payload (prompt, session_id, browser_data, attachments) →
  session (DynamoDB-backed) → prvo „direct handler" (brza putanja za strukturisane
  korake workflow-a) → ako ne matchuje, pun Strands Agent sa:
  - tenant system prompt (iz S3 config bucketa, interpolacija `{current_time}`,
    `{workflow_context}`, `{context}`),
  - tenant-specific tools + shared RAG tool,
  - hooks (tool limiting, parameter capture),
  - opciono strukturisani izlaz (`AgentResponse` Pydantic: Confirmation, Choice,
    Rating, Date/Time, DocumentUpload) — bogate UI komponente.
- Model: Bedrock (default `eu.amazon.nova-pro-v1:0`), `MAX_TOOL_CALLS` default 5.
- Atlas prodajni tok (iz `conversation_analyzer.py` i tools): identifikacija
  namere → prikupljanje podataka (paket, tablice, adresa, kontakt) → kompletiranje
  kupovine u razgovoru (order_service) → potvrda („zahtev primljen / narudžbina
  je primljena / aktivacija paketa"). Cenovnik paketa u kodu (RSD): Internacionalni+
  10.990, Nacionalni 4.990, itd. (dominantan proizvod voicebota bio Internacionalni+).

### 2. agentcore-kb-onboarding — znanje (RAG) chatbota
Izvor: `ap/products/agentcore-kb-onboarding/README.md`

- Automatski KB pipeline (Step Functions): scraping sajta tenanta →
  paralelno skrejpovanje (Map, do 5 Lambdi, batch 350, SHA-256 hash za skip
  nepromenjenih) → FAQ improvements (LLM iz „dislike" feedbacka) → build FAISS
  indeksa (inkrementalno, LangChain index() + DynamoDB RecordManager) → SNS mejl.
- Price detection: regex pre-filter → GPT-4o-mini structured output →
  auto-update cena u `faq_runtime.json` ili flag „needs_review".
- FAQ base/runtime split (deploy ne gazi runtime izmene). REST API (API Gateway,
  X-Api-Key) za update/rebuild/fresh-build/status/FAQ CRUD.
- Relevantno za rad: chatbot ne „halucinira" cene i informacije — odgovara iz
  kontrolisanog, verzionisanog KB-a; ovo je važno za validnost prodajnih tvrdnji.

### 3. data-platform — analiza konverzacija (iza metrika)
Izvor: `ap/products/data-platform/` (docs/ARCHITECTURE_REVIEW.md, atlas-reports)

- Per-tenant sistem za automatsku analizu konverzacija preko **Amazon Bedrock
  Nova** sa structured output (Tool Use).
- Analize: sentiment, teme, kvalitet, resolution; trajanje iz timestamp-ova;
  business impact scoring (lead_score, urgency, conversion probability);
  agregacija metrika (hourly/daily/weekly/monthly); custom metrike po tenantu.
- **BIL REST API** za dashboarde (X-Api-Key). Migracija konverzacija iz
  AgentCore bucketa.
- Atlas-specifično (`atlas-reports/conversation_analyzer.py`): klasifikacija
  konverzacija u completed sale / hot lead / renewal / problem / info, detekcija
  preko markera u tekstu (npr. „zahtev primljen") i workflow stanja
  (`agent_state.atlas24h_workflow`). Ovo je merni instrument za brojke u radu.
- conversation-export Lambda (svakih 5 min): eksport sesija idle >10min u S3
  data lake; cleanup posle 30min. Sprečava „session splitting" (spajanje nastavka
  razgovora u isti fajl). Ovo definiše šta je jedna „konverzacija" u metrikama.

### 4. notification-service — asinhroni mejl
Izvor: `ap/products/notification-service/README.md`

- API Lambda → SQS FIFO (DLQ, 3 retrija) → email-sender Lambda → AWS SES;
  svaki uspešan send logovan u DynamoDB (GSI po datumu).
- Relevantno: kvalifikovani lead-ovi i potvrde iz chatbota idu korisniku/timu
  ovim servisom (u case study-ju: „šalje kvalifikovane leadove timu mejlom").

## Predlog: dijagram arhitekture za rad

Napraviti jednu figuru (`figures/arhitektura.svg` ili .png) sa tokom:

```
Korisnik → Web chat → customer-agent (Bedrock AgentCore + Strands)
                         │        ├── RAG (FAISS iz kb-onboarding)
                         │        └── Atlas tools (order/package/workflow)
                         ├── kupovina u razgovoru → Atlas order API
                         ├── kvalifikovan lead → notification-service (SES)
                         ▼
                   conversation-export (S3 data lake)
                         ▼
                   data-platform (Bedrock Nova analiza) → BIL API → metrike
```

TODO: napraviti stvarnu figuru; SVG se drži kao tekst (ne LFS) i traži librsvg.

## Šta treba PROVERITI / dopuniti pre pisanja (integritet)

- [ ] Potvrditi koji tačno Bedrock model je Atlas sales chatbot koristio u
      periodu maj–jul 2026 (README navodi default Nova-pro; proveriti Atlas config).
- [ ] Potvrditi da je „61% konverzija" merena baš instrumentom iz
      `conversation_analyzer.py` (completion markeri) ili iz Atlas production API
      — uskladiti definiciju iz case study-ja sa mernim kodom.
- [ ] Ne navoditi interne ARN-ove, API ključeve, imena bucketa iz koda u radu
      (bezbednost). Opisati arhitekturu na nivou komponenti, ne kredencijala.
- [ ] Odlučiti nivo detalja: konferencijski rad (5–8 str.) — arhitektura sažeto,
      jedna figura + 1–2 pasusa; puni detalji za master (#16).

## Reference za arhitekturu (za ls-researcher da verifikuje/nađe)

Za tehnički deo trebaju citati (trenutno NIJEDAN nije verifikovan — TODO):
- [ ] RAG / retrieval-augmented generation (Lewis et al. 2020) — TODO verifikovati.
- [ ] FAISS (Johnson, Douze, Jégou) — TODO verifikovati.
- [ ] Osnovni LLM/transformer i „tool use / function calling" izvor — TODO.
- [ ] AWS Bedrock / Nova — zvanična dokumentacija kao `@misc` sa url+urldate.

Napomena: sve tehničke tvrdnje u radu koje nisu opšte poznate moraju uz izvor
ili biti jasno označene kao opis sopstvenog sistema (inženjerski artefakt).
