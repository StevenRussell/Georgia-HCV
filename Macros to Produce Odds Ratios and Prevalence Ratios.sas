
/* This macro will help automate the output of odds ratios */

%macro multiple_ORs( var, reference_value );

proc surveyfreq data=final.hepvar nomcar;
stratum final_stratum;
cluster final_cluster;
weight final_weight;
tables &var * ahcv_posneg   / row cl (type=logit) deff chisq;
ods output crosstabs=c_&var;
run;

title " &var, +";
proc sql noprint;
create table pos as
select Frequency as pos_freq, cat( round(rowpercent, .01), "%") as pos_percent
from c_&var
where F_aHCV_posneg = "+" and F_&var ne "Total";
quit;

title " &var, -";
proc sql noprint;
create table neg as
select Frequency as neg_freq, cat( round(rowpercent, .01), "%") as neg_percent
from c_&var
where F_aHCV_posneg = "-" and F_&var ne "Total";
quit;

proc surveylogistic data=final.hepvar  nomcar;
stratum final_stratum;
cluster final_cluster;
weight final_weight;
class  &var (ref= &reference_value  param=ref);
model ahcv_posneg (event="+") =  &var  ;
ods output oddsratios=o_&var parameterestimates=p_&var;
format &var;
run;

data line;
effect= &reference_value;
oddsratioest=1;
lowercl=1;
uppercl=1;
run;

data o_&var;
set line o_&var;
OR = cat(round(OddsRatioEst, .01), " (", round(LowerCL, .01), ", ", round(UpperCL, .01), ")");
keep OR;
run;

data line2;
probchisq=.;
run;

data p_&var;
set line2 p_&var;
if variable ne "Intercept";
keep ProbChiSq;
run;

data all;
merge pos neg o_&var p_&var;
run;

proc print data=all noobs;
run;

%mend;

/* This macro will help automate the output of prevalence ratios */

%macro multiple_PRs( var, reference_value, reference_format_number );

proc surveyfreq data=final.hepvar_pr nomcar;
stratum final_stratum;
cluster final_cluster;
weight final_weight;
tables &var * ahcv_pos  / row cl (type=logit) deff chisq;
ods output crosstabs=c_&var;
run;

title " &var, +";
proc sql noprint;
create table pos_&var as
select Frequency as pos_freq, cat( round(rowpercent, .01), "%") as pos_percent
from c_&var
where compress(F_aHCV_pos, " ") = "1" and compress(F_&var, " ") ne "Total";
quit;

title " &var, -";
proc sql noprint;
create table neg_&var as
select Frequency as neg_freq, cat( round(rowpercent, .01), "%") as neg_percent
from c_&var
where compress(F_aHCV_pos, " ") = "0" and compress(F_&var, " ") ne "Total";
quit;

proc surveyphreg data=final.hepvar_pr  nomcar;
stratum final_stratum;
cluster final_cluster;
weight final_weight;
class  &var (ref= "&reference_format_number"  param=ref);
model time * ahcv_pos(0) =  &var / clparm risklimits ;
ods output parameterestimates=pe_&var;
format &var;
run;

data pe_&var.2;
set pe_&var (keep=parameter HazardRatio HRLowerCL HRUpperCL Probt);
PR = cat(round(HazardRatio, .01), " (", round(HRLowerCL, .01), ", ", round(HRUpperCL, .01), ")");
keep probt PR;
run;

data line;
probt=.;
pr="1";
run;

data prs_&var;
set line pe_&var.2; 
run;

data all_&var;
retain pos_freq pos_percent neg_freq neg_percent pr probt;
merge pos_&var neg_&var prs_&var;
run;

proc print data=all_&var noobs;
run;

%mend;



