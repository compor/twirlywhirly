
void exit(int);

void foo() {
  int i = 100;
  int a = 0;

  while (--i) {
    a++;

    if(a == 50)
      exit(1);

    a++;
  }

  return;
}
