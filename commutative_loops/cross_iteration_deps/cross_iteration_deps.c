
#include <stdio.h>
#include <stddef.h>

int main() {
  unsigned int array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned int);

  for (size_t i = 1; i < N; ++i)
    array[i] += array[i - 1];

  fprintf(stderr, "%u\n", array[N / 2]);

  return 0;
}
