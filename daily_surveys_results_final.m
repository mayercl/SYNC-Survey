clear; clc;
close all;

% load the data
load('subject.mat');
figure_display = 'on';

%% look at intervention and control daily fatigue surveys
for j = 1:length(subject)
   
    len_fatigue(j) = length(subject(j).daily_results_processed(:,1));
    
end 

% initialize fatigue 

fatigue_c = nan(length(subject),max(len_fatigue));
fatigue_i = nan(length(subject),max(len_fatigue));
fatigue_all = nan(length(subject),max(len_fatigue));


for j = 1:length(subject)
    
    exp_con(j) = subject(j).exp_con;

    try

    inds_fatigue = subject(j).daily_results_processed(:,1) - subject(j).daily_results_processed(1,1)+1;%datenum(datetime(subject(j).daily_results_processed(:,1),'convertfrom','posixtime','timezone','local'))-datenum(datetime(subject(j).daily_results_processed(1,1),'convertfrom','posixtime','timezone','local'))+1;
    %inds_fatigue = 1:length(subject(j).daily_results_processed(:,1)); % alternate processing
    fatigue_all(j,inds_fatigue) = subject(j).daily_results_processed(:,2);

        if subject(j).exp_con == 0 % control
            
            fatigue_c(j,inds_fatigue) = subject(j).daily_results_processed(:,2);
            
        elseif subject(j).exp_con == 1 % intervention
           
            fatigue_i(j,inds_fatigue) = subject(j).daily_results_processed(:,2);
            
        end 

    catch

    end 

end 


% take first 84 days 
fatigue_i = fatigue_i(:,1:84);
fatigue_c = fatigue_c(:,1:84);
fatigue_all = fatigue_all(:,1:84);

% check missing data 
nan_check_fatigue_c = sum(~isnan(fatigue_c));
nan_check_fatigue_i = sum(~isnan(fatigue_i));

%% daily fatigue stats
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
    fatigue_c_week = fatigue_c(:,week_inds)';
    fatigue_i_week = fatigue_i(:,week_inds)';
    fatigue_c_byweek(j,:) = nanmean(fatigue_c_week);
    fatigue_i_byweek(j,:) = nanmean(fatigue_i_week);
    fatigue_c_byweek_all(j) = nanmean(fatigue_c_week(:));
    fatigue_i_byweek_all(j)= nanmean(fatigue_i_week(:));

    % SE bars 
    fatigue_c_byweek_all_sd(j) = nanstd(fatigue_c_week(:));
    fatigue_c_byweek_all_count(j) = sum(~isnan(fatigue_c_week(:)));
    fatigue_i_byweek_all_sd(j) = nanstd(fatigue_i_week(:));
    fatigue_i_byweek_all_count(j) = sum(~isnan(fatigue_i_week(:)));

end 

