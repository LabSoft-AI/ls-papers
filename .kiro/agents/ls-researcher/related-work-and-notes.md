# Related work, gap analiza i istraživačke beleške

## Istraživačke beleške (`research-notes.md`)

Za svaki rad drži beleške u `papers/<name>/research-notes.md`. Ovo je radni
dokument (ne ulazi u build), izvor iz kojeg `ls-paper-writer` piše related work.

Predložena struktura:

```markdown
# Istraživačke beleške: <naslov/tema>

## Tema i istraživačko pitanje
Šta se istražuje, koje pitanje rad postavlja.

## Izvori

### [smith2023] Naslov rada
- **Autori / godina / venue:** ...
- **Link/DOI:** https://doi.org/...
- **Ključni doprinos:** (svojim rečima, 1–2 rečenice)
- **Metod:** ...
- **Rezultat:** ...
- **Relevantnost:** gde ulazi (uvod / related work / diskusija)
- **Napomena:** (moja sinteza — jasno označeno kao moje mišljenje)

## Tematski klasteri
- Tema A: [smith2023], [drugi2024]
- Tema B: ...

## Gap analiza
- Šta je urađeno: ...
- Šta nedostaje / praznina koju rad popunjava: ...
```

Uvek razdvoj **činjenicu iz izvora** (uz link/DOI) od **sopstvene sinteze**
(označi kao svoje). Ne prepisuj tekst izvora doslovno — sumiraj i uputi na izvor.

## Related work sekcija

Ne piši rad umesto autora; pripremi materijal i strukturu.

- **Tematska organizacija** — grupiši izvore po pristupu/problemu, ne hronološki
  nabrajaj „X je uradio, Y je uradio". Svaki klaster ima poentu.
- **Narativ** — pokaži kako se pravci nadovezuju i gde se razilaze.
- **Veza sa radom** — svaki klaster vodi ka praznini koju rad popunjava.
- **Citiranje** — koristi ključeve iz `references.bib` (`[@key]`); ako ključ ne
  postoji, prvo dodaj verifikovan BibTeX unos.

## Gap analiza

1. Mapiraj stanje oblasti (šta postojeći radovi rešavaju).
2. Identifikuj šta ostaje nerešeno ili slabo pokriveno.
3. Poveži prazninu sa ciljem rada iz uvoda (moraju se poklapati).

Gap mora biti potkrepljen izvorima (šta postoji), a ne tvrdnja bez osnova da
„niko ovo nije radio".
