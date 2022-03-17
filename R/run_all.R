
source("clean_data.R")
source("run_analysis.R")
source("generate_output.R")

RAW_DATA_FOLDER <- "../raw_data/"
TEMP_FOLDER <- "tmp"
OUTPUT_FOLDER <- "../outputs/"

cleaned_data <- clean_and_save_data(RAW_DATA_FOLDER, out = OUTPUT_FOLDER)
results <- run_analysis(cleaned_data)
report <- generate_output(results)
saveRDS(report, file=paste0(OUTPUT_FOLDER, "report.pdf"))
