#include <cstdlib>
#include <iostream>
#include "cluster.h"
#include <omp.h>

void cluster(const size_t n, const size_t t, const float *arr,
             const float *centers, float *dists) {
#pragma omp parallel num_threads(t)
  {
    unsigned int tid = omp_get_thread_num();
    float sum = 0.0;
#pragma omp for
    for (size_t i = 0; i < n; i++) {
      sum += abs(arr[i] - centers[tid]);
    }
    dists[tid] = sum;
  }
}
