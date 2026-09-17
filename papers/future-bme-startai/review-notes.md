# Peer Review — Future-BME rad (Atlas24h AI Sales Chatbot)

- **Rad:** `papers/future-bme-startai/paper.md`
- **Naslov:** "An AI Sales Chatbot as a Measurable Sales Channel: A Production Case Study in an SME"
- **Autor:** Luka Vidaković (FTN, Novi Sad)
- **Ciljni skup:** Future-BME (međunarodna konferencija, engleski, 5–8 strana)
- **Grana:** feature/paper-future-bme
- **Recenzent:** ls-reviewer
- **Datum:** 2026-09-17
- **Krug:** nezavisan pregled trenutne verzije od nule; verovatno završni krug pre PR-a (ceo izveštaj prepisan, istorija u Gitu)

## Opšti sud

Rad je spreman za predaju. Koherentan je, pošten i tehnički verodostojan. Teza
(AI sales chatbot pretvara nemonetizovan informativni kanal u merljiv prodajni
kanal) provlači se dosledno kroz apstrakt → uvod → metod → rezultate →
diskusiju → zaključak. Sve ključne brojke su sledljive do `research-notes.md`
(produkcioni case study) i međusobno aritmetički konzistentne — uključujući novu
kolonu konverzije u @tbl:rast i usaglašenu vrednost close rate-a (72,5%).
Konflikt interesa i izostanak kontrolne grupe nisu sakriveni nego eksplicitno
izneti kao pretnje validnosti (posebna pod-sekcija + Ograničenja). Struktura je
kompletna, cross-referencije i citiranje (u oba smera) ispravni. Novi pasusi u
§Discussion (in-chat vs follow-up levak; SME implikacije) uokvireni su kao
HIPOTEZA i ne prelaze u nepotkrepljene tvrdnje.

Nema kritičnih ni važnih (blokirajućih) zamerki. Preostale stavke su manje
(stilske/interpretativne nijanse) ili već poznati bibliografski TODO-ovi koji ne
predstavljaju nove mane.

---

## CRITICAL

Nema.

Provereno i potvrđeno kao ispravno:

- **Sve brojke sledljive, uklj. novu kolonu konverzije.** Rast prodaje
  196 → 558 → 1.705 i prihod 15.200 → 38.700 → 113.722 EUR (@tbl:rast i §Results)
  doslovno se poklapaju sa growth trajectory u `research-notes.md` (§1). Nova
  kolona konverzije 42,8% / 42,9% / 61,4% takođe se poklapa sa izvorom
  ("Conversion rate: — / 42.8% / 42.9% / 61.4%") i sa nezavisno preračunatim
  vrednostima: 196/458 = 42,79%, 558/1301 = 42,89%, 1.705/2.776 = 61,42%.
- **Close rate 72,5% dosledan i tačan.** 559/771 = 72,50%; rad sada koristi
  "72.5%" na svim mestima (apstrakt-nezavisno, §Results i §Discussion), čime je
  uklonjena ranija nedoslednost sa "73%". Follow-up grana 1.146/2.005 = 57,16% →
  "57%"; razlika ≈ 15,3 pp, što rad naziva "roughly fifteen percentage points".
- **Aritmetika levka verifikovana.** 559 + 1.146 = 1.705 (poklapa se sa ukupnim
  prodajama u julu); 63% rešeno bez ljudske intervencije — svi iz
  `research-notes.md`, raspodela ishoda jul 2026.
- **Konflikt interesa i kontrolna grupa** tretirani eksplicitno i konzervativno
  (@sec:conflict-of-interest + @sec:limitations): autor = implementator, podaci
  produkcioni bez nezavisne revizije, bez kontrolne grupe, jedan slučaj/domen.
  Tvrdnja o inkrementalnosti oslonjena je na stabilan ljudski učinak (-3,8% g/g),
  ne na kauzalni zaključak — metodološki korektno.
- **Novi §Discussion pasusi NE prelaze u overclaiming.** Pasus o levku koristi
  "is most readily explained by", "points in the same direction", "consistent
  with"; pasus o SME implikacijama izričito se zatvara rečenicom da počiva na
  jednom slučaju bez kontrolne grupe i "should be treated as a hypothesis for
  other settings rather than a general result". Nema kauzalne tvrdnje.

## IMPORTANT

Nema.

Provereno i potvrđeno kao ispravno:

