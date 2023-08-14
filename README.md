# SYNC-Survey
This repository contains scripts used to generate survey-focused results for the SYNC Lighting Intervention study. 

The main final is main_survey_paper.m, which serves to load and process the survey data and then perform the analyses of interest. However, note that the scripts are not currently fully functional (as access to the data is currently not provided here). 

The project is primarily in Matlab, except for the multiple imputation by chained equation (MICE) analyses in R and the generalized estimating equation (GEE) analysis in R. Code for these analyses can be found in the missing_data_imputation.R and gee_sync_weekly.R files, respectively. 

Detailed descriptions of the individual files contained in this repository are below.

Formatting files

main_survey_paper: the main file that processes the data and generates the results. Does not perform every analysis (e.g., the GEE analyses in R are separate). 

read_survey_final: reads in, formats, and saves the daily, weekly, and pre/post surveys. This file reads in the raw json files for each survey type and outputs xls files consisting of all the daily/weekly/pre/post surveys for each individual. 

load_survey_final: this file assumes we have a previously constructed subject.mat (which can be initialized as subject = struct() and then save('subject')), and updates this file with the daily and weekly results. This simply loads the files stored by read_survey_final, and does not process duplicates or shifts in terms of survey submission time. 

process_survey_final: this file loads the previously updated subject.mat file, and processes the survey results by accounting for missing data and duplicates. It also converts the daily and weekly text responses to numerical values, and stores the results in fields of subject.mat. 

aggregate_weekly_surveys_final: this file is not directly involved in all of the processing, but is used to generate an aggregate weekly survey final that contains additional information than the weekly fatigue scores (e.g., free-response information). 

subject_pre_post_generate: this file reads in pre and post surveys from the 'surveys_formatted_v2' folder (after running read_survey_final), and formats them into a subject_pre_post structure that contains the subject name and corresponding pre and post survey responses for that given individual. 

tscore_website_format: this file loads subject_pre_post, and then formats the pre/post global health, sleep disturbance, anxiety, depression, and physical function from text responses into numerical values. This file requires the compute_score_xxx (e.g., compute_score_vp_p_f_g_vg) files in order to properly convert the text responses to numbers. After this conversion, the pre/post responses are formatted in the proper manner for the HealthMeasures website and then saved as the subject_all_num.csv file.  

Analysis files

weekly_survey_analysis: this file analyses the non-imputed (raw) weekly survey data, as stored by the aggregate_weekly_surveys_final file. It again converts the weekly text responses to tscores, and then analyses these for the intervention and control groups. This file is currently not used for the analysis reported in the manuscript. 

daily_surveys_results_final: 

pre_post_fatigue_analysis:

tscore_imputed_results_analyze:

gee_model_main: 

imputed_dataset_analysis:

demographics_weekly:

R files 


