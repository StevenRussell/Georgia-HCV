
************************************************************************************************
*********************************** Importing V7 ***********************************************
************************************************************************************************;

libname HCV7 '\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data';
run;

*/Import 7 datasets from Task Force database;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE.csv"
            dbms=dlm
            out=HCV7.HCV_core
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE2.csv"
            dbms=dlm
            out=HCV7.HCV_core_2
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE3.csv"
            dbms=dlm
            out=HCV7.HCV_core_3
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE4.csv"
            dbms=dlm
            out=HCV7.HCV_core_4
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE5.csv"
            dbms=dlm
            out=HCV7.HCV_core_5
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE6.csv"
            dbms=dlm
            out=HCV7.HCV_core_6
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v7 data\GEORGIA_HCV_SURVEY_V7_CORE7.csv"
            dbms=dlm
            out=HCV7.HCV_core_7
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

*/Sort 7 datasets by ID variable;

proc sort data=HCV7.HCV_core; by _URI;
run;
proc sort data=HCV7.HCV_core_2; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV7.HCV_core_3; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV7.HCV_core_4; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV7.HCV_core_5; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV7.HCV_core_6; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV7.HCV_core_7; by _TOP_LEVEL_AURI;
run;

*/Rename ID variable in _core dataset to match all others and remove quotation marks;
data HCV7.HCV_core_v2; 
length start_time $ 25; length end_time $ 25; 
length q5_I5 $ 23; length consent_Q12a_D2 $14;
format _TOP_LEVEL_AURI $100.; set HCV7.HCV_core;

	_URI=compress(_URI, '"');
	_URI2=substr(_URI, 4, 41);
	_TOP_LEVEL_AURI=_URI2;

run;

*/Merge 7 datasets by ID variable and create check for errors;

data HCV7.HCVmerge;
	merge HCV7.HCV_core_v2 (in=ds_HCV_core_v2) HCV7.HCV_core_2 (in=ds_HCV_core_2) HCV7.HCV_core_3 (in=ds_HCV_core_3) HCV7.HCV_core_4 (in=ds_HCV_core_4) HCV7.HCV_core_5 (in=ds_HCV_core_5)
	HCV7.HCV_core_6 (in=ds_HCV_core_6) HCV7.HCV_core_7 (in=ds_HCV_core_7);
	by _TOP_LEVEL_AURI;
	core=ds_HCV_core_v2;
	core2=ds_HCV_core_2;
	core3=ds_HCV_core_3;
	core4=ds_HCV_core_4;
	core5=ds_HCV_core_5;
	core6=ds_HCV_core_6;
	core7=ds_HCV_core_7;
	/*_last_update_date2=input(_last_update_date,8.0);*/
run;

data HCV7.HCVmerge2; 
length Q149_PB8 $ 177;
length CONSENTCONSENT2Q32M4_Q32A $12; 
length CONSENTCONSENT2Q32M4_Q32E $12; 
length CONSENTCONSENT2Q32M4_Q32D $12; 
length CONSENTCONSENT2Q32M4_Q32C $12; 
length CONSENTCONSENT2Q32M4_Q32B $12; 
length CONSENT_CONSENT2_Q33_M5 $12; 

length q5_I5 $23;
length CONSENT_Q12A_D2 $14;

set HCV7.HCVmerge;
run;

data HCV7.HCVformat2;
set HCV7.HCVformat;

*matching type between v7, v8, v9, v10;
barcode_r = input(barcode, $20.);
drop barcode;
rename barcode_r = barcode;

cluster_ID_r = input(cluster_ID, $20.);
drop cluster_ID;
rename cluster_ID_r = cluster_ID;

HCV_notreat_other_specify_r = input(HCV_notreat_other_specify, $200.);
drop HCV_notreat_other_specify;
rename HCV_notreat_other_specify_r = HCV_notreat_other_specify;

smoke_other_num_r = input(smoke_other_num, $20.);
drop smoke_other_num;
rename smoke_other_num_r = smoke_other_num;

smoke_other_day_week_r = input(smoke_other_day_week, $20.);
drop smoke_other_day_week;
rename smoke_other_day_week_r = smoke_other_day_week;

manicure_salon_r = input(manicure_salon, $20.);
drop manicure_salon;
rename manicure_salon_r = manicure_salon;

manicure_homeservice_r = input(manicure_homeservice, $20.);
drop manicure_homeservice;
rename manicure_homeservice_r = manicure_homeservice;

manicure_self_r = input(manicure_self, $20.);
drop manicure_self;
rename manicure_self_r = manicure_self;

manicure_never_r = input(manicure_never, $20.);
drop manicure_never;
rename manicure_never_r = manicure_never;

barber_num_r = input(barber_num, $20.);
drop barber_num;
rename barber_num_r = barber_num;

IDU_otherdrug_r = input(IDU_otherdrug, $200.);
drop IDU_otherdrug;
rename IDU_otherdrug_r = IDU_otherdrug;

cuff_other_specify_r = input(cuff_other_specify, $20.);
drop cuff_other_specify;
rename cuff_other_specify_r = cuff_other_specify;

smoke_other_r = input(smoke_other, $20.);
drop smoke_other;
rename smoke_other_r = smoke_other;

manicure_other_r = input(manicure_other, $200.);
drop manicure_other;
rename manicure_other_r = manicure_other;

stratum_num_r = input(stratum_num, $20.);
drop stratum_num;
rename stratum_num_r = stratum_num;

*matching type for phone data;
chronic_kidney_r = input(chronic_kidney, $20.);
drop chronic_kidney;
rename chronic_kidney_r = chronic_kidney;

trust_radio_r = input(trust_radio, $20.);
drop trust_radio;
rename trust_radio_r = trust_radio;

cig_day_week_r = input(cig_day_week, $20.);
drop cig_day_week;
rename cig_day_week_r = cig_day_week;

