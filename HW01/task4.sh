#!/usr/bin/env bash
#SBATCH -J FirstSlurm
#SBATCH -p wacc
#SBATCH -c 2
#SBATCH -o FirstSlurm.out -e FirstSlurm.err

cd $SLURM_SUBMIT_DIR

hostname
