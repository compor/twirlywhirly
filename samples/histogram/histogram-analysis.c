// 2nd loop from
// https://sites.google.com/site/parallelizationforllvm/why-not-polly
// transformed for commutativity analysis, see comments in histogram.c.

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <klee/klee.h>

const size_t M = 4;

unsigned count[M];

const size_t N = 5;

unsigned src[N] = {0,1,2,3,0};

void loop_body(unsigned i, unsigned count[], unsigned src[]) {
  count[src[i]]++;
}

int main() {

  // Save the state.
  unsigned count_shadow[M];
  memcpy(count_shadow, count, sizeof(count));

  // Reference loop (input: i, src; output: count).
  //
  // FUNNY: if the positions of 'count' and 'src' as arguments are permuted,
  // klee fails with "memory error: out of bound pointer".
  for (unsigned i = 0; i < N; i++)
    loop_body(i, count, src);

  // Save the output.
  unsigned int count_ref[N];
  memcpy(count_ref, count, sizeof(count));

  // Restore the state.
  memcpy(count, count_shadow, sizeof(count_shadow));

  // Introduce permutation array (iteration space between 0 and N - 1).
  const size_t Np = N;
  size_t p[Np];
  // Declare the permutation array as symbolic.
  klee_make_symbolic(&p, sizeof(p), "p");
  for (unsigned int i = 0; i < Np; i++) {
    // Define the domain of the permutation array.
    klee_assume(p[i] < N);
    // Enforce that the array's values indeed form a permutation (they
    // are pairwise different).
    for (unsigned int j = i + 1; j < Np; j++) {
      klee_assume(p[i] != p[j]);
    }
  }

  // Symbolically-permuted loop.
  for (size_t k = 0; k < Np; ++k) {
    loop_body(p[k], count, src);
  }

  // Save the output.
  unsigned int count_permuted[N];
  memcpy(count_permuted, count, sizeof(count));

  // Assert that the outputs are the same.
  assert(memcmp(count_permuted, count_ref, sizeof(count_ref)) == 0);

  // Exit, as there is no point in continuing the execution.
  exit(EXIT_SUCCESS);

  for (unsigned i = 0; i < M; i++)
    printf("%u\n", count[i]);

  return 0;
}
