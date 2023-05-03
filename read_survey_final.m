clear; clc;
close all;

%% load directory and ids
save_data = 'off';
directory = '/Users/calebmayer/Dropbox (University of Michigan)/sync/TrialDataTools/surveys';
patients_real = readtable('/Users/calebmayer/Dropbox (University of Michigan)/sync project/patients_real.csv','HeaderLines',0,'VariableNamingRule','preserve');
patients_real = [table(patients_real.Properties.VariableNames(1),patients_real.Properties.VariableNames(2),'VariableNames',{patients_real.Properties.VariableNames{1},patients_real.Properties.VariableNames{2}}); patients_real];
patients_real = renamevars(patients_real, '726a9509fdc6adfde7d693480b16896c', 'Var2');
names_all = patients_real.Var2; % patient ids


%% read in surveys 
% record counts for different categories
count_daily = 0;
count_weekly = 0;
count_pre = 0;
count_post = 0;
count_key = 0;
count_catch = 0;

% iterate through the patients 
for j = 1:length(names_all)
    
    disp(j)
    clearvars -except j names_all directory count_daily count_weekly count_pre count_post count_key count_catch count_pre_j count_post_j save_data
    daily_table = []; % initialize daily table for individual 
    weekly_table = [];
    count_post_j(j) = 0;
    count_pre_j(j) = 0;
    count_pre_sub = 0;
    subject_folderpath = [directory '/' names_all{j}];
    subject_surveys = dir(subject_folderpath);
    subject_surveys = subject_surveys(~ismember({subject_surveys.name},{'.','..'})); % exclude . and ..

    for m = 1:length(subject_surveys)  % iterate through the surveys for a subject

        file_final = [subject_folderpath '/' subject_surveys(m).name];
        fid = fopen(file_final);
        raw = fread(fid,inf); 
        str = char(raw'); 
        fclose(fid); 
        val = jsondecode(str);
        len_answers(m) = length(fieldnames(val.answers));
        survey_data{m}  = val.answers;

        try

            survey_data{m}.time = posixtime(datetime(val.key(1:10),'timezone','local')); % should work with newer formatting 

        catch 

            survey_data{m}.time = str2num(convertCharsToStrings(subject_surveys(m).name(8:end-5))); % if not, use survey name to get time 

        end 

        fnames = fieldnames(survey_data{m}); 

        try

            val_keys(m) = convertCharsToStrings(val.key);
            count_key = count_key+1;
            
            % determine the survey type, for newer formatting 
            if contains(val.key, 'daily')
                
                count_daily = count_daily + 1;
                survey_data{m}.DailyFatigue_1Item = convertCharsToStrings(survey_data{m}.DailyFatigue_1Item);
                daily_table = [daily_table; struct2table(survey_data{m})]; % add survey to daily table 

            elseif contains(val.key, 'weekly')

                count_weekly = count_weekly + 1;
                survey_data{m}.AppExperience_FreeResponse = convertCharsToStrings(survey_data{m}.AppExperience_FreeResponse);
                survey_data{m}.AppExperience_Like = convertCharsToStrings(survey_data{m}.AppExperience_Like);
                survey_data{m}.AppExperience_Dislike = convertCharsToStrings(survey_data{m}.AppExperience_Dislike);
                survey_data{m}.SleepAidUsage = convertCharsToStrings(survey_data{m}.SleepAidUsage);

                if length(survey_data{m}.SleepAidUsage) > 1

                    survey_data_sau = survey_data{m}.SleepAidUsage(1);

                    for b = 2:length(survey_data{m}.SleepAidUsage)

                        survey_data_sau = append(survey_data_sau, ', ', survey_data{m}.SleepAidUsage(b));

                    end 

                    survey_data{m}.SleepAidUsage = survey_data_sau;

                elseif isempty(survey_data{m}.SleepAidUsage)

                    survey_data{m}.SleepAidUsage = "";

                end 

                survey_data{m}.PROMIS_Fatigue_4a_1 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_1);
                survey_data{m}.PROMIS_Fatigue_4a_2 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_2);
                survey_data{m}.PROMIS_Fatigue_4a_3 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_3);
                survey_data{m}.PROMIS_Fatigue_4a_4 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_4);
                survey_data{m}.Travel = convertCharsToStrings(survey_data{m}.Travel);
                survey_data{m}.AlcoholUsage = convertCharsToStrings(survey_data{m}.AlcoholUsage);
                weekly_table = [weekly_table; struct2table(survey_data{m},'AsArray',1)]; % add survey to weekly table
    
            elseif contains(val.key, 'pre')
                
                count_pre_j(j) = count_pre_j(j) + 1;

                if count_pre_j(j) == 1

                    count_pre = count_pre + 1;
                    pre_table = struct2table(survey_data{m});

                end 
    
            elseif contains(val.key, 'post')
                
                count_post_j(j) = count_post_j(j) + 1;

                if count_post_j(j) == 1

                    count_post = count_post + 1;
                    post_table = struct2table(survey_data{m});

                end 

            else 
                
                disp('Error in val.key: val.key is ')
                disp(val.key)
    
            end 

        catch
            
            % need alternate way to detect survey type, for older formatting 
            count_catch = count_catch + 1;

            if len_answers(m) == 1 % daily survey
                
                count_daily = count_daily + 1;
                survey_data{m}.DailyFatigue_1Item = convertCharsToStrings(survey_data{m}.DailyFatigue_1Item);
                daily_table = [daily_table; struct2table(survey_data{m})];

            elseif len_answers(m) == 10 % weekly survey
                
                count_weekly = count_weekly + 1;
                survey_data{m}.AppExperience_FreeResponse = convertCharsToStrings(survey_data{m}.AppExperience_FreeResponse);
                survey_data{m}.AppExperience_Like = convertCharsToStrings(survey_data{m}.AppExperience_Like);
                survey_data{m}.AppExperience_Dislike = convertCharsToStrings(survey_data{m}.AppExperience_Dislike);
                survey_data{m}.SleepAidUsage = convertCharsToStrings(survey_data{m}.SleepAidUsage);

                if length(survey_data{m}.SleepAidUsage) > 1

                    survey_data_sau = survey_data{m}.SleepAidUsage(1);

                    for b = 2:length(survey_data{m}.SleepAidUsage)

                        survey_data_sau = append(survey_data_sau, ', ', survey_data{m}.SleepAidUsage(b));

                    end 

                    survey_data{m}.SleepAidUsage = survey_data_sau;

                elseif isempty(survey_data{m}.SleepAidUsage)

                    survey_data{m}.SleepAidUsage = "";

                end 

                survey_data{m}.PROMIS_Fatigue_4a_1 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_1);
                survey_data{m}.PROMIS_Fatigue_4a_2 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_2);
                survey_data{m}.PROMIS_Fatigue_4a_3 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_3);
                survey_data{m}.PROMIS_Fatigue_4a_4 = convertCharsToStrings(survey_data{m}.PROMIS_Fatigue_4a_4);
                survey_data{m}.Travel = convertCharsToStrings(survey_data{m}.Travel);
                survey_data{m}.AlcoholUsage = convertCharsToStrings(survey_data{m}.AlcoholUsage);
                weekly_table = [weekly_table; struct2table(survey_data{m},'AsArray',1)];

            elseif len_answers(m) == 47 % pre/post survey

                count_pre_sub = count_pre_sub + 1;
                time_47(count_pre_sub) = survey_data{m}.time;
               
                if count_pre_sub == 1 % assume first is pre

                    count_pre = count_pre + 1; 
                    pre_table = struct2table(survey_data{m});

                elseif count_pre_sub > 1 && time_47(count_pre_sub) > time_47(count_pre_sub - 1) + 10*24*60*60

                    count_post = count_post + 1;
                    post_table = struct2table(survey_data{m});

                end 
            
            else 
                
                disp('Error in answer length: len_answers = ')
                disp(len_answers(m))

            end 

        end 
        
        % save the results 
        if strcmp(save_data, 'on')

            try
    
                writetable(weekly_table,['/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/' names_all{j} '_weekly.xls'])
            
            catch 
    
            end 
    
            try
    
                writetable(daily_table,['/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/' names_all{j} '_daily.xls'])
            
            catch 
    
            end  
    
            try 
    
                writetable(pre_table,['/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/' names_all{j} '_pre.xls'])
            
            catch
    
            end 
    
            try 
    
                writetable(post_table,['/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/' names_all{j} '_post.xls'])
            
            catch 
            
            end 

        end 

    end 

end 

