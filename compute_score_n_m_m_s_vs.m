function score = compute_score_n_m_m_s_vs(score_string, reverse)

for j = 1:length(score_string)

    if strcmp(score_string{j},'None')
        
        score(j) = 1;
    
    elseif strcmp(score_string{j},'Mild')
    
        score(j) = 2;
    
    elseif strcmp(score_string{j},'Moderate')
    
        score(j) = 3;
    
    elseif strcmp(score_string{j},'Severe')
    
        score(j) = 4;
    
    elseif strcmp(score_string{j},'Very Severe') | strcmp(score_string,'Very severe')
    
        score(j) = 5;
    
    end 

end 

if strcmp(reverse,'on')
    
    score(score == 1) = 5;
    score(score == 2) = 4;
    score(score == 4) = 2;
    score(score == 5) = 1;

end 