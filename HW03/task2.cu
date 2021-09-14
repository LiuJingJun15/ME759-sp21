#include<cuda.h>
#include<iostream>

__global__ void simpleKernel(int a, int* dA)
{
    //this adds a value to a variable stored in global memory
    int x = threadIdx.x;
    int y = blockIdx.x;
    // printf("x is %d, y is %d, index is %d, num is %d\n",x,8*y+x,a*x+y);
    dA[8*y+x] = a*x + y;
}

int main()
{
    int hA[16], *dA;
    //allocate memory on the device (GPU); zero out all entries in this device array 
    cudaMalloc((void**)&dA, sizeof(int) * 16);
    cudaMemset(dA, 0, 16 * sizeof(int));

    const int RANGE = 10;
    int a = rand() % (RANGE + 1);
    //invoke GPU kernel, with one block that has four threads
    simpleKernel<<<2,8>>>(a, dA);
    cudaDeviceSynchronize();
    //bring the result back from the GPU into the hostArray 
    cudaMemcpy(&hA, dA, sizeof(int) * 16, cudaMemcpyDeviceToHost);

    for (int i = 0; i < 16; i++)
        std::cout << hA[i] << " ";
    std::cout << "\n";
    //release the memory allocated on the GPU 
    cudaFree(dA);
    return 0;
}
