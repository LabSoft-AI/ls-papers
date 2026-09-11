# Provera citiranja i cross-reference (integritet)

Proveri u OBA smera. Ovo su najčešće greške koje autor ne primeti.

## Citiranje: tekst ↔ references.bib

**Smer 1 — svaki citat u tekstu ima unos:**
- Izvuci sve `[@kljuc]` iz `paper.md` (uključujući `[@a; @b]` i inline `@kljuc`).
- Za svaki ključ proveri da postoji `@...{kljuc, ...}` u `references.bib`.
- Ključ bez unosa → citeproc baca upozorenje, citat ostaje neformatiran. Kritično.

**Smer 2 — nema neiskorišćenih unosa:**
- Izvuci sve ključeve definisane u `references.bib`.
- Za svaki proveri da se bar jednom citira u `paper.md`.
- Neiskorišćen unos → obično zaboravljen izvor; predloži brisanje ili citiranje.

Kako pronaći (primeri, ne izvršava build):
- Ključevi iz teksta: traži obrazac `@[A-Za-z0-9_:-]+` u `paper.md`.
- Ključevi iz bib: traži `@\w+\{([^,]+),` u `references.bib` (prvi argument je ključ).
- Uporedi dva skupa; prijavi razliku u oba smera.

## Tvrdnje bez izvora

- Prođi netrivijalne tvrdnje (činjenice o oblasti, brojke, poređenja).
- Ako tvrdnja nije autorov rezultat i nema `[@key]` → označi „treba izvor".
- Ne traži izvor za očigledno / opšte poznato niti za autorove sopstvene rezultate.

## Potencijalni plagijat

- Traži pasuse koji zvuče kao doslovan prepis (nagli skok stila, nepreveden
  fragment, formulacija preblizu poznatom izvoru).
- Ne optužuj — označi kao „proveriti: preblizu izvoru [@key], preformulisati ili
  navesti kao citat".
- Direktan citat mora biti pod navodnicima i sa stranom (`[@key, str. X]`).

## Cross-reference validacija

- Skupi sve definisane labele: `{#fig:...}`, `{#tbl:...}`, `{#eq:...}`, `{#sec:...}`.
- Skupi sve reference: `@fig:...`, `@tbl:...`, `@eq:...`, `@sec:...`.
- Prijavi:
  - referencu bez definisane labele (pandoc-crossref: undefined reference),
  - definisanu labelu koja se nigde ne referencira (verovatno višak),
  - duplirane labele (moraju biti jedinstvene).

## Izlaz ove provere

Sve nalaze ubaci u izveštaj (`report-format.md`) sa tačnim ključem/labelom i
lokacijom. Citatne rupe i undefined reference su po pravilu „kritično" (lome build
ili integritet), neiskorišćeni unosi su „sitno/važno".
