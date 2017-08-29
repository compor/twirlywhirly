
int main() {
  unsigned int array[] = {3, 5, 15, 99, 11, 33, 5, 67};
  const size_t N = sizeof(array) / sizeof(unsigned int);
  unsigned int k = 0;

  for (size_t i = 1; i < N; ++i)
    A[i] += A[i - 1];

  k = A[3];

  return 0;
}
