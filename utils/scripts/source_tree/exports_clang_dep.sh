#!/usr/bin/env bash

export CC=clang 
export CXX=clang++

export LLVMCONFIG=$(which llvm-config)

export LINKER_FLAGS="-Wl,-L$(${LLVMCONFIG} --libdir)" 
export LINKER_FLAGS="${LINKER_FLAGS} -lc++ -lc++abi" 

export BUILD_TYPE=Debug

[[ -z ${Terrace_DIR} ]] && echo "missing Terrace_DIR"
export Terrace_DIR

export MemProfiler_DIR
[[ -z ${MemProfiler_DIR} ]] && echo "missing MemProfiler_DIR"

export CommutativityRuntime_DIR
[[ -z ${CommutativityRuntime_DIR} ]] && echo "missing CommutativityRuntime_DIR"

CMAKE_OPTIONS="-DTerrace_DIR=${Terrace_DIR}"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DMemProfiler_DIR=${MemProfiler_DIR}"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCommutativityRuntime_DIR=${CommutativityRuntime_DIR}"
CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCMAKE_INSTALL_RPATH=$(${LLVMCONFIG} --libdir)"

export CMAKE_OPTIONS

