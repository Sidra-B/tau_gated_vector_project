# Splicing Statistics & Visualisations

rm(list = ls())

# 1. SETUP
DATA_DIR <- "~/Downloads/rmats_output" 
if (!dir.exists(DATA_DIR)) stop("Folder not found.")
setwd(DATA_DIR)

pkgs <- c("ggplot2", "dplyr", "tidyr", "ggrepel")
new_pkgs <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
if(length(new_pkgs)) install.packages(new_pkgs)
invisible(lapply(pkgs, library, character.only = TRUE))

FDR_CUT <- 0.05
PSI_CUT <- 0.1   

# 2. PROCESS DATA
load_events <- function(file, type) {
  if (!file.exists(file)) return(NULL)
  read.delim(file, stringsAsFactors = FALSE) %>%
    mutate(FDR = as.numeric(FDR), IncLevelDifference = as.numeric(IncLevelDifference)) %>%
    filter(!is.na(FDR) & !is.na(IncLevelDifference)) %>%
    mutate(
      EventType = type,
      Novelty = ifelse(geneSymbol == "" | grepl("novel", ID), "Novel", "Annotated"),
      IsSig = ifelse(FDR < FDR_CUT & abs(IncLevelDifference) >= PSI_CUT, "Significant", "Not Significant")
    )
}

all_events <- bind_rows(
  load_events("SE.MATS.JCEC.txt", "SE"),
  load_events("MXE.MATS.JCEC.txt", "MXE"),
  load_events("RI.MATS.JCEC.txt", "RI"),
  load_events("A3SS.MATS.JCEC.txt", "A3SS"),
  load_events("A5SS.MATS.JCEC.txt", "A5SS")
) %>% mutate(clean_FDR = ifelse(FDR == 0, 1e-10, FDR)) # Prevent log(0) errors

sig_events <- all_events %>% filter(IsSig == "Significant")

# 3. FIGURE 1: BAR CHART
if (nrow(sig_events) > 0) {
  fig1 <- sig_events %>% count(EventType, Novelty) %>%
    ggplot(aes(x = EventType, y = n, fill = Novelty)) +
    geom_col(width = 0.5) +
    theme_minimal(base_size = 12) +
    scale_fill_manual(values = c("Annotated" = "#2b5c8f", "Novel" = "#d95f02")) +
    labs(title = "Differentially Spliced Events", x = "Category", y = "Count")
  
  print(fig1)
  ggsave("~/tau_gated_splicing/Fig1_BarChart.png", plot = fig1, width = 8, height = 6)
}

# 4. FIGURE 2: VOLCANO PLOT
top10 <- all_events %>% filter(geneSymbol != "", !grepl("novel", ID), IsSig == "Significant") %>% arrange(FDR) %>% head(10)

fig2 <- ggplot(all_events, aes(x = IncLevelDifference, y = -log10(clean_FDR))) +
  geom_point(data = filter(all_events, IsSig == "Not Significant"), color = "grey85", alpha = 0.4, size = 0.8) +
  geom_point(data = sig_events, aes(color = EventType), alpha = 0.8, size = 1.6) +
  geom_text_repel(data = top10, aes(label = geneSymbol), size = 3.5, fontface = "bold", max.overlaps = 20) +
  geom_vline(xintercept = c(-PSI_CUT, PSI_CUT), linetype = "dashed", color = "darkgrey") +
  geom_hline(yintercept = -log10(FDR_CUT), linetype = "dashed", color = "darkgrey") +
  theme_classic(base_size = 12) +
  labs(title = "Volcano Plot of Alternative Splicing", x = "Inclusion Level Difference", y = "-log10(FDR)")

print(fig2)
ggsave("~/tau_gated_splicing/Fig2_VolcanoPlot.png", plot = fig2, width = 10, height = 7)