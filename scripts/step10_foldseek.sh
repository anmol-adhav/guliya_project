#!/bin/bash
source $(conda info --base)/etc/profile.d/conda.sh
conda activate pholdENV

mkdir -p foldseek_dbs results/foldseek_hits novel_folds

HQ_DIR="structures/hq_structures"
OUT_DIR="results/foldseek_hits"

echo "=== Downloading Foldseek databases (first run only) ==="
foldseek databases PDB                 foldseek_dbs/pdb    tmp --threads 10
foldseek databases Alphafold/UniProt50 foldseek_dbs/afdb50 tmp --threads 10
foldseek databases SCOP                foldseek_dbs/scop   tmp --threads 10

echo "=== Running Foldseek structural searches ==="
for DB in pdb afdb50 scop; do
    echo "Searching against $DB..."
    foldseek easy-search \
        $HQ_DIR \
        foldseek_dbs/$DB \
        $OUT_DIR/hits_${DB}.tsv \
        tmp \
        --format-output "query,target,alntmscore,evalue,prob" \
        --threads 10
done

echo "=== Identifying novel fold candidates (TM-score < 0.5 vs all DBs) ==="
python3 - << 'PYEOF'
import pandas as pd, shutil
from pathlib import Path

dbs = ["pdb", "afdb50", "scop"]
hits = {}
for db in dbs:
    df = pd.read_csv(f"results/foldseek_hits/hits_{db}.tsv", sep="\t",
                     names=["query","target","tmscore","evalue","prob"])
    hits[db] = df.groupby("query")["tmscore"].max()

all_queries = set()
for db in dbs:
    all_queries.update(hits[db].index)

novel = []
for q in all_queries:
    scores = [hits[db].get(q, 0.0) for db in dbs]
    if all(s < 0.5 for s in scores):
        novel.append({"protein_id": q,
                      **{f"best_tmscore_{db}": hits[db].get(q, 0.0) for db in dbs}})

df_novel = pd.DataFrame(novel)
df_novel.to_csv("results/novel_fold_candidates.csv", index=False)

novel_dir = Path("novel_folds")
for pid in df_novel["protein_id"]:
    src = Path(f"structures/hq_structures/{pid}.pdb")
    if src.exists():
        shutil.copy(src, novel_dir / src.name)

print(f"Novel fold candidates (TM-score < 0.5 vs all DBs): {len(df_novel)}")
print(f"PDB files in: novel_folds/")
print(f"Results table: results/novel_fold_candidates.csv")
PYEOF
