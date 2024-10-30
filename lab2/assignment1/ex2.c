#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#define	rdtsc(low, high)	__asm__ volatile ("rdtsc;" : "=a" (low), "=d" (high))
#define	__rdtsc__()		__asm__ volatile ("rdtsc;" ::: "eax", "edx")
#define	cpuid()			__asm__ volatile ("cpuid;" :: "a"(0) : "bx", "cx", "dx")

#define	pushad()		__asm__ volatile ("pushal;")
#define	popad()			__asm__ volatile ("popal;")
#define	mov(dst, src)		__asm__ volatile ("mov %1, %0;" : "=r"(dst) : "r"(src))
#define	add(dst, src)		__asm__ volatile ("add %1, %0;" : "=r"(dst) : "r"(src), "0"(dst))
#define	sub(dst, src)		__asm__ volatile ("sub %1, %0;" : "=r"(dst) : "r"(src), "0"(dst))
#define	sub_reg(reg, src)	__asm__ volatile ("sub %0, %%"reg :: "m"(src))
#define	mov_reg(dst, reg)	__asm__ volatile ("mov %%"reg", %0" : "=m"(dst))

#define FREQUENCY 28000000
#define RUNS 10

// define assemby macros for operations here
// you can use the "Extended Asm" documentation for GNU GCC 
// https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html

void sort(uint32_t *array, int len) {
    for(int i = 0 ; i < len ; i++)
    {
        for(int j = i+1 ; j < len - 1 ; j++) 
        {
            if(array[j] < array[i])
            {
                //swapping 
                int temp = array[i];
                array[i] = array[j];
                array[j] = temp; 
            }
        }
    }
}

void heapify(int arr[], int n, int i) {
    int largest = i; // Initialize largest as root
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    // If left child is larger   than root
    if (left < n && arr[left] > arr[largest])
        largest = left;

    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest])
        largest = right;

    // If root is not largest
    if (largest != i) {
        // Swap the root with the largest
        int temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;

        // Recursively heapify the affected sub-tree
        heapify(arr, n, largest); 
    }
}

//heapsort
void optimized_sort(uint32_t *array, int len)
{
	  // Build max heap
    for (int i = len / 2 - 1; i >= 0; i--)
        heapify(array, len, i);

    // One by one extract elements from the heap
    for (int i = len - 1; i >= 0; i--) {
        // Move the current root to the end
        int temp = array[0];
        array[0] = array[i];
        array[i] = temp;

        // Call max heapify on the reduced heap
        heapify(array, i, 0);
    }
}

void print_array(uint32_t *array, int len)
{
	for (int i=0; i<len; ++i)
		printf("%u ", array[i]);
	printf("\n");
}

// !do not forget to use this function to generate the arrays
void generate_random_array(uint32_t *array, int len)
{
	srand(time(NULL));
	for (int i=0; i<len; ++i)
		array[i] = (uint32_t)(rand() % 1000);
}

int main(void) 
{
	uint32_t cycles_high1 = 0, cycles_low1 = 0, cpuid_time = 0;
	uint32_t cycles_high2 = 0, cycles_low2 = 0;
	uint64_t temp_cycles1 = 0, temp_cycles2 = 0;
	int64_t total_cycles = 0;
	double avg_cycles = 0.0f, avg_seconds = 0.0f, total_seconds = 0.0f; 

	// declare necessary variables here
	uint32_t array1[10000]; // static array definition
	uint32_t *array2 = (uint32_t *)malloc(10000 * sizeof(uint32_t)); // dynamic array definition

	clock_t start , end , total = 0 ;
	for (int run = 0; run < RUNS; ++run) {
		// compute the CPUID overhead
		pushad();
		cpuid();
		__rdtsc__();
		popad();
		pushad();
		cpuid();
		__rdtsc__();
		popad();
		pushad();
		cpuid();
		__rdtsc__();
		popad();
		pushad();
		cpuid();
		__rdtsc__();
		popad();
	
		pushad();
		cpuid();
		rdtsc(cycles_low1, cycles_high1);
		popad();
		pushad();
		cpuid();
		__rdtsc__();
		sub_reg("eax", cycles_low1);
		mov_reg(cpuid_time, "eax");
		popad();
	
		cycles_high1 = cycles_low1 = 0;
	

		// measure start timestamp
		pushad();
		cpuid();
		rdtsc(cycles_low1, cycles_high1);
		popad();

		
		// section of code to be measured
		start= clock(); 
		// after measuting the execution time for both array1 and array2 using the sort function
		// do the same for the optimized sort 
		optimized_sort(array1, 10000);
		// sort(array1, 10000);

		// optimized_sort(array2, 10000);
		// sort(array2, 10000);
		end = clock(); 
		// measure stop timestamp
		pushad();
		cpuid();
		rdtsc(cycles_low2, cycles_high2);
		popad();
	
		// compute 64bit value of the passed time
		temp_cycles1 = ((uint64_t)cycles_high1 << 32) | cycles_low1;
		temp_cycles2 = ((uint64_t)cycles_high2 << 32) | cycles_low2;
		total_cycles = temp_cycles2 - temp_cycles1 - cpuid_time;
		avg_cycles += total_cycles;

		total = total + (end - start);
	}

	avg_cycles /= (double)RUNS;
	avg_seconds = avg_cycles / (double)FREQUENCY;
	total_seconds = (double) total_cycles / (double)FREQUENCY;

	total = total/RUNS; 

	printf("Average cycles = %lf\n", avg_cycles);
	printf("Average seconds = %lf\n", avg_seconds);
	printf("Cycles (last run) = %lld\n", total_cycles);
	printf("Seconds (last run) = %lf\n", total_seconds);

	printf("the total clock cycles are : %d\n", total);
	return 0;
}


