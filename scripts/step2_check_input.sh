#!/bin/bash
source $(conda info --base)/etc/profile.d/conda.sh
conda activate guliya

echo "=== Input file statistics ==="
seqkit stats input/guliya_vOTUs.fasta -a
