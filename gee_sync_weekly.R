rm(list = ls())

library(readr)
library(gee)
library(magrittr)
library(dplyr)

# load the data 
iteration <- 1 # choose the imputed dataset of interest
imputed_weekly_fatigue <- read.csv(paste0('C:\\Users\\mayercl\\Dropbox (University of Michigan)\\sync project\\results_scripts\\imputed_weekly_dataset_', iteration, '.csv'), header = TRUE)
subject_ids <- read.csv('C:\\Users\\mayercl\\Dropbox (University of Michigan)\\sync project\\results_scripts\\subject_all_patient_ids.csv', header = FALSE) 
pre_post_fatigue <- read.csv('C:\\Users\\mayercl\\Dropbox (University of Michigan)\\sync project\\results_scripts\\pre_post_fatigue.csv', header = FALSE)

weekly_fatigue_df <- imputed_weekly_fatigue
weekly_fatigue_df$sync_study_id <- subject_ids[['V1']]
weekly_fatigue_df$treatment <- subject_ids[['V2']]
weekly_fatigue_df$pre_fatigue <- pre_post_fatigue[['V1']]

# read in demographic data and merge  
demographic_info <- read.csv('SYNC_Demographics_RAWDATA.csv', header = TRUE)
combined_df_all <- merge(weekly_fatigue_df, demographic_info, by = 'sync_study_id')

# format the data: each row is a unique subject/time combination 
num_subjects <- nrow(combined_df_all)
num_weeks <- 11
fatigue_all_weeks = c(combined_df_all[['V1']], combined_df_all[['V2']],combined_df_all[['V3']], combined_df_all[['V4']],combined_df_all[['V5']], combined_df_all[['V6']],combined_df_all[['V7']], combined_df_all[['V8']],combined_df_all[['V9']], combined_df_all[['V10']],combined_df_all[['V11']])
id <- seq(1, num_subjects)
id_all <- rep(id, num_weeks)
treatment_all <- rep(combined_df_all[['treatment']],num_weeks) # repeat values for each week
age_all <- rep(combined_df_all[['pt_age_enroll']],num_weeks)
gender_all <- rep(combined_df_all[['pt_gender']],num_weeks)
pre_fatigue_all <- rep(combined_df_all[['pre_fatigue']],num_weeks)

time_all <- c()
for(i in 1:num_weeks){
  time_all <- c(time_all, rep(i, num_subjects))
}

# create predictor dataframe, that uses all time point
predictor_df <- data.frame(id_all)
predictor_df$time <- time_all  
predictor_df$weekly_fatigue <- fatigue_all_weeks
predictor_df$treatment <- treatment_all
predictor_df$age <- age_all
predictor_df$gender <- gender_all
predictor_df$pre_fatigue <- pre_fatigue_all

# mean center the data, for non-categorical variables 
predictor_df_centered <- predictor_df %>% 
  mutate(age = age - mean(age), weekly_fatigue = weekly_fatigue - mean(weekly_fatigue), pre_fatigue = pre_fatigue - mean(pre_fatigue))

response <- predictor_df_centered[['weekly_fatigue']]

# apply gee, with main and interaction effects  
gee_model1 <- gee(response ~ treatment + age + gender + pre_fatigue + time  + treatment*age*gender*pre_fatigue*time, id = id_all, data = predictor_df_centered, corstr = "exchangeable", family = "gaussian")
summary(gee_model1)

# further interpret results
coefs <- coef(summary(gee_model1))
pvals <-  2 * pnorm(abs(coefs[,5]), lower.tail = FALSE)
pvals