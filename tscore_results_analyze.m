clear; clc;
close all;

%% load the data
figure_display = 'off';
filepath = 'tscores_surveys/';

% load the PROMIS tables from HealthMeasures website 
anxiety_table = readtable([filepath 'anxiety_v1.csv'],NumHeaderLines = 4);
depression_table = readtable([filepath 'depression_v1.csv'],NumHeaderLines = 4);
global_health_table = readtable([filepath 'global_health_v1.csv'],NumHeaderLines = 4);
physical_function_table = readtable([filepath 'physical_function_v1.csv'],NumHeaderLines = 4);
sleep_disturb_table = readtable([filepath 'sleep_disturb_v1.csv'],NumHeaderLines = 4);

%% analyze and format the data 
load('subject.mat'); % for int/con info

for j = 1:length(subject)
    
    subject_name(j) = subject(j).name;
    subject_con_int(j) = subject(j).exp_con;

end 

% restrict to individuals with a pre and post survey
pre_pins = unique(anxiety_table.PIN(anxiety_table.Assmnt == 1));
post_pins = unique(anxiety_table.PIN(anxiety_table.Assmnt == 2));
pins_both = intersect(pre_pins, post_pins);

% iterate through individuals with a pre and post survey
for j = 1:length(pins_both)

    individual_pin = pins_both{j};
    index = find(strcmp(individual_pin, subject_name));
    tscore_con_int(j) = subject_con_int(index);

    individual_anx_inds = find(strcmp(anxiety_table.PIN, individual_pin));
    individual_dep_inds = find(strcmp(depression_table.PIN, individual_pin));
    individual_gh_inds = find(strcmp(global_health_table.PIN, individual_pin));
    individual_pf_inds = find(strcmp(physical_function_table.PIN, individual_pin));
    individual_sd_inds = find(strcmp(sleep_disturb_table.PIN, individual_pin));
    
    anx_tscore_pre(j) = anxiety_table.TScore(individual_anx_inds(1)); % assumes first index is pre, second post 
    anx_tscore_post(j) = anxiety_table.TScore(individual_anx_inds(2));
    dep_tscore_pre(j) = depression_table.TScore(individual_dep_inds(1));
    dep_tscore_post(j) = depression_table.TScore(individual_dep_inds(2));
    gph_tscore_pre(j) = global_health_table.TScore(individual_gh_inds(1));
    gph_tscore_post(j) = global_health_table.TScore(individual_gh_inds(3));
    gmh_tscore_pre(j) = global_health_table.TScore(individual_gh_inds(2));
    gmh_tscore_post(j) = global_health_table.TScore(individual_gh_inds(4));
    pf_tscore_pre(j) = physical_function_table.TScore(individual_pf_inds(1));
    pf_tscore_post(j) = physical_function_table.TScore(individual_pf_inds(2));
    sd_tscore_pre(j) = sleep_disturb_table.TScore(individual_sd_inds(1));
    sd_tscore_post(j) = sleep_disturb_table.TScore(individual_sd_inds(2));

    % store data to subject
    subject(index).anx_tscore_pre = anx_tscore_pre(j);
    subject(index).anx_tscore_post = anx_tscore_post(j);
    subject(index).dep_tscore_pre = dep_tscore_pre(j);
    subject(index).dep_tscore_post = dep_tscore_post(j);
    subject(index).gph_tscore_pre = gph_tscore_pre(j);
    subject(index).gph_tscore_post = gph_tscore_post(j);
    subject(index).gmh_tscore_pre = gmh_tscore_pre(j);
    subject(index).gmh_tscore_post = gmh_tscore_post(j);
    subject(index).pf_tscore_pre = pf_tscore_pre(j);
    subject(index).pf_tscore_post = pf_tscore_post(j);
    subject(index).sd_tscore_pre = sd_tscore_pre(j);
    subject(index).sd_tscore_post = sd_tscore_post(j);


end 

