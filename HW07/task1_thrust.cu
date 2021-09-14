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

using namespace std;

struct randg
{
    __host__ __device__
        float operator()(const float min, const float max) const{
        thrust::minstd_rand rng;
        thrust::uniform_real_distribution<float> dist(min, max);

        return dist(rng);
    }
};

int main(int argc, char** argv) {
    if (argc != 2) {
        return 0;
    }
    int n = atoi(argv[1]);
    cudaEvent_t startEvent, stopEvent;
    cudaEventCreate(&startEvent);
    cudaEventCreate(&stopEvent);
    thrust::host_vector<float> h_vec(n);
    thrust::device_vector<float> d_vec;

    thrust::minstd_rand rng;
    thrust::uniform_real_distribution<float> dist(-1.0f, 1.0f);
    for (int i = 0; i < n; i++){
        h_vec[i] = dist(rng);
    }
    float init = h_vec[0];
    // thrust::copy(h_vec.begin(), h_vec.end(), d_vec.begin());
    d_vec = h_vec;
    cudaEventRecord(startEvent, 0);

    float result = thrust::reduce(thrust::cuda::par, d_vec.begin(), d_vec.end(), init);

    cudaEventRecord(stopEvent, 0);
    cudaEventSynchronize(stopEvent);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
    cout << result << endl;
    cout << elapsedTime << endl;
    return 0;
}
