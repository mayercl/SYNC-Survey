rm(list = ls())

library(readr)
library(gee)

# load the data 
iteration <- 1
imputed_daily_fatigue <- read.csv(paste0('Dropbox (University of Michigan)/sync project/results_scripts/imputed_daily_dataset_', iteration, '.csv'), header = TRUE)
imputed_weekly_fatigue <- read.csv(paste0('Dropbox (University of Michigan)/sync project/results_scripts/imputed_weekly_dataset_', iteration, '.csv'), header = TRUE)

# format the data 
final_fatigue <- imputed_weekly_fatigue[, ncol(imputed_weekly_fatigue)]
predictor_df <- imputed_weekly_fatigue[, -ncol(imputed_weekly_fatigue)]
response = final_fatigue
number_subjects <- nrow(imputed_weekly_fatigue)
id = seq(1, number_subjects)

# read in demographic and other data 
#folderpath <- 'S:\Peds_Shared\Shared\Sungchoi\Caleb\'
demographic_info <- read.csv('\Peds_Shared\Shared\Sungchoi\Caleb\SYNC_Demographics_RAWDATA.csv', header = TRUE)

# apply gee 
gee_model <- gee(response ~ ., id = id, data = predictor_df, corstr = "exchangeable", family = "gaussian")
summary(gee_model)