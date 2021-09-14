#include<cuda.h>
#include<iostream>
#include <chrono>
#include <random>
#include "matmul.cuh"
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
    if (argc != 3) {
        return 0;
    }
    int input = atoi(argv[1]);
    int threadsPerBlock = atoi(argv[2]);
    unsigned int n = (unsigned int) input;
    float *a = new float[n*n];
    float *b = new float[n*n];
    float *c = new float[n*n];
    initializeArray(a, -1.0, 1.0, n * n);
    initializeArray(b, -1.0, 1.0, n * n);

    matmul(a, b, c, n, threadsPerBlock); 

    delete(a);
    delete(b);
    delete(c);
    
    return 0;
}
