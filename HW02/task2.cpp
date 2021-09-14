#include <iostream>
#include <cstdlib>
#include "convolution.h"
#include <chrono>
#include <ratio>
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using namespace std;

float randomWithin(float n) {
    int randomBit = rand() & 1;
    return randomBit ? n * (float(rand() % RAND_MAX)) / float(RAND_MAX) : -n * (float(rand() % RAND_MAX)) / float(RAND_MAX);
}



int main(int argc, char** argv) {
    if (argc != 3) {
        return 0;
    }
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    std::size_t n = atoi(argv[1]);
    std::size_t m = atoi(argv[2]);
    float* image = new float[n*n];
    float* output;
    float* mask =new float[m*m];
    output = new float[n*n];
    for (std::size_t i = 0; i < n*n; i++) {
        image[i] = randomWithin(10.0);
    }
    for (std::size_t i = 0; i < m * m; i++) {
        mask[i] = randomWithin(1.0);
    }
    // Get the starting timestamp
    start = high_resolution_clock::now();
    convolve(image, output, n, mask, m);
    // Get the ending timestamp
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    // Durations are converted to milliseconds already thanks to std::chrono::duration_cast
    cout << duration_sec.count() << endl;
    cout << output[0] << endl;
    cout << output[n * n - 1] << endl;
    
    delete image;
    delete mask;
    delete output;
    return 0;
}
