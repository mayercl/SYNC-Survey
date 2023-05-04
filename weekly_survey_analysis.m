clear; clc;
close all;

% load the data 
weekly_survey_data = readtable('/Users/calebmayer/Dropbox (University of Michigan)/sync project/surveys_formatted_v2/weekly_table_all.xls');
figure_display = 'off';

%% format the data 
load('subject.mat');

for j = 1:length(subject)

    subject_inds = find(strcmp(weekly_survey_data.id, [char(subject(j).name) '_weekly.xls']));
    
    if ~isempty(subject_inds)
        
        % load and format the weekly survey items 
        subject(j).weekly = weekly_survey_data(subject_inds,:);

        % convert weekly survey text to numerical results
        subject_4a_1_text = subject(j).weekly.PROMIS_Fatigue_4a_1; 
        subject_4a_1 = nan(length(subject_4a_1_text),1);
        subject_4a_1(strcmp(subject_4a_1_text,'Not at all')) = 0;
        subject_4a_1(strcmp(subject_4a_1_text,'A little bit')) = 1;
        subject_4a_1(strcmp(subject_4a_1_text,'Somewhat')) = 2;
        subject_4a_1(strcmp(subject_4a_1_text,'Quite a bit')) = 3;
        subject_4a_1(strcmp(subject_4a_1_text,'Very much')) = 4;
        subject(j).weekly_4a_1 = subject_4a_1;

        subject_4a_2_text = subject(j).weekly.PROMIS_Fatigue_4a_2; 
        subject_4a_2 = nan(length(subject_4a_2_text),1);
        subject_4a_2(strcmp(subject_4a_2_text,'Not at all')) = 0;
        subject_4a_2(strcmp(subject_4a_2_text,'A little bit')) = 1;
        subject_4a_2(strcmp(subject_4a_2_text,'Somewhat')) = 2;
        subject_4a_2(strcmp(subject_4a_2_text,'Quite a bit')) = 3;
        subject_4a_2(strcmp(subject_4a_2_text,'Very much')) = 4;
        subject(j).weekly_4a_2 = subject_4a_2;

        subject_4a_3_text = subject(j).weekly.PROMIS_Fatigue_4a_3; 
        subject_4a_3 = nan(length(subject_4a_3_text),1);
        subject_4a_3(strcmp(subject_4a_3_text,'Not at all')) = 0;
        subject_4a_3(strcmp(subject_4a_3_text,'A little bit')) = 1;
        subject_4a_3(strcmp(subject_4a_3_text,'Somewhat')) = 2;
        subject_4a_3(strcmp(subject_4a_3_text,'Quite a bit')) = 3;
        subject_4a_3(strcmp(subject_4a_3_text,'Very much')) = 4;
        subject(j).weekly_4a_3 = subject_4a_3;

        subject_4a_4_text = subject(j).weekly.PROMIS_Fatigue_4a_4; 
        subject_4a_4 = nan(length(subject_4a_4_text),1);
        subject_4a_4(strcmp(subject_4a_4_text,'Not at all')) = 0;
        subject_4a_4(strcmp(subject_4a_4_text,'A little bit')) = 1;
        subject_4a_4(strcmp(subject_4a_4_text,'Somewhat')) = 2;
        subject_4a_4(strcmp(subject_4a_4_text,'Quite a bit')) = 3;
        subject_4a_4(strcmp(subject_4a_4_text,'Very much')) = 4;
        subject(j).weekly_4a_4 = subject_4a_4;
        
        weekly_raw_score = subject(j).weekly_4a_1 + subject(j).weekly_4a_2 + subject(j).weekly_4a_3 + subject(j).weekly_4a_4 + 4; 
        subject(j).weekly_tscore = tscore_convert_fatigue1(weekly_raw_score);

    end 
    
end 

%% analyze the data 
%load('subject.mat');
control_tscore_start = [];
control_tscore_end = [];
int_tscore_start = [];
int_tscore_end = [];

num_weeks_cutoff = 3;

% iterate through the subjects and define start and end weeks
for j = 1:length(subject)

    if subject(j).exp_con == 0 & length(subject(j).weekly_tscore) > num_weeks_cutoff
        
        control_tscore_start = [control_tscore_start; subject(j).weekly_tscore(1,1)];
        control_tscore_end = [control_tscore_end; subject(j).weekly_tscore(end,1)];

    elseif subject(j).exp_con == 1 & length(subject(j).weekly_tscore) > num_weeks_cutoff
        
        int_tscore_start = [int_tscore_start; subject(j).weekly_tscore(1,1)];
        int_tscore_end = [int_tscore_end; subject(j).weekly_tscore(end,1)];

    end 

end 

if strcmp(figure_display,'on')

    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,2,[1,2])
    y = [mean(int_tscore_start); mean(control_tscore_start); mean(int_tscore_end); mean(control_tscore_end)];
    bar(y,'k')
    %sigline([1,3],'',[],y)
    xlabel('group')
    xticklabels({'int., pre','con., pre','int., post', 'con., post'})
    ylabel('mean weekly fatigue t-score')
    title('Weekly Fatigue Surveys, T-Score','FontSize',16)
    ylim([50,58])
    box off 
    
    subplot(2,2,3)
    %tscore_change_con_int = [control_tscore_start - control_tscore_end; int_tscore_start - int_tscore_end];
    scatter(1:length(control_tscore_start), control_tscore_start - control_tscore_end)
    hold on 
    scatter(length(control_tscore_start)+1:length(control_tscore_start)+length(int_tscore_start),int_tscore_start - int_tscore_end)
    legend('control','intervention')
    xlabel('individual')
    ylabel('1st week - last week')
    title('Change in Weekly Fatigue')
    
    subplot(2,2,4)
    tscore_change_con = [control_tscore_start - control_tscore_end];
    tscore_change_int = [int_tscore_start - int_tscore_end];
    plot_mat = [100*sum(tscore_change_con <= 0)/length(tscore_change_con) 100*sum(tscore_change_int <= 0)/length(tscore_change_int);...
        100*sum(tscore_change_con > 0 & tscore_change_con < 2)/length(tscore_change_con) 100*sum(tscore_change_int > 0 & tscore_change_int < 2)/length(tscore_change_int);...
        100*sum(tscore_change_con >= 2)/length(tscore_change_con) 100*sum(tscore_change_int >= 2)/length(tscore_change_int)];
    bar(plot_mat)
    legend('control','intervention')
    xticklabels({'increase or same fatigue','decrease of less than 2', 'decrease of at least 2'})
    ylabel('percentage')
    title('Grouped Change in Weekly Fatigue')
    box off 
    
    %[h,p] = ttest(int_tscore_end, int_tscore_start)

end 
    
    

