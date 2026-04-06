import os
import shutil
from pathlib import Path
import pandas as pd

pdb_dir = Path("structures/esmfold_pdbs")
hq_dir  = Path("structures/hq_structures")
idp_dir = Path("structures/idp_candidates")
hq_dir.mkdir(parents=True, exist_ok=True)
idp_dir.mkdir(parents=True, exist_ok=True)

stats = []
for pdb_file in pdb_dir.glob("*.pdb"):
    scores = []
    with open(pdb_file) as f:
        for line in f:
            if line.startswith("ATOM"):
                try:
                    scores.append(float(line[60:66]))
                except ValueError:
                    pass
    if scores:
        mean_plddt = sum(scores) / len(scores)
        dest = hq_dir if mean_plddt >= 60 else idp_dir
        shutil.copy(pdb_file, dest / pdb_file.name)
        stats.append((pdb_file.stem, mean_plddt))

os.makedirs("results", exist_ok=True)
df = pd.DataFrame(stats, columns=["protein_id", "mean_plddt"])
df.to_csv("results/plddt_scores.csv", index=False)

print(f"HQ structures  (pLDDT >= 60): {len(list(hq_dir.glob('*.pdb')))}")
print(f"IDP candidates (pLDDT < 60) : {len(list(idp_dir.glob('*.pdb')))}")
print(f"pLDDT scores saved to: results/plddt_scores.csv")
