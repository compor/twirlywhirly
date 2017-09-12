# cmake file

add_executable(cross_iteration_deps
  cross_iteration_deps.c)

set_target_properties(cross_iteration_deps PROPERTIES LINKER_LANGUAGE C)

LoopC14NPipeline(NAME cross_iteration_deps DEPENDS cross_iteration_deps)
TerracePipeline(NAME cross_iteration_deps DEPENDS LoopC14N_cross_iteration_deps_link)
MemProfilerPipeline(NAME cross_iteration_deps DEPENDS Terrace_cross_iteration_deps_link)


# installation

install(TARGETS MemProfiler_cross_iteration_deps_bc_exe RUNTIME DESTINATION .)

