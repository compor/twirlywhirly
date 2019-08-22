# LLVM + Polly at Roberto's local environment
CC_POLLY = /home/rcas/llvm-polly/build/bin/clang

# LLVM + Klee using Klee's Docker container
CC_KLEE = clang
KLEE = klee
KLEE_INCLUDE_DIR = /home/klee/klee_src/include

histogram.polly: histogram.c
	$(CC_POLLY) -O3 -mllvm -polly -mllvm -polly-parallel -lgomp -Rpass-analysis=polly -Rpass-missed=polly $< 2> $@

histogram.comm: histogram-analysis.bc
	$(KLEE) $< 2> $@

histogram-analysis.bc: histogram-analysis.c
	$(CC_KLEE) -I $(KLEE_INCLUDE_DIR) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone $<

clean:
	rm -rf *.bc *.out *.polly *.comm *.yaml *.ll klee-out* klee-last
