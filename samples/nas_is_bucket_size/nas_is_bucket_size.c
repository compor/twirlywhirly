// Loop extracted from IS (SNU NPB). Neither ICC nor LLVM+Polly can parallelize
// this.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <klee/klee.h>

#include "common.h"

int i;

// loop_body(i): key_array, shift -> bucket_size.
void loop_body(int i, int key_array[], int shift, int bucket_size[]) {
  // We assume no UB on every memory access.
  klee_assume(i >= 0);
  klee_assume(i < SIZE_OF_BUFFERS);
  klee_assume((key_array[i] >> shift) >= 0);
  klee_assume((key_array[i] >> shift) < NUM_BUCKETS);
  bucket_size[key_array[i] >> shift]++;
}

int memequal(int *c1, int *c2, size_t len) {
  int equal = 1;
  while (len) {
    equal &= *c1 == *c2;
    c1++;
    c2++;
    len--;
  }
  return equal;
}

int main() {

  // Induction variable.
  int i;

  // Symbolic input and output.

  int key_array[SIZE_OF_BUFFERS];
  klee_make_symbolic(&key_array, sizeof(key_array), "key_array");
  int shift;
  klee_make_symbolic(&shift, sizeof(shift), "shift");
  int bucket_size[NUM_BUCKETS];
  klee_make_symbolic(&bucket_size, sizeof(bucket_size), "bucket_size");

  // Constraints derived from static analysis of the code.

  // Derived from the initialization of shift at the beginning of 'rank'.
  klee_assume(shift == MAX_KEY_LOG_2 - NUM_BUCKETS_LOG_2);
  // Derived from the initialization of 'bucket_size' right before the loop.
  for( i=0; i<NUM_BUCKETS; i++ ) {
    klee_assume(bucket_size[i] == 0);
  }

  // Save the state.
  int bucket_size_shadow[NUM_BUCKETS];
  memcpy(bucket_size_shadow, bucket_size, sizeof(bucket_size));

  // Reference loop: i, key_array, shift -> bucket_size.
  for( i=0; i<NUM_KEYS; i++ ) {
    loop_body(i, key_array, shift, bucket_size);
  }

  // Save the output.
  int bucket_size_ref[NUM_BUCKETS];
  memcpy(bucket_size_ref, bucket_size, sizeof(bucket_size));

  // Restore the state.
  memcpy(bucket_size, bucket_size_shadow, sizeof(bucket_size_shadow));

  // Introduce permutation array (iteration space between 0 and NUM_KEYS - 1).
  const size_t Np = NUM_KEYS;
  size_t p[Np];
  // Declare the permutation array as symbolic.
  klee_make_symbolic(&p, sizeof(p), "p");
  for (unsigned int i = 0; i < Np; i++) {
    // Define the domain of the permutation array.
    klee_assume(p[i] < NUM_KEYS);
    // Enforce that the array's values indeed form a permutation (they
    // are pairwise different).
    for (unsigned int j = i + 1; j < Np; j++) {
      klee_assume(p[i] != p[j]);
    }
  }

  // Symbolically-permuted loop.
  for (size_t k = 0; k < Np; ++k) {
    loop_body(p[k], key_array, shift, bucket_size);
  }

  // Save the output.
  int bucket_size_permuted[NUM_BUCKETS];
  memcpy(bucket_size_permuted, bucket_size, sizeof(bucket_size));

  // Assert that the outputs are the same.
  for( i=0; i<NUM_BUCKETS; i++ ) {
    assert(bucket_size_permuted[i] == bucket_size_ref[i]);
  }

  // Note that the following alternative:
  //   assert(memcmp(bucket_size_permuted, bucket_size_ref, sizeof(bucket_size_ref)) == 0);
  // is more expensive to execute symbolically, see http://mailman.ic.ac.uk/pipermail/klee-dev/2014-July/000755.html
  //
  // Here is a rough evaluation of three alternatives (run on Roberto's machine 9/9/2019)
  //
  // Alternative (a):
  //
  // assert(memcmp(bucket_size_permuted, bucket_size_ref, sizeof(bucket_size_ref)) == 0);
  //
  // Runtimes: 4.4s 4.8s 4.6s 4.6s 4.7s
  //
  // Alternative (b):
  //
  // assert(memequal(bucket_size_permuted, bucket_size_ref, NUM_BUCKETS));
  //
  // Runtimes: 4.1s 4.2s 4.1s 4.0s 4.3s
  //
  // Alternative (c):
  //
  // for( i=0; i<NUM_BUCKETS; i++ ) {
  //  assert(bucket_size_permuted[i] == bucket_size_ref[i]);
  // }
  //
  // Runtimes: 2.8s 3.0s 2.7s 2.9s 2.7s

  // Exit, as there is no point in continuing the execution.
  exit(EXIT_SUCCESS);
}
