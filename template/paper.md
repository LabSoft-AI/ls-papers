---
title: "Naslov rada"
author:
  - name: "Ime Prezime"
    affiliation: "Institucija / Fakultet"
date: "2026"
abstract: |
  Kratak apstrakt rada. Šta je problem, šta je urađeno, koji su rezultati.
keywords: [keyword1, keyword2]
lang: sr
# XeLaTeX main font. Must cover Cyrillic. "DejaVu Serif" ships with TeX Live
# (and CI). On macOS you can also use "Times New Roman" or "Times".
mainfont: "DejaVu Serif"
bibliography: references.bib
numbersections: true
---

# Uvod

Ovde ide uvod. Citiranje se radi ovako [@primer2023]. Više izvora
[@primer2023; @drugi2024].

Matematika inline: $E = mc^2$. Izdvojena jednačina:

$$ a^2 + b^2 = c^2 $$ {#eq:pitagora}

Referenca na jednačinu: @eq:pitagora.

# Metodologija

Referenca na sliku: @fig:primer.

![Opis slike.](figures/primer.png){#fig:primer width=60%}

Referenca na tabelu: @tbl:primer.

| Kolona A | Kolona B |
|----------|----------|
| 1        | 2        |

: Opis tabele. {#tbl:primer}

# Rezultati

Rezultati istraživanja.

# Zaključak

Zaključak.

# Reference {-}

::: {#refs}
:::
