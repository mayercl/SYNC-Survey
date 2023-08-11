clear; clc; 
close all;

%% load the data 
load('subject.mat'); % after running main_survey_paper, load_survey_final

%% process the survey results
save_data = 'on';

% iterate through the individuals 
for j = 1:length(subject)

    disp(j)
    clearvars -except j subject save_data start_diff start_diff_weekly l1 l2 inds_check

    % process the daily results 
    subject_daily = subject(j).daily_results;

    if ~isempty(subject_daily)
        
        % sort the data by time 
        [subject_formatted_time, daily_sort_inds] = sort(subject_daily.time);
        subject_daily = subject_daily(daily_sort_inds, :);

        % determine the dates and start date 
        subject_datenums = floor(datenum(datetime(subject_formatted_time,'convertfrom','posixtime','timezone','local')));
        subject_fatigue = daily_fatigue_format(subject_daily.DailyFatigue_1Item);

        if ~isempty(subject(j).pre_results)

            subject_pre_startdatenum = floor(datenum(datetime(subject(j).pre_results.time,'convertfrom','posixtime','timezone','local')));
            start_diff(j) = floor(min(subject_datenums)) - subject_pre_startdatenum;

        else 
            
            subject_pre_startdatenum = floor(min(subject_datenums));

        end 
        
        % full datenums, from first to last
        subject_datenums_full = subject_pre_startdatenum:1:max(subject_datenums);
        
        % fill in full datenums with fatigue scores or nans 
        for m = 1:length(subject_datenums_full)
            
            survey_daily_inds = find(subject_datenums == subject_datenums_full(m));

            if isempty(survey_daily_inds)
                
                subject_fatigue_full(m) = nan;

            elseif length(survey_daily_inds) == 1

                subject_fatigue_full(m) = subject_fatigue(survey_daily_inds);

            else % more than one survey for a date

                subject_fatigue_full(m) = mean(subject_fatigue(survey_daily_inds));

            end 

        end 
        
        subject(j).daily_results_processed = [subject_datenums_full' subject_fatigue_full'];

    end 

    % process weekly surveys 
    subject_weekly = subject(j).weekly_results;

    if ~isempty(subject_weekly)
        
        % sort the data by time 
        [subject_formatted_time_weekly, weekly_sort_inds] = sort(subject_weekly.time);
        subject_weekly = subject_weekly(weekly_sort_inds, :);

        % determine the dates and start date 
        subject_datenums_weekly = floor(datenum(datetime(subject_formatted_time_weekly,'convertfrom','posixtime','timezone','local')));
        subject_fatigue_weekly = weekly_fatigue_format(subject_weekly);
        l1(j) = length(subject_fatigue_weekly(:,1));

        if ~isempty(subject(j).pre_results)

            subject_pre_startdatenum_weekly = floor(datenum(datetime(subject(j).pre_results.time,'convertfrom','posixtime','timezone','local'))) + 7; % first weekly survey after 7 days
            start_diff_weekly(j) = floor(min(subject_datenums_weekly)) - subject_pre_startdatenum_weekly; 

        else 
            
            subject_pre_startdatenum_weekly = floor(min(subject_datenums_weekly));

        end 
        
        % full datenums, from first to last
        subject_datenums_full_weekly = subject_pre_startdatenum_weekly:7:max(subject_datenums_weekly)+7;
        
        % fill in full datenums with fatigue scores or nans 
        for m = 1:length(subject_datenums_full_weekly)
            
            survey_weekly_inds = find(subject_datenums_weekly <= subject_datenums_full_weekly(m)+3.5 & subject_datenums_weekly >= subject_datenums_full_weekly(m)-3.5); % add plus or minus 3.5 for some leeway 
            disp(survey_weekly_inds)

            if isempty(survey_weekly_inds) % missing data 
                
                subject_fatigue_full_weekly(m,1) = nan;
                subject_fatigue_full_weekly(m,2) = nan;

            elseif length(survey_weekly_inds) == 1

                subject_fatigue_full_weekly(m,:) = subject_fatigue_weekly(survey_weekly_inds,:);

            else % more than one survey for a date

                subject_fatigue_full_weekly(m,:) = mean(subject_fatigue_weekly(survey_weekly_inds,:));

            end 

        end 
        
        subject(j).weekly_results_processed = [subject_datenums_full_weekly' subject_fatigue_full_weekly];
        l2(j) = sum(~isnan(subject(j).weekly_results_processed(:,2)));

    end 

end 

% save the results
if strcmp(save_data, 'on')

    save('subject','subject');

end 

%% functions 
% format daily/weekly fatigue surveys
function subject_formatted_fatigue = daily_fatigue_format(subject_formatted_fatigue_text)

   subject_formatted_fatigue = nan(length(subject_formatted_fatigue_text),1);
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'Not fatigued at all')) = 0;
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'A little bit fatigued')) = 1;
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'Somewhat fatigued')) = 2;
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'Very fatigued')) = 3;

end 

