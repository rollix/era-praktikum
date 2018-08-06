/*
 * Generate functions with random noise
 * sine, cosine, exponential, logarithm, square root
 */


#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

FILE *fp;

void fopen_w(char *f_name) {
	if((fp = fopen(f_name, "w")) == NULL) {
		printf("Plot data file does not exist.");
	}
}

void sin_func(char *f_name) {
	fp = fopen(f_name, "w");
	
	for(int i = 0; i < 700; i++) {
		int noise = (rand() % 200 - 100);
		int fx = (int) (sin(i/100.0) * 1000) + noise;
        fprintf(fp, "%d %d\n", i, fx);
    }
    
	fclose(fp);
}

void cos_func(char *f_name) {
	fp = fopen(f_name, "w");
	
	for(int i = 0; i < 700; i++) {
		int noise = (rand() % 200 - 100);
		int fx = (int) (cos(i/100.0) * 1000) + noise;
        fprintf(fp, "%d %d\n", i, fx);
    }
	
	fclose(fp);
}

void exp_func(char *f_name) {
	fp = fopen(f_name, "w");

	for(int i = 0; i < 800; i++) {
		int noise = (rand() % 200 - 100);
		int fx = (int) (exp(i/100.0)) + noise;
		fprintf(fp, "%d %d\n", i, fx);
	}

	fclose(fp);
}

void log_func(char *f_name) {
	fp = fopen(f_name, "w");
	
	for(int i = 1; i < 1000; i++) {
		int noise = (rand() % 50 - 25);
		int fx = (int) (log(i) * 100) + noise;
		fprintf(fp, "%d %d\n", i, fx);
	}
	
	fclose(fp);
}

void sqrt_func(char *f_name) {
	fp = fopen(f_name, "w");
	
	for(int i = 0; i < 1000; i++) {
		int noise = (rand() % 200 - 100);
		int fx = (int) (sqrt(i) * 100) + noise;
		fprintf(fp, "%d %d\n", i, fx);
	}
	
	fclose(fp);
}

int main() {
	srand(time(NULL));
	
	sin_func("sin.dat");
	cos_func("cos.dat");
	exp_func("exp.dat");
	log_func("log.dat");
	sqrt_func("sqrt.dat");
	
}
