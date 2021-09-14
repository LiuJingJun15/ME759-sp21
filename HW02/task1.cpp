#include <iostream>
#include <cstdlib>
#include "scan.h"
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
    if (argc != 2) {
        return 0;
    }
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    int n = atoi(argv[1]);
    float* arr;
    float* result;
    arr = new float[n];
    result = new float[n];
    for (int i = 0; i < n; i++) {
        arr[i] = randomWithin(1.0);
    } 
    // Get the starting timestamp
    start = high_resolution_clock::now();
    scan(arr, result, n);
    // Get the ending timestamp
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    
    // Durations are converted to milliseconds already thanks to std::chrono::duration_cast
    cout << duration_sec.count() << endl;
    cout << result[0] << endl;
    cout << result[n-1] << endl;
    delete arr;
    delete result;
    return 0;
}
