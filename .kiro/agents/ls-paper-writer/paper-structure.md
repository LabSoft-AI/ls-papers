# Struktura naučnog rada

Vodi autora kroz sekcije redom. Svaka sekcija je `#` heading u `paper.md`
(`numbersections: true` ih automatski numeriše). Reference sekcija ostaje bez
broja (`# Reference {-}`).

## Standardni redosled sekcija

1. **Apstrakt** — u YAML metapodacima (`abstract:`), ne kao sekcija. 150–250
   reči: problem, šta je urađeno, metod, ključni rezultat, zaključak. Bez
   citata i skraćenica koje nisu objašnjene.
2. **Uvod (Uvod)** — kontekst, motivacija, problem, cilj rada, doprinos,
   pregled strukture rada. Ovde idu prvi citati `[@key]`.
3. **Srodni radovi (Related work / Pregled literature)** — šta je do sada
   urađeno, gde je praznina koju rad popunjava. Gusto citirano.
4. **Metodologija (Metodologija)** — kako je istraživanje sprovedeno; dovoljno
   detalja za reprodukciju. Podeli na podsekcije (`##`) po potrebi.
5. **Rezultati (Rezultati)** — šta je pronađeno, bez interpretacije. Slike
   (`@fig:`), tabele (`@tbl:`), jednačine (`@eq:`).
6. **Diskusija (Diskusija)** — interpretacija rezultata, poređenje sa srodnim
   radovima, ograničenja, pretnje validnosti.
7. **Zaključak (Zaključak)** — sažetak doprinosa, odgovor na cilj iz uvoda,
   pravci budućeg rada. Bez novih podataka.
8. **Reference** — `# Reference {-}` sa `::: {#refs} :::` blokom (citeproc
   automatski popunjava iz `references.bib`).

## Varijante po tipu rada

- **Konferencijski / žurnal rad** — kompaktno, često Uvod → Related → Metod →
  Rezultati → Diskusija → Zaključak.
- **Master teza** — obimnije: dodatna poglavlja (Teorijske osnove, Implementacija,
  Evaluacija), i moguć apstrakt na dva jezika. Teza može imati poglavlja kao `#`
  i podpoglavlja kao `##`/`###`.

Ako repo dobije šablone po tipu rada (issue #8), koristi odgovarajući `template/`.

## Princip

- Svaka sekcija ima jasnu svrhu; ne mešaj rezultate sa diskusijom.
- Uvod postavlja pitanje, zaključak na njega odgovara — moraju se poklapati.
- Ne dodaj sekciju koju autor nije tražio; predloži, pa sačekaj potvrdu.
