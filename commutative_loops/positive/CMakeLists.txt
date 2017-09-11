# cmake file

add_executable(simple_map
  simple_map.c)

set_target_properties(simple_map PROPERTIES LINKER_LANGUAGE C)

LoopC14NPipeline(NAME simple_map DEPENDS simple_map)
MemProfilerPipeline(NAME simple_map DEPENDS LoopC14N_simple_map_link)

