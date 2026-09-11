# Recenzentska čeklista

Prođi sistematski kroz sve četiri oblasti. Za svaku stavku: nađi problem, tačnu
lokaciju u tekstu, zašto je bitno, i kako bi popravka izgledala (bez pisanja).

## 1. Sadržaj i argumentacija

- [ ] **Rupe u argumentaciji** — postoji li skok od premise do zaključka bez koraka?
- [ ] **Neobosnovane tvrdnje** — svaka netrivijalna tvrdnja ima izvor `[@key]` ili
      je jasno označena kao doprinos rada?
- [ ] **Apstrakt ↔ uvod ↔ zaključak** — da li se poklapaju? Cilj postavljen u
      uvodu mora biti isti kao ono na šta zaključak odgovara; apstrakt sažima oba.
- [ ] **Metodologija** — jasna i dovoljno detaljna da se rad ponovi? Nedostaju li
      parametri, podaci, koraci?
- [ ] **Rezultati podržavaju zaključke** — da li zaključci prekoračuju ono što
      rezultati zaista pokazuju (overclaiming)?
- [ ] **Rezultati vs. interpretacija** — pomešani (rezultati u sekciji Rezultati,
      tumačenje u Diskusiji)?
- [ ] **Ograničenja** — da li rad priznaje ograničenja / pretnje validnosti?

## 2. Struktura

- [ ] Sve očekivane sekcije prisutne (apstrakt, uvod, related work, metodologija,
      rezultati, diskusija, zaključak; reference na kraju).
- [ ] Logički tok — svaka sekcija se nadovezuje na prethodnu.
- [ ] Nivoi naslova dosledni (`#`, `##`, `###`).
- [ ] Nema prazne/nedovršene sekcije (placeholder tekst, TODO ostavljen u radu).

## 3. Citiranje i integritet

Vidi `citation-integrity.md` za tačan postupak provere u oba smera.

- [ ] Svaki `[@key]` iz teksta ima unos u `references.bib`.
- [ ] Nema neiskorišćenih unosa u `references.bib` (unos koji se nigde ne citira).
- [ ] Tvrdnje koje traže izvor a nemaju ga — označi svaku.
- [ ] Potencijalni plagijat — tekst preblizu formulaciji izvora.

## 4. Stil i konzistentnost

- [ ] **Terminologija** — isti pojam kroz ceo rad (ne mešati sinonime za isti koncept).
- [ ] **Akademski ton, bez slop-a** — nema em-dash/en-dash kao stilskog umetka,
      emojija, AI klišea („važno je napomenuti", „nesumnjivo", „zaronimo u").
- [ ] **Cross-reference** — svaki `@fig:`/`@tbl:`/`@eq:`/`@sec:` pokazuje na
      definisanu labelu; svaka labela je bar jednom referencirana.
- [ ] **Jasnoća** — preterano duge rečenice, dvosmislenosti, žargon bez objašnjenja.
- [ ] **Doslednost formata** — brojevi, jedinice, decimalni zarez/tačka, velika slova.

## Princip

- Konkretno, ne uopšteno: „dodaj izvor za tvrdnju o X u sekciji Metodologija, 2.
  pasus" umesto „dodaj više izvora".
- Ne izmišljaj mane. Ako je oblast solidna, reci to.
- Razdvoj stvarnu grešku od stilske preferencije (označi mišljenje kao mišljenje).
