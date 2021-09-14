#include <cuda.h>
template <class TYPE>
__global__ void matmul_kernel(const TYPE* A, const TYPE* B, TYPE* C, unsigned int n) {
    extern __shared__ char sdata_char[];
    TYPE* sdata = reinterpret_cast<TYPE*>(sdata_char);
    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x; 
    int ty = threadIdx.y;
    const int BLOCK_SIZE = blockDim.x;
    int aBegin = n * BLOCK_SIZE * by;
    int aEnd = aBegin + n - 1;
    int aStep = BLOCK_SIZE;
    int bBegin = BLOCK_SIZE * bx;
    int bStep = BLOCK_SIZE * n;
    TYPE Csub = 0;
    int sIdxA;
    int sIdxB;
    for (int a = aBegin, b = bBegin;
        a <= aEnd;
        a += aStep, b += bStep) {
        sIdxA = ty * BLOCK_SIZE + tx;
        sIdxB = sIdxA + BLOCK_SIZE * BLOCK_SIZE;
        if (a + n * ty + tx < n * n) {
            sdata[sIdxA] = A[a + n * ty + tx];
        }
        else {
            sdata[sIdxA] = 0;
        }
        if (b + n * ty + tx < n * n) {
            sdata[sIdxB] = B[b + n * ty + tx];
        }
        else {
            sdata[sIdxB] = 0;
        }
        __syncthreads();

        for (int k = 0; k < BLOCK_SIZE; k++) {
            Csub += sdata[ty * BLOCK_SIZE + k] * sdata[k * BLOCK_SIZE + tx + BLOCK_SIZE * BLOCK_SIZE];
        }
        __syncthreads();
    }
    int c = n * BLOCK_SIZE * by + BLOCK_SIZE * bx;
    C[c + n * ty + tx] = Csub;
}