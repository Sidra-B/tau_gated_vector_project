#!/bin/bash
#SBATCH --job-name=test_dl
#SBATCH --mem=2G
#SBATCH --time=02:00:00
#SBATCH --output=test_log_%j.out

cd "/scratch/prj/ppn_rnp_networks/users/sidra.bichay/hnRNPH1_IR_MAF"

echo "Starting test..."
echo "Current directory: $(pwd)"
echo "FLOW_USERNAME is set to: ${FLOW_USERNAME:-NOT SET}"

export FLOW_USERNAME="Sidra-B"
export FLOW_PASSWORD="Unstaffed77tapioca"

echo "About to run Python script..."
python3 --version
python3 download_bams.py 2>&1 | head -100
echo "Script finished"
EOF
chmod +x test_download.sh
sbatch test_download.sh
sleep 3
tail -100 test_log_*.out
