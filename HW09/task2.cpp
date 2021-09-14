#include <cstdlib>
#include <iostream>
#include <omp.h>
#include "montecarlo.h"
#include <random>
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
    if (argc != 3) {
        return 0;
    }
    int n = atoi(argv[1]);
    int t = atoi(argv[2]);
    omp_set_num_threads(t);
    float* x = new float[n];
    float* y = new float[n];
    const float radius = 1.0;
    initializeArray(x, -radius, radius, n);
    initializeArray(y, -radius, radius, n);

    double start = omp_get_wtime();
    int count = montecarlo(n, x, y, radius);
    double end = omp_get_wtime();

    float pi_estimated = (float)count * 4.0 / (float)n;
    cout << pi_estimated << endl;
    cout << (end - start)*1000 << endl;
}

