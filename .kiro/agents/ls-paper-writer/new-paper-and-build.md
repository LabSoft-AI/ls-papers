# Novi rad i build

## Kreiranje novog rada iz šablona

Šablon je u `template/` (paper.md, metadata.yaml, references.bib, figures/).
Kopiraj ga u `papers/<naziv>/`:

```bash
cp -r template papers/<naziv>
```

Zatim popuni metapodatke u `papers/<naziv>/paper.md` (YAML zaglavlje):

- `title` — naslov rada
- `author` — name + affiliation (+ email po potrebi)
- `date` — godina
- `abstract` — 150–250 reči
- `keywords` — lista ključnih reči
- `lang` — `sr` (latinica) po difoltu
- `mainfont` — `DejaVu Serif` (pokriva ćirilicu, dostupno u CI); na macOS može
  `Times New Roman`
- `bibliography: references.bib`
- `numbersections: true`

Naziv foldera: kratak, mala slova sa crticama (npr. `luka-master`,
`crossref-eval`). Ovo je ujedno scope za `ls-git` commit poruke.

## Build

Output ide u `papers/<naziv>/public/` (ne commituje se).

```bash
make list                       # lista svih radova
make paper=<naziv>              # pdf + docx + odt
make paper=<naziv> pdf          # samo PDF
make paper=<naziv> clean        # obriši output
make all                        # svi radovi
```

PDF se gradi XeLaTeX-om (Unicode/ćirilica). Zavisnosti: `pandoc`,
`pandoc-crossref`, `xelatex`, `librsvg` (za SVG figure). Vidi `README.md` /
`./setup.sh`.

## Tumačenje čestih grešaka

- **`[WARNING] Citeproc: citation X not found`** — ključ iz `[@X]` ne postoji u
  `references.bib`. Dodaj unos ili ispravi ključ.
- **`pandoc-crossref: undefined reference`** — `@fig:`/`@tbl:`/`@eq:` labela nije
  definisana na elementu, ili je pogrešno napisana.
- **`Font ... cannot be found`** — `mainfont` nije instaliran; koristi
  `DejaVu Serif` ili instaliraj font.
- **`File figures/... not found`** — putanja do slike pogrešna ili slika nije
  dodata (PNG/JPG idu preko git-lfs).
- **XeLaTeX greška oko specijalnih karaktera** — proveri neuravnotežene `$`,
  `{`, `}` ili LaTeX komande.

Predloži autoru da build pokrene rano i često, po sekciji, da greške ostanu male.

## Predaja Git posla

Ovaj agent NE commituje. Kada je sadržaj spreman, predaj `ls-git` agentu ili
reci autoru da pokrene commit uz konvenciju
`#<issue> <type>(<scope>): <opis>` (scope = folder rada).
