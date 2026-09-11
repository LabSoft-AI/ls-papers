# Format recenzentskog izveštaja

Izveštaj je strukturiran po prioritetu, sa konkretnim, ukotvljenim nalazima.
Opciono se čuva u `papers/<name>/review-notes.md` (jedini fajl koji recenzent piše).

## Prioriteti

- **Kritično** — lomi build, integritet ili glavni argument. Mora se rešiti pre
  predaje. (Npr. citat bez unosa, undefined cross-ref, zaključak koji rezultati
  ne podržavaju, nedostajuća sekcija, mogući plagijat.)
- **Važno** — oslabljuje rad ali ne lomi. Trebalo bi rešiti. (Npr. neobosnovana
  tvrdnja, nejasna metodologija, nekoherentan apstrakt↔zaključak.)
- **Sitno** — poliranje. (Npr. nedosledna terminologija, stil, neiskorišćen bib
  unos, sitne nejasnoće.)

## Struktura nalaza

Svaki nalaz ima: lokaciju, problem, zašto je bitno, predlog (bez pisanja umesto autora).

```
[K/V/S] <sekcija / lokacija> — <kratak naslov problema>
  Problem: šta konkretno nije u redu.
  Zašto: posledica ako se ne reši.
  Predlog: konkretan smer popravke (autor je sprovodi).
```

Primer:
```
[K] Zaključak, 1. pasus — tvrdnja prekoračuje rezultate
  Problem: tvrdi „metod je najbolji", a evaluacija je samo na jednom skupu.
  Zašto: overclaiming; recenzent žurnala će odbiti.
  Predlog: ograniči tvrdnju na testirani skup, ili dodaj evaluaciju na još jednom.

[K] Uvod, 3. pasus — citat bez unosa
  Problem: `[@petrovic2022]` se citira, ali ne postoji u references.bib.
  Zašto: citeproc upozorenje, citat ostaje neformatiran.
  Predlog: dodaj BibTeX unos (ls-researcher) ili ispravi ključ.

[S] Kroz rad — nedosledna terminologija
  Problem: naizmenično „model" i „mreža" za isti pojam.
  Zašto: zbunjuje čitaoca.
  Predlog: izaberi jedan termin i ujednači.
```

## Šablon izveštaja (`review-notes.md`)

```markdown
# Recenzija: <naslov rada> (<datum>)

## Sažetak
2–3 rečenice: opšti utisak, spremnost za predaju, glavni blokери.

## Kritično
- [K] ...

## Važno
- [V] ...

## Sitno
- [S] ...

## Provera citiranja
- Citati bez unosa: ...
- Neiskorišćeni unosi: ...
- Cross-ref problemi: ...

## Šta je dobro
Kratko — šta ne dirati.
```

## Ton

Strog ali konstruktivan. Kritikuj rad, ne autora. Uz svaku manu ide izvodljiv
sledeći korak. Ako je nešto dobro, reci — pomaže autoru da zna šta da zadrži.
