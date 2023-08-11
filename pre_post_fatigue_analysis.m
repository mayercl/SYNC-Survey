clear; clc;
close all;

% load the data, from gee_model_main
pre_post_results = readmatrix('pre_post_fatigue.csv');
subject_ids = readtable('subject_all_patient_ids.csv');


%% analyse the pre and post data 
complete_inds = find(sum(~isnan(pre_post_results)') == 2);
pre_post_complete = pre_post_results(complete_inds,:);
subject_ids_complete = subject_ids(complete_inds,:);

% determine the stats
mean_pre_int = mean(pre_post_complete(subject_ids_complete.Var2 == 1,1));
mean_post_int = mean(pre_post_complete(subject_ids_complete.Var2 == 1,2));
sd_pre_int = std(pre_post_complete(subject_ids_complete.Var2 == 1,1));
sd_post_int = std(pre_post_complete(subject_ids_complete.Var2 == 1,2));

mean_pre_con = mean(pre_post_complete(subject_ids_complete.Var2 == 0,1));
mean_post_con = mean(pre_post_complete(subject_ids_complete.Var2 == 0,2));
sd_pre_con = std(pre_post_complete(subject_ids_complete.Var2 == 0,1));
sd_post_con = std(pre_post_complete(subject_ids_complete.Var2 == 0,2));

% significance testing
[h_start, p_start] = ttest2(pre_post_complete(subject_ids_complete.Var2 == 1,1), pre_post_complete(subject_ids_complete.Var2 == 0,1));
[h_end, p_end] = ttest2(pre_post_complete(subject_ids_complete.Var2 == 1,2), pre_post_complete(subject_ids_complete.Var2 == 0,2));
[h_int, p_int] = ttest(pre_post_complete(subject_ids_complete.Var2 == 1,1), pre_post_complete(subject_ids_complete.Var2 == 1,2));
[h_con, p_con] = ttest(pre_post_complete(subject_ids_complete.Var2 == 0,1), pre_post_complete(subject_ids_complete.Var2 == 0,2));

% percent decrease
percent_inc_int = 100*(mean_post_int - mean_pre_int)/mean_pre_int;
percent_inc_con = 100*(mean_post_con - mean_pre_con)/mean_pre_con;
