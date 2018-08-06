/*
 * Test suite for the median filter
 * Test modes: Random signals, custom input, plot data
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

extern void filter5(int N, int *start, int length, int *dest) asm("filter5");


int sig_length, block_len;
int *signal_noise;
int *signal_filt;
int *signal_filt_check;

FILE *debug;

// Comparator function to sort ascendingly
int cmp_asc(const void *a, const void *b) {
	return (*(int *)a - *(int *)b);
}

/*
 * C implementation of the median filter
 */
int medianfilter(int N, int *start, int length, int *dest) {
	
	if(N % 2 == 0 || N <= 0) {
		//printf("-- ERROR : Block length must be odd and positive\n");
		return 0;
	}
	
	if(length < 0) {
		//printf("-- ERROR : Signal length can't be negative\n");
		return 0;
	}
	
	int n_blocks = length / N;
	int medpos = N/2;
	memcpy(dest, start, length * sizeof(int));
	
	for(int i = 0; i < n_blocks; i++) {
		qsort(dest + i*N, N, sizeof(int), cmp_asc);
		dest[i] = dest[i*N + medpos];
	}
	
	return 1;
}

/* Formatted signal printing
 * Separate values with spaces
 */
void fprint_signal(FILE *fd, int sig[], int len) {
	fprintf(fd, "\n");
	
	for(int i = 0; i < len; i++) {
		fprintf(fd, "%d ",sig[i]);
	}
	
	fprintf(fd, "\n\n");
}

/* Random test run
 * Filter signal and check output
 * Write detailed result to debug file
 */
int testrun_debug(int run_id, int *n_fail) {
	fprintf(debug, "------------------------------\nTEST RUN %d\n\n", run_id);

	filter5(block_len, signal_noise, sig_length, signal_filt);
	if(medianfilter(block_len, signal_noise, sig_length, signal_filt_check) == 0) {
		free(signal_noise);
		free(signal_filt);
		free(signal_filt_check);
		return 0;
	}
		
	fprintf(debug, "NOISY:");
	fprint_signal(debug, signal_noise, sig_length);
		
	fprintf(debug, "FILTERED:");
	fprint_signal(debug, signal_filt, sig_length / block_len);
		
	if(memcmp(signal_filt, signal_filt_check, sig_length / block_len)) {
		fprintf(debug, "FAIL: \nExpected:\n");
		fprint_signal(debug, signal_filt_check, sig_length / block_len);
		*n_fail++;
	}
	
	return 1;
}

/* Write filtered signal to plot data file
 * Write gnuplot config file
 * Plot data
 */
void create_plots(char *f_name) {
	if(sig_length / block_len == 0) {
		printf("Nothing to plot - filtered signal has length zero.\n");
		return;
	}

	FILE *plot = fopen("plots/plot_filt.dat", "w");
	
	for(int i = 0; i < sig_length/block_len; i++) {
		fprintf(plot, "%d %d\n", i, signal_filt[i]);
	}
	
	fclose(plot);
	
	plot = fopen("plots/plot.conf", "w");
	
	fprintf(plot, "set term qt 0\nplot '%s' with lines\nset term qt 1\nplot 'plots/plot_filt.dat' with lines\npause 300\n", f_name);
	
	fclose(plot);
	
	system("gnuplot < plots/plot.conf");
}

/* Test mode: Randomly generated signals
 * Create random signals, filter and check result
 */
void test_random(char *input) {
	
	int n_tests, sig_range;
	int n_fail = 0;
	srand(time(NULL));
	
	if(sscanf(input, "%d %d %d %d", &n_tests, &sig_range, &sig_length, &block_len) != 4) {
		printf("Invalid\n");
		return;
	}
	
	debug = fopen("debug.txt","w");
	
	signal_noise = (int *) malloc(sig_length * sizeof(int));
	signal_filt = (int *) malloc(sig_length * sizeof(int));
	signal_filt_check = (int *) malloc(sig_length * sizeof(int));
	
	for(int i = 0; i < n_tests; i++) {
		for(int j = 0; j < sig_length; j++) {
			signal_noise[j] = rand() % sig_range - sig_range/2; // shift amplitude to get negative values too
		}
		
		if(!testrun_debug(i + 1, &n_fail))
			return;
	}
	
	printf("%d test runs completed. \nSUCCESS: %d - FAIL: %d. \nSee debug.txt for detailed output.\n", n_tests, n_tests - n_fail, n_fail);
	
	free(signal_noise);
	free(signal_filt);
	free(signal_filt_check);
	
	fclose(debug);
}

/* Test mode: Custom input
 * Create signals from file, filter and check result 
 */
