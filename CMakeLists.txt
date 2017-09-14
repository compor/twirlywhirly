# cmake file

cmake_minimum_required(VERSION 3.0)

project(twirlywhirly C)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

include(Utils)

find_package(LLVM REQUIRED CONFIG)

if(LLVM_FOUND)
  set(LLVM_LIB_DIR ${LLVM_TOOLS_BINARY_DIR}/../lib/)

  list(APPEND CMAKE_MODULE_PATH 
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/llvm-ir-cmake-utils/cmake/")

  include(LLVMIRUtil RESULT_VARIABLE LLVM_IR_UTIL_FOUND)
endif()

set(CMAKE_INSTALL_MESSAGE "LAZY")


#

add_subdirectory(commutative_loops)

