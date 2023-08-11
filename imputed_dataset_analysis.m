clear; clc;
close all;

%% load the imputed data 
figure_display_all = 'off';
figure_display = 'on';
total = 'on';

if strcmp(total,'on')
    
    imputed_weekly_table1 = readtable('imputed_datasets/imputed_total_weekly_dataset_1.csv');
    imputed_weekly_table2 = readtable('imputed_datasets/imputed_total_weekly_dataset_2.csv');
    imputed_weekly_table3 = readtable('imputed_datasets/imputed_total_weekly_dataset_3.csv');
    imputed_weekly_table4 = readtable('imputed_datasets/imputed_total_weekly_dataset_4.csv');
    imputed_weekly_table5 = readtable('imputed_datasets/imputed_total_weekly_dataset_5.csv');
    imputed_weekly_dataset{1} = table2array(imputed_weekly_table1(:,3:13));
    imputed_weekly_dataset{2} = table2array(imputed_weekly_table2(:,3:13));
    imputed_weekly_dataset{3} = table2array(imputed_weekly_table3(:,3:13));
    imputed_weekly_dataset{4} = table2array(imputed_weekly_table4(:,3:13));
    imputed_weekly_dataset{5} = table2array(imputed_weekly_table5(:,3:13));

    imputed_prepost_dataset{1} = table2array(imputed_weekly_table1(:,1:2));
    imputed_prepost_dataset{2} = table2array(imputed_weekly_table2(:,1:2));
    imputed_prepost_dataset{3} = table2array(imputed_weekly_table3(:,1:2));
    imputed_prepost_dataset{4} = table2array(imputed_weekly_table4(:,1:2));
    imputed_prepost_dataset{5} = table2array(imputed_weekly_table5(:,1:2));

    imputed_daily_table1 = readtable('imputed_datasets/imputed_split_daily_dataset_1.csv');
    imputed_daily_table2 = readtable('imputed_datasets/imputed_split_daily_dataset_2.csv');
    imputed_daily_table3 = readtable('imputed_datasets/imputed_split_daily_dataset_3.csv');
    imputed_daily_table4 = readtable('imputed_datasets/imputed_split_daily_dataset_4.csv');
    imputed_daily_table5 = readtable('imputed_datasets/imputed_split_daily_dataset_5.csv');
    imputed_daily_dataset{1} = table2array(imputed_daily_table1(:,1:84));
    imputed_daily_dataset{2} = table2array(imputed_daily_table2(:,1:84));
    imputed_daily_dataset{3} = table2array(imputed_daily_table3(:,1:84));
    imputed_daily_dataset{4} = table2array(imputed_daily_table4(:,1:84));
    imputed_daily_dataset{5} = table2array(imputed_daily_table5(:,1:84));

    % find subject ids, group id, int_con vector
    subject_ids_reference = readtable('subject_all_patient_ids.csv');
    subject_int_con = subject_ids_reference.Var2;
    subject_ids_weekly = imputed_weekly_table1.sync_study_id;
    subject_ids_daily = imputed_daily_table1.subject_id;
    for k = 1:length(subject_ids_weekly)

        index_weekly(k) = find(strcmp(subject_ids_reference.Var1(k),subject_ids_weekly));
        index_daily(k) = find(strcmp(subject_ids_reference.Var1(k), subject_ids_daily));
        
    end 

   for j = 1:5
       
       imputed_weekly_dataset{j} = imputed_weekly_dataset{j}(index_weekly,:);
       imputed_prepost_dataset{j} = imputed_prepost_dataset{j}(index_weekly,:);
       imputed_daily_dataset{j} = imputed_daily_dataset{j}(index_daily,:);

   end 

   group_id = nan(length(subject_int_con),1);
   % determine three cancer groups
    group_id(contains(subject_ids_reference.Var1,'BRE')) = 1; % breast
    group_id(contains(subject_ids_reference.Var1,'PRO')) = 2; % prostate
    group_id(contains(subject_ids_reference.Var1,'HCT')) = 3; % hct

