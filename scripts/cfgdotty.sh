#!/usr/bin/env bash

fname=$(basename $1)
suffix=${fname##*\.}
prefix=${fname%%\.*}


opt -dot-cfg-only -disable-output ${fname}

for f in *.dot; do
  dot -Tpdf $f -o "${prefix}.pdf"
done

exit 0

