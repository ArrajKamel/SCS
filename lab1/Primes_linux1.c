// make sure to use -lpthread flag when compiling this program
// gcc <file.c> -o <exec> -lpthread
//correct version

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>
#include <errno.h>

struct thread_data_struct
{
	unsigned long *numbers;
	unsigned long start;
	unsigned long len;
};

void *thread_function(void *arg);

static int is_prime(unsigned long n)
{
	for (unsigned long i=2; i<n; ++i)
		if (n%i == 0)
			return 0;
	return 1;
}

int main(int argc, char **argv)
{
	unsigned long l_end, mult, len, n_threads;
	unsigned long *numbers = NULL;

	pthread_t *threads = NULL;
	struct thread_data_struct *thread_args = NULL;

	if (argc != 3) {
		errno = EINVAL;
		perror("./<exec> [end] [no threads]\n");
		return errno;
	}

	// remember that argv[0] is the name of the program
	l_end = atoi(argv[1]);
	n_threads = atoi(argv[2]);

	len = l_end -1;
	numbers = (unsigned long *)malloc(len * sizeof(unsigned long));
	threads = (pthread_t *)malloc(n_threads * sizeof(pthread_t));
	thread_args = (struct thread_data_struct *)malloc(n_threads * sizeof(struct thread_data_struct));
	if (NULL == numbers || NULL == threads || NULL == thread_args) {
		errno = ENOMEM;
		perror("out of memory initializing necessary arrays\n");
		return errno;
	}

	for (unsigned long i = 0; i<len; ++i)
		numbers[i] = i+2;

	clock_t start = clock() ;

	for (int i=0; i<n_threads; ++i) {
		// set thread arguments
		thread_args[i].numbers = numbers;
		thread_args[i].start = i * (len/n_threads);
		thread_args[i].len = len/n_threads;
		if (i == n_threads - 1)
			// length of last thread is computed as the remaining elements
			// the length of the array minus the start index of this sequence
			thread_args[i].len = len - i*(len/n_threads);
		// create the thread
		pthread_create(threads + i, NULL, thread_function, thread_args + i);
	}

	for (int i=0; i<n_threads; ++i)
		pthread_join(threads[i], NULL);

	clock_t end = clock();

	clock_t total_clocks = end - start ; 

	for (int i=0; i<len; ++i)
		if (numbers[i] > 0)
			printf("%lu\n", numbers[i]);


	printf("the total number of clock cycles are : %d\n", total_clocks);


	free(threads); threads = NULL;
	free(thread_args); thread_args = NULL;
	free(numbers); numbers = NULL;

	return 0;
}

void *thread_function(void *arg)
{
	struct thread_data_struct *th_arg = (struct thread_data_struct *)arg;
	unsigned long *numbers = th_arg->numbers;

	for (unsigned long i=th_arg->start; i<th_arg->start + th_arg->len; ++i) {
		if (is_prime(numbers[i]))
			for (unsigned long j=2*numbers[i]-2; j<th_arg->len; j+=numbers[i])
				numbers[j] = 0;
		else numbers[i] = 0;
	}

	return NULL;
}

