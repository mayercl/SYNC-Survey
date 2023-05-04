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

% %% set up the data for GEEs
% y_fatigue = weekly_fatigue_tscore_matrix;
% id_fatigue = [1:length(subject)]';
% t_fatigue = 1:11;%ones(length(id_fatigue),1);
% x_fatigue = [ones(length(y_fatigue),1) int_con' pre_fatigue'];
% varnames = {'constant','intervention','pre fatigue'};
% % apply the GEE 
% [betahat, alphahat, results] = gee(id_fatigue, y_fatigue, t_fatigue, x_fatigue, 'n', 'equi', varnames);

