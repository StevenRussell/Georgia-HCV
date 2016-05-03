%macro OR (var, compare_category, reference_category );

data c_&compare_category.1;
set c_&var;
if F_&var= "&compare_category" and F_aHCV_posneg = "+" then pos_freq = frequency;
if F_&var= "&compare_category" and F_aHCV_posneg = "+" then pos_rowpercent = cats(round(rowpercent, .01), "%");
if F_&var= "&compare_category" and F_aHCV_posneg = "+" then output; else delete;
keep pos_freq pos_rowpercent;
run;

data c_&compare_category.2;
set c_&var;
if F_&var="&compare_category" and F_aHCV_posneg = "-" then neg_freq = frequency;
if F_&var="&compare_category" and F_aHCV_posneg = "-" then neg_rowpercent = cats(round(rowpercent, .01), "%");
if F_&var="&compare_category" and F_aHCV_posneg = "-" then output; else delete;	
keep neg_freq neg_rowpercent;
run;

data c_&reference_category.1;
set c_&var;
if F_&var="&reference_category" and F_aHCV_posneg = "+" then pos_freq = frequency;
if F_&var="&reference_category" and F_aHCV_posneg = "+" then pos_rowpercent = cats(round(rowpercent, .01), "%");
if F_&var="&reference_category" and F_aHCV_posneg = "+" then output; else delete;
keep pos_freq pos_rowpercent ;
run;

data c_&reference_category.2;
set c_&var;
if F_&var="&reference_category" and F_aHCV_posneg = "-" then neg_freq = frequency; 
if F_&var="&reference_category" and F_aHCV_posneg = "-" then neg_rowpercent = cats(round(rowpercent, .01), "%");
if F_&var="&reference_category" and F_aHCV_posneg = "-" then output; else delete;
keep neg_freq neg_rowpercent ;
run;


data &var.1;

if &switch_order=. then do;
set c_&compare_category.1 c_&reference_category.1;
end;

else if &switch_order=1 then do;
set c_&reference_category.1 c_&compare_category.1 ;
end;

run;

data &var.2;

if &switch_order=. then do;
set c_&compare_category.2 c_&reference_category.2;
end;

else if &switch_order=1 then do;
set c_&reference_category.2 c_&compare_category.2 ;
end;

run;

data o_&var.2;
set o_&var;
OR = cat(round(OddsRatioEst, .01), " (", round(LowerCL, .01), ", ", round(UpperCL, .01), ")");
keep OR;
run;

%if &switch_order=1 %then %do;
data er_o_&var.2;  /*extra row*/
OR = "1          ";
run;

data o_&var.3;
set er_o_&var.2 o_&var.2;
run;
%end;

%else %if &switch_order=. %then %do;
data o_&var.3;
set o_&var.2;
run;
%end;

data p_&var.2;
set p_&var;
if variable = "&var";
/*if classval0 = "Yes";*/
keep probchisq;
run;

%if &switch_order=1 %then %do;
data er_p_&var.2;
ProbChiSq = .;
run;

data p_&var.3;
set er_p_&var.2 p_&var.2;
run;
%end;

%else %if &switch_order=. %then %do;
data p_&var.3;
set p_&var.2;
run;
%end;

data &var;
merge &var.1 &var.2 o_&var.3 p_&var.3;
run;

%mend;


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

/***************************/

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

data final.hepvar_pr;
set final.hepvar;
if aHCV_posneg = "+" then aHCV_pos = 1;
else if aHCV_posneg = "-" then aHCV_pos = 0;

time=1;
run;


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

/***************************/

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
pr="1                        ";
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

%multiple_PRs( dentist_cat_miss, "Twice per year", 1);

%multiple_PRs( shot_admin_miss, "Doctor", 1);
