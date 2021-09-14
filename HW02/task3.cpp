#include <iostream>
#include <cstdlib>
#include "matmul.h"
#include <chrono>
#include <ratio>
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using namespace std;

double randomWithin(double n) {
    int randomBit = rand() & 1;
    return randomBit ? n * (double(rand() % RAND_MAX)) / double(RAND_MAX) : -n * (double(rand() % RAND_MAX)) / double(RAND_MAX);
}



int main(int argc, char** argv) {
    const unsigned int n = 1024;
    double* A_ptr = new double[n*n];
    double* B_ptr = new double[n*n];
    double* C_ptr = new double[n*n];
    std::vector<double> A_vec;
    std::vector<double> B_vec;


    high_resolution_clock::time_point start1;
    high_resolution_clock::time_point start2;
    high_resolution_clock::time_point start3;
    high_resolution_clock::time_point start4;
    high_resolution_clock::time_point end1;
    high_resolution_clock::time_point end2;
    high_resolution_clock::time_point end3;
    high_resolution_clock::time_point end4;
    duration<double, std::milli> duration_sec1;
    duration<double, std::milli> duration_sec2;
    duration<double, std::milli> duration_sec3;
    duration<double, std::milli> duration_sec4;

    double randDoubleA;
    double randDoubleB;
    for (unsigned int i = 0; i < n * n; i++) {
        randDoubleA = randomWithin(1.0);
        randDoubleB = randomWithin(1.0);
        A_ptr[i] = randDoubleA;
        B_ptr[i] = randDoubleB;
        A_vec.push_back(randDoubleA);
        B_vec.push_back(randDoubleB);
    }

    start1 = high_resolution_clock::now();
    mmul1(A_ptr, B_ptr, C_ptr, n);
    end1 = high_resolution_clock::now();
    double C_end1 = C_ptr[n * n - 1];
    duration_sec1 = std::chrono::duration_cast<duration<double, std::milli>>(end1 - start1);

    start2 = high_resolution_clock::now();
    mmul2(A_ptr, B_ptr, C_ptr, n);
    end2 = high_resolution_clock::now();
    double C_end2 = C_ptr[n * n - 1];
    duration_sec2 = std::chrono::duration_cast<duration<double, std::milli>>(end2 - start2);

    start3 = high_resolution_clock::now();
    mmul3(A_ptr, B_ptr, C_ptr, n);
    end3 = high_resolution_clock::now();
    double C_end3 = C_ptr[n * n - 1];
    duration_sec3 = std::chrono::duration_cast<duration<double, std::milli>>(end3 - start3);

    start4 = high_resolution_clock::now();
    mmul4(A_vec, B_vec, C_ptr, n);
    end4 = high_resolution_clock::now();
    double C_end4 = C_ptr[n * n - 1];
    duration_sec4 = std::chrono::duration_cast<duration<double, std::milli>>(end4 - start4);

    cout << n << endl; 
    cout << duration_sec1.count() << endl;
    cout << C_end1 << endl;
    cout << duration_sec2.count() << endl;
    cout << C_end2 << endl;
    cout << duration_sec3.count() << endl;
    cout << C_end3 << endl;
    cout << duration_sec4.count() << endl;
    cout << C_end4 << endl;
    delete A_ptr;
    delete B_ptr;
    delete C_ptr;
    /*delete A_vec;
    delete B_vec;*/
}
