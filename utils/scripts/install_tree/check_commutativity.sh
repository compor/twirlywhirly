#!/usr/bin/env bash

RC=0
DIRS=$(find $1 -mindepth 1 -maxdepth 1 -type d)

for d in ${DIRS}; do
  pushd ${d} &> /dev/null
  CurRC=0

  if [[ -e expected.txt ]]; then 
    diff -q -w expected.txt commutativity.txt &> /dev/null
    CurRC=$?
  else
    echo "skipping ${d}"
  fi

  if [[ ${CurRC} -ne 0 ]]; then 
    RC=1
    echo "$(basename ${d}) does not match expected results"
  fi

  popd &> /dev/null
done

if [[ ${RC} -eq 0 ]]; then
  echo "all tests match expected results"
fi

exit ${RC}

