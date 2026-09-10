# shared/build.mk — reusable Pandoc build logic for one paper.
#
# A paper folder includes this file and sets:
#   PAPER   - the source markdown (default: paper.md)
#   OUTNAME - output base filename (default: paper folder name)
#
# Usage from repo root: make paper=<folder>
# Usage inside a paper folder: make -f ../../shared/build.mk

# Repo root relative to a paper folder (papers/<name>/ -> ../../)
ROOT ?= ../..
SHARED := $(ROOT)/shared
BUILDDIR ?= public

PAPER ?= paper.md
OUTNAME ?= $(notdir $(CURDIR))

# Pandoc source format: markdown + LaTeX math + raw tex
FROM := markdown+tex_math_single_backslash+tex_math_dollars+raw_tex

# Shared resources
CSL := $(SHARED)/resources/ieee.csl
DOCX_TEMPLATE := $(SHARED)/resources/template.docx
ODT_TEMPLATE := $(SHARED)/resources/template.odt

# Common pandoc flags (crossref for figures/tables/eqs, citeproc for citations)
PANDOC_COMMON := \
	--filter pandoc-crossref \
	--citeproc \
	--csl=$(CSL) \
	--from=$(FROM) \
	--variable urlcolor=blue

.PHONY: all pdf docx odt clean

all: pdf docx odt

pdf:
	mkdir -p $(BUILDDIR)
	pandoc $(PAPER) \
		$(PANDOC_COMMON) \
		--to=latex \
		--pdf-engine=xelatex \
		--output=$(BUILDDIR)/$(OUTNAME).pdf

docx:
	mkdir -p $(BUILDDIR)
	pandoc $(PAPER) \
		$(PANDOC_COMMON) \
		--to=docx \
		--reference-doc=$(DOCX_TEMPLATE) \
		--output=$(BUILDDIR)/$(OUTNAME).docx

odt:
	mkdir -p $(BUILDDIR)
	pandoc $(PAPER) \
		$(PANDOC_COMMON) \
		--to=odt \
		--reference-doc=$(ODT_TEMPLATE) \
		--output=$(BUILDDIR)/$(OUTNAME).odt

clean:
	rm -rf $(BUILDDIR)
