#include <cstdlib>
#include <iostream>
#include <omp.h>
#include <algorithm>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <sstream>
#include <math.h>
#include <chrono>
using namespace std;
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

int main(int argc, char** argv) {
    
    std::string delim = ",";
    char sizefilename[20];
    strcpy(sizefilename, "size/size");
    strcat(sizefilename, argv[1]);
    strcat(sizefilename, ".txt");
    fstream size_file;
    size_file.open(sizefilename, ios::in);
    int* size = new int[2];
    if (!size_file) {
        cout << "No size file";
    }
    else {
        string sizeText;
        while (getline(size_file, sizeText)) {
            auto start = 0U;
            auto end = sizeText.find(delim);
            while (end != std::string::npos)
            {
                size[0] = stoi(sizeText.substr(start, end - start));
                start = end + delim.length();
                end = sizeText.find(delim, start);
            }
            size[1] = stoi(sizeText.substr(start, end));
        }
    }
    size_file.close();

    char imfilename[20];
    strcpy(imfilename, "output/out");
    strcat(imfilename, argv[1]);
    strcat(imfilename, ".txt");
    int nrow = size[0];
    int ncol = size[1];
    int* bin = new int[nrow*ncol];
    fstream binary_file;
    binary_file.open(imfilename, ios::in);
    if (!binary_file) {
        cout << "No binary file";
    }
    else {
        int rownum = 0;
        string binaryText;
        while (getline(binary_file, binaryText)) {
            int colnum = 0;
            auto start = 0U;
            auto end = binaryText.find(delim);
            while (end != std::string::npos) {
                bin[rownum * ncol + colnum] = stoi(binaryText.substr(start, end - start));
                start = end + delim.length();
                end = binaryText.find(delim, start);
                colnum += 1;
            }
            bin[rownum * ncol + colnum] = stoi(binaryText.substr(start, end));
            rownum += 1;
        }
    }

    int maxDistance = hypot(size[0], size[1]);
    cout << maxDistance << "\n";
    int nangle = 315;
    int* votes = new int[nangle * (2 * maxDistance + 1)];
    cout << nangle * (2 * maxDistance + 1) << endl;
    
    high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    start = high_resolution_clock::now();

    for (int i = 0; i < nrow*ncol; i++) {
        if (bin[i] == 0) {
            continue;
        }
        else {
            int y = i / ncol;
            int x = i % nrow;
            for (int j = 0; j < nangle; j++) {
                double theta = 0.01 * j;
                int rho = round((x * cos(theta - M_PI/2) + y * sin(theta - M_PI/2))) + maxDistance;
                int idx = rho * nangle + j;
                votes[idx]++;
            }
        }
    }

    end = high_resolution_clock::now();
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    cout << "time in ms:" << duration_sec.count() << endl;

    // output vote matrix to file


    return 0;
}