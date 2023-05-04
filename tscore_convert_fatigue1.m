function z = tscore_convert_fatigue1(weekly_raw_score)

% convert weekly fatigue raw score to tscore and SD, based on
% HealthMeasures website 

tscore = nan(length(weekly_raw_score),2);

tscore(weekly_raw_score == 4,1) = 33.7;
tscore(weekly_raw_score == 4,2) = 4.9;
tscore(weekly_raw_score == 5,1) = 39.7;
tscore(weekly_raw_score == 5,2) = 3.1;
tscore(weekly_raw_score == 6,1) = 43.1;
tscore(weekly_raw_score == 6,2) = 2.7;
tscore(weekly_raw_score == 7,1) = 46.0;
tscore(weekly_raw_score == 7,2) = 2.6;
tscore(weekly_raw_score == 8,1) = 48.6;
tscore(weekly_raw_score == 8,2) = 2.5;
tscore(weekly_raw_score == 9,1) = 51.0;
tscore(weekly_raw_score == 9,2) = 2.5;
tscore(weekly_raw_score == 10,1) = 53.1;
tscore(weekly_raw_score == 10,2) = 2.4;
tscore(weekly_raw_score == 11,1) = 55.1;
tscore(weekly_raw_score == 11,2) = 2.4;
tscore(weekly_raw_score == 12,1) = 57.0;
tscore(weekly_raw_score == 12,2) = 2.3;
tscore(weekly_raw_score == 13,1) = 58.8;
tscore(weekly_raw_score == 13,2) = 2.3;
tscore(weekly_raw_score == 14,1) = 60.7;
tscore(weekly_raw_score == 14,2) = 2.3;
tscore(weekly_raw_score == 15,1) = 62.7;
tscore(weekly_raw_score == 15,2) = 2.4;
tscore(weekly_raw_score == 16,1) = 64.6;
tscore(weekly_raw_score == 16,2) = 2.4;
tscore(weekly_raw_score == 17,1) = 66.7;
tscore(weekly_raw_score == 17,2) = 2.4;
tscore(weekly_raw_score == 18,1) = 69.0;
tscore(weekly_raw_score == 18,2) = 2.5;
tscore(weekly_raw_score == 19,1) = 71.6;
tscore(weekly_raw_score == 19,2) = 2.7;
tscore(weekly_raw_score == 20,1) = 75.8;
tscore(weekly_raw_score == 20,2) = 3.9;

z = tscore;
