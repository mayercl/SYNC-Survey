clear; clc; 
close all;

%% load the data 
load('subject.mat'); % after running main_survey_paper, load_survey_final

%% process the survey results
count_rep = 0;
count_del = 0;

for j = 1:length(subject)

    disp(j)

    % process the daily results 
    subject_daily = subject(j).daily_results;
    ind_delete = [];

    if ~isempty(subject_daily)
        
        [subject_formatted_time, daily_sort_inds] = sort(subject_daily.time);
        subject_formatted_fatigue_text = subject_daily.DailyFatigue_1Item(daily_sort_inds);
        subject_formatted_fatigue = daily_fatigue_format(subject_formatted_fatigue_text);
        subject_datenums = datenum(datetime(subject_formatted_time,'convertfrom','posixtime'));
        ind_repeat = find(diff(subject_datenums) < 1); % first indices of a repeat
        ind_repeat_second = ind_repeat+1; % second index of repeat
        
        % deal with daily surveys that occur close together in time
        for i = 1:length(ind_repeat)
            
            if subject_formatted_fatigue(ind_repeat(i)) == subject_formatted_fatigue(ind_repeat_second(i))
                
                ind_delete = [ind_delete; ind_repeat_second(i)]; % delete second index of repeat
                count_del = count_del+1;

            else

                count_rep = count_rep+1;

            end 

        end 
        
        subject_formatted_time(ind_delete) = [];
        subject_formatted_fatigue(ind_delete) = [];
        subject(j).daily_results_processed = [subject_formatted_time subject_formatted_fatigue];

    end 

    % process the weekly results
    subject_weekly = subject(j).weekly_results;

end 

% save the results
if strcmp(save_data, 'on')

    save('subject','subject');

end 

% format daily fatigue surveys
function subject_formatted_fatigue = daily_fatigue_format(subject_formatted_fatigue_text)

   subject_formatted_fatigue = nan(length(subject_formatted_fatigue_text),1);
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'Not fatigued at all')) = 0;
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'A little bit fatigued')) = 1;
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'Somewhat fatigued')) = 2;
   subject_formatted_fatigue(strcmp(subject_formatted_fatigue_text,'Very fatigued')) = 3;

end 