# cmake file

macro(DecoupleLoopsFrontPipelineSetupNames)
  set(PIPELINE_NAME "DecoupleLoopsFront")
  set(PIPELINE_INSTALL_TARGET "${PIPELINE_NAME}-install")
endmacro()


macro(DecoupleLoopsFrontPipelineSetup)
  DecoupleLoopsFrontPipelineSetupNames()

  message(STATUS "setting up pipeline DecoupleLoopsFront")

  if(NOT DEFINED ENV{HARNESS_REPORT_DIR})
    message(FATAL_ERROR
      "${PIPELINE_NAME} env variable HARNESS_REPORT_DIR is not defined")
  endif()

  file(TO_CMAKE_PATH $ENV{HARNESS_REPORT_DIR} HARNESS_REPORT_DIR)
  if(NOT EXISTS ${HARNESS_REPORT_DIR})
    file(MAKE_DIRECTORY ${HARNESS_REPORT_DIR})
  endif()

  message(STATUS
    "${PIPELINE_NAME} uses env variable: HARNESS_REPORT_DIR=${HARNESS_REPORT_DIR}")

  #

  find_package(DecoupleLoopsFront CONFIG)

  get_target_property(DLF_LIB_LOCATION LLVMDecoupleLoopsFrontPass LOCATION)
endmacro()

DecoupleLoopsFrontPipelineSetup()

#

function(DecoupleLoopsFrontPipeline)
  DecoupleLoopsFrontPipelineSetupNames()

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

  file(TO_CMAKE_PATH ${HARNESS_REPORT_DIR} REPORT_DIR)
  file(TO_CMAKE_PATH ${REPORT_DIR}/${BMK_NAME} REPORT_DIR)
  file(MAKE_DIRECTORY ${REPORT_DIR})

  llvmir_attach_opt_pass_target(${PIPELINE_PREFIX}_le
    ${DEPENDEE_TRGT}
    -loop-extract)
  add_dependencies(${PIPELINE_PREFIX}_le ${DEPENDEE_TRGT})

  llvmir_attach_opt_pass_target(${PIPELINE_PREFIX}_dlf
    ${PIPELINE_PREFIX}_le
    -load ${DLF_LIB_LOCATION}
    -decouple-loops-front
    -dlf-debug
    -dlf-bb-annotate-type
    -dlf-bb-annotate-weight
    -dlf-bb-prefix-type
    -dlf-report ${HARNESS_REPORT_DIR}/${BMK_NAME}
    -dlf-dot-cfg-only
    -dlf-dot-dir ${REPORT_DIR})
  add_dependencies(${PIPELINE_PREFIX}_dlf ${PIPELINE_PREFIX}_le)

  llvmir_attach_executable(${PIPELINE_PREFIX}_bc_exe ${PIPELINE_PREFIX}_dlf)
  add_dependencies(${PIPELINE_PREFIX}_bc_exe ${PIPELINE_PREFIX}_dlf)

  target_link_libraries(${PIPELINE_PREFIX}_bc_exe m)

  ## pipeline aggregate targets
  add_custom_target(${PIPELINE_SUBTARGET} DEPENDS
    ${DEPENDEE_TRGT}
    ${PIPELINE_PREFIX}_le
    ${PIPELINE_PREFIX}_dlf
    ${PIPELINE_PREFIX}_bc_exe)

  add_dependencies(${PIPELINE_NAME} ${PIPELINE_SUBTARGET})

  InstallDecoupleLoopsFrontPipelineLLVMIR(DEPENDS ${PIPELINE_PREFIX}_dlf DESTINATION .)
endfunction()


function(InstallDecoupleLoopsFrontPipelineLLVMIR)
  DecoupleLoopsFrontPipelineSetupNames()

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


