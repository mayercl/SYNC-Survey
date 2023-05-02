clear; clc;
close all;

% load the data
load('subject.mat');

%% look at intervention and control daily fatigue surveys, other results over time
for j = 1:length(subject)
    
    len(j) = length(subject(j).hr_date);
    len_lco(j) = length(subject(j).lco_time);
    len_fatigue(j) = length(subject(j).daily_results_processed(:,1));
    
end 


mesors_c = nan(length(subject),max(len));
amps_c = nan(length(subject),max(len));
steps2hr_c = nan(length(subject),max(len));
noise_c = nan(length(subject),max(len));
autocorrelation_c = nan(length(subject),max(len));
uncertainty_c = nan(length(subject),max(len));
daily_steps_c = nan(length(subject),max(len));
fatigue_c = nan(length(subject),max(len));
lco_phase_c = nan(length(subject),max(len_lco));
lco_amp_c = nan(length(subject),max(len_lco));

mesors_i = nan(length(subject),max(len));
amps_i = nan(length(subject),max(len));
steps2hr_i = nan(length(subject),max(len));
noise_i = nan(length(subject),max(len));
autocorrelation_i = nan(length(subject),max(len));
uncertainty_i = nan(length(subject),max(len));
daily_steps_i = nan(length(subject),max(len));
fatigue_i = nan(length(subject),max(len));
lco_phase_i = nan(length(subject),max(len_lco));
lco_amp_i = nan(length(subject),max(len_lco));

for j = 1:length(subject)
    try
    inds = datenum(subject(j).hr_date) - datenum(subject(j).hr_date(1))+1;
    inds_fatigue = datenum(datetime(subject(j).daily_results_processed(:,1),'convertfrom','posixtime','timezone','local'))-datenum(datetime(subject(j).daily_results_processed(1,1),'convertfrom','posixtime','timezone','local'))+1;
    %inds_fatigue = 1:length(subject(j).daily_results_processed(:,1)); % alternate processing
    inds_lco = 1:length(subject(j).lco_time);
    
    if subject(j).exp_con == 0 % control
        
        mesors_c(j,inds) = subject(j).mesor;
        amps_c(j,inds) = subject(j).amp;
        steps2hr_c(j,inds) = subject(j).steps2hr;
        noise_c(j,inds) = subject(j).noise;
        autocorrelation_c(j,inds) = subject(j).autocorrelation;
        uncertainty_c(j,inds) = subject(j).uncertainty;
        daily_steps_c(j,inds) = subject(j).daily_steps;
        fatigue_c(j,inds_fatigue) = subject(j).daily_results_processed(:,2);
        lco_phase_c(j,inds_lco) = mod(subject(j).lco_phase,24);
        lco_amp_c(j,inds_lco) = subject(j).lco_amp;
        
    elseif subject(j).exp_con == 1 % intervention
       
        mesors_i(j,inds) = subject(j).mesor;
        amps_i(j,inds) = subject(j).amp;
        steps2hr_i(j,inds) = subject(j).steps2hr;
        noise_i(j,inds) = subject(j).noise;
        autocorrelation_i(j,inds) = subject(j).autocorrelation;
        uncertainty_i(j,inds) = subject(j).uncertainty;
        daily_steps_i(j,inds) = subject(j).daily_steps;
        fatigue_i(j,inds_fatigue) = subject(j).daily_results_processed(:,2);
        lco_phase_i(j,inds_lco) = mod(subject(j).lco_phase,24);
        lco_amp_i(j,inds_lco) = subject(j).lco_amp;
        
    end 
    catch
    end 
end 


% take first 84 days 
mesors_i = mesors_i(:,1:84);
amps_i = amps_i(:,1:84);
uncertainty_i = uncertainty_i(:,1:84);
steps2hr_i = steps2hr_i(:,1:84);
noise_i = noise_i(:,1:84);
autocorrelation_i = autocorrelation_i(:,1:84);
fatigue_i = fatigue_i(:,1:84);
lco_amp_i = lco_amp_i(:,1:84);
lco_phase_i = lco_phase_i(:,1:84);
daily_steps_i = daily_steps_i(:,1:84);

mesors_c = mesors_c(:,1:84);
amps_c = amps_c(:,1:84);
uncertainty_c = uncertainty_c(:,1:84);
steps2hr_c = steps2hr_c(:,1:84);
noise_c = noise_c(:,1:84);
autocorrelation_c = autocorrelation_c(:,1:84);
fatigue_c = fatigue_c(:,1:84);
lco_amp_c = lco_amp_c(:,1:84);
lco_phase_c = lco_phase_c(:,1:84);
daily_steps_c = daily_steps_c(:,1:84);

