#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include "stencil.cuh"
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

   
int main(int argc, char** argv) {
    if (argc != 4) {
        return 0;
    }
    
    int input = atoi(argv[1]);
    int R = atoi(argv[2]);
    unsigned int n = (unsigned int) input;
    int threads_per_block = atoi(argv[3]);
    float *image = new float[n];
    float *output = new float[n];
    float *mask = new float[2*R+1];
    
    initializeArray(image, -1.0, 1.0, n);
    initializeArray(mask, -1.0, 1.0, 2*R + 1);

    stencil(image, mask, output, n, R, threads_per_block); 

    delete(image);
    delete(output);
    delete(mask);
    
    return 0;
}
