from Bio import SeqIO

short, long_seqs = [], []
for rec in SeqIO.parse("gene_calls/dark_cluster_90_rep_seq.fasta", "fasta"):
    (long_seqs if len(rec.seq) > 1000 else short).append(rec)

SeqIO.write(short,     "gene_calls/esm_input.faa",     "fasta")
SeqIO.write(long_seqs, "gene_calls/long_proteins.faa", "fasta")

print(f"ESMFold input  (<= 1000aa): {len(short)}")
print(f"Skipped        (> 1000aa) : {len(long_seqs)}")
print(f"Total                     : {len(short) + len(long_seqs)}")
