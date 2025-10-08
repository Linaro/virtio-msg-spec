#!/bin/sh

SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC" $1

rm $SPECDOC.aux $SPECDOC.pdf $SPECDOC.out
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
