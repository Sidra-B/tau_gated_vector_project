import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load unfiltered Tau mouse JC data
print("Loading Mouse Tau rMATS data...")
mouse_path = "/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/results/rmats/rmats_output/SE.MATS.JC.txt"
tau_df = pd.read_csv(mouse_path, sep="\t")

# Keep necessary columns
tau_df = tau_df[['geneSymbol', 'IncLevelDifference', 'FDR']].dropna(subset=['IncLevelDifference'])
tau_df = tau_df.rename(columns={'IncLevelDifference': 'dPSI_TauMouse'})

# Convert mouse gene symbols to UPPERCASE
tau_df['geneSymbol'] = tau_df['geneSymbol'].astype(str).str.upper()

# Load Human AD dataset (Llewelyn's Data)
print("Loading Human AD data...")
human_path = "/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/data/SE.MATS.JCEC_WT_d28_vs_S305N_het_d28.txt"
human_df = pd.read_csv(human_path, sep="\t") 

# Keep necessary rMATS columns and rename
human_df = human_df[['geneSymbol', 'IncLevelDifference']].dropna(subset=['IncLevelDifference'])
human_df = human_df.rename(columns={'IncLevelDifference': 'dPSI_Human'})
human_df['GeneSymbol'] = human_df['geneSymbol'].astype(str).str.upper()

# Merge the datasets
print("Merging datasets...")
merged_df = pd.merge(tau_df, human_df, left_on='geneSymbol', right_on='GeneSymbol', how='inner')

# Plotting the Scatter Graph
print(f"Plotting {len(merged_df)} overlapping events...")
plt.figure(figsize=(10, 8))

# Plot the scatter
scatter = sns.scatterplot(
    data=merged_df, 
    x='dPSI_TauMouse', 
    y='dPSI_Human', 
    alpha=0.6, 
    edgecolor=None,
    hue='FDR',
    palette='viridis_r' 
)

# Add crosshairs at 0,0
plt.axhline(0, color='black', linestyle='--', linewidth=1)
plt.axvline(0, color='black', linestyle='--', linewidth=1)

# Format
plt.xlabel("Tau Mouse dPSI (Unfiltered)", fontsize=12, fontweight='bold')
plt.ylabel("Human AD dPSI (Unfiltered)", fontsize=12, fontweight='bold')
plt.title("Splicing Overlap: Mouse Tauopathy vs. Human AD", fontsize=14, fontweight='bold')
plt.grid(True, alpha=0.3)

# Save the plot
output_file = "/scratch/prj/ppn_rnp_networks/users/sidra.bichay/tau_gated_vector_project/results/overlap_plots/Mouse_vs_Human_Scatter.png"
plt.savefig(output_file, dpi=300, bbox_inches='tight')
print(f"Success! Plot saved to {output_file}")