# Istraživačke beleške: Future-BME rad (StartAI studija slučaja)

> Autor: Luka Vidaković. Ovo je radni dokument (ne ulazi u build). Sve brojke
> ispod su iz stvarnih StartAI materijala u `~/github/work/world/sales/startai/`.
> Svaki podatak je označen izvorom. Ništa nije izmišljeno.
>
> KONFLIKT INTERESA: autor je implementator sistema (StartAI). Svi podaci su
> produkcioni podaci samog StartAI-ja, bez nezavisne verifikacije i bez kontrolne
> grupe. Ovo mora biti eksplicitno navedeno u radu (sekcija Ograničenja).

## ODLUKA O OBIMU (scope) — pročitati pre pisanja

**Future-BME rad = JEDAN slučaj, dubinski: Atlas24h AI Sales Chatbot.**

Obrazloženje (autor, 17.09.2026):

- 5–8 strana i 6 dana ne dozvoljavaju pošteno usklađivanje metrika četiri
  različita slučaja. Konverzija u chatu (61%), deflection poziva (49%) i udeo
  zahteva za termin (37%) NISU ista mera i ne mogu jedna pored druge bez
  zajedničkog analitičkog okvira — a graditi i braniti taj okvir za 4 slučaja u
  ovom prostoru vodi u plitak rad na sve četiri tačke („prevelik obim za dat
  prostor" u recenziji).
- Podela rada između radova mora biti svesna odluka: **Future-BME = uzak i
  dubok (Atlas24h sales chatbot)**; **master rad (#16) = komparacija sva četiri
  slučaja** sa usklađenim metrikama i prostorom za odbranu okvira.

Posledice za ovaj rad:

- Primarni slučaj: **samo Atlas24h AI Sales Chatbot** (sekcija „1." ispod).
- Ostala tri slučaja (sales voicebot, CS voicebot, HealthMedic) — NE ulaze u
  Future-BME rad; rezervisani za master (#16). Ostaju u ovim beleškama samo kao
  kontekst, jasno označeni.
- Literatura: glavni oslonac na klaster A (chatbot konverzija: [@luo2019],
  [@schanke2021], [@nicolescu2022]) + metodologija (klaster E). Klasteri B i C
  (voicebots, zdravstvo) postaju sekundarni/za master.
- Dopunski izvori koje je autor predložio (pokrivaju ugao koji 5 klastera ne
  pokriva direktno): Isabella et al. (2025), *Journal of Business Research* —
  chatbot naspram landing page (konverzija); i jedan TOE-RBV rad o adopciji.
  STATUS (ls-researcher, 17.09.2026): TOE-RBV rad NAĐEN i verifikovan
  ([@zuferi2026toerbv], Crossref) — dodat u Klaster D. Isabella et al. (2025)
  JBR — NIJE pouzdano identifikovan pretragom; ostavljen TODO (v. dole), NE
  izmišljam.

## STATUS VERIFIKACIJE IZVORA (ne verovati tuđem izveštaju)

Pravilo: nijedan izvor se u finalnoj predaji ne tretira kao „verifikovan" dok
mu DOI nije lično otvoren ili provučen kroz Crossref API.

| Ključ | Nezavisno provereno | Status |
|-------|---------------------|--------|
| luo2019 | autor (ručno) + ls-git (Crossref) | naslov/god/DOI OK; vol/pages TODO |
| zhang2026 | autor (ručno) + ls-git (Crossref) | OK (72(1):73–95) |
| oldemeyer2024 | autor (ručno) + ls-git (Crossref) | ispravljeno na 75(1); god 2024/2025 TODO |
| laranjo2018 | ls-git (Crossref) | OK (25(9):1248–1258) |
| wang2023 | ls-git (Crossref) | OK (32(4):1002–1018) |
| rashid2019 | ls-git (Crossref) | OK (vol 18; article-number TODO) |
| schanke2021 | ls-researcher (Crossref) | OK — naslov/autori/venue/32(3):736–751/2021 se poklapaju |
| nicolescu2022 | ls-researcher (Crossref) | OK — naslov/autori/venue/11(10):1579/2022 se poklapaju |
| milneives2020 | ls-researcher (Crossref) | OK — naslov/autori/venue/22(10):e20346/2020 se poklapaju |
| schwaeke2024 | ls-researcher (Crossref) | metapodaci OK (63(3):1297–1331); Crossref: online 2024-08-13, štampano 2025 — godina zadržana 2024 (issued), dodat komentar u .bib |
| runeson2009 | ls-researcher (Crossref) | OK — naslov/autori/venue/14(2):131–164/2009 se poklapaju |
| zuferi2026toerbv | ls-researcher (Crossref) | OK — TOE-RBV AI adopcija MSP EU; LNCS book-chapter, 308–326, 2026 |
| lewis2020rag | ls-researcher (arXiv/NeurIPS) | OK — arXiv:2005.11401, „Accepted at NeurIPS 2020", 12 autora potvrđeno |
| johnson2021faiss | ls-researcher (Crossref) | OK — IEEE TBD 7(3):535–547; online 2019, štampano 2021 |
| vaswani2017attention | ls-researcher (arXiv/NeurIPS) | OK — arXiv:1706.03762, NeurIPS 2017, 8 autora potvrđeno |
| awsbedrock | ls-researcher (zvanične AWS docs) | OK — stranica otvorena 2026-09-17 (@misc, url+urldate) |
| awsnova | ls-researcher (zvanične AWS docs) | OK — stranica otvorena 2026-09-17 (@misc, url+urldate) |

Ne ignorisati sopstvene TODO-ove ls-researcher-a — oni su deo ovog spiska.

## Izvori materijala

- Case studije (PDF, verifikovane produkcione brojke):
  `sales/startai/materials/case-studies/`
  - `StartAI-CaseStudy-Atlas24h-AI-CustomerService-Voicebot.pdf`
  - `StartAI-CaseStudy-Atlas24h-AI-Sales-Chatbot.pdf`
  - `StartAI-CaseStudy-Atlas24h-AI-Sales-Voicebot.pdf`
  - `StartAI-CaseStudy-HealthMedic-AI-Chatbot.pdf`
- Sales tracker (proces, sekundarni kontekst): `sales/startai/tracker/reports/`,
  `tracker/data/` (nedeljni podaci N1–N3, tim-izveštaj 16.09.2026).

Napomena o verifikaciji (iz samih case studija): brojke za Atlas24h su
verifikovane kroz „Atlas production API" / „production call logs"; HealthMedic iz
„production conversation data — 2,032 analizirane konverzije". Ovo su tvrdnje iz
internih dokumenata, ne nezavisna revizija.

## Slučajevi (produkcioni podaci)

> Za Future-BME koristi se SAMO slučaj 1 (Atlas24h AI Sales Chatbot).
> Slučajevi 2–4 su kontekst i rezervisani su za master rad (#16) — NE ulaze u
> ovaj konferencijski rad.

### 1. Atlas24h — AI Sales Chatbot (web chat) — PRIMARNI SLUČAJ (Future-BME)

- Period: rast maj→jul 2026.
- Jul 2026: €113,722 verifikovanog prihoda, 1,705 potvrđenih prodaja (API),
  2,776 kvalifikovanih leadova, konverzija 61.4%.
- Rast: maj 196 prodaja / €15,200; jun 558 / €38,700; jul 1,705 / €113,722.
- Konverzija skočila 43%→61% nakon omogućavanja kupovine u chatu.
- Doprinos AI kanala ukupnoj prodaji (jul 2026): 1,811 od 3,905 (46.4%);
  ljudski call centar ravno na 2,094 (-3.8% g/g).
  NAPOMENA (obim): 1,811 je ŠIRI AI kanal (uklj. voicebot) — NE koristi se u
  Future-BME radu; rad je strogo o chatbotu (1,705). Ostaje ovde kao kontekst.

Izvor: kompletan StartAI case study „Atlas24h — AI Sales Chatbot" (startai.tech,
Case Studies, jul 2026; „Every number verified through the Atlas production API").
Detaljne verifikovane brojke iz tog case study-ja (koriste se u §5 rada):

- Growth trajectory (Before info bot → maj → jun → jul 2026):
  - Konverzacije: — / 1,847 / 4,598 / 7,559
  - Kvalifikovani leadovi: 0 / 458 / 1,301 / 2,776
  - Potvrđene prodaje (API): 0 / 196 / 558 / 1,705
  - Prihod: €0 / €15,200 / €38,700 / €113,722
  - Conversion rate: — / 42.8% / 42.9% / 61.4%
- Raspodela ishoda (jul 2026):
  - Direktna kupovina završena u chatu: 771 konverzacija → 559 potvrđeno (73%)
  - Lead generisan (follow-up konvertovao): 2,005 → 1,146 potvrđeno (57%)
  - Informacija / provera statusa: 4,783 → rešeno od strane AI (63%)
  - 559 + 1,146 = 1,705 (poklapa se sa ukupnim potvrđenim prodajama u julu)
  - 63% svih konverzacija rešeno bez ljudske intervencije
- „What changed in July": kupovina se završava direktno u razgovoru (bez
  prosleđivanja timu) → konverzija 43%→61%; close rate 73% na in-chat kupovinama
  je najviši u levku.

### 2. Atlas24h — AI Sales Voicebot (outbound, autonoman) — [REZERVISANO ZA MASTER #16]

- Period: 25 dana (lansiran 6. jul 2026).
- 143 završene prodaje, 2,209 poziva, konverzija 6.5%, 0 ljudi u zatvaranju.
- Prosečan uspešan poziv 2.5 min; dominantan proizvod Internacionalni+ (128/143).
- 88 poziva/dan vs. 40–60 kod ljudskog agenta; radi noću i vikendom.

### 3. Atlas24h — AI Customer Service Voicebot (inbound) — [REZERVISANO ZA MASTER #16]

- Jul 2026: 4,223 poziva obradio AI, 2,081 rešeno bez čoveka (deflection 49.3%).
- Kontekst: obim poziva 13,809 (jul 2025) → 21,009 (jul 2026), +52.1%.
- Ljudski sales output ostao stabilan (2,177→2,094, -3.8%), 0 novih agenata,
  ušteda €200K+/god. Peak: 519 poziva u satu (9h), prosečno trajanje 58.5s.
- Kategorije: status članstva 1,847 (65% AI), roadside 1,109 (45%),
  cene 689 (55%), prodajne prilike 578 (sve prosleđene čoveku).

### 4. HealthMedic — AI Healthcare Chatbot (web chat, poliklinika NS) — [REZERVISANO ZA MASTER #16]

- Period: mart–avgust 2026 (2,032 analizirane konverzije).
- 2,068 pacijentskih konverzacija, 751 zahtev za termin (37% svih),
  96.8% konverzacija bez negativnog sentimenta, 24/7.
- Mesečni rast: mart 179 → avgust 414 konverzacija.
- Tipovi upita: termin 751 (37%), cene 644 (32%), usluge 230 (11%),
  medicinske info 171 (8%), lekari 121 (6%).

## Skica ugla za Future-BME (5–8 strana) — JEDAN SLUČAJ, DUBINSKI

Okvir: primenjena studija slučaja o uvođenju **AI sales chatbota** u MSP
okruženju u Srbiji (Atlas24h, roadside assistance), sa merljivim produkcionim
ishodima kroz tri meseca (maj–jul 2026).

Teza: AI sales chatbot pretvara ranije nemonetizovan informativni kanal u
merljiv prodajni kanal — od €0 do €113.722 mesečnog prihoda i rasta konverzije
sa 43% na 61% nakon omogućavanja kupovine u razgovoru — bez povećanja broja
zaposlenih, uz stabilan učinak ljudskog tima.

Zašto baš ovaj slučaj: ima najčistiju, jednodimenzionalnu metriku (konverzija →
potvrđena prodaja → prihod, sve kroz Atlas production API), pa se izbegava
problem neusklađenih mera iz drugih slučajeva. Jedan analitički okvir, jedan
domen, dovoljno prostora za pošten tretman ograničenja.

Predlog strukture (5–8 strana): apstrakt; uvod (problem + doprinos); related
work (klaster A + metodologija E); **sistem/arhitektura** (chatbot na Bedrock
AgentCore + Strands, RAG iz kb-onboarding, data-platform za analizu konverzacija
— v. `architecture-notes.md`, jedna figura); metod (opis slučaja, definicije
metrika, izvor podataka, konflikt interesa); rezultati (rast maj–jul, konverzija,
prihod, udeo AI kanala); diskusija (poređenje sa [@luo2019]/[@schanke2021],
ograničenja); zaključak.

Napomena: sekcija Arhitektura je ono što rad čini NAUČNIM/tehničkim, ne samo
poslovnim case study-jem. Opisati sistem kao inženjerski artefakt (kako je
izgrađen i kako se meri), ali sažeto zbog 5–8 strana — puni detalji za master
(#16). Detalji i izvori u `architecture-notes.md`.

## Šta NEDOSTAJE (za ls-researcher / pre pisanja)

- Recenzirana literatura o AI agentima u kontaktnim centrima / MSP (related work).
  Nema još nijednog `[@key]` — sve treba naći i verifikovati (ls-researcher).
- Definicija metrika (šta tačno „resolution", „conversion", „deflection" znače) —
  preuzeti iz case studija i formalizovati.
- Eksplicitan opis ograničenja i konflikta interesa (obavezno).
- Future-BME formatni zahtevi (broj strana, stil citiranja, šablon iz #8).

## TODO

- [ ] Popuniti `metadata.yaml` / `paper.md` header (naslov, autor: Luka Vidaković,
  apstrakt, keywords).
- [X] ls-researcher: related work + BibTeX u `references.bib`. (v. sekciju
  „Related work — literatura" ispod)
- [ ] ls-paper-writer: struktura i tekst po sekcijama.
- [ ] ls-reviewer: pregled pre predaje.

---

# Related work — literatura (ls-researcher)

> Priredio: Luka Vidaković (ls-researcher sesija). Svi izvori su STVARNI i
> verifikovani preko Crossref/DOI-a — metapodaci (autori, godina, venue, DOI)
> potvrđeni pre citiranja. BibTeX ključevi su u `references.bib`.
>
> Konvencija oznaka:
>
> - **Izvor** = doslovno iz rada (referenca + DOI/link).
> - *Sinteza* = moja interpretacija / gde ulazi u naš rad (nije citat).

## Klaster A — AI konverzacioni agenti / chatbotovi (podrška i prodaja)

Relevantno za: Atlas24h AI Sales Chatbot i HealthMedic chatbot (konverzija,
angažman, otkrivanje identiteta bota).

- **[@luo2019]** Luo, Tong, Fang, Qu (2019), *Marketing Science*, „Frontiers:
  Machines vs. Humans: The Impact of AI Chatbot Disclosure on Customer
  Purchases". DOI: 10.1287/mksc.2019.1192.

  - Izvor: terenski eksperiment; neotkriveni chatbotovi jednako efikasni kao
    iskusni agenti i ~4x efikasniji od neiskusnih, ali otkrivanje identiteta
    bota pre razgovora smanjuje stopu kupovine za >79%.
  - *Sinteza:* okvir za diskusiju o tome zašto naši chatbotovi postižu visoku
    konverziju (61.4% Atlas sales chatbot) i za etičko pitanje transparentnosti.
- **[@schanke2021]** Schanke, Burtch, Ray (2021), *Information Systems Research*
  32(3):736–751, „Estimating the Impact of ‘Humanizing’ Customer Service
  Chatbots". DOI: 10.1287/isre.2021.1015.

  - Izvor: humanizacija bota (humor, društvenost, personalizacija) povećava
    prihvatanje, ali uz kompromise (npr. veća osetljivost na cenu).
  - *Sinteza:* dizajn-varijable koje utiču na ishode; kontekstualizuje naše
    rezultate angažmana i konverzacije.
- **[@nicolescu2022]** Nicolescu, Tudorache (2022), *Electronics* 11(10):1579,
  „Human-Computer Interaction in Customer Service: The Experience with AI
  Chatbots — A Systematic Literature Review". DOI: 10.3390/electronics11101579.

  - Izvor: sistematski pregled iskustva korisnika sa chatbotovima u korisničkoj
    podršci; mapira dimenzije kvaliteta i faktore prihvatanja.
  - *Sinteza:* pregledni „krovni" izvor za uvod u klaster A i za pozicioniranje
    domena korisničke podrške.

## Klaster B — Glasovni agenti (voicebots) i automatizacija kontakt centara

Relevantno za: Atlas24h AI Sales Voicebot (outbound) i AI Customer Service
Voicebot (inbound, deflection 49.3%).

- **[@wang2023]** Wang, Huang, Hong, Liu, Guo, Chen (2023), *Production and
  Operations Management* 32(4):1002–1018, „Voice-based AI in Call Center
  Customer Service: A Natural Field Experiment". DOI: 10.1111/poms.13953.

  - Izvor: prirodni terenski eksperiment sa glasovnim AI u kol-centru; za
    jednostavne zahteve AI smanjuje pritužbe, dok kod složenih klijenti „uče"
    iz ranije interakcije s AI-jem.
  - *Sinteza:* najbliži akademski pandan našem inbound voicebot slučaju;
    okvir za tumačenje deflection stope i granice automatizacije po složenosti.
- **[@zhang2026]** Zhang, Narayandas (2026), *Management Science* 72(1):73–95,
  „Engaging Customers with AI in Online Chats: Evidence from a Randomized Field
  Experiment". DOI: 10.1287/mnsc.2022.03920.

  - Izvor: randomizovani terenski eksperiment; AI-asistirani agenti brži i
    efikasniji, najveći dobitak kod manje iskusnih agenata (empatija, rešenje).
  - *Sinteza:* podupire tezu o povećanju kapaciteta bez novog zapošljavanja;
    premošćuje klaster A i B (chat + asistencija agentu).

## Klaster C — AI u zdravstvu: konverzacioni agenti / chatbotovi

Relevantno za: HealthMedic AI Healthcare Chatbot (zakazivanje 37% upita,
poliklinika NS, 24/7).

- **[@laranjo2018]** Laranjo et al. (2018), *JAMIA* 25(9):1248–1258,
  „Conversational Agents in Healthcare: A Systematic Review".
  DOI: 10.1093/jamia/ocy072.

  - Izvor: sistematski pregled; oblast u ranoj fazi, studije uglavnom
    kvazi-eksperimentalne, retko mere efikasnost/bezbednost.
  - *Sinteza:* utvrđuje da nedostaju primenjene produkcione studije — direktno
    ka praznini koju naš HealthMedic slučaj popunjava.
- **[@milneives2020]** Milne-Ives et al. (2020), *JMIR* 22(10):e20346,
  „The Effectiveness of Artificial Intelligence Conversational Agents in Health
  Care: Systematic Review". DOI: 10.2196/20346.

  - Izvor: dokazi pretežno pozitivni/mešoviti; upotrebljivost i zadovoljstvo
    visoki, efikasnost pozitivna u ~3/4 studija, uz istaknuta ograničenja.
  - *Sinteza:* referentna tačka za naše rezultate zadovoljstva (96.8% bez
    negativnog sentimenta) i za okvir zakazivanja/trijaže.

## Klaster D — AI adopcija u malim i srednjim preduzećima (MSP)

Relevantno za: kontekst MSP u Srbiji, uvođenje bez novih zaposlenih, ušteda.

- **[@oldemeyer2024]** Oldemeyer, Jede, Teuteberg (2024), *Management Review
  Quarterly* 75(2):1185–1227, „Investigation of Artificial Intelligence in
  SMEs: A Systematic Review…". DOI: 10.1007/s11301-024-00405-4.

  - Izvor: najčešće barijere adopcije — nedostatak znanja, troškovi, neadekvatna
    infrastruktura (društveni, ekonomski, tehnološki aspekti).
  - *Sinteza:* okvir barijera naspram kojeg pozicioniramo uspešnu produkcionu
    adopciju u konkretnom MSP-u.
- **[@schwaeke2024]** Schwaeke, Peters, Kanbach, Kraus, Jones (2024), *Journal
  of Small Business Management* 63(3):1297–1331, „The New Normal: The Status
  Quo of AI Adoption in SMEs". DOI: 10.1080/00472778.2024.2379999.

  - Izvor: literatura fragmentisana; nejasno kako MSP zaista koriste AI —
    poziv na više empirijskih, kontekstualnih studija.
  - *Sinteza:* eksplicitno artikuliše prazninu (nedostatak konkretnih „kako")
    koju naša primenjena studija slučaja adresira.
- **[@zuferi2026toerbv]** Zuferi, Kreppein, Fischer (2026), *HCI in Business,
  Government and Organizations* (LNCS), 308–326, „Iterative TOE-RBV-Based AI
  Integration Framework for Resource-Constrained SMEs in the EU".
  DOI: 10.1007/978-3-032-30044-7_19.

  - Izvor: integracioni okvir za uvođenje AI u resursno ograničenim MSP-ovima
    u EU; kombinuje Technology-Organization-Environment (TOE) i Resource-Based
    View (RBV) kroz iterativni Plan-Do-Check-Act ciklus.
  - *Sinteza:* TOE-RBV teorijski okvir koji je autor predložio (dopunski izvor);
    pozicionira Atlas24h adopciju u resursno ograničenom MSP kontekstu
    (tehnološki/organizacioni/okruženjski faktori + sopstveni resursi/kapaciteti).

## Klaster E — Metodologija studije slučaja / praktičarsko istraživanje

Relevantno za: opravdanje dizajna (studija slučaja), tretman konflikta interesa
(autor = implementator, produkcioni podaci bez kontrolne grupe).

- **[@runeson2009]** Runeson, Höst (2009), *Empirical Software Engineering*
  14(2):131–164, „Guidelines for Conducting and Reporting Case Study Research
  in Software Engineering". DOI: 10.1007/s10664-008-9102-8.

  - Izvor: smernice za sprovođenje/izveštavanje studija slučaja u softverskom
    inženjerstvu (dizajn, prikupljanje podataka, validnost, pretnje validnosti).
  - *Sinteza:* metodološki oslonac za sekciju Metod i za eksplicitno navođenje
    pretnji validnosti (uklj. konflikt interesa i izostanak kontrolne grupe).
- **[@rashid2019]** Rashid, Rashid, Warraich, Sabir, Waseem (2019),
  *International Journal of Qualitative Methods* 18, „Case Study Method: A
  Step-by-Step Guide for Business Researchers". DOI: 10.1177/1609406919862424.

  - Izvor: sistematski vodič kroz faze studije slučaja u poslovnim istraživanjima.
  - *Sinteza:* dodatna metodološka referenca za poslovni/MSP kontekst; podupire
    strukturu opisa slučajeva.

## Predlog strukture Related Work sekcije (redosled + gap analiza)

Redosled ide od šireg fenomena ka konkretnoj praznini koju rad popunjava:

1. **AI konverzacioni agenti u prodaji i podršci** (Klaster A) — postaviti
   fenomen i dokaze o efektima (konverzija, angažman, otkrivanje identiteta).
2. **Glasovni agenti i automatizacija kontakt centara** (Klaster B) — proširiti
   na glasovni modalitet; terenski eksperimenti kao najbliži akademski dokazi.
3. **AI u zdravstvu** (Klaster C) — domenska specifičnost (zakazivanje/trijaža),
   pregledi pokazuju manjak primenjenih produkcionih studija.
4. **AI adopcija u MSP** (Klaster D) — organizacioni kontekst; barijere i
   fragmentisana empirija.
5. **Metodologija studije slučaja / praktičarsko istraživanje** (Klaster E) —
   opravdati dizajn i transparentno tretirati konflikt interesa.

**Gap analiza (prazina koju rad popunjava):** postojeća literatura ili (i) meri
efekte u kontrolisanim/eksperimentalnim uslovima (Klaster A/B) bez uvida u
dugoročne produkcione ishode, ili (ii) u zdravstvu i MSP kontekstu poziva na
više primenjenih, kontekstualnih studija (Klaster C/D). Nedostaje **primenjena,
višedomenska (roadside + zdravstvo), višemodalna (sales chatbot, sales voicebot,
customer-service voicebot, healthcare chatbot) studija slučaja iz stvarne
produkcije MSP-a u Srbiji**, sa merljivim ishodima. Naš rad popunjava tu
prazninu — uz eksplicitno priznanje ograničenja (konflikt interesa, bez
nezavisne verifikacije i kontrolne grupe), metodološki uokviren Klasterom E.

## Klaster F — Sopstveni prethodni radovi autora (self-citation)

VERIFIKOVANO preko Crossref (autori, venue, godina, strane, DOI se poklapaju).
Luka Vidaković je koautor sva tri; isti tim (FTN Novi Sad: Stojanović, Pavković,
Četić, Krunić, Vidaković).

- **[@stojanovic2024telfor]** (2024), *TELFOR 2024*, 1–4. „Unit Test Generation
  Multi-Agent AI System…". DOI: 10.1109/TELFOR63250.2024.10819096.
  - *Sinteza:* raniji rad tima o VIŠE-AGENTSKIM AI sistemima → kontinuitet ka
    agentskoj arhitekturi našeg chatbota. Uvod + Arhitektura.
- **[@stojanovic2025aws]** (2025), *ZINC 2025*, 20–24. „Comparison of AWS
  Architectures for Scalable and Cost-Efficient RAG".
  DOI: 10.1109/ZINC65316.2025.11100283.
  - *Sinteza:* opravdava arhitektonske izbore (RAG na AWS, FAISS/Bedrock) u
    sekciji Arhitektura — dizajn zasnovan na ranijoj evaluaciji, ne ad hoc.
- **[@vidakovic2025docker]** (2025), *ZINC 2025*, 1–5. „Comparative Analysis of
  Docker and Python Runtimes for AWS Lambda in RAG-Based AI Solutions"
  (Vidaković PRVI autor). DOI: 10.1109/ZINC65316.2025.11103568.
  - *Sinteza:* opravdava izbore runtime-a (Lambda u kb-onboarding/data-platform).
    Arhitektura / Metod. Kao prvi autor — najjača self-citation.

### Kako self-citation jača rad (strategija)

1. **Kontinuitet** — rad je deo programa (agenti → RAG → AWS runtime →
   produkciona primena), nije izolovan. 3 self-citata su umereni, ne preterivanje.
2. **Tehnička verodostojnost** — arhitektonske/implementacione tvrdnje (RAG,
   FAISS, Lambda runtime, agentski dizajn) oslonjene na timsku recenziranu
   evaluaciju, ne „iz vazduha".
3. **Pozicioniranje doprinosa** — raniji radovi su eksperimentalni/uporedni
   (lab); OVAJ je prvi PRIMENJENI, PRODUKCIONI korak istog programa (od
   evaluacije arhitekture ka stvarnim poslovnim ishodima). Iskorak je deo gap
   analize.

Oprez (integritet): self-citation samo gde je STVARNO relevantno (arhitektura,
RAG, runtime, agenti). Ne trpati sva tri u svaku sekciju, ne preuveličavati vezu.

## Klaster G — Tehničke reference (arhitektura)

Relevantno za: sekcija Sistem/Arhitektura (chatbot na AWS Bedrock AgentCore +
Strands, RAG/FAISS iz kb-onboarding, data-platform sa Bedrock Nova + Tool Use).
Cilj: tehničke tvrdnje oslonjene na verifikovane izvore, ne „iz vazduha".

- **[@lewis2020rag]** Lewis, Perez, Piktus, Petroni, Karpukhin, Goyal, Küttler,
  Lewis, Yih, Rocktäschel, Riedel, Kiela (2020), *NeurIPS 33*, „Retrieval-Augmented
  Generation for Knowledge-Intensive NLP Tasks". arXiv:2005.11401
  (DOI 10.48550/arXiv.2005.11401). VERIFIKOVANO: arXiv stranica navodi „Accepted
  at NeurIPS 2020"; potpuna lista od 12 autora potvrđena sa arXiv-a.

  - Izvor: uvodi RAG — kombinacija parametarske (seq2seq LLM) i neparametarske
    memorije (gust vektorski indeks, npr. Wikipedia) preko neuralnog retrivera.
  - *Sinteza:* temeljni izvor za RAG pristup u kb-onboarding (chatbot odgovara
    iz kontrolisanog KB-a, ne halucinira cene/informacije).

- **[@johnson2021faiss]** Johnson, Douze, Jégou (2021), *IEEE Transactions on
  Big Data* 7(3):535–547, „Billion-Scale Similarity Search with GPUs".
  DOI: 10.1109/TBDATA.2019.2921572. VERIFIKOVANO Crossref (online 2019,
  štampano izdanje 7(3) 2021 — godina 2021 zadržana po štampanom izdanju).

  - Izvor: FAISS — biblioteka za efikasnu pretragu sličnosti (nearest-neighbor)
    nad milijardama vektora, uz GPU ubrzanje.
  - *Sinteza:* opravdava izbor FAISS indeksa u kb-onboarding RAG pipeline-u.

- **[@vaswani2017attention]** Vaswani, Shazeer, Parmar, Uszkoreit, Jones, Gomez,
  Kaiser, Polosukhin (2017), *NeurIPS 30*, „Attention Is All You Need".
  arXiv:1706.03762 (DOI 10.48550/arXiv.1706.03762). VERIFIKOVANO: arXiv +
  NeurIPS 2017; 8 autora potvrđeno.

  - Izvor: uvodi Transformer arhitekturu (self-attention), temelj savremenih LLM.
  - *Sinteza:* osnovni LLM/transformer izvor za pozadinu Bedrock/Nova modela.
    (Odabran kao (c) — transformer temelj; tool-use/function-calling opisan je
    kroz zvaničnu AWS Nova dokumentaciju [@awsnova], koja eksplicitno navodi
    „tool use (function calling)".)

- **[@awsbedrock]** Amazon Web Services, „Amazon Bedrock User Guide — Overview".
  @misc, url + urldate 2026-09-17. Zvanična dokumentacija (nema DOI).
  VERIFIKOVANO: stranica otvorena 2026-09-17
  (docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html).

  - *Sinteza:* referenca za platformu na kojoj radi customer-agent (Bedrock
    AgentCore, upravljani pristup foundation modelima).

- **[@awsnova]** Amazon Web Services, „What is Amazon Nova? — User Guide".
  @misc, url + urldate 2026-09-17. Zvanična dokumentacija (nema DOI).
  VERIFIKOVANO: stranica otvorena 2026-09-17
  (docs.aws.amazon.com/nova/latest/userguide/what-is-nova.html). Potvrđeno:
  Nova Pro model ID `amazon.nova-pro-v1:0`, podržava RAG i agentske aplikacije;
  Nova podržava tool use (function calling).

  - *Sinteza:* referenca za model koji koristi customer-agent (default
    `eu.amazon.nova-pro-v1:0`) i data-platform analiza (Bedrock Nova + Tool Use).

## TODO / neverifikovano (za dalju proveru)

- `[@luo2019]` — DOI, autori, naslov, journal, godina POTVRĐENI (Crossref).
  Volume/broj/strane NISU u Crossref-u; javno se navode kao *Marketing Science*
  38(6):937–947. U `references.bib` upisano sa `% TODO` — potvrditi kod izdavača
  pre finalne predaje.
- `[@rashid2019]` — SAGE članak koristi article-number (1609406919862424) umesto
  klasične paginacije; upisano `pages = {1--13}` kao uobičajena dužina — po
  potrebi zameniti zvaničnom paginacijom PDF-a.
- **[@lewis2020rag] / [@vaswani2017attention]** — DOI koji je upisan je arXiv
  DataCite DOI (10.48550/arXiv...). Strane NeurIPS zbornika (`9459--9474`,
  `5998--6008`) su uobičajeno navođene vrednosti — potvrditi tačnu paginaciju iz
  zvaničnog NeurIPS proceedings PDF-a pre finalne predaje ako se citira po
  stranama. Naslovi/autori/godine/venue su verifikovani (arXiv + „Accepted at
  NeurIPS 2020" / NeurIPS 2017).
- **[@schwaeke2024]** — godina: Crossref navodi online-first 2024-08-13, a
  štampano izdanje 63(3) je 2025. Zadržano `year = {2024}` (issued date); ako
  ciljni šablon zahteva godinu štampanog izdanja, promeniti u 2025.
- **[@zuferi2026toerbv]** — Crossref navodi godinu 2026 (LNCS zbornik) i tip
  book-chapter, strane 308–326. Verifikovano; ako je potrebno, dodati ISBN
  (9783032300447) i editore iz zvaničnog LNCS izdanja.
- **Isabella et al. (2025), *Journal of Business Research* — chatbot naspram
  landing page (konverzija)** — NEVERIFIKOVANO / NIJE NAĐENO. Pretraga
  (web_search) NIJE vratila rad koji se pouzdano poklapa sa opisom „Isabella et
  al. 2025, JBR, chatbot vs landing page konverzija". NE dodajem BibTeX (integritet
  — ne izmišljam). TODO za autora/ls-researcher: potvrditi tačan navod (pun
  naslov, DOI ili link) ili proveriti da li je autor mislio na drugi izvor
  (npr. drugi časopis, drugu godinu, ili prezime slično „Isabella"). Bez toga
  ne ide u `references.bib`.
