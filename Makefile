SHELL := /bin/sh
INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
INSTALL_DATA := $(INSTALL) -m 644

MKTEXLSR := mktexlsr
TEX := tex
LATEX := pdflatex
MAKEINDEX := makeindex

name := modernmath
bundle := phst

texmf := $(shell kpsewhich --var-value=TEXMFHOME)
branch := latex/$(bundle)
destdir := $(texmf)/tex/$(branch)
docdir := $(texmf)/doc/$(branch)
auctexdir := ~/.emacs.d/auctex/style

LATEXFLAGS := --file-line-error --interaction=scrollmode
LATEXFLAGS_DRAFT := $(LATEXFLAGS) --draftmode
LATEXFLAGS_FINAL := $(LATEXFLAGS) --synctex=1

source := $(name).dtx
driver := $(name).ins
destination := $(name).sty
manual := $(name).pdf
auctex_style := $(name).el
index_src := $(name).idx
index_dest := $(name).ind
index_sty := gind.ist
changes_src := $(name).glo
changes_dest := $(name).gls
changes_sty := gglo.ist


all: $(destination) $(auctex_style)

pdf: $(manual)

complete: all pdf

install: all
	$(INSTALL) -d $(destdir)
	$(INSTALL_DATA) $(destination) $(destdir)
	$(INSTALL) -d $(auctexdir)
	$(INSTALL_DATA) $(auctex_style) $(auctexdir)
	$(MKTEXLSR)

install-pdf: pdf
	$(INSTALL) -d $(docdir)
	$(INSTALL_DATA) $(manual) $(docdir)
	$(MKTEXLSR)

install-complete: install install-pdf

$(destination): $(source) $(driver)
	$(TEX) $(driver)

$(manual): $(source) $(destination)
	$(LATEX) $(LATEXFLAGS_DRAFT) $(source)
	$(MAKEINDEX) -s $(index_sty) -o $(index_dest) $(index_src)
	$(MAKEINDEX) -s $(changes_sty) -o $(changes_dest) $(changes_src)
	$(LATEX) $(LATEXFLAGS_DRAFT) $(source)
	$(LATEX) $(LATEXFLAGS_FINAL) $(source)

.SUFFIXES:
