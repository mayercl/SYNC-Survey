clear; clc;
close all;

%% load the data
figure_display = 'on';
% format: first two cols are anxiety, then depression, then phys func, then
% sleep disturbance, then global phys health, then global mental health
imputed_prepost_table1 = readtable('imputed_datasets/imputed_split_prepost_promis_dataset_1.csv');
imputed_prepost_table2 = readtable('imputed_datasets/imputed_split_prepost_promis_dataset_2.csv');
imputed_prepost_table3 = readtable('imputed_datasets/imputed_split_prepost_promis_dataset_3.csv');
imputed_prepost_table4 = readtable('imputed_datasets/imputed_split_prepost_promis_dataset_4.csv');
imputed_prepost_table5 = readtable('imputed_datasets/imputed_split_prepost_promis_dataset_5.csv');
imputed_prepost_dataset{1} = table2array(imputed_prepost_table1(:,1:end-1));
imputed_prepost_dataset{2} = table2array(imputed_prepost_table2(:,1:end-1));
imputed_prepost_dataset{3} = table2array(imputed_prepost_table3(:,1:end-1));
imputed_prepost_dataset{4} = table2array(imputed_prepost_table4(:,1:end-1));
imputed_prepost_dataset{5} = table2array(imputed_prepost_table5(:,1:end-1));

load('subject.mat'); % for int/con info
for j = 1:length(subject)
    
    subject_name(j) = subject(j).name;
    subject_con_int(j) = subject(j).exp_con;
    subject_ids(j) = subject(j).patient_id;

end 

for j = 1:length(imputed_prepost_dataset{1}(:,1))

    subject_id = imputed_prepost_table1.subject_id{j};
    index = find(strcmp(subject_id,subject_ids));
    tscore_con_int(j) = subject_con_int(index);
    
end 

%% analyze and format the data 
imputed_prepost_total = (imputed_prepost_dataset{1}+imputed_prepost_dataset{2}+imputed_prepost_dataset{3}+imputed_prepost_dataset{4}+imputed_prepost_dataset{5})/5;
anx_tscore_pre = imputed_prepost_total(:,1);
anx_tscore_post = imputed_prepost_total(:,2);
dep_tscore_pre = imputed_prepost_total(:,3);
dep_tscore_post = imputed_prepost_total(:,4);
pf_tscore_pre = imputed_prepost_total(:,5);
pf_tscore_post = imputed_prepost_total(:,6);
sd_tscore_pre = imputed_prepost_total(:,7);
sd_tscore_post = imputed_prepost_total(:,8);
gph_tscore_pre = imputed_prepost_total(:,9);
gph_tscore_post = imputed_prepost_total(:,10);
gmh_tscore_pre = imputed_prepost_total(:,11);
gmh_tscore_post = imputed_prepost_total(:,12);

