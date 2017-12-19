#!/usr/bin/env bash

[[ -z "${1}" ]] && echo "error: source bitcode file was not provided" && exit 1
INPUT_FILE=$1

#

FNAME=$(basename $INPUT_FILE)
SUFFIX=${FNAME##*\.}
PREFIX=${FNAME%%\.*}
OUTPUT_FILE="${PREFIX}.pdf"

opt -dot-cfg-only -disable-output ${INPUT_FILE}
[[ $? -ne 0 ]] && exit 1

for dotfile in *.dot; do
  dot -Tpdf ${dotfile} -o ${OUTPUT_FILE}
done

