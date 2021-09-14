#include "vscale.cuh"

__global__ void vscale(const float *a, float *b, unsigned int n)
{
    //this adds a value to a variable stored in global memory
    int x = threadIdx.x;
    int y = blockIdx.x;
    int idx = y*blockDim.x + x;
    if (idx < n){ 
        b[idx] *= a[idx];
    }else{
        return;    
    }
}
