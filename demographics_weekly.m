clear; clc;
close all;

%% load the data 
load('subject.mat');
ind_good = [];

% iterate through the individuals, determine week 1 alcohol and sleep aid
% usage 

for j = 1:length(subject)
    
    if ~isempty(subject(j).weekly_results)
    
    [~,min_index] = min(subject(j).weekly_results.time); % min_index always 1
    week1_travel_individual(j) = subject(j).weekly_results.Travel(min_index);
    week1_alcohol_individual(j) = subject(j).weekly_results.AlcoholUsage(min_index);
    week1_sleep_aid_usage(j) = subject(j).weekly.SleepAidUsage(min_index);
    ind_good = [ind_good; j];

    end 

    subject_int_con(j) = subject(j).exp_con;
    
    if contains(subject(j).patient_id,'BRE')

        group_id(j) = 1; % breast

    elseif contains(subject(j).patient_id,'PRO')
        
        group_id(j) = 2; % prostate

    elseif contains(subject(j).patient_id,'HCT')

        group_id(j) = 3; % HCT

    end 

end 

%% aggregate the results for the baseline characteristics table 
totals = [131 46 42 43]; % manually generate total counts

% alcohol intake 
alcohol_0 = [sum(strcmp(week1_alcohol_individual,'0')), sum(strcmp(week1_alcohol_individual,'0') & group_id == 1), sum(strcmp(week1_alcohol_individual,'0') & group_id == 2), sum(strcmp(week1_alcohol_individual,'0') & group_id == 3)];
alcohol_0_percents = 100*alcohol_0./totals;
alcohol_12 = [sum(strcmp(week1_alcohol_individual,'1-2 drinks')), sum(strcmp(week1_alcohol_individual,'1-2 drinks') & group_id == 1), sum(strcmp(week1_alcohol_individual,'1-2 drinks') & group_id == 2), sum(strcmp(week1_alcohol_individual,'1-2 drinks') & group_id == 3)];
alcohol_12_percents = 100*alcohol_12./totals;
alcohol_36 = [sum(strcmp(week1_alcohol_individual,'3-6 drinks')), sum(strcmp(week1_alcohol_individual,'3-6 drinks') & group_id == 1), sum(strcmp(week1_alcohol_individual,'3-6 drinks') & group_id == 2), sum(strcmp(week1_alcohol_individual,'3-6 drinks') & group_id == 3)];
alcohol_36_percents = 100*alcohol_36./totals;
alcohol_712 = [sum(strcmp(week1_alcohol_individual,'7-12 drinks')), sum(strcmp(week1_alcohol_individual,'7-12 drinks') & group_id == 1), sum(strcmp(week1_alcohol_individual,'7-12 drinks') & group_id == 2), sum(strcmp(week1_alcohol_individual,'7-12 drinks') & group_id == 3)];
alcohol_712_percents = 100*alcohol_712./totals;
alcohol_more12 = [sum(strcmp(week1_alcohol_individual,'>12 drinks')), sum(strcmp(week1_alcohol_individual,'>12 drinks') & group_id == 1), sum(strcmp(week1_alcohol_individual,'>12 drinks') & group_id == 2), sum(strcmp(week1_alcohol_individual,'>12 drinks') & group_id == 3)];
alcohol_more12_percents = 100*alcohol_more12./totals;
alcohol_unknown = totals - (alcohol_0+alcohol_12+alcohol_36+alcohol_712+alcohol_more12);
alcohol_unknown_percents = 100*alcohol_unknown./totals;

% sleep aid usage 
len_sleep_aids  = cellfun('length',week1_sleep_aid_usage);
sleep_aids_yes = [sum(len_sleep_aids > 0), sum(len_sleep_aids > 0 & group_id == 1), sum(len_sleep_aids > 0 & group_id == 2), sum(len_sleep_aids > 0 & group_id == 3)];
sleep_aids_yes_percents = 100*sleep_aids_yes./totals;
sleep_aids_no = [sum(strcmp(week1_sleep_aid_usage,'')), sum(strcmp(week1_sleep_aid_usage,'') & group_id == 1), sum(strcmp(week1_sleep_aid_usage,'') & group_id == 2), sum(strcmp(week1_sleep_aid_usage,'') & group_id == 3)];
sleep_aids_no_percents = 100*sleep_aids_no./totals;
sleep_aids_unknown = totals - (sleep_aids_yes + sleep_aids_no);
sleep_aids_unknown_percents = 100*sleep_aids_unknown./totals;

