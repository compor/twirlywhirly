# cmake file

if(NOT LLVM_FOUND)
  message(FATAL_ERROR "This part of the project requires LLVM!")
endif()

include(LoopC14N)
include(Terrace)
include(MemProfiler)

add_subdirectory(map_simple)
add_subdirectory(map_saxpy)
add_subdirectory(map_mandelbrot)
add_subdirectory(reduce_add)
add_subdirectory(reduce_histogram)
add_subdirectory(reduce_concat)
add_subdirectory(map_reduce_dot_product)
add_subdirectory(matrix_product)
add_subdirectory(scan_add)
add_subdirectory(stencil_simple)
add_subdirectory(list_traversal_update)
add_subdirectory(linear_search)
add_subdirectory(binary_search)
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

