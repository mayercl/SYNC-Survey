function [weekly_fatigue_tscore_matrix, daily_fatigue_matrix, pre_fatigue, post_fatigue, int_con] = format_subject(subject)

% given subject, a matlab structure with fields including exp_con (0 for
% control and 1 for intervention), weekly (a table with the weekly survey
% data), weekly_tscore (a matrix with the weekly tscore info),
% daily_results_processed (a matrix with the daily fatigue scores), pre,
% and post, this function returns formatted matrices for weekly, faily,
% pre, post fatigue, as well as a intervention/control indicator vector

num_weeks = 11;
num_days = 84;
weekly_fatigue_tscore_matrix = nan(length(subject),num_weeks);
daily_fatigue_matrix = nan(length(subject), num_days);

for j = 1:length(subject)
    
    int_con(j) = subject(j).exp_con;

    if ~isempty(subject(j).weekly)

        weekly_dates = datenum(subject(j).weekly.dates);
        weekly_tscores = subject(j).weekly_tscore(:,1);
    
        if length(weekly_dates) ~= length(weekly_tscores)
        
            disp('Error: date and data lengths do not align')
    
    
        end 

        start_date_subject = min(weekly_dates);
        %diff(weekly_dates)
        datenums_scaled = (weekly_dates - start_date_subject)/7;
        indices = round(datenums_scaled) + 1;
        indices = indices(indices <= num_weeks);
        weekly_fatigue_tscore_matrix(j,indices) = weekly_tscores(1:length(indices));

    end 

    % daily 
    if ~isempty(subject(j).daily_results_processed)

        daily_dates = datenum(datetime(subject(j).daily_results_processed(:,1),'convertfrom','posixtime','timezone','local'));
        daily_scores = subject(j).daily_results_processed(:,2);
        start_date_subject = min(daily_dates);
        %diff(weekly_dates)
        datenums_scaled = daily_dates - start_date_subject;
        indices = round(datenums_scaled) + 1;
        indices = indices(indices <= num_days);
        daily_fatigue_matrix(j,indices) = daily_scores(1:length(indices));

    end 

    % pre fatigue 
    if ~isempty(subject(j).pre)

        pre_fatigue_str = subject(j).pre.Global08r;
    
            if strcmp(pre_fatigue_str,'None')
    
                pre_fatigue(j) = 0;
    
            elseif strcmp(pre_fatigue_str,'Mild')
    
                pre_fatigue(j) = 1;
    
            elseif strcmp(pre_fatigue_str,'Moderate')
    
                pre_fatigue(j) = 2;
    
            elseif strcmp(pre_fatigue_str,'Severe')
    
                pre_fatigue(j) = 3;
    
            elseif strcmp(pre_fatigue_str,'Very Severe')
    
                pre_fatigue(j) = 4;
    
            end 
    else 

        pre_fatigue(j) = nan;

    end 

         % post fatigue 
        if ~isempty(subject(j).post)
        
            post_fatigue_str = subject(j).post.Global08r;

            if strcmp(post_fatigue_str,'None')
    
                post_fatigue(j) = 0;
    
            elseif strcmp(post_fatigue_str,'Mild')
    
                post_fatigue(j) = 1;
    
            elseif strcmp(post_fatigue_str,'Moderate')
    
                post_fatigue(j) = 2;
    
            elseif strcmp(post_fatigue_str,'Severe')
    
                post_fatigue(j) = 3;
    
            elseif strcmp(post_fatigue_str,'Very Severe')
    
                post_fatigue(j) = 4;
    
            end 

        else 

            post_fatigue(j) = nan;

        end 

end 