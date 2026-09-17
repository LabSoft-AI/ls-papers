# Peer Review — Future-BME rad (Atlas24h AI Sales Chatbot)

- **Rad:** `papers/future-bme-startai/paper.md`
- **Naslov:** "An AI Sales Chatbot as a Measurable Sales Channel: A Production Case Study in an SME"
- **Autor:** Luka Vidaković (FTN, Novi Sad)
- **Ciljni skup:** Future-BME (međunarodna konferencija, engleski, 5–8 strana)
- **Grana:** feature/paper-future-bme
- **Recenzent:** ls-reviewer
- **Datum:** 2026-09-17
- **Krug:** nezavisan pregled trenutne verzije (prethodni nalazi I1/I2/I3 zatvoreni; ovaj izveštaj prepisan od nule)

## Opšti sud

Rad je koherentan, pošten i tehnički verodostojan. Teza (AI sales chatbot
pretvara nemonetizovan informativni kanal u merljiv prodajni kanal) provlači se
dosledno kroz apstrakt → uvod → metod → rezultate → zaključak. Sve ključne
brojke su sledljive do `research-notes.md` (produkcioni case study) i međusobno
aritmetički konzistentne. Konflikt interesa i izostanak kontrolne grupe nisu
sakriveni nego eksplicitno izneti kao pretnje validnosti (posebna pod-sekcija +
Ograničenja). Struktura je kompletna, cross-referencije i citiranje (u oba
smera) su ispravni. Ranije zatvoreni nalazi (definicija "resolved without human
intervention", definicija "close rate" + 57% poređenje, apstrakt prihod u tri
tačke) potvrđeni kao razrešeni u trenutnom tekstu.

Nema kritičnih ni važnih (blokirajućih) zamerki. Preostale stavke su manje
(stilske/kozmetičke) ili već poznati bibliografski TODO-ovi koji ne predstavljaju
nove mane.

---

## CRITICAL

Nema.

Provereno i potvrđeno kao ispravno:

- **Sve brojke sledljive.** Rast prodaje 196 → 558 → 1.705 i prihod 15.200 →
  38.700 → 113.722 EUR (@tbl:rast i tekst §Results) doslovno se poklapaju sa
  growth trajectory u `research-notes.md` (§1, Atlas24h AI Sales Chatbot).
- **Aritmetika levka verifikovana.** 1.705 / 2.776 = 61,4% (tekst navodi 61,4%);
  559 + 1.146 = 1.705 (poklapa se sa ukupnim prodajama u julu); close rate in-chat
  559/771 = 72,5% (tekst i izvor zaokružuju na 73%); follow-up 1.146/2.005 = 57,2%
  (tekst: 57%); 63% rešeno bez ljudske intervencije — svi iz `research-notes.md`,
  raspodela ishoda jul 2026.
- **Konflikt interesa i kontrolna grupa** tretirani eksplicitno i konzervativno
  (@sec:conflict-of-interest + @sec:limitations): autor = implementator, podaci
  su produkcioni bez nezavisne revizije, bez kontrolne grupe, jedan slučaj/domen.
  Tvrdnja o inkrementalnosti oslonjena je na stabilan ljudski učinak (-3,8% g/g),
  a ne na kauzalni zaključak — što je metodološki korektno.
- **Nema overclaiminga.** Diskusija koristi oprezan jezik ("coincides in time",
  "suggests", "supports the claim") umesto tvrdnji o uzročnosti; rast se ne
  pripisuje isključivo chatbotu (seasonal/marketing efekti eksplicitno nisu
  izolovani).

## IMPORTANT

Nema.

Provereno i potvrđeno kao ispravno:

- **Koherentnost apstrakt ↔ uvod ↔ zaključak.** Apstrakt najavljuje arhitekturu,
  definicije mera, tri meseca produkcije i ograničenja; uvod ponavlja trojni
  doprinos (artefakt / definicije mera / produkcioni ishodi); zaključak zatvara
  iste tri tačke sa istim brojkama (43%→61%, 113.722 EUR). Nema nesaglasja.
