# Peer review — Future-BME rad (Atlas24h AI Sales Chatbot)

**Rad:** `papers/future-bme-startai/paper.md` — "An AI Sales Chatbot as a
Measurable Sales Channel: A Production Case Study in an SME"
**Autor:** Luka Vidaković · **Grana:** `feature/paper-future-bme`
**Recenzent:** ls-reviewer · **Datum:** 2026-09-17
**Tip:** konferencijski rad (Future-BME, međunarodna, 5–8 strana, engleski)

> Ovo je svež, konsolidovan izveštaj koji odražava SAMO trenutno stanje rada.
> Ranija istorija recenzije nije zadržana u ovom fajlu (dostupna je u Gitu).

## Opšti sud

Rad je u vrlo dobrom stanju i blizu je spreman za predaju. Struktura je potpuna i
logična, argumentacija je koherentna kroz apstrakt → uvod → rezultate → zaključak,
a — što je za ovakav rad ključno — ograničenja i konflikt interesa tretirani su
otvoreno i na više mesta. Citiranje je čisto u oba smera, sve unakrsne reference
pogađaju definisane labele, a sve brojke u tekstu su sledljive iz
`research-notes.md`, uključujući julsku raspodelu (559 / 1,146 / 63% / 73%).
SVG dijagram je u celosti na engleskom i usklađen sa tekstom.

Nema nalaza nivoa CRITICAL. Preostalo je nekoliko IMPORTANT/MINOR stavki koje su
uglavnom pitanja preciznosti i doslednosti, ne suštinske greške. Uz manje revizije
rad je spreman za predaju.

---

## CRITICAL

Nema.

---

## IMPORTANT

### I1. Metrika "resolved without human intervention" (63%) nije definisana

**Ukotvljeno:** @sec:results — "while 63% of all conversations were resolved
without human intervention"; ponovljeno implicitno u apstraktu preko konteksta.
Sekcija @sec:metric-definitions definiše samo *qualified lead*, *conversion* i
*confirmed sale*.

