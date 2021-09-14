#include "mpi.h"
#include <iostream>
#include <random>
#include <cstdlib>
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
    int p;
    int my_rank;
    float* arr = new float[n];
    double start, end;
    int tag1 = 100;
    int tag2 = 200;
    int tag3 = 300;
    float* time1 = new float[1];
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &p);

    if (p != 2) {
        MPI_Abort(MPI_COMM_WORLD, 1);
    }
        

    if (my_rank == 0) { 
        initializeArray(arr, 0.0, 1.0, n);
        start = MPI_Wtime();
        MPI_Send(arr, n, MPI_FLOAT, 1, tag1, MPI_COMM_WORLD);

        MPI_Recv(arr, n, MPI_FLOAT, 1, tag2, MPI_COMM_WORLD, &status);
        end = MPI_Wtime();
        time1[0] = end - start;
        MPI_Send(time1, 1, MPI_FLOAT, 1, tag3, MPI_COMM_WORLD);
    }
    else if(my_rank == 1){ 
        start = MPI_Wtime();
        MPI_Recv(arr, n, MPI_FLOAT, 0, tag1, MPI_COMM_WORLD, &status);
        
        MPI_Send(arr, n, MPI_FLOAT, 0, tag2, MPI_COMM_WORLD);
        end = MPI_Wtime();
        MPI_Recv(time1, 1, MPI_FLOAT, 0, tag3, MPI_COMM_WORLD, &status);
        printf("%f\n", (time1[0] + end - start)*1000);
    }

    MPI_Finalize();
    return 0;
}
