// Example of using LLVM's libfuzzer to test loop commutativity. Run like:
//
// make nas_is_bucket_size_libfuzzer.run

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <assert.h>
#include "FuzzedDataProvider.h"
#include <vector>

// Reduced parameters, for feasibility.
#define NUM_KEYS 4
#define SIZE_OF_BUFFERS NUM_KEYS
#define NUM_BUCKETS 4
#define MAX_KEY_LOG_2 4
#define NUM_BUCKETS_LOG_2 2

#define N NUM_KEYS

// TODO: define custom mutator to always generate correct permutations. Define
// initial permutation as 0 1 2 ...

// loop_body(i): bucket_size, key_array, shift -> bucket_size.
void loop_body(int i, int key_array[], int shift, int bucket_size[]) {
  bucket_size[key_array[i] >> shift]++;
}

void test_permutation(unsigned p[N],
                      int key_array[SIZE_OF_BUFFERS],
                      int shift,
                      int bucket_size[NUM_BUCKETS]) {

  // The array 'bucket_size' is both input and output. Create an instance for
  // each loop and initialize to the input, random values.
  int bucket_size_ref[NUM_BUCKETS],
      bucket_size_permuted[NUM_BUCKETS];
  for( int i=0; i<NUM_BUCKETS; i++ ) {
    bucket_size_ref[i] = bucket_size[i];
    bucket_size_permuted[i] = bucket_size[i];
  }

  // Run original loop.
  for( int i=0; i<NUM_KEYS; i++ ) {
    loop_body(i, key_array, shift, bucket_size_ref);
  }

  // Run commuted loop according to permutation vector p.
  for (unsigned k=0; k < N; k++) {
    loop_body(p[k], key_array, shift, bucket_size_permuted);
  }

  // Assert that the outputs are the same.
  for( int i=0; i<NUM_BUCKETS; i++ ) {
    assert(bucket_size_permuted[i] == bucket_size_ref[i]);
  }

}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {

  FuzzedDataProvider input(data, size);

  // Define a random permutation array.
  unsigned p[N];
  for (unsigned i = 0; i < N; i++) {
    p[i] = input.ConsumeIntegralInRange(0, N - 1);
  }
  for (unsigned int i = 0; i < N; i++) {
    for (unsigned int j = i + 1; j < N; j++) {
      if (p[i] == p[j]) {
        return 0;
      }
    }
  }

  // Define a random instance of the input arguments.
  int key_array[SIZE_OF_BUFFERS];
  for (unsigned i = 0; i < SIZE_OF_BUFFERS; i++) {
    key_array[i] = input.ConsumeIntegralInRange(0, INT_MAX);
  }
  int shift;
  shift = input.ConsumeIntegralInRange(0, INT_MAX);
  int bucket_size[NUM_BUCKETS];
  for (unsigned i = 0; i < NUM_BUCKETS; i++) {
    bucket_size[i] = input.ConsumeIntegralInRange(0, INT_MAX);
  }

  // Input constraints derived on discarding out-of-bounds UB. If the
  // constraints are not satisfied, discard input.
  for (unsigned int i : key_array) {
    if ((i >> shift) < 0 || (i >> shift) >= NUM_BUCKETS)
      return 0;
  }

  // Print input, for debugging purposes.
  printf("p (size %d): ", N);
  for (unsigned int i : p) {
    printf("%d ", i);
  }
  printf("\n");

  printf("key_array (size %d): ", SIZE_OF_BUFFERS);
  for (unsigned int i : key_array) {
    printf("%d ", i);
  }
  printf("\n");

  printf("shift: %d\n", shift);

  printf("bucket_size (size %d): ", NUM_BUCKETS);
  for (unsigned int i : bucket_size) {
    printf("%d ", i);
  }
  printf("\n");

  test_permutation(p, key_array, shift, bucket_size);

  return 0;
}
