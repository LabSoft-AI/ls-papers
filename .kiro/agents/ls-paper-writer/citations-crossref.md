# Citiranje (BibTeX + IEEE) i cross-reference

Formatiranje ide preko `citeproc` + `shared/resources/ieee.csl`. Ne piši reference
ručno u tekstu — koristi ključeve, Pandoc generiše listu literature.

## BibTeX unosi (`references.bib`)

Svaki izvor je jedan unos sa jedinstvenim ključem. Ključ konvencija:
`prezimeGodina` (npr. `smith2023`). Ako postoji, tražiti DOI.

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

@inproceedings{drugiGodina,
  author    = {Treci, Autor},
  title     = {Naslov konferencijskog rada},
  booktitle = {Zbornik radova konferencije},
  year      = {2024},
  pages     = {100--110}
}

@book{knjigaGodina,
  author    = {Autor, Ime},
  title     = {Naslov knjige},
  publisher = {Izdavač},
  year      = {2022}
}
```

Tipovi: `@article`, `@inproceedings`, `@book`, `@techreport`, `@misc` (za veb
izvore, sa `url` i `urldate`).

**Pravilo:** nikada ne izmišljaj unos. Ako autor nema pun bibliografski podatak,
ostavi `TODO` i traži DOI/link.

## Citiranje u tekstu

- Jedan izvor: `[@smith2023]`
- Više izvora: `[@smith2023; @drugi2024]`
- Sa stranom: `[@smith2023, str. 45]`
- Inline (autor kao deo rečenice): `@smith2023 pokazuje da ...`

Ključ u citatu MORA postojati u `references.bib`, inače build baca upozorenje i
citat ostaje neformatiran.

## Cross-reference (pandoc-crossref)

Definiši labelu na elementu, referenciraj sa `@`.

**Slika:**
```markdown
![Opis slike.](figures/dijagram.png){#fig:dijagram width=60%}
```
Referenca: `@fig:dijagram` → "Slika 1".

**Tabela:**
```markdown
| Kolona A | Kolona B |
|----------|----------|
| 1        | 2        |

: Opis tabele. {#tbl:rezultati}
```
Referenca: `@tbl:rezultati` → "Tabela 1".

**Jednačina:**
```markdown
$$ a^2 + b^2 = c^2 $$ {#eq:pitagora}
```
Referenca: `@eq:pitagora` → "jedn. 1".

**Sekcija:** `# Metodologija {#sec:metod}` → referenca `@sec:metod`.

Numeracija je automatska; ne kucaj brojeve ručno. Labele moraju biti jedinstvene.

## LaTeX matematika

- Inline: `$E = mc^2$`
- Blok (bez broja): `$$ ... $$`
- Blok (sa brojem/labelom): `$$ ... $$ {#eq:label}`

Figure su PNG/JPG/PDF u `figures/` (git-lfs), ili SVG (tekst, treba `librsvg`).
