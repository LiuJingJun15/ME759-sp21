#include "stencil.cuh"
#include<iostream>
#include<cuda.h>
using std::cout;
using namespace std;

// The following should be stored/computed in shared memory:
// - The entire mask
// - The elements of image needed to compute the elements of output corresponding to the threads in the given block
// - The output image elements corresponding to the given block before it is written back to global memory
__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R){
    int bx = blockIdx.x;
    int tx = threadIdx.x;
    int BLOCK_SIZE = blockDim.x;
    int index = bx*BLOCK_SIZE + tx;
    extern __shared__ float sh_arr[];
    // initialize shared mem
        for (int i = 0; i < 2*R+1; i++){
	    sh_arr[i] = mask[i];
	}
    int offsetImg = 2*R+1;
    if (tx - R < 0){
        if (BLOCK_SIZE*bx - R < 0){
	    sh_arr[offsetImg + tx] = 1.0;
	}else{
	    sh_arr[offsetImg + tx] = image[index - R];
	}
	sh_arr[offsetImg + tx + R] = image[index];
    }else if (tx + R > BLOCK_SIZE - 1){
        if (BLOCK_SIZE*bx + tx + R > n-1){
	    sh_arr[offsetImg + 2*R + tx] = 1.0;
	}else{
	    sh_arr[offsetImg + 2*R + tx] = image[index + R];
	}
	sh_arr[offsetImg + tx + R] = image[index];
    }else{
	sh_arr[offsetImg + tx + R] = image[index];
    }
    __syncthreads();
    // compute
    int offsetOut = offsetImg + BLOCK_SIZE + 2*R;
    for (int i=0; i < 2*R+1; i++){
        sh_arr[offsetOut + tx] += sh_arr[i] * sh_arr[offsetImg + i + tx];
    }
    __syncthreads();
    output[index] = sh_arr[offsetOut + tx];
}

__host__ void stencil(const float* image,
                      const float* mask,
                      float* output,
                      unsigned int n,
                      unsigned int R,
                      unsigned int threads_per_block){
                          cudaEvent_t startEvent, stopEvent; 
                          cudaEventCreate(&startEvent); 
                          cudaEventCreate(&stopEvent);
                          float *image_dev;
                          float *output_dev;
                          float *mask_dev;
                          cudaMalloc((void**)&image_dev, sizeof(float) * n );
                          cudaMalloc((void**)&output_dev, sizeof(float) * n);
                          cudaMalloc((void**)&mask_dev, sizeof(float) *(2 * R + 1));
                          cudaMemcpy(image_dev, image, sizeof(float)*n, cudaMemcpyHostToDevice);
                          cudaMemcpy(mask_dev, mask, sizeof(float)*(2*R+1), cudaMemcpyHostToDevice);

                          int blocksPerGrid = (n + threads_per_block - 1)/threads_per_block;
	                      int sizeShared = sizeof(float)*(2*threads_per_block + 4*R+1); //2R + 1 for image, 2R+1 for mask, block_size for output
                          cudaEventRecord(startEvent, 0);

                          stencil_kernel<<<blocksPerGrid, threads_per_block, sizeShared>>>(image_dev, mask_dev, output_dev, n, R);
			  cudaDeviceSynchronize();
                          cudaEventRecord(stopEvent, 0); 

                          cudaEventSynchronize(stopEvent); 

                          float elapsedTime; 
                          cudaEventElapsedTime(&elapsedTime, startEvent, stopEvent);
                          cudaMemcpy(output, output_dev, sizeof(float) * n, cudaMemcpyDeviceToHost);
                          cout << output[n-1] << endl;
                          cout << elapsedTime << endl;
                          cudaFree(image_dev);
                          cudaFree(output_dev);
                          cudaFree(mask_dev);
                          cudaEventDestroy(startEvent);
                          cudaEventDestroy(stopEvent);
                      }