piercing_home_r = input(piercing_home, $20.);
drop piercing_home;
rename piercing_home_r = piercing_home;
run;

************************************************************************************************
*********************************** Phone V7 ***********************************************
************************************************************************************************;

PROC IMPORT OUT= HCV7.phone 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Georgia He
p C Serosurvey\Data salvaged from phones_FINAL\Data salvaged from phones
_FINAL\Georgia_HCV_survey_v7_results_from phones_090415.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2;
	 guessingrows=567; 
RUN;

proc sort data=HCV7.phone;
by meta_instanceID;
run;

data HCV7.phone2;
length _TOP_LEVEL_AURI $100;
set HCV7.phone;
_Top_level_auri = meta_instanceID;
drop meta_instanceID;
q12=put(consent_Q12a_D2, 14.);
drop consent_Q12a_d2;
rename q12=consent_q12a_d2;

/*if _n_ in (1, 566, 567) then delete;*/
run;

data HCV7.phone_format2;
set HCV7.phone_format;

stratum_num_r = input(stratum_num, $20.);
drop stratum_num;
rename stratum_num_r = stratum_num;

run;

data HCV7.phone_merge;
length address_results $ 177;
length int_date $150;
length birthday $150;
merge  HCV7.HCVformat2 (in=database) HCV7.phone_format2 (in=phone) ;
by _Top_level_auri;
if phone=0 then database_v7=1;
phone_v7=phone;
if database=1;
run;

***************************************************************************************************
*********************************     Dental Data       *******************************************
**************************************************************************************************;

PROC IMPORT OUT= HCV7.DENTAL 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Georgia He
p C Serosurvey\HCV_dentalQ_CallInfo.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet2$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data HCV7.dental2; 
length _top_level_auri $100.;
set HCV7.dental;

array checknull (*) _char_
;
do i=1 to 19;
		test1=find(checknull(i),"NULL");
		test2=find(checknull(i),"NUL");
		if test1>0 or test2>0 then do;
			checknull(i)=" ";
		end;
	end;

_last_update_date2=put(_last_update_date,21.);
drop _last_update_date;
rename _last_update_date2=_last_update_date;

/*Q164_EXIT1_2=put(Q164_EXIT1, 4.);
drop Q164_EXIT1;
rename Q164_EXIT1_2=Q164_EXIT1;

Q163_PB29_2=put(Q163_PB29, 3.);
drop Q163_PB29;
rename Q163_PB29_2=Q163_PB29;

q165_pb31_2=put(q165_pb31, 7.);
drop q165_pb31;
rename q165_pb31_2=q165_pb31;*/

/*new= put( q165_pb31, hhmm.);*/
run;

data HCV7.dental3; 
set HCV7.dental2; 

Q5_I5_r=put(Q5_I5, 21.);
drop Q5_I5;
rename Q5_I5_r=Q5_I5;

Q3A_I3_r=put(Q3A_I3, 4.);
drop Q3A_I3;
rename Q3A_I3_r=Q3A_I3;

Q7_I7_r=put(Q7_I7 , 3.);
drop Q7_I7 ;
rename Q7_I7_r=Q7_I7;

Q3B_I3_r=put(Q3B_I3, 5.);
drop Q3B_I3;
rename Q3B_I3_r=Q3B_I3;

Q2A_I2_r=put(Q2A_I2, 7.);
drop Q2A_I2;
rename Q2A_I2_r=Q2A_I2;

Q145_PB4_r=put(Q145_PB4, 3.);
drop Q145_PB4;
rename Q145_PB4_r=Q145_PB4;

Q148_PB7_r=put(Q148_PB7, 29.);
drop Q148_PB7;
rename Q148_PB7_r=Q148_PB7;

Q6_I6_r=put(Q6_I6, 7.);
drop Q6_I6;
rename Q6_I6_r=Q6_I6;

Q0_BARCODE_r=put(Q0_BARCODE, 10.);
drop Q0_BARCODE;
rename Q0_BARCODE_r=Q0_BARCODE;

Q142_PB1_r=put(Q142_PB1, 14.);
drop Q142_PB1;
rename Q142_PB1_r=Q142_PB1;

CONSENT_CONSENT2_Q31_M3_r=put(CONSENT_CONSENT2_Q31_M3, 4.);
drop CONSENT_CONSENT2_Q31_M3;
rename CONSENT_CONSENT2_Q31_M3_r=CONSENT_CONSENT2_Q31_M3;

run;

data HCV7.dental4;
	set HCV7.dental3;
/*dentist_hospital*/ drop CONSENTCONSENT2Q32M4_Q32A ;
/*dentist_cabinet*/  drop CONSENTCONSENT2Q32M4_Q32B ;
/*dentist_home*/     drop CONSENTCONSENT2Q32M4_Q32C ;
/*dentist_other*/    drop CONSENTCONSENT2Q32M4_Q32D ;
/*dentist_DK*/       drop CONSENTCONSENT2Q32M4_Q32E ;
dentist_cat       = input(CONSENT_CONSENT2_Q31_M3,8.0) ;
/*dentist_other_specify = CONSENT_CONSENT2_Q32_M4A ;*/
drop CONSENT_CONSENT2_Q33_M5 ;
f_name          = CONSENT_Q10_I10 ;
surname       = CONSENT_Q9_I9 ;
drop Interviewer_to_contact;
dental_proc_num = Q33 ;
barcode = Q0_BARCODE ;
int_ID_NCD = Q142_PB1 ;
consent_blood = input(Q145_PB4, 8.0) ;
phone_results = Q148_PB7 ;
address_results = Q149_PB8; 
blood_collected = Q163_PB29; 
disposition_other_specify = Q164A_EXIT1_OTHER ;
disposition = Q164_EXIT1 ;
blood_time = input(Q165_PB31, $7.);
hh_num = input(Q2A_I2, 8.0);
dentist_DK  = input(Q32_DK,8.0) ;
 *; if Q32_Dcab = 'Yes' then dentist_cabinet = 1; if Q32_Dcab = 'No' then dentist_cabinet = .;
 *; if Q32_Hosp = 'Yes' then dentist_hospital = 1; if Q32_Hosp = 'No' then dentist_hospital = .; 
 *; if Q32_Other = 'Yes' then dentist_other = 1; if Q32_Other = 'No' then dentist_other = .;
