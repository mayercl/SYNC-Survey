function score = compute_score_naa_alb_s_qab_vm(score_string, reverse)

for j = 1:length(score_string)

    if strcmp(score_string{j},'Not at all')
        
        score(j) = 1;
    
    elseif strcmp(score_string{j},'A little bit')
    
        score(j) = 2;
    
    elseif strcmp(score_string{j},'Somewhat')
    
        score(j) = 3;
    
    elseif strcmp(score_string{j},'Quite a bit')
    
        score(j) = 4;
    
    elseif strcmp(score_string{j},'Very Much') | strcmp(sleep_108,'Very much')
    
        score(j) = 5;
    
    end 

end 

if strcmp(reverse,'on')
    
    score(score == 1) = 5;
    score(score == 2) = 4;
    score(score == 4) = 2;
    score(score == 5) = 1;

end 