#!/bin/bash
#SBATCH --job-name=tau_dl
#SBATCH --mem=4G
#SBATCH --time=04:00:00
#SBATCH --output=download_tau_%j.out
#SBATCH --error=download_tau_%j.err

# Project pathway
cd "/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project"

echo "Starting download script..."
echo "Current directory: $(pwd)"

# Explicitly pass authentication keys
export FLOW_USERNAME="Sidra-B"
export FLOW_PASSWORD="Unstaffed77tapioca"

# Force clear out old files for updated data
rm -rf bam_files
mkdir -p bam_files

echo "Executing Python file download layout..."
python3 download_bams.py

echo "Job process sequence finished."