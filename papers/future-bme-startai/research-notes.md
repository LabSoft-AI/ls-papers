# Istraživačke beleške: Future-BME rad (StartAI studija slučaja)

> Autor: Luka Vidaković. Ovo je radni dokument (ne ulazi u build). Sve brojke
> ispod su iz stvarnih StartAI materijala u `~/github/work/world/sales/startai/`.
> Svaki podatak je označen izvorom. Ništa nije izmišljeno.
>
> KONFLIKT INTERESA: autor je implementator sistema (StartAI). Svi podaci su
> produkcioni podaci samog StartAI-ja, bez nezavisne verifikacije i bez kontrolne
> grupe. Ovo mora biti eksplicitno navedeno u radu (sekcija Ograničenja).

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

## Četiri slučaja (potencijalni materijal za komparaciju)

### 1. Atlas24h — AI Sales Chatbot (web chat)
- Period: rast maj→jul 2026.
- Jul 2026: €113,722 verifikovanog prihoda, 1,705 potvrđenih prodaja (API),
  2,776 kvalifikovanih leadova, konverzija 61.4%.
- Rast: maj 196 prodaja / €15,200; jun 558 / €38,700; jul 1,705 / €113,722.
- Konverzija skočila 43%→61% nakon omogućavanja kupovine u chatu.
- Doprinos AI kanala ukupnoj prodaji (jul 2026): 1,811 od 3,905 (46.4%);
  ljudski call centar ravno na 2,094 (-3.8% g/g).

### 2. Atlas24h — AI Sales Voicebot (outbound, autonoman)
- Period: 25 dana (lansiran 6. jul 2026).
- 143 završene prodaje, 2,209 poziva, konverzija 6.5%, 0 ljudi u zatvaranju.
- Prosečan uspešan poziv 2.5 min; dominantan proizvod Internacionalni+ (128/143).
- 88 poziva/dan vs. 40–60 kod ljudskog agenta; radi noću i vikendom.

### 3. Atlas24h — AI Customer Service Voicebot (inbound)
- Jul 2026: 4,223 poziva obradio AI, 2,081 rešeno bez čoveka (deflection 49.3%).
- Kontekst: obim poziva 13,809 (jul 2025) → 21,009 (jul 2026), +52.1%.
- Ljudski sales output ostao stabilan (2,177→2,094, -3.8%), 0 novih agenata,
  ušteda €200K+/god. Peak: 519 poziva u satu (9h), prosečno trajanje 58.5s.
- Kategorije: status članstva 1,847 (65% AI), roadside 1,109 (45%),
  cene 689 (55%), prodajne prilike 578 (sve prosleđene čoveku).

### 4. HealthMedic — AI Healthcare Chatbot (web chat, poliklinika NS)
- Period: mart–avgust 2026 (2,032 analizirane konverzije).
- 2,068 pacijentskih konverzacija, 751 zahtev za termin (37% svih),
  96.8% konverzacija bez negativnog sentimenta, 24/7.
- Mesečni rast: mart 179 → avgust 414 konverzacija.
- Tipovi upita: termin 751 (37%), cene 644 (32%), usluge 230 (11%),
  medicinske info 171 (8%), lekari 121 (6%).

## Skica ugla za Future-BME (5–8 strana)

Moguć okvir: primenjena studija slučaja o uvođenju AI agenata (chat + glas) u
MSP okruženju u Srbiji, kroz dva domena (roadside assistance / Atlas24h i
zdravstvo / HealthMedic) i tri modaliteta (sales chatbot, sales voicebot,
customer-service voicebot, healthcare chatbot).

Teza: AI agenti povećavaju kapacitet (obim, dostupnost 24/7) bez povećanja broja
zaposlenih, uz merljive produkcione ishode.

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
- [x] ls-researcher: related work + BibTeX u `references.bib`. (v. sekciju
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

## TODO / neverifikovano (za dalju proveru)

- `[@luo2019]` — DOI, autori, naslov, journal, godina POTVRĐENI (Crossref).
  Volume/broj/strane NISU u Crossref-u; javno se navode kao *Marketing Science*
  38(6):937–947. U `references.bib` upisano sa `% TODO` — potvrditi kod izdavača
  pre finalne predaje.
- `[@rashid2019]` — SAGE članak koristi article-number (1609406919862424) umesto
  klasične paginacije; upisano `pages = {1--13}` kao uobičajena dužina — po
  potrebi zameniti zvaničnom paginacijom PDF-a.
