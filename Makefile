.PHONY: paper.pdf all clean

all: bib-update paper.pdf

paper.pdf: paper.tex
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" paper.tex

paper-notodos.pdf: paper.pdf
	pdflatex "\def\notodocomments{}\input{paper}"
	pdflatex "\def\notodocomments{}\input{paper}"
	cp -pf paper.pdf $@

# This target creates:
#   https://homes.cs.washington.edu/~mernst/tmp3/determinism.pdf
web: paper-notodos.pdf
	cp -pf paper-notodos.pdf ${HOME}/public_html/tmp3/determinism.pdf
.PHONY: paper-singlecolumn.pdf paper-notodos.pdf

clean:
	latexmk -CA

martin: paper.pdf
	open paper.pdf

export BIBINPUTS ?= .:bib
bib:
ifdef PLUMEBIB
	ln -s ${PLUMEBIB} $@
else
	git clone https://github.com/mernst/plume-bib.git $@
endif
.PHONY: bib-update
bib-update: bib
# Even if this command fails, it does not terminate the make job.
# However, to skip it, invoke make as:  make NOGIT=1 ...
ifndef NOGIT
	-(cd bib && git pull && make)
endif

TAGS: tags
tags:
	etags `latex-process-inputs -list paper.tex`
