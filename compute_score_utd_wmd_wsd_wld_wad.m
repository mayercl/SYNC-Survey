function score =  compute_score_utd_wmd_wsd_wld_wad(score_string, reverse)

for j = 1:length(score_string)

    if strcmp(score_string{j},'Unable to do')
        
        score(j) = 1;
    
    elseif strcmp(score_string{j},'With much difficulty')
    
        score(j) = 2;
    
    elseif strcmp(score_string{j},'With some difficulty')
    
        score(j) = 3;
    
    elseif strcmp(score_string{j},'With a little difficulty')
    
        score(j) = 4;
    
    elseif strcmp(score_string{j},'Without any difficulty') 
    
        score(j) = 5;
    
    end 

end 

if strcmp(reverse,'on')
    
    score(score == 1) = 5;
    score(score == 2) = 4;
    score(score == 4) = 2;
    score(score == 5) = 1;

end 