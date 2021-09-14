#include <cstdlib>
#include <iostream>
#include <omp.h>
#include "reduce.h"
#include <random>
#include <math.h> 
using namespace std;

void initializeArray(float* arr, float min, float max, unsigned int n) {
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<float> dist(min, max);
    for (unsigned int i = 0; i < n; i++) {
        arr[i] = dist(generator);
    }
}


int main(int argc, char** argv) {
    int n = atoi(argv[1]);
    int t = atoi(argv[2]);
    float* arr = new float[n];
    initializeArray(arr, -1.0, 1.0, n);
    omp_set_num_threads(t);
    double start = omp_get_wtime();
    float global_res = reduce(arr, 0, n);
    double end = omp_get_wtime();
    cout << global_res << endl;
    cout << (end - start) * 1000 << endl;
    
}