%% visualize the data
if strcmp(figure_display,'on')

    figure()
    set(gcf, 'Position',  [100, 100, 1000, 400])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,3,1)
    y = [mean(anx_tscore_pre(tscore_con_int == 1)), mean(anx_tscore_pre(tscore_con_int == 0)),mean(anx_tscore_post(tscore_con_int == 1)), mean(anx_tscore_post(tscore_con_int == 0))];
    bar(y,'k')
    box off 
    ylim([min(y) - 10, max(y)+5])
    xticklabels({'Intervention, pre','Control, pre', 'Intervention, post','Control, post'})
    ylabel('Tscore')
    title('Anxiety','FontSize',16)
    
    subplot(2,3,2)
    y = [mean(dep_tscore_pre(tscore_con_int == 1)), mean(dep_tscore_pre(tscore_con_int == 0)),mean(dep_tscore_post(tscore_con_int == 1)), mean(dep_tscore_post(tscore_con_int == 0))];
    bar(y,'k')
    box off 
    ylim([min(y) - 10, max(y)+5])
    xticklabels({'Intervention, pre','Control, pre', 'Intervention, post','Control, post'})
    ylabel('Tscore')
    title('Depression','FontSize',16)
    
    subplot(2,3,3)
    y = [mean(gph_tscore_pre(tscore_con_int == 1)), mean(gph_tscore_pre(tscore_con_int == 0)),mean(gph_tscore_post(tscore_con_int == 1)), mean(gph_tscore_post(tscore_con_int == 0))];
    bar(y,'k')
    box off 
    ylim([min(y) - 10, max(y)+5])
    xticklabels({'Intervention, pre','Control, pre', 'Intervention, post','Control, post'})
    ylabel('Tscore')
    title('Global physical health','FontSize',16)
    
    subplot(2,3,4)
    y = [mean(gmh_tscore_pre(tscore_con_int == 1)), mean(gmh_tscore_pre(tscore_con_int == 0)),mean(gmh_tscore_post(tscore_con_int == 1)), mean(gmh_tscore_post(tscore_con_int == 0))];
    bar(y,'k')
    box off 
    ylim([min(y) - 10, max(y)+5])
    xticklabels({'Intervention, pre','Control, pre', 'Intervention, post','Control, post'})
    ylabel('Tscore')
    title('Global mental health','FontSize',16)
    
    subplot(2,3,5)
    y = [mean(pf_tscore_pre(tscore_con_int == 1)), mean(pf_tscore_pre(tscore_con_int == 0)),mean(pf_tscore_post(tscore_con_int == 1)), mean(pf_tscore_post(tscore_con_int == 0))];
    bar(y,'k')
    box off 
    ylim([min(y) - 10, max(y)+5])
    xticklabels({'Intervention, pre','Control, pre', 'Intervention, post','Control, post'})
    ylabel('Tscore')
    title('Physical function','FontSize',16)
    
    subplot(2,3,6)
    y = [mean(sd_tscore_pre(tscore_con_int == 1)), mean(sd_tscore_pre(tscore_con_int == 0)),mean(sd_tscore_post(tscore_con_int == 1)), mean(sd_tscore_post(tscore_con_int == 0))];
    bar(y,'k')
    box off 
    ylim([min(y) - 10, max(y)+5])
    xticklabels({'Intervention, pre','Control, pre', 'Intervention, post','Control, post'})
    ylabel('Tscore')
    title('Sleep disturbance','FontSize',16)
    
    % more visuals 
    figure()
    set(gcf, 'Position',  [100, 100, 800, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    anx_tscore_int_mat = [anx_tscore_pre(tscore_con_int == 1)' anx_tscore_post(tscore_con_int == 1)'];
    anx_tscore_con_mat = [anx_tscore_pre(tscore_con_int == 0)' anx_tscore_post(tscore_con_int == 0)'];
    
    for j = 1:sum(tscore_con_int == 1)
    
        plot(anx_tscore_int_mat(j,:), 'r')
        hold on 
    
    end 
    for j = 1:sum(tscore_con_int == 0)
    
        plot(anx_tscore_con_mat(j,:), 'b')
        hold on 
    
    end 
    
    box off 
    xticks([1,2])
    xticklabels({'pre','post'})
    ylabel('Tscore')
    title('Anxiety','FontSize',16)
    
    figure()
    set(gcf, 'Position',  [100, 100, 800, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    dep_tscore_int_mat = [dep_tscore_pre(tscore_con_int == 1)' dep_tscore_post(tscore_con_int == 1)'];
    dep_tscore_con_mat = [dep_tscore_pre(tscore_con_int == 0)' dep_tscore_post(tscore_con_int == 0)'];
    
    for j = 1:sum(tscore_con_int == 1)
    
        plot(dep_tscore_int_mat(j,:), 'r')
        hold on 
    
    end 
    for j = 1:sum(tscore_con_int == 0)
    
        plot(dep_tscore_con_mat(j,:), 'b')
        hold on 
    
    end 
    
    box off 
    xticks([1,2])
    xticklabels({'pre','post'})
    ylabel('Tscore')
    title('Depression','FontSize',16)
    
    figure()
    set(gcf, 'Position',  [100, 100, 800, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    gph_tscore_int_mat = [gph_tscore_pre(tscore_con_int == 1)' gph_tscore_post(tscore_con_int == 1)'];
    gph_tscore_con_mat = [gph_tscore_pre(tscore_con_int == 0)' gph_tscore_post(tscore_con_int == 0)'];
    
    for j = 1:sum(tscore_con_int == 1)
    
        plot(gph_tscore_int_mat(j,:), 'r')
        hold on 
    
    end 
    for j = 1:sum(tscore_con_int == 0)
    
        plot(gph_tscore_con_mat(j,:), 'b')
        hold on 
    
    end 
    
    box off 
    xticks([1,2])
    xticklabels({'pre','post'})
    ylabel('Tscore')
    title('Global physical health','FontSize',16)
    
    figure()
    set(gcf, 'Position',  [100, 100, 800, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    gmh_tscore_int_mat = [gmh_tscore_pre(tscore_con_int == 1)' gmh_tscore_post(tscore_con_int == 1)'];
    gmh_tscore_con_mat = [gmh_tscore_pre(tscore_con_int == 0)' gmh_tscore_post(tscore_con_int == 0)'];
    
    for j = 1:sum(tscore_con_int == 1)
    
        plot(gmh_tscore_int_mat(j,:), 'r')
        hold on 
    
    end 
    for j = 1:sum(tscore_con_int == 0)
    
        plot(gmh_tscore_con_mat(j,:), 'b')
        hold on 
    
    end 
    
    box off 
    xticks([1,2])
    xticklabels({'pre','post'})
    ylabel('Tscore')
    title('Global mental health','FontSize',16)
    
    figure()
    set(gcf, 'Position',  [100, 100, 800, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    pf_tscore_int_mat = [pf_tscore_pre(tscore_con_int == 1)' pf_tscore_post(tscore_con_int == 1)'];
    pf_tscore_con_mat = [pf_tscore_pre(tscore_con_int == 0)' pf_tscore_post(tscore_con_int == 0)'];
    
    for j = 1:sum(tscore_con_int == 1)
    
        plot(pf_tscore_int_mat(j,:), 'r')
        hold on 
    
    end 
    for j = 1:sum(tscore_con_int == 0)
    
        plot(pf_tscore_con_mat(j,:), 'b')
        hold on 
    
    end 
    
    box off 
    xticks([1,2])
    xticklabels({'pre','post'})
    ylabel('Tscore')
    title('Physical function','FontSize',16)
    
    figure()
    set(gcf, 'Position',  [100, 100, 800, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    sd_tscore_int_mat = [sd_tscore_pre(tscore_con_int == 1)' sd_tscore_post(tscore_con_int == 1)'];
    sd_tscore_con_mat = [sd_tscore_pre(tscore_con_int == 0)' sd_tscore_post(tscore_con_int == 0)'];
    
    for j = 1:sum(tscore_con_int == 1)
    
        plot(sd_tscore_int_mat(j,:), 'r')
        hold on 
    
    end 
    for j = 1:sum(tscore_con_int == 0)
    
        plot(sd_tscore_con_mat(j,:), 'b')
        hold on 
    
    end 
    
    box off 
    xticks([1,2])
    xticklabels({'pre','post'})
    ylabel('Tscore')
    title('Sleep disturbance','FontSize',16)

end 
% look at statistical significance, e.g., 
%[h,p] = ttest2(anx_tscore_pre(tscore_con_int == 1),anx_tscore_pre(tscore_con_int == 0))
% [h,p] = ttest(anx_tscore_pre(tscore_con_int == 1),anx_tscore_post(tscore_con_int == 1))
