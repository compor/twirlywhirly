
void exit(int);

void foo() {
  exit(1);
}

void test() {
  int i = 100;
  int a = 0;

  while (--i) {
    a++;

    if(a == 50)
      foo();

    a++;
  }

  return;
}
