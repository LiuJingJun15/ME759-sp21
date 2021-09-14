#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include "reduce.cuh"
using namespace std;

float randomWithin(float min, float max){
    int some_seed = 111;
    std::mt19937 generator(some_seed);
    std::uniform_real_distribution<float> dist(min, max);
    float pseudorandom_float = dist(generator);
    return pseudorandom_float;
}

void initializeArray(float *arr, float min, float max, unsigned int n){
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<float> dist(min, max);
    for (unsigned int i = 0; i < n;i++){
        arr[i] = dist(generator);
    }
}

   
int main(int argc, char** argv) {
    if (argc != 3) {
        return 0;
    }
    int n_in = atoi(argv[1]);
    int threads_per_block = atoi(argv[2]);
    unsigned int n = (unsigned int) n_in;
    int lenReal;
    if (n % 2 == 0) {
        lenReal = n / 2;
    }
    else {
        lenReal = n / 2 + 1;
    }
    int nBlocks = (lenReal + threads_per_block - 1) / threads_per_block;
    float* input = new float[n];
    float* output = new float[nBlocks];
    initializeArray(input, -1.0, 1.0, n);
    cudaEvent_t startEvent, stopEvent;
    cudaEventCreate(&startEvent);
    cudaEventCreate(&stopEvent);
    float* input_dev;
    float* output_dev;
    
    if (nBlocks == 0) { nBlocks = 1; }
    cudaMalloc((void**)&input_dev, sizeof(float) * n);
    cudaMalloc((void**)&output_dev, sizeof(float) * nBlocks);
    
    cudaMemcpy(input_dev, input, sizeof(float) * n, cudaMemcpyHostToDevice);

    cudaEventRecord(startEvent, 0);
    reduce(&input_dev, &output_dev, n, threads_per_block);

    cudaEventRecord(stopEvent, 0);
    cudaEventSynchronize(stopEvent);
    cudaMemcpy(output, output_dev, sizeof(float), cudaMemcpyDeviceToHost);
    float elapsedTime;
    cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
    cout << output[0] << endl;
    cout << elapsedTime << endl;
    cudaEventDestroy(startEvent);
    cudaEventDestroy(stopEvent);
    delete(input);
    delete(output);
    return 0;
}
