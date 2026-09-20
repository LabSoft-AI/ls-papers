# Istraživačke beleške: Master rad — komparativna analiza 4 AI implementacije

> Autor: Luka Vidaković. Radni dokument (ne ulazi u build). Sve brojke iz
> verifikovanih StartAI case studija (startai.tech/en/case-studies, „verified
> through production API / production data"). Ništa izmišljeno.
>
> KONFLIKT INTERESA: autor je implementator sistema (StartAI). Produkcioni
> podaci bez nezavisne revizije, bez kontrolne grupe. Eksplicitno navesti.
>
> BLOKER (iz issue #16): pre pisanja potvrditi kod mentora da praktičarski
> pristup sa sopstvenim produkcionim podacima prolazi na smeru. STATUS: potvrđeno
> od strane autora da idemo dalje (20.09.2026).

## Metapodaci teze (potvrđeno)

- Jezik: SRPSKI, ĆIRILICA (kao template Željane Kužet). Ceo rad na ćirilici.
- Autor: Luka Vidaković
- Studijski program: Рачунарство и аутоматика
- Modul / stručna oblast: Рачунарска техника и рачунарске комуникације
- Usmerenje: Аутомобилски софтвер
- Nivo studija: Мастер академске студије
- Fakultet: Факултет техничких наука, Нови Сад
- (Na obrascu: ako postoji samo „Студијски програм" → „Рачунарство и аутоматика";
  ako postoji i „Модул/Усмерење" → „Рачунарска техника и рачунарске комуникације
  – Аутомобилски софтвер")

## Obim (za razliku od Future-BME rada #15)

Future-BME (#15, predat) = JEDAN slučaj (Atlas24h sales chatbot), dubinski.
Master rad (#16) = KOMPARATIVNA analiza SVA 4 slučaja + kompletna arhitektura
(chatbot + voicebot), sa usklađenim analitičkim okvirom. Ovde ima prostora da se
neuporedive metrike (konverzija/deflection/termini) pošteno uokvire.

## Format / template

- Master teza: `shared/resources/ftn-master-thesis-template.docx` (Željana Kužet
  pré-final). Struktura (ćirilica): UVOD → PREGLED LITERATURE → CILJ I
  METODOLOGIJA ISTRAŽIVANJA → REZULTATI STUDIJE SLUČAJA I DISKUSIJA → ZAKLJUČAK →
  PRILOZI → LITERATURA.
- Jezik: proveriti sa mentorom (teza je verovatno srpski; Future-BME je bio
  engleski). TODO: potvrditi jezik teze.
- Studijski program autora: TODO (template Željane kaže „Inženjerstvo zaštite na
  radu" — to je njen smer; upisati Lukin smer).

## Izvori — 4 case studija (startai.tech, jul/avg 2026)

### CS1 — Atlas24h AI Sales Chatbot (web chat)
Izvor: /en/case-studies/atlas24h-chatbot/ (verified via Atlas production API)
- Growth (Before info bot → maj → jun → jul 2026):
  - Konverzacije: — / 1,847 / 4,598 / 7,559
  - Kvalifikovani leadovi: 0 / 458 / 1,301 / 2,776
  - Potvrđene prodaje (API): 0 / 196 / 558 / 1,705
  - Prihod: €0 / €15,200 / €38,700 / €113,722
  - Conversion: — / 42.8% / 42.9% / 61.4%
- Jul raspodela ishoda: direktna kupovina u chatu 771→559 (73%); lead+follow-up
  2,005→1,146 (57%); info/status 4,783 rešeno AI (63%).
- Doprinos AI kanala ukupnoj prodaji jul 2026: 1,811 od 3,905 (46.4%); human call
  centar 2,094 (-3.8% g/g). Jul 2025 human: 2,177.
- Ključno: kupovina u razgovoru (jul) → konverzija 43%→61%.

### CS2 — Atlas24h AI Sales Voicebot (outbound, autonoman)
Izvor: /en/case-studies/atlas24h-sales-voicebot/ (verified via Atlas production API)
- Period: 25 dana (lansiran 6. jul 2026).
- 143 završene prodaje, 2,209 poziva, konverzija 6.5%, 0 ljudi u zatvaranju.
- Total conversation time 35.1h; prosečan poziv 57.4s; uspešan ~2.5 min.
- Dominantan proizvod Internacionalni+ (128/143, ~90% uspešnih poziva).
- Levak: poziv odgovoren 48% pokušaja; ponuda saslušana 82%; prodaja 6.5% svih.
- 88 poziva/dan (vs 40–60 ljudski); 35% uspešnih prodaja van radnog vremena.
- Scaling plan: avg 2026 → 5,000+ poziva/mesec, cilj 300+ prodaja/mesec.

### CS3 — Atlas24h AI Customer Service Voicebot (inbound)
Izvor: /en/case-studies/atlas24h-cs-voicebot/ (verified via production call logs)
- Jul 2026: 4,223 poziva obradio AI, 2,081 rešeno bez čoveka (deflection 49.3%).
- Obim poziva: 13,809 (jul 2025) → 21,009 (jul 2026), +52.1%.
- Human sales output 2,177→2,094 (-3.8%), 0 novih agenata, €200K+ ušteda.
- Peak: 519 poziva/sat (9h); prosečno trajanje 58.5s; oslobođeno 34h/mesec.
- Kategorije: status članstva 1,847 (65% AI, 1,203); roadside 1,109 (45%, 498);
  cene 689 (55%, 380); prodajne prilike 578 (sve prosleđene čoveku).
- Next phase: cilj 60% resolution do sep 2026; obrada obnova direktno u pozivu.

### CS4 — HealthMedic AI Healthcare Chatbot (web chat, poliklinika NS)
Izvor: /en/case-studies/healthmedic-chatbot/ (production data, 2,032 konverzacije)
- Period: mart–avgust 2026.
- 2,068 pacijentskih konverzacija; 751 zahtev za termin (37%); 96.8% bez
  negativnog sentimenta; 24/7.
- Mesečni rast: mart 179 → apr 363 → maj 344 → jun 361 → jul 404 → avg 414.
- Tipovi upita: termin 751 (37%), cene 644 (32%), usluge 230 (11%), medicinske
  info 171 (8%), lekari 121 (6%).
- Next phase: integracija kalendara (potvrda termina u razgovoru), višejezičnost.

## Osa komparacije (analitički okvir — ključ master rada)

4 slučaja variraju po tri dimenzije:
- Modalitet: tekst (chat) vs glas (voice)
- Smer: inbound (korisnik inicira) vs outbound (sistem inicira)
- Domen: roadside assistance (Atlas24h) vs zdravstvo (HealthMedic)
- Cilj: prodaja (sales) vs korisnička podrška (service)

| Slučaj | Modalitet | Smer | Domen | Cilj | Glavna metrika |
|--------|-----------|------|-------|------|----------------|
| CS1 chatbot | tekst | inbound | roadside | prodaja | konverzija 61.4% |
| CS2 sales voicebot | glas | outbound | roadside | prodaja | 143 prodaje/25d, 6.5% |
| CS3 CS voicebot | glas | inbound | roadside | podrška | deflection 49.3% |
| CS4 healthcare chatbot | tekst | inbound | zdravstvo | podrška/zakazivanje | 751 termina, 96.8% |

Ključno metodološko pitanje (koje je Future-BME izbegao suzivši obim): metrike
NISU direktno uporedive (konverzija ≠ deflection ≠ udeo termina). Master rad MORA
definisati zajednički okvir: npr. „automation rate" (udeo interakcija rešenih bez
čoveka) kao zajednička osa + domenski-specifične sekundarne metrike. Ovo je
srž doprinosa i mora se braniti u diskusiji.

## Arhitektura (kompletna — chatbot + voicebot)

Izvor: `~/github/work/world/ap/products/` (v. i architecture-notes iz #15).
- agentcore-runtime/customer-agent: multi-tenant AI agent (Bedrock AgentCore +
  Strands), tenant tools (atlas24h_chatbot, itd.), chat modalitet.
- Voicebot (glasovni agenti CS2, CS3): `world/experimental/voicebot` (razvoj) +
  `world/ap/products/voicebot` (session-export) + deploy workflows
  (voicebot-production-deploy, sales-voicebot-production-deploy,
  voicebot-session-export-production-deploy). Arhitektura (iz docs/ATLAS_VOICEBOT.md
  i src/README.md):
  - Telefonija: Asterisk PBX (SIP/RTP), SIP server (5060), WebSocket audio (8081).
  - Junior/Supervisor pattern: Junior agent (gpt-4o-realtime) radi glas I/O
    (STT+TTS preko OpenAI Realtime API); Supervisor agent (gpt-4.1) radi
    rezonovanje i pozive alata (getNextResponseFromSupervisor).
  - Alati supervisora: queryKnowledgeBase (FAISS FAQ+scraped), getUserPackages /
    getContractInfo (Atlas API), startWorkflow / submitWorkflowFields (email
    workflow), transferToHuman (Asterisk blind transfer).
  - Workflow framework: intent definicije + required fields po intentu,
    validatori (telefon, email, tablice, JMBG), SES email sender.
  - RTP audio handler (konverzija paketa), headless realtime session (bez UI),
    call-flow-integration kao orkestrator.
  - Jezik: srpski (chatSupervisorSerbian) + bosanski varijanta.
  - KONTRAST sa chatbotom (za komparaciju): chatbot = tekst, jedan agent
    (AgentCore+Strands, Nova); voicebot = glas, dva agenta (OpenAI Realtime +
    gpt-4.1), telefonija (Asterisk/SIP/RTP). Isti KB/RAG i workflow/email sloj.
- kb-onboarding: RAG (FAISS), scraping, price detection, FAQ improvement.
- data-platform: analiza konverzacija (Bedrock Nova), BIL API, metrike — merni
  instrument za sve 4 studije.
- notification-service: SES/SQS async.

## Literatura

- Baza iz Future-BME (#15) je primenljiva: klasteri A (chatbot), B (voicebots —
  wang2023, zhang2026 SAD relevantni!), C (zdravstvo — laranjo2018, milneives2020
  SAD relevantni!), D (MSP), E (metodologija), G (tehničke: RAG/FAISS/Bedrock).
- Za master treba PROŠIRITI: master teze traže širi pregled literature. TODO
  ls-researcher: dodati izvore za glasovne agente/voice AI, contact center
  automation, multimodal conversational AI, comparative case study methodology.
- references.bib: krenuti od kopije Future-BME bib-a (sve verifikovano) + dopune.

## TODO (redosled)

- [x] Potvrditi jezik teze (SRPSKI ĆIRILICA) i studijski program (Računarstvo i
      automatika / RT i RK – Automobilski softver) — POTVRĐENO
- [x] Arhitektura: voice pipeline potvrđen (experimental/voicebot, Asterisk +
      OpenAI Realtime junior/supervisor)
- [ ] ls-researcher: proširiti literaturu (voice AI, contact center, multimodal,
      comparative methodology) + kopirati verifikovane unose iz #15
- [ ] Definisati zajednički analitički okvir za komparaciju (automation rate + ...)
- [ ] ls-paper-writer: pisanje po strukturi teze na ĆIRILICI (bezličan glas)
- [ ] Dijagrami: arhitektura (chatbot + voicebot), po slučaju
- [ ] ls-reviewer: pregled
- [ ] Zbornik sažetak (#19) — posle master rada