num_datasets = 5;
for j = 1:num_datasets
    
    anx_int_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,1));
    anx_int_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,2));
    dep_int_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,3));
    dep_int_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,4));
    pf_int_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,5));
    pf_int_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,6));
    sd_int_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,7));
    sd_int_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,8));
    gph_int_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,9));
    gph_int_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,10));
    gmh_int_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,11));
    gmh_int_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 1,12));

    anx_con_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,1));
    anx_con_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,2));
    dep_con_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,3));
    dep_con_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,4));
    pf_con_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,5));
    pf_con_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,6));
    sd_con_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,7));
    sd_con_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,8));
    gph_con_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,9));
    gph_con_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,10));
    gmh_con_pre_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,11));
    gmh_con_post_mean(j) = mean(imputed_prepost_dataset{j}(tscore_con_int == 0,12));

    % significance tests on individual imputations
    [h_anx_start(j),p_anx_start(j),ci_anx_start(j,:), stats_anx_start{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,1),imputed_prepost_dataset{j}(tscore_con_int == 0,1));
    [h_anx_end(j),p_anx_end(j),ci_anx_end(j,:), stats_anx_end{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,2),imputed_prepost_dataset{j}(tscore_con_int == 0,2));
    [h_anx_int(j),p_anx_int(j),ci_anx_int(j,:), stats_anx_int{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 1,1),imputed_prepost_dataset{j}(tscore_con_int == 1,2));
    [h_anx_con(j),p_anx_con(j),ci_anx_con(j,:), stats_anx_con{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 0,1),imputed_prepost_dataset{j}(tscore_con_int == 0,2));

    tstats_start_anx(j) = stats_anx_start{j}.tstat;
    tstats_end_anx(j) = stats_anx_end{j}.tstat;
    tstats_int_anx(j) = stats_anx_int{j}.tstat;
    tstats_con_anx(j) = stats_anx_con{j}.tstat;

    [h_dep_start(j),p_dep_start(j),ci_dep_start(j,:), stats_dep_start{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,3),imputed_prepost_dataset{j}(tscore_con_int == 0,3));
    [h_dep_end(j),p_dep_end(j),ci_dep_end(j,:), stats_dep_end{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,4),imputed_prepost_dataset{j}(tscore_con_int == 0,4));
    [h_dep_int(j),p_dep_int(j),ci_dep_int(j,:), stats_dep_int{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 1,3),imputed_prepost_dataset{j}(tscore_con_int == 1,4));
    [h_dep_con(j),p_dep_con(j),ci_dep_con(j,:), stats_dep_con{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 0,3),imputed_prepost_dataset{j}(tscore_con_int == 0,4));
    
    tstats_start_dep(j) = stats_dep_start{j}.tstat;
    tstats_end_dep(j) = stats_dep_end{j}.tstat;
    tstats_int_dep(j) = stats_dep_int{j}.tstat;
    tstats_con_dep(j) = stats_dep_con{j}.tstat;

    [h_pf_start(j),p_pf_start(j),ci_pf_start(j,:), stats_pf_start{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,5),imputed_prepost_dataset{j}(tscore_con_int == 0,5));
    [h_pf_end(j),p_pf_end(j),ci_pf_end(j,:), stats_pf_end{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,6),imputed_prepost_dataset{j}(tscore_con_int == 0,6));
    [h_pf_int(j),p_pf_int(j),ci_pf_int(j,:), stats_pf_int{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 1,5),imputed_prepost_dataset{j}(tscore_con_int == 1,6));
    [h_pf_con(j),p_pf_con(j),ci_pf_con(j,:), stats_pf_con{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 0,5),imputed_prepost_dataset{j}(tscore_con_int == 0,6));
    
    tstats_start_pf(j) = stats_pf_start{j}.tstat;
    tstats_end_pf(j) = stats_pf_end{j}.tstat;
    tstats_int_pf(j) = stats_pf_int{j}.tstat;
    tstats_con_pf(j) = stats_pf_con{j}.tstat;

    [h_sd_start(j),p_sd_start(j),ci_sd_start(j,:), stats_sd_start{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,7),imputed_prepost_dataset{j}(tscore_con_int == 0,7));
    [h_sd_end(j),p_sd_end(j),ci_sd_end(j,:), stats_sd_end{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,8),imputed_prepost_dataset{j}(tscore_con_int == 0,8));
    [h_sd_int(j),p_sd_int(j),ci_sd_int(j,:), stats_sd_int{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 1,7),imputed_prepost_dataset{j}(tscore_con_int == 1,8));
    [h_sd_con(j),p_sd_con(j),ci_sd_con(j,:), stats_sd_con{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 0,7),imputed_prepost_dataset{j}(tscore_con_int == 0,8));
    
    tstats_start_sd(j) = stats_sd_start{j}.tstat;
    tstats_end_sd(j) = stats_sd_end{j}.tstat;
    tstats_int_sd(j) = stats_sd_int{j}.tstat;
    tstats_con_sd(j) = stats_sd_con{j}.tstat;

    [h_gph_start(j),p_gph_start(j),ci_gph_start(j,:), stats_gph_start{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,9),imputed_prepost_dataset{j}(tscore_con_int == 0,9));
    [h_gph_end(j),p_gph_end(j),ci_gph_end(j,:), stats_gph_end{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,10),imputed_prepost_dataset{j}(tscore_con_int == 0,10));
    [h_gph_int(j),p_gph_int(j),ci_gph_int(j,:), stats_gph_int{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 1,9),imputed_prepost_dataset{j}(tscore_con_int == 1,10));
    [h_gph_con(j),p_gph_con(j),ci_gph_con(j,:), stats_gph_con{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 0,9),imputed_prepost_dataset{j}(tscore_con_int == 0,10));
    
    tstats_start_gph(j) = stats_gph_start{j}.tstat;
    tstats_end_gph(j) = stats_gph_end{j}.tstat;
    tstats_int_gph(j) = stats_gph_int{j}.tstat;
    tstats_con_gph(j) = stats_gph_con{j}.tstat;

    [h_gmh_start(j),p_gmh_start(j),ci_gmh_start(j,:), stats_gmh_start{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,11),imputed_prepost_dataset{j}(tscore_con_int == 0,11));
    [h_gmh_end(j),p_gmh_end(j),ci_gmh_end(j,:), stats_gmh_end{j}] = ttest2(imputed_prepost_dataset{j}(tscore_con_int == 1,12),imputed_prepost_dataset{j}(tscore_con_int == 0,12));
    [h_gmh_int(j),p_gmh_int(j),ci_gmh_int(j,:), stats_gmh_int{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 1,11),imputed_prepost_dataset{j}(tscore_con_int == 1,12));
    [h_gmh_con(j),p_gmh_con(j),ci_gmh_con(j,:), stats_gmh_con{j}] = ttest(imputed_prepost_dataset{j}(tscore_con_int == 0,11),imputed_prepost_dataset{j}(tscore_con_int == 0,12));
    
    tstats_start_gmh(j) = stats_gmh_start{j}.tstat;
    tstats_end_gmh(j) = stats_gmh_end{j}.tstat;
    tstats_int_gmh(j) = stats_gmh_int{j}.tstat;
    tstats_con_gmh(j) = stats_gmh_con{j}.tstat;

