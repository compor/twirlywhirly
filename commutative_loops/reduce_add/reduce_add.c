
#include <stdio.h>
#include <stddef.h>

int main() {
  unsigned int array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned int);
  size_t acc = 0;

  for (size_t i = 0; i < N; ++i)
    acc += array[i];

  fprintf(stderr, "%zu\n", acc);

  return 0;
}
