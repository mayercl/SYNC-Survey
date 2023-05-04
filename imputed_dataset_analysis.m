clear; clc;
close all;

%% load the imputed data 
figure_display = 'off';

% 5 iterations of imputed data, from the MICE package in R
imputed_daily_dataset{1} = readmatrix('imputed_daily_dataset_1.csv');
imputed_daily_dataset{2} = readmatrix('imputed_daily_dataset_2.csv');
imputed_daily_dataset{3} = readmatrix('imputed_daily_dataset_3.csv');
imputed_daily_dataset{4} = readmatrix('imputed_daily_dataset_4.csv');
imputed_daily_dataset{5} = readmatrix('imputed_daily_dataset_5.csv');

imputed_weekly_dataset{1} = readmatrix('imputed_weekly_dataset_1.csv');
imputed_weekly_dataset{2} = readmatrix('imputed_weekly_dataset_2.csv');
imputed_weekly_dataset{3} = readmatrix('imputed_weekly_dataset_3.csv');
imputed_weekly_dataset{4} = readmatrix('imputed_weekly_dataset_4.csv');
imputed_weekly_dataset{5} = readmatrix('imputed_weekly_dataset_5.csv');

subject_ids = readtable('subject_all_patient_ids.csv');
subject_int_con = subject_ids.Var2;

%% visualize the data 
num_datasets = 5;
num_days = length(imputed_daily_dataset{1}(1,:));
num_weeks = length(imputed_weekly_dataset{1}(1,:)); 

for j = 1:num_datasets
    
    if strcmp(figure_display,'on')

        figure()
        plot(1:num_days, mean(imputed_daily_dataset{j}(subject_int_con == 0,:)),'b')
        hold on 
        plot(1:num_days, mean(imputed_daily_dataset{j}(subject_int_con == 1,:)),'r')
        title('Daily')
    
        figure()
        plot(1:num_weeks, mean(imputed_weekly_dataset{j}(subject_int_con == 0,:)),'b')
        hold on 
        plot(1:num_weeks, mean(imputed_weekly_dataset{j}(subject_int_con == 1,:)),'r')
        title('Weekly')

    end 

    [h_weekly(j),p_weekly(j)] = ttest2(imputed_weekly_dataset{j}(subject_int_con == 0,end), imputed_weekly_dataset{j}(subject_int_con == 1,end));

end 

%% more figures 
if strcmp(figure_display,'on')

    figure()
    set(gcf, 'Position',  [100, 100, 900, 1000])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    h = heatmap(imputed_weekly_dataset{1})
    h.FontSize = 6

end 

imputed_daily_avg = [imputed_daily_dataset{1}+imputed_daily_dataset{2}+imputed_daily_dataset{3}+imputed_daily_dataset{4}+imputed_daily_dataset{5}]/5;
imputed_weekly_avg = [imputed_weekly_dataset{1}+imputed_weekly_dataset{2}+imputed_weekly_dataset{3}+imputed_weekly_dataset{4}+imputed_weekly_dataset{5}]/5;
int_tscore_start = imputed_weekly_avg(subject_int_con == 1,1);
con_tscore_start = imputed_weekly_avg(subject_int_con == 0,1);
int_tscore_end = imputed_weekly_avg(subject_int_con == 1,end);
con_tscore_end = imputed_weekly_avg(subject_int_con == 0,end);

