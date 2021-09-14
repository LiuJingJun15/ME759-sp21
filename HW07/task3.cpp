#include <iostream>
#include <omp.h>
using namespace std;
int factorial(int n) {
    int fac = 1;
    for (int i = 1; i <= n; i++) {
        fac *= i;
    }
    return fac;
}

int main() {
#pragma omp parallel
    
    {
        int myId = omp_get_thread_num();
        int nThreads = omp_get_num_threads();
        if (myId == 0){
            printf("Number of threads: %d \n", nThreads);
        }
    }
    
#pragma omp parallel
    {
        int myId = omp_get_thread_num();
        
	printf("I am thread No. %d\n", myId);
    }
#pragma omp parallel
    
    {
        int myId2 = omp_get_thread_num() + 1;
        int myId4 = myId2 + 4;
	printf("%d!=%d\n",myId2,factorial(myId2));
	printf("%d!=%d\n",myId4,factorial(myId4));
    }
}
