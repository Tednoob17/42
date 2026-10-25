MODULES := $(wildcard 00-guide/*/subject) $(wildcard 01-piscine/*/subject) $(wildcard 02-hors-pool/*/subject)

.PHONY: all clean distclean

all:
	@for d in $(MODULES); do \
		echo "==> $$d"; \
		$(MAKE) -C $$d || exit 1; \
	done

clean:
	@for d in $(MODULES); do $(MAKE) -C $$d clean; done

distclean:
	@for d in $(MODULES); do $(MAKE) -C $$d distclean; done
