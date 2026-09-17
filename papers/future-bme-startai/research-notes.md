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
- [ ] ls-researcher: related work + BibTeX u `references.bib`.
- [ ] ls-paper-writer: struktura i tekst po sekcijama.
- [ ] ls-reviewer: pregled pre predaje.
