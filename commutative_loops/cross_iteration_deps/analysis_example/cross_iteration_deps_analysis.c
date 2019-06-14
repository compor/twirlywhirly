// Same example but transformed in order to test commutativity. Run:
// make cross_iteration_deps_analysis.klee

#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include "klee/klee.h"

int main() {
  unsigned int array[8] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned int);

  // Save the state of 'array'.
  unsigned int array_shadow[N];
  memcpy(array_shadow, array, sizeof(array));

  // Reference loop.
  for (size_t i = 1; i < N; ++i)
    array[i] += array[i - 1];

  // Save the output.
  unsigned int array_ref[N];
  memcpy(array_ref, array, sizeof(array));
  
  // Restore the state.
  memcpy(array, array_shadow, sizeof(array_shadow));

  // Introduce permutation array. Note that it has the size of the
  // iteration space (between 1 and N - 1).
  const size_t Np = N - 1;
  size_t p[Np];
  // Declare the permutation array as symbolic.
  klee_make_symbolic(&p, sizeof(p), "p");
  for (unsigned int i = 0; i < Np; i++) {
    // Define the domain of the permutation array.
    klee_assume(p[i] > 0);
    klee_assume(p[i] < N);
    // Enforce that the array's values indeed form a permutation (they
    // are pairwise different).
    for (unsigned int j = i + 1; j < Np; j++) {
      klee_assume(p[i] != p[j]);
    }
  }
  
  // Symbolically-permuted loop.
  for (size_t k = 0; k < Np; ++k) {
    size_t i = p[k];
    array[i] += array[i - 1];
  }

  // Save the output.
  unsigned int array_permuted[N];
  memcpy(array_permuted, array, sizeof(array));

  // Assert that the outputs are the same.
  assert(memcmp(array_permuted, array_ref, sizeof(array_ref)) == 0);

  // Exit, as there is no point in continuing the execution.
  exit(EXIT_SUCCESS);

  fprintf(stderr, "%u\n", array[N / 2]);

  return 0;
}
