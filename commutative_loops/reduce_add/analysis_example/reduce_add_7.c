// Make permutation *and* input symbolic. This step goes beyond the
// original program. The size of the array is reduced for feasibility.

#include <stdio.h>
#include <stddef.h>
#include <assert.h>
#include <stdlib.h>
#include "klee/klee.h"

int main() {

  const size_t N = 4;
  const size_t M = 100;
  // Make input symbolic (but bounded in size and value domain).
  unsigned array[N];
  klee_make_symbolic(&array, sizeof(array), "array");
  for (unsigned int i = 0; i < N; i++) {
    // Define the domain.
    klee_assume(array[i] < M);
  }
  
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
  // Declare the permutation array as symbolic.
  klee_make_symbolic(&p, sizeof(p), "p");
  for (unsigned int i = 0; i < N; i++) {
    // Define the domain of the permutation array.
    klee_assume(p[i] < N);
    // Enforce that the array's values indeed form a permutation (they
    // are pairwise different).
    for (unsigned int j = i + 1; j < N; j++) {
      klee_assume(p[i] != p[j]);
    }
  }

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