- **Struktura kompletna.** Introduction → Related Work (4 pod-sekcije: agenti u
  prodaji/podršci, adopcija u MSP, metodologija studije slučaja, Gap) → System
  and Architecture → Method (metric definitions, data sources, conflict of
  interest) → Results → Discussion (+ Limitations) → Conclusion → References.
  Logičan tok, bez praznina.
- **Definicije metrika prisutne pre upotrebe** (@sec:metric-definitions):
  qualified lead, conversion, confirmed sale, "resolved without human
  intervention" (I1 — sada definisano preko data platforme), "close rate" (I2 —
  definisano po grani levka). Sve metrike koje se pojavljuju u Results imaju
  definiciju.
- **Citiranje integritet, oba smera.**
  - Svi in-text `[@key]` (16 jedinstvenih: luo2019, schanke2021, nicolescu2022,
    oldemeyer2024, schwaeke2024, zuferi2026toerbv, runeson2009, rashid2019,
    stojanovic2024telfor, stojanovic2025aws, vidakovic2025docker, awsbedrock,
    awsnova, vaswani2017attention, lewis2020rag, johnson2021faiss) imaju unos u
    `references.bib`.
  - Neiskorišćeni unosi (4): `wang2023`, `zhang2026`, `laranjo2018`,
    `milneives2020` — svi eksplicitno označeni u `.bib` komentarom "Rezervisano
    za master #16 — namerno necitiran". Namerno zadržani, ne greška.
