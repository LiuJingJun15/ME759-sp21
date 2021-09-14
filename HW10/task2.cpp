#include <cstdlib>
#include <chrono>
#include <iostream>
#include <omp.h>
#include "reduce.h"
#include <random>
#include <math.h> 
#include "mpi.h"
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
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
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    
    int p;
    int my_rank;
    float this_reduce, global_res;
    // double start, end;
    float* arr = new float[n];
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &p);

    omp_set_num_threads(t);

    initializeArray(arr, -1.0, 1.0, n);
    MPI_Barrier(MPI_COMM_WORLD);
    start = high_resolution_clock::now();
    this_reduce = reduce(arr, 0, n);

    MPI_Reduce(&this_reduce, &global_res, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD); 
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

    if (my_rank == 0) {
        cout << global_res << endl;
        cout << duration_sec.count() << endl;
    }
    return 0;
}