dentist_other_specify = Q32_Otxt ;
 *; if Q32_aHome = 'Yes' then dentist_home = 1; if Q32_aHome = 'No' then dentist_home = .;
stratum_num = Q3A_I3 ;
cluster_ID = Q3B_I3 ;
int_date   = Q5_I5 ;
int_start_time = Q6_I6 ;
consent_int  = input(Q7_I7, 8.0) ;
/*_LAST_UPDATE_DATE ;
_TOP_LEVEL_AURI ;*/

drop CONSENT_CONSENT2_Q31_M3
 CONSENT_CONSENT2_Q32_M4A
 CONSENT_CONSENT2_Q33_M5
 CONSENT_Q10_I10
 CONSENT_Q9_I9
 Q33
 Q0_BARCODE
 Q142_PB1 
 Q145_PB4
 Q148_PB7
 Q149_PB8
 Q163_PB29 
 Q164A_EXIT1_OTHER 
 Q164_EXIT1 
 Q165_PB31
 Q2A_I2 
 Q32_DK 
 Q32_Dcab
 Q32_Hosp 
 Q32_Other 
 Q32_Otxt 
 Q32_aHome 
  Q3A_I3 
 Q3B_I3 
 Q5_I5 
 Q6_I6 
 Q7_I7 
i test1 test2;

/*SAS_int_date = int_date - 21916;
format SAS_int_date Date9.;*/
run;

proc sort data=HCV7.dental4;
by _top_level_auri;
run;

data HCV7.for_merge;
merge HCV7.phone_merge HCV7.dental4 (in=in1);
dental_data_added=in1;
by _top_level_auri;
run;

*********************************************************************************************
************************   Finished with v7, ready for merge   ******************************
*********************    Dataset to merge: HCV7.for_merge      ******************************
*********************************************************************************************

*********************************************************************************************
*************************************       v8         **************************************
*********************************************************************************************

*/Georgia HCV+ Serosurvey;

libname HCV8 '\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data';
run;

*/Import 7 datasets from Task Force database;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE.csv"
            dbms=dlm
            out=HCV8.HCV_core
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE2.csv"
            dbms=dlm
            out=HCV8.HCV_core_2
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE3.csv"
            dbms=dlm
            out=HCV8.HCV_core_3
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE4.csv"
            dbms=dlm
            out=HCV8.HCV_core_4
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE5.csv"
            dbms=dlm
            out=HCV8.HCV_core_5
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE6.csv"
            dbms=dlm
            out=HCV8.HCV_core_6
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v8 data\GEORGIA_HCV_SURVEY_V8_CORE7.csv"
            dbms=dlm
            out=HCV8.HCV_core_7
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

*/Sort 7 datasets by ID variable;

proc sort data=HCV8.HCV_core; by _URI;
run;
proc sort data=HCV8.HCV_core_2; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV8.HCV_core_3; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV8.HCV_core_4; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV8.HCV_core_5; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV8.HCV_core_6; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV8.HCV_core_7; by _TOP_LEVEL_AURI;
run;

*/Rename ID variable in _core dataset to match all others and remove quotation marks;
data HCV8.HCV_core_v2; format _TOP_LEVEL_AURI $100.; set HCV8.HCV_core;

	_URI=compress(_URI, '"');
	_URI2=substr(_URI, 4, 41);
	_TOP_LEVEL_AURI=_URI2;

run;

*/Merge 7 datasets by ID variable and create check for errors;

data HCV8.HCVmerge;
	merge HCV8.HCV_core_v2 (in=ds_HCV_core_v2) HCV8.HCV_core_2 (in=ds_HCV_core_2) HCV8.HCV_core_3 (in=ds_HCV_core_3) HCV8.HCV_core_4 (in=ds_HCV_core_4) HCV8.HCV_core_5 (in=ds_HCV_core_5)
	HCV8.HCV_core_6 (in=ds_HCV_core_6) HCV8.HCV_core_7 (in=ds_HCV_core_7);
	by _TOP_LEVEL_AURI;
	core=ds_HCV_core_v2;
	core2=ds_HCV_core_2;
	core3=ds_HCV_core_3;
	core4=ds_HCV_core_4;
	core5=ds_HCV_core_5;
	core6=ds_HCV_core_6;
	core7=ds_HCV_core_7;
run;

*/Create formats for renamed variables and drop old variables;;


data HCV8.HCVformat2;
length start_time $ 25; length end_time $ 25; length int_date $ 23; length birthday $ 14;
set HCV8.HCVformat;

barcode_r = input(barcode, $20.);
drop barcode;
rename barcode_r = barcode;

cluster_ID_r = input(cluster_ID, $20.);
drop cluster_ID;
rename cluster_ID_r = cluster_ID;

HCV_notreat_other_specify_r = input(HCV_notreat_other_specify, $200.);
drop HCV_notreat_other_specify;
rename HCV_notreat_other_specify_r = HCV_notreat_other_specify;

smoke_other_num_r = input(smoke_other_num, $20.);
drop smoke_other_num;
rename smoke_other_num_r = smoke_other_num;

smoke_other_day_week_r = input(smoke_other_day_week, $20.);
drop smoke_other_day_week;
rename smoke_other_day_week_r = smoke_other_day_week;

manicure_salon_r = input(manicure_salon, $20.);
drop manicure_salon;
rename manicure_salon_r = manicure_salon;

manicure_homeservice_r = input(manicure_homeservice, $20.);
drop manicure_homeservice;
rename manicure_homeservice_r = manicure_homeservice;

