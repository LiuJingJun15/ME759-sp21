#include<cuda.h>
#include<iostream>
#include<stdio.h>


__global__ void factorialKernel()
{
    //this adds a value to a variable stored in global memory
    int factorial = 1;
    int n = threadIdx.x+1;
    for(int i = 1; i <= n; ++i) {
        factorial *= i;
    }
    printf("%d!=%d\n", n, factorial);
}


int main()
{

    //invoke GPU kernel, with one block that has four threads
    factorialKernel<<<1,8>>>();
    cudaDeviceSynchronize();
    //bring the result back from the GPU into the hostArray 
    // cudaMemcpy(&hostArray, devArray, sizeof(int) * numElems, cudaMemcpyDeviceToHost);

    // print out the result to confirm that things are looking good 
    //std::printf("here\n");    
    //release the memory allocated on the GPU 
    //cudaFree(devArray);
    return 0;
}

