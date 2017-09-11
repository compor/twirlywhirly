# cmake file

macro(MemProfilerPipelineSetupNames)
  set(PIPELINE_NAME "MemProfiler")
  string(TOUPPER "${PIPELINE_NAME}" PIPELINE_NAME_UPPER)
  set(PIPELINE_INSTALL_TARGET "${PIPELINE_NAME}-install")
endmacro()

macro(MemProfilerPipelineSetup)
  MemProfilerPipelineSetupNames()

  message(STATUS "setting up pipeline ${PIPELINE_NAME}")

  #

  find_package(MemProfiler CONFIG)

  if(NOT MemProfiler_FOUND)
    message(FATAL_ERROR "package MemProfiler was not found")
  endif()

  get_target_property(MEMPROFILER_LIB_LOCATION LLVMMemProfilerPass LOCATION)
endmacro()

MemProfilerPipelineSetup()

#

function(MemProfilerPipeline)
  MemProfilerPipelineSetupNames()

  set(options ALL)
  set(oneValueArgs NAME DEPENDS)
  set(multiValueArgs)
  cmake_parse_arguments(${PIPELINE_NAME_UPPER}
    "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(TRGT ${${PIPELINE_NAME_UPPER}_DEPENDS})
  set(NAME ${${PIPELINE_NAME_UPPER}_NAME})

  if(NOT TRGT)
    message(FATAL_ERROR "pipeline ${PIPELINE_NAME}: missing DEPENDS target")
  endif()

  if(NOT NAME)
    message(FATAL_ERROR "pipeline ${PIPELINE_NAME}: missing NAME option")
  endif()

  if(${PIPELINE_NAME_UPPER}_ALL)
    set(ALL_OPTION "ALL")
  endif()

  if(${PIPELINE_NAME_UPPER}_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "pipeline ${PIPELINE_NAME}: has extraneous arguments \
    ${${PIPELINE_NAME_UPPER}_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT TARGET ${TRGT})
    message(FATAL_ERROR "pipeline ${PIPELINE_NAME}: ${TRGT} is not a target")
  endif()

  if(NOT TARGET ${PIPELINE_NAME})
    add_custom_target(${PIPELINE_NAME})
  endif()

  set(PIPELINE_SUBTARGET "${PIPELINE_NAME}_${NAME}")
  set(PIPELINE_PREFIX ${PIPELINE_SUBTARGET})

  ## pipeline targets and chaining
  set(DEPENDEE_TRGT ${TRGT})

  llvmir_attach_opt_pass_target(${PIPELINE_PREFIX}_link
    ${DEPENDEE_TRGT}
    -load ${MEMPROFILER_LIB_LOCATION}
    -dynapar-memprof -memprof-instrument-control=false)
  add_dependencies(${PIPELINE_PREFIX}_link ${DEPENDEE_TRGT})

  llvmir_attach_executable(${PIPELINE_PREFIX}_bc_exe ${PIPELINE_PREFIX}_link)
  add_dependencies(${PIPELINE_PREFIX}_bc_exe ${PIPELINE_PREFIX}_link)

  target_link_libraries(${PIPELINE_PREFIX}_bc_exe m)

  ## pipeline aggregate targets
  add_custom_target(${PIPELINE_SUBTARGET} DEPENDS
    ${PIPELINE_PREFIX}_link
    ${PIPELINE_PREFIX}_bc_exe)

  add_dependencies(${PIPELINE_NAME} ${PIPELINE_SUBTARGET})

  InstallMemProfilerLLVMIRPipeline(DEPENDS ${PIPELINE_PREFIX}_link DESTINATION .)
endfunction()


function(InstallMemProfilerLLVMIRPipeline)
  MemProfilerPipelineSetupNames()

  set(options)
  set(oneValueArgs DEPENDS DESTINATION)
  set(multiValueArgs)
  cmake_parse_arguments(${PIPELINE_NAME_UPPER}
    "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(TRGT ${${PIPELINE_NAME_UPPER}_DEPENDS})
  set(DEST_DIR ${${PIPELINE_NAME_UPPER}_DESTINATION})

  if(NOT TRGT)
    message(FATAL_ERROR "pipeline ${PIPELINE_NAME}: missing DEPENDS target")
  endif()

  if(NOT DEST_DIR)
    message(FATAL_ERROR "pipeline ${PIPELINE_NAME}: missing DESTINATION")
  endif()

  if(NOT TARGET ${PIPELINE_INSTALL_TARGET})
    add_custom_target(${PIPELINE_INSTALL_TARGET})
  endif()

  if(NOT IS_ABSOLUTE ${DEST_DIR})
    set(DEST_DIR ${CMAKE_INSTALL_PREFIX}/${DEST_DIR})
  endif()

  get_property(LLVMIR_DIR TARGET ${TRGT} PROPERTY LLVMIR_DIR)

  file(TO_NATIVE_PATH ${LLVMIR_DIR} LLVMIR_NDIR)
  file(TO_NATIVE_PATH ${DEST_DIR} DEST_NDIR)

  set(PIPELINE_PART_INSTALL_TARGET "${TRGT}-install")

  add_custom_target(${PIPELINE_PART_INSTALL_TARGET}
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${LLVMIR_DIR} ${DEST_NDIR})

  add_dependencies(${PIPELINE_PART_INSTALL_TARGET} ${TRGT})
  add_dependencies(${PIPELINE_INSTALL_TARGET} ${PIPELINE_PART_INSTALL_TARGET})
endfunction()

