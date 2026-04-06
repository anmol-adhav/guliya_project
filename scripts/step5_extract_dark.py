from Bio import SeqIO
import pandas as pd

phold = pd.read_csv("annotation/phold_output/phold_annotations.tsv", sep="\t")

dark_mask = (
    phold["product"].isin(["hypothetical protein", "unknown function", ""]) |
    phold["product"].isna()
)
dark_ids  = set(phold[dark_mask]["protein_id"])
known_ids = set(phold[~dark_mask]["protein_id"])

all_proteins = {r.id: r for r in SeqIO.parse("gene_calls/guliya_proteins.faa", "fasta")}

dark_seqs  = [all_proteins[i] for i in dark_ids  if i in all_proteins]
known_seqs = [all_proteins[i] for i in known_ids if i in all_proteins]

SeqIO.write(dark_seqs,  "gene_calls/guliya_dark_proteins.faa",  "fasta")
SeqIO.write(known_seqs, "gene_calls/guliya_known_proteins.faa", "fasta")

total = len(all_proteins)
print(f"Total proteins : {total}")
print(f"Annotated      : {len(known_seqs)} ({100*len(known_seqs)/total:.1f}%)")
print(f"Dark fraction  : {len(dark_seqs)} ({100*len(dark_seqs)/total:.1f}%)")