if strcmp(figure_display,'on')

    % generate daily fatigue figure 
    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    subplot(2,2,[1,2])
    set(0,'DefaultAxesTitleFontWeight','normal');
    %plot([1:12]*7, nanmean(fatigue_c_byweek'),'b')
    %hold on 
    %plot([1:12]*7, nanmean(fatigue_i_byweek'),'r')
    %errorbar([1:12]*7,nanmean(fatigue_c_byweek'),nanstd(fatigue_c_byweek')/sqrt(84),'b')
    %errorbar([1:12]*7,nanmean(fatigue_i_byweek'),nanstd(fatigue_i_byweek')/sqrt(84),'r')
    plot(1:84, movmean(nanmean(fatigue_c),7),'b','Linewidth',2)
    hold on 
    plot(1:84, movmean(nanmean(fatigue_i),7),'r','Linewidth',2)
    legend('control','intervention')
    xlabel('days')
    ylabel('averaged daily fatigue score (0-3)')
    title('Daily fatigue over the study','FontSize',16)
    box off 
    %errorbar(movmean(nanmean(fatigue_c),7),movstd(nanmean(fatigue_c),7),'b')
    %errorbar(movmean(nanmean(fatigue_i),7),movstd(nanmean(fatigue_i),7),'r')
    subplot(2,2,3)
    bar([nanmean(fatigue_end_i(:)), nanmean(fatigue_end_c(:))],'k')
    ylabel('average end of trial fatigue')
    title('Average fatigue, last week')
    xticklabels({'int.','con.'})
    box off 

end 

% good indices 
good_indices_c = find(~isnan(fatigue_c(:,end)));
good_indices_i = find(~isnan(fatigue_i(:,end)));

% figure()
% set(gcf, 'Position',  [100, 100, 1000, 400])
% set(gcf,'color','w');
% set(gca,'Visible','off')
% set(0,'DefaultAxesTitleFontWeight','normal');
% plot(1:84, movmean(nanmean(fatigue_c(good_indices_c,:)),7),'b','Linewidth',2)
% hold on 
% plot(1:84, movmean(nanmean(fatigue_i(good_indices_i,:)),7),'r','Linewidth',2)
% legend('control','intervention')
% xlabel('days')
% ylabel('averaged daily fatigue score (0-3)')
% title('Daily fatigue over the study')
%% divide by cancer population
for j = 1:length(subject)
    if strcmp(subject(j).code(1:2),'BR')
        population_code(j) = 1;
    elseif strcmp(subject(j).code(1:2),'PR')
        population_code(j) = 2;
    elseif strcmp(subject(j).code(1:2),'AU')
        population_code(j) = 3;
    end 
end 

for j = 1:3

    population = j;
    fatigue_start_c_pop = fatigue_c(population_code == population,1:cutoff);
    fatigue_start_i_pop = fatigue_i(population_code == population,1:cutoff);
    fatigue_end_c_pop = fatigue_c(population_code == population,end-cutoff+1:end);
    fatigue_end_i_pop = fatigue_i(population_code == population,end-cutoff+1:end);
    mean_start_c_pop(j) = nanmean(fatigue_start_c_pop,'all');
    mean_start_i_pop(j) = nanmean(fatigue_start_i_pop,'all');
    mean_end_c_pop(j) = nanmean(fatigue_end_c_pop,'all');
    mean_end_i_pop(j) = nanmean(fatigue_end_i_pop,'all');
    sd_start_c_pop = nanstd(fatigue_start_c_pop(:));
    sd_start_i_pop = nanstd(fatigue_start_i_pop(:));
    sd_end_c_pop = nanstd(fatigue_end_c_pop(:));
    sd_end_i_pop = nanstd(fatigue_end_i_pop(:));

end 

% test statistical significance
[h_start_pop, p_start_pop] = ttest2(fatigue_start_c_pop(:), fatigue_start_i_pop(:));
[h_end_pop, p_end_pop] = ttest2(fatigue_end_c_pop(:), fatigue_end_i_pop(:));
[h_se_c_pop, p_se_c_pop] = ttest2(fatigue_start_c_pop(:), fatigue_end_c_pop(:));
[h_se_i_pop, p_se_i_pop] = ttest2(fatigue_start_i_pop(:), fatigue_end_i_pop(:));

if strcmp(figure_display,'on')

    subplot(2,2,4)
    bar_mat = [mean_start_i_pop(1) - mean_end_i_pop(1) mean_start_i_pop(2) - mean_end_i_pop(2) mean_start_i_pop(3) - mean_end_i_pop(3); mean_start_c_pop(1) - mean_end_c_pop(1) mean_start_c_pop(2) - mean_end_c_pop(2) mean_start_c_pop(3) - mean_end_c_pop(3)];
    bar(bar_mat)
    ylabel('average decrease in daily fatigue')
    %xticks([1.5, 3.5, 5.5])
    xticklabels({'intervention','control'})
    legend('BR','PR','AU')
    title('Intervention and control changes in fatigue, first vs last week')
    box off 
    
    se_c1 = fatigue_c_byweek_all_sd./sqrt(fatigue_c_byweek_all_count);
    se_i1 = fatigue_i_byweek_all_sd./sqrt(fatigue_i_byweek_all_count);
    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    subplot(1,2,1)
    plot(1:7:84, fatigue_c_byweek_all,'b','Linewidth',2)
    hold on 
    scatter(1:7:84, fatigue_c_byweek_all)
    errorbar(1:7:84,fatigue_c_byweek_all, se_c1,'b')
    plot(1:7:84, fatigue_i_byweek_all,'r','Linewidth',2)
    scatter(1:7:84, fatigue_i_byweek_all)
    errorbar(1:7:84,fatigue_i_byweek_all, se_i1,'r')
    legend('control','','','intervention','','')
    xlabel('days')
    ylabel('averaged daily fatigue score (0-3)')
    title('Daily fatigue: by week, all data averaged','FontSize',16)
    ylim([1,1.6])
    box off 

    subplot(1,2,2)
    plot(1:7:84, nanmean(fatigue_c_byweek'),'b','Linewidth',2)
    hold on 
    scatter(1:7:84, nanmean(fatigue_c_byweek'))
    errorbar(1:7:84, nanmean(fatigue_c_byweek'), nanstd(fatigue_c_byweek')./sqrt(sum(~isnan(fatigue_c_byweek'))),'b')
    plot(1:7:84, nanmean(fatigue_i_byweek'),'r','Linewidth',2)
    scatter(1:7:84, nanmean(fatigue_i_byweek'))
    errorbar(1:7:84, nanmean(fatigue_i_byweek'), nanstd(fatigue_i_byweek')./sqrt(sum(~isnan(fatigue_i_byweek'))),'r')
    legend('control','','','intervention','','')
    xlabel('days')
    ylabel('averaged daily fatigue score (0-3)')
    title('Daily fatigue: by week, by subject then averaged','FontSize',16)
    ylim([1,1.6])
    box off 



end 