end 

% perform the statistical analyses: rubin's rules 
[p_value_pooled_anx_end, ~, ~] = rubin_pool(anx_int_post_mean, anx_con_post_mean, tstats_end_anx, num_datasets);
[p_value_pooled_anx_start, ~, ~] = rubin_pool(anx_int_pre_mean, anx_con_pre_mean, tstats_start_anx, num_datasets);
[p_value_pooled_anx_int, ~, ~] = rubin_pool(anx_int_pre_mean, anx_int_post_mean, tstats_int_anx, num_datasets);
[p_value_pooled_anx_con, ~, ~] = rubin_pool(anx_con_pre_mean, anx_con_post_mean, tstats_con_anx, num_datasets);

[p_value_pooled_dep_end, ~, ~] = rubin_pool(dep_int_post_mean, dep_con_post_mean, tstats_end_dep, num_datasets);
[p_value_pooled_dep_start, ~, ~] = rubin_pool(dep_int_pre_mean, dep_con_pre_mean, tstats_start_dep, num_datasets);
[p_value_pooled_dep_int, ~, ~] = rubin_pool(dep_int_pre_mean, dep_int_post_mean, tstats_int_dep, num_datasets);
[p_value_pooled_dep_con, ~, ~] = rubin_pool(dep_con_pre_mean, dep_con_post_mean, tstats_con_dep, num_datasets);

[p_value_pooled_pf_end, ~, ~] = rubin_pool(pf_int_post_mean, pf_con_post_mean, tstats_end_pf, num_datasets);
[p_value_pooled_pf_start, ~, ~] = rubin_pool(pf_int_pre_mean, pf_con_pre_mean, tstats_start_pf, num_datasets);
[p_value_pooled_pf_int, ~, ~] = rubin_pool(pf_int_pre_mean, pf_int_post_mean, tstats_int_pf, num_datasets);
[p_value_pooled_pf_con, ~, ~] = rubin_pool(pf_con_pre_mean, pf_con_post_mean, tstats_con_pf, num_datasets);

[p_value_pooled_sd_end, ~, ~] = rubin_pool(sd_int_post_mean, sd_con_post_mean, tstats_end_sd, num_datasets);
[p_value_pooled_sd_start, ~, ~] = rubin_pool(sd_int_pre_mean, sd_con_pre_mean, tstats_start_sd, num_datasets);
[p_value_pooled_sd_int, ~, ~] = rubin_pool(sd_int_pre_mean, sd_int_post_mean, tstats_int_sd, num_datasets);
[p_value_pooled_sd_con, ~, ~] = rubin_pool(sd_con_pre_mean, sd_con_post_mean, tstats_con_sd, num_datasets);

[p_value_pooled_gph_end, ~, ~] = rubin_pool(gph_int_post_mean, gph_con_post_mean, tstats_end_gph, num_datasets);
[p_value_pooled_gph_start, ~, ~] = rubin_pool(gph_int_pre_mean, gph_con_pre_mean, tstats_start_gph, num_datasets);
[p_value_pooled_gph_int, ~, ~] = rubin_pool(gph_int_pre_mean, gph_int_post_mean, tstats_int_gph, num_datasets);
[p_value_pooled_gph_con, ~, ~] = rubin_pool(gph_con_pre_mean, gph_con_post_mean, tstats_con_gph, num_datasets);

[p_value_pooled_gmh_end, ~, ~] = rubin_pool(gmh_int_post_mean, gmh_con_post_mean, tstats_end_gmh, num_datasets);
[p_value_pooled_gmh_start, ~, ~] = rubin_pool(gmh_int_pre_mean, gmh_con_pre_mean, tstats_start_gmh, num_datasets);
[p_value_pooled_gmh_int, ~, ~] = rubin_pool(gmh_int_pre_mean, gmh_int_post_mean, tstats_int_gmh, num_datasets);
[p_value_pooled_gmh_con, ~, ~] = rubin_pool(gmh_con_pre_mean, gmh_con_post_mean, tstats_con_gmh, num_datasets);

