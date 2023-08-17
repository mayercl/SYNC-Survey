function score_final = compute_score_n_m_m_s_vs(score_string, reverse)

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
    
    score_final(score == 1) = 5;
    score_final(score == 2) = 4;
    score_final(score == 3) = 3;
    score_final(score == 4) = 2;
    score_final(score == 5) = 1;

else 

    score_final = score;

end 