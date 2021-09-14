#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include "matmul.cuh"
#include "matmul_kernel.cuh"
using namespace std;

float randomFloatWithin(float min, float max){
    int some_seed = 111;
    std::mt19937 generator(some_seed);
    std::uniform_real_distribution<float> dist(min, max);
    float pseudorandom_float = dist(generator);
    return pseudorandom_float;
}

void initializeFloatArray(float *arr, float min, float max, unsigned int n){
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<float> dist(min, max);
    for (unsigned int i = 0; i < n;i++){
        arr[i] = dist(generator);
    }
}

void initializeDoubleArray(double* arr, double min, double max, unsigned int n) {
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<double> dist(min, max);
    for (unsigned int i = 0; i < n; i++) {
        arr[i] = dist(generator);
    }
}

void initializeIntArray(int* arr, int min, int max, unsigned int n) {
    int mod = max - min + 1;
    for (unsigned int i = 0; i < n; i++) {
        arr[i] = rand() % mod + min;
    }
}
   
int main(int argc, char** argv) {
    if (argc != 3) {
        return 0;
    }
    int n = atoi(argv[1]);
    int block_dim = atoi(argv[2]);
    if (block_dim > 32){
        block_dim = 32;
    }
    if (block_dim > n){
        block_dim = n;
    }

    int* A_int = new int[n * n];
    int* B_int = new int[n * n];
    int* C_int = new int[n * n];
    initializeIntArray(A_int, -10, 10, n * n);
    initializeIntArray(B_int, -10, 10, n * n);

    float* A_float = new float[n * n];
    float* B_float = new float[n * n];
    float* C_float = new float[n * n];
    initializeFloatArray(A_float, -1.0, 1.0, n * n);
    initializeFloatArray(B_float, -1.0, 1.0, n * n);
    
    double* A_double = new double[n * n];
    double* B_double = new double[n * n];
    double* C_double = new double[n * n];
    initializeDoubleArray(A_double, -1.0, 1.0, n * n);
    initializeDoubleArray(B_double, -1.0, 1.0, n * n);

    cudaEvent_t startEvent, stopEvent;
    cudaEventCreate(&startEvent);
    cudaEventCreate(&stopEvent);

    // int arrays
    int* Ad_int;
    int* Bd_int;
    int* Cd_int;
    cudaMalloc((void**)&Ad_int, sizeof(int) * n * n);
    cudaMalloc((void**)&Bd_int, sizeof(int) * n * n);
    cudaMalloc((void**)&Cd_int, sizeof(int) * n * n);
    cudaMemcpy(Ad_int, A_int, sizeof(int) * n * n, cudaMemcpyHostToDevice);
    cudaMemcpy(Bd_int, B_int, sizeof(int) * n * n, cudaMemcpyHostToDevice);

    cudaEventRecord(startEvent, 0);
    matmul_1(Ad_int, Bd_int, Cd_int, n, block_dim);
    cudaEventRecord(stopEvent, 0);

    cudaEventSynchronize(stopEvent);
    cudaDeviceSynchronize();
    float elapsedTime_int;
    cudaEventElapsedTime(&elapsedTime_int, startEvent, stopEvent);
    cudaMemcpy(C_int, Cd_int, sizeof(int) * n * n, cudaMemcpyDeviceToHost);
    cout << C_int[0] << endl;
    cout << C_int[n * n - 1] << endl;
    cout << elapsedTime_int << endl;
    cudaFree(Ad_int);
    cudaFree(Bd_int);
    cudaFree(Cd_int);
    


    // float arrays
    float* Ad_float;
    float* Bd_float;
    float* Cd_float;
    cudaMalloc((void**)&Ad_float, sizeof(float) * n * n);
    cudaMalloc((void**)&Bd_float, sizeof(float) * n * n);
    cudaMalloc((void**)&Cd_float, sizeof(float) * n * n);
    cudaMemcpy(Ad_float, A_float, sizeof(float) * n * n, cudaMemcpyHostToDevice);
    cudaMemcpy(Bd_float, B_float, sizeof(float) * n * n, cudaMemcpyHostToDevice);

    cudaEventRecord(startEvent, 0);
    matmul_2(Ad_float, Bd_float, Cd_float, n, block_dim);
    cudaEventRecord(stopEvent, 0);

    cudaEventSynchronize(stopEvent);
    cudaDeviceSynchronize();
    float elapsedTime_float;
    cudaEventElapsedTime(&elapsedTime_float, startEvent, stopEvent);
    cudaMemcpy(C_float, Cd_float, sizeof(float) * n * n, cudaMemcpyDeviceToHost);
    cout << C_float[0] << endl;
    cout << C_float[n * n - 1] << endl;
    cout << elapsedTime_float << endl;
    cudaFree(Ad_float);
    cudaFree(Bd_float);
    cudaFree(Cd_float);

    // double arrays
    double* Ad_double;
    double* Bd_double;
    double* Cd_double;
    cudaMalloc((void**)&Ad_double, sizeof(double) * n * n);
    cudaMalloc((void**)&Bd_double, sizeof(double) * n * n);
    cudaMalloc((void**)&Cd_double, sizeof(double) * n * n);
    cudaMemcpy(Ad_double, A_double, sizeof(double) * n * n, cudaMemcpyHostToDevice);
    cudaMemcpy(Bd_double, B_double, sizeof(double) * n * n, cudaMemcpyHostToDevice);

    cudaEventRecord(startEvent, 0);
    matmul_3(Ad_double, Bd_double, Cd_double, n, block_dim);
    cudaEventRecord(stopEvent, 0);

    cudaEventSynchronize(stopEvent);
    cudaDeviceSynchronize();
    float elapsedTime_double;
    cudaEventElapsedTime(&elapsedTime_double, startEvent, stopEvent);
    cudaMemcpy(C_double, Cd_double, sizeof(double) * n * n, cudaMemcpyDeviceToHost);
    cout << C_double[0] << endl;
    cout << C_double[n * n - 1] << endl;
    cout << elapsedTime_double << endl;
    cudaFree(Ad_double);
    cudaFree(Bd_double);
    cudaFree(Cd_double);
    return 0;
}