else 

    % 5 iterations of imputed data, from the MICE package in R
    imputed_daily_dataset{1} = readmatrix('imputed_datasets/imputed_daily_dataset_1.csv');
    imputed_daily_dataset{2} = readmatrix('imputed_datasets/imputed_daily_dataset_2.csv');
    imputed_daily_dataset{3} = readmatrix('imputed_datasets/imputed_daily_dataset_3.csv');
    imputed_daily_dataset{4} = readmatrix('imputed_datasets/imputed_daily_dataset_4.csv');
    imputed_daily_dataset{5} = readmatrix('imputed_datasets/imputed_daily_dataset_5.csv');
    
    imputed_weekly_dataset{1} = readmatrix('imputed_datasets/imputed_weekly_dataset_1.csv');
    imputed_weekly_dataset{2} = readmatrix('imputed_datasets/imputed_weekly_dataset_2.csv');
    imputed_weekly_dataset{3} = readmatrix('imputed_datasets/imputed_weekly_dataset_3.csv');
    imputed_weekly_dataset{4} = readmatrix('imputed_datasets/imputed_weekly_dataset_4.csv');
    imputed_weekly_dataset{5} = readmatrix('imputed_datasets/imputed_weekly_dataset_5.csv');

    subject_ids = readtable('subject_all_patient_ids.csv');
    subject_int_con = subject_ids.Var2;
    group_id = nan(length(subject_int_con),1);
    
    % determine three cancer groups
    group_id(contains(subject_ids.Var1,'BRE')) = 1; % breast
    group_id(contains(subject_ids.Var1,'PRO')) = 2; % prostate
    group_id(contains(subject_ids.Var1,'HCT')) = 3; % hct

end 




%% visualize the data 
num_datasets = 5;
num_days = length(imputed_daily_dataset{1}(1,:));
num_weeks = length(imputed_weekly_dataset{1}(1,:)); 

for j = 1:num_datasets
    
    if strcmp(figure_display_all,'on')

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
if strcmp(figure_display_all,'on')

    figure()
    set(gcf, 'Position',  [100, 100, 900, 1000])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    h = heatmap(imputed_weekly_dataset{1})
    h.FontSize = 6

end 

% average the imputed datasets 
imputed_daily_avg = [imputed_daily_dataset{1}+imputed_daily_dataset{2}+imputed_daily_dataset{3}+imputed_daily_dataset{4}+imputed_daily_dataset{5}]/5;
imputed_weekly_avg = [imputed_weekly_dataset{1}+imputed_weekly_dataset{2}+imputed_weekly_dataset{3}+imputed_weekly_dataset{4}+imputed_weekly_dataset{5}]/5;
imputed_prepost_avg = (imputed_prepost_dataset{1} + imputed_prepost_dataset{2} +imputed_prepost_dataset{3} + imputed_prepost_dataset{4} + imputed_prepost_dataset{5})/5;

int_tscore_start = imputed_weekly_avg(subject_int_con == 1,1);
con_tscore_start = imputed_weekly_avg(subject_int_con == 0,1);
int_tscore_end = imputed_weekly_avg(subject_int_con == 1,end);
con_tscore_end = imputed_weekly_avg(subject_int_con == 0,end);

