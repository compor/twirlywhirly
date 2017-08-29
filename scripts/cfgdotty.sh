#!/usr/bin/env bash

if [ -z "$1" ]; then 
  echo "error: source bitcode file was not provided" 

  exit 1
fi

INPUT_FILE=$1

#

FNAME=$(basename $INPUT_FILE)
SUFFIX=${FNAME##*\.}
PREFIX=${FNAME%%\.*}
OUTPUT_FILE="${PREFIX}.pdf"

opt -dot-cfg-only -disable-output ${INPUT_FILE}
RC=$?

if [ $RC -eq 0 ]; then
  for dotfile in *.dot; do
    dot -Tpdf ${dotfile} -o ${OUTPUT_FILE}
    RC=$?

    if [ ${RC} -ne 0 ]; then 
      break;
    fi
  done
fi

exit $RC