manicure_self_r = input(manicure_self, $20.);
drop manicure_self;
rename manicure_self_r = manicure_self;

manicure_never_r = input(manicure_never, $20.);
drop manicure_never;
rename manicure_never_r = manicure_never;

barber_num_r = input(barber_num, $20.);
drop barber_num;
rename barber_num_r = barber_num;

IDU_otherdrug_r = input(IDU_otherdrug, $200.);
drop IDU_otherdrug;
rename IDU_otherdrug_r = IDU_otherdrug;

cuff_other_specify_r = input(cuff_other_specify, $20.);
drop cuff_other_specify;
rename cuff_other_specify_r = cuff_other_specify;

smoke_other_r = input(smoke_other, $20.);
drop smoke_other;
rename smoke_other_r = smoke_other;

manicure_other_r = input(manicure_other, $200.);
drop manicure_other;
rename manicure_other_r = manicure_other;

stratum_num_r = input(stratum_num, $20.);
drop stratum_num;
rename stratum_num_r = stratum_num;

*matching type for phone data;
chronic_kidney_r = input(chronic_kidney, $20.);
drop chronic_kidney;
rename chronic_kidney_r = chronic_kidney;

trust_radio_r = input(trust_radio, $20.);
drop trust_radio;
rename trust_radio_r = trust_radio;

cig_day_week_r = input(cig_day_week, $20.);
drop cig_day_week;
rename cig_day_week_r = cig_day_week;

piercing_home_r = input(piercing_home, $20.);
drop piercing_home;
rename piercing_home_r = piercing_home;
run;

***********
Phone
*********;

PROC IMPORT OUT= HCV8.phone 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Georgia He
p C Serosurvey\Data salvaged from phones_FINAL\Data salvaged from phones
_FINAL\phone8_for_import.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 guessingrows=5020;
RUN;
proc sort data=HCV8.phone;
by meta_instanceID;
run;

data HCV8.phone2;
length _TOP_LEVEL_AURI $100;
set HCV8.phone;
_Top_level_auri = meta_instanceID;
drop meta_instanceID;
q12=put(consent_Q12a_D2, 14.);
drop consent_Q12a_d2;
rename q12=consent_q12a_d2;

/*if _n_ in (1,2,3,4,5013,5014,5015,5016,5017,5018,5019,5020,5021,5022,5023) then delete;*/
run;

data HCV8.phone_format2;
/*length start_time $ 25; length end_time $ 25; length int_date $ 23; length birthday $ 14;*/

set HCV8.phone_format;

stratum_num_r = input(stratum_num, $20.);
drop stratum_num;
rename stratum_num_r = stratum_num;

hbv_trans_other_r = input(hbv_trans_other, $20.);
drop hbv_trans_other;
rename hbv_trans_other_r = hbv_trans_other;
run;

data HCV8.phone_merge;
length cluster_name $200.;
length surname $100.;
length ethnicity_other_specify $100.;
length house_other_specify $150.;
length medcare_pay_other_specify $200.;
length medcare_location_other_specify $200.;
length flu_other $100.;
length dentist_other_specify $200.;
length flushot_loc $200.;
length shot_admin_other $200.;
length shot_needle_other_specify $100.;
length shot_purpose_other_specify $180.;
length shot_med_other_specify $200.;
length surgery_other $200.;
length sti_other $100.;
length chronic_other_specify $300.;
length cancer_type $350.;
length HCV_prev_other $100.;
length HBV_trans_other_specify $150.;
length HCV_trans_other_specify $150.;
length walk_bike_typicalday $100.;
length tattoo_other_specify $100.;
length piercing_other_specify $100.;
length shave_other_specify $100.;
length phone_results $100.;
length address_results $300.;
length BP_ID $100.;
length disposition_other_specify $350.;
length HCV_notreat_other_specify $350.;
length smoke_other $100.;

merge  HCV8.HCVformat2 (in=database) HCV8.phone_format2 (in=phone) ;
by _Top_level_auri;
if phone=0 then database_v8=1;
phone_v8=phone;
if database=1;
run;

*********************************************************************************************
************************   Finished with v8, ready for merge   ******************************
*********************    Dataset to merge: HCV8.phone_merge      ******************************
*********************************************************************************************



*********************************************************************************************
*************************************       v9         **************************************
*********************************************************************************************

*/Georgia HCV+ Serosurvey;

libname HCV9 '\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data';
run;

*/Import 7 datasets from Task Force database;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE.csv"
            dbms=dlm
            out=HCV9.HCV_core
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core;
run;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE2.csv"
            dbms=dlm
            out=HCV9.HCV_core_2
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core_2 varnum;
run;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE3.csv"
            dbms=dlm
            out=HCV9.HCV_core_3
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core_3;
run;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE4.csv"
            dbms=dlm
            out=HCV9.HCV_core_4
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core_4;
run;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE5.csv"
            dbms=dlm
            out=HCV9.HCV_core_5
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core_5;
run;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE6.csv"
            dbms=dlm
            out=HCV9.HCV_core_6
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core_6;
run;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v9 data\GEORGIA_HCV_SURVEY_V9_CORE7.csv"
            dbms=dlm
            out=HCV9.HCV_core_7
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

proc contents data=HCV9.HCV_core_7;
run;



*/Sort 7 datasets by ID variable;

proc sort data=HCV9.HCV_core; by _URI;
run;

proc sort data=HCV9.HCV_core_2; by _TOP_LEVEL_AURI;
run;

proc sort data=HCV9.HCV_core_3; by _TOP_LEVEL_AURI;
run;

proc sort data=HCV9.HCV_core_4; by _TOP_LEVEL_AURI;
run;

proc sort data=HCV9.HCV_core_5; by _TOP_LEVEL_AURI;
run;

proc sort data=HCV9.HCV_core_6; by _TOP_LEVEL_AURI;
run;

proc sort data=HCV9.HCV_core_7; by _TOP_LEVEL_AURI;
run;



