#include <stdio.h>
#include <stdint.h>

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

// define assemby macros for operations here
// you can use the "Extended Asm" documentation for GNU GCC 
// https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html

int main(void) 
{
	uint32_t cycles_high1 = 0, cycles_low1 = 0, cpuid_time = 0;
	uint32_t cycles_high2 = 0, cycles_low2 = 0;
	uint64_t temp_cycles1 = 0, temp_cycles2 = 0;
	int64_t total_cycles = 0;

	// declare necessary variables here

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

	// measure stop timestamp
	pushad();
	cpuid();
	rdtsc(cycles_low2, cycles_high2);
	popad();

	// compute 64bit value of the passed time
	temp_cycles1 = ((uint64_t)cycles_high1 << 32) | cycles_low1;
	temp_cycles2 = ((uint64_t)cycles_high2 << 32) | cycles_low2;
	total_cycles = temp_cycles2 - temp_cycles1 - cpuid_time;

	printf("CPUID overhead = %u\n", cpuid_time);
	printf("Cycles (before) = %llu\n", temp_cycles1);
	printf("Cycles (after) = %llu\n", temp_cycles2);
	printf("Total cycles = %lld\n", total_cycles);
	return 0;
}


