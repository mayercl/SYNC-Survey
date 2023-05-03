function score = compute_score_naa_al_m_m_c(score_string, reverse)

for j = 1:length(score_string)

    if strcmp(score_string{j},'Not at all')
        
        score(j) = 1;
    
    elseif strcmp(score_string{j},'A little')
    
        score(j) = 2;
    
    elseif strcmp(score_string{j},'Moderately')
    
        score(j) = 3;
    
    elseif strcmp(score_string{j},'Mostly')
    
        score(j) = 4;
    
    elseif strcmp(score_string{j},'Completely')
    
        score(j) = 5;
    
    end 

end 

if strcmp(reverse,'on')
    
    score(score == 1) = 5;
    score(score == 2) = 4;
    score(score == 4) = 2;
    score(score == 5) = 1;

end 