*/Rename ID variable in _core dataset to match all others and remove quotation marks;
data HCV9.HCV_core_v2; format _TOP_LEVEL_AURI $100.; set HCV9.HCV_core;

	_URI=compress(_URI, '"');
	_URI2=substr(_URI, 4, 41);
	_TOP_LEVEL_AURI=_URI2;

run;


*/Merge 7 datasets by ID variable and create check for errors;

data HCV9.HCVmerge;
	merge HCV9.HCV_core_v2 (in=ds_HCV_core_v2) HCV9.HCV_core_2 (in=ds_HCV_core_2) HCV9.HCV_core_3 (in=ds_HCV_core_3) HCV9.HCV_core_4 (in=ds_HCV_core_4) HCV9.HCV_core_5 (in=ds_HCV_core_5)
	HCV9.HCV_core_6 (in=ds_HCV_core_6) HCV9.HCV_core_7 (in=ds_HCV_core_7);
	by _TOP_LEVEL_AURI;
	core=ds_HCV_core_v2;
	core2=ds_HCV_core_2;
	core3=ds_HCV_core_3;
	core4=ds_HCV_core_4;
	core5=ds_HCV_core_5;
	core6=ds_HCV_core_6;
	core7=ds_HCV_core_7;
run;

data HCV9.HCVmerge2; 
length Q5_I5 $23;
length start_time $25;
length consent_q12A_d2 $14;
length end_time $25;
set HCV9.HCVmerge;
run;

*************************************************************************************
************************      Phone Data       **************************************
*************************************************************************************;

PROC IMPORT OUT= HCV9.phone 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Georgia He
p C Serosurvey\Data salvaged from phones_FINAL\Data salvaged from phones
_FINAL\Georgia_HCV_survey_v9_results_from phones_090415.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 guessingrows=405;
RUN;

proc sort data=HCV9.phone;
by meta_instanceID;
run;

data HCV9.phone2;
length _TOP_LEVEL_AURI $100;
set HCV9.phone;
_Top_level_auri = meta_instanceID;
drop meta_instanceID;
q12=put(consent_Q12a_D2, 14.);
drop consent_Q12a_d2;
rename q12=consent_q12a_d2;

/*if _n_ in (1, 566, 567) then delete;*/
run;

data HCV9.phone_merge;
merge  HCV9.HCVmerge2 (in=database) HCV9.phone2 (in=phone) ;
by _Top_level_auri;
if phone=0 then database_v9=1;
phone_v9=phone;
if database=1;
run;

data HCV9.HCVnull(drop= i test1 test2 /*data1 data2 data3 data4 data5 data6 data7*/); set HCV9.phone_merge;
array checknull (*) _char_;
	do i=1 to 398;
		test1=find(checknull(i),"NULL");
		test2=find(checknull(i),"NUL");
		if test1>0 or test2>0 then do;
			checknull(i)=" ";
		end;
	end;
run;

*/Rename variables and indicate which are numeric;;

data HCV9.HCVformat2;
set HCV9.HCVformat;

barcode_r = input(barcode, $20.);
drop barcode;
rename barcode_r = barcode;

cluster_ID_r = input(cluster_ID, $20.);
drop cluster_ID;
rename cluster_ID_r = cluster_ID;

HCV_notreat_other_specify_r = input(HCV_notreat_other_specify, $200.);
drop HCV_notreat_other_specify;
rename HCV_notreat_other_specify_r = HCV_notreat_other_specify;

smoke_other_num_r = input(smoke_other_num, $20.);
drop smoke_other_num;
rename smoke_other_num_r = smoke_other_num;

smoke_other_day_week_r = input(smoke_other_day_week, $20.);
drop smoke_other_day_week;
rename smoke_other_day_week_r = smoke_other_day_week;

manicure_salon_r = input(manicure_salon, $20.);
drop manicure_salon;
rename manicure_salon_r = manicure_salon;

manicure_homeservice_r = input(manicure_homeservice, $20.);
drop manicure_homeservice;
rename manicure_homeservice_r = manicure_homeservice;

manicure_self_r = input(manicure_self, $20.);
drop manicure_self;
rename manicure_self_r = manicure_self;

manicure_never_r = input(manicure_never, $20.);
drop manicure_never;
rename manicure_never_r = manicure_never;

barber_num_r = input(barber_num, $20.);
drop barber_num;
rename barber_num_r = barber_num;

IDU_otherdrug_r = input(IDU_otherdrug, $200.);
drop IDU_otherdrug;
rename IDU_otherdrug_r = IDU_otherdrug;

cuff_other_specify_r = input(cuff_other_specify, $20.);
drop cuff_other_specify;
rename cuff_other_specify_r = cuff_other_specify;

smoke_other_r = input(smoke_other, $20.);
drop smoke_other;
rename smoke_other_r = smoke_other;

manicure_other_r = input(manicure_other, $200.);
drop manicure_other;
rename manicure_other_r = manicure_other;

stratum_num_r = input(stratum_num, $20.);
drop stratum_num;
rename stratum_num_r = stratum_num;

*matching type for phone data;
chronic_kidney_r = input(chronic_kidney, $20.);
drop chronic_kidney;
rename chronic_kidney_r = chronic_kidney;

trust_radio_r = input(trust_radio, $20.);
drop trust_radio;
rename trust_radio_r = trust_radio;

cig_day_week_r = input(cig_day_week, $20.);
drop cig_day_week;
rename cig_day_week_r = cig_day_week;

piercing_home_r = input(piercing_home, $20.);
drop piercing_home;
rename piercing_home_r = piercing_home;
run;


*********************************************************************************************
************************   Finished with v9, ready for merge   ******************************
*********************    Dataset to merge: HCV9.HCVformat2      ******************************
*********************************************************************************************



*********************************************************************************************
*************************************       v10        **************************************
*********************************************************************************************

*/Georgia HCV+ Serosurvey;

libname HCV10 '\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data';
run;

