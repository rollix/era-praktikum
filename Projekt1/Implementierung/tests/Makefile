ASM=nasm
CC=gcc
MODE=64
objects = test_filter ../filter5.o

all: test_filter
	
test_filter: ../filter5.o test_filter.c
	$(CC) -m$(MODE) -g -o test_filter test_filter.c ../filter5.o

clean:
	rm -f $(objects)
