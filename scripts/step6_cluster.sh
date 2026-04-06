#!/bin/bash
source $(conda info --base)/etc/profile.d/conda.sh
conda activate guliya

echo "=== Clustering dark proteins at 90% identity ==="
mmseqs easy-cluster \
    gene_calls/guliya_dark_proteins.faa \
    gene_calls/dark_cluster_90 \
    gene_calls/tmp_cluster \
    --min-seq-id 0.90 \
    -c 0.80 \
    --cov-mode 1 \
    --threads 10

echo "Clustering done. Representative sequences:"
grep -c ">" gene_calls/dark_cluster_90_rep_seq.fasta
