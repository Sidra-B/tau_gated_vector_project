#!/bin/bash
#SBATCH --job-name=splice_nouveau
#SBATCH --output=logs/splice_nouveau_%j.out
#SBATCH --error=logs/splice_nouveau_%j.err
#SBATCH --time=24:00:00
#SBATCH --mem=16G
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1

# Activate Conda
eval "$(conda shell.bash hook)"
conda activate design_env
export CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)" 2>/dev/null))
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$CUDNN_PATH/lib:$LD_LIBRARY_PATH
export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib

# Path to the folder
cd /scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/software/SpliceNouveau

# Run the Software
python SpliceNouveau.py \
  --initial_cds "absent" \
  --initial_intron1 "absent" \
  --one_intron --ir --ce_start 300 --intron1_mut_chance 1.0 --target_const_donor 0.9 --target_const_acc 0.9 \
  --attempts 5 --n_iterations_per_attempt 2000 \
  --output ../../results/vectors/ \
  --seq "aattgtgccttgcagacacctcttatatggcaagcccttgattatggatagaaatgtgttaggtctctaagccccaggtggaataacgacaacccgcctagctccggtggggtagagcatgacgccctgaacaccacttagcatcctcagggttgcatctagcacctggccatacccctggagtcaggctggcgccagaccctttctgttctcctctgtggtctcacctatgctgttttctcttccctctctcatcctctctccctctctctctggccatcttgggtgctgtgtctgaagCTACTCCAACTGCAGgtattgtaccatcaacagaggtaatgggcatggctcggggcagtgcaaatggagcccatgctggccagagcccagcaagaggaagtggcgagggctgaaagcatgctccaggtcaccctttcagtggagaagccaaacttgaaaggaaggtgtttagagagcattgactagaggatgtgagcatgctctctcctttcatataatgcttgtccttacgaaagaggctggctcagaagtggtctcacatgtagaaccctctgaagctgagagaaaacctgttgtggccacctgagccttgct"