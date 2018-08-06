ASM=nasm
CC=gcc
MODE=64
objects = filter5.o main

all: main

filter5.o: filter5.asm
	$(ASM) -f elf$(MODE) filter5.asm
	
main: filter5.o main.c
	$(CC) -m$(MODE) -o main main.c filter5.o

clean:
	rm -f $(objects)
