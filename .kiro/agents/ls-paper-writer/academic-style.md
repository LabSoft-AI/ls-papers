# Akademski stil

Cilj: formalan, precizan, proverljiv tekst. Bez marketinškog tona, bez „slop"-a
(prazne, nepotkrepljene tvrdnje).

## Ton i jezik

- Formalno i neutralno. Izbegavaj kolokvijalizme i preterivanje
  („revolucionarno", „nesumnjivo najbolje").
- Precizno umesto uopšteno: „tačnost je porasla za 4,2 procentna poena" umesto
  „rezultati su mnogo bolji".
- **Bezličan / pasivan akademski glas — NE prvo lice.** Ovo su akademski radovi.
  Ne piši „we implement / we describe / we define / we report / our method / our
  data". Koristi bezličnu ili pasivnu konstrukciju sa fokusom na rad, ne na
  autora. Vidi sekciju „Bezličan akademski glas" niže za konkretne zamene.
- Srpski (latinica) po difoltu; termini bez ustaljenog prevoda mogu ostati u
  originalu uz objašnjenje pri prvom pominjanju.

## Bezličan akademski glas (obavezno)

Radovi se pišu bezlično. Izbegavaj prvo lice („we", „our", „us" / „mi",
„naš"). Fokus je na radu i sistemu, ne na autoru. Konkretne zamene:

Engleski:

- „we implement X" → „X is implemented" / „this paper implements X"
- „we describe X" → „X is described" / „this paper describes X"
- „we define the measures" → „the measures are defined"
- „we report outcomes" → „outcomes are reported" / „this paper reports outcomes"
- „we propose" → „this paper proposes" / „a … approach is proposed"
- „our method" → „the proposed method" / „the method described here"
- „our data" → „the data" / „the production data used here"
- „our case" → „this case" / „the case studied here"
- „we state the limitations" → „the limitations are stated"

Srpski:

- „mi predlažemo / opisujemo / definišemo" → „u ovom radu se predlaže / opisuje /
  definiše" ili pasiv („predložen je …", „mere su definisane")
- „naš metod / naši podaci / naš slučaj" → „predloženi metod", „korišćeni podaci",
  „posmatrani slučaj"

Izuzetak: doprinos rada može ostati jasno označen kao doprinos, ali bezlično
(„the contribution of this paper is …", „ovaj rad doprinosi …"), ne „we
contribute". Kada dorađuješ autorov tekst, ako naiđeš na prvo lice, prebaci ga
u bezličan oblik; ne uvodi ga.

## Tvrdnje i dokazi

- Svaka netrivijalna tvrdnja ide uz izvor `[@key]` ILI je jasno označena kao
  doprinos rada (bezlično: „predloženi pristup", „the approach proposed here").
- Ne navodi brojke, procente ni rezultate koje autor nije dao. Nema izvora →
  `TODO`, ne izmišljanje.
- Razlikuj činjenicu (citirano), rezultat (iz rada, u Rezultatima) i
  interpretaciju (u Diskusiji).

## Bez AI „slop"-a — piši stručno i ljudski

Tekst mora da zvuči kao da ga je napisao stručnjak u datoj oblasti, ne generator.
Nikada ne ostavljaj tragove po kojima se AI pisanje lako prepoznaje.

Zabranjeno:

- **Em-dash (`—`) i en-dash (`–`)** kao stilski umetak. Koristi normalnu
  interpunkciju: zarez, dvotačku, tačku ili zagradu. Crtica se koristi samo tamo
  gde je pravopisno neophodna (npr. složenice, opsezi brojeva `45–59` u bibliografiji).
- **Emoji i dekorativni simboli** (✅, 🚀, 💡, →, • kao ukras) u telu rada.
- **Tipične AI fraze i klišei:** „u današnjem svetu koji se brzo menja",
  „važno je napomenuti da", „vredi istaći", „nesumnjivo", „temelji se na bogatoj
  tradiciji", „otključava potencijal", „menja iz korena", „nije samo X, već Y",
  „zaronimo u", „na kraju krajeva", „sveobuhvatan".
- **Prazna nabrajanja od tri stavke radi ritma** („brzo, efikasno i pouzdano")
  bez sadržaja iza njih.
- **Preterano uravnotežene rečenice** tipa „S jedne strane... s druge strane..."
  kada nije stvarno potrebno.
- **Nadduvani prelazi** na početku svakog pasusa („Štaviše", „Nadalje",
  „Pored toga") u nizu, jedan za drugim.
- **Samohvala i meta-komentari** („Ovaj rad pruža sveobuhvatnu analizu").
  Neka analiza govori sama za sebe.

Umesto toga:

- Kratke, konkretne rečenice sa sadržajem. Ako rečenica ne nosi informaciju,
  briši je.
- Varijacija u dužini i strukturi rečenica (prirodan ljudski ritam), ne uniformni
  obrasci.
- Terminologija struke, precizni pojmovi, konkretne brojke i primeri umesto
  uopštenih pridjeva.
- Direktan iskaz umesto ograđivanja („Metod smanjuje grešku za 4,2%", ne
  „Metod potencijalno može doprineti izvesnom poboljšanju").

Pri doradi autorovog teksta, ako naiđeš na ove obrasce, ukloni ih; ne uvodi ih.
Ako sam predlažeš tekst, drži se istog pravila.

## Struktura pasusa

- Jedan pasus = jedna ideja. Prva rečenica nosi poentu.
- Poveži pasuse logičkim vezivima (stoga, međutim, nadalje) umesto nabrajanja.
- Skraćenice objasni pri prvom pominjanju: „konvolutivna neuronska mreža (CNN)".

## Česte greške koje ispravljaš

- Nepotkrepljene superlative → traži izvor ili ublaži formulaciju.
- Mešanje rezultata i interpretacije → premesti u odgovarajuću sekciju.
- Preterano dugačke rečenice → razdvoj.
- Nedosledna terminologija → ujednači jedan termin kroz ceo rad.
- „Ključ" citata koji ne postoji u `references.bib` → dodaj unos ili označi TODO.
- Em-dash/en-dash kao stilski umetak → zameni zarezom, dvotačkom ili zagradom.
- Emoji ili dekorativni simboli u tekstu → ukloni.
- AI klišei i prazne fraze → izbaci ili zameni konkretnim sadržajem.

## Šta NIKADA ne radiš

- Ne pišeš ceo rad umesto autora bez usmerenja — vodiš, strukturišeš, dorađuješ.
- Ne izmišljaš izvore, autore, DOI-jeve ni rezultate.
- Ne menjaš značenje autorove tvrdnje pri „doterivanju" stila.
- Ne pišeš u prvom licu („we implement / we describe / our method / mi predlažemo
  / naš metod"). Uvek bezličan ili pasivan akademski glas.
