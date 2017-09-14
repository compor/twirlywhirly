# cmake file

add_executable(cross_iteration_deps
  cross_iteration_deps.c)

set_target_properties(cross_iteration_deps PROPERTIES LINKER_LANGUAGE C)

LoopC14NPipeline(NAME cross_iteration_deps DEPENDS cross_iteration_deps)
TerracePipeline(NAME cross_iteration_deps DEPENDS LoopC14N_cross_iteration_deps_link)
MemProfilerPipeline(NAME cross_iteration_deps DEPENDS Terrace_cross_iteration_deps_link)

get_target_property(OUTDIR 
  MemProfiler_cross_iteration_deps_bc_exe RUNTIME_OUTPUT_DIRECTORY)

copy_rt_scripts(PROGRAM_NAME MemProfiler_cross_iteration_deps_bc_exe 
  DESTINATION "${OUTDIR}/scripts")

# installation

install(TARGETS MemProfiler_cross_iteration_deps_bc_exe 
  RUNTIME DESTINATION "cross_iteration_deps")

install(DIRECTORY "${OUTDIR}/scripts/" 
  DESTINATION "cross_iteration_deps" USE_SOURCE_PERMISSIONS)

