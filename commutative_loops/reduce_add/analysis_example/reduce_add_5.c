// Permute second loop. This intermediate step compiles but does not
// produce a correct execution as the permutation array is
// uninitialized.

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

  // Introduce permutation array with the same iteration space as the
  // loop. This trick might not generalize all the way, for example
  // how do we permute iteration over linked lists?
  size_t p[N];
  // Introduce a level of indirection for the loop iteration. The loop
  // iterates now over the permutation array, which by construction
  // has the same iteration space as the original loop.
  for (size_t k = 0; k < N; ++k) {
    // We define the original induction variable here ("i") so no
    // renaming is needed within the body of the loop.
    size_t i = p[k];
    // The body of the loop remains intact.
    acc += array[i];
  }

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
