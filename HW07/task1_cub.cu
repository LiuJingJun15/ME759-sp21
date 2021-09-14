#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#define CUB_STDERR // print CUDA runtime errors to console
#include <stdio.h>
#include <cub/util_allocator.cuh>
#include <cub/device/device_reduce.cuh>
#include "cub/util_debug.cuh"
using namespace std;
using namespace cub;
CachingDeviceAllocator  g_allocator(true);  // Caching allocator for device memory


int main(int argc, char** argv) {
    if (argc != 2) {
        return 0;
    }
    int n = atoi(argv[1]);
    const size_t num_items = n;
    float *h_in = new float[num_items];
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);

    for (int i = 0; i < n; i++) {
        h_in[i] = dist(generator);
    }
    
    
    cudaEvent_t startEvent, stopEvent;
    cudaEventCreate(&startEvent);
    cudaEventCreate(&stopEvent);

    float* d_in = NULL;
    g_allocator.DeviceAllocate((void**)&d_in, sizeof(float) * num_items);
    cudaMemcpy(d_in, h_in, sizeof(float) * num_items, cudaMemcpyHostToDevice);
    float* d_sum = NULL;
    g_allocator.DeviceAllocate((void**)&d_sum, sizeof(float) * 1);
    // Request and allocate temporary storage
    void* d_temp_storage = NULL;
    size_t temp_storage_bytes = 0;
    DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum, num_items);
    g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes);
    
    cudaEventRecord(startEvent, 0);

    DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum, num_items);

    cudaEventRecord(stopEvent, 0);

    float gpu_sum;
    cudaMemcpy(&gpu_sum, d_sum, sizeof(float) * 1, cudaMemcpyDeviceToHost);
    cudaEventSynchronize(stopEvent);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
    cout << gpu_sum << endl;
    cout << elapsedTime << endl;
    if (d_in) g_allocator.DeviceFree(d_in);
    if (d_sum) g_allocator.DeviceFree(d_sum);
    if (d_temp_storage) g_allocator.DeviceFree(d_temp_storage);
    return 0;
}
