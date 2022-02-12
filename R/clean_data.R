
library(readr)
library(dplyr)
library(tidyr)

RAW_DATA_FOLDER <- "C:/Users/Jonathan Tannen/Dropbox/Documents/courses/git_demo/raw_data/"
CLEANED_DATA_FOLDER <- "C:/Users/Jonathan Tannen/Dropbox/Documents/courses/git_demo/data/"


clean_raw_data <- function(file){
  df <- read_csv(file)
  
  df$warddiv <- paste0(sprintf("%02d", df$WARD), "-", sprintf("%02d", df$DIVISION))
  df$type <- case_when(
    df$TYPE == "A" ~ "Mail",
    df$TYPE == "M" ~ "In-Person",
    df$TYPE == "P" ~ "Provisional"
  )
  
  df <- df %>% select(warddiv, OFFICE, CANDIDATE, type, PARTY, VOTES)
  names(df) <- tolower(names(df))
  return(df)
}

clean_raw_data_2020 <- function(file){
  warning("2020 does not have party info, party will be dropped.")
  df <- read_csv(file)
  
  df <- df %>% pivot_longer(
    names_to="office_candidate", values_to="votes",
    cols = `PRESIDENT AND VICE-PRESIDENT OF THE UNITED STATES\nJOSEPH R BIDEN AND KAMALA D HARRIS`:`QUESTION #4\nNO`
  )
  
  df$office <- gsub("(.*)\\n(.*)", "\\1", df$office_candidate)
  df$candidate <- gsub("(.*)\\n(.*)", "\\2", df$office_candidate)
  df$warddiv <- df$DIV
  
  df$type <- case_when(
    df$TYPE == "E" ~ "In-Person",
    df$TYPE == "M" ~ "Mail",
    df$TYPE == "P" ~ "Provisional"
  )
  
  df <- df %>% select(warddiv, office, candidate, type, votes)
  return(df)
}

clean_and_save_raw_data <- function(){
  all_files <- list.files(RAW_DATA_FOLDER, pattern = ".*\\.csv", full.names = T)
  res <- list()
  for(f in all_files){
    year <- gsub(".*/([0-9]+)_[a-z]+.csv", "\\1", f)
    election_type <- gsub(".*/[0-9]+_([a-z]+).csv", "\\1", f)
    if(year == "2020"){
      res[[f]] <- clean_raw_data_2020(f)
    } else{
      res[[f]] <- clean_raw_data(f)
    }
    res[[f]]$year <- year
    res[[f]]$election_type <- election_type
  }
  
  res <- bind_rows(res)
  
  saveRDS(res, file = paste0(CLEANED_DATA_FOLDER, "res.RDS"))
}

if(FALSE){
  clean_and_save_raw_data()
}
