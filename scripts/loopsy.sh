#!/usr/bin/env bash

fname=$(basename $1)
suffix=${fname##*\.}
prefix=${fname%%\.*}


clang -c -emit-llvm ${fname}

outfile="${prefix}-canon.bc"
opt -loop-simplify "${prefix}.bc" -o ${outfile}

llvm-dis ${outfile} 

exit 0

