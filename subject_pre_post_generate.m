clear; clc;
close all;

%% load the data 
% load the data directly from the folder
filepath = '/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/';
surveys_all = dir(filepath);

for j = 1:length(surveys_all)
    
    if length(surveys_all(j).name) > 20

        subject_names(j) = convertCharsToStrings(surveys_all(j).name(1:32));

    end 

end 

unique_subject_names = unique(subject_names);
unique_subject_names(ismissing(unique_subject_names)) = [];

for j = 1:length(unique_subject_names)

    disp(j)
    subject_name = char(unique_subject_names(j));
    subject_pre_post(j).name = subject_name;

    try 

        subject_pre_post(j).pre = readtable([filepath subject_name '_pre.xls']);

    catch 

    end 

    try 

        subject_pre_post(j).post = readtable([filepath subject_name '_post.xls']);

    catch 

    end 


end 