if strcmp(figure_display,'on')

    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,2,[1,2])
    y = [mean(int_tscore_start(:)); mean(con_tscore_start(:)); mean(int_tscore_end(:)); mean(con_tscore_end(:))];
    bar(y,'k')
    %sigline([1,3],'',[],y)
    xlabel('group')
    xticklabels({'int., pre','con., pre','int., post', 'con., post'})
    ylabel('mean weekly fatigue t-score')
    title('Weekly Fatigue Surveys, T-Score','FontSize',16)
    ylim([50,57])
    box off 
    
    subplot(2,2,3)
    %tscore_change_con_int = [control_tscore_start - control_tscore_end; int_tscore_start - int_tscore_end];
    scatter(1:length(con_tscore_start), con_tscore_start - con_tscore_end,'k')
    hold on 
    scatter(length(con_tscore_start)+1:length(con_tscore_start)+length(int_tscore_start),int_tscore_start - int_tscore_end,'k','filled')
    legend('control','intervention')
    xlabel('individual')
    ylabel('1st week - last week')
    title('Change in Weekly Fatigue')
    
    subplot(2,2,4)
    tscore_change_con = [con_tscore_start - con_tscore_end];
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
    
    % daily 
    
    int_tscore_start = mean(imputed_daily_avg(subject_int_con == 1,1:7)');
    con_tscore_start = mean(imputed_daily_avg(subject_int_con == 0,1:7)');
    int_tscore_end = mean(imputed_daily_avg(subject_int_con == 1,end-6:end)');
    con_tscore_end = mean(imputed_daily_avg(subject_int_con == 0,end-6:end)');
    
    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,2,[1,2])
    y = [mean(int_tscore_start); mean(con_tscore_start); mean(int_tscore_end); mean(con_tscore_end)];
    bar(y,'k')
    %sigline([1,3],'',[],y)
    xlabel('group')
    xticklabels({'int., pre','con., pre','int., post', 'con., post'})
    ylabel('mean daily fatigue')
    title('Daily Fatigue Surveys','FontSize',16)
    %ylim([50,57])
    box off 
    
    subplot(2,2,3)
    %tscore_change_con_int = [control_tscore_start - control_tscore_end; int_tscore_start - int_tscore_end];
    scatter(1:length(con_tscore_start), con_tscore_start - con_tscore_end,'k')
    hold on 
    scatter(length(con_tscore_start)+1:length(con_tscore_start)+length(int_tscore_start),int_tscore_start - int_tscore_end,'k','filled')
    legend('control','intervention')
    xlabel('individual')
    ylabel('1st week - last week')
    title('Change in Daily Fatigue')
    
    subplot(2,2,4)
    tscore_change_con = [con_tscore_start - con_tscore_end];
    tscore_change_int = [int_tscore_start - int_tscore_end];
    plot_mat = [100*sum(tscore_change_con <= 0)/length(tscore_change_con) 100*sum(tscore_change_int <= 0)/length(tscore_change_int);...
        100*sum(tscore_change_con > 0 & tscore_change_con < 1)/length(tscore_change_con) 100*sum(tscore_change_int > 0 & tscore_change_int < 1)/length(tscore_change_int);...
        100*sum(tscore_change_con >= 1)/length(tscore_change_con) 100*sum(tscore_change_int >= 1)/length(tscore_change_int)];
    bar(plot_mat)
    legend('control','intervention')
    xticklabels({'increase or same fatigue','decrease of less than 1', 'decrease of at least 1'})
    ylabel('percentage')
    title('Grouped Change in Daily Fatigue')
    box off 

end 
%% compute statistical analysis results separately 

% iterate through the imputed datasets 
for j = 1:num_datasets
    
    int_tscore_start_weekly = imputed_weekly_dataset{j}(subject_int_con == 1,1);
    con_tscore_start_weekly = imputed_weekly_dataset{j}(subject_int_con == 0,1);
    int_tscore_end_weekly = imputed_weekly_dataset{j}(subject_int_con == 1,end);
    con_tscore_end_weekly = imputed_weekly_dataset{j}(subject_int_con == 0,end);
    int_tscore_start_daily = mean(imputed_daily_dataset{j}(subject_int_con == 1,1:7)');
    con_tscore_start_daily = mean(imputed_daily_dataset{j}(subject_int_con == 0,1:7)');
    int_tscore_end_daily = mean(imputed_daily_dataset{j}(subject_int_con == 1,end-6:end)');
    con_tscore_end_daily = mean(imputed_daily_dataset{j}(subject_int_con == 0,end-6:end)');
    
    tscore_diff_int_weekly(j) = mean(int_tscore_start_weekly) - mean(int_tscore_end_weekly);
    tscore_diff_con_weekly(j) = mean(con_tscore_start_weekly) - mean(con_tscore_end_weekly);
    tscore_diff_start_weekly(j) = mean(int_tscore_start_weekly) - mean(con_tscore_start_weekly);
    tscore_diff_end_weekly(j) = mean(int_tscore_end_weekly) - mean(con_tscore_end_weekly);

    [h_weekly_start(j),p_weekly_start(j)] = ttest2(int_tscore_start_weekly, con_tscore_start_weekly);
    [h_weekly_end(j),p_weekly_end(j)] = ttest2(int_tscore_end_weekly, con_tscore_end_weekly);
    [h_weekly_int(j),p_weekly_int(j)] = ttest(int_tscore_end_weekly, int_tscore_start_weekly);
    [h_weekly_con(j),p_weekly_con(j)] = ttest(con_tscore_end_weekly, con_tscore_start_weekly);

    [h_daily_start(j),p_daily_start(j)] = ttest2(int_tscore_start_daily, con_tscore_start_daily);
    [h_daily_end(j),p_daily_end(j)] = ttest2(int_tscore_end_daily, con_tscore_end_daily);
    [h_daily_int(j),p_daily_int(j)] = ttest(int_tscore_end_daily, int_tscore_start_daily);
    [h_daily_con(j),p_daily_con(j)] = ttest(con_tscore_end_daily, con_tscore_start_daily);

end 