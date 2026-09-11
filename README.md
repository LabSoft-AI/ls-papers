# ls-papers

Paper-as-code monorepo for LabSoft research papers and master theses. Write in
Markdown, build to PDF, DOCX, and ODT with Pandoc. Shared IEEE citation style
and document templates.

## Structure

```
ls-papers/
├── Makefile              # build one paper or all
├── shared/
│   ├── build.mk          # reusable Pandoc build logic
│   └── resources/
│       ├── ieee.csl      # IEEE citation style
│       ├── template.docx # DOCX reference style
│       └── template.odt  # ODT reference style
├── papers/               # one folder per paper
│   └── <your-paper>/
│       ├── paper.md
│       ├── references.bib
│       └── figures/
├── template/             # skeleton for a new paper (copy it)
└── .github/workflows/    # CI builds papers on push
```

## Prerequisites

Quickest path — run the setup script (detects your OS and installs everything:
pandoc, pandoc-crossref, XeLaTeX, librsvg, git-lfs, DejaVu font):

```bash
./setup.sh
```

Supports macOS (Homebrew), Debian/Ubuntu (apt), Fedora/RHEL (dnf). For anything
else, install manually:

**macOS (Homebrew):**
```bash
brew install pandoc pandoc-crossref librsvg
brew install --cask mactex-no-gui   # or basictex for a smaller install
```

**Ubuntu/Debian:**
```bash
sudo apt-get install -y pandoc pandoc-crossref \
  texlive-xetex texlive-latex-recommended \
  texlive-latex-extra texlive-fonts-recommended fonts-dejavu
```

Check:
```bash
pandoc --version
pandoc-crossref --version
xelatex --version
```

PDF is built with **XeLaTeX** (Unicode/Cyrillic support). The main font is set
per paper via `mainfont:` in `paper.md` (default `DejaVu Serif`, which covers
Cyrillic and ships with TeX Live). On macOS you can switch to `Times New Roman`.

Binary assets (PNG/JPG/PDF/DOCX/ODT/ODS) are stored via **git-lfs**. Install it
once: `git lfs install`. SVG figures are kept as text (not LFS) and need
`librsvg` for PDF conversion.

## Pre-commit hooks

Quality checks run automatically before each commit. `./setup.sh` installs and
registers them. To do it manually:

```bash
pip3 install --user pre-commit    # or: pipx install pre-commit / brew install pre-commit
pre-commit install                # pre-commit stage
pre-commit install --hook-type commit-msg   # commit message format
```

What runs:

- **Hygiene** — trailing whitespace, end-of-file newline, merge-conflict markers,
  large-file guard (binaries belong in git-lfs), YAML syntax, line endings.
- **Spell-check** — `codespell` catches common English typos. It skips
  `references.bib`, code, and build output; Serbian words and domain terms are
  whitelisted in `.spellignore` (add a lowercase word there if a valid word is
  flagged). Config in `.codespellrc`.
- **Markdown lint** — light rules only (`.markdownlint.yaml`); papers are prose,
  not strict Markdown.
- **Commit message** — enforces `#<issue> <type>(<scope>): <description>`
  (`scripts/check-commit-msg.sh`).

Run against everything at any time:

```bash
pre-commit run --all-files
```

## Start a new paper

```bash
cp -r template papers/<your-paper>
# edit papers/<your-paper>/paper.md, references.bib, add figures/
```

## Build

```bash
make list                      # list all papers
make paper=<your-paper>        # build one paper (pdf + docx + odt)
make paper=<your-paper> pdf    # build one format
make all                       # build every paper
make paper=<your-paper> clean  # remove build output
```

Output lands in `papers/<your-paper>/public/`.

## Writing

- **Citations:** add BibTeX entries to `references.bib`, cite with `[@key]`.
  Formatted with the IEEE style (`shared/resources/ieee.csl`).
- **Figures:** `![Caption](figures/x.png){#fig:label}`, reference with `@fig:label`.
- **Tables:** add `{#tbl:label}` after the caption, reference with `@tbl:label`.
- **Equations:** `$$ ... $$ {#eq:label}`, reference with `@eq:label`.
- Cross-references need `pandoc-crossref` (installed above).

## Conventions

Git and GitHub workflow follows the `ls-git` agent (`.kiro/agents/ls-git`).
Commits: `#<issue> <type>(<scope>): <description>`. Issues in Serbian Cyrillic.
See `.kiro/agents/ls-git/` for full conventions.

## Hosting

Planned (see `LabSoft-AI/world#1789`): private site under `labsoft.ai`
(S3 + CloudFront + auth) listing all built papers.
