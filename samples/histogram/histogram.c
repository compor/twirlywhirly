// 2nd loop from
// https://sites.google.com/site/parallelizationforllvm/why-not-polly.
//
// Polly does not recognize it as parallelizable:
// $ make histogram.polly
// $ cat histogram.polly
// (..)
// The array subscript of "count" is not affine
// (..)
// Using commutativity analysis, the loop is recognized as parallelizable:
// $ make histogram.comm
// $ cat histogram.comm
// (..)
// KLEE: done: total instructions = 2066
// (..)
// Note, however, that in the second case, N is restricted to 5.

#include <stdio.h>

const size_t M = 4;

unsigned count[M];

const size_t N = 50;

unsigned src[N] = {0,1,2,3,0,0,1,2,3,0,
                   0,1,2,3,0,0,1,2,3,0,
                   0,1,2,3,0,0,1,2,3,0,
                   0,1,2,3,0,0,1,2,3,0,
                   0,1,2,3,0,0,1,2,3,0};

int main() {

  for (unsigned i = 0; i < N; i++)
    count[src[i]]++;

  for (unsigned i = 0; i < M; i++)
    printf("%u\n", count[i]);

  return 0;
}
