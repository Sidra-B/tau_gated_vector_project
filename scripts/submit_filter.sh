#!/bin/bash -l
#SBATCH --job-name=filter_targets
#SBATCH --partition=interruptible_cpu
#SBATCH --mem=8G
#SBATCH --time=00:10:00
#SBATCH --output=/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/logs/filter_%j.out
#SBATCH --error=/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/logs/filter_%j.err

echo "Setting up environment..."
source /scratch/prj/ppn_rnp_networks/users/sidra.bichay/software/Miniconda3/etc/profile.d/conda.sh
conda activate rmats_env 

echo "Running the filtering and sorting script..."
# Updated to your exact file name: filter_relaxed_bed.py
python /scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/scripts/filter_relaxed_bed.py

echo "Complete"