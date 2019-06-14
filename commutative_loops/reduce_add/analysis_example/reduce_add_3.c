// Restore state after first loop.

#include <stdio.h>
#include <stddef.h>

int main() {
  unsigned array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned);
  unsigned acc = 0;

  // Save the state of everything that is live right before the loop
  // and is rewritten by the loop.
  unsigned int acc_shadow = acc;
  
  for (size_t i = 0; i < N; ++i)
    acc += array[i];

  // Restore the state.
  acc = acc_shadow;
  
  for (size_t i = 0; i < N; ++i)
    acc += array[i];
  
  fprintf(stderr, "%u\n", acc);

  return 0;
}
