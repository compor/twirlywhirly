# cmake file

set(TOOL_NAME "stack_heap_printer")

add_executable(${TOOL_NAME}
  ${TOOL_NAME}.c)

install(TARGETS ${TOOL_NAME}
  RUNTIME DESTINATION "utils/${TOOL_NAME}")

