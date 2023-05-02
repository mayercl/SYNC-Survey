clear; clc; 
close all;

%% load the survey data and update subject.mat
load('subject.mat');

for j = 1:length(subject)

    subject_names_all(j) = subject(j).name;

end 

filepath = '/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/';
patients_real = readtable('/Users/calebmayer/Dropbox (University of Michigan)/sync project/patients_real.csv','HeaderLines',0,'VariableNamingRule','preserve');
patients_real = [table(patients_real.Properties.VariableNames(1),patients_real.Properties.VariableNames(2),'VariableNames',{patients_real.Properties.VariableNames{1},patients_real.Properties.VariableNames{2}}); patients_real];
patients_real = renamevars(patients_real, '726a9509fdc6adfde7d693480b16896c', 'Var2');
names_all = patients_real.Var2;

daily_empty = [];
weekly_empty = [];
pre_empty = [];
post_empty = [];

for j = 1:length(names_all)
    
    disp(j)
    subject_index = find(strcmp(names_all{j},subject_names_all));

    try 

        daily_results = readtable([filepath names_all{j} '_daily.xls']);

        if ~isempty(subject_index)

            subject(subject_index).daily_results = daily_results;

        else 

            disp('Error: subject needs to be extended')

        end 

    catch 

        daily_empty = [daily_empty; j];

    end 

    try 

        weekly_results = readtable([filepath names_all{j} '_weekly.xls']);

        if ~isempty(subject_index)

            subject(subject_index).weekly_results = weekly_results;

        else 

            disp('Error: subject needs to be extended')
            
        end 

    catch 

        weekly_empty = [weekly_empty; j];

    end 

    try

        pre_results = readtable([filepath names_all{j} '_pre.xls']);

        if ~isempty(subject_index)

            subject(subject_index).pre_results = pre_results;

        else 

            disp('Error: subject needs to be extended')
            
        end 

    catch 

        pre_empty = [pre_empty; j];

    end 

    try 

        post_results = readtable([filepath names_all{j} '_post.xls']);

        if ~isempty(subject_index)

            subject(subject_index).post_results = post_results;

        else 

            disp('Error: subject needs to be extended')
            
        end 

    catch

        post_empty = [post_empty; j];

    end 

end 

save('subject.mat','subject.mat');