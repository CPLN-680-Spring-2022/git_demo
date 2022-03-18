
source("clean_data.R")
source("run_analysis.R")
source("generate_output.R")

RAW_DATA_FOLDER <- "../raw_data/"
TEMP_FOLDER <- "tmp"
OUTPUT_FOLDER <- "../outputs/"

output_file <- function(file) paste0(OUTPUT_FOLDER, file)

cleaned_data <- clean_and_save_data(RAW_DATA_FOLDER, out = OUTPUT_FOLDER)
results <- run_analysis(cleaned_data)
saveRDS(results, file=output_file("results.RDS"))
report <- generate_output(results)
saveRDS(report, file=output_file("report.pdf"))