if strcmp(figure_display_all,'on')

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
    
    % other stats 
    tscore_diff_int_weekly(j) = mean(int_tscore_start_weekly) - mean(int_tscore_end_weekly);
    tscore_diff_con_weekly(j) = mean(con_tscore_start_weekly) - mean(con_tscore_end_weekly);
    tscore_diff_start_weekly(j) = mean(int_tscore_start_weekly) - mean(con_tscore_start_weekly);
    tscore_diff_end_weekly(j) = mean(int_tscore_end_weekly) - mean(con_tscore_end_weekly);

    tscore_int_start_weekly(j) = mean(int_tscore_start_weekly);
    tscore_int_end_weekly(j) = mean(int_tscore_end_weekly);
    tscore_con_start_weekly(j) = mean(con_tscore_start_weekly);
    tscore_con_end_weekly(j) = mean(con_tscore_end_weekly);

    tscore_int_start_weekly_sd(j) = std(int_tscore_start_weekly);
    tscore_int_end_weekly_sd(j) = std(int_tscore_end_weekly);
    tscore_con_start_weekly_sd(j) = std(con_tscore_start_weekly);
    tscore_con_end_weekly_sd(j) = std(con_tscore_end_weekly);

    tscore_int_start_daily(j) = mean(int_tscore_start_daily);
    tscore_int_end_daily(j) = mean(int_tscore_end_daily);
    tscore_con_start_daily(j) = mean(con_tscore_start_daily);
    tscore_con_end_daily(j) = mean(con_tscore_end_daily);

    tscore_int_start_daily_sd(j) = std(int_tscore_start_daily);
    tscore_int_end_daily_sd(j) = std(int_tscore_end_daily);
    tscore_con_start_daily_sd(j) = std(con_tscore_start_daily);
    tscore_con_end_daily_sd(j) = std(con_tscore_end_daily);
    
    int_start_prepost(j) = mean(imputed_prepost_dataset{j}(subject_int_con == 1,1));
    int_end_prepost(j) = mean(imputed_prepost_dataset{j}(subject_int_con == 1,2));
    con_start_prepost(j) = mean(imputed_prepost_dataset{j}(subject_int_con == 0,1));
    con_end_prepost(j) = mean(imputed_prepost_dataset{j}(subject_int_con == 0,2));

    %tscore_int_end_daily_sd_diff(j) = std(int_tscore_end_daily - con_tscore_end_daily);

    % significance testing on individual imputations
    [h_weekly_start(j),p_weekly_start(j),ci_weekly_start(j,:), stats_weekly_start{j}] = ttest2(int_tscore_start_weekly, con_tscore_start_weekly);
    [h_weekly_end(j),p_weekly_end(j),ci_weekly_end(j,:), stats_weekly_end{j}] = ttest2(int_tscore_end_weekly, con_tscore_end_weekly);
    [h_weekly_int(j),p_weekly_int(j),ci_weekly_int(j,:), stats_weekly_int{j}] = ttest(int_tscore_end_weekly, int_tscore_start_weekly);
    [h_weekly_con(j),p_weekly_con(j),ci_weekly_con(j,:), stats_weekly_con{j}] = ttest(con_tscore_end_weekly, con_tscore_start_weekly);

    tstats_end_weekly(j) = stats_weekly_end{j}.tstat;
    tstats_start_weekly(j) = stats_weekly_start{j}.tstat;
    tstats_int_weekly(j) = stats_weekly_int{j}.tstat;
    tstats_con_weekly(j) = stats_weekly_con{j}.tstat;

    [h_daily_start(j),p_daily_start(j),ci_daily_start(j,:), stats_daily_start{j}] = ttest2(int_tscore_start_daily, con_tscore_start_daily);
    [h_daily_end(j),p_daily_end(j),ci_daily_end(j,:), stats_daily_end{j}] = ttest2(int_tscore_end_daily, con_tscore_end_daily);
    [h_daily_int(j),p_daily_int(j),ci_daily_int(j,:), stats_daily_int{j}] = ttest(int_tscore_end_daily, int_tscore_start_daily);
    [h_daily_con(j),p_daily_con(j),ci_daily_con(j,:), stats_daily_con{j}] = ttest(con_tscore_end_daily, con_tscore_start_daily);
    
    tstats_end_daily(j) = stats_daily_end{j}.tstat;
    tstats_start_daily(j) = stats_daily_start{j}.tstat;
    tstats_int_daily(j) = stats_daily_int{j}.tstat;
    tstats_con_daily(j) = stats_daily_con{j}.tstat;

    [h_prepost_start(j),p_prepost_start(j),ci_prepost_start(j,:), stats_prepost_start{j}] = ttest2(imputed_prepost_dataset{j}(subject_int_con == 1,1), imputed_prepost_dataset{j}(subject_int_con == 0,1));
    [h_prepost_end(j),p_prepost_end(j),ci_prepost_end(j,:), stats_prepost_end{j}] = ttest2(imputed_prepost_dataset{j}(subject_int_con == 1,2), imputed_prepost_dataset{j}(subject_int_con == 0,2));
    [h_prepost_int(j),p_prepost_int(j),ci_prepost_int(j,:), stats_prepost_int{j}] = ttest(imputed_prepost_dataset{j}(subject_int_con == 1,2), imputed_prepost_dataset{j}(subject_int_con == 1,1));
    [h_prepost_con(j),p_prepost_con(j),ci_prepost_con(j,:), stats_prepost_con{j}] = ttest(imputed_prepost_dataset{j}(subject_int_con == 0,2), imputed_prepost_dataset{j}(subject_int_con == 0,1));
    
    tstats_end_prepost(j) = stats_prepost_end{j}.tstat;
    tstats_start_prepost(j) = stats_prepost_start{j}.tstat;
    tstats_int_prepost(j) = stats_prepost_int{j}.tstat;
    tstats_con_prepost(j) = stats_prepost_con{j}.tstat;

    df_end_daily(j) = stats_daily_end{j}.df;
    sd_end_daily(j) = stats_daily_end{j}.sd;
    

