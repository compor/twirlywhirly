
#include <stdio.h>
#include <stddef.h>

int main() {
  unsigned array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned int);
  unsigned j = 0;

  for (size_t i = 0; i < N; ++i) {
    array[i] = i;
    j++;
  }

  fprintf(stderr, "%u\n", array[N / 2]);
  fprintf(stderr, "%u\n", j);

  return 0;
}
