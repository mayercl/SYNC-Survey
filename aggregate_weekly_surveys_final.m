clear; clc;
close all;
filelist = dir('/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2');
n = 0;
while length(filelist(n+1).name) < 10 % determine the offset 
    n = n+1;
end 

count = 0;
weekly_table_all = [];
for j = 1:length(filelist) - n
    
   if contains(filelist(j+n).name,'weekly')
       count = count+1;
       weekly_data = readtable((['/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/' filelist(j+n).name]));
       weekly_data_new = [table(repmat({filelist(j+n).name},height(weekly_data),1),'VariableNames',{'id'}) weekly_data];
       %if strcmp(class(table2array(weekly_data_new(:,"SleepAidUsage"))), 'double')
        for i  = 1:width(weekly_data_new)
            if ~iscell(weekly_data_new.(i))
                weekly_data_new.(i) = num2cell(weekly_data_new.(i));
            end 
        end 
       %end 
       weekly_data_new(:,"SleepAidUsage") =  table(table2cell(weekly_data_new(:,"SleepAidUsage")),'VariableNames',{'SleepAidUsage'});
       weekly_table_all = [weekly_table_all; weekly_data_new];
       n_cols(j) = width(weekly_data);
   end 
    
end 
weekly_table_all.dates = datetime(cell2mat(weekly_table_all.time),'Convertfrom','posixtime','timezone','local');
weekly_table_all = weekly_table_all(:,{'id','dates','AppExperience_FreeResponse','AppExperience_Dislike','AppExperience_Like','SleepAidUsage','AlcoholUsage','Travel','PROMIS_Fatigue_4a_1','PROMIS_Fatigue_4a_2','PROMIS_Fatigue_4a_3','PROMIS_Fatigue_4a_4','time'});
writetable(weekly_table_all,'/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/weekly_table_all.xls');