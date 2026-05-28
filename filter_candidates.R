library(data.table)

# Load rMATS data
se_data <- fread("rmats_output/SE.MATS.JC.txt")

# Calculate metrics
se_data$WT_PSI_Avg <- sapply(strsplit(as.character(se_data$IncLevel1), ","), function(x) mean(as.numeric(x), na.rm = TRUE)) 

se_data$Min_Coverage <- sapply(1:nrow(se_data), function(i) {
  ijc <- as.numeric(strsplit(as.character(se_data$IJC_SAMPLE_1[i]), ",")[[1]])
  sjc <- as.numeric(strsplit(as.character(se_data$SJC_SAMPLE_1[i]), ",")[[1]])
  min(ijc + sjc, na.rm = TRUE)
})

# Apply thresholds
filtered_candidates <- subset(se_data, 
                              FDR < 0.05 & 
                              WT_PSI_Avg < 0.2 & 
                              IncLevelDifference > 0.1 & 
                              Min_Coverage > 15)

# Export final state
filtered_candidates <- filtered_candidates[order(filtered_candidates$FDR), ]
write.csv(filtered_candidates, "Filtered_SE_Targets.csv", row.names = FALSE)
