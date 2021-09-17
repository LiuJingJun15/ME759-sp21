#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -J jliu798projtest
#SBATCH -o hough.out -e hough.err
#SBATCH --nodes=1 --cpus-per-task=4

g++ hough.cpp -Wall -O3 -std=c++17 -o hough -fopenmp

for i in {1..6}
do
	./hough "$i"
done