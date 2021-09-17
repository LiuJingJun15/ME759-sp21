#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -J jliu798projtest
#SBATCH -o hough_cpu.out -e hough_cpu.err

g++ hough_cpu.cpp -Wall -O3 -std=c++17 -o hough_cpu -fopenmp

for i in {1..6}
do
	./hough_cpu "$i"
done