*/Import 7 datasets from Task Force database;

proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE.csv"
            dbms=dlm
            out=HCV10.HCV_core
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE2.csv"
            dbms=dlm
            out=HCV10.HCV_core_2
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE3.csv"
            dbms=dlm
            out=HCV10.HCV_core_3
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE4.csv"
            dbms=dlm
            out=HCV10.HCV_core_4
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE5.csv"
            dbms=dlm
            out=HCV10.HCV_core_5
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE6.csv"
            dbms=dlm
            out=HCV10.HCV_core_6
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;
proc import datafile="\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey\Georgia HCV data FINAL from database\Georgia HCV data FINAL from database\Georgia HCV v10 data\GEORGIA_HCV_SURVEY_V10_CORE7.csv"
            dbms=dlm
            out=HCV10.HCV_core_7
            replace;
     		delimiter=';';
     		getnames=yes;
			guessingrows=5000;
run;

*/Sort 7 datasets by ID variable;

proc sort data=HCV10.HCV_core; by _URI;
run;
proc sort data=HCV10.HCV_core_2; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV10.HCV_core_3; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV10.HCV_core_4; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV10.HCV_core_5; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV10.HCV_core_6; by _TOP_LEVEL_AURI;
run;
proc sort data=HCV10.HCV_core_7; by _TOP_LEVEL_AURI;
run;

*/Rename ID variable in _core dataset to match all others and remove quotation marks;
data HCV10.HCV_core_v2; format _TOP_LEVEL_AURI $100.; set HCV10.HCV_core;

	_URI=compress(_URI, '"');
	_URI2=substr(_URI, 4, 41);
	_TOP_LEVEL_AURI=_URI2;

run;

*/Merge 7 datasets by ID variable and create check for errors;

data HCV10.HCVmerge;
	merge HCV10.HCV_core_v2 (in=ds_HCV_core_v2) HCV10.HCV_core_2 (in=ds_HCV_core_2) HCV10.HCV_core_3 (in=ds_HCV_core_3) HCV10.HCV_core_4 (in=ds_HCV_core_4) HCV10.HCV_core_5 (in=ds_HCV_core_5)
	HCV10.HCV_core_6 (in=ds_HCV_core_6) HCV10.HCV_core_7 (in=ds_HCV_core_7);
	by _TOP_LEVEL_AURI;
	core=ds_HCV_core_v2;
	core2=ds_HCV_core_2;
	core3=ds_HCV_core_3;
	core4=ds_HCV_core_4;
	core5=ds_HCV_core_5;
	core6=ds_HCV_core_6;
	core7=ds_HCV_core_7;
run;

data HCV10.HCVmerge2; 
length Q5_I5 $23;
length start_time $25;
length consent_q12A_d2 $14;
length end_time $25;
set HCV10.HCVmerge;
run;

*************************************************************************************
************************      Phone Data       **************************************
*************************************************************************************;

PROC IMPORT OUT= HCV10.phone 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Georgia He
p C Serosurvey\Data salvaged from phones_FINAL\Data salvaged from phones
_FINAL\Georgia_HCV_survey_v10_results_from phones_090415.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 guessingrows=192;
RUN;

proc sort data=HCV10.phone;
by meta_instanceID;
run;

data HCV10.phone2;
length _TOP_LEVEL_AURI $100;
set HCV10.phone;
_Top_level_auri = meta_instanceID;
drop meta_instanceID;
q12=put(consent_Q12a_D2, 14.);
drop consent_Q12a_d2;
rename q12=consent_q12a_d2;

/*if _n_ in (1, 566, 567) then delete;*/
run;

data HCV10.phone_merge;
merge  HCV10.HCVmerge2 (in=database) HCV10.phone2 (in=phone) ;
if phone=0 then database_v10=1;
phone_v10=phone;
by _Top_level_auri;
if database=1;
run;

data HCV10.HCVnull(drop= i test1 test2 /*data1 data2 data3 data4 data5 data6 data7*/); set HCV10.phone_merge;
array checknull (*) _char_;
	do i=1 to 398;
		test1=find(checknull(i),"NULL");
		test2=find(checknull(i),"NUL");
		if test1>0 or test2>0 then do;
			checknull(i)=" ";
		end;
	end;
run;

*/Rename variables and indicate which are numeric;;




data HCV10.HCVformat2;
set HCV10.HCVformat;

barcode_r = input(barcode, $20.);
drop barcode;
rename barcode_r = barcode;

cluster_ID_r = input(cluster_ID, $20.);
drop cluster_ID;
rename cluster_ID_r = cluster_ID;

HCV_notreat_other_specify_r = input(HCV_notreat_other_specify, $200.);
drop HCV_notreat_other_specify;
rename HCV_notreat_other_specify_r = HCV_notreat_other_specify;

smoke_other_num_r = input(smoke_other_num, $20.);
drop smoke_other_num;
rename smoke_other_num_r = smoke_other_num;

smoke_other_day_week_r = input(smoke_other_day_week, $20.);
drop smoke_other_day_week;
rename smoke_other_day_week_r = smoke_other_day_week;

manicure_salon_r = input(manicure_salon, $20.);
drop manicure_salon;
rename manicure_salon_r = manicure_salon;

manicure_homeservice_r = input(manicure_homeservice, $20.);
drop manicure_homeservice;
rename manicure_homeservice_r = manicure_homeservice;

manicure_self_r = input(manicure_self, $20.);
drop manicure_self;
rename manicure_self_r = manicure_self;

manicure_never_r = input(manicure_never, $20.);
drop manicure_never;
rename manicure_never_r = manicure_never;

barber_num_r = input(barber_num, $20.);
drop barber_num;
rename barber_num_r = barber_num;

IDU_otherdrug_r = input(IDU_otherdrug, $200.);
drop IDU_otherdrug;
rename IDU_otherdrug_r = IDU_otherdrug;

