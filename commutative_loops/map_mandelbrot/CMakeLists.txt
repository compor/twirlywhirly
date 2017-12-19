# cmake file

set(EXAMPLE_NAME "map_mandelbrot")

add_executable(${EXAMPLE_NAME}
  ${EXAMPLE_NAME}.c)

set_target_properties(${EXAMPLE_NAME} PROPERTIES LINKER_LANGUAGE C)

if(COMMAND LoopC14NPipeline)
  LoopC14NPipeline(NAME ${EXAMPLE_NAME} DEPENDS ${EXAMPLE_NAME})
endif()

if(COMMAND DecoupleLoopsFrontPipeline)
  DecoupleLoopsFrontPipeline(NAME ${EXAMPLE_NAME} 
    DEPENDS LoopC14N_${EXAMPLE_NAME}_link)
endif()

if(COMMAND TerracePipeline)
  TerracePipeline(NAME ${EXAMPLE_NAME} 
    DEPENDS DecoupleLoopsFront_${EXAMPLE_NAME}_dlf)
endif()

if(COMMAND MemProfilerPipeline)
  MemProfilerPipeline(NAME ${EXAMPLE_NAME} DEPENDS Terrace_${EXAMPLE_NAME}_link)
endif()

get_target_property(OUTDIR 
  MemProfiler_${EXAMPLE_NAME}_bc_exe RUNTIME_OUTPUT_DIRECTORY)

copy_rt_scripts(PROGRAM_NAME MemProfiler_${EXAMPLE_NAME}_bc_exe 
  DESTINATION "${OUTDIR}/scripts")


# installation

install(TARGETS MemProfiler_${EXAMPLE_NAME}_bc_exe 
  RUNTIME DESTINATION "${EXAMPLE_NAME}")

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/expected.txt" 
  DESTINATION "${EXAMPLE_NAME}")

install(DIRECTORY "${OUTDIR}/scripts/" 
  DESTINATION "${EXAMPLE_NAME}" USE_SOURCE_PERMISSIONS)

