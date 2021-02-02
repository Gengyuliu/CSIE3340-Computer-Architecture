run:
	riscv64-unknown-elf-gcc -static -o fibonacci fibonacci.c fibonacci.s

dump:
	riscv64-unknown-elf-objdump -d fibonacci > fibonacci.dump
test:
	spike pk ./fibonacci
clean:
	rm -f fibonacci

