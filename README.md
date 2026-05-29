Tau Gated Vector Project

Objective: Design auto-gated gene therapy vectors that trigger therapeutic expression only in neurons with tau pathology.

Strategy
- Mechanism: Use tau-induced cryptic splicing as a biological "ON" switch.
- Payload: Expresses TRIM21-based degraders to clear tau aggregates while sparing healthy monomers (Wilkins et al., 2024; Benn et al., 2024).
- Reporter: Initial prototyping utilises an EGFP reporter to validate the splicing mechanism visually.

Pipeline
1. rMATS: Analyse P301S mouse neuron RNA-Seq (Control vs. Tau-seeded).
2. Filter: Identify high-confidence cryptic exons (Delta PSI > 0.1, FDR < 0.05, Skipped Exon events).
3. Motif Analysis: Analyse sequence features using STREME to identify RNA Binding Protein (RBP) constraints.
4. Design: Use Splice Nouveau to digitally evolve functional, auto-gated introns without breaking the reading frame.

Current Status
- rMATS: Completed (183M reads processed; 19,884 potential SE events detected, 1,114 statistically analysable).
- Filtering: Completed (Filtered down to 3 top candidate genes. Prioritized 2610035D17Rik).
- Motif Analysis: Completed (STREME identified highly conserved T-rich consensus CCTTTCCTTTA linked to Tia1).
- AI Design: In Progress. (100-iteration test successful; improved SpliceAI score from 0.05 to 0.18. Currently running a scaled 5x2000 iteration production run).