**Zašto:** rad eksplicitno insistira na proverljivosti metrika (cela sekcija
Metric definitions postoji upravo zbog toga). Uvođenje četvrte metrike ("resolved
without human intervention") u Rezultatima, bez definicije, ruši tu doslednost:
čitalac ne zna da li "resolved" znači zatvoreno bez eskalacije na čoveka, bez
prosleđivanja lead-a, ili nešto treće. U `research-notes.md` ta brojka potiče iz
reda "Informacija / provera statusa: 4,783 → rešeno od strane AI (63%)" i
"63% svih konverzacija rešeno bez ljudske intervencije" — dakle definicija
postoji u izvoru, samo nije preneta u rad.

**Predlog popravke:** dodati kratku definiciju u @sec:metric-definitions (npr.
stavku "Resolved without human intervention: udeo konverzacija koje je AI zatvorio
bez eskalacije na ljudski tim"), ili pri prvom pominjanju u @sec:results dodati
poludefiniciju u zagradi. Autor bira formulaciju.

### I2. "close rate" uveden bez definicije, i asimetrično sa follow-up granom

**Ukotvljeno:** @sec:results — "The close rate on in-chat purchases was 73%, the
highest in the funnel."

**Zašto:** "close rate" je peti pojam koji se pojavljuje samo jednom i nije u
@sec:metric-definitions. Dodatno, iz `research-notes.md` vidi se da follow-up grana
ima svoj close rate (2,005 → 1,146 = 57%), ali rad navodi samo in-chat 73%.
Tvrdnja "the highest in the funnel" je tačna prema izvoru (73% > 57%), ali čitalac
nema drugu vrednost za poređenje, pa "highest" deluje nepotkrepljeno unutar samog
teksta. Brojka 73% jeste sledljiva (771 → 559), tako da nije greška — pitanje je
samo definisanosti i potkrepljenja komparativne tvrdnje.

**Predlog popravke:** ili (a) definisati "close rate" i ukratko navesti i
follow-up vrednost da bi "highest in the funnel" imalo osnovu u tekstu, ili
(b) izostaviti komparativ "the highest in the funnel" ako se ne želi uvoditi druga
brojka. Autor odlučuje o obimu.

### I3. Apstrakt preskače junsku vrednost prihoda, blaga nekonzistentnost sa telom

**Ukotvljeno:** apstrakt — "verified revenue rising from 15,200 to 113,722 euros
per month" navodi samo maj i jul; telo (@sec:results, @tbl:rast) navodi sva tri
meseca (15,200 / 38,700 / 113,722). Za prodaje apstrakt ipak navodi sve tri
(196 / 558 / 1,705).

**Zašto:** nije faktička greška (obe krajnje vrednosti su tačne), ali je
asimetrično: prodaje su date u tri tačke, prihod u dve. Sitna nekonzistentnost u
najčitanijem delu rada.

**Predlog popravke:** radi doslednosti navesti i junsku vrednost prihoda (38,700)
u apstraktu, ili obe putanje svesti na "od → do" par. Kozmetički, ali lako.

---

## MINOR

### M1. Nedosledno navođenje eura u apstraktu vs telu

**Ukotvljeno:** apstrakt piše "15,200 to 113,722 euros"; telo piše "15,200 to
38,700 and 113,722 euros per month". Reč "euros" naspram simbola nije problem
(dosledno se koristi reč), ali obrati pažnju da je stil brojki konzistentan
(zarez kao separator hiljada svuda) — jeste, provereno. Ostaje samo stilska
napomena da se izbegava mešanje "euros" i "EUR" (tabela @tbl:rast koristi "EUR",
tekst koristi "euros") — prihvatljivo, ali autor može uskladiti.

### M2. Dvostruko iskazana ista konverzija (61% i 61.4%)

**Ukotvljeno:** @sec:results — "conversion rose from 43% to 61% (1,705 of 2,776
qualified leads, that is 61.4%)". Apstrakt i zaključak koriste "43% to 61%".

**Zašto:** nije greška — 61% je zaokruženje 61.4%, i autor to eksplicitno pokazuje
u zagradi, što je zapravo dobra praksa transparentnosti. Napomena je samo da se
zadrži konzistentno: zaokruženo (43/61) u apstraktu/zaključku, precizno sa izvodom
u Rezultatima. Trenutno je upravo tako — dobro urađeno, ostavljeno kao potvrda.

### M3. "43%" početna konverzija — sledljivo ali vredi proveriti izvor

**Ukotvljeno:** @sec:results i apstrakt — "conversion increased from 43% to 61%".

**Zašto:** `research-notes.md` navodi conversion rate maj 42.8%, jun 42.9%, jul
61.4%. "43%" je razumno zaokruženje polazne vrednosti (42.8/42.9), tako da je
sledljivo. Napomena je samo da se osigura da "from 43%" referiše na pred-transakcioni
period (maj–jun ~43%), što tekst i sugeriše ("coinciding with enabling purchases").
Nije mana; potvrda da je brojka utemeljena.

### M4. Neiskorišćeni bib unosi su ispravno označeni

**Ukotvljeno:** `references.bib` — `wang2023`, `zhang2026`, `laranjo2018`,
`milneives2020`. Svaki nosi komentar "Rezervisano za master #16 — namerno
necitiran u ovom radu".

**Zašto:** ovo je tačno ono što se traži — 4 rezervisana unosa, jasno označena,
neće izazvati "unused entry" zabunu kod recenzenta. Nema akcije. (Napomena: ako
ciljni build/šablon koristi samo citirane reference — pandoc `--citeproc` sa
`::: {#refs} :::` renderuje samo citirane — ovi unosi se ionako neće pojaviti u
listi referenci, što je u redu.)

### M5. TODO/neizvesnosti u bib metapodacima (ne blokiraju predaju sadržaja)

**Ukotvljeno:** `references.bib` — inline komentari kod `luo2019` (vol/broj/strane
"potvrditi kod izdavača"), `oldemeyer2024` (god 2024/2025), `schwaeke2024`
(online-first vs štampano), `rashid2019` (article-number vs paginacija),
`lewis2020rag`/`vaswani2017attention` (arXiv DOI + NeurIPS paginacija).

**Zašto:** to su poznati, dokumentovani TODO-ovi (usklađeni sa
`research-notes.md`), ne izmišljeni podaci. Ne utiču na tekst rada, ali pre finalne
predaje vredi razrešiti bar `luo2019` strane i odluku o godini za `oldemeyer2024`/
`schwaeke2024` prema Future-BME šablonu citiranja. Stavka za autora/ls-researcher.

### M6. AI-slop provera — čisto

**Ukotvljeno:** ceo `paper.md`.

**Zašto:** nema em-dash umetaka kao stilskih ukrasa, nema emojija, nema klišea
tipa "in today's fast-paced world", "leverage", "delve". Ton je akademski i
suzdržan. SME se dosledno piše kao "SMEs"/"an SME". "AI sales chatbot" se koristi
dosledno. Ovo je pozitivan nalaz — bez zamerki.

---

## Priority summary

| ID | Prioritet | Nalaz | Ukotvljeno | Akcija |
|----|-----------|-------|------------|--------|
| I1 | IMPORTANT | "resolved without human intervention" (63%) nije definisano | @sec:results / @sec:metric-definitions | dodati definiciju metrike |
| I2 | IMPORTANT | "close rate" (73%) nedefinisan; "highest in funnel" bez druge vrednosti | @sec:results | definisati ili ublažiti komparativ |
| I3 | IMPORTANT | apstrakt navodi 2 tačke prihoda, telo 3 (asimetrija) | apstrakt vs @sec:results | dodati junsku vrednost ili svesti na par |
| M1 | MINOR | "euros" vs "EUR" nedosledno | apstrakt/tekst vs @tbl:rast | opciono uskladiti |
| M2 | MINOR | 61% i 61.4% zajedno — zapravo dobra praksa | @sec:results | potvrda, bez akcije |
| M3 | MINOR | "43%" polazna konverzija — sledljivo | @sec:results | potvrda, bez akcije |
| M4 | MINOR | 4 rezervisana bib unosa ispravno označena | references.bib | bez akcije |
| M5 | MINOR | dokumentovani bib TODO-ovi (strane/godine) | references.bib | razrešiti pre finalne predaje |
| M6 | MINOR | AI-slop provera čista | ceo paper.md | pozitivan nalaz |

---

## Checklist coverage

1. **Sadržaj/argumentacija** — provereno. Apstrakt↔uvod↔zaključak koherentni;
   glavna teza (info kanal → merljiv prodajni kanal; 43%→61% uz omogućavanje
   kupovine) dosledna svuda. Nema overclaiming-a: uzročnost je pažljivo
   formulisana ("coinciding", "suggests", "cannot be attributed to the chatbot
   alone"). Konflikt interesa (@sec:conflict-of-interest) i izostanak kontrolne
   grupe (@sec:limitations) tretirani eksplicitno i više puta. Metod jasan i
   reproduktivan na nivou konferencijskog rada (definicije metrika + izvori
   podataka). SVE brojke sledljive iz `research-notes.md`: 196/558/1,705,
   €15,200/38,700/113,722, 2,776 leadova, 61.4%, 559/1,146 (=1,705), 63%, 73%,
   -3.8% g/g. Otvorene stavke: definicije za 63% i 73% (I1, I2).
2. **Struktura** — sve sekcije prisutne (Introduction, Related Work sa 4 pod-sekcije,
   System and Architecture, Method, Results, Discussion, Limitations, Conclusion).
   Tok logičan (fenomen → praznina → sistem → metod → rezultati → tumačenje →
   ograničenja). ~2,200 reči + jedna figura + jedna tabela → očekivano unutar
   5–8 strana za IEEE/konf. format. Uredno.
3. **Citiranje/integritet** — provereno u oba smera. Svi in-text `[@kljuc]`
   (18 jedinstvenih) imaju unos u `references.bib`. Neiskorišćena su tačno 4
   unosa (wang2023, zhang2026, laranjo2018, milneives2020), svi označeni kao
   rezervisani za #16 (M4). Nema citata bez unosa niti tvrdnji koje očigledno
   zahtevaju izvor a nemaju ga (tehničke/poslovne tvrdnje su ili citirane ili
   jasno označene kao opis sopstvenog sistema).
4. **Cross-reference** — svi `@sec:`/`@tbl:`/`@fig:` (6 korišćenih) pogađaju
   definisane labele (@fig:arhitektura, @tbl:rast, @sec:method, @sec:system,
   @sec:conflict-of-interest, @sec:limitations). Nema mrtvih referenci.
5. **Stil/konzistentnost** — akademski engleski, bez AI-slop-a (M6). SME/SMEs
   dosledno. SVG dijagram (`figures/arhitektura.svg`) u celosti na engleskom i
   usklađen sa opisom u @sec:system. Otvoreno: definisanost metrika 63%/73% (I1/I2)
   i sitna euro-nedoslednost (M1).

---

## Finalna procena

**Spreman uz manje revizije.**

Nema blokirajućih (CRITICAL) nalaza. Tri IMPORTANT stavke (I1–I3) su pitanja
preciznosti/doslednosti, ne suštinske mane: definisati metrike "resolved without
human intervention" (63%) i "close rate" (73%) tako da budu u skladu sa već
postojećom sekcijom definicija, i ujednačiti prikaz prihoda u apstraktu. Nakon
tih dopuna rad je spreman za predaju. MINOR stavke su opcione ili već dobro
urađene. Preporuka: I1 i I2 rešiti pre predaje (jer rad sam sebe drži na standardu
proverljivih metrika), I3 i M-stavke po mogućnosti.