cuff_other_specify_r = input(cuff_other_specify, $20.);
drop cuff_other_specify;
rename cuff_other_specify_r = cuff_other_specify;

smoke_other_r = input(smoke_other, $20.);
drop smoke_other;
rename smoke_other_r = smoke_other;

manicure_other_r = input(manicure_other, $200.);
drop manicure_other;
rename manicure_other_r = manicure_other;

stratum_num_r = input(stratum_num, $20.);
drop stratum_num;
rename stratum_num_r = stratum_num;

*matching type for phone data;
chronic_kidney_r = input(chronic_kidney, $20.);
drop chronic_kidney;
rename chronic_kidney_r = chronic_kidney;

trust_radio_r = input(trust_radio, $20.);
drop trust_radio;
rename trust_radio_r = trust_radio;

cig_day_week_r = input(cig_day_week, $20.);
drop cig_day_week;
rename cig_day_week_r = cig_day_week;

piercing_home_r = input(piercing_home, $20.);
drop piercing_home;
rename piercing_home_r = piercing_home;
run;


*********************************************************************************************
************************   Finished with v10, ready for merge   ******************************
*********************    Dataset to merge: HCV10.HCVformat2      ******************************
*********************************************************************************************



*********************************************************************************************
*************************************     Combining    **************************************
*********************************************************************************************;

/* Combining v7, v8, v9, and v10 datasets  */

libname g "\\cdc.gov\private\L330\ykf1\New folder\Georgia Hep C Serosurvey";

data g.combined_v7_v8_v9_v10;

length cluster_name $200;
length surname $100;
length ethnicity_other_specify $100;
length house_other_specify $200;
length medcare_pay_other_specify $200;
length medcare_location_other_specify $200;
length flu_other $200;
length dentist_other_specify $200;
length flushot_loc $200;
length shot_admin_other $200;
length shot_needle_other_specify $100;
length shot_purpose_other_specify $180;
length shot_med_other_specify $200;
length surgery_other $200;
length sti_other $100;
length chronic_other_specify $300;
length cancer_type $350;
length HCV_prev_other $100;
length HBV_trans_other_specify $150;
length HCV_trans_other_specify $150;
length walk_bike_typicalday $100;
length tattoo_other_specify $100;
length piercing_other_specify $200;
length shave_other_specify $100;
length phone_results $100;
length address_results $300;
length BP_ID $100;
length disposition_other_specify $350;
length HCV_notreat_other_specify $350;
length smoke_other $100;

length int_id_quest $ 100;
length int_date $ 100;
length f_name $ 100;
length birthday $ 100;

length nurse_ID $ 100;
length phone_results $100;
length height_ID $100;
length weight_ID $100;
length blood_time $100;
length int_start_time $100;
length trust_other_specify $100;
length waist_ID $100;
set HCV7.for_merge HCV8.phone_merge HCV9.HCVformat2 HCV10.HCVformat2;
run;

proc compare 
base=g.combined_v7_v8_v9_v10
compare=combined_v7_v8_v9_v10;
run;

data g.prep;
set g.combined_v7_v8_v9_v10;

cig_day_week_r = input(cig_day_week, 8.0);
drop cig_day_week;
rename cig_day_week_r = cig_day_week;

smoke_other_day_week_r = input(smoke_other_day_week, 8.0);
drop smoke_other_day_week;
rename smoke_other_day_week_r = smoke_other_day_week;

piercing_home_r = input(piercing_home, 8.0);
drop piercing_home;
rename piercing_home_r = piercing_home;

manicure_salon_r = input(manicure_salon, 8.0);
drop manicure_salon;
rename manicure_salon_r = manicure_salon;

manicure_homeservice_r = input(manicure_homeservice, 8.0);
drop manicure_homeservice;
rename manicure_homeservice_r = manicure_homeservice;

manicure_self_r = input(manicure_self, 8.0);
drop manicure_self;
rename manicure_self_r = manicure_self;

manicure_never_r = input(manicure_never, 8.0);
drop manicure_never;
rename manicure_never_r = manicure_never;

chronic_kidney_r = input(chronic_kidney, 8.0);
drop chronic_kidney;
rename chronic_kidney_r = chronic_kidney;

trust_radio_r = input(trust_radio, 8.0);
drop trust_radio;
rename trust_radio_r = trust_radio;

run;

