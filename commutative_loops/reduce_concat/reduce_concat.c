
#include <stdio.h>
#include <string.h>
#include <stddef.h>

int main() {
  char *array[] = {"ab", "cd", "ef", "gh"};
  const size_t N = sizeof(array) / sizeof(char *);
  const size_t n = strlen(array[0]);
  char acc[N * 2 + 1] = {0};
  char *result = acc;
  size_t i = 0;

  for (i = 0; i < N; ++i) {
    fprintf(stderr, "%zu\n", i);
    strncat(result, array[i], n);
  }

  /* this does not work because the use of output stmts is not checked */
  fprintf(stderr, "%s\n", result);

  /* this causes a crash */
  /*fprintf(stderr, "%zu\n", i);*/

  fprintf(stderr, "%c\n", acc[2]);

  return 0;
}
