// Save output of each loop, assert that they are equal, and exit.

#include <stdio.h>
#include <stddef.h>
#include <assert.h>
#include <stdlib.h>

int main() {
  unsigned array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned);
  unsigned acc = 0;

  // Save the state of everything that is live right before the loop
  // and is rewritten by the loop.
  unsigned int acc_shadow = acc;
  
  for (size_t i = 0; i < N; ++i)
    acc += array[i];

  // Save the state of everything that is live right after the loop
  // and is defined within the loop (the "output" of the loop).
  unsigned int acc_ref = acc;

  // Restore the state.
  acc = acc_shadow;
  
  for (size_t i = 0; i < N; ++i)
    acc += array[i];

  // Save also the "output" of the permuted loop for simplicity, even
  // if this is not strictly necessary.
  unsigned int acc_permuted = acc;

  // Assert that the "outputs" are the same.
  assert(acc_ref == acc_permuted);

  // Exit, as there is no point in continuing the execution.
  exit(EXIT_SUCCESS);
  
  fprintf(stderr, "%u\n", acc);

  return 0;
}
