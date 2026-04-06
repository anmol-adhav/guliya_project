#!/bin/bash
source $(conda info --base)/etc/profile.d/conda.sh
conda activate pholdENV

mkdir -p annotation logs

echo "=== Running Phold structure-informed annotation ==="
phold run \
    -i input/guliya_vOTUs.fasta \
    -o annotation/phold_output \
    --threads 10 \
    --cpu   # Replace with --gpu if CUDA GPU is available

echo "Phold annotation complete."
