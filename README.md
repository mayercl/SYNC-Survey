# SYNC-Survey
This repository contains scripts used to generate survey-focused results for the SYNC Lighting Intervention study. 

The main final is main_survey_paper.m, which serves to load and process the survey data and then perform the analyses of interest. However, note that the scripts are not currently fully functional (as access to the data is currently not provided here). 

The project is primarily in Matlab, except for the multiple imputation by chained equation (MICE) analyses in R and the generalized estimating equation (GEE) analysis in R. Code for these analyses can be found in the missing_data_imputation.R and gee_sync_weekly.R files, respectively. 

While I've started cleaning these files, some still need more work and clarity before publication. I'll do that and update this document with a more detailed description of all the files when possible. 