nan_check_fatigue_c = sum(~isnan(fatigue_c));
nan_check_fatigue_i = sum(~isnan(fatigue_i));
nan_check_c = sum(~isnan(mesors_c));
nan_check_i = sum(~isnan(mesors_i));

% exclusion criteria, v1
exclude_indices_i = find(mesors_i >= 200 | steps2hr_i >= 5 | amps_i >= 20);
mesors_i(exclude_indices_i) = nan;
amps_i(exclude_indices_i) = nan;
phase_i(exclude_indices_i) = nan;
steps2hr_i(exclude_indices_i) = nan;
noise_i(exclude_indices_i) = nan;
autocorrelation_i(exclude_indices_i) = nan;

exclude_indices_c = find(mesors_c >= 200 | steps2hr_c >= 5 | amps_c >= 20);
mesors_c(exclude_indices_c) = nan;
amps_c(exclude_indices_c) = nan;
phase_c(exclude_indices_c) = nan;
steps2hr_c(exclude_indices_c) = nan;
noise_c(exclude_indices_c) = nan;
autocorrelation_c(exclude_indices_c) = nan;

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
[h_se_c, p_se_c] = ttest2(fatigue_start_c(:), fatigue_end_c(:));
[h_se_i, p_se_i] = ttest2(fatigue_start_i(:), fatigue_end_i(:));

% average by week
num_weeks = 12;

