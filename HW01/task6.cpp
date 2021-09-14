#include <iostream>
#include <cstdlib>
using namespace std;
int main(int argc, char** argv){
    if (argc != 2){
        return 0;
    }
    int N = atoi(argv[1]);
    for (int i = 0; i <= N; i++){
        if (i != N){
	    printf("%d ", i);
	}else{
	    printf("%d\n", i);
	}
    }
    for (int j = N; j >= 0; j--){
        if(j != 0){
	    std::cout << j << " ";
	}else{
	    std::cout << j << std::endl;
	}
    }
    return 0;
}
