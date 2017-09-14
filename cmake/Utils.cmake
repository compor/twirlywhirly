# cmake file

include(CMakeParseArguments)

function(copy_rt_scripts)
  set(options)
  set(oneValueArgs DESTINATION PROGRAM_NAME)
  set(multiValueArgs)
  cmake_parse_arguments(COPY_RT_SCRIPTS
    "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  if(NOT COPY_RT_SCRIPTS_DESTINATION)
    message(FATAL_ERROR "command 'copy_rt_scripts': missing DESTINATION option")
  endif()

  if(NOT COPY_RT_SCRIPTS_PROGRAM_NAME)
    message(FATAL_ERROR "command 'copy_rt_scripts': missing PROGRAM_NAME option")
  endif()

  if(COPY_RT_SCRIPTS_UPARSED_ARGUMENTS)
    message(FATAL_ERROR "command 'copy_rt_scripts': extraneous arguments")
  endif()

  set(PROGRAM_NAME "${COPY_RT_SCRIPTS_PROGRAM_NAME}")
  set(DESTINATION "${COPY_RT_SCRIPTS_DESTINATION}")

  file(TO_CMAKE_PATH "${CMAKE_SOURCE_DIR}/utils/scripts/install_tree/"
    SCRIPTS_DIR)

  set(PROFILE_SCRIPT "prof.sh")
  set(TEST_SCRIPT "test.sh")

  configure_file("${SCRIPTS_DIR}/${PROFILE_SCRIPT}.in"
    "${DESTINATION}/${PROFILE_SCRIPT}" @ONLY)

  configure_file("${SCRIPTS_DIR}/${TEST_SCRIPT}.in"
    "${DESTINATION}/${TEST_SCRIPT}" @ONLY)
endfunction()

