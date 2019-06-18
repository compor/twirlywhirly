#include <math.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "klee/klee.h"

// Greatly reduced the problem size for feasibility.
#define PROBLEM_SIZE 4

#define IMAX PROBLEM_SIZE
#define JMAX PROBLEM_SIZE
#define KMAX PROBLEM_SIZE
#define IMAXP IMAX / 2 * 2
#define JMAXP JMAX / 2 * 2

double rhs[KMAX][JMAXP + 1][IMAXP + 1][5];
int grid_points[3];

void rhs_norm(double rms[5]) {
  int i, j, k, d, m;
  double add;

  for (m = 0; m < 5; m++) {
    rms[m] = 0.0;
  }

  // Save the state (add, rms, k, j, i, m).
  double add_shadow = add;
  double rms_shadow[5];
  memcpy(rms_shadow, rms, sizeof(rms_shadow));
  int k_shadow = k;
  int j_shadow = j;
  int i_shadow = i;
  int m_shadow = m;

  // Reference loop.
  for (k = 1; k <= grid_points[2] - 2; k++) {
    for (j = 1; j <= grid_points[1] - 2; j++) {
      for (i = 1; i <= grid_points[0] - 2; i++) {
        for (m = 0; m < 5; m++) {
          add = rhs[k][j][i][m];
          rms[m] = rms[m] + add * add;
        }
      }
    }
  }

  // Save the output (rms).
  double rms_reference[5];
  memcpy(rms_reference, rms, sizeof(rms_reference));

  // Restore the state (add, rms, k, j, i, m).
  add = add_shadow;
  memcpy(rms, rms_shadow, sizeof(rms_shadow));
  k = k_shadow;
  j = j_shadow;
  i = i_shadow;
  m = m_shadow;

  // Introduce permutation array. Note that it has the size of the
  // iteration space (between 1 and grid_points[2] - 2).
  const size_t Np = grid_points[2] - 2;
  size_t p[Np];

  // Declare the permutation array as symbolic.
  klee_make_symbolic(&p, sizeof(p), "p");
  for (unsigned int i = 0; i < Np; i++) {
    // Define the domain of the permutation array.
    klee_assume(p[i] >= 1);
    klee_assume(p[i] <= grid_points[2] - 2);
    // Enforce that the array's values indeed form a permutation (they
    // are pairwise different).
    for (unsigned int j = i + 1; j < Np; j++) {
      klee_assume(p[i] != p[j]);
    }
  }

  // Symbolically-permuted loop.
  for (size_t iteration = 0; iteration < Np; ++iteration) {
    k = p[iteration];
    for (j = 1; j <= grid_points[1] - 2; j++) {
      for (i = 1; i <= grid_points[0] - 2; i++) {
        for (m = 0; m < 5; m++) {
          add = rhs[k][j][i][m];
          rms[m] = rms[m] + add * add;
        }
      }
    }
  }

  // Save the output (rms).
  double rms_permuted[5];
  memcpy(rms_permuted, rms, sizeof(rms_permuted));

  // Assert that the outputs are the same.
  assert(memcmp(rms_permuted, rms_reference,
		sizeof(rms_reference)) == 0);

  // Exit, as there is no point in continuing the execution.
  exit(EXIT_SUCCESS);
  
  for (m = 0; m < 5; m++) {
    for (d = 0; d < 3; d++) {
      rms[m] = rms[m] / (double)(grid_points[d] - 2);
    }
    rms[m] = sqrt(rms[m]);
  }
}

int main(int argc, char *argv[]) {
  FILE *fp;
  double xcr[5];

  printf("\n\n NAS Parallel Benchmarks (NPB3.3-SER-C) - BT Benchmark\n\n");

  if ((fp = fopen("inputbt.data", "r")) != NULL) {
    int result;
    printf(" Reading from input file inputbt.data\n");
    while (fgetc(fp) != '\n')
      ;
    result = fscanf(fp, "%d%d%d\n", &grid_points[0], &grid_points[1],
                    &grid_points[2]);
    fclose(fp);
  } else {
    printf(" No input file inputbt.data. Using compiled defaults\n");
    grid_points[0] = PROBLEM_SIZE;
    grid_points[1] = PROBLEM_SIZE;
    grid_points[2] = PROBLEM_SIZE;
  }

  printf(" Size: %4dx%4dx%4d\n", grid_points[0], grid_points[1],
         grid_points[2]);
  printf("\n");

  rhs_norm(xcr);

  return 0;
}