% other means and sds values: 
% mean(sd_tscore_pre(tscore_con_int == 1))
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
    
    nIDs = 6;
    alphabet = ('A':'Z').';
    chars = num2cell(alphabet(1:nIDs));
    chars = chars.';
    charlbl = chars;%strcat('(',chars,')'); % {'(a)','(b)','(c)','(d)'}

    figure()
    set(gcf, 'Position',  [100, 100, 1000, 600])
    set(gcf,'color','w');
    set(gca,'Visible','off')
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,3,1)
    anx_tscore_bp = [anx_tscore_pre; anx_tscore_post];
    g = [tscore_con_int'; tscore_con_int' + 2];
    boxplot(anx_tscore_bp, g,'color','k')
    yt = get(gca, 'YTick');
    axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');
    hold on
    plot(xt([1 3]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 3])), max(yt)*1.15, '*k')
    hold off
    box off 
    ylim([min(anx_tscore_bp) - 5, max(yt)*1.15])
    xticklabels({'Int, pre','Con, pre', 'Int, post','Cont, post'})
    ylabel('Tscore')
    title('Anxiety','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.95,charlbl{1},'Units','normalized','FontSize',16)

    subplot(2,3,2)
    dep_tscore_bp = [dep_tscore_pre; dep_tscore_post];
    g = [tscore_con_int'; tscore_con_int' + 2];
    boxplot(dep_tscore_bp, g,'color','k')
    yt = get(gca, 'YTick');
    axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');
    hold on
    plot(xt([2 4]), [1 1]*max(yt)*1.1, '-k',  mean(xt([2 4])), max(yt)*1.15, '*k')
    hold off
    box off 
    ylim([min(dep_tscore_bp) - 5, max(yt)*1.15])
    xticklabels({'Int, pre','Con, pre', 'Int, post','Con, post'})
    ylabel('Tscore')
    title('Depression','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.99,charlbl{2},'Units','normalized','FontSize',16)

    subplot(2,3,3)
    gph_tscore_bp = [gph_tscore_pre; gph_tscore_post];
    g = [tscore_con_int'; tscore_con_int' + 2];
    boxplot(gph_tscore_bp, g,'color','k')
    box off 
    yt = get(gca, 'YTick');
    ylim([min(gph_tscore_bp) - 5, max(yt)*1.15])
    xticklabels({'Int, pre','Con, pre', 'Int, post','Con, post'})
    ylabel('Tscore')
    title('Global physical health','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.99,charlbl{3},'Units','normalized','FontSize',16)

    subplot(2,3,4)
    gmh_tscore_bp = [gmh_tscore_pre; gmh_tscore_post];
    g = [tscore_con_int'; tscore_con_int' + 2];
    boxplot(gmh_tscore_bp, g,'color','k')
    box off
    yt = get(gca, 'YTick');
    ylim([min(gmh_tscore_bp) - 5, max(yt)*1.15])
    xticklabels({'Int, pre','Con, pre', 'Int, post','Con, post'})
    ylabel('Tscore')
    title('Global mental health','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.99,charlbl{4},'Units','normalized','FontSize',16)

    subplot(2,3,5)
    pf_tscore_bp = [pf_tscore_pre; pf_tscore_post];
    g = [tscore_con_int'; tscore_con_int' + 2];
    boxplot(pf_tscore_bp, g,'color','k')
    box off 
    yt = get(gca, 'YTick');
    ylim([min(pf_tscore_bp) - 5, max(yt)*1.15])
    xticklabels({'Int, pre','Con, pre', 'Int, post','Con, post'})
    ylabel('Tscore')
    title('Physical function','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.99,charlbl{5},'Units','normalized','FontSize',16)

    subplot(2,3,6)
    sd_tscore_bp = [sd_tscore_pre; sd_tscore_post];
    g = [tscore_con_int'; tscore_con_int' + 2];
    boxplot(sd_tscore_bp, g,'color','k')
    yt = get(gca, 'YTick');
    axis([xlim    0  ceil(max(yt)*1.2)])
    xt = get(gca, 'XTick');
    hold on
    plot(xt([1 3]), [1 1]*max(yt)*1.1, '-k',  mean(xt([1 3])), max(yt)*1.15, '*k')
    hold off
    box off 
    ylim([min(sd_tscore_bp) - 5, max(yt)*1.15])
    xticklabels({'Int, pre','Con, pre', 'Int, post','Con, post'})
    ylabel('Tscore')
    title('Sleep disturbance','FontSize',16)
    ax = gca;
    ax.FontSize = 16;
    text(0.025,0.99,charlbl{6},'Units','normalized','FontSize',16)

end 
% look at statistical significance, e.g.,: 
%[h,p] = ttest2(anx_tscore_pre(tscore_con_int == 1),anx_tscore_pre(tscore_con_int == 0))
% [h,p] = ttest(anx_tscore_pre(tscore_con_int == 1),anx_tscore_post(tscore_con_int == 1))

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
