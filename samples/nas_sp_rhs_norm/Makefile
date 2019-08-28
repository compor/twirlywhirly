# LLVM + Klee using Klee's Docker container
CC_KLEE = clang
KLEE = klee
KLEE_INCLUDE_DIR = /home/klee/klee_src/include

nas_sp_rhs_norm.klee: nas_sp_rhs_norm.bc
	$(KLEE) $<

nas_sp_rhs_norm.bc: nas_sp_rhs_norm.c
	$(CC_KLEE) -I $(KLEE_INCLUDE_DIR) -emit-llvm -c -g -O0 -Xclang -disable-O0-optnone $<

clean:
	rm -rf *.bc *.out *.polly *.comm *.yaml *.ll klee-out* klee-last *~
