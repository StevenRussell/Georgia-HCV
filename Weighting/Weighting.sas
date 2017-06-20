libname w "\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\weighting";
options nofmterr;

*----------------------------------------------------  merging datasets  ------------------------------------------------------;

/* condensing dataset to get only stratum and first stage weight */

data condensed;
set w.finalsample;
by stratum;
if first.stratum then output; else delete;
keep stratum samplingweight;
run;

data weight1_data;
set condensed;
rename stratum = final_stratum;
run;

proc print data=weight1_data; 
run;

/* assuming median number of household members for households without data */
data weight3_data;
set matchformtag3;
keep final_barcode countmembers;
if countmembers in (0, .) then countmembers = 2;
rename countmembers = weight3;
run;

proc sort data=weight3_data;
by final_barcode;
run;

/* simplifying survey data */

data survey;
set tag99;
keep final_barcode final_stratum final_cluster final_hh;
run;

proc sort data=survey;
by final_barcode;
run;

/* merging simplified survey data with 3rd stage weighting data*/

data survey_w3;
merge survey weight3_data;
by final_barcode;
run;

/* merging survey data, weight1 data, weight 3 data*/

proc sort data=survey_w3;
by final_stratum;
run;

proc sort data=weight1_data;
by final_stratum;
run;

data survey_w1_w3;
merge survey_w3 weight1_data;
by final_stratum;
rename samplingweight = weight1;
run;


/* counting the number of HHs that responded in any given cluster */

data count;
set survey;
strata_cluster = final_stratum * 100 + final_cluster;
run;

proc sort data=count;
by strata_cluster;
run;

data responded_hhs_per_cluster;
set count;
by strata_cluster;
if first.strata_cluster then hh_count = 0;
hh_count + 1;
if last.strata_cluster then output; else delete;
drop final_barcode final_stratum final_cluster final_hh;
run;

/* making dataset with total HH count in each cluster (as opposed to responded HH count) */

data all_hhs_in_cluster;
set w.census2014;
keep stratum cluster households population;
run;

data all_hhs_in_cluster2;
set all_hhs_in_cluster;
rename stratum = final_stratum;
rename cluster = final_cluster;
run;

/* merging the first part of weight2 with survey data, weight 1 data and weight 3 data */

proc sort data=survey_w1_w3;
by final_stratum final_cluster;
run;

data survey_w1_w3_allhhs;
merge survey_w1_w3 all_hhs_in_cluster2;
by final_stratum final_cluster;
strata_cluster = final_stratum * 100 + final_cluster;
run;

/* merging total number of hh data with responded number of hh data */
/* this gives allows us to create our weight2 variable */

proc sort data=survey_w1_w3_allhhs;
by strata_cluster;
run;

proc sort data=responded_hhs_per_cluster;
by strata_cluster;
run;

data w.base_weights;
merge survey_w1_w3_allhhs responded_hhs_per_cluster;
by strata_cluster;
weight2 = households / hh_count;
base_weight = weight1 * weight2 * weight3;

if final_barcode = "040999" then final_barcode = "300004";
if final_barcode = "051299" then final_barcode = "300002";

/*unique s, c, hh*/
if final_barcode = "011301" then final_barcode = "300001";
if final_barcode = "051615" then final_barcode = "300003";
if final_barcode = "101626" then final_barcode = "300006";
if final_barcode = "101627" then final_barcode = "300007";
run;

/*check*/

proc freq data=w.base_weights noprint;
table final_barcode / out=f;
run;

proc print data=f;
where count > 1;
run;

/* looking at distribution of base weights */

proc means data=w.base_weights mean mean std min max var;
var base_weight;
run;

proc freq data=w.base_weights;
table base_weight;
run;

**************************************************************************
************************     calibration    ******************************
**************************************************************************;

/* age is missing for 16 observations */

proc freq data=tag99;
table age;
run;

/* replacing age with "selected age" variable from form data*/
data no_age;
set w.tagformdata;
where age=.;

if selectedsex=. then selectedsex=gender;
age=selected_age;

keep selectedage selectedsex final_barcode;
run;

data no_age2;
set no_age;
rename selectedage = age;
rename selectedsex = gender;
run;

data age_sex;
set w.tag99;
keep final_barcode age gender;
run;

proc sort data=age_sex;
by final_barcode;
run;

data merged;
merge age_sex no_age2;
by final_barcode;
run;

/* creating new age categories for calibration */

data new_age_cat;
merge w.base_weights merged;

if age ge 0 and age lt 45 then new_age_cat = "less than 45";
else if age ge 45 and age lt 65 then new_age_cat = "45-64";
else if age ge 65 then new_age_cat = "65+";

if final_barcode="012011" then new_age_cat = "45-64";
if final_barcode="101812" then new_age_cat = "less than 45";
if final_barcode="151512" then new_age_cat = "65+";

if final_barcode = "300063" then delete;
run;

proc sort data=new_age_cat;
by final_stratum;
run;

/* merging in urban vs rural variable 
(we are not doing calibration for this variable at this time though)*/

