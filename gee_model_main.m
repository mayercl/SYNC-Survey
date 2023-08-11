clear; clc;
close all;

%% load the data 
load('subject.mat');

%% format the data 
save_data = 'off';
figure_display = 'off';
num_weeks = 11;
[weekly_fatigue_tscore_matrix, daily_fatigue_matrix, pre_fatigue, post_fatigue, int_con] = format_subject(subject);

% extract patient ids and intervention/control
for j = 1:length(subject)

    subject_all_patient_ids(j) = subject(j).patient_id;
    subject_all_int_con(j) = subject(j).exp_con;

end 

% write formatted data to csv
if strcmp(save_data,'on')

    writematrix(daily_fatigue_matrix,'daily_fatigue_matrix.csv')
    writematrix(weekly_fatigue_tscore_matrix, 'weekly_fatigue_tscore_matrix.csv')
    writematrix([subject_all_patient_ids' subject_all_int_con'],'subject_all_patient_ids.csv')
    writematrix([pre_fatigue' post_fatigue'],'pre_post_fatigue.csv')

end 

%% visualize the data 
if strcmp(figure_display, 'on')

    figure()
    set(gcf, 'Position',  [100, 100, 900, 1000])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    h = heatmap(daily_fatigue_matrix)
    h.FontSize = 6
    
    figure()
    set(gcf, 'Position',  [100, 100, 900, 1000])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    h = heatmap(weekly_fatigue_tscore_matrix)
    h.FontSize = 6

end 

%% statistical analysis
% daily
fatigue_c = daily_fatigue_matrix(int_con == 0,:);
fatigue_i = daily_fatigue_matrix(int_con == 1,:);
cutoff = 7;
fatigue_start_c = fatigue_c(:,1:cutoff);
fatigue_start_i = fatigue_i(:,1:cutoff);
fatigue_end_c = fatigue_c(:,end-cutoff+1:end);
fatigue_end_i = fatigue_i(:,end-cutoff+1:end);

mean_start_c = nanmean(fatigue_start_c,'all');
mean_start_i = nanmean(fatigue_start_i,'all');
mean_end_c = nanmean(fatigue_end_c,'all');
mean_end_i = nanmean(fatigue_end_i,'all');
sd_start_c = nanstd(fatigue_start_c(:));
sd_start_i = nanstd(fatigue_start_i(:));
sd_end_c = nanstd(fatigue_end_c(:));
sd_end_i = nanstd(fatigue_end_i(:));

% test statistical significance
[h_start, p_start] = ttest2(fatigue_start_c(:), fatigue_start_i(:));
[h_end, p_end] = ttest2(fatigue_end_c(:), fatigue_end_i(:));
[h_se_c, p_se_c] = ttest(fatigue_start_c(:), fatigue_end_c(:));
[h_se_i, p_se_i] = ttest(fatigue_start_i(:), fatigue_end_i(:));

% average by week
num_weeks = 12;

for j = 1:num_weeks
    
    week_inds = [(j-1)*7+1:j*7];
    fatigue_c_byweek(j,:) = nanmean(fatigue_c(:,week_inds)');
    fatigue_i_byweek(j,:) = nanmean(fatigue_i(:,week_inds)');

end 

% test statistical significance, by week
fatigue_start_c_byweek = fatigue_c_byweek(1,:);
fatigue_end_c_byweek = fatigue_c_byweek(end,:);
fatigue_start_i_byweek = fatigue_i_byweek(1,:);
fatigue_end_i_byweek = fatigue_i_byweek(end,:);

[h_start_byweek, p_start_byweek] = ttest2(fatigue_start_c_byweek(:), fatigue_start_i_byweek(:));
[h_end_byweek, p_end_byweek] = ttest2(fatigue_end_c_byweek(~isnan(fatigue_end_c_byweek)), fatigue_end_i_byweek(~isnan(fatigue_end_i_byweek)));
[h_se_c_byweek, p_se_c_byweek] = ttest(fatigue_start_c_byweek(:), fatigue_end_c_byweek(:));
[h_se_i_byweek, p_se_i_byweek] = ttest(fatigue_start_i_byweek(:), fatigue_end_i_byweek(:));