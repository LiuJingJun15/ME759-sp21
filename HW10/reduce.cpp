#include <cstdlib>
#include <iostream>
#include <omp.h>
#include "reduce.h"


float reduce(const float* arr, const size_t l, const size_t r) {
	float count = 0;
#pragma omp parallel 
	{
#pragma omp for simd reduction(+:count)
	for (size_t i = l; i < r; i++) {
		count += arr[i];
	}
	}
	return count;
}

