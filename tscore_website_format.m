% load pre/post data in form to be converted to tscore on website
clear; clc;
close all;

% load the data (if needed)
%subject_pre_post_generate
load('subject_pre_post');

%% format the write the data in the correct format 
save_data = 'off';
subject_pre_all = [];
subject_post_all = [];
% format data in table 
for j = 1:length(subject_pre_post)

    subject_pre_table = subject_pre_post(j).pre;
    subject_pre_all = [subject_pre_all; subject_pre_table];

    subject_post_table = subject_pre_post(j).post;
    subject_post_all = [subject_post_all; subject_post_table];
    
    if ~isempty(subject_pre_table)

        names_all_pre(j) = convertCharsToStrings(subject_pre_post(j).name);
    
    end 

    if ~isempty(subject_post_table)

        names_all_post(j) = convertCharsToStrings(subject_pre_post(j).name);
    
    end 

end 

names_all_pre = names_all_pre(~ismissing(names_all_pre));
names_all_post = names_all_post(~ismissing(names_all_post));

subject_pre_all.FinalQuestion = [];
subject_pre_all.time = [];
subject_pre_all.Chronotype1 = [];
subject_pre_all.Chronotype2 = [];
subject_pre_all.Chronotype3 = [];
subject_pre_all.Chronotype4 = [];
subject_pre_all.Chronotype5 = [];

subject_post_all.FinalQuestion = [];
subject_post_all.time = [];
subject_post_all.Chronotype1 = [];
subject_post_all.Chronotype2 = [];
subject_post_all.Chronotype3 = [];
subject_post_all.Chronotype4 = [];
subject_post_all.Chronotype5 = [];

% convert to numerical scores
subject_pre_all_num = subject_pre_all;
subject_post_all_num = subject_post_all;

% global health (v1.2)
subject_pre_all_num.Global01 = compute_score_p_f_g_vg_e(subject_pre_all_num.Global01,'off')';
subject_pre_all_num.Global02 = compute_score_p_f_g_vg_e(subject_pre_all_num.Global02,'off')';
subject_pre_all_num.Global03 = compute_score_p_f_g_vg_e(subject_pre_all_num.Global03,'off')';
subject_pre_all_num.Global04 = compute_score_p_f_g_vg_e(subject_pre_all_num.Global04,'off')';
subject_pre_all_num.Global05 = compute_score_p_f_g_vg_e(subject_pre_all_num.Global05,'off')';
subject_pre_all_num.Global09r = compute_score_p_f_g_vg_e(subject_pre_all_num.Global09r,'off')';
subject_pre_all_num.Global06 = compute_score_naa_al_m_m_c(subject_pre_all_num.Global06,'off')';
subject_pre_all_num.Global10r = compute_score_nrsoa(subject_pre_all_num.Global10r,'on')';
subject_pre_all_num.Global08r = compute_score_n_m_m_s_vs(subject_pre_all_num.Global08r,'on')';
subject_pre_all_num.Global07r = str2num(cell2mat(subject_pre_all_num.Global07r));

subject_post_all_num.Global01 = compute_score_p_f_g_vg_e(subject_post_all_num.Global01,'off')';
subject_post_all_num.Global02 = compute_score_p_f_g_vg_e(subject_post_all_num.Global02,'off')';
subject_post_all_num.Global03 = compute_score_p_f_g_vg_e(subject_post_all_num.Global03,'off')';
subject_post_all_num.Global04 = compute_score_p_f_g_vg_e(subject_post_all_num.Global04,'off')';
subject_post_all_num.Global05 = compute_score_p_f_g_vg_e(subject_post_all_num.Global05,'off')';
subject_post_all_num.Global09r = compute_score_p_f_g_vg_e(subject_post_all_num.Global09r,'off')';
subject_post_all_num.Global06 = compute_score_naa_al_m_m_c(subject_post_all_num.Global06,'off')';
subject_post_all_num.Global10r = compute_score_nrsoa(subject_post_all_num.Global10r,'on')';
subject_post_all_num.Global08r = compute_score_n_m_m_s_vs(subject_post_all_num.Global08r,'on')';
subject_post_all_num.Global07r = str2num(cell2mat(subject_post_all_num.Global07r));

