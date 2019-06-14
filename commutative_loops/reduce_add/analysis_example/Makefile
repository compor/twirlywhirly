HOME_DIR = /home/discovery

KLEE_DIR = $(HOME_DIR)/klee/install2
KLEE_INCLUDE_DIR = $(KLEE_DIR)/include
KLEE = $(KLEE_DIR)/bin/klee

LLVM_DIR = $(HOME_DIR)/llvm/7.0/toolchain1
LLVM_LIB_DIR = $(LLVM_DIR)/lib
CC = $(LLVM_DIR)/bin/clang

LLVM_CONFIG = 

%.bc : %.c
	$(CC) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone $< -I $(KLEE_INCLUDE_DIR)

%.klee : %.bc
	LD_LIBRARY_PATH=$(LLVM_LIB_DIR) $(KLEE) $<

clean:
	rm -f -r klee-* *.bc *~
