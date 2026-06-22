#!/bin/bash

# Loops through formatted FASTA file and submit a job for each sequence
while read -r line; do
    if [[ $line == ">"* ]]; then
        header=$line
    else
        # Submit the job using the sequence found
        sbatch <<EOT
#!/bin/bash
#SBATCH --job-name=splice_nouveau_batch
#SBATCH --output=logs/splice_nouveau_%j.out
#SBATCH --error=logs/splice_nouveau_%j.err
#SBATCH --time=24:00:00
#SBATCH --mem=16G
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1

eval "\$(conda shell.bash hook)"
conda activate design_env
cd /scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/software/SpliceNouveau

python SpliceNouveau.py \\
  --one_intron --ir --ce_start 300 --intron1_mut_chance 1.0 --target_const_donor 0.9 --target_const_acc 0.9 \\
  --attempts 5 --n_iterations_per_attempt 2000 \\
  --output ../../results/vectors/ \\
  --seq "$line"
EOT
    fi
done < results/formatted_for_ai.fa