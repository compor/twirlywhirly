#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define PROBLEM_SIZE 102

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

