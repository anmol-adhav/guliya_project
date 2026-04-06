import esm
import torch
import os
from Bio import SeqIO

os.makedirs("structures/esmfold_pdbs", exist_ok=True)
os.makedirs("logs", exist_ok=True)

model = esm.pretrained.esmfold_v1().eval()
if torch.cuda.is_available():
    model = model.cuda()
    print("Using CUDA GPU")
else:
    print("Using CPU (slow — consider running on HPC)")

records = list(SeqIO.parse("gene_calls/esm_input.faa", "fasta"))
print(f"Predicting structures for {len(records)} proteins...")

for i, rec in enumerate(records):
    out_path = f"structures/esmfold_pdbs/{rec.id}.pdb"
    if os.path.exists(out_path):
        continue  # resume support

    with torch.no_grad():
        pdb_str = model.infer_pdb(str(rec.seq))

    with open(out_path, "w") as f:
        f.write(pdb_str)

    if (i + 1) % 100 == 0:
        print(f"  Progress: {i+1}/{len(records)}")

print("ESMFold complete. PDB files saved to: structures/esmfold_pdbs/")