end 

% pool to get p-values
[p_value_pooled_weekly_end, ~, ~] = rubin_pool(tscore_int_end_weekly, tscore_con_end_weekly, tstats_end_weekly, num_datasets);
[p_value_pooled_weekly_start, ~, ~] = rubin_pool(tscore_int_start_weekly, tscore_con_start_weekly, tstats_start_weekly, num_datasets);
[p_value_pooled_weekly_int, ~, ~] = rubin_pool(tscore_int_start_weekly, tscore_int_end_weekly, tstats_int_weekly, num_datasets);
[p_value_pooled_weekly_con, ~, ~] = rubin_pool(tscore_con_start_weekly, tscore_con_end_weekly, tstats_con_weekly, num_datasets);

[p_value_pooled_daily_end, ~, ~] = rubin_pool(tscore_int_end_daily, tscore_con_end_daily, tstats_end_daily, num_datasets);
[p_value_pooled_daily_start, ~, ~] = rubin_pool(tscore_int_start_daily, tscore_con_start_daily, tstats_start_daily, num_datasets);
[p_value_pooled_daily_int, ~, ~] = rubin_pool(tscore_int_start_daily, tscore_int_end_daily, tstats_int_daily, num_datasets);
[p_value_pooled_daily_con, ~, ~] = rubin_pool(tscore_con_start_daily, tscore_con_end_daily, tstats_con_daily, num_datasets);

[p_value_pooled_prepost_end, ~, ~] = rubin_pool(int_end_prepost, con_end_prepost, tstats_end_prepost, num_datasets);
[p_value_pooled_prepost_start, ~, ~] = rubin_pool(int_start_prepost, con_start_prepost, tstats_start_prepost, num_datasets);
[p_value_pooled_prepost_int, ~, ~] = rubin_pool(int_start_prepost, int_end_prepost, tstats_int_prepost, num_datasets);
[p_value_pooled_prepost_con, ~, ~] = rubin_pool(con_start_prepost, con_end_prepost, tstats_con_prepost, num_datasets);

% to get other values:
% mean(imputed_weekly_avg(subject_int_con == 1,:)), etc. 
%  mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 2,:)), etc. 
% mean(mean(imputed_daily_avg(subject_int_con == 1,1:7)'))
% per_chg_int_weekly = 100*(mean(imputed_weekly_avg(subject_int_con == 1,end)) - mean(imputed_weekly_avg(subject_int_con == 1,1)))/mean(imputed_weekly_avg(subject_int_con == 1,1))
% per_chg_int_weekly_grp = 100*(mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,end)) - mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,1)))/mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,1))
% mean(imputed_prepost_avg(subject_int_con == 1,1))
% per_chg_int_prepost = 100*(mean(imputed_prepost_avg(subject_int_con == 1,2)) - mean(imputed_prepost_avg(subject_int_con == 1,1)))/mean(imputed_prepost_avg(subject_int_con == 1,1))

