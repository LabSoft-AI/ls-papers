# Per-paper build overrides for the master thesis (issue #16).
# Included by shared/build.mk (via `-include paper.mk`).
#
# FTN master thesis: Serbian (Cyrillic), author-date citations (APA-style, as in
# the reference template), and the FTN master Word template for DOCX output.
CSL := $(SHARED)/resources/apa.csl
DOCX_TEMPLATE := $(SHARED)/resources/ftn-master-thesis-template.docx
