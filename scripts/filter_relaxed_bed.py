import pandas as pd
import numpy as np

# PARAMETERS
INPUT_RMATS = "results/rmats/rmats_output/SE.MATS.JC.txt"
OUT_CSV     = "results/Filtered_SE_Targets.csv"
OUT_BED     = "results/target_regions.bed"

FDR_TH      = 0.05    # Statistical significance threshold
DPSI_TH     = 0.10    # 10% Splicing shift threshold (Absolute value)
WT_PSI_TH   = 0.30    # 30% Maximum allowed background inclusion in healthy cells
COV_TH      = 5       # Minimum read coverage per replicate

# PARSER HELPER FUNCTIONS
def parse_wt_psi(val):
    """Calculates the mean of comma-separated WT PSI values, skipping 'NA'."""
    vals = [float(x) for x in str(val).split(',') if x.strip() not in ('NA', '')] if pd.notna(val) else []
    return np.mean(vals) if vals else np.nan

def parse_min_cov(row):
    """Calculates the minimum combined coverage (IJC + SJC) across WT replicates."""
    if pd.isna(row['IJC_SAMPLE_1']) or pd.isna(row['SJC_SAMPLE_1']): return 0
    ijc = [float(x) for x in str(row['IJC_SAMPLE_1']).split(',') if x.strip() not in ('NA', '')]
    sjc = [float(x) for x in str(row['SJC_SAMPLE_1']).split(',') if x.strip() not in ('NA', '')]
    return min([i + s for i, s in zip(ijc, sjc)]) if (ijc and len(ijc) == len(sjc)) else 0

# MAIN PIPELINE EXECUTION
if __name__ == "__main__":
    print(f"Loading rMATS data from: {INPUT_RMATS}...")
    df = pd.read_csv(INPUT_RMATS, sep='\t')
    
    # Standardise and drop core rows missing vital rMATS statistics
    df['FDR'] = pd.to_numeric(df['FDR'], errors='coerce')
    df['IncLevelDifference'] = pd.to_numeric(df['IncLevelDifference'], errors='coerce')
    df = df.dropna(subset=['FDR', 'IncLevelDifference'])

    # Compute advanced gating metrics
    df['WT_PSI_Avg'] = df['IncLevel1'].apply(parse_wt_psi)
    df['Min_Coverage'] = df.apply(parse_min_cov, axis=1)

    # Filter dataset using the parameters defined at the top
    filtered = df[
        (df['FDR'] < FDR_TH) & 
        (df['IncLevelDifference'].abs() >= DPSI_TH) & 
        (df['WT_PSI_Avg'] <= WT_PSI_TH) & 
        (df['Min_Coverage'] >= COV_TH)
    ].sort_values(by='FDR')

    # Export 1: Detailed CSV Report
    filtered.to_csv(OUT_CSV, index=False)
    
    # Export 2: Standard Genomic BED File (Select and reorder columns directly)
    bed_cols = ['chr', 'exonStart_0base', 'exonEnd', 'geneSymbol', 'IncLevelDifference', 'strand']
    filtered[bed_cols].to_csv(OUT_BED, sep='\t', header=False, index=False)

    print(f"\n FILTERING COMPLETE | Found {len(filtered)} events across {filtered['geneSymbol'].nunique()} unique candidate genes.")
    print(f"Saved CSV: {OUT_CSV}\n Saved BED: {OUT_BED}")