- **Koherentnost apstrakt ↔ uvod ↔ zaključak.** Apstrakt najavljuje arhitekturu,
  definicije mera, tri meseca produkcije i ograničenja; uvod ponavlja trojni
  doprinos; zaključak zatvara iste tri tačke sa istim brojkama (43%→61%,
  113.722 EUR). Nema nesaglasja.
- **Struktura kompletna.** Introduction → Related Work (agenti u prodaji/podršci,
  adopcija u MSP, metodologija studije slučaja, Gap) → System and Architecture →
  Method (metric definitions, data sources, conflict of interest) → Results →
  Discussion (+ Limitations) → Conclusion → References. Logičan tok, bez praznina.
- **Definicije metrika prisutne pre upotrebe** (@sec:metric-definitions):
  qualified lead, conversion, confirmed sale, "resolved without human
  intervention", "close rate". Svaka metrika koja se pojavljuje u Results ima
  definiciju.
- **Citiranje integritet, oba smera.** Svih 16 jedinstvenih in-text ključeva
  (luo2019, schanke2021, nicolescu2022, oldemeyer2024, schwaeke2024,
  zuferi2026toerbv, runeson2009, rashid2019, stojanovic2024telfor,
  stojanovic2025aws, vidakovic2025docker, awsbedrock, awsnova,
  vaswani2017attention, lewis2020rag, johnson2021faiss) ima unos u
  `references.bib`. Neiskorišćeni unosi (4): `wang2023`, `zhang2026`,
  `laranjo2018`, `milneives2020` — svi eksplicitno označeni komentarom
  "Rezervisano za master #16 — namerno necitiran". Namerno zadržani, ne greška.
- **Cross-reference validni.** Svih 6 upotrebljenih referenci (@fig:arhitektura,
  @tbl:rast, @sec:method, @sec:system, @sec:conflict-of-interest,
  @sec:limitations) pokazuje na definisane labele. Nema visećih referenci.
- **SVG figura na engleskom.** `figures/arhitektura.svg` — svi labeli (User (web
  chat), Conversational agent, Session management, Agentic step, RAG (FAISS),
  In-conversation purchase, Notification service, Conversation export, Data
  platform, Metric aggregation, Measurable outcomes) na engleskom; usklađeno sa
  jezikom rada.

## MINOR

