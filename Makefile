# ls-papers — root Makefile
#
# Build one paper:   make paper=luka-master
# Build one format:  make paper=luka-master pdf
# Build all papers:  make all
# Clean one:         make paper=luka-master clean
# Clean all:         make clean

PAPERS := $(notdir $(wildcard papers/*))

# Build a single paper by delegating to shared/build.mk inside its folder.
ifdef paper
.PHONY: all pdf docx odt clean
all pdf docx odt clean:
	$(MAKE) -C papers/$(paper) -f $(CURDIR)/shared/build.mk ROOT=$(CURDIR) $@
else

.PHONY: all clean list
all:
	@for p in $(PAPERS); do \
		echo "==> Building $$p"; \
		$(MAKE) -C papers/$$p -f $(CURDIR)/shared/build.mk ROOT=$(CURDIR) all || exit 1; \
	done

clean:
	@for p in $(PAPERS); do \
		$(MAKE) -C papers/$$p -f $(CURDIR)/shared/build.mk ROOT=$(CURDIR) clean; \
	done

list:
	@echo "Papers:"; for p in $(PAPERS); do echo "  - $$p"; done

endif
