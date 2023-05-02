clear; clc;
close all;

%% load the data
%read_survey_final; % read the surveys into survey_formatted_v2
load_survey_final; % load the survey data 

% process the survey data
process_survey_final;

% aggregate the weekly surveys 
aggregate_weekly_surveys_final;

% format the pre/post surveys 
tscore_website_format; % then use website

%% analyze the data 
% analyze the weekly data 
weekly_survey_analysis;

% analyze the daily data 
daily_surveys_results

% analyze the pre/post data 
tscore_results_analyze;

% set up the data for gee analysis  
gee_model_main;

% aalyze imputed datasets
imputed_dataset_analysis;
