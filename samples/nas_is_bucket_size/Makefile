# LLVM + Klee using Klee's Docker container
CC_KLEE = clang
KLEE = klee
KLEE_INCLUDE_DIR = /home/klee/klee_src/include
CC = clang

all: nas_is_bucket_size.klee nas_is_bucket_size_swap.klee

%.klee: %.bc
	$(KLEE) $<

%.bc: %.c common.h
	$(CC_KLEE) -I $(KLEE_INCLUDE_DIR) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone $<

%.bin: %.cc FuzzedDataProvider.h
	$(CC) -g -O2 -fsanitize=fuzzer $< -o $@

%.run: %.bin
	./$< -max-len=4

clean:
	rm -rf *.bc *.out *.polly *.comm *.yaml *.ll klee-out* klee-last *~
