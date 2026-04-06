#!/bin/bash
source $(conda info --base)/etc/profile.d/conda.sh
conda activate guliya

mkdir -p gene_calls

echo "=== Running prodigal-gv gene calling ==="
prodigal-gv \
    -i input/guliya_vOTUs.fasta \
    -a gene_calls/guliya_proteins.faa \
    -d gene_calls/guliya_genes.fna \
    -f gff \
    -o gene_calls/guliya_genes.gff \
    -p meta \
    -q

echo "Gene calling done. Proteins predicted:"
grep -c ">" gene_calls/guliya_proteins.faa
