# cmake file

add_executable(simple_map
  simple_map.c)

set_target_properties(simple_map PROPERTIES LINKER_LANGUAGE C)

LoopC14NPipeline(DEPENDS simple_map)

