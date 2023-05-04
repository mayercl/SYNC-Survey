rm(list = ls())

library(readr)
library(mice)

#setwd("/Users/calebmayer/Dropbox (University of Michigan)/sync project/results_scripts")

# load the data 
daily_fatigue <- read.csv('Dropbox (University of Michigan)/sync project/results_scripts/daily_fatigue_matrix.csv', header = FALSE)
weekly_fatigue <- read.csv('Dropbox (University of Michigan)/sync project/results_scripts/weekly_fatigue_tscore_matrix.csv', header = FALSE)

# format the data 
daily_fatigue_df <- data.frame(daily_fatigue)
weekly_fatigue_df <- data.frame(weekly_fatigue)

# multiple imputation analysis 
miss_var_summary_daily <- mice::md.pattern(daily_fatigue_df)
miss_var_summary_weekly <- mice::md.pattern(weekly_fatigue_df)
imputed_daily_model <- mice(daily_fatigue_df, m = 5)
imputed_weekly_model <- mice(weekly_fatigue_df, m = 5)

# generate the imputted data 
imp_daily_list <- list()
imp_weekly_list <- list()
for (i in 1:5) {
  imp_daily_list[[i]] <- complete(imputed_daily_model, i)
  imp_weekly_list[[i]] <- complete(imputed_weekly_model, i)
  
  # save the data 
  write.csv(imp_daily_list[[i]], paste0("Dropbox (University of Michigan)/sync project/results_scripts/imputed_daily_dataset_", i, ".csv"), row.names = FALSE)
  write.csv(imp_weekly_list[[i]], paste0("Dropbox (University of Michigan)/sync project/results_scripts/imputed_weekly_dataset_", i, ".csv"), row.names = FALSE)
}


