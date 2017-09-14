# cmake file

add_executable(simple_map
  simple_map.c)

set_target_properties(simple_map PROPERTIES LINKER_LANGUAGE C)

LoopC14NPipeline(NAME simple_map DEPENDS simple_map)
TerracePipeline(NAME simple_map DEPENDS LoopC14N_simple_map_link)
MemProfilerPipeline(NAME simple_map DEPENDS Terrace_simple_map_link)

get_target_property(OUTDIR 
  MemProfiler_simple_map_bc_exe RUNTIME_OUTPUT_DIRECTORY)

copy_rt_scripts(PROGRAM_NAME MemProfiler_simple_map_bc_exe 
  DESTINATION "${OUTDIR}/scripts")

# installation

install(TARGETS MemProfiler_simple_map_bc_exe 
  RUNTIME DESTINATION "simple_map")

install(DIRECTORY "${OUTDIR}/scripts/" 
  DESTINATION "simple_map" USE_SOURCE_PERMISSIONS)