for j = 1:num_weeks
    
    week_inds = [(j-1)*7+1:j*7];
    fatigue_c_byweek(j,:) = nanmean(fatigue_c(:,week_inds)');
    fatigue_i_byweek(j,:) = nanmean(fatigue_i(:,week_inds)');

end 

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

subplot(2,2,4)
bar_mat = [mean_start_i_pop(1) - mean_end_i_pop(1) mean_start_i_pop(2) - mean_end_i_pop(2) mean_start_i_pop(3) - mean_end_i_pop(3); mean_start_c_pop(1) - mean_end_c_pop(1) mean_start_c_pop(2) - mean_end_c_pop(2) mean_start_c_pop(3) - mean_end_c_pop(3)];
bar(bar_mat)
ylabel('average decrease in daily fatigue')
%xticks([1.5, 3.5, 5.5])
xticklabels({'intervention','control'})
legend('BR','PR','AU')
title('Intervention and control changes in fatigue, first vs last week')
box off 
%% LCO stats
cutoff = 7;
lco_amp_start_c = lco_amp_c(:,1:cutoff);
lco_amp_start_i = lco_amp_i(:,1:cutoff);
lco_amp_end_c = lco_amp_c(:,end-cutoff+1:end);
lco_amp_end_i = lco_amp_i(:,end-cutoff+1:end);
mean_lco_amp_start_c = nanmean(lco_amp_start_c,'all');
mean_lco_amp_start_i = nanmean(lco_amp_start_i,'all');
mean_lco_amp_end_c = nanmean(lco_amp_end_c,'all');
mean_lco_amp_end_i = nanmean(lco_amp_end_i,'all');
sd_lco_amp_start_c = nanstd(lco_amp_start_c(:));
sd_lco_amp_start_i = nanstd(lco_amp_start_i(:));
sd_lco_amp_end_c = nanstd(lco_amp_end_c(:));
sd_lco_amp_end_i = nanstd(lco_amp_end_i(:));

% test statistical significance
[h_start_lco_amp, p_start_lco_amp] = ttest2(lco_amp_start_c(:), lco_amp_start_i(:));
[h_end_lco_amp, p_end_lco_amp] = ttest2(lco_amp_end_c(:), lco_amp_end_i(:));
[h_se_c_lco_amp, p_se_c_lco_amp] = ttest2(lco_amp_start_c(:), lco_amp_end_c(:));
[h_se_i_lco_amp, p_se_i_lco_amp] = ttest2(lco_amp_start_i(:), lco_amp_end_i(:));

% phase
lco_phase_start_c = lco_phase_c(:,1:cutoff);
lco_phase_start_i = lco_phase_i(:,1:cutoff);
lco_phase_end_c = lco_phase_c(:,end-cutoff+1:end);
lco_phase_end_i = lco_phase_i(:,end-cutoff+1:end);
mean_lco_phase_start_c = mod(circularAverage(lco_phase_start_c(~isnan(lco_phase_start_c))*(2*pi)/24)*24/(2*pi),24);
mean_lco_phase_start_i = mod(circularAverage(lco_phase_start_i(~isnan(lco_phase_start_i))*(2*pi)/24)*24/(2*pi),24);
mean_lco_phase_end_c = mod(circularAverage(lco_phase_end_c(~isnan(lco_phase_end_c))*(2*pi)/24)*24/(2*pi),24);
mean_lco_phase_end_i = mod(circularAverage(lco_phase_end_i(~isnan(lco_phase_end_i))*(2*pi)/24)*24/(2*pi),24);
sd_lco_phase_start_c = circularStandardDeviation(lco_phase_start_c(~isnan(lco_phase_start_c))*(2*pi)/24)*24/(2*pi);
sd_lco_phase_start_i = circularStandardDeviation(lco_phase_start_i(~isnan(lco_phase_start_i))*(2*pi)/24)*24/(2*pi);
sd_lco_phase_end_c = circularStandardDeviation(lco_phase_end_c(~isnan(lco_phase_end_c))*(2*pi)/24)*24/(2*pi);
sd_lco_phase_end_i = circularStandardDeviation(lco_phase_end_i(~isnan(lco_phase_end_i))*(2*pi)/24)*24/(2*pi);

% test statistical significance
[h_start_lco_phase, p_start_lco_phase] = ttest2(lco_phase_start_c(:), lco_phase_start_i(:));
[h_end_lco_phase, p_end_lco_phase] = ttest2(lco_phase_end_c(:), lco_phase_end_i(:));
[h_se_c_lco_phase, p_se_c_lco_phase] = ttest2(lco_phase_start_c(:), lco_phase_end_c(:));
[h_se_i_lco_phase, p_se_i_lco_phase] = ttest2(lco_phase_start_i(:), lco_phase_end_i(:));

%% look at HR params
figure()
set(gcf, 'Position',  [100, 100, 800, 600])
set(gcf,'color','w');
set(gca,'Visible','off')
set(0,'DefaultAxesTitleFontWeight','normal');
subplot(3,2,1)
plot(movmean(nanmean(mesors_c(:,nan_check_c >= 2)),7),'LineWidth',4)
hold on 
plot(movmean(nanmean(mesors_i(:,nan_check_i >= 2)),7),'LineWidth',4)
legend('control','intervention')
xlabel('day after beginning study')
ylabel('parameter')
title('Mesor','Fontsize',14)
box off 

subplot(3,2,2)
plot(movmean(nanmean(amps_c(:,nan_check_c >= 2)),7),'LineWidth',4)
hold on 
plot(movmean(nanmean(amps_i(:,nan_check_i >= 2)),7),'LineWidth',4)
xlabel('day after beginning study')
ylabel('parameter')
title('Amplitude','Fontsize',14)
box off 

subplot(3,2,4)
plot(movmean(nanmean(steps2hr_c(:,nan_check_c >= 2)),7),'LineWidth',4)
hold on 
plot(movmean(nanmean(steps2hr_i(:,nan_check_i >= 2)),7),'LineWidth',4)
xlabel('day after beginning study')
ylabel('parameter')
title('Steps2hr','Fontsize',14)
box off 

subplot(3,2,5)
plot(movmean(nanmean(noise_c(:,nan_check_c >= 2)),7),'LineWidth',4)
hold on 
plot(movmean(nanmean(noise_i(:,nan_check_i >= 2)),7),'LineWidth',4)
xlabel('day after beginning study')
ylabel('parameter')
title('Noise','Fontsize',14)
box off 

subplot(3,2,6)
plot(movmean(nanmean(autocorrelation_c(:,nan_check_c >= 2)),7),'LineWidth',4)
hold on 
plot(movmean(nanmean(autocorrelation_i(:,nan_check_i >= 2)),7),'LineWidth',4)
xlabel('day after beginning study')
ylabel('parameter')
title('Autocorrelation','Fontsize',14)
box off 

subplot(3,2,3)
plot(movmean(nanmean(uncertainty_c(:,nan_check_c >= 2)),7),'LineWidth',4)
hold on 
plot(movmean(nanmean(uncertainty_i(:,nan_check_i >= 2)),7),'LineWidth',4)
xlabel('day after beginning study')
ylabel('parameter')
title('Uncertainty','Fontsize',14)
box off 

%% daily steps stats
cutoff = 7;
daily_steps_start_c = daily_steps_c(:,1:cutoff);
daily_steps_start_i = daily_steps_i(:,1:cutoff);
daily_steps_end_c = daily_steps_c(:,end-cutoff+1:end);
daily_steps_end_i = daily_steps_i(:,end-cutoff+1:end);
mean_daily_steps_start_c = nanmean(daily_steps_start_c,'all');
mean_daily_steps_start_i = nanmean(daily_steps_start_i,'all');
mean_daily_steps_end_c = nanmean(daily_steps_end_c,'all');
mean_daily_steps_end_i = nanmean(daily_steps_end_i,'all');
sd_daily_steps_start_c = nanstd(daily_steps_start_c(:));
sd_daily_steps_start_i = nanstd(daily_steps_start_i(:));
sd_daily_steps_end_c = nanstd(daily_steps_end_c(:));
sd_daily_steps_end_i = nanstd(daily_steps_end_i(:));

% test statistical significance
[h_daily_steps_start, p_daily_steps_start] = ttest2(daily_steps_start_c(:), daily_steps_start_i(:));
[h_daily_steps_end, p_daily_steps_end] = ttest2(daily_steps_end_c(:), daily_steps_end_i(:));
[h_daily_steps_se_c, p_daily_steps_se_c] = ttest2(daily_steps_start_c(:), daily_steps_end_c(:));
[h_daily_steps_se_i, p_daily_steps_se_i] = ttest2(daily_steps_start_i(:), daily_steps_end_i(:));

%% make cleaner daily fatigue figure
num_rows = length(fatigue_c(:,1));
num_days = length(fatigue_c(1,:));
pre_inds = 1:cutoff;
post_inds = num_days - cutoff + 1:num_days;

for j = 1:num_rows
    
    if sum(~isnan(fatigue_c(j,:))) >= 14

        pre_con_avg_fatigue(j) = nanmean(fatigue_c(j, pre_inds));
        post_con_avg_fatigue(j) = nanmean(fatigue_c(j, post_inds));

    end 

    if sum(~isnan(fatigue_i(j,:))) >= 14

        pre_int_avg_fatigue(j) = nanmean(fatigue_i(j, pre_inds));
        post_int_avg_fatigue(j) = nanmean(fatigue_i(j, post_inds));

    end 

end 

% process the fatigue survey results 
pre_post_con_fatigue = [pre_con_avg_fatigue' post_con_avg_fatigue'];
pre_post_int_fatigue = [pre_int_avg_fatigue' post_int_avg_fatigue'];
con_nans_row = sum(~isnan(pre_post_con_fatigue)');
int_nans_row = sum(~isnan(pre_post_int_fatigue)');
good_con_inds = find(con_nans_row == 2);
good_int_inds = find(int_nans_row == 2);
pre_post_con_fatigue = pre_post_con_fatigue(good_con_inds,:);
pre_post_int_fatigue = pre_post_int_fatigue(good_int_inds,:);

figure()
set(gcf, 'Position',  [100, 100, 1000, 400])
set(gcf,'color','w');
set(gca,'Visible','off')
set(0,'DefaultAxesTitleFontWeight','normal');
subplot(2,2,[1,2])
y_fatigue = [mean(pre_post_int_fatigue(:,1)); mean(pre_post_con_fatigue(:,1));mean(pre_post_int_fatigue(:,2)); mean(pre_post_con_fatigue(:,2))];
bar(y_fatigue, 'k')
xlabel('group')
xticklabels({'int., pre','con., pre','int., post', 'con., post'})
ylabel('mean daily fatigue')
title('Daily Fatigue Surveys','FontSize',16)
box off

subplot(2,2,3)
%tscore_change_con_int = [control_tscore_start - control_tscore_end; int_tscore_start - int_tscore_end];
scatter(1:length(pre_post_con_fatigue(:,1)), pre_post_con_fatigue(:,1) - pre_post_con_fatigue(:,2))
hold on 
scatter(length(pre_post_con_fatigue(:,1))+1:length(pre_post_con_fatigue(:,1))+length(pre_post_int_fatigue(:,1)), pre_post_int_fatigue(:,1) - pre_post_int_fatigue(:,2))
legend('control','intervention')
xlabel('individual')
ylabel('pre - post')
title('Change in Fatigue Score from Pre to Post')

subplot(2,2,4)
fatigue_change_con = pre_post_con_fatigue(:,1) - pre_post_con_fatigue(:,2);
fatigue_change_int = pre_post_int_fatigue(:,1) - pre_post_int_fatigue(:,2);
histogram(fatigue_change_con)
hold on 
histogram(fatigue_change_int)
legend('control','intervention')
%xticklabels({'increase or same fatigue','decrease of less than 2', 'decrease of at least 2'})
xlabel('daily pre - post fatigue score')
ylabel('count')
title('Change in Fatigue')
box off 