- **Cross-reference validni.** Svi `@sec:*`, `@tbl:rast`, `@fig:arhitektura`
  pokazuju na definisane labele (#sec:method, #sec:system, #sec:limitations,
  #sec:conflict-of-interest, #tbl:rast, #fig:arhitektura). Nema visećih
  referenci.
- **SVG figura na engleskom.** `figures/arhitektura.svg` — sav tekst (User (web
  chat), Conversational agent, Session management, Agentic step, RAG (FAISS),
  In-conversation purchase, Notification service, Conversation export, Data
  platform, Measurable outcomes) je na engleskom; usklađeno sa jezikom rada.

## MINOR

1. **Zaokruživanje 42,8% → "43%" u apstraktu i tekstu (naracija).**
   Ukotvljeno: apstrakt ("increased from 43% to 61%") i §Results ("rose from 43%
   to 61%"). `research-notes.md` daje maj = 42,8%, jun = 42,9%, jul = 61,4%.
   Zašto se pominje: "43%→61%" je zapravo maj→jul (jun je takođe ~43%), pa
   "from 43% to 61%" implicira dvotačkasti skok iako je jun bio na istom nivou
   kao maj. Nije greška (zaokruživanje 42,8→43 i 61,4→61 je korektno, a tekst na
   jednom mestu i navodi precizno "61,4%"), ali predlog: u §Results razmotriti
   kratku napomenu da je jun ostao na ~43% i da skok nastaje u julu (posle
   omogućavanja kupovine), radi potpune preciznosti. Opciono.

2. **"73%" close rate — zaokruženo naviše sa 72,5%.**
   Ukotvljeno: §Results ("close rate on in-chat purchases was 73% (559 of 771...)").
   559/771 = 72,5%. Izvor (`research-notes.md`) sam navodi "73%", pa je rad
   dosledan izvoru. Standardno zaokruživanje 72,5 → 73 je prihvatljivo; pominje
   se samo radi transparentnosti (nije mana). Bez izmene, osim ako se želi
   navesti "72,5%".

3. **Dužina rada — pri donjoj granici opsega 5–8 strana.**
   Ukotvljeno: telo rada ~2.000 reči + apstrakt (~200) + jedna tabela + jedna
   figura + ~20 referenci. U dvokolonskom formatu ovo tipično daje ~5–6 strana,
   dakle unutar 5–8, ali bliže donjoj granici. Tačan broj strana NIJE verifikovan
   (nije rađen build). Predlog: ako recenzentski format traži bliže 6–7 strana,
   sekcija Discussion i/ili Architecture podnose još 1–2 pasusa bez gubitka
   fokusa. Nije obavezno.

4. **Poznati bibliografski TODO-ovi (nasleđeni, NISU nove mane).**
   Navedeni kao poznate otvorene stavke iz `references.bib`/`research-notes.md`,
   ne kao defekti otkriveni u ovom krugu:
   - `luo2019` — broj sveske (issue 6) nije nezavisno potvrđen (Crossref/OpenAlex/S2
     ga ne navode; DBLP/INFORMS nedostupni preko API-ja). Volume 38 i strane
     937–947 potvrđeni. Zadržano `number = {6}` uz TODO; potvrditi kod izdavača
     (INFORMS) pre finalne predaje.
   - `Isabella et al. (2025), Journal of Business Research` (chatbot vs landing
     page) — nije pouzdano identifikovan pretragom, NIJE dodat u `.bib`
     (integritet — ne izmišljati izvor). Ostaje TODO za autora: potvrditi tačan
     navod ili odustati. Ne blokira predaju jer se ne citira.
   Finalizovano u prethodnom krugu i potvrđeno ispravnim: oldemeyer2024 →
   2025/75(2):1185–1227; schwaeke2024 → 2025/63(3):1297–1331; rashid2019 →
   article-number 1609406919862424 (bez raspona strana); lewis2020rag → NeurIPS
   strane 9459–9474; vaswani2017attention → strane izostavljene (zvanični NeurIPS
   BibTeX ima prazno `pages`). Sve u skladu sa statusom verifikacije u
   `research-notes.md`.

## Priority summary

| Prioritet | Broj nalaza | Sažetak |
|-----------|-------------|---------|
| CRITICAL  | 0           | Nema. Brojke, konflikt interesa i tvrdnje verifikovani. |
| IMPORTANT | 0           | Nema. Koherentnost, struktura, citiranje, cross-ref, SVG — ispravni. |
| MINOR     | 4           | Zaokruživanje 43%/73% (naracija), dužina pri donjoj granici, poznati bib TODO-ovi (luo2019 issue, Isabella nije nađen). |

## Checklist coverage

1. **Sadržaj / argumentacija** — provereno: koherentnost apstrakt↔uvod↔zaključak
   (OK), nema overclaiminga (oprezan jezik u Discussion), konflikt interesa +
   izostanak kontrolne grupe eksplicitni, metod jasan i ponovljiv (definicije
   mera + izvori podataka), SVE brojke sledljive i aritmetički tačne
   (559/771/1146/2005/63%/73% + 196/558/1705, 15200/38700/113722, 61,4%).
2. **Struktura + 5–8 strana** — sve očekivane sekcije prisutne i logično povezane;
   dužina unutar opsega ali pri donjoj granici (MINOR 3; tačan broj strana
   neproveren — build nije rađen).
3. **Citiranje integritet (oba smera)** — svih 16 in-text ključeva ima unos;
   4 neiskorišćena unosa namerno rezervisana za master #16 (označeni); poznati
   TODO metapodaci navedeni kao poznate stavke (MINOR 4), ne kao nove mane.
4. **Cross-ref @sec/@tbl/@fig** — svi validni, pokazuju na definisane labele.
5. **Stil / SME doslednost / AI slop / SVG / metrike** — terminologija dosledna
   ("AI sales chatbot", "SME", "data platform"); nema AI slopa (nema em-dash
   umetaka kao stilskog trika, nema emoji-ja ni klišea); SVG na engleskom;
   sve metrike definisane pre upotrebe.

## Finalna procena spremnosti

**Spreman uz manje revizije (opciono).**

Rad je suštinski spreman za predaju. Nema kritičnih ni važnih zamerki: brojke su
verifikovane, argumentacija poštena, struktura i citiranje ispravni. Preostale
MINOR stavke su opcione (kozmetičko preciziranje zaokruživanja, eventualno
proširenje ka gornjoj granici strana) ili nasleđeni bibliografski TODO-ovi
(luo2019 issue kod izdavača; Isabella izvor — potvrditi ili izostaviti) koji ne
blokiraju predaju. Preporuka: rešiti luo2019 issue pre finalne verzije ako je
izvodljivo; ostalo po nahođenju autora.
