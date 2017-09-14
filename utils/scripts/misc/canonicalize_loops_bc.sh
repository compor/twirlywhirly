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
OUTPUT_FILE="${PREFIX}-canon.bc"

clang -c -emit-llvm ${INPUT_FILE} && \
opt -loop-simplify "${PREFIX}.bc" -o ${OUTPUT_FILE} && \
llvm-dis ${OUTPUT_FILE} 

exit $?

