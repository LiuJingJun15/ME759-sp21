#include <cstdlib>
#include <iostream>
#include <omp.h>
#include "cluster.h"
#include <random>
#include <algorithm>
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
    if (argc == 1) {
        float arr[8] = { 0.0, 1.0, 3.0, 4.0, 6.0, 6.0, 7.0, 8.0 };
        int n = 8; 
        int t = 2;
        float* centers = new float[t];
        for (int i = 0; i < t; i++) {
            centers[i] = arr[(2 * i + 1) * n / (2 * t)];
        }
        float* dists = new float[t];
        cluster(n, t, arr, centers, dists);
        for (int i = 0; i < t; i++) {
            cout << dists[i] << endl;
        }
        return 0;
    }
    if (argc != 3) {
        return 0;
    }
    int n = atoi(argv[1]);
    int t = atoi(argv[2]);
    omp_set_num_threads(t);
    float* arr = new float[n];
    initializeArray(arr, 0.0, (float)n, n);
    sort(arr, arr + n);
    float* centers = new float[t];
    for (int i = 0; i < t; i++) {
        centers[i] = arr[(2 * i + 1) * n / (2 * t)];
    }
    float* dists = new float[t];

    double start = omp_get_wtime();
    cluster(n, t, arr, centers, dists);
    double end = omp_get_wtime();

    float maxDist = 0.0;
    float partitionID = 0;
    for (int i = 0; i < t; i++) {
        if (dists[i] > maxDist) {
            maxDist = dists[i];
            partitionID = centers[i];
        }
    }

    cout << maxDist << endl;
    cout << partitionID << endl;
    cout << (end - start)*1000 << endl;
}

