#!/bin/bash -l
#SBATCH --job-name=scatter_plot
#SBATCH --partition=interruptible_cpu
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --output=/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/logs/scatter_plot_%j.out
#SBATCH --error=/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/logs/scatter_plot_%j.err

echo "Setting up environment..."
source /scratch/prj/ppn_rnp_networks/users/sidra.bichay/software/Miniconda3/etc/profile.d/conda.sh
conda activate rmats_env 

echo "Running plotting script..."
python /scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/scripts/plot_human_overlap.py

echo "Finished!"