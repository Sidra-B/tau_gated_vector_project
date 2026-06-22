#!/bin/bash -l
#SBATCH --job-name=merge_bams
#SBATCH --partition=interruptible_cpu
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/logs/merge_%j.out
#SBATCH --error=/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/logs/merge_%j.err

source /scratch/prj/ppn_rnp_networks/users/sidra.bichay/software/Miniconda3/etc/profile.d/conda.sh
conda activate rmats_env 

# Path
cd /scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/data/raw

samtools merge -f merged_Control.bam C1.sorted.bam C2.sorted.bam C3.sorted.bam C4.sorted.bam C5.sorted.bam C6.sorted.bam
samtools index merged_Control.bam

samtools merge -f merged_Tau.bam T1.sorted.bam T2.sorted.bam T3.sorted.bam T4.sorted.bam T5.sorted.bam T6.sorted.bam
samtools index merged_Tau.bam

echo "Done"