if strcmp(figure_display,'on')
    
    nIDs = 6;
    alphabet = ('A':'Z').';
    chars = num2cell(alphabet(1:nIDs));
    chars = chars.';
    charlbl = chars;%strcat('(',chars,')');
    
    imputed_daily_avg = [imputed_daily_dataset{1}+imputed_daily_dataset{2}+imputed_daily_dataset{3}+imputed_daily_dataset{4}+imputed_daily_dataset{5}]/5;
    imputed_weekly_avg = [imputed_weekly_dataset{1}+imputed_weekly_dataset{2}+imputed_weekly_dataset{3}+imputed_weekly_dataset{4}+imputed_weekly_dataset{5}]/5;
    int_tscore_start = imputed_weekly_avg(subject_int_con == 1,1);
    con_tscore_start = imputed_weekly_avg(subject_int_con == 0,1);
    int_tscore_end = imputed_weekly_avg(subject_int_con == 1,end);
    con_tscore_end = imputed_weekly_avg(subject_int_con == 0,end);
    
    figure()
    set(gcf, 'Position',  [100, 100, 1000, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,2,3)
    tscore_bp = [int_tscore_start; con_tscore_start; int_tscore_end; con_tscore_end];
    g = [zeros(length(int_tscore_start),1); ones(length(con_tscore_start),1); ones(length(int_tscore_end),1) + 1; ones(length(con_tscore_end),1)+2];
    boxplot(tscore_bp, g,'color','k')
    yt = get(gca, 'YTick');
    axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');
    hold on
    plot(xt([1 3]), [1 1]*max(yt)*1.05, '-k',  mean(xt([1 3])), max(yt)*1.075, '*k')
    plot(xt([2 4]), [1 1]*max(yt)*1.1, '-k',  mean(xt([2 4])), max(yt)*1.15, '*k')
    hold off
    box off 
    ylim([min(tscore_bp) - 5, max(yt)*1.175])
    xticklabels({'Intervention, 1st week','Control, 1st week', 'Intervention, last week','Control, last week'})
    ylabel('Tscore')
    title('Weekly fatigue','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    yticks([30:20:90])
    text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',16)

    subplot(2,2,[1,2])
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1,:)),'k')
    hold on 
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1,:)),std(imputed_weekly_avg(subject_int_con == 1,:))./sqrt(sum(subject_int_con == 1)),'k')
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0,:)),'k--')
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0,:)),std(imputed_weekly_avg(subject_int_con == 0,:))./sqrt(sum(subject_int_con == 0)),'k--')
    legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('Tscore','FontSize',16)
    title('Weekly fatigue over time','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([51:2:57])
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',16)
    
    fatigue_change_weekly = imputed_weekly_avg(:,1) - imputed_weekly_avg(:,end);
    subplot(2,2,4)
    bar(1:6,[mean(fatigue_change_weekly(subject_int_con == 1 & group_id == 1)),mean(fatigue_change_weekly(subject_int_con == 0 & group_id == 1)),mean(fatigue_change_weekly(subject_int_con == 1 & group_id == 2)),mean(fatigue_change_weekly(subject_int_con == 0 & group_id == 2)),mean(fatigue_change_weekly(subject_int_con == 1 & group_id == 3)),mean(fatigue_change_weekly(subject_int_con == 0 & group_id == 3))],'k')
    hold on 
    er = errorbar(1:6,[mean(fatigue_change_weekly(subject_int_con == 1 & group_id == 1)),mean(fatigue_change_weekly(subject_int_con == 0 & group_id == 1)),mean(fatigue_change_weekly(subject_int_con == 1 & group_id == 2)),mean(fatigue_change_weekly(subject_int_con == 0 & group_id == 2)), mean(fatigue_change_weekly(subject_int_con == 1 & group_id == 3)),mean(fatigue_change_weekly(subject_int_con == 0 & group_id == 3))],zeros(6,1),[std(fatigue_change_weekly(subject_int_con == 1 & group_id == 1))/sqrt(length(fatigue_change_weekly(subject_int_con == 1 & group_id == 1))),std(fatigue_change_weekly(subject_int_con == 0 & group_id == 1))/sqrt(length(fatigue_change_weekly(subject_int_con == 0 & group_id == 1))),std(fatigue_change_weekly(subject_int_con == 1 & group_id == 2))/sqrt(length(fatigue_change_weekly(subject_int_con == 1 & group_id == 2))),std(fatigue_change_weekly(subject_int_con == 0 & group_id == 2))/sqrt(length(fatigue_change_weekly(subject_int_con == 0 & group_id == 2))),std(fatigue_change_weekly(subject_int_con == 1 & group_id == 3))/sqrt(length(fatigue_change_weekly(subject_int_con == 1 & group_id == 3))),std(fatigue_change_weekly(subject_int_con == 0 & group_id == 3))/sqrt(length(fatigue_change_weekly(subject_int_con == 0 & group_id == 3)))],'k')
    er.LineStyle = 'none';
    box off 
    %xticks([1.5:2:5.5])
    yticks([0:2:4])
    xticklabels({'BR, int','BR, con','PR, int','PR, con', 'HCT, int','HCT, con'})
    ax = gca;
    ax.FontSize = 16;
    title('Weekly fatigue improvement by cancer group','FontSize',16)
    text(0.025,0.95,charlbl{3},'Units','normalized','FontSize',16)
    ylabel('decrease in fatigue')

    figure(20)
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,3,1)
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,:)),'k')
    hold on 
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,:)),std(imputed_weekly_avg(subject_int_con == 1 & group_id == 1,:))./sqrt(sum(subject_int_con == 1 & group_id == 1)),'k')
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 1,:)),'k--')
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 1,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 1,:)),std(imputed_weekly_avg(subject_int_con == 0 & group_id == 1,:))./sqrt(sum(subject_int_con == 0 & group_id == 1)),'k--')
    legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('Tscore','FontSize',16)
    title('Breast cancer population, weekly','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([48:4:56])
    ylim([47.5,58])
    ax = gca;
    ax.FontSize = 16;
    text(0.005,0.99,charlbl{1},'Units','normalized','FontSize',16)

    subplot(2,3,2)
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 2,:)),'k')
    hold on 
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 2,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 2,:)),std(imputed_weekly_avg(subject_int_con == 1 & group_id == 2,:))./sqrt(sum(subject_int_con == 1 & group_id == 2)),'k')
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 2,:)),'k--')
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 2,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 2,:)),std(imputed_weekly_avg(subject_int_con == 0 & group_id == 2,:))./sqrt(sum(subject_int_con == 0 & group_id == 2)),'k--')
    %legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('Tscore','FontSize',16)
    title('Prostate cancer population, weekly','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([48:4:56])
    ylim([47.5,58])
    ax = gca;
    ax.FontSize = 16;
    text(0.005,0.99,charlbl{2},'Units','normalized','FontSize',16)
    
    subplot(2,3,3)
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 3,:)),'k')
    hold on 
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 3,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 1 & group_id == 3,:)),std(imputed_weekly_avg(subject_int_con == 1 & group_id == 3,:))./sqrt(sum(subject_int_con == 1 & group_id == 3)),'k')
    plot(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 3,:)),'k--')
    scatter(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 3,:)),'k','filled')
    errorbar(1:length(imputed_weekly_avg(1,:)),mean(imputed_weekly_avg(subject_int_con == 0 & group_id == 3,:)),std(imputed_weekly_avg(subject_int_con == 0 & group_id == 3,:))./sqrt(sum(subject_int_con == 0 & group_id == 3)),'k--')
    %legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('Tscore','FontSize',16)
    title('HCT cancer population, weekly','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([48:4:56])
    ylim([47.5,58])
    ax = gca;
    ax.FontSize = 16;
    text(0.005,0.99,charlbl{3},'Units','normalized','FontSize',16)

    % daily figure 
    int_tscore_start = mean(imputed_daily_avg(subject_int_con == 1,1:7)');
    con_tscore_start = mean(imputed_daily_avg(subject_int_con == 0,1:7)');
    int_tscore_end = mean(imputed_daily_avg(subject_int_con == 1,end-6:end)');
    con_tscore_end = mean(imputed_daily_avg(subject_int_con == 0,end-6:end)');
    
    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(1,2,1)
    tscore_bp = [int_tscore_start'; con_tscore_start'; int_tscore_end'; con_tscore_end'];
    g = [zeros(length(int_tscore_start),1); ones(length(con_tscore_start),1); ones(length(int_tscore_end),1) + 1; ones(length(con_tscore_end),1)+2];
    boxplot(tscore_bp, g,'color','k')
    yt = get(gca, 'YTick');
    axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');
    hold on
    plot(xt([1 3]), [1 1]*max(yt)*1.05, '-k',  mean(xt([1 3])), max(yt)*1.075, '*k')
    plot(xt([2 4]), [1 1]*max(yt)*1.1, '-k',  mean(xt([2 4])), max(yt)*1.15, '*k')
    plot(xt([3 4]), [1 1]*max(yt)*1.02, '-k',  mean(xt([3 4])), max(yt)*1.05, '*k')
    hold off
    box off 
    ylim([min(tscore_bp) - 0.1, max(yt)*1.175])
    xticklabels({'Intervention, 1st week','Control, 1st week', 'Intervention, last week','Control, last week'})
    ylabel('Tscore')
    title('Daily fatigue','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    yticks([0:1:3])
    text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',16)

    for j = 1:12
        week_inds = [7*(j-1)+1:7*j];
        daily_binned_int(j) = mean(mean(imputed_daily_avg(subject_int_con == 1,week_inds)));
        daily_binned_con(j) = mean(mean(imputed_daily_avg(subject_int_con == 0,week_inds)));
        daily_binned_int_sd(j) = std(mean(imputed_daily_avg(subject_int_con == 1,week_inds)'));
        daily_binned_con_sd(j) = std(mean(imputed_daily_avg(subject_int_con == 0,week_inds)'));

        daily_binned_int_br(j) = mean(mean(imputed_daily_avg(subject_int_con == 1 & group_id == 1,week_inds)));
        daily_binned_con_br(j) = mean(mean(imputed_daily_avg(subject_int_con == 0 & group_id == 1,week_inds)));
        daily_binned_int_sd_br(j) = std(mean(imputed_daily_avg(subject_int_con == 1 & group_id == 1,week_inds)'));
        daily_binned_con_sd_br(j) = std(mean(imputed_daily_avg(subject_int_con == 0 & group_id == 1,week_inds)'));

        daily_binned_int_pr(j) = mean(mean(imputed_daily_avg(subject_int_con == 1 & group_id == 2,week_inds)));
        daily_binned_con_pr(j) = mean(mean(imputed_daily_avg(subject_int_con == 0 & group_id == 2,week_inds)));
        daily_binned_int_sd_pr(j) = std(mean(imputed_daily_avg(subject_int_con == 1 & group_id == 2,week_inds)'));
        daily_binned_con_sd_pr(j) = std(mean(imputed_daily_avg(subject_int_con == 0 & group_id == 2,week_inds)'));

        daily_binned_int_hct(j) = mean(mean(imputed_daily_avg(subject_int_con == 1 & group_id == 3,week_inds)));
        daily_binned_con_hct(j) = mean(mean(imputed_daily_avg(subject_int_con == 0 & group_id == 3,week_inds)));
        daily_binned_int_sd_hct(j) = std(mean(imputed_daily_avg(subject_int_con == 1 & group_id == 3,week_inds)'));
        daily_binned_con_sd_hct(j) = std(mean(imputed_daily_avg(subject_int_con == 0 & group_id == 3,week_inds)'));

    end 
    subplot(1,2,2)
    plot(1:length(daily_binned_int),daily_binned_int,'k')
    hold on 
    scatter(1:length(daily_binned_int),daily_binned_int,'k','filled')
    errorbar(1:length(daily_binned_int),daily_binned_int, daily_binned_int_sd/sqrt(sum(subject_int_con == 1)),'k')
    plot(1:length(daily_binned_con),daily_binned_con,'k--')
    scatter(1:length(daily_binned_con),daily_binned_con,'k','filled')
    errorbar(1:length(daily_binned_con),daily_binned_con, daily_binned_con_sd/sqrt(sum(subject_int_con == 0)),'k--')
    legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('fatigue value','FontSize',16)
    title('Daily fatigue over time','FontSize',16)
    box off
    %xticks([1:2:11])
    yticks([1.1:0.2:1.5])
    xticks([1:2:12])
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.95,charlbl{2},'Units','normalized','FontSize',16)

   figure(20)
%     set(gcf, 'Position',  [100, 100, 1000, 400])
%     set(gcf,'color','w');
%     set(gca,'Visible','off')
%     set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,3,4)
    plot(1:length(daily_binned_int_br),daily_binned_int_br,'k')
    hold on 
    scatter(1:length(daily_binned_int_br),daily_binned_int_br,'k','filled')
    errorbar(1:length(daily_binned_int_br),daily_binned_int_br, daily_binned_int_sd_br/sqrt(sum(subject_int_con == 1 & group_id == 1)),'k')
    plot(1:length(daily_binned_con_br),daily_binned_con_br,'k--')
    scatter(1:length(daily_binned_con_br),daily_binned_con_br,'k','filled')
    errorbar(1:length(daily_binned_con_br),daily_binned_con_br, daily_binned_con_sd_br/sqrt(sum(subject_int_con == 0 & group_id == 1)),'k--')
    %legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('fatigue value','FontSize',16)
    title('Breast cancer population, daily','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([1:0.4:1.8])
    %xticks([1:2:12])
    ylim([0.9, 1.9])
    ax = gca;
    ax.FontSize = 16;
    text(0.005,0.99,charlbl{4},'Units','normalized','FontSize',16)

    subplot(2,3,5)
    plot(1:length(daily_binned_int_pr),daily_binned_int_pr,'k')
    hold on 
    scatter(1:length(daily_binned_int_pr),daily_binned_int_pr,'k','filled')
    errorbar(1:length(daily_binned_int_pr),daily_binned_int_pr, daily_binned_int_sd_pr/sqrt(sum(subject_int_con == 1 & group_id == 2)),'k')
    plot(1:length(daily_binned_con_pr),daily_binned_con_pr,'k--')
    scatter(1:length(daily_binned_con_pr),daily_binned_con_pr,'k','filled')
    errorbar(1:length(daily_binned_con_pr),daily_binned_con_pr, daily_binned_con_sd_pr/sqrt(sum(subject_int_con == 0 & group_id == 2)),'k--')
    %legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('fatigue value','FontSize',16)
    title('Prostate cancer population, daily','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([1:0.4:1.8])
    %xticks([1:2:12])
    ylim([0.9, 1.9])
    ax = gca;
    ax.FontSize = 16;
    text(0.005,0.99,charlbl{5},'Units','normalized','FontSize',16)

    subplot(2,3,6)
    plot(1:length(daily_binned_int_hct),daily_binned_int_hct,'k')
    hold on 
    scatter(1:length(daily_binned_int_hct),daily_binned_int_hct,'k','filled')
    errorbar(1:length(daily_binned_int_hct),daily_binned_int_hct, daily_binned_int_sd_hct/sqrt(sum(subject_int_con == 1 & group_id == 3)),'k')
    plot(1:length(daily_binned_con_hct),daily_binned_con_hct,'k--')
    scatter(1:length(daily_binned_con_hct),daily_binned_con_hct,'k','filled')
    errorbar(1:length(daily_binned_con_hct),daily_binned_con_hct, daily_binned_con_sd_hct/sqrt(sum(subject_int_con == 0 & group_id == 3)),'k--')
    %legend('intervention','','','control','','')
    xlabel('week','FontSize',16)
    ylabel('fatigue value','FontSize',16)
    title('HCT cancer population, daily','FontSize',16)
    box off
    xticks([1:2:11])
    yticks([1:0.4:1.8])
    xticks([1:2:12])
    ylim([0.9, 1.9])
    ax = gca;
    ax.FontSize = 16;
    text(0.005,0.99,charlbl{6},'Units','normalized','FontSize',16)

end 

function [p_value_pooled, mean_diff_avg, se_total] = rubin_pool(means1, means2, tstats, num_datasets)

    mean_diff_avg = mean(means1 - means2);
    se = (means1 - means2)./tstats;
    v_w = mean(se.^2);
    v_b = sum((means1 - means2 - mean_diff_avg).^2)/(num_datasets - 1);
    v_total = v_w + v_b + v_b/num_datasets;
    se_total = sqrt(v_total);
    wald_pooled = mean_diff_avg/se_total; % check this
    lambda = (v_b + v_b/num_datasets)/v_total;
    df = (num_datasets - 1)/lambda^2;
    p_value_pooled = 2*(1 - tcdf(abs(wald_pooled), df));

end 