#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  void *stack_start = NULL;
  void *heap_start = NULL;

  stack_start = __builtin_frame_address(0);
  fprintf(stderr, "stack starting at: %p\n", stack_start);

  heap_start = malloc(sizeof(int));
  fprintf(stderr, "heap starting at: %p\n", heap_start);
  free(heap_start);

  return 0;
}
