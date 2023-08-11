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
daily_surveys_results_final;

% analyze pre/post fatigue
pre_post_fatigue_analysis;

% analyze the pre/post data 
tscore_imputed_results_analyze;

% set up the data for gee analysis  
gee_model_main;

% analyze imputed datasets
imputed_dataset_analysis;

% portion of demographics table
demographics_weekly;

%% supplemental information 
% missingness
missing_data_checks;

weekly_daily_survey_analysis_supplement;

% basic wearable metrics--daily avg steps, hr 
basic_wearables_analysis; 

% time of day and daily surveys 
surveys_time_of_day;

% analyze the pre/post data 
tscore_results_analyze;

% weekly vs daily surveys 
daily_weekly_fatigue_comp;
