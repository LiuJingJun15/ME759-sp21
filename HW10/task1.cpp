#include<iostream>
#include <chrono>
#include <random>
#include "optimize.h"
typedef vec* vec_ptr;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using namespace std::chrono;
using namespace std;


void initializeArray(data_t* arr, float min, float max, unsigned int n) {
    std::random_device source;
    std::mt19937_64 generator(source());
    std::uniform_real_distribution<float> dist(min, max);
    for (unsigned int i = 0; i < n; i++) {
        arr[i] = (data_t) dist(generator);
    }
}

int main(int argc, char** argv) {
    int n = atoi(argv[1]);

    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> duration_sec;

    data_t* data_this = new data_t[n];
    data_t* dest = new data_t[1];

    initializeArray(data_this, 0.99, 1.01, n);
    
    vec_ptr v = new vec(n);
    v->data = data_this;
    
    *dest = IDENT;
    start = high_resolution_clock::now();
    for (int i = 0; i < 10; i++) {
        optimize1(v, dest);
    }
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << dest[0] << endl;
    cout << duration_sec.count()/10 << endl;

    *dest = IDENT;
    start = high_resolution_clock::now();
    for (int i = 0; i < 10; i++) {
        optimize2(v, dest);
    }
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << dest[0] << endl;
    cout << duration_sec.count()/10 << endl;

    *dest = IDENT;
    start = high_resolution_clock::now();
    for (int i = 0; i < 10; i++) {
        optimize3(v, dest);
    }
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << dest[0] << endl;
    cout << duration_sec.count()/10 << endl;

    *dest = IDENT;
    start = high_resolution_clock::now();
    for (int i = 0; i < 10; i++) {
        optimize4(v, dest);
    }
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << dest[0] << endl;
    cout << duration_sec.count()/10 << endl;

    *dest = IDENT;
    start = high_resolution_clock::now();
    for (int i = 0; i < 10; i++) {
        optimize5(v, dest);
    }
    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << dest[0] << endl;
    cout << duration_sec.count()/10 << endl;

    return 0;
}
