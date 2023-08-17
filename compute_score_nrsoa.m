function score_final = compute_score_nrsoa(score_string, reverse)

for j = 1:length(score_string)

    if strcmp(score_string{j},'Never')
        
        score(j) = 1;
    
    elseif strcmp(score_string{j},'Rarely')
    
        score(j) = 2;
    
    elseif strcmp(score_string{j},'Sometimes')
    
        score(j) = 3;
    
    elseif strcmp(score_string{j},'Often')
    
        score(j) = 4;
    
    elseif strcmp(score_string{j},'Always') 
    
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