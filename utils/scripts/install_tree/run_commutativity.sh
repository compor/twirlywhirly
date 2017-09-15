#!/usr/bin/env bash

DIRS=$(find $1 -mindepth 1 -maxdepth 1 -type d)

for d in ${DIRS}; do
  pushd ${d} &> /dev/null

  if [[ -e prof.sh ]]; then 
    ./prof.sh
    ./test.sh
  else
    echo "skipping ${d}"
  fi

  popd &> /dev/null
done

exit $?

