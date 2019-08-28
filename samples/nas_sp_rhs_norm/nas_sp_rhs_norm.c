// Loop extracted from SP (SNU NPB). Neither ICC, LLVM+Polly, nor the
// idiom-based approach detect this as parallel.
//
// Note that the loop has floating-point arithmetic, and upstream Klee cannot
// handle that.
//
// Note also that floating-point addition is not associative, and thus the loop
// should NOT be parallelizable (unless -ffast-math is used). Would be
// interesting to see if klee-float
// (https://srg.doc.ic.ac.uk/projects/klee-float/) can detect that.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <klee/klee.h>

// Problem size for class 'S'
#define PROBLEM_SIZE   4

#define IMAX    PROBLEM_SIZE
#define JMAX    PROBLEM_SIZE
#define KMAX    PROBLEM_SIZE
#define IMAXP   (IMAX/2*2)
#define JMAXP   (JMAX/2*2)

#define RHS_SIZE_0 KMAX
#define RHS_SIZE_1 (JMAXP+1)
#define RHS_SIZE_2 (IMAXP+1)
#define RHS_SIZE_3 5
#define RMS_SIZE_0 5
// FIXME: this is unknown at compile-time (default when input is not provided).
#define NZ2 (PROBLEM_SIZE - 2)

// loop_body(k): k, ny2, nx2, rhs -> rms.
void loop_body(int k, int ny2, int nx2,
               double rhs[RHS_SIZE_0][RHS_SIZE_1][RHS_SIZE_2][RHS_SIZE_3],
               double rms[RMS_SIZE_0]) {
  int i, j, d, m;
  double add;
  for (j = 1; j <= ny2; j++) {
    for (i = 1; i <= nx2; i++) {
      for (m = 0; m < 5; m++) {
        add = rhs[k][j][i][m];
        rms[m] = rms[m] + add*add;
      }
    }
  }
}

int main() {

  // Induction variable.
  int k;
  // Loop limit variable.
  int nz2 = NZ2;

  // Symbolic input and output.
  int ny2;
  klee_make_symbolic(&ny2, sizeof(ny2), "ny2");
  int nx2;
  klee_make_symbolic(&nx2, sizeof(nx2), "nx2");
  double rhs[RHS_SIZE_0][RHS_SIZE_1][RHS_SIZE_2][RHS_SIZE_3];
  klee_make_symbolic(&rhs, sizeof(rhs), "rhs");
  double rms[RMS_SIZE_0];
  klee_make_symbolic(&rms, sizeof(rms), "rms");

  // Constraints derived from static analysis of the code.

  // For each array access within the loop body, assume no UB.
  // FIXME: in the worst case, this requires a sophisticated analysis, is there
  // a more straightforward way to enforce this?
  klee_assume(ny2 <= RHS_SIZE_1);
  klee_assume(nx2 <= RHS_SIZE_2);

  // Save the state.
  double rms_shadow[RMS_SIZE_0];
  memcpy(rms_shadow, rms, sizeof(rms));

  // Reference loop: k, ny2, nx2, rhs -> rms.
  for (k = 1; k <= nz2; k++) {
    loop_body(k, ny2, nx2, rhs, rms);
  }

  // Save the output.
  double rms_ref[RMS_SIZE_0];
  memcpy(rms_ref, rms, sizeof(rms));

  // Restore the state.
  memcpy(rms, rms_shadow, sizeof(rms_shadow));

  // Introduce permutation array (iteration space between 1 and nz2).
  const size_t Np = nz2;
  size_t p[Np];
  // Declare the permutation array as symbolic.
  klee_make_symbolic(&p, sizeof(p), "p");
  for (unsigned int i = 0; i < Np; i++) {
    // Define the domain of the permutation array.
    klee_assume(p[i] >= 1);
    klee_assume(p[i] <= nz2);
    // Enforce that the array's values indeed form a permutation (they are
    // pairwise different).
    for (unsigned int j = i + 1; j < Np; j++) {
      klee_assume(p[i] != p[j]);
    }
  }

  // Symbolically-permuted loop.
  for (size_t k = 0; k < Np; ++k) {
    loop_body(p[k], ny2, nx2, rhs, rms);
  }

  // Save the output.
  double rms_permuted[RMS_SIZE_0];
  memcpy(rms_permuted, rms, sizeof(rms));

  // Assert that the outputs are the same.
  assert(memcmp(rms_permuted, rms_ref, sizeof(rms_ref)) == 0);

  exit(EXIT_SUCCESS);
}