data census2014;
set w.census2014;
strata_cluster = stratum * 100 + cluster;
keep strata_cluster UvsR ;
run;

data UvsR;
merge new_age_cat census2014;
by strata_cluster;
run;

/* creating groups based on age, sex, and strata */

data group;
set UvsR;
by final_stratum;

/*if UvsR = "R" then base1 = 10000;
	else if UvsR = "U" then base1 = 0;*/

base = final_stratum * 100;

if gender="1" and new_age_cat="less than 45" 				then group=1 + base;
		else if gender="1" and new_age_cat="45-64" 			then group=2 + base;
		else if gender="1" and new_age_cat="65+" 			then group=3 + base;
		else if gender="2" and new_age_cat="less than 45" 	then group=4 + base;
		else if gender="2" and new_age_cat="45-64" 			then group=5 + base;
		else if gender="2" and new_age_cat="65+" 			then group=6 + base;

if final_barcode in ("010404", "010419", "010509", "010511", "010519", "010701", "010714", "011014", "011102",
"012011", "012408", "012419", "012501", "013325", "013701", "013907", "040123", "041103", "041410", "050107",
"050324", "050620", "051625", "061119", "061224", "090618", "091208", "100615", "100616", "101812", "150215",
"151006", "151218", "151512") then delete;
run;

proc sort data=group;
by group;
run;

/* summing weights in each of our groups */

data sum;
set group;
by group;
if first.group then weight_sum = base_weight;
else weight_sum + base_weight;
if last.group then output; else delete;
keep group weight_sum final_stratum;
run;

proc print data=sum noobs;
var weight_sum;
run;

/* importing calibration weights */

PROC IMPORT OUT= W.Calibration 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Georgia He
p C Serosurvey\weighting\Final Calibration apr 12.xlsx" 
            DBMS=EXCEL REPLACE;
     SHEET="Final Calibration$"; 
	 RANGE="A1:E97";
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

/* making group variable in base_weights dataset (so we can merge in next step) */

data base_weights;
set new_age_cat;

base = final_stratum * 100;

if gender="1" and new_age_cat="less than 45" 				then group=1 + base;
		else if gender="1" and new_age_cat="45-64" 			then group=2 + base;
		else if gender="1" and new_age_cat="65+" 			then group=3 + base;
		else if gender="2" and new_age_cat="less than 45" 	then group=4 + base;
		else if gender="2" and new_age_cat="45-64" 			then group=5 + base;
		else if gender="2" and new_age_cat="65+" 			then group=6 + base;

if final_barcode in ("010404", "010419", "010509", "010511", "010519", "010701", "010714", "011014", "011102",
"012011", "012408", "012419", "012501", "013325", "013701", "013907", "040123", "041103", "041410", "050107",
"050324", "050620", "051625", "061119", "061224", "090618", "091208", "100615", "100616", "101812", "150215",
"151006", "151218", "151512") then delete;

run;

proc sort data=base_weights;
by group;
run;

proc sort data=w.calibration;
by group;
run;

/* merging base weight data with calibration weight data */

data w.base_weights_calibration_weight;
merge base_weights w.calibration;
by group;

final_weight = base_weight * calibration_weight;
run;

proc sort data=w.base_weights_calibration_weight;
by final_barcode;
run;


/*check*/

PROC MEANS DATA=w.newly_weighted_data NWAY ;
  /*CLASS gender new_age_cat;*/
  VAR final_weight ;
  OUTPUT OUT=fam1 SUM=sumwt MEAN=meanwt N=cnt ;
RUN;

proc print data=fam1; run;

PROC MEANS DATA=w.base_weights_calibration_weight NWAY;
  CLASS final_stratum new_age_cat gender;
  VAR final_weight ;
  OUTPUT OUT=fam1 SUM=sumwt MEAN=meanwt N=cnt ;
RUN;

proc print data=fam1; run;

/* looking at distribution of final_weights */

proc univariate data=w.base_weights_calibration_weight;
var final_weight ;
histogram;
run;

proc means data=w.base_weights_calibration_weight mean mean std min max var;
var final_weight;
run;

/* looking at extreme weights */

proc print data=w.base_weights_calibration_weight;
where final_weight > 3800;
var final_stratum final_cluster final_hh 
weight1 weight2 weight3 hh_count households population calibration_weight
final_weight;
run;

proc print data=w.base_weights_calibration_weight;
where final_weight < 13;
var final_stratum final_cluster final_hh 
weight1 weight2 weight3 hh_count households population calibration_weight
final_weight;
run;

/* combining weights with survey data */

data weights_for_merge;
set w.base_weights_calibration_weight;
keep final_barcode final_weight;
run;

proc sort data=weights_for_merge;
by final_barcode;
run;

data consented2;
set w.consented;
drop final_weight;
run;

data w.newly_weighted_data;
merge consented2 weights_for_merge ;
by final_barcode;
run;

data w.newly_weighted_data (compress=char); 
set w.newly_weighted_data;
run;


