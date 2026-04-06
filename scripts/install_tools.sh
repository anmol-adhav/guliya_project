#!/bin/bash
set -e
echo "=== Installing Guliya Project environments ==="

mamba create -n guliya python=3.11 -y
conda run -n guliya mamba install -c bioconda -c conda-forge \
    prodigal-gv mmseqs2 seqkit biopython pandas numpy -y

mamba create -n pholdENV python=3.10 -y
conda run -n pholdENV mamba install -c bioconda -c conda-forge foldseek -y
conda run -n pholdENV pip install phold
conda run -n pholdENV phold install

mamba create -n defensefinder python=3.11 -y
conda run -n defensefinder pip install mdmparis-defense-finder
conda run -n defensefinder defense-finder update

echo "=== All tools installed successfully ==="
