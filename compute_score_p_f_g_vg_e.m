function score = compute_score_p_f_g_vg_e(score_string, reverse)

for j = 1:length(score_string)

    if strcmp(score_string{j},'Poor')
        
        score(j) = 1;
    
    elseif strcmp(score_string{j},'Fair')
    
        score(j) = 2;
    
    elseif strcmp(score_string{j},'Good')
    
        score(j) = 3;
    
    elseif strcmp(score_string{j},'Very good') | strcmp(score_string{j},'Very Good')
    
        score(j) = 4;
    
    elseif strcmp(score_string{j},'Excellent')
    
        score(j) = 5;
    
    end 

end    

    if strcmp(reverse,'on')
        
        score(score == 1) = 5;
        score(score == 2) = 4;
        score(score == 4) = 2;
        score(score == 5) = 1;
    
    end 