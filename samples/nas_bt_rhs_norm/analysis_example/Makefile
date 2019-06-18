HOME_DIR = /home/discovery

KLEE_DIR = $(HOME_DIR)/klee/install2
KLEE_INCLUDE_DIR = $(KLEE_DIR)/include
KLEE = $(KLEE_DIR)/bin/klee
KLEE_FLAGS = -solver-backend=z3

LLVM_DIR = $(HOME_DIR)/llvm/7.0/toolchain1
LLVM_LIB_DIR = $(LLVM_DIR)/lib
CC = $(LLVM_DIR)/bin/clang

%.bc : %.c
	$(CC) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone $< -I $(KLEE_INCLUDE_DIR)

%.bin : %.c
	$(CC) -o $@ -O0 -Xclang -disable-O0-optnone $< -I $(KLEE_INCLUDE_DIR)

%.klee : %.bc
	LD_LIBRARY_PATH=$(LLVM_LIB_DIR) $(KLEE) $(KLEE_FLAGS) $<

clean:
	rm -f -r klee-* *.bc *~
