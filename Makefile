# -*- Mode: makefile -*-
#
# Basic Makefile to aid automation of document building
#

.PHONY: all draft
all:
	./makeall.sh

draft:
	./makeall.sh draft

.PHONY: html draft-html
html:
	./makehtml.sh

draft-html:
	./makehtml.sh draft

.PHONY: clean
clean:
	git clean -fd

.PHONY: help
help:
	@echo "Build the VIRTIO specification documents."
	@echo ""
	@echo "Possible operations are:"
	@echo
	@echo " $(MAKE)            Build everything"
	@echo " $(MAKE) draft      Build unofficial draft"
	@echo " $(MAKE) html       Build just html"
	@echo " $(MAKE) draft-html Build just draft html"
	@echo " $(MAKE) clean      Remove all intermediate files"
