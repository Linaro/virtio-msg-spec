# -*- Mode: makefile -*-
#
# Basic Makefile to aid automation of document building
#

.PHONY: all local
all:
	./makeall.sh

local-all:
	./makeall.sh local

.PHONY: html local-html

html:
	./makehtml.sh

local-html:
	./makehtml.sh local

.PHONY: clean
clean:
	git clean -fd

.PHONY: help
help:
	@echo "Build the VIRTIO specification documents."
	@echo ""
	@echo "Possible operations are:"
	@echo
	@echo " $(MAKE)         Build everything"
	@echo " $(MAKE) html    Build local html"
	@echo " $(MAKE) clean   Remove all intermediate files"
