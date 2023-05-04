# SYNC-Survey
This repository contains scripts used to generate survey-focused results for the SYNC Lighting Intervention study. 

The main final is main_survey_paper.m, which serves to load and process the survey data and then perform the analyses of interest. 

The project is primarily in Matlab, except for the multiple imputation by chained equation (MICE) analyses in R and the generalized estimating equation (GEE) analysis in R. Code for these analyses can be found in the missing_data_imputation.R and gee_sync_weekly.R files, respectively. 
