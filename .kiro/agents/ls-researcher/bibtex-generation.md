# Generisanje BibTeX unosa

BibTeX unosi idu u `references.bib` rada. Format prati `template/references.bib`.
`citeproc` + `shared/resources/ieee.csl` formatiraju izlaz po IEEE stilu.

## Zlatno pravilo

Svaki unos mora poticati iz stvarnog, verifikovanog izvora (DOI, otvorena stranica
rada, ili autorov podatak). Nikada ne izmišljaj autore, naslov, godinu, DOI ni
stranice. Nesiguran podatak → `TODO`, ne pogađanje.

## Ključ unosa

Konvencija: `prezimeGodina` prvog autora (npr. `smith2023`). Ako se ključ ponavlja,
dodaj slovo (`smith2023a`, `smith2023b`). Ključ mora biti jedinstven u fajlu.

## Tipovi i obavezna polja

**Žurnal:**
```bibtex
@article{prezimeGodina,
  author  = {Prezime, Ime and Drugi, Autor},
  title   = {Naslov rada},
  journal = {Naziv časopisa},
  year    = {2023},
  volume  = {12},
  number  = {3},
  pages   = {45--59},
  doi     = {10.1000/primer}
}
```

**Konferencija:**
```bibtex
@inproceedings{prezimeGodina,
  author    = {Prezime, Ime},
  title     = {Naslov rada},
  booktitle = {Zbornik / Proceedings},
  year      = {2024},
  pages     = {100--110},
  doi       = {10.1000/xyz}
}
```

**Knjiga:** `@book` (author/editor, title, publisher, year).
**Preprint (arXiv):** `@misc` sa `eprint`, `archivePrefix = {arXiv}`, `url`.
**Veb izvor:** `@misc` sa `author`, `title`, `year`, `url`, `urldate`.
**Tehnički izveštaj:** `@techreport` (institution, number).

## Postupak (DOI/link → BibTeX)

1. Otvori DOI/stranicu (web_fetch) i pročitaj tačne metapodatke.
2. Preferiraj zvanični citation export (izdavač, Crossref, arXiv) ako postoji.
3. Popuni polja tačno kako stoje na izvoru; opsezi stranica sa en-dash `--`.
4. Proveri: autori (redosled, kompletni), godina, venue, DOI.
5. Ako polje nedostaje na izvoru, ostavi `TODO` u tom polju, ne izmišljaj.

## Dodavanje u rad

Ponudi da dodaš unos u `papers/<name>/references.bib` (proveri da ključ ne
postoji već). Samo pisanje teksta i `[@key]` citiranje prepusti `ls-paper-writer`
agentu.