data g.format; set g.prep;
	format walk_bike_lastweek consent_int consent_NCD consent_blood consent_bank BP_treat kyphotic blood_collected blood_donate_relative
           blood_donate_money tb_treat hypertension_ever insulin_current HCV_heard HBV_heard alc_month alc_ever alc_year YES_NO.;
	format smoke_past pregnant flushot shot_discard dialysis_ever dialysis_current blood_trans_relative blood_donate
           med_invasive surgery_ever tb_ever tb_year bp_meas hypertension_year sugar_meas diabetes_ever diabetes_year
           sugar_test_share insulin_syringe_share HCV_asymptomatic HCV_med HBV_asymptomatic HBV_med HCV_ever HBV_ever
		   HBV_vacc_ever YES_NO_DK.;
	format prison MSM YES_NO_RF.;
	format IDU_ever IDU_share1 IDU_share2 sex_STI sex_HBV sex_HCV sex_HIV insurance displaced flu sti_ever HIV_test
           HCV_treated HCV_cured YES_NO_DK_RF.;
	format blood_trans YES_NO_DATE.;
	format smoke_current_freq smoke_past_freq FREQa.;
	format IDU_num_life FREQb.;
	format IDU_num_6mo FREQc.;
	format condom MSM_condom FREQd.;
	format dentist_cat FREQe.;
	format alc_year_freq FREQf.;
	format cig_day_week hand_cig_day_week pipe_day_week cigar_day_week smoke_other_day_week DAY_WEEK.;
	format gender GENDER.;
	format ethnicity ETHNICITY.;
	format tattoo_needle tattoo_ink piercing_needle shave_razor NEW_USED.;
	format shave_barber shave_home shave_none IDU_needle_NEP IDU_needle_store IDU_needle_order IDU_needle_borrow IDU_needle_rent
		   IDU_needle_DK IDU_needle_none heprisk_toothbrush heprisk_razor heprisk_scissors heprisk_brush heprisk_nail heprisk_none heprisk_DK IDU_vent IDU_jeff
		   IDU_krokodil IDU_opium IDU_med IDU_poppy IDU_heroin IDU_alcohol IDU_cocaine IDU_crack IDU_psych IDU_ecstasy IDU_drug_DK IDU_drug_RF sex_healthcare
		   sex_military sex_police sex_dialysis sex_IDU sex_CSW sex_none sex_RF CHECK_ALL_one.; 
	format tattoo_salon tattoo_home tattoo_prison tattoo_other tattoo_DK piercing_salon
		   piercing_home piercing_prison piercing_other piercing_DK CHECK_ALL_two.;
	format work_healthcare work_military work_police manicure_salon manicure_homeservice manicure_self manicure_never CHECK_ALL_three.; 
	format flu_polyclinic flu_hospital flu_medhome flu_pharmacy flu_villagedoc flu_none  CHECK_ALL_four.;
	format dialysis_polyclinic dialysis_hospital dialysis_home dialysis_villagedoc surgery_hospital surgery_nursing surgery_polyclinic 
		   surgery_DK sti_syphilis sti_gonorrhea sti_chlamydia sti_herpes sti_warts chronic_asthma 
           chronic_arthritis chronic_cancer chronic_CVD chronic_COPD chronic_hemophilia chronic_thyroid chronic_kidney chronic_lung  
           chronic_DK chronic_other dentist_hospital dentist_cabinet dentist_home dentist_DK HCV_trans_droplets HCV_trans_food HCV_trans_blood HCV_trans_sex 
           HCV_trans_handshake HCV_trans_hh_objects HCV_trans_needle HCV_trans_touch HCV_trans_DK HCV_trans_none HCV_prev_vacc 
           HCV_prev_condom HCV_prev_needle HCV_prev_wash HCV_prev_sterile HCV_prev_DK HCV_prev_none CHECK_ALL_five.;
	format trust_family trust_medlit trust_newspaper trust_radio trust_tv
		   trust_internet trust_billboards trust_brochures trust_doctor trust_pharmacist trust_DK trust_none trust_other HBV_trans_droplets HBV_trans_food
		   HBV_trans_sex HBV_trans_blood HBV_trans_handshake HBV_trans_hh_objects HBV_trans_needle HBV_trans_touch HBV_trans_DK HBV_trans_none HBV_trans_other HBV_prev_vacc
		   HBV_prev_condom HBV_prev_needle HBV_prev_wash HBV_prev_sterile HBV_prev_DK HBV_prev_none HCV_notreat_avail HCV_notreat_eligible HCV_notreat_expense
		   HCV_notreat_effect HCV_notreat_inject HCV_notreat_travel HCV_notreat_DK HCV_notreat_RF hep_other_A hep_other_D hep_other_E hep_other_none hep_other_DK
		   CHECK_ALL_six.;

	format education EDU.;
	format cuff CUFF.;
	format religion RELIGION.;
	format married MARRIED.;
	format work WORK.;
	format house HOUSE.;
	format earnings_cat EARN_CAT.;
	format earnings_estimate EARN_EST.;
	format insurance_type INSURANCE.;
	format medcare_pay MEDPAY.;
	format medcare_location MEDLOC.;
	format shot_admin SHOTADMIN.;
	format shot_needle SHOTSOURCE.;
	format shot_purpose SHOTPURPOSE.;
	format shot_med SHOTMED.;
	format HIV_result HIVTEST.;
	format language LANG.;
	format HCV_treat_complete HCVMED.;
	format HBV_treated HBVMED.;
	format disposition EXIT.;

run;

********************************************************************************************;

proc print data =g.combined_for_merge2 (obs=15);
var stratum_num2 cluster_ID2 hh_num   hh_num2;
run;

data g.combined_for_merge;
set g.combined_v7_v8_v9_v10;
/*barcode2=barcode;*/

s=input(      compress(stratum_num, "ABCDEFGHIJKLMNOPQRSTUVWXYZ?.abcdefghijklmnopqrstuvwxyz"),      8.0);
c=input(      compress(cluster_ID,  "ABCDEFGHIJKLMNOPQRSTUVWXYZ?.abcdefghijklmnopqrstuvwxyz"),      8.0);
/*h=input(      compress(hh_num,      "ABCDEFGHIJKLMNOPQRSTUVWXYZ?.abcdefghijklmnopqrstuvwxyz"),      8.0);*/
drop stratum_num cluster_ID /*hh_num*/;

rename s = stratum_num;
rename c = cluster_ID;
/*rename h = hh_num;*/
run;

data g.combined_for_merge2;
set g.combined_for_merge;

if stratum_num < 10 then stratum_num2 = cat("0", stratum_num); 
	else stratum_num2 = stratum_num;

if cluster_ID < 10 then cluster_ID2 = cat("0", cluster_ID); 
	else cluster_ID2 = cluster_ID;

if hh_num >= 100 then digits_hh = int(log10(hh_num))+1;

if hh_num < 10 then hh_num2 = cat("0", hh_num); 
	else hh_num2 = hh_num;
run;

data g.combined_for_merge3;
set g.combined_for_merge2;

if digits_hh = 6 then hh_num2 = substr(;
	if digits_hh = 5 then hh_num2 = hh_num - floor(hh_num, 10);
	if digits_hh = 4 then hh_num2 = hh_num - floor(hh_num, 10);
	if digits_hh = 3 then hh_num2 = hh_num - floor(hh_num, 10);

if hh_num >= 10 and hh_num < 100 then hh_num2 = hh_num;


barcode2 = cats (stratum_num2, cluster_ID2, hh_num2);
run;
