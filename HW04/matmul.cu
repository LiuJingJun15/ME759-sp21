#include "matmul.cuh"
#include<iostream>
#include<cuda.h>
using std::cout;
using namespace std;
void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block){
    cudaEvent_t startEvent, stopEvent; 
    cudaEventCreate(&startEvent); 
    cudaEventCreate(&stopEvent);
    int blocksPerGrid = (n * n + threads_per_block-1)/threads_per_block;
    float *a_dev;
    float *b_dev;
    float *c_dev;
    cudaMalloc((void**)&a_dev, sizeof(float) * n * n);
    cudaMalloc((void**)&b_dev, sizeof(float) * n * n);
    cudaMalloc((void**)&c_dev, sizeof(float) * n * n);
    cudaMemcpy(a_dev, A, sizeof(float)*n*n, cudaMemcpyHostToDevice);
    cudaMemcpy(b_dev, B, sizeof(float)*n*n, cudaMemcpyHostToDevice);

    cudaEventRecord(startEvent, 0);
    matmul_kernel<<<blocksPerGrid, threads_per_block>>>(a_dev, b_dev, c_dev, n);
    cudaDeviceSynchronize();
    cudaEventRecord(stopEvent, 0); 
    cudaEventSynchronize(stopEvent); 

    float elapsedTime; 
    cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
    cudaMemcpy(C, c_dev, sizeof(float) * n * n, cudaMemcpyDeviceToHost);
    cout << C[n*n-1] << endl;
    cout << elapsedTime << endl;
    
    cudaEventDestroy(startEvent); 
    cudaEventDestroy(stopEvent);
    cudaFree(a_dev);
    cudaFree(b_dev);
    cudaFree(c_dev);
}

__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n){
    int bidx = blockIdx.x;
    int tidx = threadIdx.x;
    int M = blockDim.x;
    int idxC = M*bidx + tidx;
    int row = idxC/n;
    int col = idxC%n;
    float sum = 0.0;
    if (idxC >= n*n){
        return;
    }
    for (int i = 0; i < n; i++){
        sum += A[row*n + i]*B[n*i + col];
    }
    C[idxC] = sum;
}
