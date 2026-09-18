# Per-paper build overrides for the Future-BME submission.
# Included by shared/build.mk (via `-include paper.mk`).
#
# Future-BME requires: APA 7th referencing and their Word template
# (B5, Cambria). We reuse the conference .docx as the pandoc reference-doc so
# DOCX output inherits their styles.
CSL := $(SHARED)/resources/apa.csl
DOCX_TEMPLATE := $(SHARED)/resources/future-bme-template.docx
