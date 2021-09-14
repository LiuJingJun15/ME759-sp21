#include<cuda.h>
#include "reduce.cuh"
#include<iostream>
using std::cout;
using namespace std;



__global__ void reduce_kernel(float* g_idata, float* g_odata, unsigned int n) {
    int bid = blockIdx.x;
    int tid = threadIdx.x;
    int bd = blockDim.x;
    unsigned int i = bid * (bd * 2) + tid;
    extern __shared__ float sdata[];
    // printf("bid: %d, tid:%d, bd:%d, input[i]: %f, input[i+bd]: %f\n",bid,tid,bd,g_idata[i],g_idata[i+bd]);
    if (i < n) {
        if (i + bd < n) {
            sdata[tid] = g_idata[i] + g_idata[i + bd];
        }
        else {
            sdata[tid] = g_idata[i];
        }
    }
    else {
        sdata[tid] = 0.0;
    }
    __syncthreads();
    for (unsigned int s = bd / 2; s > 0; s >>= 1) {
        if (tid < s) {
            sdata[tid] += sdata[tid + s];
        }
        __syncthreads();
    }
    g_odata[bid] = sdata[0];
    __syncthreads();
}

__host__ void reduce(float** input, float** output, unsigned int N, unsigned int threads_per_block) {
    /*
    for (int i = 0; i < N; i++) {
        printf("%f, ", (*input)[i]);
    }
    printf("\n");
    */
    int lenReal;
    if (N%2 == 0){
        lenReal = N/2;
    }else{
        lenReal = N/2 + 1;
    }
    int nBlocks = (lenReal + threads_per_block - 1) / threads_per_block;
    if (nBlocks == 0) {nBlocks = 1;}
    while (nBlocks > 0) {	
        if (nBlocks == 1){
            reduce_kernel << <1, threads_per_block, sizeof(float)*threads_per_block >> > (*input, *output, N);
            cudaDeviceSynchronize();
	        break;
	    }else{
            reduce_kernel << <nBlocks, threads_per_block, sizeof(float)* threads_per_block >> > (*input, *output, N);
            cudaDeviceSynchronize();
	        N = nBlocks;
            if (N % 2 == 0) {
                lenReal = N / 2;
            }
            else {
                lenReal = N / 2 + 1;
            }
            nBlocks = (lenReal + threads_per_block - 1) / threads_per_block;
	        *input = *output;            
        }
	    // printf("leaving with nBlocks: %d, lenReal: %d, N: %d\n", nBlocks, lenReal,N);
    }
}