1. **Uporedivost dve grane levka (in-chat 72,5% vs follow-up 57%) — nijansa
   selekcije.**
   Ukotvljeno: §Discussion, pasus koji razliku od ~15 pp objašnjava trenutkom
   kupovine ("most readily explained by the point at which the purchase
   happens"). Zašto se pominje: dve grane možda nisu potpuno uporedive populacije
   — korisnik koji završi kupovinu u chatu po definiciji ima jaču/neposredniju
   nameru od onoga koji ostavlja kontakt za kasnije, pa deo razlike može biti
   efekat selekcije, a ne samo trenutak transakcije. Rad ovo NE imenuje
   eksplicitno. Nije mana argumenta (pasus je već uokviren kao hipoteza i
   oprezan), ali predlog: jedna polurečenica koja priznaje da se grane razlikuju
   i po nameri korisnika dodatno bi ojačala interpretaciju. Opciono.

2. **Zaokruživanje 42,8% → "43%" u naraciji.**
   Ukotvljeno: apstrakt i §Results/§Discussion ("from 43% to 61%"). Ovo je
   sada eksplicitno razjašnjeno u §Results dodatom napomenom da je konverzija
   ostala ~43% u maju (42,8%) i junu (42,9%), a skok na 61,4% nastaje u julu —
   "a May-to-July change rather than a month-over-month increase". Time je ranija
   MINOR zamerka rešena; napomena je tačna i dovoljna. Nema dalje akcije.

3. **Dužina rada — pri donjoj/srednjoj granici opsega 5–8 strana.**
   Ukotvljeno: telo ~2.300 reči + apstrakt + jedna tabela (sada sa 4 kolone) +
   jedna figura + ~20 referenci. Prošireni §Discussion (dva nova pasusa) pomera
   rad ka sredini opsega. U dvokolonskom formatu tipično ~6 strana, dakle unutar
   5–8. Tačan broj strana NIJE verifikovan (build nije rađen). Bez akcije osim
   ako recenzentski format traži bliže gornjoj granici.

4. **Poznati bibliografski TODO-ovi (nasleđeni, NISU nove mane).**
   Navedeni kao poznate otvorene stavke iz `references.bib`/`research-notes.md`,
   ne kao defekti otkriveni u ovom krugu:
   - `luo2019` — broj sveske (issue 6) nije nezavisno potvrđen (Crossref/OpenAlex/S2
     ga ne navode; DBLP/INFORMS nedostupni preko API-ja). Volume 38 i strane
     937–947 potvrđeni. Zadržano `number = {6}` uz TODO; potvrditi kod izdavača
     (INFORMS) pre finalne verzije ako je izvodljivo.
   - `Isabella et al. (2025), Journal of Business Research` (chatbot vs landing
     page) — nije pouzdano identifikovan pretragom, NIJE dodat u `.bib`
     (integritet — ne izmišljati izvor). Ostaje TODO za autora: potvrditi tačan
     navod ili odustati. Ne blokira predaju jer se ne citira.
   Finalizovano ranije i potvrđeno ispravnim u ovom krugu: oldemeyer2024 →
   2025/75(2):1185–1227; schwaeke2024 → 2025/63(3):1297–1331; rashid2019 →
   article-number 1609406919862424 (bez raspona strana); lewis2020rag → NeurIPS
   strane 9459–9474; vaswani2017attention → strane izostavljene (zvanični NeurIPS
   BibTeX ima prazno `pages`). Sve u skladu sa statusom verifikacije u
   `research-notes.md`.

## Priority summary

| Prioritet | Broj nalaza | Sažetak |
|-----------|-------------|---------|
| CRITICAL  | 0           | Nema. Brojke (uklj. kolonu konverzije i 72,5%), konflikt interesa i tvrdnje verifikovani. |
| IMPORTANT | 0           | Nema. Koherentnost, struktura, citiranje, cross-ref, SVG — ispravni; novi Discussion pasusi uokvireni kao hipoteza. |
| MINOR     | 4           | Nijansa selekcije u poređenju grana levka (opciono); zaokruživanje 43% već razjašnjeno u tekstu; dužina pri sredini opsega; poznati bib TODO-ovi (luo2019 issue, Isabella nije nađen). |

## Checklist coverage

1. **Sadržaj / argumentacija** — provereno: koherentnost apstrakt↔uvod↔zaključak
   (OK); nema overclaiminga (oprezan jezik; novi §Discussion pasusi eksplicitno
   uokvireni kao hipoteza); konflikt interesa + izostanak kontrolne grupe
   eksplicitni; metod jasan i ponovljiv (definicije mera + izvori podataka); SVE
   brojke sledljive i aritmetički tačne, uključujući novu kolonu konverzije
   (42,8/42,9/61,4) i 72,5% (559/771). Jedina nijansa: uporedivost grana levka
   (MINOR 1).
2. **Struktura + 5–8 strana** — sve očekivane sekcije prisutne i logično povezane;
   dužina unutar opsega, prošireni Discussion pomera ka sredini (MINOR 3; tačan
   broj strana neproveren — build nije rađen).
3. **Citiranje integritet (oba smera)** — svih 16 in-text ključeva ima unos;
   4 neiskorišćena unosa namerno rezervisana za master #16 (označeni); poznati
   TODO metapodaci (luo2019 issue, Isabella nije nađen) navedeni kao poznate
   stavke (MINOR 4), ne kao nove mane.
4. **Cross-ref @sec/@tbl/@fig** — svih 6 upotrebljenih validni, pokazuju na
   definisane labele.
5. **Stil / SME doslednost / AI slop / SVG / metrike** — terminologija dosledna
   ("AI sales chatbot", "SME", "data platform"); nema AI slopa (nema em-dash
   umetaka kao stilskog trika, nema emoji-ja ni klišea); SVG na engleskom; sve
   metrike definisane pre upotrebe.

## Finalna procena spremnosti

**SPREMAN ZA PR / predaju** (uz jednu opcionu manju reviziju).

Rad je suštinski i formalno spreman. Nema kritičnih ni važnih zamerki: brojke su
verifikovane (uključujući novu kolonu konverzije i usaglašeni close rate 72,5%),
argumentacija poštena, novi §Discussion pasusi ostaju u granicama hipoteze,
struktura i citiranje ispravni, cross-ref i SVG uredni. Preostale MINOR stavke su
opcione (polurečenica o selekciji između grana levka; eventualno širenje ka
gornjoj granici strana) ili nasleđeni bibliografski TODO-ovi (luo2019 issue kod
izdavača; Isabella izvor — potvrditi ili izostaviti) koji ne blokiraju predaju.
Preporuka: otvoriti PR sada; luo2019 issue rešiti pre finalne verzije ako je
izvodljivo, ostalo po nahođenju autora.