void test_custom(char *input) {

	char *line;
	int chars, n_fail = 0, n_tests = 0;
	FILE *fp;
	size_t len = 0;
	
	if(sscanf(input, "%d", &block_len) != 1) {
		printf("Invalid\n");
		return;
	}
	
	if((fp = fopen("custom_signal.dat", "r")) == NULL) {
		printf("Error: Custom signal file does not exist.\n");
		return;
	}
	debug = fopen("debug.txt", "w");
	
	int val, n_bytes;
	while((chars = getline(&line, &len, fp)) != EOF) {
		if(sscanf(line, "%d", &val) < 1)
			continue;
	
		sig_length = 0;
		signal_noise = (int *) malloc(chars * sizeof(int));
		
		while(sscanf(line, "%d%n", &val, &n_bytes) > 0) {
			signal_noise[sig_length] = val;
			line += n_bytes;
			sig_length++;
		}
		
		signal_filt = (int *) malloc(sig_length * sizeof(int));
		signal_filt_check = (int *) malloc(sig_length * sizeof(int));
		
		n_tests++;
		
		if(!testrun_debug(n_tests, &n_fail))
			return;
		
		free(signal_noise);
		free(signal_filt);
		free(signal_filt_check);
	}
	
	printf("%d test runs completed. \nSUCCESS: %d - FAIL: %d. \nSee debug.txt for detailed output.\n", n_tests, n_tests - n_fail, n_fail);
	
	fclose(debug);
	fclose(fp);
}

/* Test mode: Plot functions
 * Read from file, filter and plot data using gnuplot 
 */
void test_plot(char *input) {
	
	int func, noise;
	char *line, *f_name;
	FILE *plot;
	size_t f_len = 100;
	sig_length = 0;
	block_len = 5;
	
	signal_noise = (int *) malloc(f_len * sizeof(int));

	if(sscanf(input, "%d", &func) != 1) {
		printf("Invalid\n");
		return;
	}
	
	switch(func) {
		case 1:
			f_name = "plots/sin.dat";
			break;
		case 2:
			f_name = "plots/cos.dat";
			break;
		case 3:
			f_name = "plots/exp.dat";
			break;
		case 4:
			f_name = "plots/log.dat";
			break;
		case 5:
			f_name = "plots/sqrt.dat";
			break;
		case 6:
			f_name = "plots/custom.dat";
			break;
	}
	
	if((plot = fopen(f_name, "r")) == NULL) {
		printf("Error: Plot data does not exist.\n");
		return;
	}
	
	int x;
	size_t len = 0;
	
	while(getline(&line, &len, plot) != -1) {
		if(sig_length > f_len) {
			f_len *= 2;
			signal_noise = realloc(signal_noise, f_len * sizeof(int));
		}

		if(sscanf(line, "%d %d", &x, &signal_noise[sig_length]) != 2) {
			printf("Incorrect file format\n");
			sig_length = 0;
			break;
		}
		
		sig_length++;
	}
	
	fclose(plot);
	
	if(sig_length == 0)
		return;
	
	signal_filt = (int *) malloc(sig_length * sizeof(int));
	filter5(block_len, signal_noise, sig_length, signal_filt);
	
	create_plots(f_name);
	
	free(signal_noise);
	free(signal_filt);
}

/* Main menu loop
 * Get input and select test mode
 */
int menu_loop() {
	
	char *input = NULL;
	ssize_t size = 0;
	int ret;
    
    while(1) {
   		printf("> ");
   		getline(&input, &size, stdin);
   		
   		ret = 0;
   		if(sscanf(input, "%d", &ret) == -1)
   			continue;
   		
		switch(ret) {
			case 1:
				printf("Enter <tests> <range> <signal length> <block length>: ");
				getline(&input, &size, stdin);
				test_random(input);
				break;
			case 2:
				printf("Enter block length: ");
				getline(&input, &size, stdin);
				test_custom(input);
				break;
			case 3:
				printf("Select function:\n  (1) sin(x)\n  (2) cos(x)\n  (3) exp(x)\n  (4) log(x)\n  (5) sqrt(x)\n  (6) Custom\n> ");
				getline(&input, &size, stdin);
				test_plot(input);
				break;
			case 4:
				return 0;
			default:
				printf("Invalid\n");
				break;
		}	
    }
    
    return 0;
}

int main(int argc, char **argv) {
	
	printf("Main Menu:\n\
  (1) Randomly generated signals\n\
  (2) Custom input\n\
  (3) Plot functions \n\
  (4) Exit \n");
	
	menu_loop();
	
	return 0;
}
