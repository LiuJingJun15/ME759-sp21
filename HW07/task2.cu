#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include <thrust/reduce.h>
#include <thrust/system/cuda/execution_policy.h>
#include <thrust/system/omp/execution_policy.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/sequence.h>
#include <thrust/sequence.h>
#include <thrust/random/linear_congruential_engine.h>
#include <thrust/random/uniform_real_distribution.h>
#include <thrust/transform.h>
#include <thrust/functional.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>
#include "count.cuh"
#include <ctime>
using namespace std;

int main(int argc, char** argv) {
    if (argc != 2) {
        return 0;
    }
    int n = atoi(argv[1]);
    cudaEvent_t startEvent, stopEvent;
    cudaEventCreate(&startEvent);
    cudaEventCreate(&stopEvent);

    thrust::host_vector<int> h_vec(n);
    thrust::device_vector<int> d_val(n);
    thrust::device_vector<int> d_count(n);
    thrust::device_vector<int> d_in(n);
    thrust::host_vector<int> value(n);
    thrust::host_vector<int> counts(n);
    srand(time(0));
    for (int i = 0; i < n; i++) {
        h_vec[i] = rand()%501;
    }
    d_in = h_vec;
    cudaEventRecord(startEvent, 0);

    count(d_in, d_val, d_count);

    cudaEventRecord(stopEvent, 0);
    cudaEventSynchronize(stopEvent);
    int sizeval = d_val.end() - d_val.begin();
    value = d_val;
    counts = d_count;
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
    
    cout << value[sizeval - 1] << endl;
    cout << counts[sizeval - 1] << endl;
    cout << elapsedTime << endl;
    
}
