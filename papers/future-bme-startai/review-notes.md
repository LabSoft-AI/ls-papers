# Peer review — `paper.md` (Future-BME, StartAI/Atlas24h case study)

> Reviewer: ls-reviewer. Draft reviewed: first version on branch
> `feature/paper-future-bme`, file `papers/future-bme-startai/paper.md`
> (14,662 B, 2026-09-17). Conference paper, English, author Luka Vidaković.
> Target: Future-BME, 5–8 pages.
>
> Scope of this review: content & argumentation, structure, citation integrity
> (both directions), cross-references, style/consistency. I did **not** edit the
> paper. Every finding is anchored (section / sentence / key) with the reason and
> a suggested direction — the fix is the author's.
>
> Overall verdict: solid, well-structured first draft. The limitations and
> conflict of interest are handled unusually honestly, which is a strength. There
> is **one CRITICAL data-consistency issue** (the 1,705 vs. 1,811 conflation)
> that must be resolved before submission, plus a few IMPORTANT items. No invented
> defects; where the draft is sound I say so.

---

## CRITICAL (must fix before submission)

### C1 — "AI chatbot" (1,705) vs. "AI channel" (1,811) are conflated; the abstract merges two different figures

- **Where:** Abstract (lines ~17–19: "confirmed sales grew from 196 … to 1,705
  … the AI channel's share of total sales reached 46.4%"); Results §5, sentence
  "In July 2026, the AI channel contributed 1,811 of a total of 3,905 sales, that
  is, 46.4% of all sales."
- **Problem:** The paper's headline count for the *AI sales chatbot* is **1,705**
  (July confirmed sales). But the 46.4% share is computed from **1,811 / 3,905**
  (research-notes.md: "Doprinos AI kanala ukupnoj prodaji (jul 2026): 1,811 od
  3,905"). So 1,705 = chatbot; 1,811 = "AI channel" (a broader aggregate, likely
  chatbot + voicebot). The paper never defines "AI channel" as distinct from "AI
  sales chatbot", and the abstract attributes the 46.4% to the same object it
  just described with 1,705. A referee will read this as an internal inconsistency
  (1,705 ≠ 1,811 for the same July) or as silent scope-creep beyond the single
  case the paper claims to study.
- **Why it matters:** The whole paper's stated scope (research-notes.md, "ODLUKA
  O OBIMU") is **one case: the Atlas24h AI Sales Chatbot**; the sales voicebot is
  explicitly reserved for the master thesis (#16). If 1,811 includes voicebot
  sales, the flagship 46.4% claim quietly pulls in a case the paper says it is not
  studying — an overclaim relative to the declared scope.
- **Suggested fix (author decides):** Either (a) define "AI channel" explicitly in
  §4/§5 and state what it contains vs. the chatbot's 1,705, and justify why the
  channel-level share belongs in a single-chatbot paper; or (b) compute the share
  from the chatbot's own 1,705 and report *that* number; or (c) keep 1,811 but
  add one sentence naming the components and pointing forward to the master thesis
  for the voicebot. Do not leave two different July totals unexplained.

---

## IMPORTANT (should fix before submission)

### I1 — Conversion 61% (paper) vs. 61.4% (notes) and undefined "qualified lead" count

- **Where:** Abstract and Results §5 ("conversion increased from 43% to 61%");
  §4.1 defines *conversion* = confirmed sales / qualified leads.
- **Problem:** research-notes.md records **61.4%** and **2,776 qualified leads**
  for July. The paper rounds to 61% (fine on its own) but never reports the
  qualified-lead denominator anywhere, even though §4.1 *defines* conversion in
  terms of it. A reader cannot check 1,705 / 2,776 ≈ 61.4% because 2,776 is absent.
- **Why it matters:** The paper's own selling point (§1, §4) is verifiability
  ("making the results verifiable"). Defining a metric as a ratio and then never
  giving the denominator undercuts that claim.
- **Suggested fix:** Add the qualified-lead counts (at least for July, ideally per
  month) to @tbl:rast or the Results prose, so the 61% is reconstructable.

### I2 — "43% → 61%" causal-adjacent wording risks overclaiming

- **Where:** Results §5 ("conversion rose from 43% to 61% after purchasing within
  the chat itself was enabled"); Discussion §6 ("suggests that the key factor was
  removing the break between intent and transaction"); Abstract ("increased … after
  enabling purchases within the chat").
- **Problem:** Discussion §6 hedges well ("coincides in time … suggests"), and
  §6.1 correctly lists "no control group … cannot be attributed to the chatbot
  alone." But the Abstract and the first Results sentence state the 43→61 jump
  right next to the causal trigger without the hedge, so read in isolation
  (abstract is often read alone) they imply causation the design cannot support.
- **Why it matters:** With no control group and admitted seasonal/marketing
  confounds, a temporal coincidence is the strongest claim the data license. The
  abstract currently reads slightly stronger than the limitations allow —
  classic overclaim surface.
- **Suggested fix:** Mirror the §6 hedge in the abstract and the first Results
  sentence (e.g. frame as temporal association, not effect). Keep §6/§6.1 as is —
  they are good.

### I3 — Four bib entries are unused (Clusters B and C)

- **Where:** `references.bib`: `wang2023`, `zhang2026`, `laranjo2018`,
  `milneives2020` have **no** `[@key]` anywhere in `paper.md` (verified by
  extracting all in-text keys and diffing against bib keys).
- **Problem:** These are deliberately reserved for the master thesis (#16) per
  research-notes.md, so their *absence from the text is correct* for this paper.
  The issue is hygiene: they still sit in the paper's `references.bib`. With
  citeproc + IEEE CSL and the `::: {#refs}` block, uncited entries are simply not
  printed, so **this will not corrupt the rendered bibliography** — but it is dead
  weight in the file and can confuse a co-author or a future automated check.
- **Why it matters:** Low build risk, but "no unused entries" is a citation-
  integrity expectation; leaving voicebot/health refs here blurs the paper's
  declared single-case scope at the file level.
- **Suggested fix (author decides):** Either keep them (acceptable — shared bib
  across the paper program) but add a comment marking them as reserved-for-#16 and
  intentionally uncited; or move them to a shared/master bib. No text change needed.

### I4 — Architecture diagram is entirely in Serbian; paper is in English

- **Where:** `figures/arhitektura.svg`, referenced as @fig:arhitektura in §3.
- **Problem:** Every label in the SVG is Serbian ("Korisnik (web chat)", "Upravljanje
  sesijom", "Kupovina u razgovoru", "Podatkovna platforma (merni instrument)",
  "Merljivi ishodi", etc. — 21 text nodes). The paper, caption, and abstract are
  English. This is the known TODO flagged in the paper's own HTML comment ("localize
  the diagram to English later").
- **Why it matters:** For an international venue, a Serbian-only figure in an
  English paper is an immediate reviewer flag and hurts readability of the one
  technical figure. It is a real defect for submission, not just cosmetic.
- **Suggested fix:** Localize the SVG text nodes to English before submission.
  Already tracked as a TODO — raising it to IMPORTANT because it is submission-
  blocking for an English venue, not a "later" item.

---

## MINOR (polish; not blocking)

### M1 — `metadata.yaml` is still the untouched template

- **Where:** `papers/future-bme-startai/metadata.yaml` ("title: Naslov rada",
  "Ime Prezime", "lang: sr", placeholder abstract/keywords).
- **Problem:** Real metadata lives in the `paper.md` YAML front matter (which is
  what pandoc uses in this repo), so the build is unaffected. But the stale
  template file is misleading — a reader may think it is the source of truth, and
  it still says `lang: sr` while the paper is `lang: en`.
- **Suggested fix:** Either delete `metadata.yaml`, or sync it with the real
  front matter. Cosmetic / repo-hygiene only.

### M2 — Section-label inconsistency: some subsections referenced, most never

- **Where:** Labels defined but never referenced: `sec:agents-sales-support`,
  `sec:ai-adoption-smes`, `sec:case-study-methodology`, `sec:gap`,
  `sec:metric-definitions`, `sec:data-sources`, `sec:introduction`,
  `sec:related-work`, `sec:results`, `sec:discussion`, `sec:conclusion`.
- **Problem:** Not an error — defining a label without back-referencing it is
  legal and `numbersections` handles numbering. All *used* references
  (@sec:method, @sec:system, @sec:limitations, @sec:conflict-of-interest,
  @tbl:rast, @fig:arhitektura) resolve to defined labels (verified). Just noting
  the many unused labels for tidiness; harmless.
- **Suggested fix:** None required. Optionally drop labels you will never cite.

### M3 — Revenue currency provenance (EUR vs. code prices in RSD)

- **Where:** §4.2 "Revenue is expressed in euros as verified in the internal case
  reports"; architecture-notes.md lists package prices in RSD (Internacionalni+
  10.990 RSD, etc.).
- **Problem:** Prices in the underlying system are RSD; the paper reports EUR.
  §4.2 does say euros come from the internal case reports (so it is sourced), but
  it does not state whether a conversion was applied or the case reports were
  natively in EUR. A careful referee may ask.
- **Why it matters:** Minor traceability gap; the sentence is defensible as
  written but one clause would close it.
- **Suggested fix:** One clause clarifying that the EUR figures are as-reported in
  the case reports (no reviewer-side conversion), if that is accurate.

### M4 — Style: draft is clean of AI slop; a few tiny consistency notes

- **Positive:** No em-dash inserts, no emojis, no cliché filler. Terminology is
  consistent: "SME"/"small and medium-sized enterprises" is introduced once and
  used consistently; "AI sales chatbot", "data platform", "qualified lead /
  conversion / confirmed sale" are used uniformly. Academic register is good.
- **Minor:** (a) "AI sales chatbot" vs. "AI channel" — see C1; make the
  distinction lexical, not accidental. (b) Abstract gives June revenue implicitly
  (15,200 → 113,722) while Results spells out all three (15,200 / 38,700 /
  113,722); consistent, just noting the abstract compresses. No change needed.

---

## Checklist coverage (what was verified)

- **Content & argumentation:** Abstract ↔ Intro ↔ Conclusion are coherent on the
  core thesis (unmonetized info channel → measurable sales channel; 43→61%;
  €113,722; stable human team; no new hires). Conflict of interest (§4.3) and
  no-control-group / single-case limitations (§6.1) are stated explicitly and
  repeatedly — a genuine strength. Method (§4) is clear and reproducible at the
  case-study level (design, metric definitions, data sources). Main residual
  argumentation risks: C1 (scope conflation) and I2 (causal wording in abstract).
- **Structure:** All expected sections present — Abstract, Introduction, Related
  Work (with 4 subsections + Gap), System & Architecture, Method (with metric
  defs, data sources, COI), Results, Discussion (with Limitations), Conclusion,
  References. Logical flow is sound (phenomenon → SME context → methodology → gap
  → system → method → results → discussion). Length looks within 5–8 pages
  (single figure, single table, ~2.5k words of body); confirm after PDF build.
- **Citation integrity (both directions):** 16 distinct in-text `[@key]`s, all
  16 have a bib entry (verified by key diff). Reverse direction: 4 bib entries
  unused (I3). No claim in §2/§3 that needs a source appears to lack one; the
  self-citations (`stojanovic2024telfor`, `stojanovic2025aws`,
  `vidakovic2025docker`) are placed where relevant (continuity, architecture,
  runtime) and are 3 in total — moderate, not over-citation. Note: the bib file
  itself carries several unresolved TODOs the author already flagged (luo2019
  vol/pages; oldemeyer2024 year; schwaeke2024 year; rashid2019 article-number;
  NeurIPS page numbers for lewis2020rag/vaswani2017attention). Those are the
  author's known pre-submission verification items, not new defects — listing
  them so they are not forgotten.
- **Cross-references:** All 6 used @sec/@tbl/@fig references resolve to defined
  labels (verified). No dangling references.
- **Style/consistency:** Clean academic English, consistent terminology, no AI
  slop. SVG diagram in Serbian is the one real style/localization defect (I4).

---

## Priority summary

| ID | Priority  | One-line                                                            |
|----|-----------|---------------------------------------------------------------------|
| C1 | CRITICAL  | 1,705 (chatbot) vs. 1,811 (AI channel) conflated; 46.4% scope creep |
| I1 | IMPORTANT | Conversion denominator (qualified leads, 2,776) never reported      |
| I2 | IMPORTANT | Abstract/first-Results 43→61% reads causal; hedge like §6           |
| I3 | IMPORTANT | 4 unused bib entries (wang2023, zhang2026, laranjo2018, milneives2020) |
| I4 | IMPORTANT | Architecture SVG is Serbian-only in an English paper                |
| M1 | MINOR     | metadata.yaml still the untouched template (lang: sr)               |
| M2 | MINOR     | Many defined section labels never referenced (harmless)             |
| M3 | MINOR     | EUR vs. RSD revenue provenance could use one clarifying clause      |
| M4 | MINOR     | Style clean; keep "chatbot" vs "channel" lexically distinct         |

Handoffs: content fixes (C1, I1, I2, M3) → author / ls-paper-writer; bib hygiene
(I3) and metadata (M1) → author; source/verification TODOs already in the bib →
ls-researcher; the SVG localization (I4) → author. No Git actions taken.

---

## Drugi krug recenzije (2026-09-17)

> Reviewer: ls-reviewer. Nezavisan, pun ponovni pregled TRENUTNE verzije
> `paper.md` na grani `feature/paper-future-bme`. Rad ponovo pročitan od početka;
> `references.bib` proveren u oba smera; `research-notes.md` i
> `architecture-notes.md` korišćeni za verifikaciju činjenica; SVG dijagram
> otvoren i pregledan. Nisam menjao rad. Svaki nalaz je ukotvljen.
>
> Ukratko: **sve tri kategorije iz prvog kruga (C1, I1–I4) su REŠENE.** Sporni
> brojevi (1,811 / 3,905 / 46.4% / 43.7% / „AI channel") su u potpunosti uklonjeni
> — rad je sada strogo o chatbotu. Ostaju dva nova, manja nalaza (jedan važan oko
> sledljivosti novih granularnih brojki, jedan minoran) i ranije MINOR stavke koje
> nisu blokirajuće. Procena: rad je u stanju blizu spremnom za predaju.

### (a) Status ranijih nalaza

| ID | Prvi krug (kratko) | Status | Dokaz / gde |
|----|--------------------|--------|-------------|
| **C1** | 1,705 (chatbot) vs. 1,811 (AI channel); 46.4% scope creep | **REŠEN** | `grep` po `paper.md` za `1,811\|3,905\|46.4\|43.7\|AI channel` → **0 pogodaka**. Apstrakt i §5 sada govore isključivo o chatbotu (1,705 / €113,722). Nema drugog julskog totala. |
| **I1** | Konverzioni imenilac (2,776 kvalif. leadova) nije naveden | **REŠEN** | §5, rečenica: „conversion rose from 43% to 61% (1,705 of 2,776 qualified leads, that is 61.4%)". 1,705/2,776 = 61.4% ✓ rekonstruktivno. |
| **I2** | Apstrakt/§5 43→61% zvuči kauzalno | **REŠEN (DELIMIČNO→REŠEN)** | Apstrakt sada: „increased from 43% to 61%, **coinciding with** enabling purchases within the chat" — temporalna, ne uzročna formulacija; §5 „coinciding with"; §6 zadržava „coincides in time … suggests". Hedge sada dosledan kroz apstrakt/rezultate/diskusiju. |
| **I3** | 4 neiskorišćena bib unosa (wang2023, zhang2026, laranjo2018, milneives2020) | **REŠEN** | Svaki od 4 unosa u `references.bib` sada nosi komentar `% Rezervisano za master #16 — namerno necitiran u ovom radu`. Diff ključeva potvrđuje: iskorišćeno 16, neiskorišćeno tačno ta 4 (namerno). citeproc ih neće štampati. |
| **I4** | SVG dijagram samo na srpskom | **REŠEN** | `figures/arhitektura.svg` otvoren: svi tekst-čvorovi su na engleskom („User (web chat)", „Session management", „Agentic step", „RAG (FAISS)", „In-conversation purchase", „Notification service", „Conversation export", „Data platform (measurement instrument)", „Conversation analysis (Amazon Nova)", „Metric aggregation + API", „Measurable outcomes"). Nema više srpskih labela. |
| **M1** | `metadata.yaml` još template (lang: sr) | **OTVOREN (MINOR)** | Nisam ponovo otvarao fajl u ovom krugu jer ne utiče na build (pandoc koristi YAML iz `paper.md`). Ako fajl još postoji netaknut, ostaje kozmetička higijena — proveriti/obrisati pre predaje. |
| **M2** | Mnoge definisane a nekorišćene sekcijske labele | **OTVOREN — bez akcije (bezopasno)** | I dalje ~11 sekcijskih labela definisano bez back-reference. Legalno; `numbersections` radi. Nije greška. |
| **M3** | Provenijencija EUR vs. RSD u prihodu | **OTVOREN (MINOR)** | §4.2 i dalje: „Revenue is expressed in euros as verified in the internal case reports." Ne kaže da li je primenjena konverzija ili su izveštaji izvorno u EUR. Jedna klauzula bi zatvorila. Nije blokirajuće. |
| **M4** | Stil čist; „chatbot" vs „channel" leksički razdvojiti | **REŠEN** | Termin „AI channel" više se ne pojavljuje; rad dosledno koristi „AI sales chatbot". Stil i dalje čist: bez em-dash umetaka, bez emojija, bez klišea. „SME" dosledan. |

### (b) Novi nalazi (drugi krug)

**N1 — VAŽAN — Nove granularne brojke u §5 nisu sledljive do dostupnih beleški.**

- **Gde:** §5 (Results), rečenice: „Of the 1,705 confirmed sales in that month,
  **559** users completed the entire purchase within the chat (in-chat completion)
  and **1,146** left contact details and converted through follow-up, while **63%**
  of all conversations were resolved without human intervention. The close rate on
  in-chat purchases was **73%**, the highest in the funnel."
- **Problem:** `research-notes.md` (slučaj 1, Atlas24h Sales Chatbot) beleži samo:
  €113,722, 1,705 prodaja, 2,776 leadova, 61.4% konverzija, rast maj→jul, i
  ljudski call centar -3.8%. Novi brojevi 559 / 1,146 (in-chat vs follow-up split),
  63% (resolution bez čoveka) i 73% (close rate in-chat) **ne postoje** u
  istraživačkim beleškama kojima raspolažem. Aritmetika je konzistentna
  (559 + 1,146 = 1,705 ✓), što je dobar znak, ali sami procenti (63%, 73%) i
  podela ne mogu se proveriti iz `research-notes.md`.
- **Zašto je važno:** Rad se eksplicitno prodaje na proverljivosti (§1, §4 —
  „making the results verifiable"). Ove brojke verovatno dolaze iz interne case-
  study PDF (`StartAI-CaseStudy-Atlas24h-AI-Sales-Chatbot.pdf`, van ovog repo-a),
  ali kao recenzent ih ne mogu potvrditi. Nije nužno greška — može biti tačno iz
  PDF-a — ali je nesledljivo iz materijala koji prati rad.
- **Predlog (autor odlučuje):** Potvrditi 559 / 1,146 / 63% / 73% direktno iz
  Atlas case-study PDF-a i, po mogućstvu, dopuniti `research-notes.md` tim
  brojkama (isti tretman kao ostale — označen izvor), da bi Results bio sledljiv
  do beleški kao i sve ostalo. Ako neka od brojki nije u PDF-u, ukloniti je ili
  označiti izvor u tekstu.

**N2 — MINOR — „63% resolved without human intervention" je nova metrika bez definicije u §4.1.**

- **Gde:** §5 uvodi „resolved without human intervention" (63%); §4.1 definiše
  samo *qualified lead*, *conversion*, *confirmed sale* — ne i „resolution".
- **Problem:** Metrika koja se pojavljuje u rezultatima a nije definisana u sekciji
  definicija stvara mali jaz u odnosu na inače uzoran „definiši-pa-izmeri" pristup
  rada. (Isti pojam „resolution/deflection" u beleškama se koristi za voicebot
  slučajeve rezervisane za master; ovde je za chatbot.)
- **Predlog:** Ili dodati kratku definiciju „resolved without human intervention"
  u §4.1, ili u §5 u jednoj klauzuli reći šta se računa kao rešeno bez čoveka.
  Sitno; ne blokira.

**Pozitivno (bez izmišljanja mana):** Apstrakt↔uvod↔zaključak su koherentni i sada
potpuno usklađeni oko chatbota (bez konflacije kanala). Konflikt interesa (§4.3) i
ograničenja (bez kontrolne grupe, jedan slučaj, instrument istog tima — §6.1)
navedeni su eksplicitno, više puta, i u zaključku — retko poštено za case study.
Metod je jasan i reproduktivan na nivou studije slučaja. Self-citati (3) su
umereni i na pravim mestima. Cross-reference (svih 6 korišćenih @sec/@tbl/@fig)
pogađaju definisane labele — nema visećih referenci. Struktura pokriva sve
očekivane sekcije; dužina deluje unutar 5–8 strana (jedna figura, jedna tabela,
~2.5k reči tela) — potvrditi posle PDF build-a.

**Podsetnik (nije nov nalaz):** BibTeX i dalje nosi ranije autorove TODO-ove
(luo2019 vol/strane; oldemeyer2024/schwaeke2024 godina online-vs-štampano;
rashid2019 article-number; NeurIPS strane za lewis2020rag/vaswani2017attention).
To su poznate pred-predajne verifikacione stavke autora, ne nove mane.

### (c) Opšta procena spremnosti za predaju

Rad je **blizu spreman za predaju**. Sve što je prvi krug označio kao blokirajuće
(C1) ili važno (I1–I4) je rešeno, i to čisto: kritična konflacija obima potpuno je
uklonjena, imenilac konverzije dodat, kauzalna formulacija ublažena, neiskorišćeni
unosi označeni, dijagram lokalizovan na engleski. Preostaje:

- **N1 (važan, ali ne blokira nauku):** obezbediti sledljivost novih granularnih
  brojki (559/1,146/63%/73%) do izvora/beleški — pitanje integriteta/proverljivosti,
  ne tačnosti.
- **N2 + M1 + M3 (minorno):** definisati „resolution" u §4.1; srediti/obrisati
  `metadata.yaml`; jedna klauzula o EUR provenijenciji.

Preporuka: **prihvatiti uz manje revizije** (minor revisions). Nakon što se N1
razreši (potvrda brojki iz case-study PDF-a) i minorne stavke doteraju, rad je
spreman za predaju na Future-BME. Nijedna preostala stavka ne dovodi u pitanje
osnovnu tezu ni integritet rada.

| ID | Prioritet | Jedna linija |
|----|-----------|--------------|
| N1 | VAŽAN | Nove brojke 559/1,146/63%/73% nisu sledljive iz `research-notes.md` — potvrditi iz case-study PDF-a |
| N2 | MINOR | „resolved without human intervention" (63%) nije definisan u §4.1 |
| M1 | MINOR | `metadata.yaml` (verovatno još template, lang: sr) — proveriti/obrisati |
| M3 | MINOR | EUR vs. RSD provenijencija prihoda — jedna klauzula |
