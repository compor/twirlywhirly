# cmake file

if(NOT LLVM_FOUND)
  message(FATAL_ERROR "This part of the project requires LLVM!")
endif()

include(LoopC14N)
include(Terrace)
include(MemProfiler)

add_subdirectory(positive)
add_subdirectory(negative)


# installation

install(PROGRAMS "${CMAKE_SOURCE_DIR}/utils/scripts/install_tree/prepare_env.sh"
  DESTINATION "scripts")

