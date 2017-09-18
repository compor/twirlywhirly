
#include <stdio.h>
#include <stddef.h>

int main() {
  unsigned array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned int);
  size_t i;
  unsigned v = 33;

  for (i = 0; i < N; ++i)
    if (array[i] == v)
      break;

  fprintf(stderr, "%u\n", v);
  fprintf(stderr, "%u\n", array[N / 2]);

  return 0;
}