function subject_tscore_fatigue_weekly = weekly_fatigue_format(subject_weekly_table)
    
     % convert weekly survey text to numerical results
        subject_4a_1_text = subject_weekly_table.PROMIS_Fatigue_4a_1; 
        subject_4a_1 = nan(length(subject_4a_1_text),1);
        subject_4a_1(strcmp(subject_4a_1_text,'Not at all')) = 0;
        subject_4a_1(strcmp(subject_4a_1_text,'A little bit')) = 1;
        subject_4a_1(strcmp(subject_4a_1_text,'Somewhat')) = 2;
        subject_4a_1(strcmp(subject_4a_1_text,'Quite a bit')) = 3;
        subject_4a_1(strcmp(subject_4a_1_text,'Very much')) = 4;
        subject_weekly_4a_1 = subject_4a_1;

        subject_4a_2_text = subject_weekly_table.PROMIS_Fatigue_4a_2; 
        subject_4a_2 = nan(length(subject_4a_2_text),1);
        subject_4a_2(strcmp(subject_4a_2_text,'Not at all')) = 0;
        subject_4a_2(strcmp(subject_4a_2_text,'A little bit')) = 1;
        subject_4a_2(strcmp(subject_4a_2_text,'Somewhat')) = 2;
        subject_4a_2(strcmp(subject_4a_2_text,'Quite a bit')) = 3;
        subject_4a_2(strcmp(subject_4a_2_text,'Very much')) = 4;
        subject_weekly_4a_2 = subject_4a_2;

        subject_4a_3_text = subject_weekly_table.PROMIS_Fatigue_4a_3; 
        subject_4a_3 = nan(length(subject_4a_3_text),1);
        subject_4a_3(strcmp(subject_4a_3_text,'Not at all')) = 0;
        subject_4a_3(strcmp(subject_4a_3_text,'A little bit')) = 1;
        subject_4a_3(strcmp(subject_4a_3_text,'Somewhat')) = 2;
        subject_4a_3(strcmp(subject_4a_3_text,'Quite a bit')) = 3;
        subject_4a_3(strcmp(subject_4a_3_text,'Very much')) = 4;
        subject_weekly_4a_3 = subject_4a_3;

        subject_4a_4_text = subject_weekly_table.PROMIS_Fatigue_4a_4; 
        subject_4a_4 = nan(length(subject_4a_4_text),1);
        subject_4a_4(strcmp(subject_4a_4_text,'Not at all')) = 0;
        subject_4a_4(strcmp(subject_4a_4_text,'A little bit')) = 1;
        subject_4a_4(strcmp(subject_4a_4_text,'Somewhat')) = 2;
        subject_4a_4(strcmp(subject_4a_4_text,'Quite a bit')) = 3;
        subject_4a_4(strcmp(subject_4a_4_text,'Very much')) = 4;
        subject_weekly_4a_4 = subject_4a_4;
        
        weekly_raw_score = subject_weekly_4a_1 + subject_weekly_4a_2 + subject_weekly_4a_3 + subject_weekly_4a_4 + 4; 
        subject_tscore_fatigue_weekly = tscore_convert_fatigue1(weekly_raw_score);
    
end 

function z = tscore_convert_fatigue1(weekly_raw_score)

    % convert weekly fatigue raw score to tscore and SD, based on
    % HealthMeasures website 
    
    tscore = nan(length(weekly_raw_score),2);
    
    % taken from scoring manual on HealthMeasures website 
    tscore(weekly_raw_score == 4,1) = 33.7;
    tscore(weekly_raw_score == 4,2) = 4.9;
    tscore(weekly_raw_score == 5,1) = 39.7;
    tscore(weekly_raw_score == 5,2) = 3.1;
    tscore(weekly_raw_score == 6,1) = 43.1;
    tscore(weekly_raw_score == 6,2) = 2.7;
    tscore(weekly_raw_score == 7,1) = 46.0;
    tscore(weekly_raw_score == 7,2) = 2.6;
    tscore(weekly_raw_score == 8,1) = 48.6;
    tscore(weekly_raw_score == 8,2) = 2.5;
    tscore(weekly_raw_score == 9,1) = 51.0;
    tscore(weekly_raw_score == 9,2) = 2.5;
    tscore(weekly_raw_score == 10,1) = 53.1;
    tscore(weekly_raw_score == 10,2) = 2.4;
    tscore(weekly_raw_score == 11,1) = 55.1;
    tscore(weekly_raw_score == 11,2) = 2.4;
    tscore(weekly_raw_score == 12,1) = 57.0;
    tscore(weekly_raw_score == 12,2) = 2.3;
    tscore(weekly_raw_score == 13,1) = 58.8;
    tscore(weekly_raw_score == 13,2) = 2.3;
    tscore(weekly_raw_score == 14,1) = 60.7;
    tscore(weekly_raw_score == 14,2) = 2.3;
    tscore(weekly_raw_score == 15,1) = 62.7;
    tscore(weekly_raw_score == 15,2) = 2.4;
    tscore(weekly_raw_score == 16,1) = 64.6;
    tscore(weekly_raw_score == 16,2) = 2.4;
    tscore(weekly_raw_score == 17,1) = 66.7;
    tscore(weekly_raw_score == 17,2) = 2.4;
    tscore(weekly_raw_score == 18,1) = 69.0;
    tscore(weekly_raw_score == 18,2) = 2.5;
    tscore(weekly_raw_score == 19,1) = 71.6;
    tscore(weekly_raw_score == 19,2) = 2.7;
    tscore(weekly_raw_score == 20,1) = 75.8;
    tscore(weekly_raw_score == 20,2) = 3.9;
    
    z = tscore;

end 
