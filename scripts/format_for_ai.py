INPUT_FASTA = "results/top20_expanded_sequences.fa"
OUTPUT_FASTA = "results/formatted_for_ai.fa"
PADDING = 300

print(f"Formatting sequences from {INPUT_FASTA}...")

with open(INPUT_FASTA, 'r') as f_in, open(OUTPUT_FASTA, 'w') as f_out:
    # Read the entire file and split into individual FASTA blocks
    fasta_blocks = f_in.read().split(">")[1:] 
    
    for block in fasta_blocks:
        lines = block.strip().split('\n')
        header = ">" + lines[0]
        seq = "".join(lines[1:])
        
        if len(seq) > PADDING * 2:
            # Format: lowercase for intronic padding, capitalised for the central exon
            formatted_seq = seq[:PADDING].lower() + seq[PADDING:-PADDING].upper() + seq[-PADDING:].lower()
            f_out.write(f"{header}\n{formatted_seq}\n")
        else:
            print(f"Warning: {header} is too short and was skipped.")

print(f"Formatting complete. Sequences have been saved to {OUTPUT_FASTA}.")