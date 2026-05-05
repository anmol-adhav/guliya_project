# guliya_project
Guliya Glacier Virome — Dark Proteome &amp; Novel Fold Discovery
# 🧊 Guliya Glacier Virome - Dark Proteome & Novel Fold Discovery

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.11](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/)
[![Conda](https://img.shields.io/badge/conda-supported-green.svg)](https://conda.io/)

## Overview

This repository contains a fully computational pipeline to:

1. **Call genes** from Guliya glacier vOTUs (viral Operational Taxonomic Units)
2. **Annotate** proteins using structure-informed phage annotation (Phold)
3. **Extract the dark fraction** — proteins with no known function
4. **Cluster** dark proteins to remove redundancy
5. **Predict 3D structures** using ESMFold
6. **Screen for novel folds** using Foldseek against PDB, AFDB50, and SCOP
7. **Validate** structural novelty using DALI and ECOD

> **Dataset**: 1,951 Guliya glacier vOTUs assembled from ancient ice core metagenomes  
> **Key result**: 55.1% of all predicted proteins (17,169 / 31,135) are functionally dark

---

## Pipeline Summary
Input: guliya_vOTUs.fasta (1,951 contigs)
↓
[Step 3] prodigal-gv gene calling → 31,135 proteins
↓
[Step 4] Phold structure-informed annotation
↓
[Step 5] Extract dark fraction → 17,169 dark proteins (55.1%)
↓
[Step 6] MMseqs2 clustering (90% identity) → 15,524 representative sequences
↓
[Step 7] Length filter (<= 1000 aa) → 15,437 ESMFold-ready proteins
↓
[Step 8] ESMFold structure prediction → 15,437 PDB files
↓
[Step 9] pLDDT quality filter (>= 60)
↓
[Step 10] Foldseek novel fold screening → Novel fold candidates
↓
[Step 11] DALI / ECOD structural validation
↓
[Step 12] DeepFRI functional inference

text

---

## Repository Structure
Guliya_project/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── .gitignore
├── envs/
│ ├── guliya.yml
│ ├── pholdENV.yml
│ └── defensefinder.yml
├── scripts/
│ ├── install_tools.sh
│ ├── step2_check_input.sh
│ ├── step3_prodigal.sh
│ ├── step4_phold.sh
│ ├── step5_extract_dark.py
│ ├── step6_cluster.sh
│ ├── step7_length_filter.py
│ ├── step8_run_esmfold.py
│ ├── step9_plddt_filter.py
│ └── step10_foldseek.sh
├── input/ # Place guliya_vOTUs.fasta here (not tracked by git)
├── gene_calls/ # prodigal-gv output
├── annotation/ # Phold output
├── structures/ # ESMFold predicted PDBs
├── novel_folds/ # Foldseek hits TM-score < 0.5
└── results/ # Final tables and summaries

text

---

## Quick Start

### 1. Clone and set up environments

```bash
git clone https://github.com/<your-username>/Guliya_project.git
cd Guliya_project
bash scripts/install_tools.sh
```

### 2. Place your input file

```bash
cp /path/to/guliya_vOTUs.fasta input/
```

### 3. Run the pipeline step by step

```bash
conda activate guliya

bash scripts/step2_check_input.sh
bash scripts/step3_prodigal.sh
bash scripts/step4_phold.sh
python scripts/step5_extract_dark.py
bash scripts/step6_cluster.sh
python scripts/step7_length_filter.py
python scripts/step8_run_esmfold.py   # Run on GPU cluster
python scripts/step9_plddt_filter.py
bash scripts/step10_foldseek.sh
```

---

## Key Results

| Metric | Value |
|--------|-------|
| Input vOTUs | 1,951 |
| Total proteins predicted | 31,135 |
| Annotated by Phold | 13,966 (44.9%) |
| Dark fraction | 17,169 (55.1%) |
| After 90% identity clustering | 15,524 |
| ESMFold-ready (≤ 1000 aa) | 15,437 |
| Skipped (> 1000 aa) | 87 |

---

## Tool Requirements

| Tool | Purpose |
|------|---------|
| prodigal-gv | Phage-aware gene calling |
| Phold | Structure-informed annotation |
| MMseqs2 ≥ 14 | Protein clustering |
| ESMFold (esm ≥ 2.0) | Structure prediction |
| Foldseek | Structural similarity search |
| Biopython ≥ 1.81 | Sequence I/O |
| pandas ≥ 2.0 | Data manipulation |

---

## Hardware Notes

- **Gene calling & clustering**: Runs on any machine (Mac, Linux)
- **Phold**: GPU-accelerated via Apple MPS on M-series Macs or CUDA on Linux
- **ESMFold**: Requires NVIDIA CUDA GPU (≥ 10GB VRAM) or HPC cluster with LocalColabFold

---

## Citation

If you use this pipeline, please cite:

- **Phold**: [Larralde et al., 2024](https://doi.org/10.1093/bioinformatics/btae417)
- **ESMFold**: [Lin et al., 2023, Science](https://doi.org/10.1126/science.ade2574)
- **Foldseek**: [van Kempen et al., 2024, Nature Biotechnology](https://doi.org/10.1038/s41587-023-01773-0)
- **MMseqs2**: [Steinegger & Söding, 2017, Nature Biotechnology](https://doi.org/10.1038/nbt.3988)
- **prodigal-gv**: [Camargo et al., 2023](https://doi.org/10.1038/s41592-023-01956-2)

---

## License

MIT — see [LICENSE](LICENSE) for details.
