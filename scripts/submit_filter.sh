#!/bin/bash -l
#SBATCH --partition=interruptible_cpu
#SBATCH --nodes=1
#SBATCH --time=00:15:00
#SBATCH --job-name=filter_rmats

module load R
Rscript filter_candidates.R
