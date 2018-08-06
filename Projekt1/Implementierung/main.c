/*
 * C wrapper for the median filter
 * Creates a random signal array with given range and length, then calls filter5
 * Prints both the original and filtered signal
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>


// noisy signal
int signal[103];

// filtered signal
int *filt_signal;

int sig_length = sizeof(signal) / sizeof(int);	// length of signal
int sig_range = 100;    // signal amplitude
int block_len = 5; // length of one signal block

extern void filter5(int N, int *start, int length, int *dest) asm("filter5");

/* 
 * Print signal array up to a certain length (debugging)
 */
void print_signal(int sig[], int len) {
	printf("------------------------------------------------\n");
	
	for(int i = 0; i < len; i++) {
		printf("%d ",sig[i]);
	}
	
	printf("\n------------------------------------------------\n\n");
}

int main() {
	srand(time(NULL));
	
	printf("Creating signal ...\n\n");
	// create random signal
	for(int i = 0; i < sig_length; i++) {
		signal[i] = rand() % sig_range - sig_range/2; // shift amplitude to get negative values too
	}
	
	// allocate space for filtered signal
	filt_signal = (int *) malloc(sig_length * sizeof(int));
	
	printf("NOISY SIGNAL\n");
	print_signal(signal, sig_length);
	
	printf("Applying median filter ...\n\n");
	// filter signal
	filter5(block_len, signal, sig_length, filt_signal);
	
	printf("FILTERED SIGNAL\n");
	print_signal(filt_signal, sig_length / block_len);
	
	printf("Completed. Exiting ...\n\n");
	free(filt_signal);
}
