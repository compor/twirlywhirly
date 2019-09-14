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

void test_permutation(std::vector<unsigned char> p) {

  // Define input and output.

  // Input. TODO: fill in randomly
  int key_array[SIZE_OF_BUFFERS];
  // Input. TODO: concretize randomly
  int shift;
  // Input/output. TODO: fill in randomly
  int bucket_size_ref[NUM_BUCKETS];
  // Input/output. TODO: fill in randomly
  int bucket_size_permuted[NUM_BUCKETS];
  for( int i=0; i<NUM_BUCKETS; i++ ) {
    bucket_size_ref[i] = 0;
    bucket_size_permuted[i] = 0;
  }

  // Run original loop.
  for( int i=0; i<NUM_KEYS; i++ ) {
    loop_body(i, key_array, shift, bucket_size_ref);
  }

  // Run commuted loop according to permutation vector p.
  for (unsigned char k : p) {
    loop_body(k, key_array, shift, bucket_size_permuted);
  }

  // Assert that the outputs are the same.
  for( int i=0; i<NUM_BUCKETS; i++ ) {
    assert(bucket_size_permuted[i] == bucket_size_ref[i]);
  }

}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {

  FuzzedDataProvider input(data, size);

  // Permutation array
  std::vector<unsigned char> p(input.ConsumeBytes<unsigned char>(N));
  // Input argument
  //std::vector<unsigned char> a(input.ConsumeRemainingBytes<unsigned char>());

  if (p.size() < N) return 0;

  for (unsigned char i : p) {
    if (i >= N) return 0;
  }

  for (unsigned int i = 0; i < N; i++) {
    for (unsigned int j = i + 1; j < N; j++) {
      if (p[i] == p[j]) {
        return 0;
      }
    }
  }

  printf("permutation (N=%zu): ", p.size());
  for (unsigned int i : p) {
    printf("%d ", i);
  }
  printf("\n");

  test_permutation(p);

  return 0;
}
