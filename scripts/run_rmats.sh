#!/bin/bash
#SBATCH --job-name=tau_gated_rmats
#SBATCH --partition=interruptible_cpu
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --output=rmats_tau_%j.out
#SBATCH --error=rmats_tau_%j.err

set -euo pipefail

# 1. Environment Setup
source /scratch/prj/ppn_rnp_networks/users/sidra.bichay/software/Miniconda3/etc/profile.d/conda.sh
conda activate rmats_env

# 2. Path to repository
cd /scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project

# 3. Ensure directories exist 
mkdir -p rmats_output rmats_tmp

echo "Starting rMATS analysis for Tau S305N Gated Vector Design (Fresh Overwrite)..."
echo "Job ID: ${SLURM_JOB_ID}"
echo "Start time: $(date)"

# 4. Run rMATS with Ensembl GTF
rmats.py \
  --b1 b1_sorted.txt \
  --b2 b2_sorted.txt \
  --gtf Mus_musculus.GRCm39.110.gtf \
  --od rmats_output \
  --tmp rmats_tmp \
  --task both \
  -t paired \
  --libType fr-unstranded \
  --readLength 100 \
  --nthread "${SLURM_CPUS_PER_TASK}" \
  --tstat "${SLURM_CPUS_PER_TASK}" \
  --allow-clipping \
  --variable-read-length

echo "rMATS analysis complete!"
echo "End time: $(date)"
ls -lh rmats_output/