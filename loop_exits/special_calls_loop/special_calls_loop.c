
void foo(void);
void bar(void);

void test(void) {
  int i = 100;

  while (--i) {
    foo();
    bar();
  }
}
