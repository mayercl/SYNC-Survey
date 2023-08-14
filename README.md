# SYNC-Survey
This repository contains scripts used to generate survey-focused results for the SYNC Lighting Intervention study. 

The main final is main_survey_paper.m, which serves to load and process the survey data and then perform the analyses of interest. However, note that the scripts are not currently fully functional (as access to the data is currently not provided here). 

The project is primarily in Matlab, except for the multiple imputation by chained equation (MICE) analyses in R and the generalized estimating equation (GEE) analysis in R. Code for these analyses can be found in the missing_data_imputation.R and gee_sync_weekly.R files, respectively. 

Detailed descriptions of the individual files contained in this repository are below.

Formatting files:

main_survey_paper: the main file that processes the data and generates the results. Does not perform every analysis (e.g., the GEE analyses in R are separate). 

read_survey_final: reads in, formats, and saves the daily, weekly, and pre/post surveys. This file reads in the raw json files for each survey type and outputs xls files consisting of all the daily/weekly/pre/post surveys for each individual. 

load_survey_final: this file assumes we have a previously constructed subject.mat (which can be initialized as subject = struct() and then save('subject')), and updates this file with the daily and weekly results. 

process_survey_final: 

aggregate_weekly_surveys_final: 

tscore_website_format: 

Analysis files:

weekly_survey_analysis:

daily_surveys_results_final:

pre_post_fatigue_analysis:

tscore_imputed_results_analyze:

gee_model_main: 

imputed_dataset_analysis:

demographics_weekly:


