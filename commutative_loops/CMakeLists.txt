# cmake file

if(NOT LLVM_FOUND)
  message(FATAL_ERROR "This part of the project requires LLVM!")
endif()

include(LoopC14N)
include(Terrace)
include(MemProfiler)

add_subdirectory(map_simple)
add_subdirectory(map_saxpy)
add_subdirectory(reduce_add)
add_subdirectory(map_reduce_dot_product)
add_subdirectory(scan_add)
add_subdirectory(cross_iteration_deps)
add_subdirectory(cross_iteration_deps_fake)


# installation

install(PROGRAMS "${CMAKE_SOURCE_DIR}/utils/scripts/install_tree/prepare_env.sh"
  DESTINATION "scripts")

install(PROGRAMS
  "${CMAKE_SOURCE_DIR}/utils/scripts/install_tree/check_commutativity.sh"
  DESTINATION "scripts")

install(PROGRAMS
  "${CMAKE_SOURCE_DIR}/utils/scripts/install_tree/run_commutativity.sh"
  DESTINATION "scripts")

