#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include "vscale.cuh"
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
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

void printRandFloat(float min, float max, unsigned int n){
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<float> dist(min, max);
    for (unsigned int i = 0; i < n; i++){	
	cout << dist(generator) << endl;
    }
}

   
int main(int argc, char** argv) {
    if (argc != 2) {
        return 0;
    }
    
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    int input = atoi(argv[1]);
    unsigned int n = (unsigned int) input;
    float *a = new float[n];
    float *b = new float[n];
    float *c = new float[n];
    float *a_dev;
    float *b_dev;
    cudaMalloc((void**)&a_dev, sizeof(float) * n);
    cudaMalloc((void**)&b_dev, sizeof(float) * n);
    initializeArray(a, -10.0, 10.0, n);
    initializeArray(b, 0.0, 1.0, n);
    cudaMemcpy(a_dev, a, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(b_dev, b, sizeof(float)*n, cudaMemcpyHostToDevice);
    const int threadsPerBlock = 16;
    int blocksPerGrid = (n+threadsPerBlock-1)/threadsPerBlock;
    
    start = high_resolution_clock::now();

    vscale<<<blocksPerGrid, threadsPerBlock>>>(a_dev, b_dev, n);
    cudaDeviceSynchronize();

    end = high_resolution_clock::now();

    cudaMemcpy(c, b_dev, sizeof(float) * n, cudaMemcpyDeviceToHost);
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    
    cout << duration_sec.count() << endl;
    cout << c[0] << endl;
    cout << c[n-1] << endl;
    delete(a);
    delete(b);
    cudaFree(a_dev);
    cudaFree(b_dev);
    return 0;
}