% sleep disturbance (short form 8b)
subject_pre_all_num.Sleep108 = compute_score_naa_alb_s_qab_vm(subject_pre_all_num.Sleep108,'off')';
subject_pre_all_num.Sleep115 = compute_score_naa_alb_s_qab_vm(subject_pre_all_num.Sleep115,'on')';
subject_pre_all_num.Sleep116 = compute_score_naa_alb_s_qab_vm(subject_pre_all_num.Sleep116,'on')';
subject_pre_all_num.Sleep44 = compute_score_naa_alb_s_qab_vm(subject_pre_all_num.Sleep44,'off')';
subject_pre_all_num.Sleep87 = compute_score_nrsoa(subject_pre_all_num.Sleep87,'off')';
subject_pre_all_num.Sleep90 = compute_score_nrsoa(subject_pre_all_num.Sleep90,'off')';
subject_pre_all_num.Sleep110 = compute_score_nrsoa(subject_pre_all_num.Sleep110,'on')';
subject_pre_all_num.Sleep109 = compute_score_vp_p_f_g_vg(subject_pre_all_num.Sleep109,'on')';

subject_post_all_num.Sleep108 = compute_score_naa_alb_s_qab_vm(subject_post_all_num.Sleep108,'off')';
subject_post_all_num.Sleep115 = compute_score_naa_alb_s_qab_vm(subject_post_all_num.Sleep115,'on')';
subject_post_all_num.Sleep116 = compute_score_naa_alb_s_qab_vm(subject_post_all_num.Sleep116,'on')';
subject_post_all_num.Sleep44 = compute_score_naa_alb_s_qab_vm(subject_post_all_num.Sleep44,'off')';
subject_post_all_num.Sleep87 = compute_score_nrsoa(subject_post_all_num.Sleep87,'off')';
subject_post_all_num.Sleep90 = compute_score_nrsoa(subject_post_all_num.Sleep90,'off')';
subject_post_all_num.Sleep110 = compute_score_nrsoa(subject_post_all_num.Sleep110,'on')';
subject_post_all_num.Sleep109 = compute_score_vp_p_f_g_vg(subject_post_all_num.Sleep109,'on')';

% anxiety (short form 7a)
subject_pre_all_num.EDANX01 = compute_score_nrsoa(subject_pre_all_num.EDANX01,'off')';
subject_pre_all_num.EDANX05 = compute_score_nrsoa(subject_pre_all_num.EDANX05,'off')';
subject_pre_all_num.EDANX30 = compute_score_nrsoa(subject_pre_all_num.EDANX30,'off')';
subject_pre_all_num.EDANX40 = compute_score_nrsoa(subject_pre_all_num.EDANX40,'off')';
subject_pre_all_num.EDANX46 = compute_score_nrsoa(subject_pre_all_num.EDANX46,'off')';
subject_pre_all_num.EDANX53 = compute_score_nrsoa(subject_pre_all_num.EDANX53,'off')';
subject_pre_all_num.EDANX54 = compute_score_nrsoa(subject_pre_all_num.EDANX54,'off')';

subject_post_all_num.EDANX01 = compute_score_nrsoa(subject_post_all_num.EDANX01,'off')';
subject_post_all_num.EDANX05 = compute_score_nrsoa(subject_post_all_num.EDANX05,'off')';
subject_post_all_num.EDANX30 = compute_score_nrsoa(subject_post_all_num.EDANX30,'off')';
subject_post_all_num.EDANX40 = compute_score_nrsoa(subject_post_all_num.EDANX40,'off')';
subject_post_all_num.EDANX46 = compute_score_nrsoa(subject_post_all_num.EDANX46,'off')';
subject_post_all_num.EDANX53 = compute_score_nrsoa(subject_post_all_num.EDANX53,'off')';
subject_post_all_num.EDANX54 = compute_score_nrsoa(subject_post_all_num.EDANX54,'off')';

% depression (short form 8a)
subject_pre_all_num.EDDEP04 = compute_score_nrsoa(subject_pre_all_num.EDDEP04,'off')';
subject_pre_all_num.EDDEP06 = compute_score_nrsoa(subject_pre_all_num.EDDEP06,'off')';
subject_pre_all_num.EDDEP29 = compute_score_nrsoa(subject_pre_all_num.EDDEP29,'off')';
subject_pre_all_num.EDDEP41 = compute_score_nrsoa(subject_pre_all_num.EDDEP41,'off')';
subject_pre_all_num.EDDEP22 = compute_score_nrsoa(subject_pre_all_num.EDDEP22,'off')';
subject_pre_all_num.EDDEP36 = compute_score_nrsoa(subject_pre_all_num.EDDEP36,'off')';
subject_pre_all_num.EDDEP05 = compute_score_nrsoa(subject_pre_all_num.EDDEP05,'off')';
subject_pre_all_num.EDDEP09 = compute_score_nrsoa(subject_pre_all_num.EDDEP09,'off')';

subject_post_all_num.EDDEP04 = compute_score_nrsoa(subject_post_all_num.EDDEP04,'off')';
subject_post_all_num.EDDEP06 = compute_score_nrsoa(subject_post_all_num.EDDEP06,'off')';
subject_post_all_num.EDDEP29 = compute_score_nrsoa(subject_post_all_num.EDDEP29,'off')';
subject_post_all_num.EDDEP41 = compute_score_nrsoa(subject_post_all_num.EDDEP41,'off')';
subject_post_all_num.EDDEP22 = compute_score_nrsoa(subject_post_all_num.EDDEP22,'off')';
subject_post_all_num.EDDEP36 = compute_score_nrsoa(subject_post_all_num.EDDEP36,'off')';
subject_post_all_num.EDDEP05 = compute_score_nrsoa(subject_post_all_num.EDDEP05,'off')';
subject_post_all_num.EDDEP09 = compute_score_nrsoa(subject_post_all_num.EDDEP09,'off')';

% physical function (short form 8b)
subject_pre_all_num.PFA11 = compute_score_utd_wmd_wsd_wld_wad(subject_pre_all_num.PFA11,'off')';
subject_pre_all_num.PFA21 = compute_score_utd_wmd_wsd_wld_wad(subject_pre_all_num.PFA21,'off')';
subject_pre_all_num.PFA23 = compute_score_utd_wmd_wsd_wld_wad(subject_pre_all_num.PFA23,'off')';
subject_pre_all_num.PFA53 = compute_score_utd_wmd_wsd_wld_wad(subject_pre_all_num.PFA53,'off')';
subject_pre_all_num.PFC12 = compute_score_naa_vl_s_qal_cd(subject_pre_all_num.PFC12,'on')';
subject_pre_all_num.PFB1 = compute_score_naa_vl_s_qal_cd(subject_pre_all_num.PFB1,'on')';
subject_pre_all_num.PFA5 = compute_score_naa_vl_s_qal_cd(subject_pre_all_num.PFA5,'on')';
subject_pre_all_num.PFA4 = compute_score_naa_vl_s_qal_cd(subject_pre_all_num.PFA4,'on')';

subject_post_all_num.PFA11 = compute_score_utd_wmd_wsd_wld_wad(subject_post_all_num.PFA11,'off')';
subject_post_all_num.PFA21 = compute_score_utd_wmd_wsd_wld_wad(subject_post_all_num.PFA21,'off')';
subject_post_all_num.PFA23 = compute_score_utd_wmd_wsd_wld_wad(subject_post_all_num.PFA23,'off')';
subject_post_all_num.PFA53 = compute_score_utd_wmd_wsd_wld_wad(subject_post_all_num.PFA53,'off')';
subject_post_all_num.PFC12 = compute_score_naa_vl_s_qal_cd(subject_post_all_num.PFC12,'on')';
subject_post_all_num.PFB1 = compute_score_naa_vl_s_qal_cd(subject_post_all_num.PFB1,'on')';
subject_post_all_num.PFA5 = compute_score_naa_vl_s_qal_cd(subject_post_all_num.PFA5,'on')';
subject_post_all_num.PFA4 = compute_score_naa_vl_s_qal_cd(subject_post_all_num.PFA4,'on')';

%% save the results in the proper format for website 
subject_pre_all_num.Assmnt = ones(height(subject_pre_all_num),1);
subject_pre_all_num.PIN = names_all_pre';
subject_post_all_num.Assmnt = ones(height(subject_post_all_num),1)+1;
subject_post_all_num.PIN = names_all_post';
subject_all_num = [subject_pre_all_num; subject_post_all_num];
subject_all_num = [subject_all_num(:,"PIN") subject_all_num(:,"Assmnt") subject_all_num(:,1:end-2)];

if strcmp(save_data,'on')

    writetable(subject_all_num,'subject_all_num.csv')

end 

% try dividing by survey?
%survey_all_num_pf = [survey_all_num(:,"PIN") survey_all_num(:,"Assmnt") survey_all_num(:,"PFA11") survey_all_num(:,"PFA23") survey_all_num(:,"PFA4") survey_all_num(:,"PFA21") survey_all_num(:,"PFB1") survey_all_num(:,"PFA53") survey_all_num(:,"PFA53")]