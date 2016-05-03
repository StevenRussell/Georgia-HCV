
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

*/Change "NULL" and "NUL" responses to missing;;
data HCV7.HCVnull(drop= i test1 test2 /*data1 data2 data3 data4 data5 data6 data7*/); set HCV7.HCVmerge; /*comb;*/
array checknull (354) $ CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
CONSENT_CONSENT2_Q121_R11
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
CONSENT_CONSENT2_Q30_M2
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
CONSENT_CONSENT2_Q55_STI1
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_Q9_I9
CONSENT_Q10_I10
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20A_D10_OTHER
CONSENT_Q20_D10
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K
CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E
CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E
CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9
CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E
CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E
CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K
CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M
CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H
CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K
CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G
CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E
CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D
CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G
CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H
CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F
CONSNTCNSENT2Q29CM1C_Q29C_G
CONSENT_CONSENT2_Q32_M4A
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G
CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K
CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I
CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I
CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O
CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F
Q0_BARCODE
Q1_I1
Q11_D1
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22
Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31
Q2A_I2
Q3A_I3
Q3B_I3
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
;
	do i=1 to 354;
		test1=find(checknull(i),"NULL");
		test2=find(checknull(i),"NUL");
		if test1>0 or test2>0 then do;
			checknull(i)=" ";
		end;
	end;
run;

*/Rename variables and indicate which are numeric;;
data HCV7.HCVrecode;
	set HCV7.HCVnull;
barcode=input(Q0_BARCODE,8.0);
int_id_quest=Q1_I1;
hh_num=input(Q2A_I2,8.0);
stratum_num=input(Q3A_I3,8.0);
cluster_ID=input(Q3B_I3,8.0);
cluster_name=Q4_I4;
int_date=Q5_I5;
int_start_time=Q6_I6;
consent_int=input(Q7_I7,8.0);
consent_demo=input(Q7A_CONSENT,8.0);
language=input(Q8_I8,8.0);
surname=CONSENT_Q9_I9;
f_name=CONSENT_Q10_I10;
gender=input(Q11_D1,8.0);
birthday=CONSENT_Q12A_D2;
birthyear=input(CONSENT_Q12B_D2,8.0);
age=input(CONSENT_Q13_D3,8.0);
education=input(CONSENT_Q14_D4,8.0);
ethnicity=input(CONSENT_Q15_D5,8.0);
ethnicity_other_specify=CONSENT_Q15A_D5_OTHER;
religion=input(CONSENT_Q16_D6,8.0);
religion_other_specify=CONSENT_Q16A_D6_OTHER;
married=input(CONSENT_Q17_D7,8.0);
work=input(CONSENT_Q18_D8,8.0);
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);
house=input(CONSENT_Q20_D10,8.0);
house_other_specify=CONSENT_Q20A_D10_OTHER;
resident_num=input(CONSENT_Q21_D11,8.0);
earnings_cat=input(CONSENT_Q22_D12,8.0);
earnings_amount=input(CONSENT_Q22A_D12,8.0);
earnings_estimate=input(CONSENT_Q23_D13,8.0);
earners_num=input(CONSENT_Q24_D14,8.0);
insurance=input(CONSENT_Q25_D15,8.0);
insurance_type=input(CONSENT_Q26_D16,8.0);
medcare_pay=input(CONSENT_Q27_D17,8.0);
medcare_pay_other_specify=CONSENT_Q27A_D17_OTHER;
displaced=input(CONSENT_Q28_D18,8.0);
medcare_location=input(CONSENT_CONSENT2_Q29_M1,8.0);
medcare_location_other_specify=CONSENT_CONSENT2_Q29A_M1_OTHER;
flu=input(CONSENT_CONSENT2_Q29B_M1B,8.0);
flu_polyclinic=input(CONSNTCNSENT2Q29CM1C_Q29C_A,8.0);
flu_hospital=input(CONSNTCNSENT2Q29CM1C_Q29C_B,8.0);
flu_medhome=input(CONSNTCNSENT2Q29CM1C_Q29C_C,8.0);
flu_pharmacy=input(CONSNTCNSENT2Q29CM1C_Q29C_D,8.0);
flu_villagedoc=input(CONSNTCNSENT2Q29CM1C_Q29C_E,8.0);
flu_none=input(CONSNTCNSENT2Q29CM1C_Q29C_F,8.0);
hospital_lifetime_num=input(CONSENT_CONSENT2_Q30_M2,8.0);
flu_other=CONSNTCNSENT2Q29CM1C_Q29C_G;
dentist_cat=input(CONSENT_CONSENT2_Q31_M3,8.0);
dentist_other_specify=CONSENT_CONSENT2_Q32_M4A;
dentist_hospital=input(CONSENTCONSENT2Q32M4_Q32A,8.0);
dentist_cabinet=input(CONSENTCONSENT2Q32M4_Q32B,8.0);
dentist_home=input(CONSENTCONSENT2Q32M4_Q32C,8.0);
dentist_other=input(CONSENTCONSENT2Q32M4_Q32D,8.0);
dentist_DK=input(CONSENTCONSENT2Q32M4_Q32E,8.0);
dental_proc_num=input(CONSENT_CONSENT2_Q33_M5,8.0);
shot_num=input(CONSENT_CONSENT2_Q34_M6,8.0);
flushot=input(CONSENT_CONSENT2_Q34A_M6_1,8.0);
flushot_loc=CONSENT_CONSENT2_Q34B_M6_2;
shot_admin=input(CONSENT_CONSENT2_Q35_M7,8.0);
shot_admin_other=CONSENT_CONSENT2_Q35A_M7_OTHER;
shot_needle=input(CONSENT_CONSENT2_Q36_M8,8.0);
shot_needle_other_specify=CONSENT_CONSENT2_Q36A_M8_OTHER;
shot_purpose=input(CONSENT_CONSENT2_Q37_M9,8.0);
shot_purpose_other_specify=CONSENT_CONSENT2_Q37A_M9_OTHER;
shot_med=input(CONSENT_CONSENT2_Q38_M10,8.0);
shot_med_other_specify=CONSENT_CONSENT2_Q38A_M10_OTHER;
shot_discard=input(CONSENT_CONSENT2_Q39_M11,8.0);
IV_num=input(CONSENT_CONSENT2_Q40_M12,8.0);
dialysis_ever=input(CONSENT_CONSENT2_Q41_M14,8.0);
dialysis_polyclinic=input(CONSNTCNSENT2Q42M15_Q42A,8.0);
dialysis_hospital=input(CONSNTCNSENT2Q42M15_Q42B,8.0);
dialysis_home=input(CONSNTCNSENT2Q42M15_Q42C,8.0);
dialysis_pharmacy=input(CONSNTCNSENT2Q42M15_Q42D,8.0);
dialysis_villagedoc=input(CONSNTCNSENT2Q42M15_Q42E,8.0);
dialysis_other=input(CONSNTCNSENT2Q42M15_Q42G,8.0);
dialysis_current=input(CONSENT_CONSENT2_Q43_M16,8.0);
dialysis_freq=input(CONSENT_CONSENT2_Q44_M17,8.0);
blood_trans=input(CONSENT_CONSENT2_Q45_M18,8.0);
blood_trans_num=input(CONSENT_CONSENT2_Q46_M19,8.0);
blood_trans_relative=input(CONSENT_CONSENT2_Q47_M20,8.0);
blood_donate=input(CONSENT_CONSENT2_Q48_M21,8.0);
blood_donate_relative=input(CONSENT_CONSENT2_Q49_M22,8.0);
blood_donate_money=input(CONSENT_CONSENT2_Q50_M23,8.0);
med_invasive=input(CONSENT_CONSENT2_Q51_S1,8.0);
surgery_ever=input(CONSENT_CONSENT2_Q52_S2,8.0);
surgery_num=input(CONSENT_CONSENT2_Q53_S3,8.0);
surgery_hospital=input(CONSENTCONSENT2Q54S4_Q54A,8.0);
surgery_nursing=input(CONSENTCONSENT2Q54S4_Q54B,8.0);
surgery_polyclinic=input(CONSENTCONSENT2Q54S4_Q54C,8.0);
surgery_other=CONSENTCONSENT2Q54S4_Q54D;
surgery_DK=input(CONSENTCONSENT2Q54S4_Q54E,8.0);
sti_ever=input(CONSENT_CONSENT2_Q55_STI1,8.0);
sti_syphilis=input(CONSNTCONSNT2Q56STI2_Q56A,8.0);
sti_gonorrhea=input(CONSNTCONSNT2Q56STI2_Q56B,8.0);
sti_chlamydia=input(CONSNTCONSNT2Q56STI2_Q56C,8.0);
sti_herpes=input(CONSNTCONSNT2Q56STI2_Q56D,8.0);
sti_warts=input(CONSNTCONSNT2Q56STI2_Q56E,8.0);
sti_other=CONSNTCONSNT2Q56STI2_Q56F;
HIV_test=input(CONSENT_CONSENT2_Q57_STI3,8.0);
HIV_result=input(CONSENT_CONSENT2_Q58_STI4,8.0);
tb_ever=input(CONSENT_CONSENT2_Q59_TB1,8.0);
tb_year=input(CONSENT_CONSENT2_Q60_TB2,8.0);
tb_treat=input(CONSENT_CONSENT2_Q61_TB3,8.0);
bp_meas=input(CONSENT_CONSENT2_Q62_HY1,8.0);
hypertension_ever=input(CONSENT_CONSENT2_Q63_HY2,8.0);
hypertension_year=input(CONSENT_CONSENT2_Q64_HY3,8.0);
sugar_meas=input(CONSENT_CONSENT2_Q65_D1,8.0);
diabetes_ever=input(CONSENT_CONSENT2_Q66_D2,8.0);
diabetes_year=input(CONSENT_CONSENT2_Q67_D3,8.0);
insulin_current=input(CONSENT_CONSENT2_Q68_D4,8.0);
sugar_test_share=input(CONSENT_CONSENT2_Q69_D5,8.0);
insulin_syringe_share=input(CONSENT_CONSENT2_Q70_D6,8.0);
chronic_asthma=input(CONSNTCNSENT2Q71CD1_Q71A,8.0);
chronic_arthritis=input(CONSNTCNSENT2Q71CD1_Q71B,8.0);
chronic_cancer=input(CONSNTCNSENT2Q71CD1_Q71C,8.0);
chronic_CVD=input(CONSNTCNSENT2Q71CD1_Q71D,8.0);
chronic_COPD=input(CONSNTCNSENT2Q71CD1_Q71E,8.0);
chronic_hemophilia=input(CONSNTCNSENT2Q71CD1_Q71F,8.0);
chronic_thyroid=input(CONSNTCNSENT2Q71CD1_Q71G,8.0);
chronic_kidney=input(CONSNTCNSENT2Q71CD1_Q71H,8.0);
chronic_lung=input(CONSNTCNSENT2Q71CD1_Q71I,8.0);
chronic_other=input(CONSNTCNSENT2Q71CD1_Q71J,8.0);
chronic_DK=input(CONSNTCNSENT2Q71CD1_Q71K,8.0);
chronic_other_specify=CONSENT_CONSENT2_Q71L_CD1_OTHER;
cancer_type=CONSENT_CONSENT2_Q72_CD2;
HCV_heard=input(CONSENT_CONSENT2_Q73_H1,8.0);
HCV_trans_droplets=input(CONSENTCONSENT2Q74H2_Q74A,8.0);
HCV_trans_food=input(CONSENTCONSENT2Q74H2_Q74B,8.0);
HCV_trans_blood=input(CONSENTCONSENT2Q74H2_Q74C,8.0);
HCV_trans_sex=input(CONSENTCONSENT2Q74H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENTCONSENT2Q74H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENTCONSENT2Q74H2_Q74F,8.0);
HCV_trans_needle=input(CONSENTCONSENT2Q74H2_Q74G,8.0);
HCV_trans_touch=input(CONSENTCONSENT2Q74H2_Q74H,8.0);
HCV_trans_DK=input(CONSENTCONSENT2Q74H2_Q74I,8.0);
HCV_trans_none=input(CONSENTCONSENT2Q74H2_Q74J,8.0);
HCV_trans_other=input(CONSENTCONSENT2Q74H2_Q74K,8.0);
HCV_trans_other_specify=CONSENT_CONSENT2_Q74L_H2A;
HCV_asymptomatic=input(CONSENT_CONSENT2_Q75_H3,8.0);
HCV_med=input(CONSENT_CONSENT2_Q76_H4,8.0);
HCV_prev_vacc=input(CONSENTCONSENT2Q7H5_Q77A,8.0);
HCV_prev_condom=input(CONSENTCONSENT2Q7H5_Q77B,8.0);
HCV_prev_needle=input(CONSENTCONSENT2Q7H5_Q77C,8.0);
HCV_prev_wash=input(CONSENTCONSENT2Q7H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENTCONSENT2Q7H5_Q77E,8.0);
HCV_prev_DK=input(CONSENTCONSENT2Q7H5_Q77F,8.0);
HCV_prev_other=CONSENTCONSENT2Q7H5_Q77G;
HCV_prev_none=input(CONSENTCONSENT2Q7H5_Q77H,8.0);
trust_family=input(CONSENTCONSENT2Q78H6_Q78A,8.0);
trust_medlit=input(CONSENTCONSENT2Q78H6_Q78B,8.0);
trust_newspaper=input(CONSENTCONSENT2Q78H6_Q78C,8.0);
trust_radio=input(CONSENTCONSENT2Q78H6_Q78D,8.0);
trust_tv=input(CONSENTCONSENT2Q78H6_Q78E,8.0);
trust_internet=input(CONSENTCONSENT2Q78H6_Q78F,8.0);
trust_billboards=input(CONSENTCONSENT2Q78H6_Q78G,8.0);
trust_brochures=input(CONSENTCONSENT2Q78H6_Q78H,8.0);
trust_doctor=input(CONSENTCONSENT2Q78H6_Q78I,8.0);
trust_pharmacist=input(CONSENTCONSENT2Q78H6_Q78J,8.0);
trust_DK=input(CONSENTCONSENT2Q78H6_Q78K,8.0);
trust_none=input(CONSENTCONSENT2Q78H6_Q78L,8.0);
trust_other=input(CONSENTCONSENT2Q78H6_Q78M,8.0);
trust_other_specify=CONSENT_CONSENT2_Q78N_H6A;
HBV_heard=input(CONSENT_CONSENT2_Q79_H7,8.0);
HBV_trans_droplets=input(CONSENTCONSENT2Q80H8_Q80A,8.0);
HBV_trans_food=input(CONSENTCONSENT2Q80H8_Q80B,8.0);
HBV_trans_blood=input(CONSENTCONSENT2Q80H8_Q80C,8.0);
HBV_trans_sex=input(CONSENTCONSENT2Q80H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENTCONSENT2Q80H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENTCONSENT2Q80H8_Q80F,8.0);
HBV_trans_needle=input(CONSENTCONSENT2Q80H8_Q80G,8.0);
HBV_trans_touch=input(CONSENTCONSENT2Q80H8_Q80H,8.0);
HBV_trans_DK=input(CONSENTCONSENT2Q80H8_Q80I,8.0);
HBV_trans_none=input(CONSENTCONSENT2Q80H8_Q80J,8.0);
HBV_trans_other=input(CONSENTCONSENT2Q80H8_Q80K,8.0);
HBV_trans_other_specify=CONSENT_CONSENT2_Q80L_H8A;
HBV_asymptomatic=input(CONSENT_CONSENT2_Q81_H9,8.0);
HBV_med=input(CONSENT_CONSENT2_Q82_H10,8.0);
HBV_prev_vacc=input(CONSENTCONSENT2Q83H1_Q83A,8.0);
HBV_prev_condom=input(CONSENTCONSENT2Q83H1_Q83B,8.0);
HBV_prev_needle=input(CONSENTCONSENT2Q83H1_Q83C,8.0);
HBV_prev_wash=input(CONSENTCONSENT2Q83H1_Q83D,8.0);
HBV_prev_sterile=input(CONSENTCONSENT2Q83H1_Q83E,8.0);
HBV_prev_DK=input(CONSENTCONSENT2Q83H1_Q83F,8.0);
HBV_prev_none=input(CONSENTCONSENT2Q83H1_Q83G,8.0);
HCV_ever=input(CONSENT_CONSENT2_Q84_H12,8.0);
HCV_year=input(CONSENT_CONSENT2_Q85_H13,8.0);
HCV_treated=input(CONSENT_CONSENT2_Q86_H14,8.0);
HCV_notreat_avail=input(CONSNTCNSENT2Q87H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSNTCNSENT2Q87H15_Q87B,8.0);
HCV_notreat_expense=input(CONSNTCNSENT2Q87H15_Q87C,8.0);
HCV_notreat_effect=input(CONSNTCNSENT2Q87H15_Q87D,8.0);
HCV_notreat_inject=input(CONSNTCNSENT2Q87H15_Q87E,8.0);
HCV_notreat_other_specify=CONSNTCNSENT2Q87H15_Q87F;
HCV_notreat_DK=input(CONSNTCNSENT2Q87H15_Q87G,8.0);
HCV_notreat_RF=input(CONSNTCNSENT2Q87H15_Q87H,8.0);
HCV_notreat_travel=input(CONSNTCNSENT2Q87H15_Q87I,8.0);
HCV_treat_complete=input(CONSENT_CONSENT2_Q88_H16,8.0);
HCV_cured=input(CONSENT_CONSENT2_Q89_H17,8.0);
HBV_ever=input(CONSENT_CONSENT2_Q90_H18,8.0);
HBV_year=input(CONSENT_CONSENT2_Q91_H19,8.0);
HBV_treated=input(CONSENT_CONSENT2_Q92_H20,8.0);
HBV_vacc_ever=input(CONSENT_CONSENT2_Q93_H21,8.0);
hep_other_A=input(CONSENTCONSENT2Q94H2_Q94A,8.0);
hep_other_D=input(CONSENTCONSENT2Q94H2_Q94B,8.0);
hep_other_E=input(CONSENTCONSENT2Q94H2_Q94C,8.0);
hep_other_none=input(CONSENTCONSENT2Q94H2_Q94D,8.0);
hep_other_DK=input(CONSENTCONSENT2Q94H2_Q94E,8.0);
hep_other_year=input(CONSENT_CONSENT2_Q95_H23,8.0);
alc_ever=input(CONSENT_CONSENT2_Q96_A1A,8.0);
alc_year=input(CONSENT_CONSENT2_Q97_A1B,8.0);
alc_year_freq=input(CONSENT_CONSENT2_Q98_A2,8.0);
alc_month=input(CONSENT_CONSENT2_Q99_A3,8.0);
alc_occasions=input(CONSENT_CONSENT2_Q100_A4,8.0);
alc_drinks=input(CONSENT_CONSENT2_Q101_A5,8.0);
alc_max=input(CONSENT_CONSENT2_Q102_A6,8.0);
alc_male=input(CONSENT_CONSENT2_Q103A_A7_MALES,8.0);
alc_female=input(CONSENT_CONSENT2_Q103B_A7_FEMAL,8.0);
walk_bike_lastweek=input(CONSENT_CONSENT2_Q104_PA1,8.0);
walk_bike_typicalweek=input(CONSENT_CONSENT2_Q105_PA2,8.0);
walk_bike_typicalday=CONSENT_CONSENT2_Q106_PA3;
smoke_current_freq=input(CONSENT_CONSENT2_Q107_T1,8.0);
smoke_past=input(CONSENT_CONSENT2_Q108_T2,8.0);
smoke_past_freq=input(CONSENT_CONSENT2_Q109_T3,8.0);
cig_num=input(CONSENTCONSENT2Q10T4_Q110A,8.0);
cig_day_week=input(CONSENTCONSENT2Q10T4_Q110B,8.0);
hand_cig_num=input(CONSENTCONSENT2Q10T4_Q110C,8.0);
hand_cig_day_week=input(CONSENTCONSENT2Q10T4_Q110D,8.0);
pipe_num=input(CONSENTCONSENT2Q10T4_Q110E,8.0);
pipe_day_week=input(CONSENTCONSENT2Q10T4_Q110F,8.0);
cigar_num=input(CONSENTCONSENT2Q10T4_Q110G,8.0);
cigar_day_week=input(CONSENTCONSENT2Q10T4_Q110H,8.0);
smoke_other=CONSENTCONSENT2Q10T4_Q110I;
smoke_other_num=input(CONSENTCONSENT2Q10T4_Q110J,8.0);
smoke_other_day_week=input(CONSENTCONSENT2Q10T4_Q110K,8.0);
prison=input(CONSENT_CONSENT2_Q111_R1,8.0);
tattoo=input(CONSENT_CONSENT2_Q112_R2,8.0);
tattoo_other_specify=CONSENT_CONSENT2_Q113F_R3A;
tattoo_needle=input(CONSENT_CONSENT2_Q114_R4,8.0);
tattoo_ink=input(CONSENT_CONSENT2_Q115_R5,8.0);
piercing=input(CONSENT_CONSENT2_Q116_R6,8.0);
piercing_other_specify=CONSENT_CONSENT2_Q117F_R7A;
piercing_salon=input(CONSENTCONSENT2Q17R7_Q117A,8.0);
piercing_home=input(CONSENTCONSENT2Q17R7_Q117B,8.0);
piercing_prison=input(CONSENTCONSENT2Q17R7_Q117C,8.0);
piercing_other=input(CONSENTCONSENT2Q17R7_Q117D,8.0);
piercing_DK=input(CONSENTCONSENT2Q17R7_Q117E,8.0);
piercing_needle=input(CONSENT_CONSENT2_Q118_R8,8.0);
manicure_num=input(CONSENT_CONSENT2_Q119A_R9A,8.0);
manicure_salon=input(CONSENTCONSENT2Q19R9_Q119A_R9,8.0);
manicure_homeservice=input(CONSENTCONSENT2Q19R9_Q119B_R9,8.0);
manicure_self=input(CONSENTCONSENT2Q19R9_Q119C_R9,8.0);
manicure_never=input(CONSENTCONSENT2Q19R9_Q119D_R9,8.0);
manicure_other=CONSENTCONSENT2Q19R9_Q119E_R9;
barber_num=input(CONSENT_CONSENT2_Q120A_R10A,8.0);
shave_other_specify=CONSENT_CONSENT2_Q120E_R10E;
shave_barber=input(CONSNTCNSENT2Q120R10_Q120A,8.0);
shave_home=input(CONSNTCNSENT2Q120R10_Q120B,8.0);
shave_none=input(CONSNTCNSENT2Q120R10_Q120C,8.0);
shave_other=input(CONSNTCNSENT2Q120R10_Q120D,8.0);
shave_razor=input(CONSENT_CONSENT2_Q121_R11,8.0);
heprisk_toothbrush=input(CONSNTCNSENT2Q12R12_Q122A,8.0);
heprisk_razor=input(CONSNTCNSENT2Q12R12_Q122B,8.0);
heprisk_scissors=input(CONSNTCNSENT2Q12R12_Q122C,8.0);
heprisk_brush=input(CONSNTCNSENT2Q12R12_Q122D,8.0);
heprisk_nail=input(CONSNTCNSENT2Q12R12_Q122E,8.0);
heprisk_none=input(CONSNTCNSENT2Q12R12_Q122F,8.0);
heprisk_DK=input(CONSNTCNSENT2Q12R12_Q122G,8.0);
IDU_ever=input(CONSENT_CONSENT2_Q123_I1,8.0);
IDU_num_life=input(CONSENT_CONSENT2_Q124_I2,8.0);
IDU_num_6mo=input(CONSENT_CONSENT2_Q125_I3,8.0);
IDU_age_start=input(CONSENT_CONSENT2_Q126_I4,8.0);
IDU_needle_NEP=input(CONSNTCONSNT2Q127I5_Q127A,8.0);
IDU_needle_store=input(CONSNTCONSNT2Q127I5_Q127B,8.0);
IDU_needle_order=input(CONSNTCONSNT2Q127I5_Q127C,8.0);
IDU_needle_borrow=input(CONSNTCONSNT2Q127I5_Q127D,8.0);
IDU_needle_rent=input(CONSNTCONSNT2Q127I5_Q127E,8.0);
IDU_needle_found=input(CONSNTCONSNT2Q127I5_Q127F,8.0);
IDU_needle_DK=input(CONSNTCONSNT2Q127I5_Q127G,8.0);
IDU_needle_none=input(CONSNTCONSNT2Q127I5_Q127H,8.0);
IDU_needle_refused=input(CONSNTCONSNT2Q127I5_Q127I,8.0);
IDU_share1=input(CONSENT_CONSENT2_Q128_I6,8.0);
IDU_share1_num=input(CONSENT_CONSENT2_Q129_I7,8.0);
IDU_share2=input(CONSENT_CONSENT2_Q130_I8,8.0);
IDU_share2_num=input(CONSENT_CONSENT2_Q131_I9,8.0);
IDU_vent=input(CONSNTCONSNT2Q132I10_Q132A,8.0);
IDU_jeff=input(CONSNTCONSNT2Q132I10_Q132B,8.0);
IDU_krokodil=input(CONSNTCONSNT2Q132I10_Q132C,8.0);
IDU_opium=input(CONSNTCONSNT2Q132I10_Q132D,8.0);
IDU_med=input(CONSNTCONSNT2Q132I10_Q132E,8.0);
IDU_poppy=input(CONSNTCONSNT2Q132I10_Q132F,8.0);
IDU_heroin=input(CONSNTCONSNT2Q132I10_Q132G,8.0);
IDU_alcohol=input(CONSNTCONSNT2Q132I10_Q132H,8.0);
IDU_cocaine=input(CONSNTCONSNT2Q132I10_Q132I,8.0);
IDU_crack=input(CONSNTCONSNT2Q132I10_Q132J,8.0);
IDU_psych=input(CONSNTCONSNT2Q132I10_Q132K,8.0);
IDU_ecstasy=input(CONSNTCONSNT2Q132I10_Q132L,8.0);
IDU_otherdrug=CONSNTCONSNT2Q132I10_Q132M;
IDU_drug_DK=input(CONSNTCONSNT2Q132I10_Q132N,8.0);
IDU_drug_RF=input(CONSNTCONSNT2Q132I10_Q132O,8.0);
sex_num=input(CONSENT_CONSENT2_Q133_SP1,8.0);
sex_STI=input(CONSENT_CONSENT2_Q134_SP2,8.0);
sex_HBV=input(CONSENT_CONSENT2_Q135_SP3,8.0);
sex_HCV=input(CONSENT_CONSENT2_Q136_SP4,8.0);
sex_HIV=input(CONSENT_CONSENT2_Q137_SP5,8.0);
condom=input(CONSENT_CONSENT2_Q138_SP6,8.0);
sex_healthcare=input(CONSNTCNSENT2Q139SP7_Q139A,8.0);
sex_military=input(CONSNTCNSENT2Q139SP7_Q139B,8.0);
sex_police=input(CONSNTCNSENT2Q139SP7_Q139C,8.0);
sex_dialysis=input(CONSNTCNSENT2Q139SP7_Q139D,8.0);
sex_IDU=input(CONSNTCNSENT2Q139SP7_Q139E,8.0);
sex_CSW=input(CONSNTCNSENT2Q139SP7_Q139F,8.0);
sex_none=input(CONSNTCNSENT2Q139SP7_Q139G,8.0);
sex_RF=input(CONSNTCNSENT2Q139SP7_Q139H,8.0);
tattoo_salon=input(CONSENTCONSENT2Q13R3_Q113A,8.0);
tattoo_home=input(CONSENTCONSENT2Q13R3_Q113B,8.0);
tattoo_prison=input(CONSENTCONSENT2Q13R3_Q113C,8.0);
tattoo_other=input(CONSENTCONSENT2Q13R3_Q113D,8.0);
tattoo_DK=input(CONSENTCONSENT2Q13R3_Q113E,8.0);
MSM=input(CONSENT_CONSENT2_Q140_SP8,8.0);
MSM_condom=input(CONSENT_CONSENT2_Q141_SP9,8.0);
int_ID_NCD=Q142_PB1;
nurse_ID=Q143_PB2;
consent_NCD=input(Q144_PB3,8.0);
consent_blood=input(Q145_PB4,8.0);
consent_bank=input(Q147_PB6,8.0);
phone_results=Q148_PB7;
address_results=Q149_PB8;
BP_ID=Q150_PB9;
cuff=input(Q151_PB10,8.0);
cuff_other_specify=input(Q151A_PB10,8.0);
BP_s1=input(Q152_PB11,8.0);
BP_d1=input(Q152_PB12,8.0);
BPM1=input(Q152_PB13,8.0);
BP_s2=input(Q153_PB14,8.0);
BP_d2=input(Q153_PB15,8.0);
BPM2=input(Q153_PB16,8.0);
BP_s3=input(Q154_PB17,8.0);
BP_d3=input(Q154_PB18,8.0);
BPM3=input(Q154_PB19,8.0);
BP_treat=input(Q155_PB20,8.0);
height_ID=Q156A_PB21;
weight_ID=Q156B_PB22;
height_cm=input(Q157_PB23,8.0);
kyphotic=input(Q157A_PB23A,8.0);
weight_kg=input(Q158_PB24,8.0);
pregnant=input(Q159_PB25,8.0);
waist_ID=Q160_PB26;
waist_cm=input(Q161_PB27,8.0);
hip_cm=input(Q162_PB28,8.0);
blood_collected=input(Q163_PB29,8.0);
disposition=input(Q164_EXIT1,8.0);
disposition_other_specify=Q164A_EXIT1_OTHER;
blood_time=Q165_PB31;
run;

*/Create labels for renamed variables;;
data HCV7.HCVlabel; set HCV7.HCVrecode; 
	label barcode = 'Barcode';
	label int_id_quest = 'Interviewer ID for behavioral questionnaire';
	label f_name = 'First name';
	label age = 'Age of participant';
	label gender = 'Gender';
	label education = 'What is the highest level of education you have completed?';
	label alc_occasions = 'During the past 30 days, on how many drinking occasions did you have at least one alcoholic drink?';
	label alc_drinks = 'During the past 30 days, when you drank alcohol, on average, how many standard alcoholic drinks did you have during one drinking occasion?';
	label alc_max = 'During the past 30 days, what was the largest number of standard alcoholic drinks you had on a single occasion?';
	label alc_male = '(Males) During the past 30 days, how many times did you have 5 or more standard alcoholic drinks in a single drinking occasion?';
	label alc_female = '(Females) During the past 30 days, how many times did you have 4 or more standard alcoholic drinks in a single drinking occasion?';
	label walk_bike_lastweek = 'Have you walked or used a bicycle for at least 10 minutes continuously to get to and from places in the last week?';
	label walk_bike_typicalweek = 'In a typical week, on how many days do you walk or bicycle for at least 10 minutes continuously to get to and from places?';
	label walk_bike_typicalday = 'How much time do you spend walking or bicylcling for travel on a typical day?';
	label smoke_current_freq = 'Do you currently smoke tobacco...';
	label smoke_past = 'Have you smoked tobacco daily in the past?';
	label smoke_past_freq = 'In the past, have you smoked tobacco...';
	label cig_num = 'Number of manufactured cigarettes';
	label cig_day_week = 'Manufactured cigarettes counted per day/week';
	label hand_cig_num = 'Number of hand rolled cigarettes';
	label hand_cig_day_week = 'Hand rolled cigarettes counted per day/week';
	label pipe_num = 'Number of pipes full of tobacco';
	label pipe_day_week = 'Pipes counted per day/week';
	label cigar_num = 'Number of cigars, cheroots, or cigarillos';
	label cigar_day_week = 'Cigars, cheroots, or cigarillos counted per day/week';
	label smoke_other = 'Other tobacco products (specify)';
	label smoke_other_num = 'Number of other tobacco products';
	label smoke_other_day_week = 'Other tobacco products counted per day/week';
	label prison = 'Have you ever been in prison or jail?';
	label tattoo = 'Do you have any tattoos? If so, how many?';
	label tattoo_other_specify = 'If you got a tattoo somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label tattoo_needle = 'Do you know if the people who gave you your tattoo(s) used new needles, or did they use needles that had been used before?';
	label tattoo_ink = 'Do you know if the people who gave you your tattoo(s)used a new bottle of ink, or a bottle of ink that had already  been opened and
						used for someone else?';
	label piercing = 'Do you have any body piercings? If yes, how many?';
	label piercing_other_specify = 'If you got a body piercing somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label piercing_needle = 'Do you know if the people who gave you the piercing(s) used a new needle or piercing instrument, or one that had been used before?';
	label manicure_num = 'In the last 6 months, how many times have you received a manicure or pedicure at a beauty salon or through a home service?';
	label barber_num = 'In a typical month, how many times do you go to a barber or a beauty salon to get shaved?';
	label shave_other_specify = 'If you typically get shaved somewhere else (other than a barber, beauty salon, or at home), please state where';
	label shave_barber = 'Barber or beauty salon (Where do you typically shave or get shaved?)';
	label shave_home = 'Home (Where do you typically shave or get shaved?)';
	label shave_none = 'I do not shave (Where do you typically shave or get shaved?)';
	label shave_other = 'Somewhere else (Where do you typically shave or get shaved?)';
	label shave_razor = 'When you go to the barber do you know whether you are being shaved with new razors, or razors that ahve been used before?';
	label IDU_ever = 'Have you ever injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_life = 'About how many times if your life have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_6mo = 'In the last 6 months, how often have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_age_start = 'How old were you when you first injected drugs or narcotics for nonmedical reasons?';
	label IDU_needle_NEP = 'Needle exchange program (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_store = 'Drug store or other medical goods supplier (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_order = 'Mail or internet order (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_borrow = 'Borrowed from a friend or family member (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_rent = 'Purchased or rented from someone (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_found = 'A needle and/or syringe I found (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_DK = 'Do not know/remember (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_none = 'None of the above (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_refused = 'Refused (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_share1 = 'Have you ever used someone elses needle and/or syringe after they used it?';
	label IDU_share1_num = 'How many times have you ever used someone elses needle and/or syringe after they used it?';
	label birthday = 'Birth day/month';
	label birthyear = 'Birth year';
	label heprisk_toothbrush = 'Toothbrush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_razor = 'Razor blades (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_scissors = 'Scissors (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_brush = 'Shaving brush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_nail = 'Nail cutter (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_none = 'None of the above (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_DK = 'Dont know/remember (Which of the following articles have you used in common with other members of your household?)';
	label IDU_share2 = 'Have you ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_share2_num = 'How many times havey ou ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_vent = 'Vent (Which of the following drugs have you injected using a needle?)';
	label IDU_jeff = 'Jeff (Which of the following drugs have you injected using a needle?)';
	label IDU_krokodil = 'Krokodil (Which of the following drugs have you injected using a needle?)';
	label IDU_opium = 'Opium (Which of the following drugs have you injected using a needle?)';
	label IDU_med = 'Medical/synthetic drugs (Which of the following drugs have you injected using a needle?)';
	label IDU_poppy = 'Poppy straw (Which of the following drugs have you injected using a needle?)';
	label IDU_heroin = 'Heroin (Which of the following drugs have you injected using a needle?)';
	label IDU_alcohol = 'Alcohol (Which of the following drugs have you injected using a needle?)';
	label IDU_cocaine = 'Cocaine (Which of the following drugs have you injected using a needle?)';
	label IDU_crack = 'Crack (Which of the following drugs have you injected using a needle?)';
	label IDU_psych = 'Psychoactive or hallucinogenic substances (Which of the following drugs have you injected using a needle?)';
	label IDU_ecstasy = 'Ecstasy (Which of the following drugs have you injected using a needle?)';
	label IDU_otherdrug = 'Other (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_DK = 'Dont know/remember (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_RF = 'Refused to answer (Which of the following drugs have you injected using a needle?)';
	label sex_num = 'How many sexual partners have you had in your lifetime?';
	label sex_STI = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with any sexually transmitted infections?';
	label sex_HBV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HBV?';
	label sex_HCV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HCV?';
	label sex_HIV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HIV?';
	label condom = 'In your lifetime, how often have you used condoms with your sexual partners?';
	label sex_healthcare = 'Healthcare or emergency worker who comes into contact with blood (In your lifetime, have any of your sexual partners belonged to the
							following groups?)';
	label sex_military = 'Military (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_police = 'Police (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_dialysis = 'Person who regularly receives kidney dialysis, blood transfusions, or has hemophilia (In your lifetime, have any of your sexual 
						  partners belonged to the following groups?)';
	label sex_IDU = 'Injection drug user (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_CSW  = 'Commercial sex worker (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_none = 'None of the above (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_RF = 'Refused (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label tattoo_salon = 'Beauty salon or tattoo salon (Where did you get your tattoo(s)?)';
	label tattoo_home = 'Home (Where did you get your tattoo(s)?)';
	label tattoo_prison = 'Prison (Where did you get your tattoo(s)?)';
	label tattoo_other = 'Somewhere else (Where did you get your tattoo(s)?)';
	label tattoo_DK = 'Dont know/remember (Where did you get your tattoo(s)?)';
	label MSM = '(Men) Have you ever had sex with another man?';
	label MSM_condom = 'How often do you use condoms with your same sex partner(s)?';
	label int_ID_NCD = 'Interviewer ID for NCD section';
	label nurse_ID = 'Nurse ID';
	label consent_NCD = 'Would you be willing to have your height, weight and blood pressure taken today?';
	label consent_blood = 'Would you be willing to give a blood sample for hepatitis C and B testing?';
	label consent_bank = 'If there is any remaining blood left over after testing for hepatitis, can it be used to test for other diseases
                          of public health interest?';
	label phone_results = 'Contact phone number to return results';
	label address_results = 'Mailing address, or best way to reach for returning results';
	label ethnicity = 'Ethnicity';
	label BP_ID = 'Blood pressure device ID';
	label cuff = 'Cuff size used for blood pressure';
	label cuff_other_specify = 'If other cuff size was used for blood pressure, please specify';
	label BP_s1 = 'BP reading 1: Systolic (mmHg)';
	label BP_d1 = 'BP reading 1: Diastolic (mmHg)';
	label BPM1 = 'BP reading 1: Beats per minute';
	label BP_s2 = 'BP reading 2: Systolic (mmHg)';
	label BP_d2 = 'BP reading 2: Diastolic (mmHg)';
	label BPM2 = 'BP reading 2: Beats per minute';
	label BP_s3 = 'BP reading 3: Systolic (mmHg)';
	label BP_d3 = 'BP reading 3: Diastolic (mmHg)';
	label BPM3 = 'BP reading 3: Beats per minute';
	label BP_treat = 'During the past 2 weeks, have you been treated for raised blood pressure with drugs (medication) prescribed
                      by a doctor or other health worker?';
	label height_ID = 'Height device ID';
	label weight_ID = 'Weight device ID';
	label height_cm = 'Participant height in cm';
	label kyphotic = 'Is participant kyphotic (their back is hunched over due to age or spinal malformation)?';
	label weight_kg = ' Participant weight in kg';
	label pregnant = '(Women) Is the participant pregnant?';
	label ethnicity_other_specify = 'If ethnicity recorded as other, please specify';
	label religion = 'Religion';
	label waist_ID = 'Waist device ID';
	label waist_cm = 'Participant waist circumference in cm';
	label hip_cm = 'Participant hip circumference in cm';
	label blood_collected = 'Was a 10ml tiger top tube collected?';	
	label blood_time = 'Time of day blood specimen collected (24 hour clock)';
	label religion_other_specify = 'If religion recorded as other, please specify';
	label married = 'Marital status';
	label piercing_salon = 'Beauty salon or tattoo salon (Where did you get your body piercing(s)?)';
	label piercing_home = 'Home (Where did you get your body piercing(s)?)';
	label piercing_prison = 'Prison (Where did you get your body piercing(s)?)';
	label piercing_other = 'Somewhere else (Where did you get your body piercing(s)?)';
	label piercing_DK = 'Dont know/remember (Where did you get your body piercing(s)?)';
	label work = 'Which of hte following best describes your main work status over hte past year?';
	label work_healthcare = 'Health care (In your lifetime, have you ever worked in any of the following fields?)';
	label work_military = 'Military (In your lifetime, have you ever worked in any of the following fields?)';
	label work_police = 'Police (In your lifetime, have you ever worked in any of the following fields?)';
	label manicure_salon = 'Beauty salon (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_homeservice = 'Home service (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_self = 'I always perform my own manicures and pedicures (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_never = 'I have never had a manicure or pedicure (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_other = 'Somewhere else (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label house = 'Does your family rent, or own the house you live in?';
	label house_other_specify =  'If rent/own was recorded as other, please specify';
	label resident_num = 'How many people older than 18 years, including yourself, live permanently in your household?';
	label earnings_cat = 'Income category - GEL per week/month/year';
	label earnings_amount = 'In the last year, can you tell me what the average earnings of your household have been?';
	label earnings_estimate = 'If you do not know the exact amount, can you give an estimate of your households monthly earning?' ;
	label earners_num = 'How many people earn money in your household?';
	label insurance = 'Do you currently have medical insurance?';
	label insurance_type = 'What kind of health insurance do you have?';
	label medcare_pay = 'How do you pay for medical care when you need it?';
	label medcare_pay_other_specify = 'If medical care payment was recorded as other, please specify';
	label displaced = 'Have you ever been forced to move from your house because of war or civil unrest?';
	label medcare_location = 'Where do you go for medical care when you need it?';
	label medcare_location_other_specify = 'If medical care location was recorded as other, please specify';
	label flu = 'Last winter, October 2014 to April 2015, did you have a severe respiratory illness, with a sudden onset fever and cough that made you 
	            short of breath or caused you to have difficulty breathing?';
	label flu_polyclinic = 'Polyclinic (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_hospital = 'Hospital (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_medhome = 'Health care provider comes to my house (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_pharmacy = 'Pharmacy (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_villagedoc = 'Village doctor (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_none = 'I do not seek care when I am sick or injured (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_other = 'Other (If yes to severe respiratory illness, where did you go for medical care?)';
	label hh_num = 'Household number';
	label hospital_lifetime_num = 'During your lifetime, how many times have you been admitted to the hospital for any reason?';
	label dentist_cat = 'How often do you visit the dentist to have your teeth cleaned?';
	label dentist_other_specify = 'If dental location was recorded as other, please specify'; 
	label dentist_hospital = 'Hospital (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_cabinet = 'Dental cabinet (Have you ever visited the dentist or had a dental procedure in any of the following locations?');
	label dentist_home = 'Someones home (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_other = 'Other (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_DK = 'Do not know/remember (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';;
	label dental_proc_num = 'How many invasive dental procedures have you had in your lifetime?';
	label shot_num = 'How many shots have you received in the last 6 months, including immunizations and medication to numb you before a medical
                    or dental procedure?';
	label flushot = 'Did you receive a flu shot during the last (2014-2015) influenza season?';
	label flushot_loc = 'If yes to flu shot, where did you receive it?';
	label shot_admin = 'Who administered your last shot?';
	label shot_admin_other = 'If shot administration was recorded as other, please specify';
	label shot_needle = 'Before you received this last shot, did you see where the needle and/or syringe was taken from?';
	label shot_needle_other_specify = 'If shot needle/syringe source was recorded as other, please specify';
	label shot_purpose = 'Why did you get this last shot?';
	label shot_purpose_other_specify = 'If shot purpose was recorded as other, please specify';
	label shot_med = 'What medication was injected in this last shot?';
	label shot_med_other_specify = 'If shot medication was recorded as other, please specify';
	label shot_discard = 'Did they throw the syringe away after your shot?';
	label stratum_num = 'Stratum number';
	label cluster_ID = 'Cluster ID';
	label cluster_name = 'Cluster, city, or village name';
	label IV_num = 'How many IV infusions have you received in the last 6 months?';
	label dialysis_ever = 'In your lifetime, have you ever received dialysis for your kidneys?';
	label dialysis_polyclinic = 'Polyclinic (In what type of facilities have you received kidney dialysis?)';
	label dialysis_hospital = 'Hospital (In what type of facilities have you received kidney dialysis?)';
	label dialysis_home = 'Helath care provider comes to my house (In what type of facilities have you received kidney dialysis?)';
	label dialysis_pharmacy = 'Pharmacy (In what type of facilities have you received kidney dialysis?)';
	label dialysis_villagedoc = 'Village doctor (In what type of facilities have you received kidney dialysis?)';
	label dialysis_other = 'Other (In what type of facilities have you received kidney dialysis?)';
	label dialysis_current = 'Do you currently receive dialysis for your kidneys?';
	label dialysis_freq = 'How many times a week do you receive dialysis for your kidneys?';
	label blood_trans = 'Have you received any blood transfusions in your lifetime?';
	label blood_trans_num = 'How many times in your life have you received a transfusion of blood or blood products?';
	label blood_trans_relative = 'Did any of your blood transfusions come from a friend or relative?';
	label blood_donate = 'Have you ever donated blood?';
	label blood_donate_relative = 'Have you ever donated blood to a relative or friend who needed it?';
	label int_date = 'Confirm interview date';
	label blood_donate_money = 'Have you ever donated blood in exchange for money?';
	label med_invasive = 'During your lifetime, have you ever had an invasive medical procedure?';
	label surgery_ever = 'During your lifetime, have you ever had any type of surgery?';
	label surgery_num = 'During your lifetime, how many surgeries have you had?';
	label surgery_hospital = 'Hospital (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_nursing = 'Nursing home (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_polyclinic = 'Polyclinic (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_other = 'Other (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_DK = 'Do not know/remember (Have you ever had surgery in any of the following locations during your lifetime?)';
	label sti_ever = 'Have you ever been told by a doctor or other health worker that you had a sexually transmitted disease?';
	label sti_syphilis = 'Syphilis (Which sexually transmitted disease have you been diagnosed with?');
	label sti_gonorrhea = 'Gonorrhea (Which sexually transmitted disease have you been diagnosed with?');
	label sti_chlamydia = 'Chlamydia (Which sexually transmitted disease have you been diagnosed with?');
	label sti_herpes = 'Herpes (Which sexually transmitted disease have you been diagnosed with?');
	label sti_warts = 'Genital warts (Which sexually transmitted disease have you been diagnosed with?');
	label sti_other = 'Other (Which sexually transmitted disease have you been diagnosed with?');
	label HIV_test = 'Have you ever been tested for HIV, the virus that causes AIDS?';
	label HIV_result = 'What were your HIV test results?';
	label tb_ever = 'Have you ever been told by a doctor or other health worker that you have tuberculosis?';
	label int_start_time = 'Interview start time';
	label tb_year = 'Have you been told that you have tuberculosis in the past 12 months?';
	label tb_treat = 'Have you ever been treated for your tuberculosis?';
	label bp_meas = 'Have you ever had your blood pressure measured by a doctor or other health worker?';
	label hypertension_ever = 'Have you ever been told by a doctor or other health worker that you have raised blood pressure or hypertension?';
	label hypertension_year = 'Have you been told that you have raised blood pressure or hypertension in the past 12 months?';
	label sugar_meas = 'Have you ever had your blood sugar measured by a doctor or other health worker?';
	label diabetes_ever = 'Have you ever been told by a doctor or other health worker that you have high blood sugar or diabetes?';
	label diabetes_year = 'Have you been told that you have raised blood sugar or diabetes in the past 12 months?';
	label insulin_current = 'Are you currently taking insulin therapy?';
	label sugar_test_share = 'Have you ever tested your blood sugar using a needle that you shared with others?';
	label consent_int = 'Consent given for interview?';
	label insulin_syringe_share = 'Have you ever shared insulin syringes with others?';
	label chronic_asthma = 'Asthma (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_arthritis = 'Arthritis (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_cancer = 'Cancer (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_CVD = 'Cardiovascular disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_COPD = 'Chronic obstructive pulmonary disease (COPD) (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_hemophilia = 'Hemophilia or other blood disorders (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_thyroid = 'Thyroid problems (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_kidney = 'Kidney disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_lung = 'Lung disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other = 'Other (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other_specify = 'If other chronic condition was recorded, please state what type';
	label cancer_type = 'If cancer was recorded, please state what type';
	label HCV_heard = 'Have you ever heard of the hepatitis C virus, or HCV?';
	label HCV_trans_droplets = 'Droplets (Do you know how HCV is transmitted?)';
	label HCV_trans_food = 'Food (Do you know how HCV is transmitted?)';
	label HCV_trans_blood = 'Blood  (Do you know how HCV is transmitted?)';
	label HCV_trans_sex = 'Sexual contact (Do you know how HCV is transmitted?)';
	label HCV_trans_handshake = 'Handshake with an infected person (Do you know how HCV is transmitted?)';
	label HCV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HCV is transmitted?)';
	label HCV_trans_needle = 'Sharing needles or syringes (Do you know how HCV is transmitted?)';
	label HCV_trans_touch = 'Touching items in public places (Do you know how HCV is transmitted?)';
	label HCV_trans_DK = 'Do not know/remember (Do you know how HCV is transmitted?)';
	label HCV_trans_none = 'None of the above (Do you know how HCV is transmitted?)';
	label HCV_trans_other = 'Other (Do you know how HCV is transmitted?)';
	label HCV_trans_other_specify = 'If other mode of HCV transmission was recorded, please state how';
	label HCV_asymptomatic = 'Is it possible to have HCV but not have any symptoms?';
	label HCV_med = 'Are there medications available to treat HCV infections?';
	label trust_family = 'Talking with family members, friends, neighbors or colleagues (Where do you get health information that you trust?)';
	label trust_medlit = 'Special medical literature (Where do you get health information that you trust?)';
	label trust_newspaper = 'Newspapers and magazines (Where do you get health information that you trust?)';
	label trust_radio = 'Radio (Where do you get health information that you trust?)';
	label trust_tv = 'TV (Where do you get health information that you trust?)';
	label trust_internet = 'Internet (Where do you get health information that you trust?)';
	label trust_billboards = 'Billboards (Where do you get health information that you trust?)';
	label trust_brochures = 'Brochures, fliers, posters, or other printed materials (Where do you get health information that you trust?)';
	label trust_doctor = 'Doctors and other healthcare workers (Where do you get health information that you trust?)';
	label trust_pharmacist = 'Pharmacists (Where do you get health information that you trust?)';
	label trust_DK = 'Do not know/remember (Where do you get health information that you trust?)';
	label trust_none = 'None of the above (Where do you get health information that you trust?)';
	label trust_other = 'Other (Where do you get health information that you trust?)';
	label trust_other_specify = 'If other source of HCV information was recorded, please specify';
	label HBV_heard = 'Have you ever heard of the hepatitis B virus?';
	label consent_demo = 'If consent not given for interview, is participant OK giving basic demographic information?';
	label HCV_prev_vacc = 'Get a vaccination (What can you do to prevent HCV infection?)';
	label HCV_prev_condom = 'Use condoms (What can you do to prevent HCV infection?)';
	label HCV_prev_needle = 'Avoid sharing syringes or needles with other people (What can you do to prevent HCV infection?)';
	label HCV_prev_wash = 'Wash hands thoroughly (What can you do to prevent HCV infection?)';
	label HCV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to prevent HCV infection?)';
	label HCV_prev_DK = 'Do not know/remember (What can you do to prevent HCV infection?)';
	label HCV_prev_other = 'Other (What can you do to prevent HCV infection?)';
	label HCV_prev_none = 'None of the above (What can you do to prevent HCV infection?)';
	label language = 'Interview language';
	label HBV_trans_droplets = 'Droplets (Do you know how HBV is transmitted?)';
	label HBV_trans_food = 'Food (Do you know how HBV is transmitted?)';
	label HBV_trans_blood = 'Blood (Do you know how HBV is transmitted?)';
	label HBV_trans_sex = 'Sexual contact (Do you know how HBV is transmitted?)';
	label HBV_trans_handshake = 'Handshake with an infected person (Do you know how HBV is transmitted?)';
	label HBV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HBV is transmitted?)';
	label HBV_trans_needle = 'Sharing needles or syringes (Do you know how HBV is transmitted?)';
	label HBV_trans_touch = 'Touching items in public places (Do you know how HBV is transmitted?)';
	label HBV_trans_DK = 'Dont know/Remember (Do you know how HBV is transmitted?)';
	label HBV_trans_none = 'None of the above (Do you know how HBV is transmitted?)';
	label HBV_trans_other = 'Other (Do you know how HBV is transmitted?)';
	label HBV_trans_other_specify = 'If HBV transmission mode recorded as other, please state how';
	label HBV_asymptomatic = 'Is it possible to have HBV but not have any symptoms?';
	label HBV_med = 'Are there medications available to reat HBV infections?';
	label HBV_prev_vacc = 'Get a vaccination (What can you do to help prevent HBV infection?)';
	label HBV_prev_condom = 'Use condoms (What can you do to help prevent HBV infection?)';
	label HBV_prev_needle = 'Avoid sharing needles and syringes (What can you do to help prevent HBV infection?)';
	label HBV_prev_wash = 'Wash hads frequently (What can you do to help prevent HBV infection?)';
	label HBV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to help prevent HBV infection?)';
	label HBV_prev_DK = 'Dont know/Remember (What can you do to help prevent HBV infection?)';
	label HBV_prev_none = 'None of the above (What can you do to help prevent HBV infection?)';
	label HCV_ever = 'Have you ever been told by a doctor or other health worker that you have hepatitis C?';
	label HCV_year = 'What year were you told that you had hepatitis C?';
	label HCV_treated = 'Have you ever taken medications to treat your hepatitis C infection?';
	label HCV_notreat_avail = 'The medication was not available (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_eligible = 'My doctor told me I was not eligible to take the medication (Why didnt you take medication to treat 
          your hepatitis C infection?)';
	label HCV_notreat_expense = 'The medication was too expensive (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_effect = 'I heard that the medication has a lot of side effects (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_inject = 'I did not want to inject myself with a needle (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_other_specify = 'Other, specify ((Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_DK = 'Dont know/remember (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_RF = 'Refused (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_travel = 'I would ahve to travel too far to get the medication, or to see hte doctor in order to get
	      the medication (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_treat_complete = 'Did you complete your hepatitis C treatment, or did you stop before the end?';
	label HCV_cured = 'Did the treatment cure your hepatitis C infection?';
	label surname = 'Family surname';
	label HBV_ever = 'Have you been told by a doctor or other health worker that you have hepatitis B?';
	label HBV_year = 'What year were you told that you have hepatitis B?';
	label HBV_treated = 'Have you ever taken medications to treat your hepatitis B infection?';
	label HBV_vacc_ever = 'Have you ever been vaccinated against hepatitis B infection?';
	label hep_other_A = 'Hepatitis A (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';
	label hep_other_D = 'Hepatitis D (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_E = 'Hepatitis E (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_none = 'None (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_year = 'What year were you told that you had this other type of hepatitis?';
	label alc_ever = 'Have you ever consumed an alcoholic drink such as beer, wine, or spirits?';
	label alc_year = 'Have you consumed an alcoholic drink within the past 12 months?' ;
	label alc_year_freq = 'During the past 12 months, how frequently have you had at least one alcoholic drink?';
	label alc_month = 'Have you consumed an alcoholic drink within the past 30 days?';
	label disposition = 'Interview disposition: Did you complete the entire questionnaire?';
	label disposition_other_specify = 'If interview disposition recorded as other, please specify';

	run;

*/Create formats for renamed variables and drop old variables;;

data HCV7.HCVformat; set HCV7.HCVlabel(drop=
Q0_BARCODE
Q1_I1
Q2A_I2
Q3A_I3
Q3B_I3
Q4_I4
Q5_I5
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
CONSENT_Q9_I9
CONSENT_Q10_I10
Q11_D1
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20_D10
CONSENT_Q20A_D10_OTHER
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F
CONSENT_CONSENT2_Q30_M2
CONSNTCNSENT2Q29CM1C_Q29C_G
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q32_M4A
CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E
CONSENT_CONSENT2_Q55_STI1
CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H
CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D
CONSENT_CONSENT2_Q121_R11
CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H
CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9


CONSENT_CONSENT2_PROMPT1
CONSENT_CONSENT2_PROMPT2
CONSENT_CONSENT2_PROMPT3
CONSENT_CONSENT2_PROMPT4
CONSENT_CONSENT2_PROMPT5
CONSENT_CONSENT2_PROMPTB
CONSENT_CONSENT2_PROMPTC
CONSENT_CONSENT2_PROMPTD
CONSENT_CONSENT2_PROMPTE
CONSENT_CONSENT2_PROMPTF
CONSENT_CONSENT2_PROMPTG
CONSENT_CONSENT2_PROMPTH
CONSENT_CONSENT2_PROMPTI
CONSENT_CONSENT2_PROMPTJ
CONSENT_CONSENT2_PROMPTK
CONSENT_CONSENT2_PROMPTL
CONSENT_CONSENT2_PROMPTM
CONSENT_CONSENT2_PROMPTN
CONSENT_CONSENT2_PROMPTO
CONSENT_CONSENT2_PROMPTP


CONSENT_PROMPTA
PROMPT6
PROMPTQ
PROMPTR
_LAST_UPDATE_URI_USER
_MODEL_VERSION
_UI_VERSION
_ORDINAL_NUMBER
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22

Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31
)
; 
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

*/Rename variables and indicate which are numeric;;
data HCV7.phone_recode;
set HCV7.phone2;

flu_polyclinic=input(Consent_Consent2_Q29c_M1c_Q29c_,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_A*/ 
flu_hospital=input(var50,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_B*/ 
flu_medhome=input(var51,8.0);     /*CONSENT_CONSENT2_Q29C_M1C_Q29C_C*/ 
flu_pharmacy=input(var52,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_D*/ 
flu_villagedoc=input(var53,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_E*/ 
flu_none=input(var54,8.0);        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_F*/ 

flu_other=var55;        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_G*/ 
/*var variables*/
     
*flu_polyclinic=input(var91,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_A*/ 
*flu_hospital=input(var74,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_B*/ 
*flu_medhome=input(var73,8.0);     /*CONSENT_CONSENT2_Q29C_M1C_Q29C_C*/ 
*flu_pharmacy=input(var71,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_D*/ 
*flu_villagedoc=input(var68,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_E*/ 
*flu_none=input(var65,8.0);        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_F*/ 

/*flu_other=CONSENT_CONSENT2_Q29C_M1C_Q29C_;*/

/*sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);*/
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);

earnings_cat=input(CONSENT_Q22_D12,8.0);

/*flu_medhome = CONSENT_CONSENT2_Q29C_M1C_Q29C_;*/

dentist_hospital=input(CONSENT_CONSENT2_Q32_M4_Q32A,8.0);
dentist_cabinet=input(CONSENT_CONSENT2_Q32_M4_Q32B,8.0);
dentist_home=input(CONSENT_CONSENT2_Q32_M4_Q32C,8.0);
dentist_other=input(CONSENT_CONSENT2_Q32_M4_Q32D,8.0);
dentist_DK=input(CONSENT_CONSENT2_Q32_M4_Q32E,8.0);

dialysis_polyclinic=input(CONSENT_CONSENT2_Q42_M15_Q42A,8.0);
dialysis_hospital=input(CONSENT_CONSENT2_Q42_M15_Q42B,8.0);
dialysis_home=input(CONSENT_CONSENT2_Q42_M15_Q42C,8.0);
dialysis_pharmacy=input(CONSENT_CONSENT2_Q42_M15_Q42D,8.0);
dialysis_villagedoc=input(CONSENT_CONSENT2_Q42_M15_Q42E,8.0);
dialysis_other=input(CONSENT_CONSENT2_Q42_M15_Q42G,8.0);

surgery_hospital=input(CONSENT_CONSENT2_Q54_S4_Q54A,8.0);
surgery_nursing=input(CONSENT_CONSENT2_Q54_S4_Q54B,8.0);
surgery_polyclinic=input(CONSENT_CONSENT2_Q54_S4_Q54C,8.0);
****;surgery_other=CONSENT_CONSENT2_Q54_S4_Q54D;
surgery_DK=input(CONSENT_CONSENT2_Q54_S4_Q54E,8.0);

sti_syphilis=input(CONSENT_CONSENT2_Q56_STI2_Q56A,8.0);
sti_gonorrhea=input(CONSENT_CONSENT2_Q56_STI2_Q56B,8.0);
sti_chlamydia=input(CONSENT_CONSENT2_Q56_STI2_Q56C,8.0);
sti_herpes=input(CONSENT_CONSENT2_Q56_STI2_Q56D,8.0);
sti_warts=input(CONSENT_CONSENT2_Q56_STI2_Q56E,8.0);
***;sti_other=CONSENT_CONSENT2_Q56_STI2_Q56F;

chronic_asthma=input(CONSENT_CONSENT2_Q71_CD1_Q71A,8.0);
chronic_arthritis=input(CONSENT_CONSENT2_Q71_CD1_Q71B,8.0);
chronic_cancer=input(CONSENT_CONSENT2_Q71_CD1_Q71C,8.0);
chronic_CVD=input(CONSENT_CONSENT2_Q71_CD1_Q71D,8.0);
chronic_COPD=input(CONSENT_CONSENT2_Q71_CD1_Q71E,8.0);
chronic_hemophilia=input(CONSENT_CONSENT2_Q71_CD1_Q71F,8.0);
chronic_thyroid=input(CONSENT_CONSENT2_Q71_CD1_Q71G,8.0);
********;chronic_kidney=CONSENT_CONSENT2_Q71_CD1_Q71H;
chronic_lung=input(CONSENT_CONSENT2_Q71_CD1_Q71I,8.0);
chronic_other=input(CONSENT_CONSENT2_Q71_CD1_Q71J,8.0);
chronic_DK=input(CONSENT_CONSENT2_Q71_CD1_Q71K,8.0);

HCV_trans_droplets=input(CONSENT_CONSENT2_Q74_H2_Q74A,8.0);
HCV_trans_food=input(CONSENT_CONSENT2_Q74_H2_Q74B,8.0);
HCV_trans_blood=input(CONSENT_CONSENT2_Q74_H2_Q74C,8.0);
HCV_trans_sex=input(CONSENT_CONSENT2_Q74_H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENT_CONSENT2_Q74_H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENT_CONSENT2_Q74_H2_Q74F,8.0);
HCV_trans_needle=input(CONSENT_CONSENT2_Q74_H2_Q74G,8.0);
HCV_trans_touch=input(CONSENT_CONSENT2_Q74_H2_Q74H,8.0);
HCV_trans_DK=input(CONSENT_CONSENT2_Q74_H2_Q74I,8.0);
HCV_trans_none=input(CONSENT_CONSENT2_Q74_H2_Q74J,8.0);
HCV_trans_other=input(CONSENT_CONSENT2_Q74_H2_Q74K,8.0);

HCV_prev_vacc=input(CONSENT_CONSENT2_Q77_H5_Q77A,8.0);
HCV_prev_condom=input(CONSENT_CONSENT2_Q77_H5_Q77B,8.0);
HCV_prev_needle=input(CONSENT_CONSENT2_Q77_H5_Q77C,8.0);
HCV_prev_wash=input(CONSENT_CONSENT2_Q77_H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENT_CONSENT2_Q77_H5_Q77E,8.0);
HCV_prev_DK=input(CONSENT_CONSENT2_Q77_H5_Q77F,8.0);
****;HCV_prev_other=CONSENT_CONSENT2_Q77_H5_Q77G;
HCV_prev_none=input(CONSENT_CONSENT2_Q77_H5_Q77H,8.0);
trust_family=input(CONSENT_CONSENT2_Q78_H6_Q78A,8.0);
trust_medlit=input(CONSENT_CONSENT2_Q78_H6_Q78B,8.0);
trust_newspaper=input(CONSENT_CONSENT2_Q78_H6_Q78C,8.0);
*******;trust_radio=CONSENT_CONSENT2_Q78_H6_Q78D;
trust_tv=input(CONSENT_CONSENT2_Q78_H6_Q78E,8.0);
trust_internet=input(CONSENT_CONSENT2_Q78_H6_Q78F,8.0);
trust_billboards=input(CONSENT_CONSENT2_Q78_H6_Q78G,8.0);
trust_brochures=input(CONSENT_CONSENT2_Q78_H6_Q78H,8.0);
trust_doctor=input(CONSENT_CONSENT2_Q78_H6_Q78I,8.0);
trust_pharmacist=input(CONSENT_CONSENT2_Q78_H6_Q78J,8.0);
trust_DK=input(CONSENT_CONSENT2_Q78_H6_Q78K,8.0);
trust_none=input(CONSENT_CONSENT2_Q78_H6_Q78L,8.0);
trust_other=input(CONSENT_CONSENT2_Q78_H6_Q78M,8.0);

HBV_trans_droplets=input(CONSENT_CONSENT2_Q80_H8_Q80A,8.0);
HBV_trans_food=input(CONSENT_CONSENT2_Q80_H8_Q80B,8.0);
HBV_trans_blood=input(CONSENT_CONSENT2_Q80_H8_Q80C,8.0);
HBV_trans_sex=input(CONSENT_CONSENT2_Q80_H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENT_CONSENT2_Q80_H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENT_CONSENT2_Q80_H8_Q80F,8.0);
HBV_trans_needle=input(CONSENT_CONSENT2_Q80_H8_Q80G,8.0);
HBV_trans_touch=input(CONSENT_CONSENT2_Q80_H8_Q80H,8.0);
HBV_trans_DK=input(CONSENT_CONSENT2_Q80_H8_Q80I,8.0);
HBV_trans_none=input(CONSENT_CONSENT2_Q80_H8_Q80J,8.0);
HBV_trans_other=input(CONSENT_CONSENT2_Q80_H8_Q80K,8.0);

HBV_prev_vacc=input(CONSENT_CONSENT2_Q83_H11_Q83A,8.0);
HBV_prev_condom=input(CONSENT_CONSENT2_Q83_H11_Q83B,8.0);
HBV_prev_needle=input(CONSENT_CONSENT2_Q83_H11_Q83C,8.0);
HBV_prev_wash=input(CONSENT_CONSENT2_Q83_H11_Q83D,8.0);
HBV_prev_sterile=input(CONSENT_CONSENT2_Q83_H11_Q83E,8.0);
HBV_prev_DK=input(CONSENT_CONSENT2_Q83_H11_Q83F,8.0);
HBV_prev_none=input(CONSENT_CONSENT2_Q83_H11_Q83G,8.0);

HCV_notreat_avail=input(CONSENT_CONSENT2_Q87_H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSENT_CONSENT2_Q87_H15_Q87B,8.0);
HCV_notreat_expense=input(CONSENT_CONSENT2_Q87_H15_Q87C,8.0);
HCV_notreat_effect=input(CONSENT_CONSENT2_Q87_H15_Q87D,8.0);
HCV_notreat_inject=input(CONSENT_CONSENT2_Q87_H15_Q87E,8.0);
********;HCV_notreat_other_specify=CONSENT_CONSENT2_Q87_H15_Q87F;
HCV_notreat_DK=input(CONSENT_CONSENT2_Q87_H15_Q87G,8.0);
HCV_notreat_RF=input(CONSENT_CONSENT2_Q87_H15_Q87H,8.0);
HCV_notreat_travel=input(CONSENT_CONSENT2_Q87_H15_Q87I,8.0);

hep_other_A=input(CONSENT_CONSENT2_Q94_H22_Q94A,8.0);
hep_other_D=input(CONSENT_CONSENT2_Q94_H22_Q94B,8.0);
hep_other_E=input(CONSENT_CONSENT2_Q94_H22_Q94C,8.0);
hep_other_none=input(CONSENT_CONSENT2_Q94_H22_Q94D,8.0);
hep_other_DK=input(CONSENT_CONSENT2_Q94_H22_Q94E,8.0);

cig_num =input(CONSENT_CONSENT2_Q110_T4_Q110A, 8.0);
********;cig_day_week= CONSENT_CONSENT2_Q110_T4_Q110B;
hand_cig_num= input(CONSENT_CONSENT2_Q110_T4_Q110C, 8.0);
hand_cig_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110D, 8.0);
pipe_num= input(CONSENT_CONSENT2_Q110_T4_Q110E, 8.0);
pipe_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110F, 8.0);
cigar_num= input(CONSENT_CONSENT2_Q110_T4_Q110G, 8.0);
cigar_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110H, 8.0);
smoke_other= CONSENT_CONSENT2_Q110_T4_Q110I;
smoke_other_num= CONSENT_CONSENT2_Q110_T4_Q110J;
smoke_other_day_week= CONSENT_CONSENT2_Q110_T4_Q110K;

piercing_salon=input(CONSENT_CONSENT2_Q117_R7_Q117A,8.0);
********;piercing_home=CONSENT_CONSENT2_Q117_R7_Q117B;
piercing_prison=input(CONSENT_CONSENT2_Q117_R7_Q117C,8.0);
piercing_other=input(CONSENT_CONSENT2_Q117_R7_Q117D,8.0);
piercing_DK=input(CONSENT_CONSENT2_Q117_R7_Q117E,8.0);

manicure_salon=CONSENT_CONSENT2_Q119_R9_Q119A_;
manicure_homeservice=CONSENT_CONSENT2_Q119_R9_Q119B_;
manicure_self=CONSENT_CONSENT2_Q119_R9_Q119C_;
manicure_never=CONSENT_CONSENT2_Q119_R9_Q119D_;
manicure_other=CONSENT_CONSENT2_Q119_R9_Q119E_;
barber_num=CONSENT_CONSENT2_Q120A_R10A;

shave_barber=input(CONSENT_CONSENT2_Q120_R10_Q120A  ,8.0);
shave_home=input(CONSENT_CONSENT2_Q120_R10_Q120B  ,8.0);
shave_none=input(CONSENT_CONSENT2_Q120_R10_Q120C  ,8.0);
shave_other=input(CONSENT_CONSENT2_Q120_R10_Q120D  ,8.0);

heprisk_toothbrush=input(CONSENT_CONSENT2_Q122_R12_Q122A,8.0);
heprisk_razor=input(CONSENT_CONSENT2_Q122_R12_Q122B,8.0);
heprisk_scissors=input(CONSENT_CONSENT2_Q122_R12_Q122C,8.0);
heprisk_brush=input(CONSENT_CONSENT2_Q122_R12_Q122D,8.0);
heprisk_nail=input(CONSENT_CONSENT2_Q122_R12_Q122E,8.0);
heprisk_none=input(CONSENT_CONSENT2_Q122_R12_Q122F,8.0);
heprisk_DK=input(CONSENT_CONSENT2_Q122_R12_Q122G ,8.0);

IDU_needle_NEP=input(CONSENT_CONSENT2_Q127_I5_Q127A,8.0);
IDU_needle_store=input(CONSENT_CONSENT2_Q127_I5_Q127B,8.0);
IDU_needle_order=input(CONSENT_CONSENT2_Q127_I5_Q127C,8.0);
IDU_needle_borrow=input(CONSENT_CONSENT2_Q127_I5_Q127D,8.0);
IDU_needle_rent=input(CONSENT_CONSENT2_Q127_I5_Q127E,8.0);
IDU_needle_found=input(CONSENT_CONSENT2_Q127_I5_Q127F,8.0);
IDU_needle_DK=input(CONSENT_CONSENT2_Q127_I5_Q127G,8.0);
IDU_needle_none=input(CONSENT_CONSENT2_Q127_I5_Q127H,8.0);
IDU_needle_refused=input(CONSENT_CONSENT2_Q127_I5_Q127I,8.0);

IDU_vent=input(CONSENT_CONSENT2_Q132_I10_Q132A,8.0);
IDU_jeff=input(CONSENT_CONSENT2_Q132_I10_Q132B,8.0);
IDU_krokodil=input(CONSENT_CONSENT2_Q132_I10_Q132C,8.0);
IDU_opium=input(CONSENT_CONSENT2_Q132_I10_Q132D,8.0);
IDU_med=input(CONSENT_CONSENT2_Q132_I10_Q132E,8.0);
IDU_poppy=input(CONSENT_CONSENT2_Q132_I10_Q132F,8.0);
IDU_heroin=input(CONSENT_CONSENT2_Q132_I10_Q132G,8.0);
IDU_alcohol=input(CONSENT_CONSENT2_Q132_I10_Q132H,8.0);
IDU_cocaine=input(CONSENT_CONSENT2_Q132_I10_Q132I,8.0);
IDU_crack=input(CONSENT_CONSENT2_Q132_I10_Q132J,8.0);
IDU_psych=input(CONSENT_CONSENT2_Q132_I10_Q132K,8.0);
IDU_ecstasy=input(CONSENT_CONSENT2_Q132_I10_Q132L,8.0);
*******;IDU_otherdrug=CONSENT_CONSENT2_Q132_I10_Q132M;
IDU_drug_DK=input(CONSENT_CONSENT2_Q132_I10_Q132N,8.0);
IDU_drug_RF=input(CONSENT_CONSENT2_Q132_I10_Q132O,8.0);

sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);
sex_military = input(CONSENT_CONSENT2_Q139_SP7_Q139B, 8.0);
sex_police = input(CONSENT_CONSENT2_Q139_SP7_Q139C, 8.0);
sex_dialysis = input(CONSENT_CONSENT2_Q139_SP7_Q139D, 8.0);
sex_IDU = input(CONSENT_CONSENT2_Q139_SP7_Q139E, 8.0);
sex_CSW = input(CONSENT_CONSENT2_Q139_SP7_Q139F, 8.0);
sex_none = input(CONSENT_CONSENT2_Q139_SP7_Q139G, 8.0);
sex_RF = input(CONSENT_CONSENT2_Q139_SP7_Q139H, 8.0);
tattoo_salon=input(CONSENT_CONSENT2_Q113_R3_Q113A,8.0);
tattoo_home=input(CONSENT_CONSENT2_Q113_R3_Q113B,8.0);
tattoo_prison=input(CONSENT_CONSENT2_Q113_R3_Q113C,8.0);
tattoo_other=input(CONSENT_CONSENT2_Q113_R3_Q113D,8.0);
tattoo_DK=input(CONSENT_CONSENT2_Q113_R3_Q113E,8.0);

*matching variables;

*;barcode=Q0_BARCODE;
int_id_quest=Q1_I1;
hh_num=input(Q2A_I2,8.0);
stratum_num=input(Q3A_I3,8.0);
*;cluster_ID=Q3B_I3;
cluster_name=Q4_I4;
int_date=Q5_I5;
int_start_time=Q6_I6;
consent_int=input(Q7_I7,8.0);
consent_demo=input(Q7A_CONSENT,8.0);
language=input(Q8_I8,8.0);
surname=CONSENT_Q9_I9;
f_name=CONSENT_Q10_I10;
gender=input(Q11_D1,8.0);
birthday=CONSENT_Q12A_D2;
birthyear=input(CONSENT_Q12B_D2,8.0);
age=input(CONSENT_Q13_D3,8.0);
education=input(CONSENT_Q14_D4,8.0);
ethnicity=input(CONSENT_Q15_D5,8.0);
ethnicity_other_specify=CONSENT_Q15A_D5_OTHER;
religion=input(CONSENT_Q16_D6,8.0);
religion_other_specify=CONSENT_Q16A_D6_OTHER;
married=input(CONSENT_Q17_D7,8.0);
work=input(CONSENT_Q18_D8,8.0);
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);
house=input(CONSENT_Q20_D10,8.0);
house_other_specify=CONSENT_Q20A_D10_OTHER;
resident_num=input(CONSENT_Q21_D11,8.0);
earnings_cat=input(CONSENT_Q22_D12,8.0);
earnings_amount=input(CONSENT_Q22A_D12,8.0);
earnings_estimate=input(CONSENT_Q23_D13,8.0);
earners_num=input(CONSENT_Q24_D14,8.0);
insurance=input(CONSENT_Q25_D15,8.0);
insurance_type=input(CONSENT_Q26_D16,8.0);
medcare_pay=input(CONSENT_Q27_D17,8.0);
medcare_pay_other_specify=CONSENT_Q27A_D17_OTHER;
displaced=input(CONSENT_Q28_D18,8.0);
medcare_location=input(CONSENT_CONSENT2_Q29_M1,8.0);
medcare_location_other_specify=CONSENT_CONSENT2_Q29A_M1_OTHER;
flu=input(CONSENT_CONSENT2_Q29B_M1B,8.0);
/*flu_polyclinic=input(CONSNTCNSENT2Q29CM1C_Q29C_A,8.0);
flu_hospital=input(CONSNTCNSENT2Q29CM1C_Q29C_B,8.0);
flu_medhome=input(CONSNTCNSENT2Q29CM1C_Q29C_C,8.0);
flu_pharmacy=input(CONSNTCNSENT2Q29CM1C_Q29C_D,8.0);
flu_villagedoc=input(CONSNTCNSENT2Q29CM1C_Q29C_E,8.0);
flu_none=input(CONSNTCNSENT2Q29CM1C_Q29C_F,8.0);*/
hospital_lifetime_num=input(CONSENT_CONSENT2_Q30_M2,8.0);
/*flu_other=CONSNTCNSENT2Q29CM1C_Q29C_G;*/
dentist_cat=input(CONSENT_CONSENT2_Q31_M3,8.0);
dentist_other_specify=CONSENT_CONSENT2_Q32_M4A;
/*dentist_hospital=input(CONSENTCONSENT2Q32M4_Q32A,8.0);
dentist_cabinet=input(CONSENTCONSENT2Q32M4_Q32B,8.0);
dentist_home=input(CONSENTCONSENT2Q32M4_Q32C,8.0);
dentist_other=input(CONSENTCONSENT2Q32M4_Q32D,8.0);
dentist_DK=input(CONSENTCONSENT2Q32M4_Q32E,8.0);*/
dental_proc_num=input(CONSENT_CONSENT2_Q33_M5,8.0);
shot_num=input(CONSENT_CONSENT2_Q34_M6,8.0);
flushot=input(CONSENT_CONSENT2_Q34A_M6_1,8.0);
flushot_loc=CONSENT_CONSENT2_Q34B_M6_2;
shot_admin=input(CONSENT_CONSENT2_Q35_M7,8.0);
shot_admin_other=CONSENT_CONSENT2_Q35A_M7_OTHER;
shot_needle=input(CONSENT_CONSENT2_Q36_M8,8.0);
shot_needle_other_specify=CONSENT_CONSENT2_Q36A_M8_OTHER;
shot_purpose=input(CONSENT_CONSENT2_Q37_M9,8.0);
shot_purpose_other_specify=CONSENT_CONSENT2_Q37A_M9_OTHER;
shot_med=input(CONSENT_CONSENT2_Q38_M10,8.0);
shot_med_other_specify=CONSENT_CONSENT2_Q38A_M10_OTHER;
shot_discard=input(CONSENT_CONSENT2_Q39_M11,8.0);
IV_num=input(CONSENT_CONSENT2_Q40_M12,8.0);
dialysis_ever=input(CONSENT_CONSENT2_Q41_M14,8.0);
/*dialysis_polyclinic=input(CONSNTCNSENT2Q42M15_Q42A,8.0);
dialysis_hospital=input(CONSNTCNSENT2Q42M15_Q42B,8.0);
dialysis_home=input(CONSNTCNSENT2Q42M15_Q42C,8.0);
dialysis_pharmacy=input(CONSNTCNSENT2Q42M15_Q42D,8.0);
dialysis_villagedoc=input(CONSNTCNSENT2Q42M15_Q42E,8.0);
dialysis_other=input(CONSNTCNSENT2Q42M15_Q42G,8.0);*/
dialysis_current=input(CONSENT_CONSENT2_Q43_M16,8.0);
dialysis_freq=input(CONSENT_CONSENT2_Q44_M17,8.0);
blood_trans=input(CONSENT_CONSENT2_Q45_M18,8.0);
blood_trans_num=input(CONSENT_CONSENT2_Q46_M19,8.0);
blood_trans_relative=input(CONSENT_CONSENT2_Q47_M20,8.0);
blood_donate=input(CONSENT_CONSENT2_Q48_M21,8.0);
blood_donate_relative=input(CONSENT_CONSENT2_Q49_M22,8.0);
blood_donate_money=input(CONSENT_CONSENT2_Q50_M23,8.0);
med_invasive=input(CONSENT_CONSENT2_Q51_S1,8.0);
surgery_ever=input(CONSENT_CONSENT2_Q52_S2,8.0);
surgery_num=input(CONSENT_CONSENT2_Q53_S3,8.0);
/*surgery_hospital=input(CONSENTCONSENT2Q54S4_Q54A,8.0);
surgery_nursing=input(CONSENTCONSENT2Q54S4_Q54B,8.0);
surgery_polyclinic=input(CONSENTCONSENT2Q54S4_Q54C,8.0);
surgery_other=CONSENTCONSENT2Q54S4_Q54D;
surgery_DK=input(CONSENTCONSENT2Q54S4_Q54E,8.0);*/
sti_ever=input(CONSENT_CONSENT2_Q55_STI1,8.0);
/*sti_syphilis=input(CONSNTCONSNT2Q56STI2_Q56A,8.0);
sti_gonorrhea=input(CONSNTCONSNT2Q56STI2_Q56B,8.0);
sti_chlamydia=input(CONSNTCONSNT2Q56STI2_Q56C,8.0);
sti_herpes=input(CONSNTCONSNT2Q56STI2_Q56D,8.0);
sti_warts=input(CONSNTCONSNT2Q56STI2_Q56E,8.0);
sti_other=CONSNTCONSNT2Q56STI2_Q56F;*/
HIV_test=input(CONSENT_CONSENT2_Q57_STI3,8.0);
HIV_result=input(CONSENT_CONSENT2_Q58_STI4,8.0);
tb_ever=input(CONSENT_CONSENT2_Q59_TB1,8.0);
tb_year=input(CONSENT_CONSENT2_Q60_TB2,8.0);
tb_treat=input(CONSENT_CONSENT2_Q61_TB3,8.0);
bp_meas=input(CONSENT_CONSENT2_Q62_HY1,8.0);
hypertension_ever=input(CONSENT_CONSENT2_Q63_HY2,8.0);
hypertension_year=input(CONSENT_CONSENT2_Q64_HY3,8.0);
sugar_meas=input(CONSENT_CONSENT2_Q65_D1,8.0);
diabetes_ever=input(CONSENT_CONSENT2_Q66_D2,8.0);
diabetes_year=input(CONSENT_CONSENT2_Q67_D3,8.0);
insulin_current=input(CONSENT_CONSENT2_Q68_D4,8.0);
sugar_test_share=input(CONSENT_CONSENT2_Q69_D5,8.0);
insulin_syringe_share=input(CONSENT_CONSENT2_Q70_D6,8.0);
/*chronic_asthma=input(CONSNTCNSENT2Q71CD1_Q71A,8.0);
chronic_arthritis=input(CONSNTCNSENT2Q71CD1_Q71B,8.0);
chronic_cancer=input(CONSNTCNSENT2Q71CD1_Q71C,8.0);
chronic_CVD=input(CONSNTCNSENT2Q71CD1_Q71D,8.0);
chronic_COPD=input(CONSNTCNSENT2Q71CD1_Q71E,8.0);
chronic_hemophilia=input(CONSNTCNSENT2Q71CD1_Q71F,8.0);
chronic_thyroid=input(CONSNTCNSENT2Q71CD1_Q71G,8.0);
chronic_kidney=input(CONSNTCNSENT2Q71CD1_Q71H,8.0);
chronic_lung=input(CONSNTCNSENT2Q71CD1_Q71I,8.0);
chronic_other=input(CONSNTCNSENT2Q71CD1_Q71J,8.0);
chronic_DK=input(CONSNTCNSENT2Q71CD1_Q71K,8.0);*/
chronic_other_specify=CONSENT_CONSENT2_Q71L_CD1_OTHER;
cancer_type=CONSENT_CONSENT2_Q72_CD2;
HCV_heard=input(CONSENT_CONSENT2_Q73_H1,8.0);
/*HCV_trans_droplets=input(CONSENTCONSENT2Q74H2_Q74A,8.0);
HCV_trans_food=input(CONSENTCONSENT2Q74H2_Q74B,8.0);
HCV_trans_blood=input(CONSENTCONSENT2Q74H2_Q74C,8.0);
HCV_trans_sex=input(CONSENTCONSENT2Q74H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENTCONSENT2Q74H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENTCONSENT2Q74H2_Q74F,8.0);
HCV_trans_needle=input(CONSENTCONSENT2Q74H2_Q74G,8.0);
HCV_trans_touch=input(CONSENTCONSENT2Q74H2_Q74H,8.0);
HCV_trans_DK=input(CONSENTCONSENT2Q74H2_Q74I,8.0);
HCV_trans_none=input(CONSENTCONSENT2Q74H2_Q74J,8.0);
HCV_trans_other=input(CONSENTCONSENT2Q74H2_Q74K,8.0);*/
HCV_trans_other_specify=CONSENT_CONSENT2_Q74L_H2A;
HCV_asymptomatic=input(CONSENT_CONSENT2_Q75_H3,8.0);
HCV_med=input(CONSENT_CONSENT2_Q76_H4,8.0);
/*HCV_prev_vacc=input(CONSENTCONSENT2Q7H5_Q77A,8.0);
HCV_prev_condom=input(CONSENTCONSENT2Q7H5_Q77B,8.0);
HCV_prev_needle=input(CONSENTCONSENT2Q7H5_Q77C,8.0);
HCV_prev_wash=input(CONSENTCONSENT2Q7H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENTCONSENT2Q7H5_Q77E,8.0);
HCV_prev_DK=input(CONSENTCONSENT2Q7H5_Q77F,8.0);
HCV_prev_other=CONSENTCONSENT2Q7H5_Q77G;
HCV_prev_none=input(CONSENTCONSENT2Q7H5_Q77H,8.0);*/
/*trust_family=input(CONSENTCONSENT2Q78H6_Q78A,8.0);
trust_medlit=input(CONSENTCONSENT2Q78H6_Q78B,8.0);
trust_newspaper=input(CONSENTCONSENT2Q78H6_Q78C,8.0);
trust_radio=input(CONSENTCONSENT2Q78H6_Q78D,8.0);
trust_tv=input(CONSENTCONSENT2Q78H6_Q78E,8.0);
trust_internet=input(CONSENTCONSENT2Q78H6_Q78F,8.0);
trust_billboards=input(CONSENTCONSENT2Q78H6_Q78G,8.0);
trust_brochures=input(CONSENTCONSENT2Q78H6_Q78H,8.0);
trust_doctor=input(CONSENTCONSENT2Q78H6_Q78I,8.0);
trust_pharmacist=input(CONSENTCONSENT2Q78H6_Q78J,8.0);
trust_DK=input(CONSENTCONSENT2Q78H6_Q78K,8.0);
trust_none=input(CONSENTCONSENT2Q78H6_Q78L,8.0);
trust_other=input(CONSENTCONSENT2Q78H6_Q78M,8.0);*/
trust_other_specify=CONSENT_CONSENT2_Q78N_H6A;
HBV_heard=input(CONSENT_CONSENT2_Q79_H7,8.0);
/*HBV_trans_droplets=input(CONSENTCONSENT2Q80H8_Q80A,8.0);
HBV_trans_food=input(CONSENTCONSENT2Q80H8_Q80B,8.0);
HBV_trans_blood=input(CONSENTCONSENT2Q80H8_Q80C,8.0);
HBV_trans_sex=input(CONSENTCONSENT2Q80H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENTCONSENT2Q80H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENTCONSENT2Q80H8_Q80F,8.0);
HBV_trans_needle=input(CONSENTCONSENT2Q80H8_Q80G,8.0);
HBV_trans_touch=input(CONSENTCONSENT2Q80H8_Q80H,8.0);
HBV_trans_DK=input(CONSENTCONSENT2Q80H8_Q80I,8.0);
HBV_trans_none=input(CONSENTCONSENT2Q80H8_Q80J,8.0);
HBV_trans_other=input(CONSENTCONSENT2Q80H8_Q80K,8.0);*/
HBV_trans_other_specify=CONSENT_CONSENT2_Q80L_H8A;
HBV_asymptomatic=input(CONSENT_CONSENT2_Q81_H9,8.0);
HBV_med=input(CONSENT_CONSENT2_Q82_H10,8.0);
/*HBV_prev_vacc=input(CONSENTCONSENT2Q83H1_Q83A,8.0);
HBV_prev_condom=input(CONSENTCONSENT2Q83H1_Q83B,8.0);
HBV_prev_needle=input(CONSENTCONSENT2Q83H1_Q83C,8.0);
HBV_prev_wash=input(CONSENTCONSENT2Q83H1_Q83D,8.0);
HBV_prev_sterile=input(CONSENTCONSENT2Q83H1_Q83E,8.0);
HBV_prev_DK=input(CONSENTCONSENT2Q83H1_Q83F,8.0);
HBV_prev_none=input(CONSENTCONSENT2Q83H1_Q83G,8.0);*/
HCV_ever=input(CONSENT_CONSENT2_Q84_H12,8.0);
HCV_year=input(CONSENT_CONSENT2_Q85_H13,8.0);
HCV_treated=input(CONSENT_CONSENT2_Q86_H14,8.0);
/*HCV_notreat_avail=input(CONSNTCNSENT2Q87H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSNTCNSENT2Q87H15_Q87B,8.0);
HCV_notreat_expense=input(CONSNTCNSENT2Q87H15_Q87C,8.0);
HCV_notreat_effect=input(CONSNTCNSENT2Q87H15_Q87D,8.0);
HCV_notreat_inject=input(CONSNTCNSENT2Q87H15_Q87E,8.0);
HCV_notreat_other_specify=CONSNTCNSENT2Q87H15_Q87F;
HCV_notreat_DK=input(CONSNTCNSENT2Q87H15_Q87G,8.0);
HCV_notreat_RF=input(CONSNTCNSENT2Q87H15_Q87H,8.0);
HCV_notreat_travel=input(CONSNTCNSENT2Q87H15_Q87I,8.0);*/
HCV_treat_complete=input(CONSENT_CONSENT2_Q88_H16,8.0);
HCV_cured=input(CONSENT_CONSENT2_Q89_H17,8.0);
HBV_ever=input(CONSENT_CONSENT2_Q90_H18,8.0);
HBV_year=input(CONSENT_CONSENT2_Q91_H19,8.0);
HBV_treated=input(CONSENT_CONSENT2_Q92_H20,8.0);
HBV_vacc_ever=input(CONSENT_CONSENT2_Q93_H21,8.0);
/*hep_other_A=input(CONSENTCONSENT2Q94H2_Q94A,8.0);
hep_other_D=input(CONSENTCONSENT2Q94H2_Q94B,8.0);
hep_other_E=input(CONSENTCONSENT2Q94H2_Q94C,8.0);
hep_other_none=input(CONSENTCONSENT2Q94H2_Q94D,8.0);
hep_other_DK=input(CONSENTCONSENT2Q94H2_Q94E,8.0);*/
hep_other_year=input(CONSENT_CONSENT2_Q95_H23,8.0);
alc_ever=input(CONSENT_CONSENT2_Q96_A1A,8.0);
alc_year=input(CONSENT_CONSENT2_Q97_A1B,8.0);
alc_year_freq=input(CONSENT_CONSENT2_Q98_A2,8.0);
alc_month=input(CONSENT_CONSENT2_Q99_A3,8.0);
alc_occasions=input(CONSENT_CONSENT2_Q100_A4,8.0);
alc_drinks=input(CONSENT_CONSENT2_Q101_A5,8.0);
alc_max=input(CONSENT_CONSENT2_Q102_A6,8.0);
alc_male=input(CONSENT_CONSENT2_Q103A_A7_MALES,8.0);
alc_female=input(CONSENT_CONSENT2_Q103B_A7_FEMAL,8.0);
walk_bike_lastweek=input(CONSENT_CONSENT2_Q104_PA1,8.0);
walk_bike_typicalweek=input(CONSENT_CONSENT2_Q105_PA2,8.0);
walk_bike_typicalday=CONSENT_CONSENT2_Q106_PA3;
smoke_current_freq=input(CONSENT_CONSENT2_Q107_T1,8.0);
smoke_past=input(CONSENT_CONSENT2_Q108_T2,8.0);
smoke_past_freq=input(CONSENT_CONSENT2_Q109_T3,8.0);
/*cig_num=input(CONSENTCONSENT2Q10T4_Q110A,8.0);
cig_day_week=input(CONSENTCONSENT2Q10T4_Q110B,8.0);
hand_cig_num=input(CONSENTCONSENT2Q10T4_Q110C,8.0);
hand_cig_day_week=input(CONSENTCONSENT2Q10T4_Q110D,8.0);
pipe_num=input(CONSENTCONSENT2Q10T4_Q110E,8.0);
pipe_day_week=input(CONSENTCONSENT2Q10T4_Q110F,8.0);
cigar_num=input(CONSENTCONSENT2Q10T4_Q110G,8.0);
cigar_day_week=input(CONSENTCONSENT2Q10T4_Q110H,8.0);
smoke_other=CONSENTCONSENT2Q10T4_Q110I;
smoke_other_num=input(CONSENTCONSENT2Q10T4_Q110J,8.0);
smoke_other_day_week=input(CONSENTCONSENT2Q10T4_Q110K,8.0);*/
prison=input(CONSENT_CONSENT2_Q111_R1,8.0);
tattoo=input(CONSENT_CONSENT2_Q112_R2,8.0);
tattoo_other_specify=CONSENT_CONSENT2_Q113F_R3A;
tattoo_needle=input(CONSENT_CONSENT2_Q114_R4,8.0);
tattoo_ink=input(CONSENT_CONSENT2_Q115_R5,8.0);
piercing=input(CONSENT_CONSENT2_Q116_R6,8.0);
piercing_other_specify=CONSENT_CONSENT2_Q117F_R7A;
/*piercing_salon=input(CONSENTCONSENT2Q17R7_Q117A,8.0);
piercing_home=input(CONSENTCONSENT2Q17R7_Q117B,8.0);
piercing_prison=input(CONSENTCONSENT2Q17R7_Q117C,8.0);
piercing_other=input(CONSENTCONSENT2Q17R7_Q117D,8.0);
piercing_DK=input(CONSENTCONSENT2Q17R7_Q117E,8.0);*/
piercing_needle=input(CONSENT_CONSENT2_Q118_R8,8.0);
manicure_num=input(CONSENT_CONSENT2_Q119A_R9A,8.0);
/*manicure_salon=input(CONSENTCONSENT2Q19R9_Q119A_R9,8.0);
manicure_homeservice=input(CONSENTCONSENT2Q19R9_Q119B_R9,8.0);
manicure_self=input(CONSENTCONSENT2Q19R9_Q119C_R9,8.0);
manicure_never=input(CONSENTCONSENT2Q19R9_Q119D_R9,8.0);
manicure_other=CONSENTCONSENT2Q19R9_Q119E_R9;*/
*;barber_num=CONSENT_CONSENT2_Q120A_R10A;
shave_other_specify=CONSENT_CONSENT2_Q120E_R10E;
/*shave_barber=input(CONSNTCNSENT2Q120R10_Q120A,8.0);
shave_home=input(CONSNTCNSENT2Q120R10_Q120B,8.0);
shave_none=input(CONSNTCNSENT2Q120R10_Q120C,8.0);
shave_other=input(CONSNTCNSENT2Q120R10_Q120D,8.0);*/
shave_razor=input(CONSENT_CONSENT2_Q121_R11,8.0);
/*heprisk_toothbrush=input(CONSNTCNSENT2Q12R12_Q122A,8.0);
heprisk_razor=input(CONSNTCNSENT2Q12R12_Q122B,8.0);
heprisk_scissors=input(CONSNTCNSENT2Q12R12_Q122C,8.0);
heprisk_brush=input(CONSNTCNSENT2Q12R12_Q122D,8.0);
heprisk_nail=input(CONSNTCNSENT2Q12R12_Q122E,8.0);
heprisk_none=input(CONSNTCNSENT2Q12R12_Q122F,8.0);
heprisk_DK=input(CONSNTCNSENT2Q12R12_Q122G,8.0);*/
IDU_ever=input(CONSENT_CONSENT2_Q123_I1,8.0);
IDU_num_life=input(CONSENT_CONSENT2_Q124_I2,8.0);
IDU_num_6mo=input(CONSENT_CONSENT2_Q125_I3,8.0);
IDU_age_start=input(CONSENT_CONSENT2_Q126_I4,8.0);
/*IDU_needle_NEP=input(CONSNTCONSNT2Q127I5_Q127A,8.0);
IDU_needle_store=input(CONSNTCONSNT2Q127I5_Q127B,8.0);
IDU_needle_order=input(CONSNTCONSNT2Q127I5_Q127C,8.0);
IDU_needle_borrow=input(CONSNTCONSNT2Q127I5_Q127D,8.0);
IDU_needle_rent=input(CONSNTCONSNT2Q127I5_Q127E,8.0);
IDU_needle_found=input(CONSNTCONSNT2Q127I5_Q127F,8.0);
IDU_needle_DK=input(CONSNTCONSNT2Q127I5_Q127G,8.0);
IDU_needle_none=input(CONSNTCONSNT2Q127I5_Q127H,8.0);
IDU_needle_refused=input(CONSNTCONSNT2Q127I5_Q127I,8.0);*/
IDU_share1=input(CONSENT_CONSENT2_Q128_I6,8.0);
IDU_share1_num=input(CONSENT_CONSENT2_Q129_I7,8.0);
IDU_share2=input(CONSENT_CONSENT2_Q130_I8,8.0);
IDU_share2_num=input(CONSENT_CONSENT2_Q131_I9,8.0);
/*IDU_vent=input(CONSNTCONSNT2Q132I10_Q132A,8.0);
IDU_jeff=input(CONSNTCONSNT2Q132I10_Q132B,8.0);
IDU_krokodil=input(CONSNTCONSNT2Q132I10_Q132C,8.0);
IDU_opium=input(CONSNTCONSNT2Q132I10_Q132D,8.0);
IDU_med=input(CONSNTCONSNT2Q132I10_Q132E,8.0);
IDU_poppy=input(CONSNTCONSNT2Q132I10_Q132F,8.0);
IDU_heroin=input(CONSNTCONSNT2Q132I10_Q132G,8.0);
IDU_alcohol=input(CONSNTCONSNT2Q132I10_Q132H,8.0);
IDU_cocaine=input(CONSNTCONSNT2Q132I10_Q132I,8.0);
IDU_crack=input(CONSNTCONSNT2Q132I10_Q132J,8.0);
IDU_psych=input(CONSNTCONSNT2Q132I10_Q132K,8.0);
IDU_ecstasy=input(CONSNTCONSNT2Q132I10_Q132L,8.0);
IDU_otherdrug=CONSNTCONSNT2Q132I10_Q132M;
IDU_drug_DK=input(CONSNTCONSNT2Q132I10_Q132N,8.0);
IDU_drug_RF=input(CONSNTCONSNT2Q132I10_Q132O,8.0);*/
sex_num=input(CONSENT_CONSENT2_Q133_SP1,8.0);
sex_STI=input(CONSENT_CONSENT2_Q134_SP2,8.0);
sex_HBV=input(CONSENT_CONSENT2_Q135_SP3,8.0);
sex_HCV=input(CONSENT_CONSENT2_Q136_SP4,8.0);
sex_HIV=input(CONSENT_CONSENT2_Q137_SP5,8.0);
condom=input(CONSENT_CONSENT2_Q138_SP6,8.0);
/*sex_healthcare=input(CONSNTCNSENT2Q139SP7_Q139A,8.0);
sex_military=input(CONSNTCNSENT2Q139SP7_Q139B,8.0);
sex_police=input(CONSNTCNSENT2Q139SP7_Q139C,8.0);
sex_dialysis=input(CONSNTCNSENT2Q139SP7_Q139D,8.0);
sex_IDU=input(CONSNTCNSENT2Q139SP7_Q139E,8.0);
sex_CSW=input(CONSNTCNSENT2Q139SP7_Q139F,8.0);
sex_none=input(CONSNTCNSENT2Q139SP7_Q139G,8.0);
sex_RF=input(CONSNTCNSENT2Q139SP7_Q139H,8.0);*/
/*tattoo_salon=input(CONSENTCONSENT2Q13R3_Q113A,8.0);
tattoo_home=input(CONSENTCONSENT2Q13R3_Q113B,8.0);
tattoo_prison=input(CONSENTCONSENT2Q13R3_Q113C,8.0);
tattoo_other=input(CONSENTCONSENT2Q13R3_Q113D,8.0);
tattoo_DK=input(CONSENTCONSENT2Q13R3_Q113E,8.0);*/
MSM=input(CONSENT_CONSENT2_Q140_SP8,8.0);
MSM_condom=input(CONSENT_CONSENT2_Q141_SP9,8.0);
int_ID_NCD=Q142_PB1;
nurse_ID=Q143_PB2;
consent_NCD=input(Q144_PB3,8.0);
consent_blood=input(Q145_PB4,8.0);
consent_bank=input(Q147_PB6,8.0);
phone_results=Q148_PB7;
address_results=Q149_PB8;
BP_ID=Q150_PB9;
cuff=input(Q151_PB10,8.0);
*;cuff_other_specify=Q151A_PB10;
BP_s1=input(Q152_PB11,8.0);
BP_d1=input(Q152_PB12,8.0);
BPM1=input(Q152_PB13,8.0);
BP_s2=input(Q153_PB14,8.0);
BP_d2=input(Q153_PB15,8.0);
BPM2=input(Q153_PB16,8.0);
BP_s3=input(Q154_PB17,8.0);
BP_d3=input(Q154_PB18,8.0);
BPM3=input(Q154_PB19,8.0);
BP_treat=input(Q155_PB20,8.0);
height_ID=Q156A_PB21;
weight_ID=Q156B_PB22;
height_cm=input(Q157_PB23,8.0);
kyphotic=input(Q157A_PB23A,8.0);
weight_kg=input(Q158_PB24,8.0);
pregnant=input(Q159_PB25,8.0);
waist_ID=Q160_PB26;
waist_cm=input(Q161_PB27,8.0);
hip_cm=input(Q162_PB28,8.0);
blood_collected=input(Q163_PB29,8.0);
disposition=input(Q164_EXIT1,8.0);
disposition_other_specify=Q164A_EXIT1_OTHER;
blood_time=Q165_PB31;
run;

*Labeling variables;;




data HCV7.phone_label; set HCV7.phone_recode; 
	label barcode = 'Barcode';
	label int_id_quest = 'Interviewer ID for behavioral questionnaire';
	label f_name = 'First name';
	label age = 'Age of participant';
	label gender = 'Gender';
	label education = 'What is the highest level of education you have completed?';
	label alc_occasions = 'During the past 30 days, on how many drinking occasions did you have at least one alcoholic drink?';
	label alc_drinks = 'During the past 30 days, when you drank alcohol, on average, how many standard alcoholic drinks did you have during one drinking occasion?';
	label alc_max = 'During the past 30 days, what was the largest number of standard alcoholic drinks you had on a single occasion?';
	label alc_male = '(Males) During the past 30 days, how many times did you have 5 or more standard alcoholic drinks in a single drinking occasion?';
	label alc_female = '(Females) During the past 30 days, how many times did you have 4 or more standard alcoholic drinks in a single drinking occasion?';
	label walk_bike_lastweek = 'Have you walked or used a bicycle for at least 10 minutes continuously to get to and from places in the last week?';
	label walk_bike_typicalweek = 'In a typical week, on how many days do you walk or bicycle for at least 10 minutes continuously to get to and from places?';
	label walk_bike_typicalday = 'How much time do you spend walking or bicylcling for travel on a typical day?';
	label smoke_current_freq = 'Do you currently smoke tobacco...';
	label smoke_past = 'Have you smoked tobacco daily in the past?';
	label smoke_past_freq = 'In the past, have you smoked tobacco...';
	label cig_num = 'Number of manufactured cigarettes';
	label cig_day_week = 'Manufactured cigarettes counted per day/week';
	label hand_cig_num = 'Number of hand rolled cigarettes';
	label hand_cig_day_week = 'Hand rolled cigarettes counted per day/week';
	label pipe_num = 'Number of pipes full of tobacco';
	label pipe_day_week = 'Pipes counted per day/week';
	label cigar_num = 'Number of cigars, cheroots, or cigarillos';
	label cigar_day_week = 'Cigars, cheroots, or cigarillos counted per day/week';
	label smoke_other = 'Other tobacco products (specify)';
	label smoke_other_num = 'Number of other tobacco products';
	label smoke_other_day_week = 'Other tobacco products counted per day/week';
	label prison = 'Have you ever been in prison or jail?';
	label tattoo = 'Do you have any tattoos? If so, how many?';
	label tattoo_other_specify = 'If you got a tattoo somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label tattoo_needle = 'Do you know if the people who gave you your tattoo(s) used new needles, or did they use needles that had been used before?';
	label tattoo_ink = 'Do you know if the people who gave you your tattoo(s)used a new bottle of ink, or a bottle of ink that had already  been opened and
						used for someone else?';
	label piercing = 'Do you have any body piercings? If yes, how many?';
	label piercing_other_specify = 'If you got a body piercing somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label piercing_needle = 'Do you know if the people who gave you the piercing(s) used a new needle or piercing instrument, or one that had been used before?';
	label manicure_num = 'In the last 6 months, how many times have you received a manicure or pedicure at a beauty salon or through a home service?';
	label barber_num = 'In a typical month, how many times do you go to a barber or a beauty salon to get shaved?';
	label shave_other_specify = 'If you typically get shaved somewhere else (other than a barber, beauty salon, or at home), please state where';
	label shave_barber = 'Barber or beauty salon (Where do you typically shave or get shaved?)';
	label shave_home = 'Home (Where do you typically shave or get shaved?)';
	label shave_none = 'I do not shave (Where do you typically shave or get shaved?)';
	label shave_other = 'Somewhere else (Where do you typically shave or get shaved?)';
	label shave_razor = 'When you go to the barber do you know whether you are being shaved with new razors, or razors that ahve been used before?';
	label IDU_ever = 'Have you ever injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_life = 'About how many times if your life have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_6mo = 'In the last 6 months, how often have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_age_start = 'How old were you when you first injected drugs or narcotics for nonmedical reasons?';
	label IDU_needle_NEP = 'Needle exchange program (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_store = 'Drug store or other medical goods supplier (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_order = 'Mail or internet order (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_borrow = 'Borrowed from a friend or family member (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_rent = 'Purchased or rented from someone (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_found = 'A needle and/or syringe I found (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_DK = 'Do not know/remember (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_none = 'None of the above (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_refused = 'Refused (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_share1 = 'Have you ever used someone elses needle and/or syringe after they used it?';
	label IDU_share1_num = 'How many times have you ever used someone elses needle and/or syringe after they used it?';
	label birthday = 'Birth day/month';
	label birthyear = 'Birth year';
	label heprisk_toothbrush = 'Toothbrush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_razor = 'Razor blades (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_scissors = 'Scissors (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_brush = 'Shaving brush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_nail = 'Nail cutter (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_none = 'None of the above (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_DK = 'Dont know/remember (Which of the following articles have you used in common with other members of your household?)';
	label IDU_share2 = 'Have you ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_share2_num = 'How many times havey ou ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_vent = 'Vent (Which of the following drugs have you injected using a needle?)';
	label IDU_jeff = 'Jeff (Which of the following drugs have you injected using a needle?)';
	label IDU_krokodil = 'Krokodil (Which of the following drugs have you injected using a needle?)';
	label IDU_opium = 'Opium (Which of the following drugs have you injected using a needle?)';
	label IDU_med = 'Medical/synthetic drugs (Which of the following drugs have you injected using a needle?)';
	label IDU_poppy = 'Poppy straw (Which of the following drugs have you injected using a needle?)';
	label IDU_heroin = 'Heroin (Which of the following drugs have you injected using a needle?)';
	label IDU_alcohol = 'Alcohol (Which of the following drugs have you injected using a needle?)';
	label IDU_cocaine = 'Cocaine (Which of the following drugs have you injected using a needle?)';
	label IDU_crack = 'Crack (Which of the following drugs have you injected using a needle?)';
	label IDU_psych = 'Psychoactive or hallucinogenic substances (Which of the following drugs have you injected using a needle?)';
	label IDU_ecstasy = 'Ecstasy (Which of the following drugs have you injected using a needle?)';
	label IDU_otherdrug = 'Other (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_DK = 'Dont know/remember (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_RF = 'Refused to answer (Which of the following drugs have you injected using a needle?)';
	label sex_num = 'How many sexual partners have you had in your lifetime?';
	label sex_STI = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with any sexually transmitted infections?';
	label sex_HBV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HBV?';
	label sex_HCV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HCV?';
	label sex_HIV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HIV?';
	label condom = 'In your lifetime, how often have you used condoms with your sexual partners?';
	label sex_healthcare = 'Healthcare or emergency worker who comes into contact with blood (In your lifetime, have any of your sexual partners belonged to the
							following groups?)';
	label sex_military = 'Military (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_police = 'Police (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_dialysis = 'Person who regularly receives kidney dialysis, blood transfusions, or has hemophilia (In your lifetime, have any of your sexual 
						  partners belonged to the following groups?)';
	label sex_IDU = 'Injection drug user (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_CSW  = 'Commercial sex worker (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_none = 'None of the above (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_RF = 'Refused (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label tattoo_salon = 'Beauty salon or tattoo salon (Where did you get your tattoo(s)?)';
	label tattoo_home = 'Home (Where did you get your tattoo(s)?)';
	label tattoo_prison = 'Prison (Where did you get your tattoo(s)?)';
	label tattoo_other = 'Somewhere else (Where did you get your tattoo(s)?)';
	label tattoo_DK = 'Dont know/remember (Where did you get your tattoo(s)?)';
	label MSM = '(Men) Have you ever had sex with another man?';
	label MSM_condom = 'How often do you use condoms with your same sex partner(s)?';
	label int_ID_NCD = 'Interviewer ID for NCD section';
	label nurse_ID = 'Nurse ID';
	label consent_NCD = 'Would you be willing to have your height, weight and blood pressure taken today?';
	label consent_blood = 'Would you be willing to give a blood sample for hepatitis C and B testing?';
	label consent_bank = 'If there is any remaining blood left over after testing for hepatitis, can it be used to test for other diseases
                          of public health interest?';
	label phone_results = 'Contact phone number to return results';
	label address_results = 'Mailing address, or best way to reach for returning results';
	label ethnicity = 'Ethnicity';
	label BP_ID = 'Blood pressure device ID';
	label cuff = 'Cuff size used for blood pressure';
	label cuff_other_specify = 'If other cuff size was used for blood pressure, please specify';
	label BP_s1 = 'BP reading 1: Systolic (mmHg)';
	label BP_d1 = 'BP reading 1: Diastolic (mmHg)';
	label BPM1 = 'BP reading 1: Beats per minute';
	label BP_s2 = 'BP reading 2: Systolic (mmHg)';
	label BP_d2 = 'BP reading 2: Diastolic (mmHg)';
	label BPM2 = 'BP reading 2: Beats per minute';
	label BP_s3 = 'BP reading 3: Systolic (mmHg)';
	label BP_d3 = 'BP reading 3: Diastolic (mmHg)';
	label BPM3 = 'BP reading 3: Beats per minute';
	label BP_treat = 'During the past 2 weeks, have you been treated for raised blood pressure with drugs (medication) prescribed
                      by a doctor or other health worker?';
	label height_ID = 'Height device ID';
	label weight_ID = 'Weight device ID';
	label height_cm = 'Participant height in cm';
	label kyphotic = 'Is participant kyphotic (their back is hunched over due to age or spinal malformation)?';
	label weight_kg = ' Participant weight in kg';
	label pregnant = '(Women) Is the participant pregnant?';
	label ethnicity_other_specify = 'If ethnicity recorded as other, please specify';
	label religion = 'Religion';
	label waist_ID = 'Waist device ID';
	label waist_cm = 'Participant waist circumference in cm';
	label hip_cm = 'Participant hip circumference in cm';
	label blood_collected = 'Was a 10ml tiger top tube collected?';	
	label blood_time = 'Time of day blood specimen collected (24 hour clock)';
	label religion_other_specify = 'If religion recorded as other, please specify';
	label married = 'Marital status';
	label piercing_salon = 'Beauty salon or tattoo salon (Where did you get your body piercing(s)?)';
	label piercing_home = 'Home (Where did you get your body piercing(s)?)';
	label piercing_prison = 'Prison (Where did you get your body piercing(s)?)';
	label piercing_other = 'Somewhere else (Where did you get your body piercing(s)?)';
	label piercing_DK = 'Dont know/remember (Where did you get your body piercing(s)?)';
	label work = 'Which of hte following best describes your main work status over hte past year?';
	label work_healthcare = 'Health care (In your lifetime, have you ever worked in any of the following fields?)';
	label work_military = 'Military (In your lifetime, have you ever worked in any of the following fields?)';
	label work_police = 'Police (In your lifetime, have you ever worked in any of the following fields?)';
	label manicure_salon = 'Beauty salon (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_homeservice = 'Home service (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_self = 'I always perform my own manicures and pedicures (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_never = 'I have never had a manicure or pedicure (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_other = 'Somewhere else (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label house = 'Does your family rent, or own the house you live in?';
	label house_other_specify =  'If rent/own was recorded as other, please specify';
	label resident_num = 'How many people older than 18 years, including yourself, live permanently in your household?';
	label earnings_cat = 'Income category - GEL per week/month/year';
	label earnings_amount = 'In the last year, can you tell me what the average earnings of your household have been?';
	label earnings_estimate = 'If you do not know the exact amount, can you give an estimate of your households monthly earning?' ;
	label earners_num = 'How many people earn money in your household?';
	label insurance = 'Do you currently have medical insurance?';
	label insurance_type = 'What kind of health insurance do you have?';
	label medcare_pay = 'How do you pay for medical care when you need it?';
	label medcare_pay_other_specify = 'If medical care payment was recorded as other, please specify';
	label displaced = 'Have you ever been forced to move from your house because of war or civil unrest?';
	label medcare_location = 'Where do you go for medical care when you need it?';
	label medcare_location_other_specify = 'If medical care location was recorded as other, please specify';
	label flu = 'Last winter, October 2014 to April 2015, did you have a severe respiratory illness, with a sudden onset fever and cough that made you 
	            short of breath or caused you to have difficulty breathing?';
	label flu_polyclinic = 'Polyclinic (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_hospital = 'Hospital (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_medhome = 'Health care provider comes to my house (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_pharmacy = 'Pharmacy (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_villagedoc = 'Village doctor (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_none = 'I do not seek care when I am sick or injured (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_other = 'Other (If yes to severe respiratory illness, where did you go for medical care?)';
	label hh_num = 'Household number';
	label hospital_lifetime_num = 'During your lifetime, how many times have you been admitted to the hospital for any reason?';
	label dentist_cat = 'How often do you visit the dentist to have your teeth cleaned?';
	label dentist_other_specify = 'If dental location was recorded as other, please specify'; 
	label dentist_hospital = 'Hospital (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_cabinet = 'Dental cabinet (Have you ever visited the dentist or had a dental procedure in any of the following locations?');
	label dentist_home = 'Someones home (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_other = 'Other (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_DK = 'Do not know/remember (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';;
	label dental_proc_num = 'How many invasive dental procedures have you had in your lifetime?';
	label shot_num = 'How many shots have you received in the last 6 months, including immunizations and medication to numb you before a medical
                    or dental procedure?';
	label flushot = 'Did you receive a flu shot during the last (2014-2015) influenza season?';
	label flushot_loc = 'If yes to flu shot, where did you receive it?';
	label shot_admin = 'Who administered your last shot?';
	label shot_admin_other = 'If shot administration was recorded as other, please specify';
	label shot_needle = 'Before you received this last shot, did you see where the needle and/or syringe was taken from?';
	label shot_needle_other_specify = 'If shot needle/syringe source was recorded as other, please specify';
	label shot_purpose = 'Why did you get this last shot?';
	label shot_purpose_other_specify = 'If shot purpose was recorded as other, please specify';
	label shot_med = 'What medication was injected in this last shot?';
	label shot_med_other_specify = 'If shot medication was recorded as other, please specify';
	label shot_discard = 'Did they throw the syringe away after your shot?';
	label stratum_num = 'Stratum number';
	label cluster_ID = 'Cluster ID';
	label cluster_name = 'Cluster, city, or village name';
	label IV_num = 'How many IV infusions have you received in the last 6 months?';
	label dialysis_ever = 'In your lifetime, have you ever received dialysis for your kidneys?';
	label dialysis_polyclinic = 'Polyclinic (In what type of facilities have you received kidney dialysis?)';
	label dialysis_hospital = 'Hospital (In what type of facilities have you received kidney dialysis?)';
	label dialysis_home = 'Helath care provider comes to my house (In what type of facilities have you received kidney dialysis?)';
	label dialysis_pharmacy = 'Pharmacy (In what type of facilities have you received kidney dialysis?)';
	label dialysis_villagedoc = 'Village doctor (In what type of facilities have you received kidney dialysis?)';
	label dialysis_other = 'Other (In what type of facilities have you received kidney dialysis?)';
	label dialysis_current = 'Do you currently receive dialysis for your kidneys?';
	label dialysis_freq = 'How many times a week do you receive dialysis for your kidneys?';
	label blood_trans = 'Have you received any blood transfusions in your lifetime?';
	label blood_trans_num = 'How many times in your life have you received a transfusion of blood or blood products?';
	label blood_trans_relative = 'Did any of your blood transfusions come from a friend or relative?';
	label blood_donate = 'Have you ever donated blood?';
	label blood_donate_relative = 'Have you ever donated blood to a relative or friend who needed it?';
	label int_date = 'Confirm interview date';
	label blood_donate_money = 'Have you ever donated blood in exchange for money?';
	label med_invasive = 'During your lifetime, have you ever had an invasive medical procedure?';
	label surgery_ever = 'During your lifetime, have you ever had any type of surgery?';
	label surgery_num = 'During your lifetime, how many surgeries have you had?';
	label surgery_hospital = 'Hospital (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_nursing = 'Nursing home (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_polyclinic = 'Polyclinic (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_other = 'Other (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_DK = 'Do not know/remember (Have you ever had surgery in any of the following locations during your lifetime?)';
	label sti_ever = 'Have you ever been told by a doctor or other health worker that you had a sexually transmitted disease?';
	label sti_syphilis = 'Syphilis (Which sexually transmitted disease have you been diagnosed with?');
	label sti_gonorrhea = 'Gonorrhea (Which sexually transmitted disease have you been diagnosed with?');
	label sti_chlamydia = 'Chlamydia (Which sexually transmitted disease have you been diagnosed with?');
	label sti_herpes = 'Herpes (Which sexually transmitted disease have you been diagnosed with?');
	label sti_warts = 'Genital warts (Which sexually transmitted disease have you been diagnosed with?');
	label sti_other = 'Other (Which sexually transmitted disease have you been diagnosed with?');
	label HIV_test = 'Have you ever been tested for HIV, the virus that causes AIDS?';
	label HIV_result = 'What were your HIV test results?';
	label tb_ever = 'Have you ever been told by a doctor or other health worker that you have tuberculosis?';
	label int_start_time = 'Interview start time';
	label tb_year = 'Have you been told that you have tuberculosis in the past 12 months?';
	label tb_treat = 'Have you ever been treated for your tuberculosis?';
	label bp_meas = 'Have you ever had your blood pressure measured by a doctor or other health worker?';
	label hypertension_ever = 'Have you ever been told by a doctor or other health worker that you have raised blood pressure or hypertension?';
	label hypertension_year = 'Have you been told that you have raised blood pressure or hypertension in the past 12 months?';
	label sugar_meas = 'Have you ever had your blood sugar measured by a doctor or other health worker?';
	label diabetes_ever = 'Have you ever been told by a doctor or other health worker that you have high blood sugar or diabetes?';
	label diabetes_year = 'Have you been told that you have raised blood sugar or diabetes in the past 12 months?';
	label insulin_current = 'Are you currently taking insulin therapy?';
	label sugar_test_share = 'Have you ever tested your blood sugar using a needle that you shared with others?';
	label consent_int = 'Consent given for interview?';
	label insulin_syringe_share = 'Have you ever shared insulin syringes with others?';
	label chronic_asthma = 'Asthma (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_arthritis = 'Arthritis (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_cancer = 'Cancer (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_CVD = 'Cardiovascular disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_COPD = 'Chronic obstructive pulmonary disease (COPD) (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_hemophilia = 'Hemophilia or other blood disorders (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_thyroid = 'Thyroid problems (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_kidney = 'Kidney disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_lung = 'Lung disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other = 'Other (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other_specify = 'If other chronic condition was recorded, please state what type';
	label cancer_type = 'If cancer was recorded, please state what type';
	label HCV_heard = 'Have you ever heard of the hepatitis C virus, or HCV?';
	label HCV_trans_droplets = 'Droplets (Do you know how HCV is transmitted?)';
	label HCV_trans_food = 'Food (Do you know how HCV is transmitted?)';
	label HCV_trans_blood = 'Blood  (Do you know how HCV is transmitted?)';
	label HCV_trans_sex = 'Sexual contact (Do you know how HCV is transmitted?)';
	label HCV_trans_handshake = 'Handshake with an infected person (Do you know how HCV is transmitted?)';
	label HCV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HCV is transmitted?)';
	label HCV_trans_needle = 'Sharing needles or syringes (Do you know how HCV is transmitted?)';
	label HCV_trans_touch = 'Touching items in public places (Do you know how HCV is transmitted?)';
	label HCV_trans_DK = 'Do not know/remember (Do you know how HCV is transmitted?)';
	label HCV_trans_none = 'None of the above (Do you know how HCV is transmitted?)';
	label HCV_trans_other = 'Other (Do you know how HCV is transmitted?)';
	label HCV_trans_other_specify = 'If other mode of HCV transmission was recorded, please state how';
	label HCV_asymptomatic = 'Is it possible to have HCV but not have any symptoms?';
	label HCV_med = 'Are there medications available to treat HCV infections?';
	label trust_family = 'Talking with family members, friends, neighbors or colleagues (Where do you get health information that you trust?)';
	label trust_medlit = 'Special medical literature (Where do you get health information that you trust?)';
	label trust_newspaper = 'Newspapers and magazines (Where do you get health information that you trust?)';
	label trust_radio = 'Radio (Where do you get health information that you trust?)';
	label trust_tv = 'TV (Where do you get health information that you trust?)';
	label trust_internet = 'Internet (Where do you get health information that you trust?)';
	label trust_billboards = 'Billboards (Where do you get health information that you trust?)';
	label trust_brochures = 'Brochures, fliers, posters, or other printed materials (Where do you get health information that you trust?)';
	label trust_doctor = 'Doctors and other healthcare workers (Where do you get health information that you trust?)';
	label trust_pharmacist = 'Pharmacists (Where do you get health information that you trust?)';
	label trust_DK = 'Do not know/remember (Where do you get health information that you trust?)';
	label trust_none = 'None of the above (Where do you get health information that you trust?)';
	label trust_other = 'Other (Where do you get health information that you trust?)';
	label trust_other_specify = 'If other source of HCV information was recorded, please specify';
	label HBV_heard = 'Have you ever heard of the hepatitis B virus?';
	label consent_demo = 'If consent not given for interview, is participant OK giving basic demographic information?';
	label HCV_prev_vacc = 'Get a vaccination (What can you do to prevent HCV infection?)';
	label HCV_prev_condom = 'Use condoms (What can you do to prevent HCV infection?)';
	label HCV_prev_needle = 'Avoid sharing syringes or needles with other people (What can you do to prevent HCV infection?)';
	label HCV_prev_wash = 'Wash hands thoroughly (What can you do to prevent HCV infection?)';
	label HCV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to prevent HCV infection?)';
	label HCV_prev_DK = 'Do not know/remember (What can you do to prevent HCV infection?)';
	label HCV_prev_other = 'Other (What can you do to prevent HCV infection?)';
	label HCV_prev_none = 'None of the above (What can you do to prevent HCV infection?)';
	label language = 'Interview language';
	label HBV_trans_droplets = 'Droplets (Do you know how HBV is transmitted?)';
	label HBV_trans_food = 'Food (Do you know how HBV is transmitted?)';
	label HBV_trans_blood = 'Blood (Do you know how HBV is transmitted?)';
	label HBV_trans_sex = 'Sexual contact (Do you know how HBV is transmitted?)';
	label HBV_trans_handshake = 'Handshake with an infected person (Do you know how HBV is transmitted?)';
	label HBV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HBV is transmitted?)';
	label HBV_trans_needle = 'Sharing needles or syringes (Do you know how HBV is transmitted?)';
	label HBV_trans_touch = 'Touching items in public places (Do you know how HBV is transmitted?)';
	label HBV_trans_DK = 'Dont know/Remember (Do you know how HBV is transmitted?)';
	label HBV_trans_none = 'None of the above (Do you know how HBV is transmitted?)';
	label HBV_trans_other = 'Other (Do you know how HBV is transmitted?)';
	label HBV_trans_other_specify = 'If HBV transmission mode recorded as other, please state how';
	label HBV_asymptomatic = 'Is it possible to have HBV but not have any symptoms?';
	label HBV_med = 'Are there medications available to reat HBV infections?';
	label HBV_prev_vacc = 'Get a vaccination (What can you do to help prevent HBV infection?)';
	label HBV_prev_condom = 'Use condoms (What can you do to help prevent HBV infection?)';
	label HBV_prev_needle = 'Avoid sharing needles and syringes (What can you do to help prevent HBV infection?)';
	label HBV_prev_wash = 'Wash hads frequently (What can you do to help prevent HBV infection?)';
	label HBV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to help prevent HBV infection?)';
	label HBV_prev_DK = 'Dont know/Remember (What can you do to help prevent HBV infection?)';
	label HBV_prev_none = 'None of the above (What can you do to help prevent HBV infection?)';
	label HCV_ever = 'Have you ever been told by a doctor or other health worker that you have hepatitis C?';
	label HCV_year = 'What year were you told that you had hepatitis C?';
	label HCV_treated = 'Have you ever taken medications to treat your hepatitis C infection?';
	label HCV_notreat_avail = 'The medication was not available (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_eligible = 'My doctor told me I was not eligible to take the medication (Why didnt you take medication to treat 
          your hepatitis C infection?)';
	label HCV_notreat_expense = 'The medication was too expensive (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_effect = 'I heard that the medication has a lot of side effects (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_inject = 'I did not want to inject myself with a needle (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_other_specify = 'Other, specify ((Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_DK = 'Dont know/remember (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_RF = 'Refused (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_travel = 'I would ahve to travel too far to get the medication, or to see hte doctor in order to get
	      the medication (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_treat_complete = 'Did you complete your hepatitis C treatment, or did you stop before the end?';
	label HCV_cured = 'Did the treatment cure your hepatitis C infection?';
	label surname = 'Family surname';
	label HBV_ever = 'Have you been told by a doctor or other health worker that you have hepatitis B?';
	label HBV_year = 'What year were you told that you have hepatitis B?';
	label HBV_treated = 'Have you ever taken medications to treat your hepatitis B infection?';
	label HBV_vacc_ever = 'Have you ever been vaccinated against hepatitis B infection?';
	label hep_other_A = 'Hepatitis A (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';
	label hep_other_D = 'Hepatitis D (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_E = 'Hepatitis E (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_none = 'None (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_year = 'What year were you told that you had this other type of hepatitis?';
	label alc_ever = 'Have you ever consumed an alcoholic drink such as beer, wine, or spirits?';
	label alc_year = 'Have you consumed an alcoholic drink within the past 12 months?' ;
	label alc_year_freq = 'During the past 12 months, how frequently have you had at least one alcoholic drink?';
	label alc_month = 'Have you consumed an alcoholic drink within the past 30 days?';
	label disposition = 'Interview disposition: Did you complete the entire questionnaire?';
	label disposition_other_specify = 'If interview disposition recorded as other, please specify';

	run;

*dropping renamed variables;;
data HCV7.phone_format;
set HCV7.phone_label (drop=
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C

CONSENT_Q22_D12

CONSENT_CONSENT2_Q32_M4_Q32A
CONSENT_CONSENT2_Q32_M4_Q32B
CONSENT_CONSENT2_Q32_M4_Q32C
CONSENT_CONSENT2_Q32_M4_Q32D
CONSENT_CONSENT2_Q32_M4_Q32E

CONSENT_CONSENT2_Q42_M15_Q42A
CONSENT_CONSENT2_Q42_M15_Q42B
CONSENT_CONSENT2_Q42_M15_Q42C
CONSENT_CONSENT2_Q42_M15_Q42D
CONSENT_CONSENT2_Q42_M15_Q42E
CONSENT_CONSENT2_Q42_M15_Q42G

CONSENT_CONSENT2_Q54_S4_Q54A
CONSENT_CONSENT2_Q54_S4_Q54B
CONSENT_CONSENT2_Q54_S4_Q54C
CONSENT_CONSENT2_Q54_S4_Q54D
CONSENT_CONSENT2_Q54_S4_Q54E

CONSENT_CONSENT2_Q56_STI2_Q56A
CONSENT_CONSENT2_Q56_STI2_Q56B
CONSENT_CONSENT2_Q56_STI2_Q56C
CONSENT_CONSENT2_Q56_STI2_Q56D
CONSENT_CONSENT2_Q56_STI2_Q56E
CONSENT_CONSENT2_Q56_STI2_Q56F

CONSENT_CONSENT2_Q71_CD1_Q71A
CONSENT_CONSENT2_Q71_CD1_Q71B
CONSENT_CONSENT2_Q71_CD1_Q71C
CONSENT_CONSENT2_Q71_CD1_Q71D
CONSENT_CONSENT2_Q71_CD1_Q71E
CONSENT_CONSENT2_Q71_CD1_Q71F
CONSENT_CONSENT2_Q71_CD1_Q71G
CONSENT_CONSENT2_Q71_CD1_Q71H
CONSENT_CONSENT2_Q71_CD1_Q71I
CONSENT_CONSENT2_Q71_CD1_Q71J
CONSENT_CONSENT2_Q71_CD1_Q71K

CONSENT_CONSENT2_Q74_H2_Q74A
CONSENT_CONSENT2_Q74_H2_Q74B
CONSENT_CONSENT2_Q74_H2_Q74C
CONSENT_CONSENT2_Q74_H2_Q74D
CONSENT_CONSENT2_Q74_H2_Q74E
CONSENT_CONSENT2_Q74_H2_Q74F
CONSENT_CONSENT2_Q74_H2_Q74G
CONSENT_CONSENT2_Q74_H2_Q74H
CONSENT_CONSENT2_Q74_H2_Q74I
CONSENT_CONSENT2_Q74_H2_Q74J
CONSENT_CONSENT2_Q74_H2_Q74K

CONSENT_CONSENT2_Q77_H5_Q77A
CONSENT_CONSENT2_Q77_H5_Q77B
CONSENT_CONSENT2_Q77_H5_Q77C
CONSENT_CONSENT2_Q77_H5_Q77D
CONSENT_CONSENT2_Q77_H5_Q77E
CONSENT_CONSENT2_Q77_H5_Q77F
CONSENT_CONSENT2_Q77_H5_Q77G
CONSENT_CONSENT2_Q77_H5_Q77H
CONSENT_CONSENT2_Q78_H6_Q78A
CONSENT_CONSENT2_Q78_H6_Q78B
CONSENT_CONSENT2_Q78_H6_Q78C
CONSENT_CONSENT2_Q78_H6_Q78D
CONSENT_CONSENT2_Q78_H6_Q78E
CONSENT_CONSENT2_Q78_H6_Q78F
CONSENT_CONSENT2_Q78_H6_Q78G
CONSENT_CONSENT2_Q78_H6_Q78H
CONSENT_CONSENT2_Q78_H6_Q78I
CONSENT_CONSENT2_Q78_H6_Q78J
CONSENT_CONSENT2_Q78_H6_Q78K
CONSENT_CONSENT2_Q78_H6_Q78L
CONSENT_CONSENT2_Q78_H6_Q78M

CONSENT_CONSENT2_Q80_H8_Q80A
CONSENT_CONSENT2_Q80_H8_Q80B
CONSENT_CONSENT2_Q80_H8_Q80C
CONSENT_CONSENT2_Q80_H8_Q80D
CONSENT_CONSENT2_Q80_H8_Q80E
CONSENT_CONSENT2_Q80_H8_Q80F
CONSENT_CONSENT2_Q80_H8_Q80G
CONSENT_CONSENT2_Q80_H8_Q80H
CONSENT_CONSENT2_Q80_H8_Q80I
CONSENT_CONSENT2_Q80_H8_Q80J
CONSENT_CONSENT2_Q80_H8_Q80K

CONSENT_CONSENT2_Q83_H11_Q83A
CONSENT_CONSENT2_Q83_H11_Q83B
CONSENT_CONSENT2_Q83_H11_Q83C
CONSENT_CONSENT2_Q83_H11_Q83D
CONSENT_CONSENT2_Q83_H11_Q83E
CONSENT_CONSENT2_Q83_H11_Q83F
CONSENT_CONSENT2_Q83_H11_Q83G

CONSENT_CONSENT2_Q87_H15_Q87A
CONSENT_CONSENT2_Q87_H15_Q87B
CONSENT_CONSENT2_Q87_H15_Q87C
CONSENT_CONSENT2_Q87_H15_Q87D
CONSENT_CONSENT2_Q87_H15_Q87E
CONSENT_CONSENT2_Q87_H15_Q87F
CONSENT_CONSENT2_Q87_H15_Q87G
CONSENT_CONSENT2_Q87_H15_Q87H
CONSENT_CONSENT2_Q87_H15_Q87I

CONSENT_CONSENT2_Q94_H22_Q94A
CONSENT_CONSENT2_Q94_H22_Q94B
CONSENT_CONSENT2_Q94_H22_Q94C
CONSENT_CONSENT2_Q94_H22_Q94D
CONSENT_CONSENT2_Q94_H22_Q94E

CONSENT_CONSENT2_Q110_T4_Q110A
CONSENT_CONSENT2_Q110_T4_Q110B
CONSENT_CONSENT2_Q110_T4_Q110C
CONSENT_CONSENT2_Q110_T4_Q110D
CONSENT_CONSENT2_Q110_T4_Q110E
CONSENT_CONSENT2_Q110_T4_Q110F
CONSENT_CONSENT2_Q110_T4_Q110G
CONSENT_CONSENT2_Q110_T4_Q110H
CONSENT_CONSENT2_Q110_T4_Q110I
CONSENT_CONSENT2_Q110_T4_Q110J
CONSENT_CONSENT2_Q110_T4_Q110K

CONSENT_CONSENT2_Q117_R7_Q117A
CONSENT_CONSENT2_Q117_R7_Q117B
CONSENT_CONSENT2_Q117_R7_Q117C
CONSENT_CONSENT2_Q117_R7_Q117D
CONSENT_CONSENT2_Q117_R7_Q117E

CONSENT_CONSENT2_Q119_R9_Q119A_
CONSENT_CONSENT2_Q119_R9_Q119B_
CONSENT_CONSENT2_Q119_R9_Q119C_
CONSENT_CONSENT2_Q119_R9_Q119D_
CONSENT_CONSENT2_Q119_R9_Q119E_
CONSENT_CONSENT2_Q120A_R10A

CONSENT_CONSENT2_Q120_R10_Q120A  
CONSENT_CONSENT2_Q120_R10_Q120B  
CONSENT_CONSENT2_Q120_R10_Q120C  
CONSENT_CONSENT2_Q120_R10_Q120D  

CONSENT_CONSENT2_Q122_R12_Q122A
CONSENT_CONSENT2_Q122_R12_Q122B
CONSENT_CONSENT2_Q122_R12_Q122C
CONSENT_CONSENT2_Q122_R12_Q122D
CONSENT_CONSENT2_Q122_R12_Q122E
CONSENT_CONSENT2_Q122_R12_Q122F
CONSENT_CONSENT2_Q122_R12_Q122G 

CONSENT_CONSENT2_Q127_I5_Q127A
CONSENT_CONSENT2_Q127_I5_Q127B
CONSENT_CONSENT2_Q127_I5_Q127C
CONSENT_CONSENT2_Q127_I5_Q127D
CONSENT_CONSENT2_Q127_I5_Q127E
CONSENT_CONSENT2_Q127_I5_Q127F
CONSENT_CONSENT2_Q127_I5_Q127G
CONSENT_CONSENT2_Q127_I5_Q127H
CONSENT_CONSENT2_Q127_I5_Q127I

CONSENT_CONSENT2_Q132_I10_Q132A
CONSENT_CONSENT2_Q132_I10_Q132B
CONSENT_CONSENT2_Q132_I10_Q132C
CONSENT_CONSENT2_Q132_I10_Q132D
CONSENT_CONSENT2_Q132_I10_Q132E
CONSENT_CONSENT2_Q132_I10_Q132F
CONSENT_CONSENT2_Q132_I10_Q132G
CONSENT_CONSENT2_Q132_I10_Q132H
CONSENT_CONSENT2_Q132_I10_Q132I
CONSENT_CONSENT2_Q132_I10_Q132J
CONSENT_CONSENT2_Q132_I10_Q132K
CONSENT_CONSENT2_Q132_I10_Q132L
CONSENT_CONSENT2_Q132_I10_Q132M
CONSENT_CONSENT2_Q132_I10_Q132N
CONSENT_CONSENT2_Q132_I10_Q132O

CONSENT_CONSENT2_Q139_SP7_Q139A
CONSENT_CONSENT2_Q139_SP7_Q139B
CONSENT_CONSENT2_Q139_SP7_Q139C
CONSENT_CONSENT2_Q139_SP7_Q139D
CONSENT_CONSENT2_Q139_SP7_Q139E
CONSENT_CONSENT2_Q139_SP7_Q139F
CONSENT_CONSENT2_Q139_SP7_Q139G
CONSENT_CONSENT2_Q139_SP7_Q139H
CONSENT_CONSENT2_Q113_R3_Q113A
CONSENT_CONSENT2_Q113_R3_Q113B
CONSENT_CONSENT2_Q113_R3_Q113C
CONSENT_CONSENT2_Q113_R3_Q113D
CONSENT_CONSENT2_Q113_R3_Q113E

/* same variables */

Q0_BARCODE
Q1_I1
Q2A_I2
Q3A_I3
Q3B_I3
Q4_I4
Q5_I5
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
CONSENT_Q9_I9
CONSENT_Q10_I10
Q11_D1
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20_D10
CONSENT_Q20A_D10_OTHER
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
/*CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F*/
CONSENT_CONSENT2_Q30_M2
/*CONSNTCNSENT2Q29CM1C_Q29C_G*/
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q32_M4A
/*CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E*/
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
/*CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G*/
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
/*CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E*/
CONSENT_CONSENT2_Q55_STI1
/*CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F*/
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
/*CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K*/
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
/*CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K*/
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
/*CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H*/
/*CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M*/
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
/*CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K*/
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
/*CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G*/
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
/*CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I*/
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
/*CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E*/
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
/*CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K*/
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
/*CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E*/
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
/*CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9*/
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
/*CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D*/
CONSENT_CONSENT2_Q121_R11
/*CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G*/
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
/*CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I*/
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
/*CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O*/
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
/*CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H*/
/*CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E*/
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9


CONSENT_CONSENT2_PROMPT1
CONSENT_CONSENT2_PROMPT2
CONSENT_CONSENT2_PROMPT3
CONSENT_CONSENT2_PROMPT4
CONSENT_CONSENT2_PROMPT5
CONSENT_CONSENT2_PROMPTB
CONSENT_CONSENT2_PROMPTC
CONSENT_CONSENT2_PROMPTD
CONSENT_CONSENT2_PROMPTE
CONSENT_CONSENT2_PROMPTF
CONSENT_CONSENT2_PROMPTG
CONSENT_CONSENT2_PROMPTH
CONSENT_CONSENT2_PROMPTI
CONSENT_CONSENT2_PROMPTJ
CONSENT_CONSENT2_PROMPTK
CONSENT_CONSENT2_PROMPTL
CONSENT_CONSENT2_PROMPTM
CONSENT_CONSENT2_PROMPTN
CONSENT_CONSENT2_PROMPTO
CONSENT_CONSENT2_PROMPTP


CONSENT_PROMPTA
PROMPT6
PROMPTQ
PROMPTR
/*_LAST_UPDATE_URI_USER
_MODEL_VERSION
_UI_VERSION
_ORDINAL_NUMBER*/
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22

Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31

/*var variables (flu variables)*/
var50 var51 var52 var53 var54 var55 CONSENT_CONSENT2_Q29C_M1C_Q29C_);
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

*/Change "NULL" and "NUL" responses to missing;;
data HCV8.HCVnull(drop= i test1 test2 /*data1 data2 data3 data4 data5 data6 data7*/); set HCV8.hcvmerge;
array checknull (354) $ CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
CONSENT_CONSENT2_Q121_R11
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
CONSENT_CONSENT2_Q30_M2
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
CONSENT_CONSENT2_Q55_STI1
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_Q9_I9
CONSENT_Q10_I10
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20A_D10_OTHER
CONSENT_Q20_D10
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K
CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E
CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E
CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9
CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E
CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E
CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K
CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M
CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H
CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K
CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G
CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E
CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D
CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G
CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H
CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F
CONSNTCNSENT2Q29CM1C_Q29C_G
CONSENT_CONSENT2_Q32_M4A
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G
CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K
CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I
CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I
CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O
CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F
Q0_BARCODE
Q1_I1
Q11_D1
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22
Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31
Q2A_I2
Q3A_I3
Q3B_I3
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
;
	do i=1 to 354;
		test1=find(checknull(i),"NULL");
		test2=find(checknull(i),"NUL");
		if test1>0 or test2>0 then do;
			checknull(i)=" ";
		end;
	end;
run;

*/Rename variables and indicate which are numeric;;

data HCV8.HCVrecode;
	set HCV8.HCVnull;

/**/barcode=Q0_BARCODE;
int_id_quest=Q1_I1;
hh_num=input(Q2A_I2,8.0);
/**/stratum_num=Q3A_I3;
/**/cluster_ID=Q3B_I3;
cluster_name=Q4_I4;
int_date=Q5_I5;
int_start_time=Q6_I6;
consent_int=input(Q7_I7,8.0);
consent_demo=input(Q7A_CONSENT,8.0);
language=input(Q8_I8,8.0);
surname=CONSENT_Q9_I9;
f_name=CONSENT_Q10_I10;
gender=input(Q11_D1,8.0);
birthday=CONSENT_Q12A_D2;
birthyear=input(CONSENT_Q12B_D2,8.0);
age=input(CONSENT_Q13_D3,8.0);
education=input(CONSENT_Q14_D4,8.0);
ethnicity=input(CONSENT_Q15_D5,8.0);
ethnicity_other_specify=CONSENT_Q15A_D5_OTHER;
religion=input(CONSENT_Q16_D6,8.0);
religion_other_specify=CONSENT_Q16A_D6_OTHER;
married=input(CONSENT_Q17_D7,8.0);
work=input(CONSENT_Q18_D8,8.0);
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);
house=input(CONSENT_Q20_D10,8.0);
house_other_specify=CONSENT_Q20A_D10_OTHER;
resident_num=input(CONSENT_Q21_D11,8.0);
earnings_cat=input(CONSENT_Q22_D12,8.0);
earnings_amount=input(CONSENT_Q22A_D12,8.0);
earnings_estimate=input(CONSENT_Q23_D13,8.0);
earners_num=input(CONSENT_Q24_D14,8.0);
insurance=input(CONSENT_Q25_D15,8.0);
insurance_type=input(CONSENT_Q26_D16,8.0);
medcare_pay=input(CONSENT_Q27_D17,8.0);
medcare_pay_other_specify=CONSENT_Q27A_D17_OTHER;
displaced=input(CONSENT_Q28_D18,8.0);
medcare_location=input(CONSENT_CONSENT2_Q29_M1,8.0);
medcare_location_other_specify=CONSENT_CONSENT2_Q29A_M1_OTHER;
flu=input(CONSENT_CONSENT2_Q29B_M1B,8.0);
flu_polyclinic=input(CONSNTCNSENT2Q29CM1C_Q29C_A,8.0);
flu_hospital=input(CONSNTCNSENT2Q29CM1C_Q29C_B,8.0);
flu_medhome=input(CONSNTCNSENT2Q29CM1C_Q29C_C,8.0);
flu_pharmacy=input(CONSNTCNSENT2Q29CM1C_Q29C_D,8.0);
flu_villagedoc=input(CONSNTCNSENT2Q29CM1C_Q29C_E,8.0);
flu_none=input(CONSNTCNSENT2Q29CM1C_Q29C_F,8.0);
hospital_lifetime_num=input(CONSENT_CONSENT2_Q30_M2,8.0);
flu_other=CONSNTCNSENT2Q29CM1C_Q29C_G;
dentist_cat=input(CONSENT_CONSENT2_Q31_M3,8.0);
dentist_other_specify=CONSENT_CONSENT2_Q32_M4A;
dentist_hospital=input(CONSENTCONSENT2Q32M4_Q32A,8.0);
dentist_cabinet=input(CONSENTCONSENT2Q32M4_Q32B,8.0);
dentist_home=input(CONSENTCONSENT2Q32M4_Q32C,8.0);
dentist_other=input(CONSENTCONSENT2Q32M4_Q32D,8.0);
dentist_DK=input(CONSENTCONSENT2Q32M4_Q32E,8.0);
dental_proc_num=input(CONSENT_CONSENT2_Q33_M5,8.0);
shot_num=input(CONSENT_CONSENT2_Q34_M6,8.0);
flushot=input(CONSENT_CONSENT2_Q34A_M6_1,8.0);
flushot_loc=CONSENT_CONSENT2_Q34B_M6_2;
shot_admin=input(CONSENT_CONSENT2_Q35_M7,8.0);
shot_admin_other=CONSENT_CONSENT2_Q35A_M7_OTHER;
shot_needle=input(CONSENT_CONSENT2_Q36_M8,8.0);
shot_needle_other_specify=CONSENT_CONSENT2_Q36A_M8_OTHER;
shot_purpose=input(CONSENT_CONSENT2_Q37_M9,8.0);
shot_purpose_other_specify=CONSENT_CONSENT2_Q37A_M9_OTHER;
shot_med=input(CONSENT_CONSENT2_Q38_M10,8.0);
shot_med_other_specify=CONSENT_CONSENT2_Q38A_M10_OTHER;
shot_discard=input(CONSENT_CONSENT2_Q39_M11,8.0);
IV_num=input(CONSENT_CONSENT2_Q40_M12,8.0);
dialysis_ever=input(CONSENT_CONSENT2_Q41_M14,8.0);
dialysis_polyclinic=input(CONSNTCNSENT2Q42M15_Q42A,8.0);
dialysis_hospital=input(CONSNTCNSENT2Q42M15_Q42B,8.0);
dialysis_home=input(CONSNTCNSENT2Q42M15_Q42C,8.0);
dialysis_pharmacy=input(CONSNTCNSENT2Q42M15_Q42D,8.0);
dialysis_villagedoc=input(CONSNTCNSENT2Q42M15_Q42E,8.0);
dialysis_other=input(CONSNTCNSENT2Q42M15_Q42G,8.0);
dialysis_current=input(CONSENT_CONSENT2_Q43_M16,8.0);
dialysis_freq=input(CONSENT_CONSENT2_Q44_M17,8.0);
blood_trans=input(CONSENT_CONSENT2_Q45_M18,8.0);
blood_trans_num=input(CONSENT_CONSENT2_Q46_M19,8.0);
blood_trans_relative=input(CONSENT_CONSENT2_Q47_M20,8.0);
blood_donate=input(CONSENT_CONSENT2_Q48_M21,8.0);
blood_donate_relative=input(CONSENT_CONSENT2_Q49_M22,8.0);
blood_donate_money=input(CONSENT_CONSENT2_Q50_M23,8.0);
med_invasive=input(CONSENT_CONSENT2_Q51_S1,8.0);
surgery_ever=input(CONSENT_CONSENT2_Q52_S2,8.0);
surgery_num=input(CONSENT_CONSENT2_Q53_S3,8.0);
surgery_hospital=input(CONSENTCONSENT2Q54S4_Q54A,8.0);
surgery_nursing=input(CONSENTCONSENT2Q54S4_Q54B,8.0);
surgery_polyclinic=input(CONSENTCONSENT2Q54S4_Q54C,8.0);
surgery_other=CONSENTCONSENT2Q54S4_Q54D;
surgery_DK=input(CONSENTCONSENT2Q54S4_Q54E,8.0);
sti_ever=input(CONSENT_CONSENT2_Q55_STI1,8.0);
sti_syphilis=input(CONSNTCONSNT2Q56STI2_Q56A,8.0);
sti_gonorrhea=input(CONSNTCONSNT2Q56STI2_Q56B,8.0);
sti_chlamydia=input(CONSNTCONSNT2Q56STI2_Q56C,8.0);
sti_herpes=input(CONSNTCONSNT2Q56STI2_Q56D,8.0);
sti_warts=input(CONSNTCONSNT2Q56STI2_Q56E,8.0);
sti_other=CONSNTCONSNT2Q56STI2_Q56F;
HIV_test=input(CONSENT_CONSENT2_Q57_STI3,8.0);
HIV_result=input(CONSENT_CONSENT2_Q58_STI4,8.0);
tb_ever=input(CONSENT_CONSENT2_Q59_TB1,8.0);
tb_year=input(CONSENT_CONSENT2_Q60_TB2,8.0);
tb_treat=input(CONSENT_CONSENT2_Q61_TB3,8.0);
bp_meas=input(CONSENT_CONSENT2_Q62_HY1,8.0);
hypertension_ever=input(CONSENT_CONSENT2_Q63_HY2,8.0);
hypertension_year=input(CONSENT_CONSENT2_Q64_HY3,8.0);
sugar_meas=input(CONSENT_CONSENT2_Q65_D1,8.0);
diabetes_ever=input(CONSENT_CONSENT2_Q66_D2,8.0);
diabetes_year=input(CONSENT_CONSENT2_Q67_D3,8.0);
insulin_current=input(CONSENT_CONSENT2_Q68_D4,8.0);
sugar_test_share=input(CONSENT_CONSENT2_Q69_D5,8.0);
insulin_syringe_share=input(CONSENT_CONSENT2_Q70_D6,8.0);
chronic_asthma=input(CONSNTCNSENT2Q71CD1_Q71A,8.0);
chronic_arthritis=input(CONSNTCNSENT2Q71CD1_Q71B,8.0);
chronic_cancer=input(CONSNTCNSENT2Q71CD1_Q71C,8.0);
chronic_CVD=input(CONSNTCNSENT2Q71CD1_Q71D,8.0);
chronic_COPD=input(CONSNTCNSENT2Q71CD1_Q71E,8.0);
chronic_hemophilia=input(CONSNTCNSENT2Q71CD1_Q71F,8.0);
chronic_thyroid=input(CONSNTCNSENT2Q71CD1_Q71G,8.0);
chronic_kidney=input(CONSNTCNSENT2Q71CD1_Q71H,8.0);
chronic_lung=input(CONSNTCNSENT2Q71CD1_Q71I,8.0);
chronic_other=input(CONSNTCNSENT2Q71CD1_Q71J,8.0);
chronic_DK=input(CONSNTCNSENT2Q71CD1_Q71K,8.0);
chronic_other_specify=CONSENT_CONSENT2_Q71L_CD1_OTHER;
cancer_type=CONSENT_CONSENT2_Q72_CD2;
HCV_heard=input(CONSENT_CONSENT2_Q73_H1,8.0);
HCV_trans_droplets=input(CONSENTCONSENT2Q74H2_Q74A,8.0);
HCV_trans_food=input(CONSENTCONSENT2Q74H2_Q74B,8.0);
HCV_trans_blood=input(CONSENTCONSENT2Q74H2_Q74C,8.0);
HCV_trans_sex=input(CONSENTCONSENT2Q74H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENTCONSENT2Q74H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENTCONSENT2Q74H2_Q74F,8.0);
HCV_trans_needle=input(CONSENTCONSENT2Q74H2_Q74G,8.0);
HCV_trans_touch=input(CONSENTCONSENT2Q74H2_Q74H,8.0);
HCV_trans_DK=input(CONSENTCONSENT2Q74H2_Q74I,8.0);
HCV_trans_none=input(CONSENTCONSENT2Q74H2_Q74J,8.0);
HCV_trans_other=input(CONSENTCONSENT2Q74H2_Q74K,8.0);
HCV_trans_other_specify=CONSENT_CONSENT2_Q74L_H2A;
HCV_asymptomatic=input(CONSENT_CONSENT2_Q75_H3,8.0);
HCV_med=input(CONSENT_CONSENT2_Q76_H4,8.0);
HCV_prev_vacc=input(CONSENTCONSENT2Q7H5_Q77A,8.0);
HCV_prev_condom=input(CONSENTCONSENT2Q7H5_Q77B,8.0);
HCV_prev_needle=input(CONSENTCONSENT2Q7H5_Q77C,8.0);
HCV_prev_wash=input(CONSENTCONSENT2Q7H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENTCONSENT2Q7H5_Q77E,8.0);
HCV_prev_DK=input(CONSENTCONSENT2Q7H5_Q77F,8.0);
HCV_prev_other=CONSENTCONSENT2Q7H5_Q77G;
HCV_prev_none=input(CONSENTCONSENT2Q7H5_Q77H,8.0);
trust_family=input(CONSENTCONSENT2Q78H6_Q78A,8.0);
trust_medlit=input(CONSENTCONSENT2Q78H6_Q78B,8.0);
trust_newspaper=input(CONSENTCONSENT2Q78H6_Q78C,8.0);
trust_radio=input(CONSENTCONSENT2Q78H6_Q78D,8.0);
trust_tv=input(CONSENTCONSENT2Q78H6_Q78E,8.0);
trust_internet=input(CONSENTCONSENT2Q78H6_Q78F,8.0);
trust_billboards=input(CONSENTCONSENT2Q78H6_Q78G,8.0);
trust_brochures=input(CONSENTCONSENT2Q78H6_Q78H,8.0);
trust_doctor=input(CONSENTCONSENT2Q78H6_Q78I,8.0);
trust_pharmacist=input(CONSENTCONSENT2Q78H6_Q78J,8.0);
trust_DK=input(CONSENTCONSENT2Q78H6_Q78K,8.0);
trust_none=input(CONSENTCONSENT2Q78H6_Q78L,8.0);
trust_other=input(CONSENTCONSENT2Q78H6_Q78M,8.0);
trust_other_specify=CONSENT_CONSENT2_Q78N_H6A;
HBV_heard=input(CONSENT_CONSENT2_Q79_H7,8.0);
HBV_trans_droplets=input(CONSENTCONSENT2Q80H8_Q80A,8.0);
HBV_trans_food=input(CONSENTCONSENT2Q80H8_Q80B,8.0);
HBV_trans_blood=input(CONSENTCONSENT2Q80H8_Q80C,8.0);
HBV_trans_sex=input(CONSENTCONSENT2Q80H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENTCONSENT2Q80H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENTCONSENT2Q80H8_Q80F,8.0);
HBV_trans_needle=input(CONSENTCONSENT2Q80H8_Q80G,8.0);
HBV_trans_touch=input(CONSENTCONSENT2Q80H8_Q80H,8.0);
HBV_trans_DK=input(CONSENTCONSENT2Q80H8_Q80I,8.0);
HBV_trans_none=input(CONSENTCONSENT2Q80H8_Q80J,8.0);
HBV_trans_other=input(CONSENTCONSENT2Q80H8_Q80K,8.0);
HBV_trans_other_specify=CONSENT_CONSENT2_Q80L_H8A;
HBV_asymptomatic=input(CONSENT_CONSENT2_Q81_H9,8.0);
HBV_med=input(CONSENT_CONSENT2_Q82_H10,8.0);
HBV_prev_vacc=input(CONSENTCONSENT2Q83H1_Q83A,8.0);
HBV_prev_condom=input(CONSENTCONSENT2Q83H1_Q83B,8.0);
HBV_prev_needle=input(CONSENTCONSENT2Q83H1_Q83C,8.0);
HBV_prev_wash=input(CONSENTCONSENT2Q83H1_Q83D,8.0);
HBV_prev_sterile=input(CONSENTCONSENT2Q83H1_Q83E,8.0);
HBV_prev_DK=input(CONSENTCONSENT2Q83H1_Q83F,8.0);
HBV_prev_none=input(CONSENTCONSENT2Q83H1_Q83G,8.0);
HCV_ever=input(CONSENT_CONSENT2_Q84_H12,8.0);
HCV_year=input(CONSENT_CONSENT2_Q85_H13,8.0);
HCV_treated=input(CONSENT_CONSENT2_Q86_H14,8.0);
HCV_notreat_avail=input(CONSNTCNSENT2Q87H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSNTCNSENT2Q87H15_Q87B,8.0);
HCV_notreat_expense=input(CONSNTCNSENT2Q87H15_Q87C,8.0);
HCV_notreat_effect=input(CONSNTCNSENT2Q87H15_Q87D,8.0);
HCV_notreat_inject=input(CONSNTCNSENT2Q87H15_Q87E,8.0);
HCV_notreat_other_specify=CONSNTCNSENT2Q87H15_Q87F;
HCV_notreat_DK=input(CONSNTCNSENT2Q87H15_Q87G,8.0);
HCV_notreat_RF=input(CONSNTCNSENT2Q87H15_Q87H,8.0);
HCV_notreat_travel=input(CONSNTCNSENT2Q87H15_Q87I,8.0);
HCV_treat_complete=input(CONSENT_CONSENT2_Q88_H16,8.0);
HCV_cured=input(CONSENT_CONSENT2_Q89_H17,8.0);
HBV_ever=input(CONSENT_CONSENT2_Q90_H18,8.0);
HBV_year=input(CONSENT_CONSENT2_Q91_H19,8.0);
HBV_treated=input(CONSENT_CONSENT2_Q92_H20,8.0);
HBV_vacc_ever=input(CONSENT_CONSENT2_Q93_H21,8.0);
hep_other_A=input(CONSENTCONSENT2Q94H2_Q94A,8.0);
hep_other_D=input(CONSENTCONSENT2Q94H2_Q94B,8.0);
hep_other_E=input(CONSENTCONSENT2Q94H2_Q94C,8.0);
hep_other_none=input(CONSENTCONSENT2Q94H2_Q94D,8.0);
hep_other_DK=input(CONSENTCONSENT2Q94H2_Q94E,8.0);
hep_other_year=input(CONSENT_CONSENT2_Q95_H23,8.0);
alc_ever=input(CONSENT_CONSENT2_Q96_A1A,8.0);
alc_year=input(CONSENT_CONSENT2_Q97_A1B,8.0);
alc_year_freq=input(CONSENT_CONSENT2_Q98_A2,8.0);
alc_month=input(CONSENT_CONSENT2_Q99_A3,8.0);
alc_occasions=input(CONSENT_CONSENT2_Q100_A4,8.0);
alc_drinks=input(CONSENT_CONSENT2_Q101_A5,8.0);
alc_max=input(CONSENT_CONSENT2_Q102_A6,8.0);
alc_male=input(CONSENT_CONSENT2_Q103A_A7_MALES,8.0);
alc_female=input(CONSENT_CONSENT2_Q103B_A7_FEMAL,8.0);
walk_bike_lastweek=input(CONSENT_CONSENT2_Q104_PA1,8.0);
walk_bike_typicalweek=input(CONSENT_CONSENT2_Q105_PA2,8.0);
walk_bike_typicalday=CONSENT_CONSENT2_Q106_PA3;
smoke_current_freq=input(CONSENT_CONSENT2_Q107_T1,8.0);
smoke_past=input(CONSENT_CONSENT2_Q108_T2,8.0);
smoke_past_freq=input(CONSENT_CONSENT2_Q109_T3,8.0);
cig_num=input(CONSENTCONSENT2Q10T4_Q110A,8.0);
cig_day_week=input(CONSENTCONSENT2Q10T4_Q110B,8.0);
hand_cig_num=input(CONSENTCONSENT2Q10T4_Q110C,8.0);
hand_cig_day_week=input(CONSENTCONSENT2Q10T4_Q110D,8.0);
pipe_num=input(CONSENTCONSENT2Q10T4_Q110E,8.0);
pipe_day_week=input(CONSENTCONSENT2Q10T4_Q110F,8.0);
cigar_num=input(CONSENTCONSENT2Q10T4_Q110G,8.0);
cigar_day_week=input(CONSENTCONSENT2Q10T4_Q110H,8.0);
smoke_other=CONSENTCONSENT2Q10T4_Q110I;
smoke_other_num=input(CONSENTCONSENT2Q10T4_Q110J,8.0);
smoke_other_day_week=input(CONSENTCONSENT2Q10T4_Q110K,8.0);
prison=input(CONSENT_CONSENT2_Q111_R1,8.0);
tattoo=input(CONSENT_CONSENT2_Q112_R2,8.0);
tattoo_other_specify=CONSENT_CONSENT2_Q113F_R3A;
tattoo_needle=input(CONSENT_CONSENT2_Q114_R4,8.0);
tattoo_ink=input(CONSENT_CONSENT2_Q115_R5,8.0);
piercing=input(CONSENT_CONSENT2_Q116_R6,8.0);
piercing_other_specify=CONSENT_CONSENT2_Q117F_R7A;
piercing_salon=input(CONSENTCONSENT2Q17R7_Q117A,8.0);
piercing_home=input(CONSENTCONSENT2Q17R7_Q117B,8.0);
piercing_prison=input(CONSENTCONSENT2Q17R7_Q117C,8.0);
piercing_other=input(CONSENTCONSENT2Q17R7_Q117D,8.0);
piercing_DK=input(CONSENTCONSENT2Q17R7_Q117E,8.0);
piercing_needle=input(CONSENT_CONSENT2_Q118_R8,8.0);
manicure_num=input(CONSENT_CONSENT2_Q119A_R9A,8.0);
manicure_salon=input(CONSENTCONSENT2Q19R9_Q119A_R9,8.0);
manicure_homeservice=input(CONSENTCONSENT2Q19R9_Q119B_R9,8.0);
manicure_self=input(CONSENTCONSENT2Q19R9_Q119C_R9,8.0);
manicure_never=input(CONSENTCONSENT2Q19R9_Q119D_R9,8.0);
manicure_other=CONSENTCONSENT2Q19R9_Q119E_R9;
barber_num=input(CONSENT_CONSENT2_Q120A_R10A,8.0);
shave_other_specify=CONSENT_CONSENT2_Q120E_R10E;
shave_barber=input(CONSNTCNSENT2Q120R10_Q120A,8.0);
shave_home=input(CONSNTCNSENT2Q120R10_Q120B,8.0);
shave_none=input(CONSNTCNSENT2Q120R10_Q120C,8.0);
shave_other=input(CONSNTCNSENT2Q120R10_Q120D,8.0);
shave_razor=input(CONSENT_CONSENT2_Q121_R11,8.0);
heprisk_toothbrush=input(CONSNTCNSENT2Q12R12_Q122A,8.0);
heprisk_razor=input(CONSNTCNSENT2Q12R12_Q122B,8.0);
heprisk_scissors=input(CONSNTCNSENT2Q12R12_Q122C,8.0);
heprisk_brush=input(CONSNTCNSENT2Q12R12_Q122D,8.0);
heprisk_nail=input(CONSNTCNSENT2Q12R12_Q122E,8.0);
heprisk_none=input(CONSNTCNSENT2Q12R12_Q122F,8.0);
heprisk_DK=input(CONSNTCNSENT2Q12R12_Q122G,8.0);
IDU_ever=input(CONSENT_CONSENT2_Q123_I1,8.0);
IDU_num_life=input(CONSENT_CONSENT2_Q124_I2,8.0);
IDU_num_6mo=input(CONSENT_CONSENT2_Q125_I3,8.0);
IDU_age_start=input(CONSENT_CONSENT2_Q126_I4,8.0);
IDU_needle_NEP=input(CONSNTCONSNT2Q127I5_Q127A,8.0);
IDU_needle_store=input(CONSNTCONSNT2Q127I5_Q127B,8.0);
IDU_needle_order=input(CONSNTCONSNT2Q127I5_Q127C,8.0);
IDU_needle_borrow=input(CONSNTCONSNT2Q127I5_Q127D,8.0);
IDU_needle_rent=input(CONSNTCONSNT2Q127I5_Q127E,8.0);
IDU_needle_found=input(CONSNTCONSNT2Q127I5_Q127F,8.0);
IDU_needle_DK=input(CONSNTCONSNT2Q127I5_Q127G,8.0);
IDU_needle_none=input(CONSNTCONSNT2Q127I5_Q127H,8.0);
IDU_needle_refused=input(CONSNTCONSNT2Q127I5_Q127I,8.0);
IDU_share1=input(CONSENT_CONSENT2_Q128_I6,8.0);
IDU_share1_num=input(CONSENT_CONSENT2_Q129_I7,8.0);
IDU_share2=input(CONSENT_CONSENT2_Q130_I8,8.0);
IDU_share2_num=input(CONSENT_CONSENT2_Q131_I9,8.0);
IDU_vent=input(CONSNTCONSNT2Q132I10_Q132A,8.0);
IDU_jeff=input(CONSNTCONSNT2Q132I10_Q132B,8.0);
IDU_krokodil=input(CONSNTCONSNT2Q132I10_Q132C,8.0);
IDU_opium=input(CONSNTCONSNT2Q132I10_Q132D,8.0);
IDU_med=input(CONSNTCONSNT2Q132I10_Q132E,8.0);
IDU_poppy=input(CONSNTCONSNT2Q132I10_Q132F,8.0);
IDU_heroin=input(CONSNTCONSNT2Q132I10_Q132G,8.0);
IDU_alcohol=input(CONSNTCONSNT2Q132I10_Q132H,8.0);
IDU_cocaine=input(CONSNTCONSNT2Q132I10_Q132I,8.0);
IDU_crack=input(CONSNTCONSNT2Q132I10_Q132J,8.0);
IDU_psych=input(CONSNTCONSNT2Q132I10_Q132K,8.0);
IDU_ecstasy=input(CONSNTCONSNT2Q132I10_Q132L,8.0);
IDU_otherdrug=CONSNTCONSNT2Q132I10_Q132M;
IDU_drug_DK=input(CONSNTCONSNT2Q132I10_Q132N,8.0);
IDU_drug_RF=input(CONSNTCONSNT2Q132I10_Q132O,8.0);
sex_num=input(CONSENT_CONSENT2_Q133_SP1,8.0);
sex_STI=input(CONSENT_CONSENT2_Q134_SP2,8.0);
sex_HBV=input(CONSENT_CONSENT2_Q135_SP3,8.0);
sex_HCV=input(CONSENT_CONSENT2_Q136_SP4,8.0);
sex_HIV=input(CONSENT_CONSENT2_Q137_SP5,8.0);
condom=input(CONSENT_CONSENT2_Q138_SP6,8.0);
sex_healthcare=input(CONSNTCNSENT2Q139SP7_Q139A,8.0);
sex_military=input(CONSNTCNSENT2Q139SP7_Q139B,8.0);
sex_police=input(CONSNTCNSENT2Q139SP7_Q139C,8.0);
sex_dialysis=input(CONSNTCNSENT2Q139SP7_Q139D,8.0);
sex_IDU=input(CONSNTCNSENT2Q139SP7_Q139E,8.0);
sex_CSW=input(CONSNTCNSENT2Q139SP7_Q139F,8.0);
sex_none=input(CONSNTCNSENT2Q139SP7_Q139G,8.0);
sex_RF=input(CONSNTCNSENT2Q139SP7_Q139H,8.0);
tattoo_salon=input(CONSENTCONSENT2Q13R3_Q113A,8.0);
tattoo_home=input(CONSENTCONSENT2Q13R3_Q113B,8.0);
tattoo_prison=input(CONSENTCONSENT2Q13R3_Q113C,8.0);
tattoo_other=input(CONSENTCONSENT2Q13R3_Q113D,8.0);
tattoo_DK=input(CONSENTCONSENT2Q13R3_Q113E,8.0);
MSM=input(CONSENT_CONSENT2_Q140_SP8,8.0);
MSM_condom=input(CONSENT_CONSENT2_Q141_SP9,8.0);
int_ID_NCD=Q142_PB1;
nurse_ID=Q143_PB2;
consent_NCD=input(Q144_PB3,8.0);
consent_blood=input(Q145_PB4,8.0);
consent_bank=input(Q147_PB6,8.0);
phone_results=Q148_PB7;
address_results=Q149_PB8;
BP_ID=Q150_PB9;
cuff=input(Q151_PB10,8.0);
cuff_other_specify=input(Q151A_PB10,8.0);
BP_s1=input(Q152_PB11,8.0);
BP_d1=input(Q152_PB12,8.0);
BPM1=input(Q152_PB13,8.0);
BP_s2=input(Q153_PB14,8.0);
BP_d2=input(Q153_PB15,8.0);
BPM2=input(Q153_PB16,8.0);
BP_s3=input(Q154_PB17,8.0);
BP_d3=input(Q154_PB18,8.0);
BPM3=input(Q154_PB19,8.0);
BP_treat=input(Q155_PB20,8.0);
height_ID=Q156A_PB21;
weight_ID=Q156B_PB22;
height_cm=input(Q157_PB23,8.0);
kyphotic=input(Q157A_PB23A,8.0);
weight_kg=input(Q158_PB24,8.0);
pregnant=input(Q159_PB25,8.0);
waist_ID=Q160_PB26;
waist_cm=input(Q161_PB27,8.0);
hip_cm=input(Q162_PB28,8.0);
blood_collected=input(Q163_PB29,8.0);
disposition=input(Q164_EXIT1,8.0);
disposition_other_specify=Q164A_EXIT1_OTHER;
blood_time=Q165_PB31;
run;

*/Create labels for renamed variables;;
data HCV8.HCVlabel; set HCV8.HCVrecode; 
	label barcode = 'Barcode';
	label int_id_quest = 'Interviewer ID for behavioral questionnaire';
	label f_name = 'First name';
	label age = 'Age of participant';
	label gender = 'Gender';
	label education = 'What is the highest level of education you have completed?';
	label alc_occasions = 'During the past 30 days, on how many drinking occasions did you have at least one alcoholic drink?';
	label alc_drinks = 'During the past 30 days, when you drank alcohol, on average, how many standard alcoholic drinks did you have during one drinking occasion?';
	label alc_max = 'During the past 30 days, what was the largest number of standard alcoholic drinks you had on a single occasion?';
	label alc_male = '(Males) During the past 30 days, how many times did you have 5 or more standard alcoholic drinks in a single drinking occasion?';
	label alc_female = '(Females) During the past 30 days, how many times did you have 4 or more standard alcoholic drinks in a single drinking occasion?';
	label walk_bike_lastweek = 'Have you walked or used a bicycle for at least 10 minutes continuously to get to and from places in the last week?';
	label walk_bike_typicalweek = 'In a typical week, on how many days do you walk or bicycle for at least 10 minutes continuously to get to and from places?';
	label walk_bike_typicalday = 'How much time do you spend walking or bicylcling for travel on a typical day?';
	label smoke_current_freq = 'Do you currently smoke tobacco...';
	label smoke_past = 'Have you smoked tobacco daily in the past?';
	label smoke_past_freq = 'In the past, have you smoked tobacco...';
	label cig_num = 'Number of manufactured cigarettes';
	label cig_day_week = 'Manufactured cigarettes counted per day/week';
	label hand_cig_num = 'Number of hand rolled cigarettes';
	label hand_cig_day_week = 'Hand rolled cigarettes counted per day/week';
	label pipe_num = 'Number of pipes full of tobacco';
	label pipe_day_week = 'Pipes counted per day/week';
	label cigar_num = 'Number of cigars, cheroots, or cigarillos';
	label cigar_day_week = 'Cigars, cheroots, or cigarillos counted per day/week';
	label smoke_other = 'Other tobacco products (specify)';
	label smoke_other_num = 'Number of other tobacco products';
	label smoke_other_day_week = 'Other tobacco products counted per day/week';
	label prison = 'Have you ever been in prison or jail?';
	label tattoo = 'Do you have any tattoos? If so, how many?';
	label tattoo_other_specify = 'If you got a tattoo somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label tattoo_needle = 'Do you know if the people who gave you your tattoo(s) used new needles, or did they use needles that had been used before?';
	label tattoo_ink = 'Do you know if the people who gave you your tattoo(s)used a new bottle of ink, or a bottle of ink that had already  been opened and
						used for someone else?';
	label piercing = 'Do you have any body piercings? If yes, how many?';
	label piercing_other_specify = 'If you got a body piercing somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label piercing_needle = 'Do you know if the people who gave you the piercing(s) used a new needle or piercing instrument, or one that had been used before?';
	label manicure_num = 'In the last 6 months, how many times have you received a manicure or pedicure at a beauty salon or through a home service?';
	label barber_num = 'In a typical month, how many times do you go to a barber or a beauty salon to get shaved?';
	label shave_other_specify = 'If you typically get shaved somewhere else (other than a barber, beauty salon, or at home), please state where';
	label shave_barber = 'Barber or beauty salon (Where do you typically shave or get shaved?)';
	label shave_home = 'Home (Where do you typically shave or get shaved?)';
	label shave_none = 'I do not shave (Where do you typically shave or get shaved?)';
	label shave_other = 'Somewhere else (Where do you typically shave or get shaved?)';
	label shave_razor = 'When you go to the barber do you know whether you are being shaved with new razors, or razors that ahve been used before?';
	label IDU_ever = 'Have you ever injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_life = 'About how many times if your life have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_6mo = 'In the last 6 months, how often have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_age_start = 'How old were you when you first injected drugs or narcotics for nonmedical reasons?';
	label IDU_needle_NEP = 'Needle exchange program (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_store = 'Drug store or other medical goods supplier (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_order = 'Mail or internet order (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_borrow = 'Borrowed from a friend or family member (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_rent = 'Purchased or rented from someone (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_found = 'A needle and/or syringe I found (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_DK = 'Do not know/remember (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_none = 'None of the above (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_refused = 'Refused (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_share1 = 'Have you ever used someone elses needle and/or syringe after they used it?';
	label IDU_share1_num = 'How many times have you ever used someone elses needle and/or syringe after they used it?';
	label birthday = 'Birth day/month';
	label birthyear = 'Birth year';
	label heprisk_toothbrush = 'Toothbrush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_razor = 'Razor blades (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_scissors = 'Scissors (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_brush = 'Shaving brush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_nail = 'Nail cutter (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_none = 'None of the above (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_DK = 'Dont know/remember (Which of the following articles have you used in common with other members of your household?)';
	label IDU_share2 = 'Have you ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_share2_num = 'How many times havey ou ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_vent = 'Vent (Which of the following drugs have you injected using a needle?)';
	label IDU_jeff = 'Jeff (Which of the following drugs have you injected using a needle?)';
	label IDU_krokodil = 'Krokodil (Which of the following drugs have you injected using a needle?)';
	label IDU_opium = 'Opium (Which of the following drugs have you injected using a needle?)';
	label IDU_med = 'Medical/synthetic drugs (Which of the following drugs have you injected using a needle?)';
	label IDU_poppy = 'Poppy straw (Which of the following drugs have you injected using a needle?)';
	label IDU_heroin = 'Heroin (Which of the following drugs have you injected using a needle?)';
	label IDU_alcohol = 'Alcohol (Which of the following drugs have you injected using a needle?)';
	label IDU_cocaine = 'Cocaine (Which of the following drugs have you injected using a needle?)';
	label IDU_crack = 'Crack (Which of the following drugs have you injected using a needle?)';
	label IDU_psych = 'Psychoactive or hallucinogenic substances (Which of the following drugs have you injected using a needle?)';
	label IDU_ecstasy = 'Ecstasy (Which of the following drugs have you injected using a needle?)';
	label IDU_otherdrug = 'Other (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_DK = 'Dont know/remember (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_RF = 'Refused to answer (Which of the following drugs have you injected using a needle?)';
	label sex_num = 'How many sexual partners have you had in your lifetime?';
	label sex_STI = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with any sexually transmitted infections?';
	label sex_HBV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HBV?';
	label sex_HCV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HCV?';
	label sex_HIV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HIV?';
	label condom = 'In your lifetime, how often have you used condoms with your sexual partners?';
	label sex_healthcare = 'Healthcare or emergency worker who comes into contact with blood (In your lifetime, have any of your sexual partners belonged to the
							following groups?)';
	label sex_military = 'Military (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_police = 'Police (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_dialysis = 'Person who regularly receives kidney dialysis, blood transfusions, or has hemophilia (In your lifetime, have any of your sexual 
						  partners belonged to the following groups?)';
	label sex_IDU = 'Injection drug user (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_CSW  = 'Commercial sex worker (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_none = 'None of the above (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_RF = 'Refused (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label tattoo_salon = 'Beauty salon or tattoo salon (Where did you get your tattoo(s)?)';
	label tattoo_home = 'Home (Where did you get your tattoo(s)?)';
	label tattoo_prison = 'Prison (Where did you get your tattoo(s)?)';
	label tattoo_other = 'Somewhere else (Where did you get your tattoo(s)?)';
	label tattoo_DK = 'Dont know/remember (Where did you get your tattoo(s)?)';
	label MSM = '(Men) Have you ever had sex with another man?';
	label MSM_condom = 'How often do you use condoms with your same sex partner(s)?';
	label int_ID_NCD = 'Interviewer ID for NCD section';
	label nurse_ID = 'Nurse ID';
	label consent_NCD = 'Would you be willing to have your height, weight and blood pressure taken today?';
	label consent_blood = 'Would you be willing to give a blood sample for hepatitis C and B testing?';
	label consent_bank = 'If there is any remaining blood left over after testing for hepatitis, can it be used to test for other diseases
                          of public health interest?';
	label phone_results = 'Contact phone number to return results';
	label address_results = 'Mailing address, or best way to reach for returning results';
	label ethnicity = 'Ethnicity';
	label BP_ID = 'Blood pressure device ID';
	label cuff = 'Cuff size used for blood pressure';
	label cuff_other_specify = 'If other cuff size was used for blood pressure, please specify';
	label BP_s1 = 'BP reading 1: Systolic (mmHg)';
	label BP_d1 = 'BP reading 1: Diastolic (mmHg)';
	label BPM1 = 'BP reading 1: Beats per minute';
	label BP_s2 = 'BP reading 2: Systolic (mmHg)';
	label BP_d2 = 'BP reading 2: Diastolic (mmHg)';
	label BPM2 = 'BP reading 2: Beats per minute';
	label BP_s3 = 'BP reading 3: Systolic (mmHg)';
	label BP_d3 = 'BP reading 3: Diastolic (mmHg)';
	label BPM3 = 'BP reading 3: Beats per minute';
	label BP_treat = 'During the past 2 weeks, have you been treated for raised blood pressure with drugs (medication) prescribed
                      by a doctor or other health worker?';
	label height_ID = 'Height device ID';
	label weight_ID = 'Weight device ID';
	label height_cm = 'Participant height in cm';
	label kyphotic = 'Is participant kyphotic (their back is hunched over due to age or spinal malformation)?';
	label weight_kg = ' Participant weight in kg';
	label pregnant = '(Women) Is the participant pregnant?';
	label ethnicity_other_specify = 'If ethnicity recorded as other, please specify';
	label religion = 'Religion';
	label waist_ID = 'Waist device ID';
	label waist_cm = 'Participant waist circumference in cm';
	label hip_cm = 'Participant hip circumference in cm';
	label blood_collected = 'Was a 10ml tiger top tube collected?';	
	label blood_time = 'Time of day blood specimen collected (24 hour clock)';
	label religion_other_specify = 'If religion recorded as other, please specify';
	label married = 'Marital status';
	label piercing_salon = 'Beauty salon or tattoo salon (Where did you get your body piercing(s)?)';
	label piercing_home = 'Home (Where did you get your body piercing(s)?)';
	label piercing_prison = 'Prison (Where did you get your body piercing(s)?)';
	label piercing_other = 'Somewhere else (Where did you get your body piercing(s)?)';
	label piercing_DK = 'Dont know/remember (Where did you get your body piercing(s)?)';
	label work = 'Which of hte following best describes your main work status over hte past year?';
	label work_healthcare = 'Health care (In your lifetime, have you ever worked in any of the following fields?)';
	label work_military = 'Military (In your lifetime, have you ever worked in any of the following fields?)';
	label work_police = 'Police (In your lifetime, have you ever worked in any of the following fields?)';
	label manicure_salon = 'Beauty salon (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_homeservice = 'Home service (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_self = 'I always perform my own manicures and pedicures (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_never = 'I have never had a manicure or pedicure (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_other = 'Somewhere else (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label house = 'Does your family rent, or own the house you live in?';
	label house_other_specify =  'If rent/own was recorded as other, please specify';
	label resident_num = 'How many people older than 18 years, including yourself, live permanently in your household?';
	label earnings_cat = 'Income category - GEL per week/month/year';
	label earnings_amount = 'In the last year, can you tell me what the average earnings of your household have been?';
	label earnings_estimate = 'If you do not know the exact amount, can you give an estimate of your households monthly earning?' ;
	label earners_num = 'How many people earn money in your household?';
	label insurance = 'Do you currently have medical insurance?';
	label insurance_type = 'What kind of health insurance do you have?';
	label medcare_pay = 'How do you pay for medical care when you need it?';
	label medcare_pay_other_specify = 'If medical care payment was recorded as other, please specify';
	label displaced = 'Have you ever been forced to move from your house because of war or civil unrest?';
	label medcare_location = 'Where do you go for medical care when you need it?';
	label medcare_location_other_specify = 'If medical care location was recorded as other, please specify';
	label flu = 'Last winter, October 2014 to April 2015, did you have a severe respiratory illness, with a sudden onset fever and cough that made you 
	            short of breath or caused you to have difficulty breathing?';
	label flu_polyclinic = 'Polyclinic (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_hospital = 'Hospital (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_medhome = 'Health care provider comes to my house (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_pharmacy = 'Pharmacy (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_villagedoc = 'Village doctor (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_none = 'I do not seek care when I am sick or injured (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_other = 'Other (If yes to severe respiratory illness, where did you go for medical care?)';
	label hh_num = 'Household number';
	label hospital_lifetime_num = 'During your lifetime, how many times have you been admitted to the hospital for any reason?';
	label dentist_cat = 'How often do you visit the dentist to have your teeth cleaned?';
	label dentist_other_specify = 'If dental location was recorded as other, please specify'; 
	label dentist_hospital = 'Hospital (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_cabinet = 'Dental cabinet (Have you ever visited the dentist or had a dental procedure in any of the following locations?');
	label dentist_home = 'Someones home (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_other = 'Other (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_DK = 'Do not know/remember (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';;
	label dental_proc_num = 'How many invasive dental procedures have you had in your lifetime?';
	label shot_num = 'How many shots have you received in the last 6 months, including immunizations and medication to numb you before a medical
                    or dental procedure?';
	label flushot = 'Did you receive a flu shot during the last (2014-2015) influenza season?';
	label flushot_loc = 'If yes to flu shot, where did you receive it?';
	label shot_admin = 'Who administered your last shot?';
	label shot_admin_other = 'If shot administration was recorded as other, please specify';
	label shot_needle = 'Before you received this last shot, did you see where the needle and/or syringe was taken from?';
	label shot_needle_other_specify = 'If shot needle/syringe source was recorded as other, please specify';
	label shot_purpose = 'Why did you get this last shot?';
	label shot_purpose_other_specify = 'If shot purpose was recorded as other, please specify';
	label shot_med = 'What medication was injected in this last shot?';
	label shot_med_other_specify = 'If shot medication was recorded as other, please specify';
	label shot_discard = 'Did they throw the syringe away after your shot?';
	label stratum_num = 'Stratum number';
	label cluster_ID = 'Cluster ID';
	label cluster_name = 'Cluster, city, or village name';
	label IV_num = 'How many IV infusions have you received in the last 6 months?';
	label dialysis_ever = 'In your lifetime, have you ever received dialysis for your kidneys?';
	label dialysis_polyclinic = 'Polyclinic (In what type of facilities have you received kidney dialysis?)';
	label dialysis_hospital = 'Hospital (In what type of facilities have you received kidney dialysis?)';
	label dialysis_home = 'Helath care provider comes to my house (In what type of facilities have you received kidney dialysis?)';
	label dialysis_pharmacy = 'Pharmacy (In what type of facilities have you received kidney dialysis?)';
	label dialysis_villagedoc = 'Village doctor (In what type of facilities have you received kidney dialysis?)';
	label dialysis_other = 'Other (In what type of facilities have you received kidney dialysis?)';
	label dialysis_current = 'Do you currently receive dialysis for your kidneys?';
	label dialysis_freq = 'How many times a week do you receive dialysis for your kidneys?';
	label blood_trans = 'Have you received any blood transfusions in your lifetime?';
	label blood_trans_num = 'How many times in your life have you received a transfusion of blood or blood products?';
	label blood_trans_relative = 'Did any of your blood transfusions come from a friend or relative?';
	label blood_donate = 'Have you ever donated blood?';
	label blood_donate_relative = 'Have you ever donated blood to a relative or friend who needed it?';
	label int_date = 'Confirm interview date';
	label blood_donate_money = 'Have you ever donated blood in exchange for money?';
	label med_invasive = 'During your lifetime, have you ever had an invasive medical procedure?';
	label surgery_ever = 'During your lifetime, have you ever had any type of surgery?';
	label surgery_num = 'During your lifetime, how many surgeries have you had?';
	label surgery_hospital = 'Hospital (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_nursing = 'Nursing home (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_polyclinic = 'Polyclinic (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_other = 'Other (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_DK = 'Do not know/remember (Have you ever had surgery in any of the following locations during your lifetime?)';
	label sti_ever = 'Have you ever been told by a doctor or other health worker that you had a sexually transmitted disease?';
	label sti_syphilis = 'Syphilis (Which sexually transmitted disease have you been diagnosed with?');
	label sti_gonorrhea = 'Gonorrhea (Which sexually transmitted disease have you been diagnosed with?');
	label sti_chlamydia = 'Chlamydia (Which sexually transmitted disease have you been diagnosed with?');
	label sti_herpes = 'Herpes (Which sexually transmitted disease have you been diagnosed with?');
	label sti_warts = 'Genital warts (Which sexually transmitted disease have you been diagnosed with?');
	label sti_other = 'Other (Which sexually transmitted disease have you been diagnosed with?');
	label HIV_test = 'Have you ever been tested for HIV, the virus that causes AIDS?';
	label HIV_result = 'What were your HIV test results?';
	label tb_ever = 'Have you ever been told by a doctor or other health worker that you have tuberculosis?';
	label int_start_time = 'Interview start time';
	label tb_year = 'Have you been told that you have tuberculosis in the past 12 months?';
	label tb_treat = 'Have you ever been treated for your tuberculosis?';
	label bp_meas = 'Have you ever had your blood pressure measured by a doctor or other health worker?';
	label hypertension_ever = 'Have you ever been told by a doctor or other health worker that you have raised blood pressure or hypertension?';
	label hypertension_year = 'Have you been told that you have raised blood pressure or hypertension in the past 12 months?';
	label sugar_meas = 'Have you ever had your blood sugar measured by a doctor or other health worker?';
	label diabetes_ever = 'Have you ever been told by a doctor or other health worker that you have high blood sugar or diabetes?';
	label diabetes_year = 'Have you been told that you have raised blood sugar or diabetes in the past 12 months?';
	label insulin_current = 'Are you currently taking insulin therapy?';
	label sugar_test_share = 'Have you ever tested your blood sugar using a needle that you shared with others?';
	label consent_int = 'Consent given for interview?';
	label insulin_syringe_share = 'Have you ever shared insulin syringes with others?';
	label chronic_asthma = 'Asthma (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_arthritis = 'Arthritis (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_cancer = 'Cancer (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_CVD = 'Cardiovascular disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_COPD = 'Chronic obstructive pulmonary disease (COPD) (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_hemophilia = 'Hemophilia or other blood disorders (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_thyroid = 'Thyroid problems (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_kidney = 'Kidney disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_lung = 'Lung disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other = 'Other (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other_specify = 'If other chronic condition was recorded, please state what type';
	label cancer_type = 'If cancer was recorded, please state what type';
	label HCV_heard = 'Have you ever heard of the hepatitis C virus, or HCV?';
	label HCV_trans_droplets = 'Droplets (Do you know how HCV is transmitted?)';
	label HCV_trans_food = 'Food (Do you know how HCV is transmitted?)';
	label HCV_trans_blood = 'Blood  (Do you know how HCV is transmitted?)';
	label HCV_trans_sex = 'Sexual contact (Do you know how HCV is transmitted?)';
	label HCV_trans_handshake = 'Handshake with an infected person (Do you know how HCV is transmitted?)';
	label HCV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HCV is transmitted?)';
	label HCV_trans_needle = 'Sharing needles or syringes (Do you know how HCV is transmitted?)';
	label HCV_trans_touch = 'Touching items in public places (Do you know how HCV is transmitted?)';
	label HCV_trans_DK = 'Do not know/remember (Do you know how HCV is transmitted?)';
	label HCV_trans_none = 'None of the above (Do you know how HCV is transmitted?)';
	label HCV_trans_other = 'Other (Do you know how HCV is transmitted?)';
	label HCV_trans_other_specify = 'If other mode of HCV transmission was recorded, please state how';
	label HCV_asymptomatic = 'Is it possible to have HCV but not have any symptoms?';
	label HCV_med = 'Are there medications available to treat HCV infections?';
	label trust_family = 'Talking with family members, friends, neighbors or colleagues (Where do you get health information that you trust?)';
	label trust_medlit = 'Special medical literature (Where do you get health information that you trust?)';
	label trust_newspaper = 'Newspapers and magazines (Where do you get health information that you trust?)';
	label trust_radio = 'Radio (Where do you get health information that you trust?)';
	label trust_tv = 'TV (Where do you get health information that you trust?)';
	label trust_internet = 'Internet (Where do you get health information that you trust?)';
	label trust_billboards = 'Billboards (Where do you get health information that you trust?)';
	label trust_brochures = 'Brochures, fliers, posters, or other printed materials (Where do you get health information that you trust?)';
	label trust_doctor = 'Doctors and other healthcare workers (Where do you get health information that you trust?)';
	label trust_pharmacist = 'Pharmacists (Where do you get health information that you trust?)';
	label trust_DK = 'Do not know/remember (Where do you get health information that you trust?)';
	label trust_none = 'None of the above (Where do you get health information that you trust?)';
	label trust_other = 'Other (Where do you get health information that you trust?)';
	label trust_other_specify = 'If other source of HCV information was recorded, please specify';
	label HBV_heard = 'Have you ever heard of the hepatitis B virus?';
	label consent_demo = 'If consent not given for interview, is participant OK giving basic demographic information?';
	label HCV_prev_vacc = 'Get a vaccination (What can you do to prevent HCV infection?)';
	label HCV_prev_condom = 'Use condoms (What can you do to prevent HCV infection?)';
	label HCV_prev_needle = 'Avoid sharing syringes or needles with other people (What can you do to prevent HCV infection?)';
	label HCV_prev_wash = 'Wash hands thoroughly (What can you do to prevent HCV infection?)';
	label HCV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to prevent HCV infection?)';
	label HCV_prev_DK = 'Do not know/remember (What can you do to prevent HCV infection?)';
	label HCV_prev_other = 'Other (What can you do to prevent HCV infection?)';
	label HCV_prev_none = 'None of the above (What can you do to prevent HCV infection?)';
	label language = 'Interview language';
	label HBV_trans_droplets = 'Droplets (Do you know how HBV is transmitted?)';
	label HBV_trans_food = 'Food (Do you know how HBV is transmitted?)';
	label HBV_trans_blood = 'Blood (Do you know how HBV is transmitted?)';
	label HBV_trans_sex = 'Sexual contact (Do you know how HBV is transmitted?)';
	label HBV_trans_handshake = 'Handshake with an infected person (Do you know how HBV is transmitted?)';
	label HBV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HBV is transmitted?)';
	label HBV_trans_needle = 'Sharing needles or syringes (Do you know how HBV is transmitted?)';
	label HBV_trans_touch = 'Touching items in public places (Do you know how HBV is transmitted?)';
	label HBV_trans_DK = 'Dont know/Remember (Do you know how HBV is transmitted?)';
	label HBV_trans_none = 'None of the above (Do you know how HBV is transmitted?)';
	label HBV_trans_other = 'Other (Do you know how HBV is transmitted?)';
	label HBV_trans_other_specify = 'If HBV transmission mode recorded as other, please state how';
	label HBV_asymptomatic = 'Is it possible to have HBV but not have any symptoms?';
	label HBV_med = 'Are there medications available to reat HBV infections?';
	label HBV_prev_vacc = 'Get a vaccination (What can you do to help prevent HBV infection?)';
	label HBV_prev_condom = 'Use condoms (What can you do to help prevent HBV infection?)';
	label HBV_prev_needle = 'Avoid sharing needles and syringes (What can you do to help prevent HBV infection?)';
	label HBV_prev_wash = 'Wash hads frequently (What can you do to help prevent HBV infection?)';
	label HBV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to help prevent HBV infection?)';
	label HBV_prev_DK = 'Dont know/Remember (What can you do to help prevent HBV infection?)';
	label HBV_prev_none = 'None of the above (What can you do to help prevent HBV infection?)';
	label HCV_ever = 'Have you ever been told by a doctor or other health worker that you have hepatitis C?';
	label HCV_year = 'What year were you told that you had hepatitis C?';
	label HCV_treated = 'Have you ever taken medications to treat your hepatitis C infection?';
	label HCV_notreat_avail = 'The medication was not available (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_eligible = 'My doctor told me I was not eligible to take the medication (Why didnt you take medication to treat 
          your hepatitis C infection?)';
	label HCV_notreat_expense = 'The medication was too expensive (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_effect = 'I heard that the medication has a lot of side effects (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_inject = 'I did not want to inject myself with a needle (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_other_specify = 'Other, specify ((Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_DK = 'Dont know/remember (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_RF = 'Refused (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_travel = 'I would ahve to travel too far to get the medication, or to see hte doctor in order to get
	      the medication (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_treat_complete = 'Did you complete your hepatitis C treatment, or did you stop before the end?';
	label HCV_cured = 'Did the treatment cure your hepatitis C infection?';
	label surname = 'Family surname';
	label HBV_ever = 'Have you been told by a doctor or other health worker that you have hepatitis B?';
	label HBV_year = 'What year were you told that you have hepatitis B?';
	label HBV_treated = 'Have you ever taken medications to treat your hepatitis B infection?';
	label HBV_vacc_ever = 'Have you ever been vaccinated against hepatitis B infection?';
	label hep_other_A = 'Hepatitis A (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';
	label hep_other_D = 'Hepatitis D (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_E = 'Hepatitis E (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_none = 'None (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_year = 'What year were you told that you had this other type of hepatitis?';
	label alc_ever = 'Have you ever consumed an alcoholic drink such as beer, wine, or spirits?';
	label alc_year = 'Have you consumed an alcoholic drink within the past 12 months?' ;
	label alc_year_freq = 'During the past 12 months, how frequently have you had at least one alcoholic drink?';
	label alc_month = 'Have you consumed an alcoholic drink within the past 30 days?';
	label disposition = 'Interview disposition: Did you complete the entire questionnaire?';
	label disposition_other_specify = 'If interview disposition recorded as other, please specify';

	run;

*/Create formats for renamed variables and drop old variables;;

data HCV8.HCVformat; set HCV8.HCVlabel(drop=
Q0_BARCODE
Q1_I1
Q2A_I2
Q3A_I3
Q3B_I3
Q4_I4
Q5_I5
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
CONSENT_Q9_I9
CONSENT_Q10_I10
Q11_D1
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20_D10
CONSENT_Q20A_D10_OTHER
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F
CONSENT_CONSENT2_Q30_M2
CONSNTCNSENT2Q29CM1C_Q29C_G
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q32_M4A
CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E
CONSENT_CONSENT2_Q55_STI1
CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H
CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D
CONSENT_CONSENT2_Q121_R11
CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H
CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9
CONSENT_CONSENT2_PROMPT1
CONSENT_CONSENT2_PROMPT2
CONSENT_CONSENT2_PROMPT3
CONSENT_CONSENT2_PROMPT4
CONSENT_CONSENT2_PROMPT5
CONSENT_CONSENT2_PROMPTB
CONSENT_CONSENT2_PROMPTC
CONSENT_CONSENT2_PROMPTD
CONSENT_CONSENT2_PROMPTE
CONSENT_CONSENT2_PROMPTF
CONSENT_CONSENT2_PROMPTG
CONSENT_CONSENT2_PROMPTH
CONSENT_CONSENT2_PROMPTI
CONSENT_CONSENT2_PROMPTJ
CONSENT_CONSENT2_PROMPTK
CONSENT_CONSENT2_PROMPTL
CONSENT_CONSENT2_PROMPTM
CONSENT_CONSENT2_PROMPTN
CONSENT_CONSENT2_PROMPTO
CONSENT_CONSENT2_PROMPTP
CONSENT_PROMPTA
PROMPT6
PROMPTQ
PROMPTR
_LAST_UPDATE_URI_USER
_MODEL_VERSION
_UI_VERSION
_ORDINAL_NUMBER
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22
Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31
)
; 

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

*/Rename variables and indicate which are numeric;;
data HCV8.phone_recode;
set HCV8.phone2;

flu_polyclinic=input(Consent_Consent2_Q29c_M1c_Q29c_,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_A*/ 
flu_hospital=input(var50,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_B*/ 
flu_medhome=input(var51,8.0);     /*CONSENT_CONSENT2_Q29C_M1C_Q29C_C*/ 
flu_pharmacy=input(var52,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_D*/ 
flu_villagedoc=input(var53,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_E*/ 
flu_none=input(var54,8.0);        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_F*/ 

flu_other=var55;        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_G*/ 
/*var variables*/
     
*flu_polyclinic=input(var91,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_A*/ 
*flu_hospital=input(var74,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_B*/ 
*flu_medhome=input(var73,8.0);     /*CONSENT_CONSENT2_Q29C_M1C_Q29C_C*/ 
*flu_pharmacy=input(var71,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_D*/ 
*flu_villagedoc=input(var68,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_E*/ 
*flu_none=input(var65,8.0);        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_F*/ 

/*flu_other=CONSENT_CONSENT2_Q29C_M1C_Q29C_;*/

/*sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);*/
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);

earnings_cat=input(CONSENT_Q22_D12,8.0);

/*flu_medhome = CONSENT_CONSENT2_Q29C_M1C_Q29C_;*/

dentist_hospital=input(CONSENT_CONSENT2_Q32_M4_Q32A,8.0);
dentist_cabinet=input(CONSENT_CONSENT2_Q32_M4_Q32B,8.0);
dentist_home=input(CONSENT_CONSENT2_Q32_M4_Q32C,8.0);
dentist_other=input(CONSENT_CONSENT2_Q32_M4_Q32D,8.0);
dentist_DK=input(CONSENT_CONSENT2_Q32_M4_Q32E,8.0);

dialysis_polyclinic=input(CONSENT_CONSENT2_Q42_M15_Q42A,8.0);
dialysis_hospital=input(CONSENT_CONSENT2_Q42_M15_Q42B,8.0);
dialysis_home=input(CONSENT_CONSENT2_Q42_M15_Q42C,8.0);
dialysis_pharmacy=input(CONSENT_CONSENT2_Q42_M15_Q42D,8.0);
dialysis_villagedoc=input(CONSENT_CONSENT2_Q42_M15_Q42E,8.0);
dialysis_other=input(CONSENT_CONSENT2_Q42_M15_Q42G,8.0);

surgery_hospital=input(CONSENT_CONSENT2_Q54_S4_Q54A,8.0);
surgery_nursing=input(CONSENT_CONSENT2_Q54_S4_Q54B,8.0);
surgery_polyclinic=input(CONSENT_CONSENT2_Q54_S4_Q54C,8.0);
****;surgery_other=CONSENT_CONSENT2_Q54_S4_Q54D;
surgery_DK=input(CONSENT_CONSENT2_Q54_S4_Q54E,8.0);

sti_syphilis=input(CONSENT_CONSENT2_Q56_STI2_Q56A,8.0);
sti_gonorrhea=input(CONSENT_CONSENT2_Q56_STI2_Q56B,8.0);
sti_chlamydia=input(CONSENT_CONSENT2_Q56_STI2_Q56C,8.0);
sti_herpes=input(CONSENT_CONSENT2_Q56_STI2_Q56D,8.0);
sti_warts=input(CONSENT_CONSENT2_Q56_STI2_Q56E,8.0);
***;sti_other=CONSENT_CONSENT2_Q56_STI2_Q56F;

chronic_asthma=input(CONSENT_CONSENT2_Q71_CD1_Q71A,8.0);
chronic_arthritis=input(CONSENT_CONSENT2_Q71_CD1_Q71B,8.0);
chronic_cancer=input(CONSENT_CONSENT2_Q71_CD1_Q71C,8.0);
chronic_CVD=input(CONSENT_CONSENT2_Q71_CD1_Q71D,8.0);
chronic_COPD=input(CONSENT_CONSENT2_Q71_CD1_Q71E,8.0);
chronic_hemophilia=input(CONSENT_CONSENT2_Q71_CD1_Q71F,8.0);
chronic_thyroid=input(CONSENT_CONSENT2_Q71_CD1_Q71G,8.0);
********;chronic_kidney=CONSENT_CONSENT2_Q71_CD1_Q71H;
chronic_lung=input(CONSENT_CONSENT2_Q71_CD1_Q71I,8.0);
chronic_other=input(CONSENT_CONSENT2_Q71_CD1_Q71J,8.0);
chronic_DK=input(CONSENT_CONSENT2_Q71_CD1_Q71K,8.0);

HCV_trans_droplets=input(CONSENT_CONSENT2_Q74_H2_Q74A,8.0);
HCV_trans_food=input(CONSENT_CONSENT2_Q74_H2_Q74B,8.0);
HCV_trans_blood=input(CONSENT_CONSENT2_Q74_H2_Q74C,8.0);
HCV_trans_sex=input(CONSENT_CONSENT2_Q74_H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENT_CONSENT2_Q74_H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENT_CONSENT2_Q74_H2_Q74F,8.0);
HCV_trans_needle=input(CONSENT_CONSENT2_Q74_H2_Q74G,8.0);
HCV_trans_touch=input(CONSENT_CONSENT2_Q74_H2_Q74H,8.0);
HCV_trans_DK=input(CONSENT_CONSENT2_Q74_H2_Q74I,8.0);
HCV_trans_none=input(CONSENT_CONSENT2_Q74_H2_Q74J,8.0);
HCV_trans_other=input(CONSENT_CONSENT2_Q74_H2_Q74K,8.0);

HCV_prev_vacc=input(CONSENT_CONSENT2_Q77_H5_Q77A,8.0);
HCV_prev_condom=input(CONSENT_CONSENT2_Q77_H5_Q77B,8.0);
HCV_prev_needle=input(CONSENT_CONSENT2_Q77_H5_Q77C,8.0);
HCV_prev_wash=input(CONSENT_CONSENT2_Q77_H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENT_CONSENT2_Q77_H5_Q77E,8.0);
HCV_prev_DK=input(CONSENT_CONSENT2_Q77_H5_Q77F,8.0);
****;HCV_prev_other=CONSENT_CONSENT2_Q77_H5_Q77G;
HCV_prev_none=input(CONSENT_CONSENT2_Q77_H5_Q77H,8.0);
trust_family=input(CONSENT_CONSENT2_Q78_H6_Q78A,8.0);
trust_medlit=input(CONSENT_CONSENT2_Q78_H6_Q78B,8.0);
trust_newspaper=input(CONSENT_CONSENT2_Q78_H6_Q78C,8.0);
*******;trust_radio=CONSENT_CONSENT2_Q78_H6_Q78D;
trust_tv=input(CONSENT_CONSENT2_Q78_H6_Q78E,8.0);
trust_internet=input(CONSENT_CONSENT2_Q78_H6_Q78F,8.0);
trust_billboards=input(CONSENT_CONSENT2_Q78_H6_Q78G,8.0);
trust_brochures=input(CONSENT_CONSENT2_Q78_H6_Q78H,8.0);
trust_doctor=input(CONSENT_CONSENT2_Q78_H6_Q78I,8.0);
trust_pharmacist=input(CONSENT_CONSENT2_Q78_H6_Q78J,8.0);
trust_DK=input(CONSENT_CONSENT2_Q78_H6_Q78K,8.0);
trust_none=input(CONSENT_CONSENT2_Q78_H6_Q78L,8.0);
trust_other=input(CONSENT_CONSENT2_Q78_H6_Q78M,8.0);

HBV_trans_droplets=input(CONSENT_CONSENT2_Q80_H8_Q80A,8.0);
HBV_trans_food=input(CONSENT_CONSENT2_Q80_H8_Q80B,8.0);
HBV_trans_blood=input(CONSENT_CONSENT2_Q80_H8_Q80C,8.0);
HBV_trans_sex=input(CONSENT_CONSENT2_Q80_H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENT_CONSENT2_Q80_H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENT_CONSENT2_Q80_H8_Q80F,8.0);
HBV_trans_needle=input(CONSENT_CONSENT2_Q80_H8_Q80G,8.0);
HBV_trans_touch=input(CONSENT_CONSENT2_Q80_H8_Q80H,8.0);
HBV_trans_DK=input(CONSENT_CONSENT2_Q80_H8_Q80I,8.0);
HBV_trans_none=input(CONSENT_CONSENT2_Q80_H8_Q80J,8.0);
HBV_trans_other=input(CONSENT_CONSENT2_Q80_H8_Q80K,8.0);

HBV_prev_vacc=input(CONSENT_CONSENT2_Q83_H11_Q83A,8.0);
HBV_prev_condom=input(CONSENT_CONSENT2_Q83_H11_Q83B,8.0);
HBV_prev_needle=input(CONSENT_CONSENT2_Q83_H11_Q83C,8.0);
HBV_prev_wash=input(CONSENT_CONSENT2_Q83_H11_Q83D,8.0);
HBV_prev_sterile=input(CONSENT_CONSENT2_Q83_H11_Q83E,8.0);
HBV_prev_DK=input(CONSENT_CONSENT2_Q83_H11_Q83F,8.0);
HBV_prev_none=input(CONSENT_CONSENT2_Q83_H11_Q83G,8.0);

HCV_notreat_avail=input(CONSENT_CONSENT2_Q87_H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSENT_CONSENT2_Q87_H15_Q87B,8.0);
HCV_notreat_expense=input(CONSENT_CONSENT2_Q87_H15_Q87C,8.0);
HCV_notreat_effect=input(CONSENT_CONSENT2_Q87_H15_Q87D,8.0);
HCV_notreat_inject=input(CONSENT_CONSENT2_Q87_H15_Q87E,8.0);
********;HCV_notreat_other_specify=CONSENT_CONSENT2_Q87_H15_Q87F;
HCV_notreat_DK=input(CONSENT_CONSENT2_Q87_H15_Q87G,8.0);
HCV_notreat_RF=input(CONSENT_CONSENT2_Q87_H15_Q87H,8.0);
HCV_notreat_travel=input(CONSENT_CONSENT2_Q87_H15_Q87I,8.0);

hep_other_A=input(CONSENT_CONSENT2_Q94_H22_Q94A,8.0);
hep_other_D=input(CONSENT_CONSENT2_Q94_H22_Q94B,8.0);
hep_other_E=input(CONSENT_CONSENT2_Q94_H22_Q94C,8.0);
hep_other_none=input(CONSENT_CONSENT2_Q94_H22_Q94D,8.0);
hep_other_DK=input(CONSENT_CONSENT2_Q94_H22_Q94E,8.0);

cig_num =input(CONSENT_CONSENT2_Q110_T4_Q110A, 8.0);
********;cig_day_week= CONSENT_CONSENT2_Q110_T4_Q110B;
hand_cig_num= input(CONSENT_CONSENT2_Q110_T4_Q110C, 8.0);
hand_cig_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110D, 8.0);
pipe_num= input(CONSENT_CONSENT2_Q110_T4_Q110E, 8.0);
pipe_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110F, 8.0);
cigar_num= input(CONSENT_CONSENT2_Q110_T4_Q110G, 8.0);
cigar_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110H, 8.0);
smoke_other= CONSENT_CONSENT2_Q110_T4_Q110I;
smoke_other_num= CONSENT_CONSENT2_Q110_T4_Q110J;
smoke_other_day_week= CONSENT_CONSENT2_Q110_T4_Q110K;

piercing_salon=input(CONSENT_CONSENT2_Q117_R7_Q117A,8.0);
********;piercing_home=CONSENT_CONSENT2_Q117_R7_Q117B;
piercing_prison=input(CONSENT_CONSENT2_Q117_R7_Q117C,8.0);
piercing_other=input(CONSENT_CONSENT2_Q117_R7_Q117D,8.0);
piercing_DK=input(CONSENT_CONSENT2_Q117_R7_Q117E,8.0);

manicure_salon=CONSENT_CONSENT2_Q119_R9_Q119A_;
manicure_homeservice=CONSENT_CONSENT2_Q119_R9_Q119B_;
manicure_self=CONSENT_CONSENT2_Q119_R9_Q119C_;
manicure_never=CONSENT_CONSENT2_Q119_R9_Q119D_;
manicure_other=CONSENT_CONSENT2_Q119_R9_Q119E_;
barber_num=CONSENT_CONSENT2_Q120A_R10A;

shave_barber=input(CONSENT_CONSENT2_Q120_R10_Q120A  ,8.0);
shave_home=input(CONSENT_CONSENT2_Q120_R10_Q120B  ,8.0);
shave_none=input(CONSENT_CONSENT2_Q120_R10_Q120C  ,8.0);
shave_other=input(CONSENT_CONSENT2_Q120_R10_Q120D  ,8.0);

heprisk_toothbrush=input(CONSENT_CONSENT2_Q122_R12_Q122A,8.0);
heprisk_razor=input(CONSENT_CONSENT2_Q122_R12_Q122B,8.0);
heprisk_scissors=input(CONSENT_CONSENT2_Q122_R12_Q122C,8.0);
heprisk_brush=input(CONSENT_CONSENT2_Q122_R12_Q122D,8.0);
heprisk_nail=input(CONSENT_CONSENT2_Q122_R12_Q122E,8.0);
heprisk_none=input(CONSENT_CONSENT2_Q122_R12_Q122F,8.0);
heprisk_DK=input(CONSENT_CONSENT2_Q122_R12_Q122G ,8.0);

IDU_needle_NEP=input(CONSENT_CONSENT2_Q127_I5_Q127A,8.0);
IDU_needle_store=input(CONSENT_CONSENT2_Q127_I5_Q127B,8.0);
IDU_needle_order=input(CONSENT_CONSENT2_Q127_I5_Q127C,8.0);
IDU_needle_borrow=input(CONSENT_CONSENT2_Q127_I5_Q127D,8.0);
IDU_needle_rent=input(CONSENT_CONSENT2_Q127_I5_Q127E,8.0);
IDU_needle_found=input(CONSENT_CONSENT2_Q127_I5_Q127F,8.0);
IDU_needle_DK=input(CONSENT_CONSENT2_Q127_I5_Q127G,8.0);
IDU_needle_none=input(CONSENT_CONSENT2_Q127_I5_Q127H,8.0);
IDU_needle_refused=input(CONSENT_CONSENT2_Q127_I5_Q127I,8.0);

IDU_vent=input(CONSENT_CONSENT2_Q132_I10_Q132A,8.0);
IDU_jeff=input(CONSENT_CONSENT2_Q132_I10_Q132B,8.0);
IDU_krokodil=input(CONSENT_CONSENT2_Q132_I10_Q132C,8.0);
IDU_opium=input(CONSENT_CONSENT2_Q132_I10_Q132D,8.0);
IDU_med=input(CONSENT_CONSENT2_Q132_I10_Q132E,8.0);
IDU_poppy=input(CONSENT_CONSENT2_Q132_I10_Q132F,8.0);
IDU_heroin=input(CONSENT_CONSENT2_Q132_I10_Q132G,8.0);
IDU_alcohol=input(CONSENT_CONSENT2_Q132_I10_Q132H,8.0);
IDU_cocaine=input(CONSENT_CONSENT2_Q132_I10_Q132I,8.0);
IDU_crack=input(CONSENT_CONSENT2_Q132_I10_Q132J,8.0);
IDU_psych=input(CONSENT_CONSENT2_Q132_I10_Q132K,8.0);
IDU_ecstasy=input(CONSENT_CONSENT2_Q132_I10_Q132L,8.0);
*******;IDU_otherdrug=CONSENT_CONSENT2_Q132_I10_Q132M;
IDU_drug_DK=input(CONSENT_CONSENT2_Q132_I10_Q132N,8.0);
IDU_drug_RF=input(CONSENT_CONSENT2_Q132_I10_Q132O,8.0);

sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);
sex_military = input(CONSENT_CONSENT2_Q139_SP7_Q139B, 8.0);
sex_police = input(CONSENT_CONSENT2_Q139_SP7_Q139C, 8.0);
sex_dialysis = input(CONSENT_CONSENT2_Q139_SP7_Q139D, 8.0);
sex_IDU = input(CONSENT_CONSENT2_Q139_SP7_Q139E, 8.0);
sex_CSW = input(CONSENT_CONSENT2_Q139_SP7_Q139F, 8.0);
sex_none = input(CONSENT_CONSENT2_Q139_SP7_Q139G, 8.0);
sex_RF = input(CONSENT_CONSENT2_Q139_SP7_Q139H, 8.0);
tattoo_salon=input(CONSENT_CONSENT2_Q113_R3_Q113A,8.0);
tattoo_home=input(CONSENT_CONSENT2_Q113_R3_Q113B,8.0);
tattoo_prison=input(CONSENT_CONSENT2_Q113_R3_Q113C,8.0);
tattoo_other=input(CONSENT_CONSENT2_Q113_R3_Q113D,8.0);
tattoo_DK=input(CONSENT_CONSENT2_Q113_R3_Q113E,8.0);

*matching variables;

*;barcode=Q0_BARCODE;
int_id_quest=Q1_I1;
hh_num=input(Q2A_I2,8.0);
stratum_num=Q3A_I3;
*;cluster_ID=Q3B_I3;
cluster_name=Q4_I4;
int_date=Q5_I5;
int_start_time=Q6_I6;
consent_int=input(Q7_I7,8.0);
consent_demo=input(Q7A_CONSENT,8.0);
language=input(Q8_I8,8.0);
surname=CONSENT_Q9_I9;
f_name=CONSENT_Q10_I10;
gender=input(Q11_D1,8.0);
birthday=CONSENT_Q12A_D2;
birthyear=input(CONSENT_Q12B_D2,8.0);
age=input(CONSENT_Q13_D3,8.0);
education=input(CONSENT_Q14_D4,8.0);
ethnicity=input(CONSENT_Q15_D5,8.0);
ethnicity_other_specify=CONSENT_Q15A_D5_OTHER;
religion=input(CONSENT_Q16_D6,8.0);
religion_other_specify=CONSENT_Q16A_D6_OTHER;
married=input(CONSENT_Q17_D7,8.0);
work=input(CONSENT_Q18_D8,8.0);
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);
house=input(CONSENT_Q20_D10,8.0);
house_other_specify=CONSENT_Q20A_D10_OTHER;
resident_num=input(CONSENT_Q21_D11,8.0);
earnings_cat=input(CONSENT_Q22_D12,8.0);
earnings_amount=input(CONSENT_Q22A_D12,8.0);
earnings_estimate=input(CONSENT_Q23_D13,8.0);
earners_num=input(CONSENT_Q24_D14,8.0);
insurance=input(CONSENT_Q25_D15,8.0);
insurance_type=input(CONSENT_Q26_D16,8.0);
medcare_pay=input(CONSENT_Q27_D17,8.0);
medcare_pay_other_specify=CONSENT_Q27A_D17_OTHER;
displaced=input(CONSENT_Q28_D18,8.0);
medcare_location=input(CONSENT_CONSENT2_Q29_M1,8.0);
medcare_location_other_specify=CONSENT_CONSENT2_Q29A_M1_OTHER;
flu=input(CONSENT_CONSENT2_Q29B_M1B,8.0);
/*flu_polyclinic=input(CONSNTCNSENT2Q29CM1C_Q29C_A,8.0);
flu_hospital=input(CONSNTCNSENT2Q29CM1C_Q29C_B,8.0);
flu_medhome=input(CONSNTCNSENT2Q29CM1C_Q29C_C,8.0);
flu_pharmacy=input(CONSNTCNSENT2Q29CM1C_Q29C_D,8.0);
flu_villagedoc=input(CONSNTCNSENT2Q29CM1C_Q29C_E,8.0);
flu_none=input(CONSNTCNSENT2Q29CM1C_Q29C_F,8.0);*/
hospital_lifetime_num=input(CONSENT_CONSENT2_Q30_M2,8.0);
/*flu_other=CONSNTCNSENT2Q29CM1C_Q29C_G;*/
dentist_cat=input(CONSENT_CONSENT2_Q31_M3,8.0);
dentist_other_specify=CONSENT_CONSENT2_Q32_M4A;
/*dentist_hospital=input(CONSENTCONSENT2Q32M4_Q32A,8.0);
dentist_cabinet=input(CONSENTCONSENT2Q32M4_Q32B,8.0);
dentist_home=input(CONSENTCONSENT2Q32M4_Q32C,8.0);
dentist_other=input(CONSENTCONSENT2Q32M4_Q32D,8.0);
dentist_DK=input(CONSENTCONSENT2Q32M4_Q32E,8.0);*/
dental_proc_num=input(CONSENT_CONSENT2_Q33_M5,8.0);
shot_num=input(CONSENT_CONSENT2_Q34_M6,8.0);
flushot=input(CONSENT_CONSENT2_Q34A_M6_1,8.0);
flushot_loc=CONSENT_CONSENT2_Q34B_M6_2;
shot_admin=input(CONSENT_CONSENT2_Q35_M7,8.0);
shot_admin_other=CONSENT_CONSENT2_Q35A_M7_OTHER;
shot_needle=input(CONSENT_CONSENT2_Q36_M8,8.0);
shot_needle_other_specify=CONSENT_CONSENT2_Q36A_M8_OTHER;
shot_purpose=input(CONSENT_CONSENT2_Q37_M9,8.0);
shot_purpose_other_specify=CONSENT_CONSENT2_Q37A_M9_OTHER;
shot_med=input(CONSENT_CONSENT2_Q38_M10,8.0);
shot_med_other_specify=CONSENT_CONSENT2_Q38A_M10_OTHER;
shot_discard=input(CONSENT_CONSENT2_Q39_M11,8.0);
IV_num=input(CONSENT_CONSENT2_Q40_M12,8.0);
dialysis_ever=input(CONSENT_CONSENT2_Q41_M14,8.0);
/*dialysis_polyclinic=input(CONSNTCNSENT2Q42M15_Q42A,8.0);
dialysis_hospital=input(CONSNTCNSENT2Q42M15_Q42B,8.0);
dialysis_home=input(CONSNTCNSENT2Q42M15_Q42C,8.0);
dialysis_pharmacy=input(CONSNTCNSENT2Q42M15_Q42D,8.0);
dialysis_villagedoc=input(CONSNTCNSENT2Q42M15_Q42E,8.0);
dialysis_other=input(CONSNTCNSENT2Q42M15_Q42G,8.0);*/
dialysis_current=input(CONSENT_CONSENT2_Q43_M16,8.0);
dialysis_freq=input(CONSENT_CONSENT2_Q44_M17,8.0);
blood_trans=input(CONSENT_CONSENT2_Q45_M18,8.0);
blood_trans_num=input(CONSENT_CONSENT2_Q46_M19,8.0);
blood_trans_relative=input(CONSENT_CONSENT2_Q47_M20,8.0);
blood_donate=input(CONSENT_CONSENT2_Q48_M21,8.0);
blood_donate_relative=input(CONSENT_CONSENT2_Q49_M22,8.0);
blood_donate_money=input(CONSENT_CONSENT2_Q50_M23,8.0);
med_invasive=input(CONSENT_CONSENT2_Q51_S1,8.0);
surgery_ever=input(CONSENT_CONSENT2_Q52_S2,8.0);
surgery_num=input(CONSENT_CONSENT2_Q53_S3,8.0);
/*surgery_hospital=input(CONSENTCONSENT2Q54S4_Q54A,8.0);
surgery_nursing=input(CONSENTCONSENT2Q54S4_Q54B,8.0);
surgery_polyclinic=input(CONSENTCONSENT2Q54S4_Q54C,8.0);
surgery_other=CONSENTCONSENT2Q54S4_Q54D;
surgery_DK=input(CONSENTCONSENT2Q54S4_Q54E,8.0);*/
sti_ever=input(CONSENT_CONSENT2_Q55_STI1,8.0);
/*sti_syphilis=input(CONSNTCONSNT2Q56STI2_Q56A,8.0);
sti_gonorrhea=input(CONSNTCONSNT2Q56STI2_Q56B,8.0);
sti_chlamydia=input(CONSNTCONSNT2Q56STI2_Q56C,8.0);
sti_herpes=input(CONSNTCONSNT2Q56STI2_Q56D,8.0);
sti_warts=input(CONSNTCONSNT2Q56STI2_Q56E,8.0);
sti_other=CONSNTCONSNT2Q56STI2_Q56F;*/
HIV_test=input(CONSENT_CONSENT2_Q57_STI3,8.0);
HIV_result=input(CONSENT_CONSENT2_Q58_STI4,8.0);
tb_ever=input(CONSENT_CONSENT2_Q59_TB1,8.0);
tb_year=input(CONSENT_CONSENT2_Q60_TB2,8.0);
tb_treat=input(CONSENT_CONSENT2_Q61_TB3,8.0);
bp_meas=input(CONSENT_CONSENT2_Q62_HY1,8.0);
hypertension_ever=input(CONSENT_CONSENT2_Q63_HY2,8.0);
hypertension_year=input(CONSENT_CONSENT2_Q64_HY3,8.0);
sugar_meas=input(CONSENT_CONSENT2_Q65_D1,8.0);
diabetes_ever=input(CONSENT_CONSENT2_Q66_D2,8.0);
diabetes_year=input(CONSENT_CONSENT2_Q67_D3,8.0);
insulin_current=input(CONSENT_CONSENT2_Q68_D4,8.0);
sugar_test_share=input(CONSENT_CONSENT2_Q69_D5,8.0);
insulin_syringe_share=input(CONSENT_CONSENT2_Q70_D6,8.0);
/*chronic_asthma=input(CONSNTCNSENT2Q71CD1_Q71A,8.0);
chronic_arthritis=input(CONSNTCNSENT2Q71CD1_Q71B,8.0);
chronic_cancer=input(CONSNTCNSENT2Q71CD1_Q71C,8.0);
chronic_CVD=input(CONSNTCNSENT2Q71CD1_Q71D,8.0);
chronic_COPD=input(CONSNTCNSENT2Q71CD1_Q71E,8.0);
chronic_hemophilia=input(CONSNTCNSENT2Q71CD1_Q71F,8.0);
chronic_thyroid=input(CONSNTCNSENT2Q71CD1_Q71G,8.0);
chronic_kidney=input(CONSNTCNSENT2Q71CD1_Q71H,8.0);
chronic_lung=input(CONSNTCNSENT2Q71CD1_Q71I,8.0);
chronic_other=input(CONSNTCNSENT2Q71CD1_Q71J,8.0);
chronic_DK=input(CONSNTCNSENT2Q71CD1_Q71K,8.0);*/
chronic_other_specify=CONSENT_CONSENT2_Q71L_CD1_OTHER;
cancer_type=CONSENT_CONSENT2_Q72_CD2;
HCV_heard=input(CONSENT_CONSENT2_Q73_H1,8.0);
/*HCV_trans_droplets=input(CONSENTCONSENT2Q74H2_Q74A,8.0);
HCV_trans_food=input(CONSENTCONSENT2Q74H2_Q74B,8.0);
HCV_trans_blood=input(CONSENTCONSENT2Q74H2_Q74C,8.0);
HCV_trans_sex=input(CONSENTCONSENT2Q74H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENTCONSENT2Q74H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENTCONSENT2Q74H2_Q74F,8.0);
HCV_trans_needle=input(CONSENTCONSENT2Q74H2_Q74G,8.0);
HCV_trans_touch=input(CONSENTCONSENT2Q74H2_Q74H,8.0);
HCV_trans_DK=input(CONSENTCONSENT2Q74H2_Q74I,8.0);
HCV_trans_none=input(CONSENTCONSENT2Q74H2_Q74J,8.0);
HCV_trans_other=input(CONSENTCONSENT2Q74H2_Q74K,8.0);*/
HCV_trans_other_specify=CONSENT_CONSENT2_Q74L_H2A;
HCV_asymptomatic=input(CONSENT_CONSENT2_Q75_H3,8.0);
HCV_med=input(CONSENT_CONSENT2_Q76_H4,8.0);
/*HCV_prev_vacc=input(CONSENTCONSENT2Q7H5_Q77A,8.0);
HCV_prev_condom=input(CONSENTCONSENT2Q7H5_Q77B,8.0);
HCV_prev_needle=input(CONSENTCONSENT2Q7H5_Q77C,8.0);
HCV_prev_wash=input(CONSENTCONSENT2Q7H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENTCONSENT2Q7H5_Q77E,8.0);
HCV_prev_DK=input(CONSENTCONSENT2Q7H5_Q77F,8.0);
HCV_prev_other=CONSENTCONSENT2Q7H5_Q77G;
HCV_prev_none=input(CONSENTCONSENT2Q7H5_Q77H,8.0);*/
/*trust_family=input(CONSENTCONSENT2Q78H6_Q78A,8.0);
trust_medlit=input(CONSENTCONSENT2Q78H6_Q78B,8.0);
trust_newspaper=input(CONSENTCONSENT2Q78H6_Q78C,8.0);
trust_radio=input(CONSENTCONSENT2Q78H6_Q78D,8.0);
trust_tv=input(CONSENTCONSENT2Q78H6_Q78E,8.0);
trust_internet=input(CONSENTCONSENT2Q78H6_Q78F,8.0);
trust_billboards=input(CONSENTCONSENT2Q78H6_Q78G,8.0);
trust_brochures=input(CONSENTCONSENT2Q78H6_Q78H,8.0);
trust_doctor=input(CONSENTCONSENT2Q78H6_Q78I,8.0);
trust_pharmacist=input(CONSENTCONSENT2Q78H6_Q78J,8.0);
trust_DK=input(CONSENTCONSENT2Q78H6_Q78K,8.0);
trust_none=input(CONSENTCONSENT2Q78H6_Q78L,8.0);
trust_other=input(CONSENTCONSENT2Q78H6_Q78M,8.0);*/
trust_other_specify=CONSENT_CONSENT2_Q78N_H6A;
HBV_heard=input(CONSENT_CONSENT2_Q79_H7,8.0);
/*HBV_trans_droplets=input(CONSENTCONSENT2Q80H8_Q80A,8.0);
HBV_trans_food=input(CONSENTCONSENT2Q80H8_Q80B,8.0);
HBV_trans_blood=input(CONSENTCONSENT2Q80H8_Q80C,8.0);
HBV_trans_sex=input(CONSENTCONSENT2Q80H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENTCONSENT2Q80H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENTCONSENT2Q80H8_Q80F,8.0);
HBV_trans_needle=input(CONSENTCONSENT2Q80H8_Q80G,8.0);
HBV_trans_touch=input(CONSENTCONSENT2Q80H8_Q80H,8.0);
HBV_trans_DK=input(CONSENTCONSENT2Q80H8_Q80I,8.0);
HBV_trans_none=input(CONSENTCONSENT2Q80H8_Q80J,8.0);
HBV_trans_other=input(CONSENTCONSENT2Q80H8_Q80K,8.0);*/
HBV_trans_other_specify=CONSENT_CONSENT2_Q80L_H8A;
HBV_asymptomatic=input(CONSENT_CONSENT2_Q81_H9,8.0);
HBV_med=input(CONSENT_CONSENT2_Q82_H10,8.0);
/*HBV_prev_vacc=input(CONSENTCONSENT2Q83H1_Q83A,8.0);
HBV_prev_condom=input(CONSENTCONSENT2Q83H1_Q83B,8.0);
HBV_prev_needle=input(CONSENTCONSENT2Q83H1_Q83C,8.0);
HBV_prev_wash=input(CONSENTCONSENT2Q83H1_Q83D,8.0);
HBV_prev_sterile=input(CONSENTCONSENT2Q83H1_Q83E,8.0);
HBV_prev_DK=input(CONSENTCONSENT2Q83H1_Q83F,8.0);
HBV_prev_none=input(CONSENTCONSENT2Q83H1_Q83G,8.0);*/
HCV_ever=input(CONSENT_CONSENT2_Q84_H12,8.0);
HCV_year=input(CONSENT_CONSENT2_Q85_H13,8.0);
HCV_treated=input(CONSENT_CONSENT2_Q86_H14,8.0);
/*HCV_notreat_avail=input(CONSNTCNSENT2Q87H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSNTCNSENT2Q87H15_Q87B,8.0);
HCV_notreat_expense=input(CONSNTCNSENT2Q87H15_Q87C,8.0);
HCV_notreat_effect=input(CONSNTCNSENT2Q87H15_Q87D,8.0);
HCV_notreat_inject=input(CONSNTCNSENT2Q87H15_Q87E,8.0);
HCV_notreat_other_specify=CONSNTCNSENT2Q87H15_Q87F;
HCV_notreat_DK=input(CONSNTCNSENT2Q87H15_Q87G,8.0);
HCV_notreat_RF=input(CONSNTCNSENT2Q87H15_Q87H,8.0);
HCV_notreat_travel=input(CONSNTCNSENT2Q87H15_Q87I,8.0);*/
HCV_treat_complete=input(CONSENT_CONSENT2_Q88_H16,8.0);
HCV_cured=input(CONSENT_CONSENT2_Q89_H17,8.0);
HBV_ever=input(CONSENT_CONSENT2_Q90_H18,8.0);
HBV_year=input(CONSENT_CONSENT2_Q91_H19,8.0);
HBV_treated=input(CONSENT_CONSENT2_Q92_H20,8.0);
HBV_vacc_ever=input(CONSENT_CONSENT2_Q93_H21,8.0);
/*hep_other_A=input(CONSENTCONSENT2Q94H2_Q94A,8.0);
hep_other_D=input(CONSENTCONSENT2Q94H2_Q94B,8.0);
hep_other_E=input(CONSENTCONSENT2Q94H2_Q94C,8.0);
hep_other_none=input(CONSENTCONSENT2Q94H2_Q94D,8.0);
hep_other_DK=input(CONSENTCONSENT2Q94H2_Q94E,8.0);*/
hep_other_year=input(CONSENT_CONSENT2_Q95_H23,8.0);
alc_ever=input(CONSENT_CONSENT2_Q96_A1A,8.0);
alc_year=input(CONSENT_CONSENT2_Q97_A1B,8.0);
alc_year_freq=input(CONSENT_CONSENT2_Q98_A2,8.0);
alc_month=input(CONSENT_CONSENT2_Q99_A3,8.0);
alc_occasions=input(CONSENT_CONSENT2_Q100_A4,8.0);
alc_drinks=input(CONSENT_CONSENT2_Q101_A5,8.0);
alc_max=input(CONSENT_CONSENT2_Q102_A6,8.0);
alc_male=input(CONSENT_CONSENT2_Q103A_A7_MALES,8.0);
alc_female=input(CONSENT_CONSENT2_Q103B_A7_FEMAL,8.0);
walk_bike_lastweek=input(CONSENT_CONSENT2_Q104_PA1,8.0);
walk_bike_typicalweek=input(CONSENT_CONSENT2_Q105_PA2,8.0);
walk_bike_typicalday=CONSENT_CONSENT2_Q106_PA3;
smoke_current_freq=input(CONSENT_CONSENT2_Q107_T1,8.0);
smoke_past=input(CONSENT_CONSENT2_Q108_T2,8.0);
smoke_past_freq=input(CONSENT_CONSENT2_Q109_T3,8.0);
/*cig_num=input(CONSENTCONSENT2Q10T4_Q110A,8.0);
cig_day_week=input(CONSENTCONSENT2Q10T4_Q110B,8.0);
hand_cig_num=input(CONSENTCONSENT2Q10T4_Q110C,8.0);
hand_cig_day_week=input(CONSENTCONSENT2Q10T4_Q110D,8.0);
pipe_num=input(CONSENTCONSENT2Q10T4_Q110E,8.0);
pipe_day_week=input(CONSENTCONSENT2Q10T4_Q110F,8.0);
cigar_num=input(CONSENTCONSENT2Q10T4_Q110G,8.0);
cigar_day_week=input(CONSENTCONSENT2Q10T4_Q110H,8.0);
smoke_other=CONSENTCONSENT2Q10T4_Q110I;
smoke_other_num=input(CONSENTCONSENT2Q10T4_Q110J,8.0);
smoke_other_day_week=input(CONSENTCONSENT2Q10T4_Q110K,8.0);*/
prison=input(CONSENT_CONSENT2_Q111_R1,8.0);
tattoo=input(CONSENT_CONSENT2_Q112_R2,8.0);
tattoo_other_specify=CONSENT_CONSENT2_Q113F_R3A;
tattoo_needle=input(CONSENT_CONSENT2_Q114_R4,8.0);
tattoo_ink=input(CONSENT_CONSENT2_Q115_R5,8.0);
piercing=input(CONSENT_CONSENT2_Q116_R6,8.0);
piercing_other_specify=CONSENT_CONSENT2_Q117F_R7A;
/*piercing_salon=input(CONSENTCONSENT2Q17R7_Q117A,8.0);
piercing_home=input(CONSENTCONSENT2Q17R7_Q117B,8.0);
piercing_prison=input(CONSENTCONSENT2Q17R7_Q117C,8.0);
piercing_other=input(CONSENTCONSENT2Q17R7_Q117D,8.0);
piercing_DK=input(CONSENTCONSENT2Q17R7_Q117E,8.0);*/
piercing_needle=input(CONSENT_CONSENT2_Q118_R8,8.0);
manicure_num=input(CONSENT_CONSENT2_Q119A_R9A,8.0);
/*manicure_salon=input(CONSENTCONSENT2Q19R9_Q119A_R9,8.0);
manicure_homeservice=input(CONSENTCONSENT2Q19R9_Q119B_R9,8.0);
manicure_self=input(CONSENTCONSENT2Q19R9_Q119C_R9,8.0);
manicure_never=input(CONSENTCONSENT2Q19R9_Q119D_R9,8.0);
manicure_other=CONSENTCONSENT2Q19R9_Q119E_R9;*/
*;barber_num=CONSENT_CONSENT2_Q120A_R10A;
shave_other_specify=CONSENT_CONSENT2_Q120E_R10E;
/*shave_barber=input(CONSNTCNSENT2Q120R10_Q120A,8.0);
shave_home=input(CONSNTCNSENT2Q120R10_Q120B,8.0);
shave_none=input(CONSNTCNSENT2Q120R10_Q120C,8.0);
shave_other=input(CONSNTCNSENT2Q120R10_Q120D,8.0);*/
shave_razor=input(CONSENT_CONSENT2_Q121_R11,8.0);
/*heprisk_toothbrush=input(CONSNTCNSENT2Q12R12_Q122A,8.0);
heprisk_razor=input(CONSNTCNSENT2Q12R12_Q122B,8.0);
heprisk_scissors=input(CONSNTCNSENT2Q12R12_Q122C,8.0);
heprisk_brush=input(CONSNTCNSENT2Q12R12_Q122D,8.0);
heprisk_nail=input(CONSNTCNSENT2Q12R12_Q122E,8.0);
heprisk_none=input(CONSNTCNSENT2Q12R12_Q122F,8.0);
heprisk_DK=input(CONSNTCNSENT2Q12R12_Q122G,8.0);*/
IDU_ever=input(CONSENT_CONSENT2_Q123_I1,8.0);
IDU_num_life=input(CONSENT_CONSENT2_Q124_I2,8.0);
IDU_num_6mo=input(CONSENT_CONSENT2_Q125_I3,8.0);
IDU_age_start=input(CONSENT_CONSENT2_Q126_I4,8.0);
/*IDU_needle_NEP=input(CONSNTCONSNT2Q127I5_Q127A,8.0);
IDU_needle_store=input(CONSNTCONSNT2Q127I5_Q127B,8.0);
IDU_needle_order=input(CONSNTCONSNT2Q127I5_Q127C,8.0);
IDU_needle_borrow=input(CONSNTCONSNT2Q127I5_Q127D,8.0);
IDU_needle_rent=input(CONSNTCONSNT2Q127I5_Q127E,8.0);
IDU_needle_found=input(CONSNTCONSNT2Q127I5_Q127F,8.0);
IDU_needle_DK=input(CONSNTCONSNT2Q127I5_Q127G,8.0);
IDU_needle_none=input(CONSNTCONSNT2Q127I5_Q127H,8.0);
IDU_needle_refused=input(CONSNTCONSNT2Q127I5_Q127I,8.0);*/
IDU_share1=input(CONSENT_CONSENT2_Q128_I6,8.0);
IDU_share1_num=input(CONSENT_CONSENT2_Q129_I7,8.0);
IDU_share2=input(CONSENT_CONSENT2_Q130_I8,8.0);
IDU_share2_num=input(CONSENT_CONSENT2_Q131_I9,8.0);
/*IDU_vent=input(CONSNTCONSNT2Q132I10_Q132A,8.0);
IDU_jeff=input(CONSNTCONSNT2Q132I10_Q132B,8.0);
IDU_krokodil=input(CONSNTCONSNT2Q132I10_Q132C,8.0);
IDU_opium=input(CONSNTCONSNT2Q132I10_Q132D,8.0);
IDU_med=input(CONSNTCONSNT2Q132I10_Q132E,8.0);
IDU_poppy=input(CONSNTCONSNT2Q132I10_Q132F,8.0);
IDU_heroin=input(CONSNTCONSNT2Q132I10_Q132G,8.0);
IDU_alcohol=input(CONSNTCONSNT2Q132I10_Q132H,8.0);
IDU_cocaine=input(CONSNTCONSNT2Q132I10_Q132I,8.0);
IDU_crack=input(CONSNTCONSNT2Q132I10_Q132J,8.0);
IDU_psych=input(CONSNTCONSNT2Q132I10_Q132K,8.0);
IDU_ecstasy=input(CONSNTCONSNT2Q132I10_Q132L,8.0);
IDU_otherdrug=CONSNTCONSNT2Q132I10_Q132M;
IDU_drug_DK=input(CONSNTCONSNT2Q132I10_Q132N,8.0);
IDU_drug_RF=input(CONSNTCONSNT2Q132I10_Q132O,8.0);*/
sex_num=input(CONSENT_CONSENT2_Q133_SP1,8.0);
sex_STI=input(CONSENT_CONSENT2_Q134_SP2,8.0);
sex_HBV=input(CONSENT_CONSENT2_Q135_SP3,8.0);
sex_HCV=input(CONSENT_CONSENT2_Q136_SP4,8.0);
sex_HIV=input(CONSENT_CONSENT2_Q137_SP5,8.0);
condom=input(CONSENT_CONSENT2_Q138_SP6,8.0);
/*sex_healthcare=input(CONSNTCNSENT2Q139SP7_Q139A,8.0);
sex_military=input(CONSNTCNSENT2Q139SP7_Q139B,8.0);
sex_police=input(CONSNTCNSENT2Q139SP7_Q139C,8.0);
sex_dialysis=input(CONSNTCNSENT2Q139SP7_Q139D,8.0);
sex_IDU=input(CONSNTCNSENT2Q139SP7_Q139E,8.0);
sex_CSW=input(CONSNTCNSENT2Q139SP7_Q139F,8.0);
sex_none=input(CONSNTCNSENT2Q139SP7_Q139G,8.0);
sex_RF=input(CONSNTCNSENT2Q139SP7_Q139H,8.0);*/
/*tattoo_salon=input(CONSENTCONSENT2Q13R3_Q113A,8.0);
tattoo_home=input(CONSENTCONSENT2Q13R3_Q113B,8.0);
tattoo_prison=input(CONSENTCONSENT2Q13R3_Q113C,8.0);
tattoo_other=input(CONSENTCONSENT2Q13R3_Q113D,8.0);
tattoo_DK=input(CONSENTCONSENT2Q13R3_Q113E,8.0);*/
MSM=input(CONSENT_CONSENT2_Q140_SP8,8.0);
MSM_condom=input(CONSENT_CONSENT2_Q141_SP9,8.0);
int_ID_NCD=Q142_PB1;
nurse_ID=Q143_PB2;
consent_NCD=input(Q144_PB3,8.0);
consent_blood=input(Q145_PB4,8.0);
consent_bank=input(Q147_PB6,8.0);
phone_results=Q148_PB7;
address_results=Q149_PB8;
BP_ID=Q150_PB9;
cuff=input(Q151_PB10,8.0);
*;cuff_other_specify=Q151A_PB10;
BP_s1=input(Q152_PB11,8.0);
BP_d1=input(Q152_PB12,8.0);
BPM1=input(Q152_PB13,8.0);
BP_s2=input(Q153_PB14,8.0);
BP_d2=input(Q153_PB15,8.0);
BPM2=input(Q153_PB16,8.0);
BP_s3=input(Q154_PB17,8.0);
BP_d3=input(Q154_PB18,8.0);
BPM3=input(Q154_PB19,8.0);
BP_treat=input(Q155_PB20,8.0);
height_ID=Q156A_PB21;
weight_ID=Q156B_PB22;
height_cm=input(Q157_PB23,8.0);
kyphotic=input(Q157A_PB23A,8.0);
weight_kg=input(Q158_PB24,8.0);
pregnant=input(Q159_PB25,8.0);
waist_ID=Q160_PB26;
waist_cm=input(Q161_PB27,8.0);
hip_cm=input(Q162_PB28,8.0);
blood_collected=input(Q163_PB29,8.0);
disposition=input(Q164_EXIT1,8.0);
disposition_other_specify=Q164A_EXIT1_OTHER;
blood_time=Q165_PB31;
run;

*/Create labels for renamed variables;;
data HCV8.phone_label; set HCV8.phone_recode; 
	label barcode = 'Barcode';
	label int_id_quest = 'Interviewer ID for behavioral questionnaire';
	label f_name = 'First name';
	label age = 'Age of participant';
	label gender = 'Gender';
	label education = 'What is the highest level of education you have completed?';
	label alc_occasions = 'During the past 30 days, on how many drinking occasions did you have at least one alcoholic drink?';
	label alc_drinks = 'During the past 30 days, when you drank alcohol, on average, how many standard alcoholic drinks did you have during one drinking occasion?';
	label alc_max = 'During the past 30 days, what was the largest number of standard alcoholic drinks you had on a single occasion?';
	label alc_male = '(Males) During the past 30 days, how many times did you have 5 or more standard alcoholic drinks in a single drinking occasion?';
	label alc_female = '(Females) During the past 30 days, how many times did you have 4 or more standard alcoholic drinks in a single drinking occasion?';
	label walk_bike_lastweek = 'Have you walked or used a bicycle for at least 10 minutes continuously to get to and from places in the last week?';
	label walk_bike_typicalweek = 'In a typical week, on how many days do you walk or bicycle for at least 10 minutes continuously to get to and from places?';
	label walk_bike_typicalday = 'How much time do you spend walking or bicylcling for travel on a typical day?';
	label smoke_current_freq = 'Do you currently smoke tobacco...';
	label smoke_past = 'Have you smoked tobacco daily in the past?';
	label smoke_past_freq = 'In the past, have you smoked tobacco...';
	label cig_num = 'Number of manufactured cigarettes';
	label cig_day_week = 'Manufactured cigarettes counted per day/week';
	label hand_cig_num = 'Number of hand rolled cigarettes';
	label hand_cig_day_week = 'Hand rolled cigarettes counted per day/week';
	label pipe_num = 'Number of pipes full of tobacco';
	label pipe_day_week = 'Pipes counted per day/week';
	label cigar_num = 'Number of cigars, cheroots, or cigarillos';
	label cigar_day_week = 'Cigars, cheroots, or cigarillos counted per day/week';
	label smoke_other = 'Other tobacco products (specify)';
	label smoke_other_num = 'Number of other tobacco products';
	label smoke_other_day_week = 'Other tobacco products counted per day/week';
	label prison = 'Have you ever been in prison or jail?';
	label tattoo = 'Do you have any tattoos? If so, how many?';
	label tattoo_other_specify = 'If you got a tattoo somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label tattoo_needle = 'Do you know if the people who gave you your tattoo(s) used new needles, or did they use needles that had been used before?';
	label tattoo_ink = 'Do you know if the people who gave you your tattoo(s)used a new bottle of ink, or a bottle of ink that had already  been opened and
						used for someone else?';
	label piercing = 'Do you have any body piercings? If yes, how many?';
	label piercing_other_specify = 'If you got a body piercing somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label piercing_needle = 'Do you know if the people who gave you the piercing(s) used a new needle or piercing instrument, or one that had been used before?';
	label manicure_num = 'In the last 6 months, how many times have you received a manicure or pedicure at a beauty salon or through a home service?';
	label barber_num = 'In a typical month, how many times do you go to a barber or a beauty salon to get shaved?';
	label shave_other_specify = 'If you typically get shaved somewhere else (other than a barber, beauty salon, or at home), please state where';
	label shave_barber = 'Barber or beauty salon (Where do you typically shave or get shaved?)';
	label shave_home = 'Home (Where do you typically shave or get shaved?)';
	label shave_none = 'I do not shave (Where do you typically shave or get shaved?)';
	label shave_other = 'Somewhere else (Where do you typically shave or get shaved?)';
	label shave_razor = 'When you go to the barber do you know whether you are being shaved with new razors, or razors that ahve been used before?';
	label IDU_ever = 'Have you ever injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_life = 'About how many times if your life have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_6mo = 'In the last 6 months, how often have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_age_start = 'How old were you when you first injected drugs or narcotics for nonmedical reasons?';
	label IDU_needle_NEP = 'Needle exchange program (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_store = 'Drug store or other medical goods supplier (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_order = 'Mail or internet order (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_borrow = 'Borrowed from a friend or family member (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_rent = 'Purchased or rented from someone (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_found = 'A needle and/or syringe I found (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_DK = 'Do not know/remember (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_none = 'None of the above (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_refused = 'Refused (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_share1 = 'Have you ever used someone elses needle and/or syringe after they used it?';
	label IDU_share1_num = 'How many times have you ever used someone elses needle and/or syringe after they used it?';
	label birthday = 'Birth day/month';
	label birthyear = 'Birth year';
	label heprisk_toothbrush = 'Toothbrush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_razor = 'Razor blades (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_scissors = 'Scissors (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_brush = 'Shaving brush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_nail = 'Nail cutter (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_none = 'None of the above (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_DK = 'Dont know/remember (Which of the following articles have you used in common with other members of your household?)';
	label IDU_share2 = 'Have you ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_share2_num = 'How many times havey ou ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_vent = 'Vent (Which of the following drugs have you injected using a needle?)';
	label IDU_jeff = 'Jeff (Which of the following drugs have you injected using a needle?)';
	label IDU_krokodil = 'Krokodil (Which of the following drugs have you injected using a needle?)';
	label IDU_opium = 'Opium (Which of the following drugs have you injected using a needle?)';
	label IDU_med = 'Medical/synthetic drugs (Which of the following drugs have you injected using a needle?)';
	label IDU_poppy = 'Poppy straw (Which of the following drugs have you injected using a needle?)';
	label IDU_heroin = 'Heroin (Which of the following drugs have you injected using a needle?)';
	label IDU_alcohol = 'Alcohol (Which of the following drugs have you injected using a needle?)';
	label IDU_cocaine = 'Cocaine (Which of the following drugs have you injected using a needle?)';
	label IDU_crack = 'Crack (Which of the following drugs have you injected using a needle?)';
	label IDU_psych = 'Psychoactive or hallucinogenic substances (Which of the following drugs have you injected using a needle?)';
	label IDU_ecstasy = 'Ecstasy (Which of the following drugs have you injected using a needle?)';
	label IDU_otherdrug = 'Other (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_DK = 'Dont know/remember (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_RF = 'Refused to answer (Which of the following drugs have you injected using a needle?)';
	label sex_num = 'How many sexual partners have you had in your lifetime?';
	label sex_STI = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with any sexually transmitted infections?';
	label sex_HBV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HBV?';
	label sex_HCV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HCV?';
	label sex_HIV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HIV?';
	label condom = 'In your lifetime, how often have you used condoms with your sexual partners?';
	label sex_healthcare = 'Healthcare or emergency worker who comes into contact with blood (In your lifetime, have any of your sexual partners belonged to the
							following groups?)';
	label sex_military = 'Military (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_police = 'Police (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_dialysis = 'Person who regularly receives kidney dialysis, blood transfusions, or has hemophilia (In your lifetime, have any of your sexual 
						  partners belonged to the following groups?)';
	label sex_IDU = 'Injection drug user (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_CSW  = 'Commercial sex worker (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_none = 'None of the above (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_RF = 'Refused (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label tattoo_salon = 'Beauty salon or tattoo salon (Where did you get your tattoo(s)?)';
	label tattoo_home = 'Home (Where did you get your tattoo(s)?)';
	label tattoo_prison = 'Prison (Where did you get your tattoo(s)?)';
	label tattoo_other = 'Somewhere else (Where did you get your tattoo(s)?)';
	label tattoo_DK = 'Dont know/remember (Where did you get your tattoo(s)?)';
	label MSM = '(Men) Have you ever had sex with another man?';
	label MSM_condom = 'How often do you use condoms with your same sex partner(s)?';
	label int_ID_NCD = 'Interviewer ID for NCD section';
	label nurse_ID = 'Nurse ID';
	label consent_NCD = 'Would you be willing to have your height, weight and blood pressure taken today?';
	label consent_blood = 'Would you be willing to give a blood sample for hepatitis C and B testing?';
	label consent_bank = 'If there is any remaining blood left over after testing for hepatitis, can it be used to test for other diseases
                          of public health interest?';
	label phone_results = 'Contact phone number to return results';
	label address_results = 'Mailing address, or best way to reach for returning results';
	label ethnicity = 'Ethnicity';
	label BP_ID = 'Blood pressure device ID';
	label cuff = 'Cuff size used for blood pressure';
	label cuff_other_specify = 'If other cuff size was used for blood pressure, please specify';
	label BP_s1 = 'BP reading 1: Systolic (mmHg)';
	label BP_d1 = 'BP reading 1: Diastolic (mmHg)';
	label BPM1 = 'BP reading 1: Beats per minute';
	label BP_s2 = 'BP reading 2: Systolic (mmHg)';
	label BP_d2 = 'BP reading 2: Diastolic (mmHg)';
	label BPM2 = 'BP reading 2: Beats per minute';
	label BP_s3 = 'BP reading 3: Systolic (mmHg)';
	label BP_d3 = 'BP reading 3: Diastolic (mmHg)';
	label BPM3 = 'BP reading 3: Beats per minute';
	label BP_treat = 'During the past 2 weeks, have you been treated for raised blood pressure with drugs (medication) prescribed
                      by a doctor or other health worker?';
	label height_ID = 'Height device ID';
	label weight_ID = 'Weight device ID';
	label height_cm = 'Participant height in cm';
	label kyphotic = 'Is participant kyphotic (their back is hunched over due to age or spinal malformation)?';
	label weight_kg = ' Participant weight in kg';
	label pregnant = '(Women) Is the participant pregnant?';
	label ethnicity_other_specify = 'If ethnicity recorded as other, please specify';
	label religion = 'Religion';
	label waist_ID = 'Waist device ID';
	label waist_cm = 'Participant waist circumference in cm';
	label hip_cm = 'Participant hip circumference in cm';
	label blood_collected = 'Was a 10ml tiger top tube collected?';	
	label blood_time = 'Time of day blood specimen collected (24 hour clock)';
	label religion_other_specify = 'If religion recorded as other, please specify';
	label married = 'Marital status';
	label piercing_salon = 'Beauty salon or tattoo salon (Where did you get your body piercing(s)?)';
	label piercing_home = 'Home (Where did you get your body piercing(s)?)';
	label piercing_prison = 'Prison (Where did you get your body piercing(s)?)';
	label piercing_other = 'Somewhere else (Where did you get your body piercing(s)?)';
	label piercing_DK = 'Dont know/remember (Where did you get your body piercing(s)?)';
	label work = 'Which of hte following best describes your main work status over hte past year?';
	label work_healthcare = 'Health care (In your lifetime, have you ever worked in any of the following fields?)';
	label work_military = 'Military (In your lifetime, have you ever worked in any of the following fields?)';
	label work_police = 'Police (In your lifetime, have you ever worked in any of the following fields?)';
	label manicure_salon = 'Beauty salon (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_homeservice = 'Home service (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_self = 'I always perform my own manicures and pedicures (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_never = 'I have never had a manicure or pedicure (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_other = 'Somewhere else (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label house = 'Does your family rent, or own the house you live in?';
	label house_other_specify =  'If rent/own was recorded as other, please specify';
	label resident_num = 'How many people older than 18 years, including yourself, live permanently in your household?';
	label earnings_cat = 'Income category - GEL per week/month/year';
	label earnings_amount = 'In the last year, can you tell me what the average earnings of your household have been?';
	label earnings_estimate = 'If you do not know the exact amount, can you give an estimate of your households monthly earning?' ;
	label earners_num = 'How many people earn money in your household?';
	label insurance = 'Do you currently have medical insurance?';
	label insurance_type = 'What kind of health insurance do you have?';
	label medcare_pay = 'How do you pay for medical care when you need it?';
	label medcare_pay_other_specify = 'If medical care payment was recorded as other, please specify';
	label displaced = 'Have you ever been forced to move from your house because of war or civil unrest?';
	label medcare_location = 'Where do you go for medical care when you need it?';
	label medcare_location_other_specify = 'If medical care location was recorded as other, please specify';
	label flu = 'Last winter, October 2014 to April 2015, did you have a severe respiratory illness, with a sudden onset fever and cough that made you 
	            short of breath or caused you to have difficulty breathing?';
	label flu_polyclinic = 'Polyclinic (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_hospital = 'Hospital (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_medhome = 'Health care provider comes to my house (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_pharmacy = 'Pharmacy (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_villagedoc = 'Village doctor (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_none = 'I do not seek care when I am sick or injured (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_other = 'Other (If yes to severe respiratory illness, where did you go for medical care?)';
	label hh_num = 'Household number';
	label hospital_lifetime_num = 'During your lifetime, how many times have you been admitted to the hospital for any reason?';
	label dentist_cat = 'How often do you visit the dentist to have your teeth cleaned?';
	label dentist_other_specify = 'If dental location was recorded as other, please specify'; 
	label dentist_hospital = 'Hospital (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_cabinet = 'Dental cabinet (Have you ever visited the dentist or had a dental procedure in any of the following locations?');
	label dentist_home = 'Someones home (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_other = 'Other (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_DK = 'Do not know/remember (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';;
	label dental_proc_num = 'How many invasive dental procedures have you had in your lifetime?';
	label shot_num = 'How many shots have you received in the last 6 months, including immunizations and medication to numb you before a medical
                    or dental procedure?';
	label flushot = 'Did you receive a flu shot during the last (2014-2015) influenza season?';
	label flushot_loc = 'If yes to flu shot, where did you receive it?';
	label shot_admin = 'Who administered your last shot?';
	label shot_admin_other = 'If shot administration was recorded as other, please specify';
	label shot_needle = 'Before you received this last shot, did you see where the needle and/or syringe was taken from?';
	label shot_needle_other_specify = 'If shot needle/syringe source was recorded as other, please specify';
	label shot_purpose = 'Why did you get this last shot?';
	label shot_purpose_other_specify = 'If shot purpose was recorded as other, please specify';
	label shot_med = 'What medication was injected in this last shot?';
	label shot_med_other_specify = 'If shot medication was recorded as other, please specify';
	label shot_discard = 'Did they throw the syringe away after your shot?';
	label stratum_num = 'Stratum number';
	label cluster_ID = 'Cluster ID';
	label cluster_name = 'Cluster, city, or village name';
	label IV_num = 'How many IV infusions have you received in the last 6 months?';
	label dialysis_ever = 'In your lifetime, have you ever received dialysis for your kidneys?';
	label dialysis_polyclinic = 'Polyclinic (In what type of facilities have you received kidney dialysis?)';
	label dialysis_hospital = 'Hospital (In what type of facilities have you received kidney dialysis?)';
	label dialysis_home = 'Helath care provider comes to my house (In what type of facilities have you received kidney dialysis?)';
	label dialysis_pharmacy = 'Pharmacy (In what type of facilities have you received kidney dialysis?)';
	label dialysis_villagedoc = 'Village doctor (In what type of facilities have you received kidney dialysis?)';
	label dialysis_other = 'Other (In what type of facilities have you received kidney dialysis?)';
	label dialysis_current = 'Do you currently receive dialysis for your kidneys?';
	label dialysis_freq = 'How many times a week do you receive dialysis for your kidneys?';
	label blood_trans = 'Have you received any blood transfusions in your lifetime?';
	label blood_trans_num = 'How many times in your life have you received a transfusion of blood or blood products?';
	label blood_trans_relative = 'Did any of your blood transfusions come from a friend or relative?';
	label blood_donate = 'Have you ever donated blood?';
	label blood_donate_relative = 'Have you ever donated blood to a relative or friend who needed it?';
	label int_date = 'Confirm interview date';
	label blood_donate_money = 'Have you ever donated blood in exchange for money?';
	label med_invasive = 'During your lifetime, have you ever had an invasive medical procedure?';
	label surgery_ever = 'During your lifetime, have you ever had any type of surgery?';
	label surgery_num = 'During your lifetime, how many surgeries have you had?';
	label surgery_hospital = 'Hospital (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_nursing = 'Nursing home (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_polyclinic = 'Polyclinic (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_other = 'Other (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_DK = 'Do not know/remember (Have you ever had surgery in any of the following locations during your lifetime?)';
	label sti_ever = 'Have you ever been told by a doctor or other health worker that you had a sexually transmitted disease?';
	label sti_syphilis = 'Syphilis (Which sexually transmitted disease have you been diagnosed with?');
	label sti_gonorrhea = 'Gonorrhea (Which sexually transmitted disease have you been diagnosed with?');
	label sti_chlamydia = 'Chlamydia (Which sexually transmitted disease have you been diagnosed with?');
	label sti_herpes = 'Herpes (Which sexually transmitted disease have you been diagnosed with?');
	label sti_warts = 'Genital warts (Which sexually transmitted disease have you been diagnosed with?');
	label sti_other = 'Other (Which sexually transmitted disease have you been diagnosed with?');
	label HIV_test = 'Have you ever been tested for HIV, the virus that causes AIDS?';
	label HIV_result = 'What were your HIV test results?';
	label tb_ever = 'Have you ever been told by a doctor or other health worker that you have tuberculosis?';
	label int_start_time = 'Interview start time';
	label tb_year = 'Have you been told that you have tuberculosis in the past 12 months?';
	label tb_treat = 'Have you ever been treated for your tuberculosis?';
	label bp_meas = 'Have you ever had your blood pressure measured by a doctor or other health worker?';
	label hypertension_ever = 'Have you ever been told by a doctor or other health worker that you have raised blood pressure or hypertension?';
	label hypertension_year = 'Have you been told that you have raised blood pressure or hypertension in the past 12 months?';
	label sugar_meas = 'Have you ever had your blood sugar measured by a doctor or other health worker?';
	label diabetes_ever = 'Have you ever been told by a doctor or other health worker that you have high blood sugar or diabetes?';
	label diabetes_year = 'Have you been told that you have raised blood sugar or diabetes in the past 12 months?';
	label insulin_current = 'Are you currently taking insulin therapy?';
	label sugar_test_share = 'Have you ever tested your blood sugar using a needle that you shared with others?';
	label consent_int = 'Consent given for interview?';
	label insulin_syringe_share = 'Have you ever shared insulin syringes with others?';
	label chronic_asthma = 'Asthma (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_arthritis = 'Arthritis (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_cancer = 'Cancer (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_CVD = 'Cardiovascular disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_COPD = 'Chronic obstructive pulmonary disease (COPD) (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_hemophilia = 'Hemophilia or other blood disorders (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_thyroid = 'Thyroid problems (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_kidney = 'Kidney disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_lung = 'Lung disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other = 'Other (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other_specify = 'If other chronic condition was recorded, please state what type';
	label cancer_type = 'If cancer was recorded, please state what type';
	label HCV_heard = 'Have you ever heard of the hepatitis C virus, or HCV?';
	label HCV_trans_droplets = 'Droplets (Do you know how HCV is transmitted?)';
	label HCV_trans_food = 'Food (Do you know how HCV is transmitted?)';
	label HCV_trans_blood = 'Blood  (Do you know how HCV is transmitted?)';
	label HCV_trans_sex = 'Sexual contact (Do you know how HCV is transmitted?)';
	label HCV_trans_handshake = 'Handshake with an infected person (Do you know how HCV is transmitted?)';
	label HCV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HCV is transmitted?)';
	label HCV_trans_needle = 'Sharing needles or syringes (Do you know how HCV is transmitted?)';
	label HCV_trans_touch = 'Touching items in public places (Do you know how HCV is transmitted?)';
	label HCV_trans_DK = 'Do not know/remember (Do you know how HCV is transmitted?)';
	label HCV_trans_none = 'None of the above (Do you know how HCV is transmitted?)';
	label HCV_trans_other = 'Other (Do you know how HCV is transmitted?)';
	label HCV_trans_other_specify = 'If other mode of HCV transmission was recorded, please state how';
	label HCV_asymptomatic = 'Is it possible to have HCV but not have any symptoms?';
	label HCV_med = 'Are there medications available to treat HCV infections?';
	label trust_family = 'Talking with family members, friends, neighbors or colleagues (Where do you get health information that you trust?)';
	label trust_medlit = 'Special medical literature (Where do you get health information that you trust?)';
	label trust_newspaper = 'Newspapers and magazines (Where do you get health information that you trust?)';
	label trust_radio = 'Radio (Where do you get health information that you trust?)';
	label trust_tv = 'TV (Where do you get health information that you trust?)';
	label trust_internet = 'Internet (Where do you get health information that you trust?)';
	label trust_billboards = 'Billboards (Where do you get health information that you trust?)';
	label trust_brochures = 'Brochures, fliers, posters, or other printed materials (Where do you get health information that you trust?)';
	label trust_doctor = 'Doctors and other healthcare workers (Where do you get health information that you trust?)';
	label trust_pharmacist = 'Pharmacists (Where do you get health information that you trust?)';
	label trust_DK = 'Do not know/remember (Where do you get health information that you trust?)';
	label trust_none = 'None of the above (Where do you get health information that you trust?)';
	label trust_other = 'Other (Where do you get health information that you trust?)';
	label trust_other_specify = 'If other source of HCV information was recorded, please specify';
	label HBV_heard = 'Have you ever heard of the hepatitis B virus?';
	label consent_demo = 'If consent not given for interview, is participant OK giving basic demographic information?';
	label HCV_prev_vacc = 'Get a vaccination (What can you do to prevent HCV infection?)';
	label HCV_prev_condom = 'Use condoms (What can you do to prevent HCV infection?)';
	label HCV_prev_needle = 'Avoid sharing syringes or needles with other people (What can you do to prevent HCV infection?)';
	label HCV_prev_wash = 'Wash hands thoroughly (What can you do to prevent HCV infection?)';
	label HCV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to prevent HCV infection?)';
	label HCV_prev_DK = 'Do not know/remember (What can you do to prevent HCV infection?)';
	label HCV_prev_other = 'Other (What can you do to prevent HCV infection?)';
	label HCV_prev_none = 'None of the above (What can you do to prevent HCV infection?)';
	label language = 'Interview language';
	label HBV_trans_droplets = 'Droplets (Do you know how HBV is transmitted?)';
	label HBV_trans_food = 'Food (Do you know how HBV is transmitted?)';
	label HBV_trans_blood = 'Blood (Do you know how HBV is transmitted?)';
	label HBV_trans_sex = 'Sexual contact (Do you know how HBV is transmitted?)';
	label HBV_trans_handshake = 'Handshake with an infected person (Do you know how HBV is transmitted?)';
	label HBV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HBV is transmitted?)';
	label HBV_trans_needle = 'Sharing needles or syringes (Do you know how HBV is transmitted?)';
	label HBV_trans_touch = 'Touching items in public places (Do you know how HBV is transmitted?)';
	label HBV_trans_DK = 'Dont know/Remember (Do you know how HBV is transmitted?)';
	label HBV_trans_none = 'None of the above (Do you know how HBV is transmitted?)';
	label HBV_trans_other = 'Other (Do you know how HBV is transmitted?)';
	label HBV_trans_other_specify = 'If HBV transmission mode recorded as other, please state how';
	label HBV_asymptomatic = 'Is it possible to have HBV but not have any symptoms?';
	label HBV_med = 'Are there medications available to reat HBV infections?';
	label HBV_prev_vacc = 'Get a vaccination (What can you do to help prevent HBV infection?)';
	label HBV_prev_condom = 'Use condoms (What can you do to help prevent HBV infection?)';
	label HBV_prev_needle = 'Avoid sharing needles and syringes (What can you do to help prevent HBV infection?)';
	label HBV_prev_wash = 'Wash hads frequently (What can you do to help prevent HBV infection?)';
	label HBV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to help prevent HBV infection?)';
	label HBV_prev_DK = 'Dont know/Remember (What can you do to help prevent HBV infection?)';
	label HBV_prev_none = 'None of the above (What can you do to help prevent HBV infection?)';
	label HCV_ever = 'Have you ever been told by a doctor or other health worker that you have hepatitis C?';
	label HCV_year = 'What year were you told that you had hepatitis C?';
	label HCV_treated = 'Have you ever taken medications to treat your hepatitis C infection?';
	label HCV_notreat_avail = 'The medication was not available (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_eligible = 'My doctor told me I was not eligible to take the medication (Why didnt you take medication to treat 
          your hepatitis C infection?)';
	label HCV_notreat_expense = 'The medication was too expensive (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_effect = 'I heard that the medication has a lot of side effects (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_inject = 'I did not want to inject myself with a needle (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_other_specify = 'Other, specify ((Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_DK = 'Dont know/remember (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_RF = 'Refused (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_travel = 'I would ahve to travel too far to get the medication, or to see hte doctor in order to get
	      the medication (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_treat_complete = 'Did you complete your hepatitis C treatment, or did you stop before the end?';
	label HCV_cured = 'Did the treatment cure your hepatitis C infection?';
	label surname = 'Family surname';
	label HBV_ever = 'Have you been told by a doctor or other health worker that you have hepatitis B?';
	label HBV_year = 'What year were you told that you have hepatitis B?';
	label HBV_treated = 'Have you ever taken medications to treat your hepatitis B infection?';
	label HBV_vacc_ever = 'Have you ever been vaccinated against hepatitis B infection?';
	label hep_other_A = 'Hepatitis A (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';
	label hep_other_D = 'Hepatitis D (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_E = 'Hepatitis E (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_none = 'None (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_year = 'What year were you told that you had this other type of hepatitis?';
	label alc_ever = 'Have you ever consumed an alcoholic drink such as beer, wine, or spirits?';
	label alc_year = 'Have you consumed an alcoholic drink within the past 12 months?' ;
	label alc_year_freq = 'During the past 12 months, how frequently have you had at least one alcoholic drink?';
	label alc_month = 'Have you consumed an alcoholic drink within the past 30 days?';
	label disposition = 'Interview disposition: Did you complete the entire questionnaire?';
	label disposition_other_specify = 'If interview disposition recorded as other, please specify';

	run;

*Dropping variables;;
data HCV8.phone_format;
set HCV8.phone_label (drop=
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C

CONSENT_Q22_D12

CONSENT_CONSENT2_Q32_M4_Q32A
CONSENT_CONSENT2_Q32_M4_Q32B
CONSENT_CONSENT2_Q32_M4_Q32C
CONSENT_CONSENT2_Q32_M4_Q32D
CONSENT_CONSENT2_Q32_M4_Q32E

CONSENT_CONSENT2_Q42_M15_Q42A
CONSENT_CONSENT2_Q42_M15_Q42B
CONSENT_CONSENT2_Q42_M15_Q42C
CONSENT_CONSENT2_Q42_M15_Q42D
CONSENT_CONSENT2_Q42_M15_Q42E
CONSENT_CONSENT2_Q42_M15_Q42G

CONSENT_CONSENT2_Q54_S4_Q54A
CONSENT_CONSENT2_Q54_S4_Q54B
CONSENT_CONSENT2_Q54_S4_Q54C
CONSENT_CONSENT2_Q54_S4_Q54D
CONSENT_CONSENT2_Q54_S4_Q54E

CONSENT_CONSENT2_Q56_STI2_Q56A
CONSENT_CONSENT2_Q56_STI2_Q56B
CONSENT_CONSENT2_Q56_STI2_Q56C
CONSENT_CONSENT2_Q56_STI2_Q56D
CONSENT_CONSENT2_Q56_STI2_Q56E
CONSENT_CONSENT2_Q56_STI2_Q56F

CONSENT_CONSENT2_Q71_CD1_Q71A
CONSENT_CONSENT2_Q71_CD1_Q71B
CONSENT_CONSENT2_Q71_CD1_Q71C
CONSENT_CONSENT2_Q71_CD1_Q71D
CONSENT_CONSENT2_Q71_CD1_Q71E
CONSENT_CONSENT2_Q71_CD1_Q71F
CONSENT_CONSENT2_Q71_CD1_Q71G
CONSENT_CONSENT2_Q71_CD1_Q71H
CONSENT_CONSENT2_Q71_CD1_Q71I
CONSENT_CONSENT2_Q71_CD1_Q71J
CONSENT_CONSENT2_Q71_CD1_Q71K

CONSENT_CONSENT2_Q74_H2_Q74A
CONSENT_CONSENT2_Q74_H2_Q74B
CONSENT_CONSENT2_Q74_H2_Q74C
CONSENT_CONSENT2_Q74_H2_Q74D
CONSENT_CONSENT2_Q74_H2_Q74E
CONSENT_CONSENT2_Q74_H2_Q74F
CONSENT_CONSENT2_Q74_H2_Q74G
CONSENT_CONSENT2_Q74_H2_Q74H
CONSENT_CONSENT2_Q74_H2_Q74I
CONSENT_CONSENT2_Q74_H2_Q74J
CONSENT_CONSENT2_Q74_H2_Q74K

CONSENT_CONSENT2_Q77_H5_Q77A
CONSENT_CONSENT2_Q77_H5_Q77B
CONSENT_CONSENT2_Q77_H5_Q77C
CONSENT_CONSENT2_Q77_H5_Q77D
CONSENT_CONSENT2_Q77_H5_Q77E
CONSENT_CONSENT2_Q77_H5_Q77F
CONSENT_CONSENT2_Q77_H5_Q77G
CONSENT_CONSENT2_Q77_H5_Q77H
CONSENT_CONSENT2_Q78_H6_Q78A
CONSENT_CONSENT2_Q78_H6_Q78B
CONSENT_CONSENT2_Q78_H6_Q78C
CONSENT_CONSENT2_Q78_H6_Q78D
CONSENT_CONSENT2_Q78_H6_Q78E
CONSENT_CONSENT2_Q78_H6_Q78F
CONSENT_CONSENT2_Q78_H6_Q78G
CONSENT_CONSENT2_Q78_H6_Q78H
CONSENT_CONSENT2_Q78_H6_Q78I
CONSENT_CONSENT2_Q78_H6_Q78J
CONSENT_CONSENT2_Q78_H6_Q78K
CONSENT_CONSENT2_Q78_H6_Q78L
CONSENT_CONSENT2_Q78_H6_Q78M

CONSENT_CONSENT2_Q80_H8_Q80A
CONSENT_CONSENT2_Q80_H8_Q80B
CONSENT_CONSENT2_Q80_H8_Q80C
CONSENT_CONSENT2_Q80_H8_Q80D
CONSENT_CONSENT2_Q80_H8_Q80E
CONSENT_CONSENT2_Q80_H8_Q80F
CONSENT_CONSENT2_Q80_H8_Q80G
CONSENT_CONSENT2_Q80_H8_Q80H
CONSENT_CONSENT2_Q80_H8_Q80I
CONSENT_CONSENT2_Q80_H8_Q80J
CONSENT_CONSENT2_Q80_H8_Q80K

CONSENT_CONSENT2_Q83_H11_Q83A
CONSENT_CONSENT2_Q83_H11_Q83B
CONSENT_CONSENT2_Q83_H11_Q83C
CONSENT_CONSENT2_Q83_H11_Q83D
CONSENT_CONSENT2_Q83_H11_Q83E
CONSENT_CONSENT2_Q83_H11_Q83F
CONSENT_CONSENT2_Q83_H11_Q83G

CONSENT_CONSENT2_Q87_H15_Q87A
CONSENT_CONSENT2_Q87_H15_Q87B
CONSENT_CONSENT2_Q87_H15_Q87C
CONSENT_CONSENT2_Q87_H15_Q87D
CONSENT_CONSENT2_Q87_H15_Q87E
CONSENT_CONSENT2_Q87_H15_Q87F
CONSENT_CONSENT2_Q87_H15_Q87G
CONSENT_CONSENT2_Q87_H15_Q87H
CONSENT_CONSENT2_Q87_H15_Q87I

CONSENT_CONSENT2_Q94_H22_Q94A
CONSENT_CONSENT2_Q94_H22_Q94B
CONSENT_CONSENT2_Q94_H22_Q94C
CONSENT_CONSENT2_Q94_H22_Q94D
CONSENT_CONSENT2_Q94_H22_Q94E

CONSENT_CONSENT2_Q110_T4_Q110A
CONSENT_CONSENT2_Q110_T4_Q110B
CONSENT_CONSENT2_Q110_T4_Q110C
CONSENT_CONSENT2_Q110_T4_Q110D
CONSENT_CONSENT2_Q110_T4_Q110E
CONSENT_CONSENT2_Q110_T4_Q110F
CONSENT_CONSENT2_Q110_T4_Q110G
CONSENT_CONSENT2_Q110_T4_Q110H
CONSENT_CONSENT2_Q110_T4_Q110I
CONSENT_CONSENT2_Q110_T4_Q110J
CONSENT_CONSENT2_Q110_T4_Q110K

CONSENT_CONSENT2_Q117_R7_Q117A
CONSENT_CONSENT2_Q117_R7_Q117B
CONSENT_CONSENT2_Q117_R7_Q117C
CONSENT_CONSENT2_Q117_R7_Q117D
CONSENT_CONSENT2_Q117_R7_Q117E

CONSENT_CONSENT2_Q119_R9_Q119A_
CONSENT_CONSENT2_Q119_R9_Q119B_
CONSENT_CONSENT2_Q119_R9_Q119C_
CONSENT_CONSENT2_Q119_R9_Q119D_
CONSENT_CONSENT2_Q119_R9_Q119E_
CONSENT_CONSENT2_Q120A_R10A

CONSENT_CONSENT2_Q120_R10_Q120A  
CONSENT_CONSENT2_Q120_R10_Q120B  
CONSENT_CONSENT2_Q120_R10_Q120C  
CONSENT_CONSENT2_Q120_R10_Q120D  

CONSENT_CONSENT2_Q122_R12_Q122A
CONSENT_CONSENT2_Q122_R12_Q122B
CONSENT_CONSENT2_Q122_R12_Q122C
CONSENT_CONSENT2_Q122_R12_Q122D
CONSENT_CONSENT2_Q122_R12_Q122E
CONSENT_CONSENT2_Q122_R12_Q122F
CONSENT_CONSENT2_Q122_R12_Q122G 

CONSENT_CONSENT2_Q127_I5_Q127A
CONSENT_CONSENT2_Q127_I5_Q127B
CONSENT_CONSENT2_Q127_I5_Q127C
CONSENT_CONSENT2_Q127_I5_Q127D
CONSENT_CONSENT2_Q127_I5_Q127E
CONSENT_CONSENT2_Q127_I5_Q127F
CONSENT_CONSENT2_Q127_I5_Q127G
CONSENT_CONSENT2_Q127_I5_Q127H
CONSENT_CONSENT2_Q127_I5_Q127I

CONSENT_CONSENT2_Q132_I10_Q132A
CONSENT_CONSENT2_Q132_I10_Q132B
CONSENT_CONSENT2_Q132_I10_Q132C
CONSENT_CONSENT2_Q132_I10_Q132D
CONSENT_CONSENT2_Q132_I10_Q132E
CONSENT_CONSENT2_Q132_I10_Q132F
CONSENT_CONSENT2_Q132_I10_Q132G
CONSENT_CONSENT2_Q132_I10_Q132H
CONSENT_CONSENT2_Q132_I10_Q132I
CONSENT_CONSENT2_Q132_I10_Q132J
CONSENT_CONSENT2_Q132_I10_Q132K
CONSENT_CONSENT2_Q132_I10_Q132L
CONSENT_CONSENT2_Q132_I10_Q132M
CONSENT_CONSENT2_Q132_I10_Q132N
CONSENT_CONSENT2_Q132_I10_Q132O

CONSENT_CONSENT2_Q139_SP7_Q139A
CONSENT_CONSENT2_Q139_SP7_Q139B
CONSENT_CONSENT2_Q139_SP7_Q139C
CONSENT_CONSENT2_Q139_SP7_Q139D
CONSENT_CONSENT2_Q139_SP7_Q139E
CONSENT_CONSENT2_Q139_SP7_Q139F
CONSENT_CONSENT2_Q139_SP7_Q139G
CONSENT_CONSENT2_Q139_SP7_Q139H
CONSENT_CONSENT2_Q113_R3_Q113A
CONSENT_CONSENT2_Q113_R3_Q113B
CONSENT_CONSENT2_Q113_R3_Q113C
CONSENT_CONSENT2_Q113_R3_Q113D
CONSENT_CONSENT2_Q113_R3_Q113E

/* same variables */

Q0_BARCODE
Q1_I1
Q2A_I2
Q3A_I3
Q3B_I3
Q4_I4
Q5_I5
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
CONSENT_Q9_I9
CONSENT_Q10_I10
Q11_D1
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20_D10
CONSENT_Q20A_D10_OTHER
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
/*CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F*/
CONSENT_CONSENT2_Q30_M2
/*CONSNTCNSENT2Q29CM1C_Q29C_G*/
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q32_M4A
/*CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E*/
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
/*CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G*/
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
/*CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E*/
CONSENT_CONSENT2_Q55_STI1
/*CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F*/
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
/*CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K*/
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
/*CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K*/
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
/*CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H*/
/*CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M*/
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
/*CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K*/
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
/*CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G*/
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
/*CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I*/
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
/*CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E*/
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
/*CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K*/
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
/*CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E*/
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
/*CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9*/
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
/*CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D*/
CONSENT_CONSENT2_Q121_R11
/*CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G*/
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
/*CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I*/
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
/*CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O*/
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
/*CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H*/
/*CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E*/
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9


CONSENT_CONSENT2_PROMPT1
CONSENT_CONSENT2_PROMPT2
CONSENT_CONSENT2_PROMPT3
CONSENT_CONSENT2_PROMPT4
CONSENT_CONSENT2_PROMPT5
CONSENT_CONSENT2_PROMPTB
CONSENT_CONSENT2_PROMPTC
CONSENT_CONSENT2_PROMPTD
CONSENT_CONSENT2_PROMPTE
CONSENT_CONSENT2_PROMPTF
CONSENT_CONSENT2_PROMPTG
CONSENT_CONSENT2_PROMPTH
CONSENT_CONSENT2_PROMPTI
CONSENT_CONSENT2_PROMPTJ
CONSENT_CONSENT2_PROMPTK
CONSENT_CONSENT2_PROMPTL
CONSENT_CONSENT2_PROMPTM
CONSENT_CONSENT2_PROMPTN
CONSENT_CONSENT2_PROMPTO
CONSENT_CONSENT2_PROMPTP


CONSENT_PROMPTA
PROMPT6
PROMPTQ
PROMPTR
/*_LAST_UPDATE_URI_USER
_MODEL_VERSION
_UI_VERSION
_ORDINAL_NUMBER*/
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22

Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31

/*var variables (flu variables)*/
var50 var51 var52 var53 var54 var55 CONSENT_CONSENT2_Q29C_M1C_Q29C_);
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
data HCV9.HCVrecode;
set HCV9.HCVnull;

/*var variables*/
     
flu_polyclinic=input( Consent_Consent2_Q29c_M1c_Q29c_,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_A*/ 
flu_hospital=input(var50,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_B*/ 
flu_medhome=input(var51,8.0);     /*CONSENT_CONSENT2_Q29C_M1C_Q29C_C*/ 
flu_pharmacy=input(var52,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_D*/ 
flu_villagedoc=input(var53,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_E*/ 
flu_none=input(var54,8.0);        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_F*/ 

flu_other=var55;

/*sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);*/
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);

earnings_cat=input(CONSENT_Q22_D12,8.0);

/*flu_medhome = CONSENT_CONSENT2_Q29C_M1C_Q29C_;*/

dentist_hospital=input(CONSENT_CONSENT2_Q32_M4_Q32A,8.0);
dentist_cabinet=input(CONSENT_CONSENT2_Q32_M4_Q32B,8.0);
dentist_home=input(CONSENT_CONSENT2_Q32_M4_Q32C,8.0);
dentist_other=input(CONSENT_CONSENT2_Q32_M4_Q32D,8.0);
dentist_DK=input(CONSENT_CONSENT2_Q32_M4_Q32E,8.0);

dialysis_polyclinic=input(CONSENT_CONSENT2_Q42_M15_Q42A,8.0);
dialysis_hospital=input(CONSENT_CONSENT2_Q42_M15_Q42B,8.0);
dialysis_home=input(CONSENT_CONSENT2_Q42_M15_Q42C,8.0);
dialysis_pharmacy=input(CONSENT_CONSENT2_Q42_M15_Q42D,8.0);
dialysis_villagedoc=input(CONSENT_CONSENT2_Q42_M15_Q42E,8.0);
dialysis_other=input(CONSENT_CONSENT2_Q42_M15_Q42G,8.0);

surgery_hospital=input(CONSENT_CONSENT2_Q54_S4_Q54A,8.0);
surgery_nursing=input(CONSENT_CONSENT2_Q54_S4_Q54B,8.0);
surgery_polyclinic=input(CONSENT_CONSENT2_Q54_S4_Q54C,8.0);
****;surgery_other=CONSENT_CONSENT2_Q54_S4_Q54D;
surgery_DK=input(CONSENT_CONSENT2_Q54_S4_Q54E,8.0);

sti_syphilis=input(CONSENT_CONSENT2_Q56_STI2_Q56A,8.0);
sti_gonorrhea=input(CONSENT_CONSENT2_Q56_STI2_Q56B,8.0);
sti_chlamydia=input(CONSENT_CONSENT2_Q56_STI2_Q56C,8.0);
sti_herpes=input(CONSENT_CONSENT2_Q56_STI2_Q56D,8.0);
sti_warts=input(CONSENT_CONSENT2_Q56_STI2_Q56E,8.0);
***;sti_other=CONSENT_CONSENT2_Q56_STI2_Q56F;

chronic_asthma=input(CONSENT_CONSENT2_Q71_CD1_Q71A,8.0);
chronic_arthritis=input(CONSENT_CONSENT2_Q71_CD1_Q71B,8.0);
chronic_cancer=input(CONSENT_CONSENT2_Q71_CD1_Q71C,8.0);
chronic_CVD=input(CONSENT_CONSENT2_Q71_CD1_Q71D,8.0);
chronic_COPD=input(CONSENT_CONSENT2_Q71_CD1_Q71E,8.0);
chronic_hemophilia=input(CONSENT_CONSENT2_Q71_CD1_Q71F,8.0);
chronic_thyroid=input(CONSENT_CONSENT2_Q71_CD1_Q71G,8.0);
chronic_kidney=input(CONSENT_CONSENT2_Q71_CD1_Q71H,8.0);
chronic_lung=input(CONSENT_CONSENT2_Q71_CD1_Q71I,8.0);
chronic_other=input(CONSENT_CONSENT2_Q71_CD1_Q71J,8.0);
chronic_DK=input(CONSENT_CONSENT2_Q71_CD1_Q71K,8.0);

HCV_trans_droplets=input(CONSENT_CONSENT2_Q74_H2_Q74A,8.0);
HCV_trans_food=input(CONSENT_CONSENT2_Q74_H2_Q74B,8.0);
HCV_trans_blood=input(CONSENT_CONSENT2_Q74_H2_Q74C,8.0);
HCV_trans_sex=input(CONSENT_CONSENT2_Q74_H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENT_CONSENT2_Q74_H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENT_CONSENT2_Q74_H2_Q74F,8.0);
HCV_trans_needle=input(CONSENT_CONSENT2_Q74_H2_Q74G,8.0);
HCV_trans_touch=input(CONSENT_CONSENT2_Q74_H2_Q74H,8.0);
HCV_trans_DK=input(CONSENT_CONSENT2_Q74_H2_Q74I,8.0);
HCV_trans_none=input(CONSENT_CONSENT2_Q74_H2_Q74J,8.0);
HCV_trans_other=input(CONSENT_CONSENT2_Q74_H2_Q74K,8.0);

HCV_prev_vacc=input(CONSENT_CONSENT2_Q77_H5_Q77A,8.0);
HCV_prev_condom=input(CONSENT_CONSENT2_Q77_H5_Q77B,8.0);
HCV_prev_needle=input(CONSENT_CONSENT2_Q77_H5_Q77C,8.0);
HCV_prev_wash=input(CONSENT_CONSENT2_Q77_H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENT_CONSENT2_Q77_H5_Q77E,8.0);
HCV_prev_DK=input(CONSENT_CONSENT2_Q77_H5_Q77F,8.0);
****;HCV_prev_other=CONSENT_CONSENT2_Q77_H5_Q77G;
HCV_prev_none=input(CONSENT_CONSENT2_Q77_H5_Q77H,8.0);
trust_family=input(CONSENT_CONSENT2_Q78_H6_Q78A,8.0);
trust_medlit=input(CONSENT_CONSENT2_Q78_H6_Q78B,8.0);
trust_newspaper=input(CONSENT_CONSENT2_Q78_H6_Q78C,8.0);
trust_radio=input(CONSENT_CONSENT2_Q78_H6_Q78D,8.0);
trust_tv=input(CONSENT_CONSENT2_Q78_H6_Q78E,8.0);
trust_internet=input(CONSENT_CONSENT2_Q78_H6_Q78F,8.0);
trust_billboards=input(CONSENT_CONSENT2_Q78_H6_Q78G,8.0);
trust_brochures=input(CONSENT_CONSENT2_Q78_H6_Q78H,8.0);
trust_doctor=input(CONSENT_CONSENT2_Q78_H6_Q78I,8.0);
trust_pharmacist=input(CONSENT_CONSENT2_Q78_H6_Q78J,8.0);
trust_DK=input(CONSENT_CONSENT2_Q78_H6_Q78K,8.0);
trust_none=input(CONSENT_CONSENT2_Q78_H6_Q78L,8.0);
trust_other=input(CONSENT_CONSENT2_Q78_H6_Q78M,8.0);

HBV_trans_droplets=input(CONSENT_CONSENT2_Q80_H8_Q80A,8.0);
HBV_trans_food=input(CONSENT_CONSENT2_Q80_H8_Q80B,8.0);
HBV_trans_blood=input(CONSENT_CONSENT2_Q80_H8_Q80C,8.0);
HBV_trans_sex=input(CONSENT_CONSENT2_Q80_H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENT_CONSENT2_Q80_H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENT_CONSENT2_Q80_H8_Q80F,8.0);
HBV_trans_needle=input(CONSENT_CONSENT2_Q80_H8_Q80G,8.0);
HBV_trans_touch=input(CONSENT_CONSENT2_Q80_H8_Q80H,8.0);
HBV_trans_DK=input(CONSENT_CONSENT2_Q80_H8_Q80I,8.0);
HBV_trans_none=input(CONSENT_CONSENT2_Q80_H8_Q80J,8.0);
HBV_trans_other=input(CONSENT_CONSENT2_Q80_H8_Q80K,8.0);

HBV_prev_vacc=input(CONSENT_CONSENT2_Q83_H11_Q83A,8.0);
HBV_prev_condom=input(CONSENT_CONSENT2_Q83_H11_Q83B,8.0);
HBV_prev_needle=input(CONSENT_CONSENT2_Q83_H11_Q83C,8.0);
HBV_prev_wash=input(CONSENT_CONSENT2_Q83_H11_Q83D,8.0);
HBV_prev_sterile=input(CONSENT_CONSENT2_Q83_H11_Q83E,8.0);
HBV_prev_DK=input(CONSENT_CONSENT2_Q83_H11_Q83F,8.0);
HBV_prev_none=input(CONSENT_CONSENT2_Q83_H11_Q83G,8.0);

HCV_notreat_avail=input(CONSENT_CONSENT2_Q87_H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSENT_CONSENT2_Q87_H15_Q87B,8.0);
HCV_notreat_expense=input(CONSENT_CONSENT2_Q87_H15_Q87C,8.0);
HCV_notreat_effect=input(CONSENT_CONSENT2_Q87_H15_Q87D,8.0);
HCV_notreat_inject=input(CONSENT_CONSENT2_Q87_H15_Q87E,8.0);
HCV_notreat_other_specify=input(CONSENT_CONSENT2_Q87_H15_Q87F,8.0);
HCV_notreat_DK=input(CONSENT_CONSENT2_Q87_H15_Q87G,8.0);
HCV_notreat_RF=input(CONSENT_CONSENT2_Q87_H15_Q87H,8.0);
HCV_notreat_travel=input(CONSENT_CONSENT2_Q87_H15_Q87I,8.0);

hep_other_A=input(CONSENT_CONSENT2_Q94_H22_Q94A,8.0);
hep_other_D=input(CONSENT_CONSENT2_Q94_H22_Q94B,8.0);
hep_other_E=input(CONSENT_CONSENT2_Q94_H22_Q94C,8.0);
hep_other_none=input(CONSENT_CONSENT2_Q94_H22_Q94D,8.0);
hep_other_DK=input(CONSENT_CONSENT2_Q94_H22_Q94E,8.0);

cig_num =input(CONSENT_CONSENT2_Q110_T4_Q110A, 8.0);
cig_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110B, 8.0);
hand_cig_num= input(CONSENT_CONSENT2_Q110_T4_Q110C, 8.0);
hand_cig_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110D, 8.0);
pipe_num= input(CONSENT_CONSENT2_Q110_T4_Q110E, 8.0);
pipe_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110F, 8.0);
cigar_num= input(CONSENT_CONSENT2_Q110_T4_Q110G, 8.0);
cigar_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110H, 8.0);
smoke_other= CONSENT_CONSENT2_Q110_T4_Q110I;
smoke_other_num= CONSENT_CONSENT2_Q110_T4_Q110J;
smoke_other_day_week= CONSENT_CONSENT2_Q110_T4_Q110K;

piercing_salon=input(CONSENT_CONSENT2_Q117_R7_Q117A,8.0);
piercing_home=input(CONSENT_CONSENT2_Q117_R7_Q117B,8.0);
piercing_prison=input(CONSENT_CONSENT2_Q117_R7_Q117C,8.0);
piercing_other=input(CONSENT_CONSENT2_Q117_R7_Q117D,8.0);
piercing_DK=input(CONSENT_CONSENT2_Q117_R7_Q117E,8.0);

manicure_salon=CONSENT_CONSENT2_Q119_R9_Q119A_;
manicure_homeservice=CONSENT_CONSENT2_Q119_R9_Q119B_;
manicure_self=CONSENT_CONSENT2_Q119_R9_Q119C_;
manicure_never=CONSENT_CONSENT2_Q119_R9_Q119D_;
manicure_other=CONSENT_CONSENT2_Q119_R9_Q119E_;
barber_num=CONSENT_CONSENT2_Q120A_R10A;

shave_barber=input(CONSENT_CONSENT2_Q120_R10_Q120A  ,8.0);
shave_home=input(CONSENT_CONSENT2_Q120_R10_Q120B  ,8.0);
shave_none=input(CONSENT_CONSENT2_Q120_R10_Q120C  ,8.0);
shave_other=input(CONSENT_CONSENT2_Q120_R10_Q120D  ,8.0);

heprisk_toothbrush=input(CONSENT_CONSENT2_Q122_R12_Q122A,8.0);
heprisk_razor=input(CONSENT_CONSENT2_Q122_R12_Q122B,8.0);
heprisk_scissors=input(CONSENT_CONSENT2_Q122_R12_Q122C,8.0);
heprisk_brush=input(CONSENT_CONSENT2_Q122_R12_Q122D,8.0);
heprisk_nail=input(CONSENT_CONSENT2_Q122_R12_Q122E,8.0);
heprisk_none=input(CONSENT_CONSENT2_Q122_R12_Q122F,8.0);
heprisk_DK=input(CONSENT_CONSENT2_Q122_R12_Q122G ,8.0);

IDU_needle_NEP=input(CONSENT_CONSENT2_Q127_I5_Q127A,8.0);
IDU_needle_store=input(CONSENT_CONSENT2_Q127_I5_Q127B,8.0);
IDU_needle_order=input(CONSENT_CONSENT2_Q127_I5_Q127C,8.0);
IDU_needle_borrow=input(CONSENT_CONSENT2_Q127_I5_Q127D,8.0);
IDU_needle_rent=input(CONSENT_CONSENT2_Q127_I5_Q127E,8.0);
IDU_needle_found=input(CONSENT_CONSENT2_Q127_I5_Q127F,8.0);
IDU_needle_DK=input(CONSENT_CONSENT2_Q127_I5_Q127G,8.0);
IDU_needle_none=input(CONSENT_CONSENT2_Q127_I5_Q127H,8.0);
IDU_needle_refused=input(CONSENT_CONSENT2_Q127_I5_Q127I,8.0);

IDU_vent=input(CONSENT_CONSENT2_Q132_I10_Q132A,8.0);
IDU_jeff=input(CONSENT_CONSENT2_Q132_I10_Q132B,8.0);
IDU_krokodil=input(CONSENT_CONSENT2_Q132_I10_Q132C,8.0);
IDU_opium=input(CONSENT_CONSENT2_Q132_I10_Q132D,8.0);
IDU_med=input(CONSENT_CONSENT2_Q132_I10_Q132E,8.0);
IDU_poppy=input(CONSENT_CONSENT2_Q132_I10_Q132F,8.0);
IDU_heroin=input(CONSENT_CONSENT2_Q132_I10_Q132G,8.0);
IDU_alcohol=input(CONSENT_CONSENT2_Q132_I10_Q132H,8.0);
IDU_cocaine=input(CONSENT_CONSENT2_Q132_I10_Q132I,8.0);
IDU_crack=input(CONSENT_CONSENT2_Q132_I10_Q132J,8.0);
IDU_psych=input(CONSENT_CONSENT2_Q132_I10_Q132K,8.0);
IDU_ecstasy=input(CONSENT_CONSENT2_Q132_I10_Q132L,8.0);
IDU_otherdrug=input(CONSENT_CONSENT2_Q132_I10_Q132M,8.0);
IDU_drug_DK=input(CONSENT_CONSENT2_Q132_I10_Q132N,8.0);
IDU_drug_RF=input(CONSENT_CONSENT2_Q132_I10_Q132O,8.0);

sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);
sex_military = input(CONSENT_CONSENT2_Q139_SP7_Q139B, 8.0);
sex_police = input(CONSENT_CONSENT2_Q139_SP7_Q139C, 8.0);
sex_dialysis = input(CONSENT_CONSENT2_Q139_SP7_Q139D, 8.0);
sex_IDU = input(CONSENT_CONSENT2_Q139_SP7_Q139E, 8.0);
sex_CSW = input(CONSENT_CONSENT2_Q139_SP7_Q139F, 8.0);
sex_none = input(CONSENT_CONSENT2_Q139_SP7_Q139G, 8.0);
sex_RF = input(CONSENT_CONSENT2_Q139_SP7_Q139H, 8.0);
tattoo_salon=input(CONSENT_CONSENT2_Q113_R3_Q113A,8.0);
tattoo_home=input(CONSENT_CONSENT2_Q113_R3_Q113B,8.0);
tattoo_prison=input(CONSENT_CONSENT2_Q113_R3_Q113C,8.0);
tattoo_other=input(CONSENT_CONSENT2_Q113_R3_Q113D,8.0);
tattoo_DK=input(CONSENT_CONSENT2_Q113_R3_Q113E,8.0);

*matching variables;

*;barcode=Q0_BARCODE;
int_id_quest=Q1_I1;
hh_num=input(Q2A_I2,8.0);
stratum_num=input(Q3A_I3,8.0);
*;cluster_ID=Q3B_I3;
cluster_name=Q4_I4;
int_date=Q5_I5;
int_start_time=Q6_I6;
consent_int=input(Q7_I7,8.0);
consent_demo=input(Q7A_CONSENT,8.0);
language=input(Q8_I8,8.0);
surname=CONSENT_Q9_I9;
f_name=CONSENT_Q10_I10;
gender=input(Q11_D1,8.0);
birthday=CONSENT_Q12A_D2;
birthyear=input(CONSENT_Q12B_D2,8.0);
age=input(CONSENT_Q13_D3,8.0);
education=input(CONSENT_Q14_D4,8.0);
ethnicity=input(CONSENT_Q15_D5,8.0);
ethnicity_other_specify=CONSENT_Q15A_D5_OTHER;
religion=input(CONSENT_Q16_D6,8.0);
religion_other_specify=CONSENT_Q16A_D6_OTHER;
married=input(CONSENT_Q17_D7,8.0);
work=input(CONSENT_Q18_D8,8.0);
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);
house=input(CONSENT_Q20_D10,8.0);
house_other_specify=CONSENT_Q20A_D10_OTHER;
resident_num=input(CONSENT_Q21_D11,8.0);
earnings_cat=input(CONSENT_Q22_D12,8.0);
earnings_amount=input(CONSENT_Q22A_D12,8.0);
earnings_estimate=input(CONSENT_Q23_D13,8.0);
earners_num=input(CONSENT_Q24_D14,8.0);
insurance=input(CONSENT_Q25_D15,8.0);
insurance_type=input(CONSENT_Q26_D16,8.0);
medcare_pay=input(CONSENT_Q27_D17,8.0);
medcare_pay_other_specify=CONSENT_Q27A_D17_OTHER;
displaced=input(CONSENT_Q28_D18,8.0);
medcare_location=input(CONSENT_CONSENT2_Q29_M1,8.0);
medcare_location_other_specify=CONSENT_CONSENT2_Q29A_M1_OTHER;
flu=input(CONSENT_CONSENT2_Q29B_M1B,8.0);
/*flu_polyclinic=input(CONSNTCNSENT2Q29CM1C_Q29C_A,8.0);
flu_hospital=input(CONSNTCNSENT2Q29CM1C_Q29C_B,8.0);
flu_medhome=input(CONSNTCNSENT2Q29CM1C_Q29C_C,8.0);
flu_pharmacy=input(CONSNTCNSENT2Q29CM1C_Q29C_D,8.0);
flu_villagedoc=input(CONSNTCNSENT2Q29CM1C_Q29C_E,8.0);
flu_none=input(CONSNTCNSENT2Q29CM1C_Q29C_F,8.0);*/
hospital_lifetime_num=input(CONSENT_CONSENT2_Q30_M2,8.0);
/*flu_other=CONSNTCNSENT2Q29CM1C_Q29C_G;*/
dentist_cat=input(CONSENT_CONSENT2_Q31_M3,8.0);
dentist_other_specify=CONSENT_CONSENT2_Q32_M4A;
/*dentist_hospital=input(CONSENTCONSENT2Q32M4_Q32A,8.0);
dentist_cabinet=input(CONSENTCONSENT2Q32M4_Q32B,8.0);
dentist_home=input(CONSENTCONSENT2Q32M4_Q32C,8.0);
dentist_other=input(CONSENTCONSENT2Q32M4_Q32D,8.0);
dentist_DK=input(CONSENTCONSENT2Q32M4_Q32E,8.0);*/
dental_proc_num=input(CONSENT_CONSENT2_Q33_M5,8.0);
shot_num=input(CONSENT_CONSENT2_Q34_M6,8.0);
flushot=input(CONSENT_CONSENT2_Q34A_M6_1,8.0);
flushot_loc=CONSENT_CONSENT2_Q34B_M6_2;
shot_admin=input(CONSENT_CONSENT2_Q35_M7,8.0);
shot_admin_other=CONSENT_CONSENT2_Q35A_M7_OTHER;
shot_needle=input(CONSENT_CONSENT2_Q36_M8,8.0);
shot_needle_other_specify=CONSENT_CONSENT2_Q36A_M8_OTHER;
shot_purpose=input(CONSENT_CONSENT2_Q37_M9,8.0);
shot_purpose_other_specify=CONSENT_CONSENT2_Q37A_M9_OTHER;
shot_med=input(CONSENT_CONSENT2_Q38_M10,8.0);
shot_med_other_specify=CONSENT_CONSENT2_Q38A_M10_OTHER;
shot_discard=input(CONSENT_CONSENT2_Q39_M11,8.0);
IV_num=input(CONSENT_CONSENT2_Q40_M12,8.0);
dialysis_ever=input(CONSENT_CONSENT2_Q41_M14,8.0);
/*dialysis_polyclinic=input(CONSNTCNSENT2Q42M15_Q42A,8.0);
dialysis_hospital=input(CONSNTCNSENT2Q42M15_Q42B,8.0);
dialysis_home=input(CONSNTCNSENT2Q42M15_Q42C,8.0);
dialysis_pharmacy=input(CONSNTCNSENT2Q42M15_Q42D,8.0);
dialysis_villagedoc=input(CONSNTCNSENT2Q42M15_Q42E,8.0);
dialysis_other=input(CONSNTCNSENT2Q42M15_Q42G,8.0);*/
dialysis_current=input(CONSENT_CONSENT2_Q43_M16,8.0);
dialysis_freq=input(CONSENT_CONSENT2_Q44_M17,8.0);
blood_trans=input(CONSENT_CONSENT2_Q45_M18,8.0);
blood_trans_num=input(CONSENT_CONSENT2_Q46_M19,8.0);
blood_trans_relative=input(CONSENT_CONSENT2_Q47_M20,8.0);
blood_donate=input(CONSENT_CONSENT2_Q48_M21,8.0);
blood_donate_relative=input(CONSENT_CONSENT2_Q49_M22,8.0);
blood_donate_money=input(CONSENT_CONSENT2_Q50_M23,8.0);
med_invasive=input(CONSENT_CONSENT2_Q51_S1,8.0);
surgery_ever=input(CONSENT_CONSENT2_Q52_S2,8.0);
surgery_num=input(CONSENT_CONSENT2_Q53_S3,8.0);
/*surgery_hospital=input(CONSENTCONSENT2Q54S4_Q54A,8.0);
surgery_nursing=input(CONSENTCONSENT2Q54S4_Q54B,8.0);
surgery_polyclinic=input(CONSENTCONSENT2Q54S4_Q54C,8.0);
surgery_other=CONSENTCONSENT2Q54S4_Q54D;
surgery_DK=input(CONSENTCONSENT2Q54S4_Q54E,8.0);*/
sti_ever=input(CONSENT_CONSENT2_Q55_STI1,8.0);
/*sti_syphilis=input(CONSNTCONSNT2Q56STI2_Q56A,8.0);
sti_gonorrhea=input(CONSNTCONSNT2Q56STI2_Q56B,8.0);
sti_chlamydia=input(CONSNTCONSNT2Q56STI2_Q56C,8.0);
sti_herpes=input(CONSNTCONSNT2Q56STI2_Q56D,8.0);
sti_warts=input(CONSNTCONSNT2Q56STI2_Q56E,8.0);
sti_other=CONSNTCONSNT2Q56STI2_Q56F;*/
HIV_test=input(CONSENT_CONSENT2_Q57_STI3,8.0);
HIV_result=input(CONSENT_CONSENT2_Q58_STI4,8.0);
tb_ever=input(CONSENT_CONSENT2_Q59_TB1,8.0);
tb_year=input(CONSENT_CONSENT2_Q60_TB2,8.0);
tb_treat=input(CONSENT_CONSENT2_Q61_TB3,8.0);
bp_meas=input(CONSENT_CONSENT2_Q62_HY1,8.0);
hypertension_ever=input(CONSENT_CONSENT2_Q63_HY2,8.0);
hypertension_year=input(CONSENT_CONSENT2_Q64_HY3,8.0);
sugar_meas=input(CONSENT_CONSENT2_Q65_D1,8.0);
diabetes_ever=input(CONSENT_CONSENT2_Q66_D2,8.0);
diabetes_year=input(CONSENT_CONSENT2_Q67_D3,8.0);
insulin_current=input(CONSENT_CONSENT2_Q68_D4,8.0);
sugar_test_share=input(CONSENT_CONSENT2_Q69_D5,8.0);
insulin_syringe_share=input(CONSENT_CONSENT2_Q70_D6,8.0);
/*chronic_asthma=input(CONSNTCNSENT2Q71CD1_Q71A,8.0);
chronic_arthritis=input(CONSNTCNSENT2Q71CD1_Q71B,8.0);
chronic_cancer=input(CONSNTCNSENT2Q71CD1_Q71C,8.0);
chronic_CVD=input(CONSNTCNSENT2Q71CD1_Q71D,8.0);
chronic_COPD=input(CONSNTCNSENT2Q71CD1_Q71E,8.0);
chronic_hemophilia=input(CONSNTCNSENT2Q71CD1_Q71F,8.0);
chronic_thyroid=input(CONSNTCNSENT2Q71CD1_Q71G,8.0);
chronic_kidney=input(CONSNTCNSENT2Q71CD1_Q71H,8.0);
chronic_lung=input(CONSNTCNSENT2Q71CD1_Q71I,8.0);
chronic_other=input(CONSNTCNSENT2Q71CD1_Q71J,8.0);
chronic_DK=input(CONSNTCNSENT2Q71CD1_Q71K,8.0);*/
chronic_other_specify=CONSENT_CONSENT2_Q71L_CD1_OTHER;
cancer_type=CONSENT_CONSENT2_Q72_CD2;
HCV_heard=input(CONSENT_CONSENT2_Q73_H1,8.0);
/*HCV_trans_droplets=input(CONSENTCONSENT2Q74H2_Q74A,8.0);
HCV_trans_food=input(CONSENTCONSENT2Q74H2_Q74B,8.0);
HCV_trans_blood=input(CONSENTCONSENT2Q74H2_Q74C,8.0);
HCV_trans_sex=input(CONSENTCONSENT2Q74H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENTCONSENT2Q74H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENTCONSENT2Q74H2_Q74F,8.0);
HCV_trans_needle=input(CONSENTCONSENT2Q74H2_Q74G,8.0);
HCV_trans_touch=input(CONSENTCONSENT2Q74H2_Q74H,8.0);
HCV_trans_DK=input(CONSENTCONSENT2Q74H2_Q74I,8.0);
HCV_trans_none=input(CONSENTCONSENT2Q74H2_Q74J,8.0);
HCV_trans_other=input(CONSENTCONSENT2Q74H2_Q74K,8.0);*/
HCV_trans_other_specify=CONSENT_CONSENT2_Q74L_H2A;
HCV_asymptomatic=input(CONSENT_CONSENT2_Q75_H3,8.0);
HCV_med=input(CONSENT_CONSENT2_Q76_H4,8.0);
/*HCV_prev_vacc=input(CONSENTCONSENT2Q7H5_Q77A,8.0);
HCV_prev_condom=input(CONSENTCONSENT2Q7H5_Q77B,8.0);
HCV_prev_needle=input(CONSENTCONSENT2Q7H5_Q77C,8.0);
HCV_prev_wash=input(CONSENTCONSENT2Q7H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENTCONSENT2Q7H5_Q77E,8.0);
HCV_prev_DK=input(CONSENTCONSENT2Q7H5_Q77F,8.0);
HCV_prev_other=CONSENTCONSENT2Q7H5_Q77G;
HCV_prev_none=input(CONSENTCONSENT2Q7H5_Q77H,8.0);*/
/*trust_family=input(CONSENTCONSENT2Q78H6_Q78A,8.0);
trust_medlit=input(CONSENTCONSENT2Q78H6_Q78B,8.0);
trust_newspaper=input(CONSENTCONSENT2Q78H6_Q78C,8.0);
trust_radio=input(CONSENTCONSENT2Q78H6_Q78D,8.0);
trust_tv=input(CONSENTCONSENT2Q78H6_Q78E,8.0);
trust_internet=input(CONSENTCONSENT2Q78H6_Q78F,8.0);
trust_billboards=input(CONSENTCONSENT2Q78H6_Q78G,8.0);
trust_brochures=input(CONSENTCONSENT2Q78H6_Q78H,8.0);
trust_doctor=input(CONSENTCONSENT2Q78H6_Q78I,8.0);
trust_pharmacist=input(CONSENTCONSENT2Q78H6_Q78J,8.0);
trust_DK=input(CONSENTCONSENT2Q78H6_Q78K,8.0);
trust_none=input(CONSENTCONSENT2Q78H6_Q78L,8.0);
trust_other=input(CONSENTCONSENT2Q78H6_Q78M,8.0);*/
trust_other_specify=CONSENT_CONSENT2_Q78N_H6A;
HBV_heard=input(CONSENT_CONSENT2_Q79_H7,8.0);
/*HBV_trans_droplets=input(CONSENTCONSENT2Q80H8_Q80A,8.0);
HBV_trans_food=input(CONSENTCONSENT2Q80H8_Q80B,8.0);
HBV_trans_blood=input(CONSENTCONSENT2Q80H8_Q80C,8.0);
HBV_trans_sex=input(CONSENTCONSENT2Q80H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENTCONSENT2Q80H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENTCONSENT2Q80H8_Q80F,8.0);
HBV_trans_needle=input(CONSENTCONSENT2Q80H8_Q80G,8.0);
HBV_trans_touch=input(CONSENTCONSENT2Q80H8_Q80H,8.0);
HBV_trans_DK=input(CONSENTCONSENT2Q80H8_Q80I,8.0);
HBV_trans_none=input(CONSENTCONSENT2Q80H8_Q80J,8.0);
HBV_trans_other=input(CONSENTCONSENT2Q80H8_Q80K,8.0);*/
HBV_trans_other_specify=CONSENT_CONSENT2_Q80L_H8A;
HBV_asymptomatic=input(CONSENT_CONSENT2_Q81_H9,8.0);
HBV_med=input(CONSENT_CONSENT2_Q82_H10,8.0);
/*HBV_prev_vacc=input(CONSENTCONSENT2Q83H1_Q83A,8.0);
HBV_prev_condom=input(CONSENTCONSENT2Q83H1_Q83B,8.0);
HBV_prev_needle=input(CONSENTCONSENT2Q83H1_Q83C,8.0);
HBV_prev_wash=input(CONSENTCONSENT2Q83H1_Q83D,8.0);
HBV_prev_sterile=input(CONSENTCONSENT2Q83H1_Q83E,8.0);
HBV_prev_DK=input(CONSENTCONSENT2Q83H1_Q83F,8.0);
HBV_prev_none=input(CONSENTCONSENT2Q83H1_Q83G,8.0);*/
HCV_ever=input(CONSENT_CONSENT2_Q84_H12,8.0);
HCV_year=input(CONSENT_CONSENT2_Q85_H13,8.0);
HCV_treated=input(CONSENT_CONSENT2_Q86_H14,8.0);
/*HCV_notreat_avail=input(CONSNTCNSENT2Q87H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSNTCNSENT2Q87H15_Q87B,8.0);
HCV_notreat_expense=input(CONSNTCNSENT2Q87H15_Q87C,8.0);
HCV_notreat_effect=input(CONSNTCNSENT2Q87H15_Q87D,8.0);
HCV_notreat_inject=input(CONSNTCNSENT2Q87H15_Q87E,8.0);
HCV_notreat_other_specify=CONSNTCNSENT2Q87H15_Q87F;
HCV_notreat_DK=input(CONSNTCNSENT2Q87H15_Q87G,8.0);
HCV_notreat_RF=input(CONSNTCNSENT2Q87H15_Q87H,8.0);
HCV_notreat_travel=input(CONSNTCNSENT2Q87H15_Q87I,8.0);*/
HCV_treat_complete=input(CONSENT_CONSENT2_Q88_H16,8.0);
HCV_cured=input(CONSENT_CONSENT2_Q89_H17,8.0);
HBV_ever=input(CONSENT_CONSENT2_Q90_H18,8.0);
HBV_year=input(CONSENT_CONSENT2_Q91_H19,8.0);
HBV_treated=input(CONSENT_CONSENT2_Q92_H20,8.0);
HBV_vacc_ever=input(CONSENT_CONSENT2_Q93_H21,8.0);
/*hep_other_A=input(CONSENTCONSENT2Q94H2_Q94A,8.0);
hep_other_D=input(CONSENTCONSENT2Q94H2_Q94B,8.0);
hep_other_E=input(CONSENTCONSENT2Q94H2_Q94C,8.0);
hep_other_none=input(CONSENTCONSENT2Q94H2_Q94D,8.0);
hep_other_DK=input(CONSENTCONSENT2Q94H2_Q94E,8.0);*/
hep_other_year=input(CONSENT_CONSENT2_Q95_H23,8.0);
alc_ever=input(CONSENT_CONSENT2_Q96_A1A,8.0);
alc_year=input(CONSENT_CONSENT2_Q97_A1B,8.0);
alc_year_freq=input(CONSENT_CONSENT2_Q98_A2,8.0);
alc_month=input(CONSENT_CONSENT2_Q99_A3,8.0);
alc_occasions=input(CONSENT_CONSENT2_Q100_A4,8.0);
alc_drinks=input(CONSENT_CONSENT2_Q101_A5,8.0);
alc_max=input(CONSENT_CONSENT2_Q102_A6,8.0);
alc_male=input(CONSENT_CONSENT2_Q103A_A7_MALES,8.0);
alc_female=input(CONSENT_CONSENT2_Q103B_A7_FEMAL,8.0);
walk_bike_lastweek=input(CONSENT_CONSENT2_Q104_PA1,8.0);
walk_bike_typicalweek=input(CONSENT_CONSENT2_Q105_PA2,8.0);
walk_bike_typicalday=CONSENT_CONSENT2_Q106_PA3;
smoke_current_freq=input(CONSENT_CONSENT2_Q107_T1,8.0);
smoke_past=input(CONSENT_CONSENT2_Q108_T2,8.0);
smoke_past_freq=input(CONSENT_CONSENT2_Q109_T3,8.0);
/*cig_num=input(CONSENTCONSENT2Q10T4_Q110A,8.0);
cig_day_week=input(CONSENTCONSENT2Q10T4_Q110B,8.0);
hand_cig_num=input(CONSENTCONSENT2Q10T4_Q110C,8.0);
hand_cig_day_week=input(CONSENTCONSENT2Q10T4_Q110D,8.0);
pipe_num=input(CONSENTCONSENT2Q10T4_Q110E,8.0);
pipe_day_week=input(CONSENTCONSENT2Q10T4_Q110F,8.0);
cigar_num=input(CONSENTCONSENT2Q10T4_Q110G,8.0);
cigar_day_week=input(CONSENTCONSENT2Q10T4_Q110H,8.0);
smoke_other=CONSENTCONSENT2Q10T4_Q110I;
smoke_other_num=input(CONSENTCONSENT2Q10T4_Q110J,8.0);
smoke_other_day_week=input(CONSENTCONSENT2Q10T4_Q110K,8.0);*/
prison=input(CONSENT_CONSENT2_Q111_R1,8.0);
tattoo=input(CONSENT_CONSENT2_Q112_R2,8.0);
tattoo_other_specify=CONSENT_CONSENT2_Q113F_R3A;
tattoo_needle=input(CONSENT_CONSENT2_Q114_R4,8.0);
tattoo_ink=input(CONSENT_CONSENT2_Q115_R5,8.0);
piercing=input(CONSENT_CONSENT2_Q116_R6,8.0);
piercing_other_specify=CONSENT_CONSENT2_Q117F_R7A;
/*piercing_salon=input(CONSENTCONSENT2Q17R7_Q117A,8.0);
piercing_home=input(CONSENTCONSENT2Q17R7_Q117B,8.0);
piercing_prison=input(CONSENTCONSENT2Q17R7_Q117C,8.0);
piercing_other=input(CONSENTCONSENT2Q17R7_Q117D,8.0);
piercing_DK=input(CONSENTCONSENT2Q17R7_Q117E,8.0);*/
piercing_needle=input(CONSENT_CONSENT2_Q118_R8,8.0);
manicure_num=input(CONSENT_CONSENT2_Q119A_R9A,8.0);
/*manicure_salon=input(CONSENTCONSENT2Q19R9_Q119A_R9,8.0);
manicure_homeservice=input(CONSENTCONSENT2Q19R9_Q119B_R9,8.0);
manicure_self=input(CONSENTCONSENT2Q19R9_Q119C_R9,8.0);
manicure_never=input(CONSENTCONSENT2Q19R9_Q119D_R9,8.0);
manicure_other=CONSENTCONSENT2Q19R9_Q119E_R9;*/
*;barber_num=CONSENT_CONSENT2_Q120A_R10A;
shave_other_specify=CONSENT_CONSENT2_Q120E_R10E;
/*shave_barber=input(CONSNTCNSENT2Q120R10_Q120A,8.0);
shave_home=input(CONSNTCNSENT2Q120R10_Q120B,8.0);
shave_none=input(CONSNTCNSENT2Q120R10_Q120C,8.0);
shave_other=input(CONSNTCNSENT2Q120R10_Q120D,8.0);*/
shave_razor=input(CONSENT_CONSENT2_Q121_R11,8.0);
/*heprisk_toothbrush=input(CONSNTCNSENT2Q12R12_Q122A,8.0);
heprisk_razor=input(CONSNTCNSENT2Q12R12_Q122B,8.0);
heprisk_scissors=input(CONSNTCNSENT2Q12R12_Q122C,8.0);
heprisk_brush=input(CONSNTCNSENT2Q12R12_Q122D,8.0);
heprisk_nail=input(CONSNTCNSENT2Q12R12_Q122E,8.0);
heprisk_none=input(CONSNTCNSENT2Q12R12_Q122F,8.0);
heprisk_DK=input(CONSNTCNSENT2Q12R12_Q122G,8.0);*/
IDU_ever=input(CONSENT_CONSENT2_Q123_I1,8.0);
IDU_num_life=input(CONSENT_CONSENT2_Q124_I2,8.0);
IDU_num_6mo=input(CONSENT_CONSENT2_Q125_I3,8.0);
IDU_age_start=input(CONSENT_CONSENT2_Q126_I4,8.0);
/*IDU_needle_NEP=input(CONSNTCONSNT2Q127I5_Q127A,8.0);
IDU_needle_store=input(CONSNTCONSNT2Q127I5_Q127B,8.0);
IDU_needle_order=input(CONSNTCONSNT2Q127I5_Q127C,8.0);
IDU_needle_borrow=input(CONSNTCONSNT2Q127I5_Q127D,8.0);
IDU_needle_rent=input(CONSNTCONSNT2Q127I5_Q127E,8.0);
IDU_needle_found=input(CONSNTCONSNT2Q127I5_Q127F,8.0);
IDU_needle_DK=input(CONSNTCONSNT2Q127I5_Q127G,8.0);
IDU_needle_none=input(CONSNTCONSNT2Q127I5_Q127H,8.0);
IDU_needle_refused=input(CONSNTCONSNT2Q127I5_Q127I,8.0);*/
IDU_share1=input(CONSENT_CONSENT2_Q128_I6,8.0);
IDU_share1_num=input(CONSENT_CONSENT2_Q129_I7,8.0);
IDU_share2=input(CONSENT_CONSENT2_Q130_I8,8.0);
IDU_share2_num=input(CONSENT_CONSENT2_Q131_I9,8.0);
/*IDU_vent=input(CONSNTCONSNT2Q132I10_Q132A,8.0);
IDU_jeff=input(CONSNTCONSNT2Q132I10_Q132B,8.0);
IDU_krokodil=input(CONSNTCONSNT2Q132I10_Q132C,8.0);
IDU_opium=input(CONSNTCONSNT2Q132I10_Q132D,8.0);
IDU_med=input(CONSNTCONSNT2Q132I10_Q132E,8.0);
IDU_poppy=input(CONSNTCONSNT2Q132I10_Q132F,8.0);
IDU_heroin=input(CONSNTCONSNT2Q132I10_Q132G,8.0);
IDU_alcohol=input(CONSNTCONSNT2Q132I10_Q132H,8.0);
IDU_cocaine=input(CONSNTCONSNT2Q132I10_Q132I,8.0);
IDU_crack=input(CONSNTCONSNT2Q132I10_Q132J,8.0);
IDU_psych=input(CONSNTCONSNT2Q132I10_Q132K,8.0);
IDU_ecstasy=input(CONSNTCONSNT2Q132I10_Q132L,8.0);
IDU_otherdrug=CONSNTCONSNT2Q132I10_Q132M;
IDU_drug_DK=input(CONSNTCONSNT2Q132I10_Q132N,8.0);
IDU_drug_RF=input(CONSNTCONSNT2Q132I10_Q132O,8.0);*/
sex_num=input(CONSENT_CONSENT2_Q133_SP1,8.0);
sex_STI=input(CONSENT_CONSENT2_Q134_SP2,8.0);
sex_HBV=input(CONSENT_CONSENT2_Q135_SP3,8.0);
sex_HCV=input(CONSENT_CONSENT2_Q136_SP4,8.0);
sex_HIV=input(CONSENT_CONSENT2_Q137_SP5,8.0);
condom=input(CONSENT_CONSENT2_Q138_SP6,8.0);
/*sex_healthcare=input(CONSNTCNSENT2Q139SP7_Q139A,8.0);
sex_military=input(CONSNTCNSENT2Q139SP7_Q139B,8.0);
sex_police=input(CONSNTCNSENT2Q139SP7_Q139C,8.0);
sex_dialysis=input(CONSNTCNSENT2Q139SP7_Q139D,8.0);
sex_IDU=input(CONSNTCNSENT2Q139SP7_Q139E,8.0);
sex_CSW=input(CONSNTCNSENT2Q139SP7_Q139F,8.0);
sex_none=input(CONSNTCNSENT2Q139SP7_Q139G,8.0);
sex_RF=input(CONSNTCNSENT2Q139SP7_Q139H,8.0);*/
/*tattoo_salon=input(CONSENTCONSENT2Q13R3_Q113A,8.0);
tattoo_home=input(CONSENTCONSENT2Q13R3_Q113B,8.0);
tattoo_prison=input(CONSENTCONSENT2Q13R3_Q113C,8.0);
tattoo_other=input(CONSENTCONSENT2Q13R3_Q113D,8.0);
tattoo_DK=input(CONSENTCONSENT2Q13R3_Q113E,8.0);*/
MSM=input(CONSENT_CONSENT2_Q140_SP8,8.0);
MSM_condom=input(CONSENT_CONSENT2_Q141_SP9,8.0);
int_ID_NCD=Q142_PB1;
nurse_ID=Q143_PB2;
consent_NCD=input(Q144_PB3,8.0);
consent_blood=input(Q145_PB4,8.0);
consent_bank=input(Q147_PB6,8.0);
phone_results=Q148_PB7;
address_results=Q149_PB8;
BP_ID=Q150_PB9;
cuff=input(Q151_PB10,8.0);
*;cuff_other_specify=Q151A_PB10;
BP_s1=input(Q152_PB11,8.0);
BP_d1=input(Q152_PB12,8.0);
BPM1=input(Q152_PB13,8.0);
BP_s2=input(Q153_PB14,8.0);
BP_d2=input(Q153_PB15,8.0);
BPM2=input(Q153_PB16,8.0);
BP_s3=input(Q154_PB17,8.0);
BP_d3=input(Q154_PB18,8.0);
BPM3=input(Q154_PB19,8.0);
BP_treat=input(Q155_PB20,8.0);
height_ID=Q156A_PB21;
weight_ID=Q156B_PB22;
height_cm=input(Q157_PB23,8.0);
kyphotic=input(Q157A_PB23A,8.0);
weight_kg=input(Q158_PB24,8.0);
pregnant=input(Q159_PB25,8.0);
waist_ID=Q160_PB26;
waist_cm=input(Q161_PB27,8.0);
hip_cm=input(Q162_PB28,8.0);
blood_collected=input(Q163_PB29,8.0);
disposition=input(Q164_EXIT1,8.0);
disposition_other_specify=Q164A_EXIT1_OTHER;
blood_time=Q165_PB31;
run;

*Labeling variables;;
data HCV9.HCVlabel; set HCV9.HCVrecode; 
	label barcode = 'Barcode';
	label int_id_quest = 'Interviewer ID for behavioral questionnaire';
	label f_name = 'First name';
	label age = 'Age of participant';
	label gender = 'Gender';
	label education = 'What is the highest level of education you have completed?';
	label alc_occasions = 'During the past 30 days, on how many drinking occasions did you have at least one alcoholic drink?';
	label alc_drinks = 'During the past 30 days, when you drank alcohol, on average, how many standard alcoholic drinks did you have during one drinking occasion?';
	label alc_max = 'During the past 30 days, what was the largest number of standard alcoholic drinks you had on a single occasion?';
	label alc_male = '(Males) During the past 30 days, how many times did you have 5 or more standard alcoholic drinks in a single drinking occasion?';
	label alc_female = '(Females) During the past 30 days, how many times did you have 4 or more standard alcoholic drinks in a single drinking occasion?';
	label walk_bike_lastweek = 'Have you walked or used a bicycle for at least 10 minutes continuously to get to and from places in the last week?';
	label walk_bike_typicalweek = 'In a typical week, on how many days do you walk or bicycle for at least 10 minutes continuously to get to and from places?';
	label walk_bike_typicalday = 'How much time do you spend walking or bicylcling for travel on a typical day?';
	label smoke_current_freq = 'Do you currently smoke tobacco...';
	label smoke_past = 'Have you smoked tobacco daily in the past?';
	label smoke_past_freq = 'In the past, have you smoked tobacco...';
	label cig_num = 'Number of manufactured cigarettes';
	label cig_day_week = 'Manufactured cigarettes counted per day/week';
	label hand_cig_num = 'Number of hand rolled cigarettes';
	label hand_cig_day_week = 'Hand rolled cigarettes counted per day/week';
	label pipe_num = 'Number of pipes full of tobacco';
	label pipe_day_week = 'Pipes counted per day/week';
	label cigar_num = 'Number of cigars, cheroots, or cigarillos';
	label cigar_day_week = 'Cigars, cheroots, or cigarillos counted per day/week';
	label smoke_other = 'Other tobacco products (specify)';
	label smoke_other_num = 'Number of other tobacco products';
	label smoke_other_day_week = 'Other tobacco products counted per day/week';
	label prison = 'Have you ever been in prison or jail?';
	label tattoo = 'Do you have any tattoos? If so, how many?';
	label tattoo_other_specify = 'If you got a tattoo somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label tattoo_needle = 'Do you know if the people who gave you your tattoo(s) used new needles, or did they use needles that had been used before?';
	label tattoo_ink = 'Do you know if the people who gave you your tattoo(s)used a new bottle of ink, or a bottle of ink that had already  been opened and
						used for someone else?';
	label piercing = 'Do you have any body piercings? If yes, how many?';
	label piercing_other_specify = 'If you got a body piercing somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label piercing_needle = 'Do you know if the people who gave you the piercing(s) used a new needle or piercing instrument, or one that had been used before?';
	label manicure_num = 'In the last 6 months, how many times have you received a manicure or pedicure at a beauty salon or through a home service?';
	label barber_num = 'In a typical month, how many times do you go to a barber or a beauty salon to get shaved?';
	label shave_other_specify = 'If you typically get shaved somewhere else (other than a barber, beauty salon, or at home), please state where';
	label shave_barber = 'Barber or beauty salon (Where do you typically shave or get shaved?)';
	label shave_home = 'Home (Where do you typically shave or get shaved?)';
	label shave_none = 'I do not shave (Where do you typically shave or get shaved?)';
	label shave_other = 'Somewhere else (Where do you typically shave or get shaved?)';
	label shave_razor = 'When you go to the barber do you know whether you are being shaved with new razors, or razors that ahve been used before?';
	label IDU_ever = 'Have you ever injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_life = 'About how many times if your life have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_6mo = 'In the last 6 months, how often have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_age_start = 'How old were you when you first injected drugs or narcotics for nonmedical reasons?';
	label IDU_needle_NEP = 'Needle exchange program (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_store = 'Drug store or other medical goods supplier (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_order = 'Mail or internet order (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_borrow = 'Borrowed from a friend or family member (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_rent = 'Purchased or rented from someone (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_found = 'A needle and/or syringe I found (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_DK = 'Do not know/remember (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_none = 'None of the above (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_refused = 'Refused (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_share1 = 'Have you ever used someone elses needle and/or syringe after they used it?';
	label IDU_share1_num = 'How many times have you ever used someone elses needle and/or syringe after they used it?';
	label birthday = 'Birth day/month';
	label birthyear = 'Birth year';
	label heprisk_toothbrush = 'Toothbrush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_razor = 'Razor blades (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_scissors = 'Scissors (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_brush = 'Shaving brush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_nail = 'Nail cutter (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_none = 'None of the above (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_DK = 'Dont know/remember (Which of the following articles have you used in common with other members of your household?)';
	label IDU_share2 = 'Have you ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_share2_num = 'How many times havey ou ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_vent = 'Vent (Which of the following drugs have you injected using a needle?)';
	label IDU_jeff = 'Jeff (Which of the following drugs have you injected using a needle?)';
	label IDU_krokodil = 'Krokodil (Which of the following drugs have you injected using a needle?)';
	label IDU_opium = 'Opium (Which of the following drugs have you injected using a needle?)';
	label IDU_med = 'Medical/synthetic drugs (Which of the following drugs have you injected using a needle?)';
	label IDU_poppy = 'Poppy straw (Which of the following drugs have you injected using a needle?)';
	label IDU_heroin = 'Heroin (Which of the following drugs have you injected using a needle?)';
	label IDU_alcohol = 'Alcohol (Which of the following drugs have you injected using a needle?)';
	label IDU_cocaine = 'Cocaine (Which of the following drugs have you injected using a needle?)';
	label IDU_crack = 'Crack (Which of the following drugs have you injected using a needle?)';
	label IDU_psych = 'Psychoactive or hallucinogenic substances (Which of the following drugs have you injected using a needle?)';
	label IDU_ecstasy = 'Ecstasy (Which of the following drugs have you injected using a needle?)';
	label IDU_otherdrug = 'Other (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_DK = 'Dont know/remember (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_RF = 'Refused to answer (Which of the following drugs have you injected using a needle?)';
	label sex_num = 'How many sexual partners have you had in your lifetime?';
	label sex_STI = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with any sexually transmitted infections?';
	label sex_HBV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HBV?';
	label sex_HCV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HCV?';
	label sex_HIV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HIV?';
	label condom = 'In your lifetime, how often have you used condoms with your sexual partners?';
	label sex_healthcare = 'Healthcare or emergency worker who comes into contact with blood (In your lifetime, have any of your sexual partners belonged to the
							following groups?)';
	label sex_military = 'Military (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_police = 'Police (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_dialysis = 'Person who regularly receives kidney dialysis, blood transfusions, or has hemophilia (In your lifetime, have any of your sexual 
						  partners belonged to the following groups?)';
	label sex_IDU = 'Injection drug user (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_CSW  = 'Commercial sex worker (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_none = 'None of the above (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_RF = 'Refused (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label tattoo_salon = 'Beauty salon or tattoo salon (Where did you get your tattoo(s)?)';
	label tattoo_home = 'Home (Where did you get your tattoo(s)?)';
	label tattoo_prison = 'Prison (Where did you get your tattoo(s)?)';
	label tattoo_other = 'Somewhere else (Where did you get your tattoo(s)?)';
	label tattoo_DK = 'Dont know/remember (Where did you get your tattoo(s)?)';
	label MSM = '(Men) Have you ever had sex with another man?';
	label MSM_condom = 'How often do you use condoms with your same sex partner(s)?';
	label int_ID_NCD = 'Interviewer ID for NCD section';
	label nurse_ID = 'Nurse ID';
	label consent_NCD = 'Would you be willing to have your height, weight and blood pressure taken today?';
	label consent_blood = 'Would you be willing to give a blood sample for hepatitis C and B testing?';
	label consent_bank = 'If there is any remaining blood left over after testing for hepatitis, can it be used to test for other diseases
                          of public health interest?';
	label phone_results = 'Contact phone number to return results';
	label address_results = 'Mailing address, or best way to reach for returning results';
	label ethnicity = 'Ethnicity';
	label BP_ID = 'Blood pressure device ID';
	label cuff = 'Cuff size used for blood pressure';
	label cuff_other_specify = 'If other cuff size was used for blood pressure, please specify';
	label BP_s1 = 'BP reading 1: Systolic (mmHg)';
	label BP_d1 = 'BP reading 1: Diastolic (mmHg)';
	label BPM1 = 'BP reading 1: Beats per minute';
	label BP_s2 = 'BP reading 2: Systolic (mmHg)';
	label BP_d2 = 'BP reading 2: Diastolic (mmHg)';
	label BPM2 = 'BP reading 2: Beats per minute';
	label BP_s3 = 'BP reading 3: Systolic (mmHg)';
	label BP_d3 = 'BP reading 3: Diastolic (mmHg)';
	label BPM3 = 'BP reading 3: Beats per minute';
	label BP_treat = 'During the past 2 weeks, have you been treated for raised blood pressure with drugs (medication) prescribed
                      by a doctor or other health worker?';
	label height_ID = 'Height device ID';
	label weight_ID = 'Weight device ID';
	label height_cm = 'Participant height in cm';
	label kyphotic = 'Is participant kyphotic (their back is hunched over due to age or spinal malformation)?';
	label weight_kg = ' Participant weight in kg';
	label pregnant = '(Women) Is the participant pregnant?';
	label ethnicity_other_specify = 'If ethnicity recorded as other, please specify';
	label religion = 'Religion';
	label waist_ID = 'Waist device ID';
	label waist_cm = 'Participant waist circumference in cm';
	label hip_cm = 'Participant hip circumference in cm';
	label blood_collected = 'Was a 10ml tiger top tube collected?';	
	label blood_time = 'Time of day blood specimen collected (24 hour clock)';
	label religion_other_specify = 'If religion recorded as other, please specify';
	label married = 'Marital status';
	label piercing_salon = 'Beauty salon or tattoo salon (Where did you get your body piercing(s)?)';
	label piercing_home = 'Home (Where did you get your body piercing(s)?)';
	label piercing_prison = 'Prison (Where did you get your body piercing(s)?)';
	label piercing_other = 'Somewhere else (Where did you get your body piercing(s)?)';
	label piercing_DK = 'Dont know/remember (Where did you get your body piercing(s)?)';
	label work = 'Which of hte following best describes your main work status over hte past year?';
	label work_healthcare = 'Health care (In your lifetime, have you ever worked in any of the following fields?)';
	label work_military = 'Military (In your lifetime, have you ever worked in any of the following fields?)';
	label work_police = 'Police (In your lifetime, have you ever worked in any of the following fields?)';
	label manicure_salon = 'Beauty salon (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_homeservice = 'Home service (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_self = 'I always perform my own manicures and pedicures (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_never = 'I have never had a manicure or pedicure (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_other = 'Somewhere else (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label house = 'Does your family rent, or own the house you live in?';
	label house_other_specify =  'If rent/own was recorded as other, please specify';
	label resident_num = 'How many people older than 18 years, including yourself, live permanently in your household?';
	label earnings_cat = 'Income category - GEL per week/month/year';
	label earnings_amount = 'In the last year, can you tell me what the average earnings of your household have been?';
	label earnings_estimate = 'If you do not know the exact amount, can you give an estimate of your households monthly earning?' ;
	label earners_num = 'How many people earn money in your household?';
	label insurance = 'Do you currently have medical insurance?';
	label insurance_type = 'What kind of health insurance do you have?';
	label medcare_pay = 'How do you pay for medical care when you need it?';
	label medcare_pay_other_specify = 'If medical care payment was recorded as other, please specify';
	label displaced = 'Have you ever been forced to move from your house because of war or civil unrest?';
	label medcare_location = 'Where do you go for medical care when you need it?';
	label medcare_location_other_specify = 'If medical care location was recorded as other, please specify';
	label flu = 'Last winter, October 2014 to April 2015, did you have a severe respiratory illness, with a sudden onset fever and cough that made you 
	            short of breath or caused you to have difficulty breathing?';
	label flu_polyclinic = 'Polyclinic (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_hospital = 'Hospital (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_medhome = 'Health care provider comes to my house (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_pharmacy = 'Pharmacy (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_villagedoc = 'Village doctor (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_none = 'I do not seek care when I am sick or injured (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_other = 'Other (If yes to severe respiratory illness, where did you go for medical care?)';
	label hh_num = 'Household number';
	label hospital_lifetime_num = 'During your lifetime, how many times have you been admitted to the hospital for any reason?';
	label dentist_cat = 'How often do you visit the dentist to have your teeth cleaned?';
	label dentist_other_specify = 'If dental location was recorded as other, please specify'; 
	label dentist_hospital = 'Hospital (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_cabinet = 'Dental cabinet (Have you ever visited the dentist or had a dental procedure in any of the following locations?');
	label dentist_home = 'Someones home (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_other = 'Other (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_DK = 'Do not know/remember (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';;
	label dental_proc_num = 'How many invasive dental procedures have you had in your lifetime?';
	label shot_num = 'How many shots have you received in the last 6 months, including immunizations and medication to numb you before a medical
                    or dental procedure?';
	label flushot = 'Did you receive a flu shot during the last (2014-2015) influenza season?';
	label flushot_loc = 'If yes to flu shot, where did you receive it?';
	label shot_admin = 'Who administered your last shot?';
	label shot_admin_other = 'If shot administration was recorded as other, please specify';
	label shot_needle = 'Before you received this last shot, did you see where the needle and/or syringe was taken from?';
	label shot_needle_other_specify = 'If shot needle/syringe source was recorded as other, please specify';
	label shot_purpose = 'Why did you get this last shot?';
	label shot_purpose_other_specify = 'If shot purpose was recorded as other, please specify';
	label shot_med = 'What medication was injected in this last shot?';
	label shot_med_other_specify = 'If shot medication was recorded as other, please specify';
	label shot_discard = 'Did they throw the syringe away after your shot?';
	label stratum_num = 'Stratum number';
	label cluster_ID = 'Cluster ID';
	label cluster_name = 'Cluster, city, or village name';
	label IV_num = 'How many IV infusions have you received in the last 6 months?';
	label dialysis_ever = 'In your lifetime, have you ever received dialysis for your kidneys?';
	label dialysis_polyclinic = 'Polyclinic (In what type of facilities have you received kidney dialysis?)';
	label dialysis_hospital = 'Hospital (In what type of facilities have you received kidney dialysis?)';
	label dialysis_home = 'Helath care provider comes to my house (In what type of facilities have you received kidney dialysis?)';
	label dialysis_pharmacy = 'Pharmacy (In what type of facilities have you received kidney dialysis?)';
	label dialysis_villagedoc = 'Village doctor (In what type of facilities have you received kidney dialysis?)';
	label dialysis_other = 'Other (In what type of facilities have you received kidney dialysis?)';
	label dialysis_current = 'Do you currently receive dialysis for your kidneys?';
	label dialysis_freq = 'How many times a week do you receive dialysis for your kidneys?';
	label blood_trans = 'Have you received any blood transfusions in your lifetime?';
	label blood_trans_num = 'How many times in your life have you received a transfusion of blood or blood products?';
	label blood_trans_relative = 'Did any of your blood transfusions come from a friend or relative?';
	label blood_donate = 'Have you ever donated blood?';
	label blood_donate_relative = 'Have you ever donated blood to a relative or friend who needed it?';
	label int_date = 'Confirm interview date';
	label blood_donate_money = 'Have you ever donated blood in exchange for money?';
	label med_invasive = 'During your lifetime, have you ever had an invasive medical procedure?';
	label surgery_ever = 'During your lifetime, have you ever had any type of surgery?';
	label surgery_num = 'During your lifetime, how many surgeries have you had?';
	label surgery_hospital = 'Hospital (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_nursing = 'Nursing home (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_polyclinic = 'Polyclinic (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_other = 'Other (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_DK = 'Do not know/remember (Have you ever had surgery in any of the following locations during your lifetime?)';
	label sti_ever = 'Have you ever been told by a doctor or other health worker that you had a sexually transmitted disease?';
	label sti_syphilis = 'Syphilis (Which sexually transmitted disease have you been diagnosed with?');
	label sti_gonorrhea = 'Gonorrhea (Which sexually transmitted disease have you been diagnosed with?');
	label sti_chlamydia = 'Chlamydia (Which sexually transmitted disease have you been diagnosed with?');
	label sti_herpes = 'Herpes (Which sexually transmitted disease have you been diagnosed with?');
	label sti_warts = 'Genital warts (Which sexually transmitted disease have you been diagnosed with?');
	label sti_other = 'Other (Which sexually transmitted disease have you been diagnosed with?');
	label HIV_test = 'Have you ever been tested for HIV, the virus that causes AIDS?';
	label HIV_result = 'What were your HIV test results?';
	label tb_ever = 'Have you ever been told by a doctor or other health worker that you have tuberculosis?';
	label int_start_time = 'Interview start time';
	label tb_year = 'Have you been told that you have tuberculosis in the past 12 months?';
	label tb_treat = 'Have you ever been treated for your tuberculosis?';
	label bp_meas = 'Have you ever had your blood pressure measured by a doctor or other health worker?';
	label hypertension_ever = 'Have you ever been told by a doctor or other health worker that you have raised blood pressure or hypertension?';
	label hypertension_year = 'Have you been told that you have raised blood pressure or hypertension in the past 12 months?';
	label sugar_meas = 'Have you ever had your blood sugar measured by a doctor or other health worker?';
	label diabetes_ever = 'Have you ever been told by a doctor or other health worker that you have high blood sugar or diabetes?';
	label diabetes_year = 'Have you been told that you have raised blood sugar or diabetes in the past 12 months?';
	label insulin_current = 'Are you currently taking insulin therapy?';
	label sugar_test_share = 'Have you ever tested your blood sugar using a needle that you shared with others?';
	label consent_int = 'Consent given for interview?';
	label insulin_syringe_share = 'Have you ever shared insulin syringes with others?';
	label chronic_asthma = 'Asthma (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_arthritis = 'Arthritis (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_cancer = 'Cancer (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_CVD = 'Cardiovascular disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_COPD = 'Chronic obstructive pulmonary disease (COPD) (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_hemophilia = 'Hemophilia or other blood disorders (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_thyroid = 'Thyroid problems (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_kidney = 'Kidney disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_lung = 'Lung disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other = 'Other (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other_specify = 'If other chronic condition was recorded, please state what type';
	label cancer_type = 'If cancer was recorded, please state what type';
	label HCV_heard = 'Have you ever heard of the hepatitis C virus, or HCV?';
	label HCV_trans_droplets = 'Droplets (Do you know how HCV is transmitted?)';
	label HCV_trans_food = 'Food (Do you know how HCV is transmitted?)';
	label HCV_trans_blood = 'Blood  (Do you know how HCV is transmitted?)';
	label HCV_trans_sex = 'Sexual contact (Do you know how HCV is transmitted?)';
	label HCV_trans_handshake = 'Handshake with an infected person (Do you know how HCV is transmitted?)';
	label HCV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HCV is transmitted?)';
	label HCV_trans_needle = 'Sharing needles or syringes (Do you know how HCV is transmitted?)';
	label HCV_trans_touch = 'Touching items in public places (Do you know how HCV is transmitted?)';
	label HCV_trans_DK = 'Do not know/remember (Do you know how HCV is transmitted?)';
	label HCV_trans_none = 'None of the above (Do you know how HCV is transmitted?)';
	label HCV_trans_other = 'Other (Do you know how HCV is transmitted?)';
	label HCV_trans_other_specify = 'If other mode of HCV transmission was recorded, please state how';
	label HCV_asymptomatic = 'Is it possible to have HCV but not have any symptoms?';
	label HCV_med = 'Are there medications available to treat HCV infections?';
	label trust_family = 'Talking with family members, friends, neighbors or colleagues (Where do you get health information that you trust?)';
	label trust_medlit = 'Special medical literature (Where do you get health information that you trust?)';
	label trust_newspaper = 'Newspapers and magazines (Where do you get health information that you trust?)';
	label trust_radio = 'Radio (Where do you get health information that you trust?)';
	label trust_tv = 'TV (Where do you get health information that you trust?)';
	label trust_internet = 'Internet (Where do you get health information that you trust?)';
	label trust_billboards = 'Billboards (Where do you get health information that you trust?)';
	label trust_brochures = 'Brochures, fliers, posters, or other printed materials (Where do you get health information that you trust?)';
	label trust_doctor = 'Doctors and other healthcare workers (Where do you get health information that you trust?)';
	label trust_pharmacist = 'Pharmacists (Where do you get health information that you trust?)';
	label trust_DK = 'Do not know/remember (Where do you get health information that you trust?)';
	label trust_none = 'None of the above (Where do you get health information that you trust?)';
	label trust_other = 'Other (Where do you get health information that you trust?)';
	label trust_other_specify = 'If other source of HCV information was recorded, please specify';
	label HBV_heard = 'Have you ever heard of the hepatitis B virus?';
	label consent_demo = 'If consent not given for interview, is participant OK giving basic demographic information?';
	label HCV_prev_vacc = 'Get a vaccination (What can you do to prevent HCV infection?)';
	label HCV_prev_condom = 'Use condoms (What can you do to prevent HCV infection?)';
	label HCV_prev_needle = 'Avoid sharing syringes or needles with other people (What can you do to prevent HCV infection?)';
	label HCV_prev_wash = 'Wash hands thoroughly (What can you do to prevent HCV infection?)';
	label HCV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to prevent HCV infection?)';
	label HCV_prev_DK = 'Do not know/remember (What can you do to prevent HCV infection?)';
	label HCV_prev_other = 'Other (What can you do to prevent HCV infection?)';
	label HCV_prev_none = 'None of the above (What can you do to prevent HCV infection?)';
	label language = 'Interview language';
	label HBV_trans_droplets = 'Droplets (Do you know how HBV is transmitted?)';
	label HBV_trans_food = 'Food (Do you know how HBV is transmitted?)';
	label HBV_trans_blood = 'Blood (Do you know how HBV is transmitted?)';
	label HBV_trans_sex = 'Sexual contact (Do you know how HBV is transmitted?)';
	label HBV_trans_handshake = 'Handshake with an infected person (Do you know how HBV is transmitted?)';
	label HBV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HBV is transmitted?)';
	label HBV_trans_needle = 'Sharing needles or syringes (Do you know how HBV is transmitted?)';
	label HBV_trans_touch = 'Touching items in public places (Do you know how HBV is transmitted?)';
	label HBV_trans_DK = 'Dont know/Remember (Do you know how HBV is transmitted?)';
	label HBV_trans_none = 'None of the above (Do you know how HBV is transmitted?)';
	label HBV_trans_other = 'Other (Do you know how HBV is transmitted?)';
	label HBV_trans_other_specify = 'If HBV transmission mode recorded as other, please state how';
	label HBV_asymptomatic = 'Is it possible to have HBV but not have any symptoms?';
	label HBV_med = 'Are there medications available to reat HBV infections?';
	label HBV_prev_vacc = 'Get a vaccination (What can you do to help prevent HBV infection?)';
	label HBV_prev_condom = 'Use condoms (What can you do to help prevent HBV infection?)';
	label HBV_prev_needle = 'Avoid sharing needles and syringes (What can you do to help prevent HBV infection?)';
	label HBV_prev_wash = 'Wash hads frequently (What can you do to help prevent HBV infection?)';
	label HBV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to help prevent HBV infection?)';
	label HBV_prev_DK = 'Dont know/Remember (What can you do to help prevent HBV infection?)';
	label HBV_prev_none = 'None of the above (What can you do to help prevent HBV infection?)';
	label HCV_ever = 'Have you ever been told by a doctor or other health worker that you have hepatitis C?';
	label HCV_year = 'What year were you told that you had hepatitis C?';
	label HCV_treated = 'Have you ever taken medications to treat your hepatitis C infection?';
	label HCV_notreat_avail = 'The medication was not available (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_eligible = 'My doctor told me I was not eligible to take the medication (Why didnt you take medication to treat 
          your hepatitis C infection?)';
	label HCV_notreat_expense = 'The medication was too expensive (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_effect = 'I heard that the medication has a lot of side effects (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_inject = 'I did not want to inject myself with a needle (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_other_specify = 'Other, specify ((Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_DK = 'Dont know/remember (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_RF = 'Refused (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_travel = 'I would ahve to travel too far to get the medication, or to see hte doctor in order to get
	      the medication (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_treat_complete = 'Did you complete your hepatitis C treatment, or did you stop before the end?';
	label HCV_cured = 'Did the treatment cure your hepatitis C infection?';
	label surname = 'Family surname';
	label HBV_ever = 'Have you been told by a doctor or other health worker that you have hepatitis B?';
	label HBV_year = 'What year were you told that you have hepatitis B?';
	label HBV_treated = 'Have you ever taken medications to treat your hepatitis B infection?';
	label HBV_vacc_ever = 'Have you ever been vaccinated against hepatitis B infection?';
	label hep_other_A = 'Hepatitis A (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';
	label hep_other_D = 'Hepatitis D (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_E = 'Hepatitis E (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_none = 'None (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_year = 'What year were you told that you had this other type of hepatitis?';
	label alc_ever = 'Have you ever consumed an alcoholic drink such as beer, wine, or spirits?';
	label alc_year = 'Have you consumed an alcoholic drink within the past 12 months?' ;
	label alc_year_freq = 'During the past 12 months, how frequently have you had at least one alcoholic drink?';
	label alc_month = 'Have you consumed an alcoholic drink within the past 30 days?';
	label disposition = 'Interview disposition: Did you complete the entire questionnaire?';
	label disposition_other_specify = 'If interview disposition recorded as other, please specify';

	run;

*Dropping variables;;
data HCV9.HCVformat;
set HCV9.HCVlabel (drop=
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C

CONSENT_Q22_D12

CONSENT_CONSENT2_Q32_M4_Q32A
CONSENT_CONSENT2_Q32_M4_Q32B
CONSENT_CONSENT2_Q32_M4_Q32C
CONSENT_CONSENT2_Q32_M4_Q32D
CONSENT_CONSENT2_Q32_M4_Q32E

CONSENT_CONSENT2_Q42_M15_Q42A
CONSENT_CONSENT2_Q42_M15_Q42B
CONSENT_CONSENT2_Q42_M15_Q42C
CONSENT_CONSENT2_Q42_M15_Q42D
CONSENT_CONSENT2_Q42_M15_Q42E
CONSENT_CONSENT2_Q42_M15_Q42G

CONSENT_CONSENT2_Q54_S4_Q54A
CONSENT_CONSENT2_Q54_S4_Q54B
CONSENT_CONSENT2_Q54_S4_Q54C
CONSENT_CONSENT2_Q54_S4_Q54D
CONSENT_CONSENT2_Q54_S4_Q54E

CONSENT_CONSENT2_Q56_STI2_Q56A
CONSENT_CONSENT2_Q56_STI2_Q56B
CONSENT_CONSENT2_Q56_STI2_Q56C
CONSENT_CONSENT2_Q56_STI2_Q56D
CONSENT_CONSENT2_Q56_STI2_Q56E
CONSENT_CONSENT2_Q56_STI2_Q56F

CONSENT_CONSENT2_Q71_CD1_Q71A
CONSENT_CONSENT2_Q71_CD1_Q71B
CONSENT_CONSENT2_Q71_CD1_Q71C
CONSENT_CONSENT2_Q71_CD1_Q71D
CONSENT_CONSENT2_Q71_CD1_Q71E
CONSENT_CONSENT2_Q71_CD1_Q71F
CONSENT_CONSENT2_Q71_CD1_Q71G
CONSENT_CONSENT2_Q71_CD1_Q71H
CONSENT_CONSENT2_Q71_CD1_Q71I
CONSENT_CONSENT2_Q71_CD1_Q71J
CONSENT_CONSENT2_Q71_CD1_Q71K

CONSENT_CONSENT2_Q74_H2_Q74A
CONSENT_CONSENT2_Q74_H2_Q74B
CONSENT_CONSENT2_Q74_H2_Q74C
CONSENT_CONSENT2_Q74_H2_Q74D
CONSENT_CONSENT2_Q74_H2_Q74E
CONSENT_CONSENT2_Q74_H2_Q74F
CONSENT_CONSENT2_Q74_H2_Q74G
CONSENT_CONSENT2_Q74_H2_Q74H
CONSENT_CONSENT2_Q74_H2_Q74I
CONSENT_CONSENT2_Q74_H2_Q74J
CONSENT_CONSENT2_Q74_H2_Q74K

CONSENT_CONSENT2_Q77_H5_Q77A
CONSENT_CONSENT2_Q77_H5_Q77B
CONSENT_CONSENT2_Q77_H5_Q77C
CONSENT_CONSENT2_Q77_H5_Q77D
CONSENT_CONSENT2_Q77_H5_Q77E
CONSENT_CONSENT2_Q77_H5_Q77F
CONSENT_CONSENT2_Q77_H5_Q77G
CONSENT_CONSENT2_Q77_H5_Q77H
CONSENT_CONSENT2_Q78_H6_Q78A
CONSENT_CONSENT2_Q78_H6_Q78B
CONSENT_CONSENT2_Q78_H6_Q78C
CONSENT_CONSENT2_Q78_H6_Q78D
CONSENT_CONSENT2_Q78_H6_Q78E
CONSENT_CONSENT2_Q78_H6_Q78F
CONSENT_CONSENT2_Q78_H6_Q78G
CONSENT_CONSENT2_Q78_H6_Q78H
CONSENT_CONSENT2_Q78_H6_Q78I
CONSENT_CONSENT2_Q78_H6_Q78J
CONSENT_CONSENT2_Q78_H6_Q78K
CONSENT_CONSENT2_Q78_H6_Q78L
CONSENT_CONSENT2_Q78_H6_Q78M

CONSENT_CONSENT2_Q80_H8_Q80A
CONSENT_CONSENT2_Q80_H8_Q80B
CONSENT_CONSENT2_Q80_H8_Q80C
CONSENT_CONSENT2_Q80_H8_Q80D
CONSENT_CONSENT2_Q80_H8_Q80E
CONSENT_CONSENT2_Q80_H8_Q80F
CONSENT_CONSENT2_Q80_H8_Q80G
CONSENT_CONSENT2_Q80_H8_Q80H
CONSENT_CONSENT2_Q80_H8_Q80I
CONSENT_CONSENT2_Q80_H8_Q80J
CONSENT_CONSENT2_Q80_H8_Q80K

CONSENT_CONSENT2_Q83_H11_Q83A
CONSENT_CONSENT2_Q83_H11_Q83B
CONSENT_CONSENT2_Q83_H11_Q83C
CONSENT_CONSENT2_Q83_H11_Q83D
CONSENT_CONSENT2_Q83_H11_Q83E
CONSENT_CONSENT2_Q83_H11_Q83F
CONSENT_CONSENT2_Q83_H11_Q83G

CONSENT_CONSENT2_Q87_H15_Q87A
CONSENT_CONSENT2_Q87_H15_Q87B
CONSENT_CONSENT2_Q87_H15_Q87C
CONSENT_CONSENT2_Q87_H15_Q87D
CONSENT_CONSENT2_Q87_H15_Q87E
CONSENT_CONSENT2_Q87_H15_Q87F
CONSENT_CONSENT2_Q87_H15_Q87G
CONSENT_CONSENT2_Q87_H15_Q87H
CONSENT_CONSENT2_Q87_H15_Q87I

CONSENT_CONSENT2_Q94_H22_Q94A
CONSENT_CONSENT2_Q94_H22_Q94B
CONSENT_CONSENT2_Q94_H22_Q94C
CONSENT_CONSENT2_Q94_H22_Q94D
CONSENT_CONSENT2_Q94_H22_Q94E

CONSENT_CONSENT2_Q110_T4_Q110A
CONSENT_CONSENT2_Q110_T4_Q110B
CONSENT_CONSENT2_Q110_T4_Q110C
CONSENT_CONSENT2_Q110_T4_Q110D
CONSENT_CONSENT2_Q110_T4_Q110E
CONSENT_CONSENT2_Q110_T4_Q110F
CONSENT_CONSENT2_Q110_T4_Q110G
CONSENT_CONSENT2_Q110_T4_Q110H
CONSENT_CONSENT2_Q110_T4_Q110I
CONSENT_CONSENT2_Q110_T4_Q110J
CONSENT_CONSENT2_Q110_T4_Q110K

CONSENT_CONSENT2_Q117_R7_Q117A
CONSENT_CONSENT2_Q117_R7_Q117B
CONSENT_CONSENT2_Q117_R7_Q117C
CONSENT_CONSENT2_Q117_R7_Q117D
CONSENT_CONSENT2_Q117_R7_Q117E

CONSENT_CONSENT2_Q119_R9_Q119A_
CONSENT_CONSENT2_Q119_R9_Q119B_
CONSENT_CONSENT2_Q119_R9_Q119C_
CONSENT_CONSENT2_Q119_R9_Q119D_
CONSENT_CONSENT2_Q119_R9_Q119E_
CONSENT_CONSENT2_Q120A_R10A

CONSENT_CONSENT2_Q120_R10_Q120A  
CONSENT_CONSENT2_Q120_R10_Q120B  
CONSENT_CONSENT2_Q120_R10_Q120C  
CONSENT_CONSENT2_Q120_R10_Q120D  

CONSENT_CONSENT2_Q122_R12_Q122A
CONSENT_CONSENT2_Q122_R12_Q122B
CONSENT_CONSENT2_Q122_R12_Q122C
CONSENT_CONSENT2_Q122_R12_Q122D
CONSENT_CONSENT2_Q122_R12_Q122E
CONSENT_CONSENT2_Q122_R12_Q122F
CONSENT_CONSENT2_Q122_R12_Q122G 

CONSENT_CONSENT2_Q127_I5_Q127A
CONSENT_CONSENT2_Q127_I5_Q127B
CONSENT_CONSENT2_Q127_I5_Q127C
CONSENT_CONSENT2_Q127_I5_Q127D
CONSENT_CONSENT2_Q127_I5_Q127E
CONSENT_CONSENT2_Q127_I5_Q127F
CONSENT_CONSENT2_Q127_I5_Q127G
CONSENT_CONSENT2_Q127_I5_Q127H
CONSENT_CONSENT2_Q127_I5_Q127I

CONSENT_CONSENT2_Q132_I10_Q132A
CONSENT_CONSENT2_Q132_I10_Q132B
CONSENT_CONSENT2_Q132_I10_Q132C
CONSENT_CONSENT2_Q132_I10_Q132D
CONSENT_CONSENT2_Q132_I10_Q132E
CONSENT_CONSENT2_Q132_I10_Q132F
CONSENT_CONSENT2_Q132_I10_Q132G
CONSENT_CONSENT2_Q132_I10_Q132H
CONSENT_CONSENT2_Q132_I10_Q132I
CONSENT_CONSENT2_Q132_I10_Q132J
CONSENT_CONSENT2_Q132_I10_Q132K
CONSENT_CONSENT2_Q132_I10_Q132L
CONSENT_CONSENT2_Q132_I10_Q132M
CONSENT_CONSENT2_Q132_I10_Q132N
CONSENT_CONSENT2_Q132_I10_Q132O

CONSENT_CONSENT2_Q139_SP7_Q139A
CONSENT_CONSENT2_Q139_SP7_Q139B
CONSENT_CONSENT2_Q139_SP7_Q139C
CONSENT_CONSENT2_Q139_SP7_Q139D
CONSENT_CONSENT2_Q139_SP7_Q139E
CONSENT_CONSENT2_Q139_SP7_Q139F
CONSENT_CONSENT2_Q139_SP7_Q139G
CONSENT_CONSENT2_Q139_SP7_Q139H
CONSENT_CONSENT2_Q113_R3_Q113A
CONSENT_CONSENT2_Q113_R3_Q113B
CONSENT_CONSENT2_Q113_R3_Q113C
CONSENT_CONSENT2_Q113_R3_Q113D
CONSENT_CONSENT2_Q113_R3_Q113E

/* same variables */

Q0_BARCODE
Q1_I1
Q2A_I2
Q3A_I3
Q3B_I3
Q4_I4
Q5_I5
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
CONSENT_Q9_I9
CONSENT_Q10_I10
Q11_D1
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20_D10
CONSENT_Q20A_D10_OTHER
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
/*CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F*/
CONSENT_CONSENT2_Q30_M2
/*CONSNTCNSENT2Q29CM1C_Q29C_G*/
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q32_M4A
/*CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E*/
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
/*CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G*/
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
/*CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E*/
CONSENT_CONSENT2_Q55_STI1
/*CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F*/
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
/*CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K*/
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
/*CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K*/
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
/*CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H*/
/*CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M*/
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
/*CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K*/
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
/*CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G*/
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
/*CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I*/
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
/*CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E*/
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
/*CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K*/
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
/*CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E*/
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
/*CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9*/
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
/*CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D*/
CONSENT_CONSENT2_Q121_R11
/*CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G*/
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
/*CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I*/
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
/*CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O*/
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
/*CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H*/
/*CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E*/
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9


CONSENT_CONSENT2_PROMPT1
CONSENT_CONSENT2_PROMPT2
CONSENT_CONSENT2_PROMPT3
CONSENT_CONSENT2_PROMPT4
CONSENT_CONSENT2_PROMPT5
CONSENT_CONSENT2_PROMPTB
CONSENT_CONSENT2_PROMPTC
CONSENT_CONSENT2_PROMPTD
CONSENT_CONSENT2_PROMPTE
CONSENT_CONSENT2_PROMPTF
CONSENT_CONSENT2_PROMPTG
CONSENT_CONSENT2_PROMPTH
CONSENT_CONSENT2_PROMPTI
CONSENT_CONSENT2_PROMPTJ
CONSENT_CONSENT2_PROMPTK
CONSENT_CONSENT2_PROMPTL
CONSENT_CONSENT2_PROMPTM
CONSENT_CONSENT2_PROMPTN
CONSENT_CONSENT2_PROMPTO
CONSENT_CONSENT2_PROMPTP


CONSENT_PROMPTA
PROMPT6
PROMPTQ
PROMPTR
_LAST_UPDATE_URI_USER
_MODEL_VERSION
_UI_VERSION
_ORDINAL_NUMBER
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22

Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31

/*var variables (flu variables)*/
var65 var68 var71 var73 var74 var91 CONSENT_CONSENT2_Q29C_M1C_Q29C_ var50 var51 var52 var53 var54 var55
);
run;

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
data HCV10.HCVrecode;
set HCV10.HCVnull;

/*var variables*/
flu_polyclinic=input( Consent_Consent2_Q29c_M1c_Q29c_,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_A*/ 
flu_hospital=input(var50,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_B*/ 
flu_medhome=input(var51,8.0);     /*CONSENT_CONSENT2_Q29C_M1C_Q29C_C*/ 
flu_pharmacy=input(var52,8.0);    /*CONSENT_CONSENT2_Q29C_M1C_Q29C_D*/ 
flu_villagedoc=input(var53,8.0);  /*CONSENT_CONSENT2_Q29C_M1C_Q29C_E*/ 
flu_none=input(var54,8.0);        /*CONSENT_CONSENT2_Q29C_M1C_Q29C_F*/ 

flu_other=var55;



/*sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);*/
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);

earnings_cat=input(CONSENT_Q22_D12,8.0);

/*flu_medhome = CONSENT_CONSENT2_Q29C_M1C_Q29C_;*/

dentist_hospital=input(CONSENT_CONSENT2_Q32_M4_Q32A,8.0);
dentist_cabinet=input(CONSENT_CONSENT2_Q32_M4_Q32B,8.0);
dentist_home=input(CONSENT_CONSENT2_Q32_M4_Q32C,8.0);
dentist_other=input(CONSENT_CONSENT2_Q32_M4_Q32D,8.0);
dentist_DK=input(CONSENT_CONSENT2_Q32_M4_Q32E,8.0);

dialysis_polyclinic=input(CONSENT_CONSENT2_Q42_M15_Q42A,8.0);
dialysis_hospital=input(CONSENT_CONSENT2_Q42_M15_Q42B,8.0);
dialysis_home=input(CONSENT_CONSENT2_Q42_M15_Q42C,8.0);
dialysis_pharmacy=input(CONSENT_CONSENT2_Q42_M15_Q42D,8.0);
dialysis_villagedoc=input(CONSENT_CONSENT2_Q42_M15_Q42E,8.0);
dialysis_other=input(CONSENT_CONSENT2_Q42_M15_Q42G,8.0);

surgery_hospital=input(CONSENT_CONSENT2_Q54_S4_Q54A,8.0);
surgery_nursing=input(CONSENT_CONSENT2_Q54_S4_Q54B,8.0);
surgery_polyclinic=input(CONSENT_CONSENT2_Q54_S4_Q54C,8.0);
****;surgery_other=CONSENT_CONSENT2_Q54_S4_Q54D;
surgery_DK=input(CONSENT_CONSENT2_Q54_S4_Q54E,8.0);

sti_syphilis=input(CONSENT_CONSENT2_Q56_STI2_Q56A,8.0);
sti_gonorrhea=input(CONSENT_CONSENT2_Q56_STI2_Q56B,8.0);
sti_chlamydia=input(CONSENT_CONSENT2_Q56_STI2_Q56C,8.0);
sti_herpes=input(CONSENT_CONSENT2_Q56_STI2_Q56D,8.0);
sti_warts=input(CONSENT_CONSENT2_Q56_STI2_Q56E,8.0);
***;sti_other=CONSENT_CONSENT2_Q56_STI2_Q56F;

chronic_asthma=input(CONSENT_CONSENT2_Q71_CD1_Q71A,8.0);
chronic_arthritis=input(CONSENT_CONSENT2_Q71_CD1_Q71B,8.0);
chronic_cancer=input(CONSENT_CONSENT2_Q71_CD1_Q71C,8.0);
chronic_CVD=input(CONSENT_CONSENT2_Q71_CD1_Q71D,8.0);
chronic_COPD=input(CONSENT_CONSENT2_Q71_CD1_Q71E,8.0);
chronic_hemophilia=input(CONSENT_CONSENT2_Q71_CD1_Q71F,8.0);
chronic_thyroid=input(CONSENT_CONSENT2_Q71_CD1_Q71G,8.0);
chronic_kidney=input(CONSENT_CONSENT2_Q71_CD1_Q71H,8.0);
chronic_lung=input(CONSENT_CONSENT2_Q71_CD1_Q71I,8.0);
chronic_other=input(CONSENT_CONSENT2_Q71_CD1_Q71J,8.0);
chronic_DK=input(CONSENT_CONSENT2_Q71_CD1_Q71K,8.0);

HCV_trans_droplets=input(CONSENT_CONSENT2_Q74_H2_Q74A,8.0);
HCV_trans_food=input(CONSENT_CONSENT2_Q74_H2_Q74B,8.0);
HCV_trans_blood=input(CONSENT_CONSENT2_Q74_H2_Q74C,8.0);
HCV_trans_sex=input(CONSENT_CONSENT2_Q74_H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENT_CONSENT2_Q74_H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENT_CONSENT2_Q74_H2_Q74F,8.0);
HCV_trans_needle=input(CONSENT_CONSENT2_Q74_H2_Q74G,8.0);
HCV_trans_touch=input(CONSENT_CONSENT2_Q74_H2_Q74H,8.0);
HCV_trans_DK=input(CONSENT_CONSENT2_Q74_H2_Q74I,8.0);
HCV_trans_none=input(CONSENT_CONSENT2_Q74_H2_Q74J,8.0);
HCV_trans_other=input(CONSENT_CONSENT2_Q74_H2_Q74K,8.0);

HCV_prev_vacc=input(CONSENT_CONSENT2_Q77_H5_Q77A,8.0);
HCV_prev_condom=input(CONSENT_CONSENT2_Q77_H5_Q77B,8.0);
HCV_prev_needle=input(CONSENT_CONSENT2_Q77_H5_Q77C,8.0);
HCV_prev_wash=input(CONSENT_CONSENT2_Q77_H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENT_CONSENT2_Q77_H5_Q77E,8.0);
HCV_prev_DK=input(CONSENT_CONSENT2_Q77_H5_Q77F,8.0);
****;HCV_prev_other=CONSENT_CONSENT2_Q77_H5_Q77G;
HCV_prev_none=input(CONSENT_CONSENT2_Q77_H5_Q77H,8.0);
trust_family=input(CONSENT_CONSENT2_Q78_H6_Q78A,8.0);
trust_medlit=input(CONSENT_CONSENT2_Q78_H6_Q78B,8.0);
trust_newspaper=input(CONSENT_CONSENT2_Q78_H6_Q78C,8.0);
trust_radio=input(CONSENT_CONSENT2_Q78_H6_Q78D,8.0);
trust_tv=input(CONSENT_CONSENT2_Q78_H6_Q78E,8.0);
trust_internet=input(CONSENT_CONSENT2_Q78_H6_Q78F,8.0);
trust_billboards=input(CONSENT_CONSENT2_Q78_H6_Q78G,8.0);
trust_brochures=input(CONSENT_CONSENT2_Q78_H6_Q78H,8.0);
trust_doctor=input(CONSENT_CONSENT2_Q78_H6_Q78I,8.0);
trust_pharmacist=input(CONSENT_CONSENT2_Q78_H6_Q78J,8.0);
trust_DK=input(CONSENT_CONSENT2_Q78_H6_Q78K,8.0);
trust_none=input(CONSENT_CONSENT2_Q78_H6_Q78L,8.0);
trust_other=input(CONSENT_CONSENT2_Q78_H6_Q78M,8.0);

HBV_trans_droplets=input(CONSENT_CONSENT2_Q80_H8_Q80A,8.0);
HBV_trans_food=input(CONSENT_CONSENT2_Q80_H8_Q80B,8.0);
HBV_trans_blood=input(CONSENT_CONSENT2_Q80_H8_Q80C,8.0);
HBV_trans_sex=input(CONSENT_CONSENT2_Q80_H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENT_CONSENT2_Q80_H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENT_CONSENT2_Q80_H8_Q80F,8.0);
HBV_trans_needle=input(CONSENT_CONSENT2_Q80_H8_Q80G,8.0);
HBV_trans_touch=input(CONSENT_CONSENT2_Q80_H8_Q80H,8.0);
HBV_trans_DK=input(CONSENT_CONSENT2_Q80_H8_Q80I,8.0);
HBV_trans_none=input(CONSENT_CONSENT2_Q80_H8_Q80J,8.0);
HBV_trans_other=input(CONSENT_CONSENT2_Q80_H8_Q80K,8.0);

HBV_prev_vacc=input(CONSENT_CONSENT2_Q83_H11_Q83A,8.0);
HBV_prev_condom=input(CONSENT_CONSENT2_Q83_H11_Q83B,8.0);
HBV_prev_needle=input(CONSENT_CONSENT2_Q83_H11_Q83C,8.0);
HBV_prev_wash=input(CONSENT_CONSENT2_Q83_H11_Q83D,8.0);
HBV_prev_sterile=input(CONSENT_CONSENT2_Q83_H11_Q83E,8.0);
HBV_prev_DK=input(CONSENT_CONSENT2_Q83_H11_Q83F,8.0);
HBV_prev_none=input(CONSENT_CONSENT2_Q83_H11_Q83G,8.0);

HCV_notreat_avail=input(CONSENT_CONSENT2_Q87_H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSENT_CONSENT2_Q87_H15_Q87B,8.0);
HCV_notreat_expense=input(CONSENT_CONSENT2_Q87_H15_Q87C,8.0);
HCV_notreat_effect=input(CONSENT_CONSENT2_Q87_H15_Q87D,8.0);
HCV_notreat_inject=input(CONSENT_CONSENT2_Q87_H15_Q87E,8.0);
HCV_notreat_other_specify=input(CONSENT_CONSENT2_Q87_H15_Q87F,8.0);
HCV_notreat_DK=input(CONSENT_CONSENT2_Q87_H15_Q87G,8.0);
HCV_notreat_RF=input(CONSENT_CONSENT2_Q87_H15_Q87H,8.0);
HCV_notreat_travel=input(CONSENT_CONSENT2_Q87_H15_Q87I,8.0);

hep_other_A=input(CONSENT_CONSENT2_Q94_H22_Q94A,8.0);
hep_other_D=input(CONSENT_CONSENT2_Q94_H22_Q94B,8.0);
hep_other_E=input(CONSENT_CONSENT2_Q94_H22_Q94C,8.0);
hep_other_none=input(CONSENT_CONSENT2_Q94_H22_Q94D,8.0);
hep_other_DK=input(CONSENT_CONSENT2_Q94_H22_Q94E,8.0);

cig_num =input(CONSENT_CONSENT2_Q110_T4_Q110A, 8.0);
cig_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110B, 8.0);
hand_cig_num= input(CONSENT_CONSENT2_Q110_T4_Q110C, 8.0);
hand_cig_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110D, 8.0);
pipe_num= input(CONSENT_CONSENT2_Q110_T4_Q110E, 8.0);
pipe_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110F, 8.0);
cigar_num= input(CONSENT_CONSENT2_Q110_T4_Q110G, 8.0);
cigar_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110H, 8.0);
smoke_other= input(CONSENT_CONSENT2_Q110_T4_Q110I, 8.0);
smoke_other_num= input(CONSENT_CONSENT2_Q110_T4_Q110J, 8.0);
smoke_other_day_week= input(CONSENT_CONSENT2_Q110_T4_Q110K, 8.0);

piercing_salon=input(CONSENT_CONSENT2_Q117_R7_Q117A,8.0);
piercing_home=input(CONSENT_CONSENT2_Q117_R7_Q117B,8.0);
piercing_prison=input(CONSENT_CONSENT2_Q117_R7_Q117C,8.0);
piercing_other=input(CONSENT_CONSENT2_Q117_R7_Q117D,8.0);
piercing_DK=input(CONSENT_CONSENT2_Q117_R7_Q117E,8.0);

manicure_salon=input(CONSENT_CONSENT2_Q119_R9_Q119A_, 8.0);
manicure_homeservice=input(CONSENT_CONSENT2_Q119_R9_Q119B_, 8.0);
manicure_self=input(CONSENT_CONSENT2_Q119_R9_Q119C_,8.0);
manicure_never=input(CONSENT_CONSENT2_Q119_R9_Q119D_,8.0);
manicure_other=input(CONSENT_CONSENT2_Q119_R9_Q119E_, 8.0);
barber_num=CONSENT_CONSENT2_Q120A_R10A;

shave_barber=input(CONSENT_CONSENT2_Q120_R10_Q120A  ,8.0);
shave_home=input(CONSENT_CONSENT2_Q120_R10_Q120B  ,8.0);
shave_none=input(CONSENT_CONSENT2_Q120_R10_Q120C  ,8.0);
shave_other=input(CONSENT_CONSENT2_Q120_R10_Q120D  ,8.0);

heprisk_toothbrush=input(CONSENT_CONSENT2_Q122_R12_Q122A,8.0);
heprisk_razor=input(CONSENT_CONSENT2_Q122_R12_Q122B,8.0);
heprisk_scissors=input(CONSENT_CONSENT2_Q122_R12_Q122C,8.0);
heprisk_brush=input(CONSENT_CONSENT2_Q122_R12_Q122D,8.0);
heprisk_nail=input(CONSENT_CONSENT2_Q122_R12_Q122E,8.0);
heprisk_none=input(CONSENT_CONSENT2_Q122_R12_Q122F,8.0);
heprisk_DK=input(CONSENT_CONSENT2_Q122_R12_Q122G ,8.0);

IDU_needle_NEP=input(CONSENT_CONSENT2_Q127_I5_Q127A,8.0);
IDU_needle_store=input(CONSENT_CONSENT2_Q127_I5_Q127B,8.0);
IDU_needle_order=input(CONSENT_CONSENT2_Q127_I5_Q127C,8.0);
IDU_needle_borrow=input(CONSENT_CONSENT2_Q127_I5_Q127D,8.0);
IDU_needle_rent=input(CONSENT_CONSENT2_Q127_I5_Q127E,8.0);
IDU_needle_found=input(CONSENT_CONSENT2_Q127_I5_Q127F,8.0);
IDU_needle_DK=input(CONSENT_CONSENT2_Q127_I5_Q127G,8.0);
IDU_needle_none=input(CONSENT_CONSENT2_Q127_I5_Q127H,8.0);
IDU_needle_refused=input(CONSENT_CONSENT2_Q127_I5_Q127I,8.0);

IDU_vent=input(CONSENT_CONSENT2_Q132_I10_Q132A,8.0);
IDU_jeff=input(CONSENT_CONSENT2_Q132_I10_Q132B,8.0);
IDU_krokodil=input(CONSENT_CONSENT2_Q132_I10_Q132C,8.0);
IDU_opium=input(CONSENT_CONSENT2_Q132_I10_Q132D,8.0);
IDU_med=input(CONSENT_CONSENT2_Q132_I10_Q132E,8.0);
IDU_poppy=input(CONSENT_CONSENT2_Q132_I10_Q132F,8.0);
IDU_heroin=input(CONSENT_CONSENT2_Q132_I10_Q132G,8.0);
IDU_alcohol=input(CONSENT_CONSENT2_Q132_I10_Q132H,8.0);
IDU_cocaine=input(CONSENT_CONSENT2_Q132_I10_Q132I,8.0);
IDU_crack=input(CONSENT_CONSENT2_Q132_I10_Q132J,8.0);
IDU_psych=input(CONSENT_CONSENT2_Q132_I10_Q132K,8.0);
IDU_ecstasy=input(CONSENT_CONSENT2_Q132_I10_Q132L,8.0);
IDU_otherdrug=input(CONSENT_CONSENT2_Q132_I10_Q132M,8.0);
IDU_drug_DK=input(CONSENT_CONSENT2_Q132_I10_Q132N,8.0);
IDU_drug_RF=input(CONSENT_CONSENT2_Q132_I10_Q132O,8.0);

sex_healthcare = input(CONSENT_CONSENT2_Q139_SP7_Q139A, 8.0);
sex_military = input(CONSENT_CONSENT2_Q139_SP7_Q139B, 8.0);
sex_police = input(CONSENT_CONSENT2_Q139_SP7_Q139C, 8.0);
sex_dialysis = input(CONSENT_CONSENT2_Q139_SP7_Q139D, 8.0);
sex_IDU = input(CONSENT_CONSENT2_Q139_SP7_Q139E, 8.0);
sex_CSW = input(CONSENT_CONSENT2_Q139_SP7_Q139F, 8.0);
sex_none = input(CONSENT_CONSENT2_Q139_SP7_Q139G, 8.0);
sex_RF = input(CONSENT_CONSENT2_Q139_SP7_Q139H, 8.0);
tattoo_salon=input(CONSENT_CONSENT2_Q113_R3_Q113A,8.0);
tattoo_home=input(CONSENT_CONSENT2_Q113_R3_Q113B,8.0);
tattoo_prison=input(CONSENT_CONSENT2_Q113_R3_Q113C,8.0);
tattoo_other=input(CONSENT_CONSENT2_Q113_R3_Q113D,8.0);
tattoo_DK=input(CONSENT_CONSENT2_Q113_R3_Q113E,8.0);

*matching variables;

*;barcode=Q0_BARCODE;
int_id_quest=Q1_I1;
hh_num=input(Q2A_I2,8.0);
stratum_num=input(Q3A_I3,8.0);
*;cluster_ID=Q3B_I3;
cluster_name=Q4_I4;
int_date=Q5_I5;
int_start_time=Q6_I6;
consent_int=input(Q7_I7,8.0);
consent_demo=input(Q7A_CONSENT,8.0);
language=input(Q8_I8,8.0);
surname=CONSENT_Q9_I9;
f_name=CONSENT_Q10_I10;
gender=input(Q11_D1,8.0);
birthday=CONSENT_Q12A_D2;
birthyear=input(CONSENT_Q12B_D2,8.0);
age=input(CONSENT_Q13_D3,8.0);
education=input(CONSENT_Q14_D4,8.0);
ethnicity=input(CONSENT_Q15_D5,8.0);
ethnicity_other_specify=CONSENT_Q15A_D5_OTHER;
religion=input(CONSENT_Q16_D6,8.0);
religion_other_specify=CONSENT_Q16A_D6_OTHER;
married=input(CONSENT_Q17_D7,8.0);
work=input(CONSENT_Q18_D8,8.0);
work_healthcare=input(CONSENT_Q19_D9_Q19A,8.0);
work_military=input(CONSENT_Q19_D9_Q19B,8.0);
work_police=input(CONSENT_Q19_D9_Q19C,8.0);
house=input(CONSENT_Q20_D10,8.0);
house_other_specify=CONSENT_Q20A_D10_OTHER;
resident_num=input(CONSENT_Q21_D11,8.0);
earnings_cat=input(CONSENT_Q22_D12,8.0);
earnings_amount=input(CONSENT_Q22A_D12,8.0);
earnings_estimate=input(CONSENT_Q23_D13,8.0);
earners_num=input(CONSENT_Q24_D14,8.0);
insurance=input(CONSENT_Q25_D15,8.0);
insurance_type=input(CONSENT_Q26_D16,8.0);
medcare_pay=input(CONSENT_Q27_D17,8.0);
medcare_pay_other_specify=CONSENT_Q27A_D17_OTHER;
displaced=input(CONSENT_Q28_D18,8.0);
medcare_location=input(CONSENT_CONSENT2_Q29_M1,8.0);
medcare_location_other_specify=CONSENT_CONSENT2_Q29A_M1_OTHER;
flu=input(CONSENT_CONSENT2_Q29B_M1B,8.0);
/*flu_polyclinic=input(CONSNTCNSENT2Q29CM1C_Q29C_A,8.0);
flu_hospital=input(CONSNTCNSENT2Q29CM1C_Q29C_B,8.0);
flu_medhome=input(CONSNTCNSENT2Q29CM1C_Q29C_C,8.0);
flu_pharmacy=input(CONSNTCNSENT2Q29CM1C_Q29C_D,8.0);
flu_villagedoc=input(CONSNTCNSENT2Q29CM1C_Q29C_E,8.0);
flu_none=input(CONSNTCNSENT2Q29CM1C_Q29C_F,8.0);*/
hospital_lifetime_num=input(CONSENT_CONSENT2_Q30_M2,8.0);
/*flu_other=CONSNTCNSENT2Q29CM1C_Q29C_G;*/
dentist_cat=input(CONSENT_CONSENT2_Q31_M3,8.0);
dentist_other_specify=CONSENT_CONSENT2_Q32_M4A;
/*dentist_hospital=input(CONSENTCONSENT2Q32M4_Q32A,8.0);
dentist_cabinet=input(CONSENTCONSENT2Q32M4_Q32B,8.0);
dentist_home=input(CONSENTCONSENT2Q32M4_Q32C,8.0);
dentist_other=input(CONSENTCONSENT2Q32M4_Q32D,8.0);
dentist_DK=input(CONSENTCONSENT2Q32M4_Q32E,8.0);*/
dental_proc_num=input(CONSENT_CONSENT2_Q33_M5,8.0);
shot_num=input(CONSENT_CONSENT2_Q34_M6,8.0);
flushot=input(CONSENT_CONSENT2_Q34A_M6_1,8.0);
flushot_loc=CONSENT_CONSENT2_Q34B_M6_2;
shot_admin=input(CONSENT_CONSENT2_Q35_M7,8.0);
shot_admin_other=CONSENT_CONSENT2_Q35A_M7_OTHER;
shot_needle=input(CONSENT_CONSENT2_Q36_M8,8.0);
shot_needle_other_specify=CONSENT_CONSENT2_Q36A_M8_OTHER;
shot_purpose=input(CONSENT_CONSENT2_Q37_M9,8.0);
shot_purpose_other_specify=CONSENT_CONSENT2_Q37A_M9_OTHER;
shot_med=input(CONSENT_CONSENT2_Q38_M10,8.0);
shot_med_other_specify=CONSENT_CONSENT2_Q38A_M10_OTHER;
shot_discard=input(CONSENT_CONSENT2_Q39_M11,8.0);
IV_num=input(CONSENT_CONSENT2_Q40_M12,8.0);
dialysis_ever=input(CONSENT_CONSENT2_Q41_M14,8.0);
/*dialysis_polyclinic=input(CONSNTCNSENT2Q42M15_Q42A,8.0);
dialysis_hospital=input(CONSNTCNSENT2Q42M15_Q42B,8.0);
dialysis_home=input(CONSNTCNSENT2Q42M15_Q42C,8.0);
dialysis_pharmacy=input(CONSNTCNSENT2Q42M15_Q42D,8.0);
dialysis_villagedoc=input(CONSNTCNSENT2Q42M15_Q42E,8.0);
dialysis_other=input(CONSNTCNSENT2Q42M15_Q42G,8.0);*/
dialysis_current=input(CONSENT_CONSENT2_Q43_M16,8.0);
dialysis_freq=input(CONSENT_CONSENT2_Q44_M17,8.0);
blood_trans=input(CONSENT_CONSENT2_Q45_M18,8.0);
blood_trans_num=input(CONSENT_CONSENT2_Q46_M19,8.0);
blood_trans_relative=input(CONSENT_CONSENT2_Q47_M20,8.0);
blood_donate=input(CONSENT_CONSENT2_Q48_M21,8.0);
blood_donate_relative=input(CONSENT_CONSENT2_Q49_M22,8.0);
blood_donate_money=input(CONSENT_CONSENT2_Q50_M23,8.0);
med_invasive=input(CONSENT_CONSENT2_Q51_S1,8.0);
surgery_ever=input(CONSENT_CONSENT2_Q52_S2,8.0);
surgery_num=input(CONSENT_CONSENT2_Q53_S3,8.0);
/*surgery_hospital=input(CONSENTCONSENT2Q54S4_Q54A,8.0);
surgery_nursing=input(CONSENTCONSENT2Q54S4_Q54B,8.0);
surgery_polyclinic=input(CONSENTCONSENT2Q54S4_Q54C,8.0);
surgery_other=CONSENTCONSENT2Q54S4_Q54D;
surgery_DK=input(CONSENTCONSENT2Q54S4_Q54E,8.0);*/
sti_ever=input(CONSENT_CONSENT2_Q55_STI1,8.0);
/*sti_syphilis=input(CONSNTCONSNT2Q56STI2_Q56A,8.0);
sti_gonorrhea=input(CONSNTCONSNT2Q56STI2_Q56B,8.0);
sti_chlamydia=input(CONSNTCONSNT2Q56STI2_Q56C,8.0);
sti_herpes=input(CONSNTCONSNT2Q56STI2_Q56D,8.0);
sti_warts=input(CONSNTCONSNT2Q56STI2_Q56E,8.0);
sti_other=CONSNTCONSNT2Q56STI2_Q56F;*/
HIV_test=input(CONSENT_CONSENT2_Q57_STI3,8.0);
HIV_result=input(CONSENT_CONSENT2_Q58_STI4,8.0);
tb_ever=input(CONSENT_CONSENT2_Q59_TB1,8.0);
tb_year=input(CONSENT_CONSENT2_Q60_TB2,8.0);
tb_treat=input(CONSENT_CONSENT2_Q61_TB3,8.0);
bp_meas=input(CONSENT_CONSENT2_Q62_HY1,8.0);
hypertension_ever=input(CONSENT_CONSENT2_Q63_HY2,8.0);
hypertension_year=input(CONSENT_CONSENT2_Q64_HY3,8.0);
sugar_meas=input(CONSENT_CONSENT2_Q65_D1,8.0);
diabetes_ever=input(CONSENT_CONSENT2_Q66_D2,8.0);
diabetes_year=input(CONSENT_CONSENT2_Q67_D3,8.0);
insulin_current=input(CONSENT_CONSENT2_Q68_D4,8.0);
sugar_test_share=input(CONSENT_CONSENT2_Q69_D5,8.0);
insulin_syringe_share=input(CONSENT_CONSENT2_Q70_D6,8.0);
/*chronic_asthma=input(CONSNTCNSENT2Q71CD1_Q71A,8.0);
chronic_arthritis=input(CONSNTCNSENT2Q71CD1_Q71B,8.0);
chronic_cancer=input(CONSNTCNSENT2Q71CD1_Q71C,8.0);
chronic_CVD=input(CONSNTCNSENT2Q71CD1_Q71D,8.0);
chronic_COPD=input(CONSNTCNSENT2Q71CD1_Q71E,8.0);
chronic_hemophilia=input(CONSNTCNSENT2Q71CD1_Q71F,8.0);
chronic_thyroid=input(CONSNTCNSENT2Q71CD1_Q71G,8.0);
chronic_kidney=input(CONSNTCNSENT2Q71CD1_Q71H,8.0);
chronic_lung=input(CONSNTCNSENT2Q71CD1_Q71I,8.0);
chronic_other=input(CONSNTCNSENT2Q71CD1_Q71J,8.0);
chronic_DK=input(CONSNTCNSENT2Q71CD1_Q71K,8.0);*/
chronic_other_specify=CONSENT_CONSENT2_Q71L_CD1_OTHER;
cancer_type=CONSENT_CONSENT2_Q72_CD2;
HCV_heard=input(CONSENT_CONSENT2_Q73_H1,8.0);
/*HCV_trans_droplets=input(CONSENTCONSENT2Q74H2_Q74A,8.0);
HCV_trans_food=input(CONSENTCONSENT2Q74H2_Q74B,8.0);
HCV_trans_blood=input(CONSENTCONSENT2Q74H2_Q74C,8.0);
HCV_trans_sex=input(CONSENTCONSENT2Q74H2_Q74D,8.0);
HCV_trans_handshake=input(CONSENTCONSENT2Q74H2_Q74E,8.0);
HCV_trans_hh_objects=input(CONSENTCONSENT2Q74H2_Q74F,8.0);
HCV_trans_needle=input(CONSENTCONSENT2Q74H2_Q74G,8.0);
HCV_trans_touch=input(CONSENTCONSENT2Q74H2_Q74H,8.0);
HCV_trans_DK=input(CONSENTCONSENT2Q74H2_Q74I,8.0);
HCV_trans_none=input(CONSENTCONSENT2Q74H2_Q74J,8.0);
HCV_trans_other=input(CONSENTCONSENT2Q74H2_Q74K,8.0);*/
HCV_trans_other_specify=CONSENT_CONSENT2_Q74L_H2A;
HCV_asymptomatic=input(CONSENT_CONSENT2_Q75_H3,8.0);
HCV_med=input(CONSENT_CONSENT2_Q76_H4,8.0);
/*HCV_prev_vacc=input(CONSENTCONSENT2Q7H5_Q77A,8.0);
HCV_prev_condom=input(CONSENTCONSENT2Q7H5_Q77B,8.0);
HCV_prev_needle=input(CONSENTCONSENT2Q7H5_Q77C,8.0);
HCV_prev_wash=input(CONSENTCONSENT2Q7H5_Q77D,8.0);
HCV_prev_sterile=input(CONSENTCONSENT2Q7H5_Q77E,8.0);
HCV_prev_DK=input(CONSENTCONSENT2Q7H5_Q77F,8.0);
HCV_prev_other=CONSENTCONSENT2Q7H5_Q77G;
HCV_prev_none=input(CONSENTCONSENT2Q7H5_Q77H,8.0);*/
/*trust_family=input(CONSENTCONSENT2Q78H6_Q78A,8.0);
trust_medlit=input(CONSENTCONSENT2Q78H6_Q78B,8.0);
trust_newspaper=input(CONSENTCONSENT2Q78H6_Q78C,8.0);
trust_radio=input(CONSENTCONSENT2Q78H6_Q78D,8.0);
trust_tv=input(CONSENTCONSENT2Q78H6_Q78E,8.0);
trust_internet=input(CONSENTCONSENT2Q78H6_Q78F,8.0);
trust_billboards=input(CONSENTCONSENT2Q78H6_Q78G,8.0);
trust_brochures=input(CONSENTCONSENT2Q78H6_Q78H,8.0);
trust_doctor=input(CONSENTCONSENT2Q78H6_Q78I,8.0);
trust_pharmacist=input(CONSENTCONSENT2Q78H6_Q78J,8.0);
trust_DK=input(CONSENTCONSENT2Q78H6_Q78K,8.0);
trust_none=input(CONSENTCONSENT2Q78H6_Q78L,8.0);
trust_other=input(CONSENTCONSENT2Q78H6_Q78M,8.0);*/
trust_other_specify=CONSENT_CONSENT2_Q78N_H6A;
HBV_heard=input(CONSENT_CONSENT2_Q79_H7,8.0);
/*HBV_trans_droplets=input(CONSENTCONSENT2Q80H8_Q80A,8.0);
HBV_trans_food=input(CONSENTCONSENT2Q80H8_Q80B,8.0);
HBV_trans_blood=input(CONSENTCONSENT2Q80H8_Q80C,8.0);
HBV_trans_sex=input(CONSENTCONSENT2Q80H8_Q80D,8.0);
HBV_trans_handshake=input(CONSENTCONSENT2Q80H8_Q80E,8.0);
HBV_trans_hh_objects=input(CONSENTCONSENT2Q80H8_Q80F,8.0);
HBV_trans_needle=input(CONSENTCONSENT2Q80H8_Q80G,8.0);
HBV_trans_touch=input(CONSENTCONSENT2Q80H8_Q80H,8.0);
HBV_trans_DK=input(CONSENTCONSENT2Q80H8_Q80I,8.0);
HBV_trans_none=input(CONSENTCONSENT2Q80H8_Q80J,8.0);
HBV_trans_other=input(CONSENTCONSENT2Q80H8_Q80K,8.0);*/
HBV_trans_other_specify=CONSENT_CONSENT2_Q80L_H8A;
HBV_asymptomatic=input(CONSENT_CONSENT2_Q81_H9,8.0);
HBV_med=input(CONSENT_CONSENT2_Q82_H10,8.0);
/*HBV_prev_vacc=input(CONSENTCONSENT2Q83H1_Q83A,8.0);
HBV_prev_condom=input(CONSENTCONSENT2Q83H1_Q83B,8.0);
HBV_prev_needle=input(CONSENTCONSENT2Q83H1_Q83C,8.0);
HBV_prev_wash=input(CONSENTCONSENT2Q83H1_Q83D,8.0);
HBV_prev_sterile=input(CONSENTCONSENT2Q83H1_Q83E,8.0);
HBV_prev_DK=input(CONSENTCONSENT2Q83H1_Q83F,8.0);
HBV_prev_none=input(CONSENTCONSENT2Q83H1_Q83G,8.0);*/
HCV_ever=input(CONSENT_CONSENT2_Q84_H12,8.0);
HCV_year=input(CONSENT_CONSENT2_Q85_H13,8.0);
HCV_treated=input(CONSENT_CONSENT2_Q86_H14,8.0);
/*HCV_notreat_avail=input(CONSNTCNSENT2Q87H15_Q87A,8.0);
HCV_notreat_eligible=input(CONSNTCNSENT2Q87H15_Q87B,8.0);
HCV_notreat_expense=input(CONSNTCNSENT2Q87H15_Q87C,8.0);
HCV_notreat_effect=input(CONSNTCNSENT2Q87H15_Q87D,8.0);
HCV_notreat_inject=input(CONSNTCNSENT2Q87H15_Q87E,8.0);
HCV_notreat_other_specify=CONSNTCNSENT2Q87H15_Q87F;
HCV_notreat_DK=input(CONSNTCNSENT2Q87H15_Q87G,8.0);
HCV_notreat_RF=input(CONSNTCNSENT2Q87H15_Q87H,8.0);
HCV_notreat_travel=input(CONSNTCNSENT2Q87H15_Q87I,8.0);*/
HCV_treat_complete=input(CONSENT_CONSENT2_Q88_H16,8.0);
HCV_cured=input(CONSENT_CONSENT2_Q89_H17,8.0);
HBV_ever=input(CONSENT_CONSENT2_Q90_H18,8.0);
HBV_year=input(CONSENT_CONSENT2_Q91_H19,8.0);
HBV_treated=input(CONSENT_CONSENT2_Q92_H20,8.0);
HBV_vacc_ever=input(CONSENT_CONSENT2_Q93_H21,8.0);
/*hep_other_A=input(CONSENTCONSENT2Q94H2_Q94A,8.0);
hep_other_D=input(CONSENTCONSENT2Q94H2_Q94B,8.0);
hep_other_E=input(CONSENTCONSENT2Q94H2_Q94C,8.0);
hep_other_none=input(CONSENTCONSENT2Q94H2_Q94D,8.0);
hep_other_DK=input(CONSENTCONSENT2Q94H2_Q94E,8.0);*/
hep_other_year=input(CONSENT_CONSENT2_Q95_H23,8.0);
alc_ever=input(CONSENT_CONSENT2_Q96_A1A,8.0);
alc_year=input(CONSENT_CONSENT2_Q97_A1B,8.0);
alc_year_freq=input(CONSENT_CONSENT2_Q98_A2,8.0);
alc_month=input(CONSENT_CONSENT2_Q99_A3,8.0);
alc_occasions=input(CONSENT_CONSENT2_Q100_A4,8.0);
alc_drinks=input(CONSENT_CONSENT2_Q101_A5,8.0);
alc_max=input(CONSENT_CONSENT2_Q102_A6,8.0);
alc_male=input(CONSENT_CONSENT2_Q103A_A7_MALES,8.0);
alc_female=input(CONSENT_CONSENT2_Q103B_A7_FEMAL,8.0);
walk_bike_lastweek=input(CONSENT_CONSENT2_Q104_PA1,8.0);
walk_bike_typicalweek=input(CONSENT_CONSENT2_Q105_PA2,8.0);
walk_bike_typicalday=CONSENT_CONSENT2_Q106_PA3;
smoke_current_freq=input(CONSENT_CONSENT2_Q107_T1,8.0);
smoke_past=input(CONSENT_CONSENT2_Q108_T2,8.0);
smoke_past_freq=input(CONSENT_CONSENT2_Q109_T3,8.0);
/*cig_num=input(CONSENTCONSENT2Q10T4_Q110A,8.0);
cig_day_week=input(CONSENTCONSENT2Q10T4_Q110B,8.0);
hand_cig_num=input(CONSENTCONSENT2Q10T4_Q110C,8.0);
hand_cig_day_week=input(CONSENTCONSENT2Q10T4_Q110D,8.0);
pipe_num=input(CONSENTCONSENT2Q10T4_Q110E,8.0);
pipe_day_week=input(CONSENTCONSENT2Q10T4_Q110F,8.0);
cigar_num=input(CONSENTCONSENT2Q10T4_Q110G,8.0);
cigar_day_week=input(CONSENTCONSENT2Q10T4_Q110H,8.0);
smoke_other=CONSENTCONSENT2Q10T4_Q110I;
smoke_other_num=input(CONSENTCONSENT2Q10T4_Q110J,8.0);
smoke_other_day_week=input(CONSENTCONSENT2Q10T4_Q110K,8.0);*/
prison=input(CONSENT_CONSENT2_Q111_R1,8.0);
tattoo=input(CONSENT_CONSENT2_Q112_R2,8.0);
tattoo_other_specify=CONSENT_CONSENT2_Q113F_R3A;
tattoo_needle=input(CONSENT_CONSENT2_Q114_R4,8.0);
tattoo_ink=input(CONSENT_CONSENT2_Q115_R5,8.0);
piercing=input(CONSENT_CONSENT2_Q116_R6,8.0);
piercing_other_specify=CONSENT_CONSENT2_Q117F_R7A;
/*piercing_salon=input(CONSENTCONSENT2Q17R7_Q117A,8.0);
piercing_home=input(CONSENTCONSENT2Q17R7_Q117B,8.0);
piercing_prison=input(CONSENTCONSENT2Q17R7_Q117C,8.0);
piercing_other=input(CONSENTCONSENT2Q17R7_Q117D,8.0);
piercing_DK=input(CONSENTCONSENT2Q17R7_Q117E,8.0);*/
piercing_needle=input(CONSENT_CONSENT2_Q118_R8,8.0);
manicure_num=input(CONSENT_CONSENT2_Q119A_R9A,8.0);
/*manicure_salon=input(CONSENTCONSENT2Q19R9_Q119A_R9,8.0);
manicure_homeservice=input(CONSENTCONSENT2Q19R9_Q119B_R9,8.0);
manicure_self=input(CONSENTCONSENT2Q19R9_Q119C_R9,8.0);
manicure_never=input(CONSENTCONSENT2Q19R9_Q119D_R9,8.0);
manicure_other=CONSENTCONSENT2Q19R9_Q119E_R9;*/
*;barber_num=CONSENT_CONSENT2_Q120A_R10A;
shave_other_specify=CONSENT_CONSENT2_Q120E_R10E;
/*shave_barber=input(CONSNTCNSENT2Q120R10_Q120A,8.0);
shave_home=input(CONSNTCNSENT2Q120R10_Q120B,8.0);
shave_none=input(CONSNTCNSENT2Q120R10_Q120C,8.0);
shave_other=input(CONSNTCNSENT2Q120R10_Q120D,8.0);*/
shave_razor=input(CONSENT_CONSENT2_Q121_R11,8.0);
/*heprisk_toothbrush=input(CONSNTCNSENT2Q12R12_Q122A,8.0);
heprisk_razor=input(CONSNTCNSENT2Q12R12_Q122B,8.0);
heprisk_scissors=input(CONSNTCNSENT2Q12R12_Q122C,8.0);
heprisk_brush=input(CONSNTCNSENT2Q12R12_Q122D,8.0);
heprisk_nail=input(CONSNTCNSENT2Q12R12_Q122E,8.0);
heprisk_none=input(CONSNTCNSENT2Q12R12_Q122F,8.0);
heprisk_DK=input(CONSNTCNSENT2Q12R12_Q122G,8.0);*/
IDU_ever=input(CONSENT_CONSENT2_Q123_I1,8.0);
IDU_num_life=input(CONSENT_CONSENT2_Q124_I2,8.0);
IDU_num_6mo=input(CONSENT_CONSENT2_Q125_I3,8.0);
IDU_age_start=input(CONSENT_CONSENT2_Q126_I4,8.0);
/*IDU_needle_NEP=input(CONSNTCONSNT2Q127I5_Q127A,8.0);
IDU_needle_store=input(CONSNTCONSNT2Q127I5_Q127B,8.0);
IDU_needle_order=input(CONSNTCONSNT2Q127I5_Q127C,8.0);
IDU_needle_borrow=input(CONSNTCONSNT2Q127I5_Q127D,8.0);
IDU_needle_rent=input(CONSNTCONSNT2Q127I5_Q127E,8.0);
IDU_needle_found=input(CONSNTCONSNT2Q127I5_Q127F,8.0);
IDU_needle_DK=input(CONSNTCONSNT2Q127I5_Q127G,8.0);
IDU_needle_none=input(CONSNTCONSNT2Q127I5_Q127H,8.0);
IDU_needle_refused=input(CONSNTCONSNT2Q127I5_Q127I,8.0);*/
IDU_share1=input(CONSENT_CONSENT2_Q128_I6,8.0);
IDU_share1_num=input(CONSENT_CONSENT2_Q129_I7,8.0);
IDU_share2=input(CONSENT_CONSENT2_Q130_I8,8.0);
IDU_share2_num=input(CONSENT_CONSENT2_Q131_I9,8.0);
/*IDU_vent=input(CONSNTCONSNT2Q132I10_Q132A,8.0);
IDU_jeff=input(CONSNTCONSNT2Q132I10_Q132B,8.0);
IDU_krokodil=input(CONSNTCONSNT2Q132I10_Q132C,8.0);
IDU_opium=input(CONSNTCONSNT2Q132I10_Q132D,8.0);
IDU_med=input(CONSNTCONSNT2Q132I10_Q132E,8.0);
IDU_poppy=input(CONSNTCONSNT2Q132I10_Q132F,8.0);
IDU_heroin=input(CONSNTCONSNT2Q132I10_Q132G,8.0);
IDU_alcohol=input(CONSNTCONSNT2Q132I10_Q132H,8.0);
IDU_cocaine=input(CONSNTCONSNT2Q132I10_Q132I,8.0);
IDU_crack=input(CONSNTCONSNT2Q132I10_Q132J,8.0);
IDU_psych=input(CONSNTCONSNT2Q132I10_Q132K,8.0);
IDU_ecstasy=input(CONSNTCONSNT2Q132I10_Q132L,8.0);
IDU_otherdrug=CONSNTCONSNT2Q132I10_Q132M;
IDU_drug_DK=input(CONSNTCONSNT2Q132I10_Q132N,8.0);
IDU_drug_RF=input(CONSNTCONSNT2Q132I10_Q132O,8.0);*/
sex_num=input(CONSENT_CONSENT2_Q133_SP1,8.0);
sex_STI=input(CONSENT_CONSENT2_Q134_SP2,8.0);
sex_HBV=input(CONSENT_CONSENT2_Q135_SP3,8.0);
sex_HCV=input(CONSENT_CONSENT2_Q136_SP4,8.0);
sex_HIV=input(CONSENT_CONSENT2_Q137_SP5,8.0);
condom=input(CONSENT_CONSENT2_Q138_SP6,8.0);
/*sex_healthcare=input(CONSNTCNSENT2Q139SP7_Q139A,8.0);
sex_military=input(CONSNTCNSENT2Q139SP7_Q139B,8.0);
sex_police=input(CONSNTCNSENT2Q139SP7_Q139C,8.0);
sex_dialysis=input(CONSNTCNSENT2Q139SP7_Q139D,8.0);
sex_IDU=input(CONSNTCNSENT2Q139SP7_Q139E,8.0);
sex_CSW=input(CONSNTCNSENT2Q139SP7_Q139F,8.0);
sex_none=input(CONSNTCNSENT2Q139SP7_Q139G,8.0);
sex_RF=input(CONSNTCNSENT2Q139SP7_Q139H,8.0);*/
/*tattoo_salon=input(CONSENTCONSENT2Q13R3_Q113A,8.0);
tattoo_home=input(CONSENTCONSENT2Q13R3_Q113B,8.0);
tattoo_prison=input(CONSENTCONSENT2Q13R3_Q113C,8.0);
tattoo_other=input(CONSENTCONSENT2Q13R3_Q113D,8.0);
tattoo_DK=input(CONSENTCONSENT2Q13R3_Q113E,8.0);*/
MSM=input(CONSENT_CONSENT2_Q140_SP8,8.0);
MSM_condom=input(CONSENT_CONSENT2_Q141_SP9,8.0);
int_ID_NCD=Q142_PB1;
nurse_ID=Q143_PB2;
consent_NCD=input(Q144_PB3,8.0);
consent_blood=input(Q145_PB4,8.0);
consent_bank=input(Q147_PB6,8.0);
phone_results=Q148_PB7;
address_results=Q149_PB8;
BP_ID=Q150_PB9;
cuff=input(Q151_PB10,8.0);
*;cuff_other_specify=Q151A_PB10;
BP_s1=input(Q152_PB11,8.0);
BP_d1=input(Q152_PB12,8.0);
BPM1=input(Q152_PB13,8.0);
BP_s2=input(Q153_PB14,8.0);
BP_d2=input(Q153_PB15,8.0);
BPM2=input(Q153_PB16,8.0);
BP_s3=input(Q154_PB17,8.0);
BP_d3=input(Q154_PB18,8.0);
BPM3=input(Q154_PB19,8.0);
BP_treat=input(Q155_PB20,8.0);
height_ID=Q156A_PB21;
weight_ID=Q156B_PB22;
height_cm=input(Q157_PB23,8.0);
kyphotic=input(Q157A_PB23A,8.0);
weight_kg=input(Q158_PB24,8.0);
pregnant=input(Q159_PB25,8.0);
waist_ID=Q160_PB26;
waist_cm=input(Q161_PB27,8.0);
hip_cm=input(Q162_PB28,8.0);
blood_collected=input(Q163_PB29,8.0);
disposition=input(Q164_EXIT1,8.0);
disposition_other_specify=Q164A_EXIT1_OTHER;
blood_time=Q165_PB31;

/*;
manicure_salon 
manicure_homeservice 
manicure_self 
manicure_never*/
run;

*Labeling Variables;;
data HCV10.HCVlabel; set HCV10.HCVrecode; 
	label barcode = 'Barcode';
	label int_id_quest = 'Interviewer ID for behavioral questionnaire';
	label f_name = 'First name';
	label age = 'Age of participant';
	label gender = 'Gender';
	label education = 'What is the highest level of education you have completed?';
	label alc_occasions = 'During the past 30 days, on how many drinking occasions did you have at least one alcoholic drink?';
	label alc_drinks = 'During the past 30 days, when you drank alcohol, on average, how many standard alcoholic drinks did you have during one drinking occasion?';
	label alc_max = 'During the past 30 days, what was the largest number of standard alcoholic drinks you had on a single occasion?';
	label alc_male = '(Males) During the past 30 days, how many times did you have 5 or more standard alcoholic drinks in a single drinking occasion?';
	label alc_female = '(Females) During the past 30 days, how many times did you have 4 or more standard alcoholic drinks in a single drinking occasion?';
	label walk_bike_lastweek = 'Have you walked or used a bicycle for at least 10 minutes continuously to get to and from places in the last week?';
	label walk_bike_typicalweek = 'In a typical week, on how many days do you walk or bicycle for at least 10 minutes continuously to get to and from places?';
	label walk_bike_typicalday = 'How much time do you spend walking or bicylcling for travel on a typical day?';
	label smoke_current_freq = 'Do you currently smoke tobacco...';
	label smoke_past = 'Have you smoked tobacco daily in the past?';
	label smoke_past_freq = 'In the past, have you smoked tobacco...';
	label cig_num = 'Number of manufactured cigarettes';
	label cig_day_week = 'Manufactured cigarettes counted per day/week';
	label hand_cig_num = 'Number of hand rolled cigarettes';
	label hand_cig_day_week = 'Hand rolled cigarettes counted per day/week';
	label pipe_num = 'Number of pipes full of tobacco';
	label pipe_day_week = 'Pipes counted per day/week';
	label cigar_num = 'Number of cigars, cheroots, or cigarillos';
	label cigar_day_week = 'Cigars, cheroots, or cigarillos counted per day/week';
	label smoke_other = 'Other tobacco products (specify)';
	label smoke_other_num = 'Number of other tobacco products';
	label smoke_other_day_week = 'Other tobacco products counted per day/week';
	label prison = 'Have you ever been in prison or jail?';
	label tattoo = 'Do you have any tattoos? If so, how many?';
	label tattoo_other_specify = 'If you got a tattoo somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label tattoo_needle = 'Do you know if the people who gave you your tattoo(s) used new needles, or did they use needles that had been used before?';
	label tattoo_ink = 'Do you know if the people who gave you your tattoo(s)used a new bottle of ink, or a bottle of ink that had already  been opened and
						used for someone else?';
	label piercing = 'Do you have any body piercings? If yes, how many?';
	label piercing_other_specify = 'If you got a body piercing somewhere else (other than a beauty salon, tattoo salon, home, or prison), please state where';
	label piercing_needle = 'Do you know if the people who gave you the piercing(s) used a new needle or piercing instrument, or one that had been used before?';
	label manicure_num = 'In the last 6 months, how many times have you received a manicure or pedicure at a beauty salon or through a home service?';
	label barber_num = 'In a typical month, how many times do you go to a barber or a beauty salon to get shaved?';
	label shave_other_specify = 'If you typically get shaved somewhere else (other than a barber, beauty salon, or at home), please state where';
	label shave_barber = 'Barber or beauty salon (Where do you typically shave or get shaved?)';
	label shave_home = 'Home (Where do you typically shave or get shaved?)';
	label shave_none = 'I do not shave (Where do you typically shave or get shaved?)';
	label shave_other = 'Somewhere else (Where do you typically shave or get shaved?)';
	label shave_razor = 'When you go to the barber do you know whether you are being shaved with new razors, or razors that ahve been used before?';
	label IDU_ever = 'Have you ever injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_life = 'About how many times if your life have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_num_6mo = 'In the last 6 months, how often have you injected drugs or narcotics for nonmedical reasons?';
	label IDU_age_start = 'How old were you when you first injected drugs or narcotics for nonmedical reasons?';
	label IDU_needle_NEP = 'Needle exchange program (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_store = 'Drug store or other medical goods supplier (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_order = 'Mail or internet order (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_borrow = 'Borrowed from a friend or family member (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_rent = 'Purchased or rented from someone (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_found = 'A needle and/or syringe I found (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_DK = 'Do not know/remember (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_none = 'None of the above (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_needle_refused = 'Refused (When you have injected drugs or narcotics, have you ever used a needle from...?)';
	label IDU_share1 = 'Have you ever used someone elses needle and/or syringe after they used it?';
	label IDU_share1_num = 'How many times have you ever used someone elses needle and/or syringe after they used it?';
	label birthday = 'Birth day/month';
	label birthyear = 'Birth year';
	label heprisk_toothbrush = 'Toothbrush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_razor = 'Razor blades (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_scissors = 'Scissors (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_brush = 'Shaving brush (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_nail = 'Nail cutter (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_none = 'None of the above (Which of the following articles have you used in common with other members of your household?)';
	label heprisk_DK = 'Dont know/remember (Which of the following articles have you used in common with other members of your household?)';
	label IDU_share2 = 'Have you ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_share2_num = 'How many times havey ou ever let someone else use your needle and/or syringe after you have used it?';
	label IDU_vent = 'Vent (Which of the following drugs have you injected using a needle?)';
	label IDU_jeff = 'Jeff (Which of the following drugs have you injected using a needle?)';
	label IDU_krokodil = 'Krokodil (Which of the following drugs have you injected using a needle?)';
	label IDU_opium = 'Opium (Which of the following drugs have you injected using a needle?)';
	label IDU_med = 'Medical/synthetic drugs (Which of the following drugs have you injected using a needle?)';
	label IDU_poppy = 'Poppy straw (Which of the following drugs have you injected using a needle?)';
	label IDU_heroin = 'Heroin (Which of the following drugs have you injected using a needle?)';
	label IDU_alcohol = 'Alcohol (Which of the following drugs have you injected using a needle?)';
	label IDU_cocaine = 'Cocaine (Which of the following drugs have you injected using a needle?)';
	label IDU_crack = 'Crack (Which of the following drugs have you injected using a needle?)';
	label IDU_psych = 'Psychoactive or hallucinogenic substances (Which of the following drugs have you injected using a needle?)';
	label IDU_ecstasy = 'Ecstasy (Which of the following drugs have you injected using a needle?)';
	label IDU_otherdrug = 'Other (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_DK = 'Dont know/remember (Which of the following drugs have you injected using a needle?)';
	label IDU_drug_RF = 'Refused to answer (Which of the following drugs have you injected using a needle?)';
	label sex_num = 'How many sexual partners have you had in your lifetime?';
	label sex_STI = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with any sexually transmitted infections?';
	label sex_HBV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HBV?';
	label sex_HCV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HCV?';
	label sex_HIV = 'As far as you know, have any of hte sex partners you have had during your lifetime been diagnosed with HIV?';
	label condom = 'In your lifetime, how often have you used condoms with your sexual partners?';
	label sex_healthcare = 'Healthcare or emergency worker who comes into contact with blood (In your lifetime, have any of your sexual partners belonged to the
							following groups?)';
	label sex_military = 'Military (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_police = 'Police (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_dialysis = 'Person who regularly receives kidney dialysis, blood transfusions, or has hemophilia (In your lifetime, have any of your sexual 
						  partners belonged to the following groups?)';
	label sex_IDU = 'Injection drug user (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_CSW  = 'Commercial sex worker (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_none = 'None of the above (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label sex_RF = 'Refused (In your lifetime, have any of your sexual partners belonged to the following groups?)';
	label tattoo_salon = 'Beauty salon or tattoo salon (Where did you get your tattoo(s)?)';
	label tattoo_home = 'Home (Where did you get your tattoo(s)?)';
	label tattoo_prison = 'Prison (Where did you get your tattoo(s)?)';
	label tattoo_other = 'Somewhere else (Where did you get your tattoo(s)?)';
	label tattoo_DK = 'Dont know/remember (Where did you get your tattoo(s)?)';
	label MSM = '(Men) Have you ever had sex with another man?';
	label MSM_condom = 'How often do you use condoms with your same sex partner(s)?';
	label int_ID_NCD = 'Interviewer ID for NCD section';
	label nurse_ID = 'Nurse ID';
	label consent_NCD = 'Would you be willing to have your height, weight and blood pressure taken today?';
	label consent_blood = 'Would you be willing to give a blood sample for hepatitis C and B testing?';
	label consent_bank = 'If there is any remaining blood left over after testing for hepatitis, can it be used to test for other diseases
                          of public health interest?';
	label phone_results = 'Contact phone number to return results';
	label address_results = 'Mailing address, or best way to reach for returning results';
	label ethnicity = 'Ethnicity';
	label BP_ID = 'Blood pressure device ID';
	label cuff = 'Cuff size used for blood pressure';
	label cuff_other_specify = 'If other cuff size was used for blood pressure, please specify';
	label BP_s1 = 'BP reading 1: Systolic (mmHg)';
	label BP_d1 = 'BP reading 1: Diastolic (mmHg)';
	label BPM1 = 'BP reading 1: Beats per minute';
	label BP_s2 = 'BP reading 2: Systolic (mmHg)';
	label BP_d2 = 'BP reading 2: Diastolic (mmHg)';
	label BPM2 = 'BP reading 2: Beats per minute';
	label BP_s3 = 'BP reading 3: Systolic (mmHg)';
	label BP_d3 = 'BP reading 3: Diastolic (mmHg)';
	label BPM3 = 'BP reading 3: Beats per minute';
	label BP_treat = 'During the past 2 weeks, have you been treated for raised blood pressure with drugs (medication) prescribed
                      by a doctor or other health worker?';
	label height_ID = 'Height device ID';
	label weight_ID = 'Weight device ID';
	label height_cm = 'Participant height in cm';
	label kyphotic = 'Is participant kyphotic (their back is hunched over due to age or spinal malformation)?';
	label weight_kg = ' Participant weight in kg';
	label pregnant = '(Women) Is the participant pregnant?';
	label ethnicity_other_specify = 'If ethnicity recorded as other, please specify';
	label religion = 'Religion';
	label waist_ID = 'Waist device ID';
	label waist_cm = 'Participant waist circumference in cm';
	label hip_cm = 'Participant hip circumference in cm';
	label blood_collected = 'Was a 10ml tiger top tube collected?';	
	label blood_time = 'Time of day blood specimen collected (24 hour clock)';
	label religion_other_specify = 'If religion recorded as other, please specify';
	label married = 'Marital status';
	label piercing_salon = 'Beauty salon or tattoo salon (Where did you get your body piercing(s)?)';
	label piercing_home = 'Home (Where did you get your body piercing(s)?)';
	label piercing_prison = 'Prison (Where did you get your body piercing(s)?)';
	label piercing_other = 'Somewhere else (Where did you get your body piercing(s)?)';
	label piercing_DK = 'Dont know/remember (Where did you get your body piercing(s)?)';
	label work = 'Which of hte following best describes your main work status over hte past year?';
	label work_healthcare = 'Health care (In your lifetime, have you ever worked in any of the following fields?)';
	label work_military = 'Military (In your lifetime, have you ever worked in any of the following fields?)';
	label work_police = 'Police (In your lifetime, have you ever worked in any of the following fields?)';
	label manicure_salon = 'Beauty salon (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_homeservice = 'Home service (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_self = 'I always perform my own manicures and pedicures (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_never = 'I have never had a manicure or pedicure (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label manicure_other = 'Somewhere else (Have you ever gotten a manicure or pedicure at a beuaty salon or home service?)';
	label house = 'Does your family rent, or own the house you live in?';
	label house_other_specify =  'If rent/own was recorded as other, please specify';
	label resident_num = 'How many people older than 18 years, including yourself, live permanently in your household?';
	label earnings_cat = 'Income category - GEL per week/month/year';
	label earnings_amount = 'In the last year, can you tell me what the average earnings of your household have been?';
	label earnings_estimate = 'If you do not know the exact amount, can you give an estimate of your households monthly earning?' ;
	label earners_num = 'How many people earn money in your household?';
	label insurance = 'Do you currently have medical insurance?';
	label insurance_type = 'What kind of health insurance do you have?';
	label medcare_pay = 'How do you pay for medical care when you need it?';
	label medcare_pay_other_specify = 'If medical care payment was recorded as other, please specify';
	label displaced = 'Have you ever been forced to move from your house because of war or civil unrest?';
	label medcare_location = 'Where do you go for medical care when you need it?';
	label medcare_location_other_specify = 'If medical care location was recorded as other, please specify';
	label flu = 'Last winter, October 2014 to April 2015, did you have a severe respiratory illness, with a sudden onset fever and cough that made you 
	            short of breath or caused you to have difficulty breathing?';
	label flu_polyclinic = 'Polyclinic (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_hospital = 'Hospital (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_medhome = 'Health care provider comes to my house (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_pharmacy = 'Pharmacy (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_villagedoc = 'Village doctor (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_none = 'I do not seek care when I am sick or injured (If yes to severe respiratory illness, where did you go for medical care?)';
	label flu_other = 'Other (If yes to severe respiratory illness, where did you go for medical care?)';
	label hh_num = 'Household number';
	label hospital_lifetime_num = 'During your lifetime, how many times have you been admitted to the hospital for any reason?';
	label dentist_cat = 'How often do you visit the dentist to have your teeth cleaned?';
	label dentist_other_specify = 'If dental location was recorded as other, please specify'; 
	label dentist_hospital = 'Hospital (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_cabinet = 'Dental cabinet (Have you ever visited the dentist or had a dental procedure in any of the following locations?');
	label dentist_home = 'Someones home (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_other = 'Other (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';
	label dentist_DK = 'Do not know/remember (Have you ever visited the dentist or had a dental procedure in any of the following locations?)';;
	label dental_proc_num = 'How many invasive dental procedures have you had in your lifetime?';
	label shot_num = 'How many shots have you received in the last 6 months, including immunizations and medication to numb you before a medical
                    or dental procedure?';
	label flushot = 'Did you receive a flu shot during the last (2014-2015) influenza season?';
	label flushot_loc = 'If yes to flu shot, where did you receive it?';
	label shot_admin = 'Who administered your last shot?';
	label shot_admin_other = 'If shot administration was recorded as other, please specify';
	label shot_needle = 'Before you received this last shot, did you see where the needle and/or syringe was taken from?';
	label shot_needle_other_specify = 'If shot needle/syringe source was recorded as other, please specify';
	label shot_purpose = 'Why did you get this last shot?';
	label shot_purpose_other_specify = 'If shot purpose was recorded as other, please specify';
	label shot_med = 'What medication was injected in this last shot?';
	label shot_med_other_specify = 'If shot medication was recorded as other, please specify';
	label shot_discard = 'Did they throw the syringe away after your shot?';
	label stratum_num = 'Stratum number';
	label cluster_ID = 'Cluster ID';
	label cluster_name = 'Cluster, city, or village name';
	label IV_num = 'How many IV infusions have you received in the last 6 months?';
	label dialysis_ever = 'In your lifetime, have you ever received dialysis for your kidneys?';
	label dialysis_polyclinic = 'Polyclinic (In what type of facilities have you received kidney dialysis?)';
	label dialysis_hospital = 'Hospital (In what type of facilities have you received kidney dialysis?)';
	label dialysis_home = 'Helath care provider comes to my house (In what type of facilities have you received kidney dialysis?)';
	label dialysis_pharmacy = 'Pharmacy (In what type of facilities have you received kidney dialysis?)';
	label dialysis_villagedoc = 'Village doctor (In what type of facilities have you received kidney dialysis?)';
	label dialysis_other = 'Other (In what type of facilities have you received kidney dialysis?)';
	label dialysis_current = 'Do you currently receive dialysis for your kidneys?';
	label dialysis_freq = 'How many times a week do you receive dialysis for your kidneys?';
	label blood_trans = 'Have you received any blood transfusions in your lifetime?';
	label blood_trans_num = 'How many times in your life have you received a transfusion of blood or blood products?';
	label blood_trans_relative = 'Did any of your blood transfusions come from a friend or relative?';
	label blood_donate = 'Have you ever donated blood?';
	label blood_donate_relative = 'Have you ever donated blood to a relative or friend who needed it?';
	label int_date = 'Confirm interview date';
	label blood_donate_money = 'Have you ever donated blood in exchange for money?';
	label med_invasive = 'During your lifetime, have you ever had an invasive medical procedure?';
	label surgery_ever = 'During your lifetime, have you ever had any type of surgery?';
	label surgery_num = 'During your lifetime, how many surgeries have you had?';
	label surgery_hospital = 'Hospital (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_nursing = 'Nursing home (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_polyclinic = 'Polyclinic (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_other = 'Other (Have you ever had surgery in any of the following locations during your lifetime?)';
	label surgery_DK = 'Do not know/remember (Have you ever had surgery in any of the following locations during your lifetime?)';
	label sti_ever = 'Have you ever been told by a doctor or other health worker that you had a sexually transmitted disease?';
	label sti_syphilis = 'Syphilis (Which sexually transmitted disease have you been diagnosed with?');
	label sti_gonorrhea = 'Gonorrhea (Which sexually transmitted disease have you been diagnosed with?');
	label sti_chlamydia = 'Chlamydia (Which sexually transmitted disease have you been diagnosed with?');
	label sti_herpes = 'Herpes (Which sexually transmitted disease have you been diagnosed with?');
	label sti_warts = 'Genital warts (Which sexually transmitted disease have you been diagnosed with?');
	label sti_other = 'Other (Which sexually transmitted disease have you been diagnosed with?');
	label HIV_test = 'Have you ever been tested for HIV, the virus that causes AIDS?';
	label HIV_result = 'What were your HIV test results?';
	label tb_ever = 'Have you ever been told by a doctor or other health worker that you have tuberculosis?';
	label int_start_time = 'Interview start time';
	label tb_year = 'Have you been told that you have tuberculosis in the past 12 months?';
	label tb_treat = 'Have you ever been treated for your tuberculosis?';
	label bp_meas = 'Have you ever had your blood pressure measured by a doctor or other health worker?';
	label hypertension_ever = 'Have you ever been told by a doctor or other health worker that you have raised blood pressure or hypertension?';
	label hypertension_year = 'Have you been told that you have raised blood pressure or hypertension in the past 12 months?';
	label sugar_meas = 'Have you ever had your blood sugar measured by a doctor or other health worker?';
	label diabetes_ever = 'Have you ever been told by a doctor or other health worker that you have high blood sugar or diabetes?';
	label diabetes_year = 'Have you been told that you have raised blood sugar or diabetes in the past 12 months?';
	label insulin_current = 'Are you currently taking insulin therapy?';
	label sugar_test_share = 'Have you ever tested your blood sugar using a needle that you shared with others?';
	label consent_int = 'Consent given for interview?';
	label insulin_syringe_share = 'Have you ever shared insulin syringes with others?';
	label chronic_asthma = 'Asthma (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_arthritis = 'Arthritis (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_cancer = 'Cancer (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_CVD = 'Cardiovascular disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_COPD = 'Chronic obstructive pulmonary disease (COPD) (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_hemophilia = 'Hemophilia or other blood disorders (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_thyroid = 'Thyroid problems (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_kidney = 'Kidney disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_lung = 'Lung disease (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other = 'Other (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you have any of the following chronic medical conditions?)';
	label chronic_other_specify = 'If other chronic condition was recorded, please state what type';
	label cancer_type = 'If cancer was recorded, please state what type';
	label HCV_heard = 'Have you ever heard of the hepatitis C virus, or HCV?';
	label HCV_trans_droplets = 'Droplets (Do you know how HCV is transmitted?)';
	label HCV_trans_food = 'Food (Do you know how HCV is transmitted?)';
	label HCV_trans_blood = 'Blood  (Do you know how HCV is transmitted?)';
	label HCV_trans_sex = 'Sexual contact (Do you know how HCV is transmitted?)';
	label HCV_trans_handshake = 'Handshake with an infected person (Do you know how HCV is transmitted?)';
	label HCV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HCV is transmitted?)';
	label HCV_trans_needle = 'Sharing needles or syringes (Do you know how HCV is transmitted?)';
	label HCV_trans_touch = 'Touching items in public places (Do you know how HCV is transmitted?)';
	label HCV_trans_DK = 'Do not know/remember (Do you know how HCV is transmitted?)';
	label HCV_trans_none = 'None of the above (Do you know how HCV is transmitted?)';
	label HCV_trans_other = 'Other (Do you know how HCV is transmitted?)';
	label HCV_trans_other_specify = 'If other mode of HCV transmission was recorded, please state how';
	label HCV_asymptomatic = 'Is it possible to have HCV but not have any symptoms?';
	label HCV_med = 'Are there medications available to treat HCV infections?';
	label trust_family = 'Talking with family members, friends, neighbors or colleagues (Where do you get health information that you trust?)';
	label trust_medlit = 'Special medical literature (Where do you get health information that you trust?)';
	label trust_newspaper = 'Newspapers and magazines (Where do you get health information that you trust?)';
	label trust_radio = 'Radio (Where do you get health information that you trust?)';
	label trust_tv = 'TV (Where do you get health information that you trust?)';
	label trust_internet = 'Internet (Where do you get health information that you trust?)';
	label trust_billboards = 'Billboards (Where do you get health information that you trust?)';
	label trust_brochures = 'Brochures, fliers, posters, or other printed materials (Where do you get health information that you trust?)';
	label trust_doctor = 'Doctors and other healthcare workers (Where do you get health information that you trust?)';
	label trust_pharmacist = 'Pharmacists (Where do you get health information that you trust?)';
	label trust_DK = 'Do not know/remember (Where do you get health information that you trust?)';
	label trust_none = 'None of the above (Where do you get health information that you trust?)';
	label trust_other = 'Other (Where do you get health information that you trust?)';
	label trust_other_specify = 'If other source of HCV information was recorded, please specify';
	label HBV_heard = 'Have you ever heard of the hepatitis B virus?';
	label consent_demo = 'If consent not given for interview, is participant OK giving basic demographic information?';
	label HCV_prev_vacc = 'Get a vaccination (What can you do to prevent HCV infection?)';
	label HCV_prev_condom = 'Use condoms (What can you do to prevent HCV infection?)';
	label HCV_prev_needle = 'Avoid sharing syringes or needles with other people (What can you do to prevent HCV infection?)';
	label HCV_prev_wash = 'Wash hands thoroughly (What can you do to prevent HCV infection?)';
	label HCV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to prevent HCV infection?)';
	label HCV_prev_DK = 'Do not know/remember (What can you do to prevent HCV infection?)';
	label HCV_prev_other = 'Other (What can you do to prevent HCV infection?)';
	label HCV_prev_none = 'None of the above (What can you do to prevent HCV infection?)';
	label language = 'Interview language';
	label HBV_trans_droplets = 'Droplets (Do you know how HBV is transmitted?)';
	label HBV_trans_food = 'Food (Do you know how HBV is transmitted?)';
	label HBV_trans_blood = 'Blood (Do you know how HBV is transmitted?)';
	label HBV_trans_sex = 'Sexual contact (Do you know how HBV is transmitted?)';
	label HBV_trans_handshake = 'Handshake with an infected person (Do you know how HBV is transmitted?)';
	label HBV_trans_hh_objects = 'Sharing household objects like razors or toothbrushes (Do you know how HBV is transmitted?)';
	label HBV_trans_needle = 'Sharing needles or syringes (Do you know how HBV is transmitted?)';
	label HBV_trans_touch = 'Touching items in public places (Do you know how HBV is transmitted?)';
	label HBV_trans_DK = 'Dont know/Remember (Do you know how HBV is transmitted?)';
	label HBV_trans_none = 'None of the above (Do you know how HBV is transmitted?)';
	label HBV_trans_other = 'Other (Do you know how HBV is transmitted?)';
	label HBV_trans_other_specify = 'If HBV transmission mode recorded as other, please state how';
	label HBV_asymptomatic = 'Is it possible to have HBV but not have any symptoms?';
	label HBV_med = 'Are there medications available to reat HBV infections?';
	label HBV_prev_vacc = 'Get a vaccination (What can you do to help prevent HBV infection?)';
	label HBV_prev_condom = 'Use condoms (What can you do to help prevent HBV infection?)';
	label HBV_prev_needle = 'Avoid sharing needles and syringes (What can you do to help prevent HBV infection?)';
	label HBV_prev_wash = 'Wash hads frequently (What can you do to help prevent HBV infection?)';
	label HBV_prev_sterile = 'Avoid unsterile or used medical devices (What can you do to help prevent HBV infection?)';
	label HBV_prev_DK = 'Dont know/Remember (What can you do to help prevent HBV infection?)';
	label HBV_prev_none = 'None of the above (What can you do to help prevent HBV infection?)';
	label HCV_ever = 'Have you ever been told by a doctor or other health worker that you have hepatitis C?';
	label HCV_year = 'What year were you told that you had hepatitis C?';
	label HCV_treated = 'Have you ever taken medications to treat your hepatitis C infection?';
	label HCV_notreat_avail = 'The medication was not available (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_eligible = 'My doctor told me I was not eligible to take the medication (Why didnt you take medication to treat 
          your hepatitis C infection?)';
	label HCV_notreat_expense = 'The medication was too expensive (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_effect = 'I heard that the medication has a lot of side effects (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_inject = 'I did not want to inject myself with a needle (Why didnt you take medication to treat your 
          hepatitis C infection?)';
	label HCV_notreat_other_specify = 'Other, specify ((Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_DK = 'Dont know/remember (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_RF = 'Refused (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_notreat_travel = 'I would ahve to travel too far to get the medication, or to see hte doctor in order to get
	      the medication (Why didnt you take medication to treat your hepatitis C infection?)';
	label HCV_treat_complete = 'Did you complete your hepatitis C treatment, or did you stop before the end?';
	label HCV_cured = 'Did the treatment cure your hepatitis C infection?';
	label surname = 'Family surname';
	label HBV_ever = 'Have you been told by a doctor or other health worker that you have hepatitis B?';
	label HBV_year = 'What year were you told that you have hepatitis B?';
	label HBV_treated = 'Have you ever taken medications to treat your hepatitis B infection?';
	label HBV_vacc_ever = 'Have you ever been vaccinated against hepatitis B infection?';
	label hep_other_A = 'Hepatitis A (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';
	label hep_other_D = 'Hepatitis D (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_E = 'Hepatitis E (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_none = 'None (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_DK = 'Do not know/remember (Have you ever been told by a doctor or other health worker that you had any other type of hepatitis?)';;
	label hep_other_year = 'What year were you told that you had this other type of hepatitis?';
	label alc_ever = 'Have you ever consumed an alcoholic drink such as beer, wine, or spirits?';
	label alc_year = 'Have you consumed an alcoholic drink within the past 12 months?' ;
	label alc_year_freq = 'During the past 12 months, how frequently have you had at least one alcoholic drink?';
	label alc_month = 'Have you consumed an alcoholic drink within the past 30 days?';
	label disposition = 'Interview disposition: Did you complete the entire questionnaire?';
	label disposition_other_specify = 'If interview disposition recorded as other, please specify';

	run;

*Dropping variables;;
data HCV10.HCVformat;
set HCV10.HCVlabel (drop=
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C

CONSENT_Q22_D12

CONSENT_CONSENT2_Q32_M4_Q32A
CONSENT_CONSENT2_Q32_M4_Q32B
CONSENT_CONSENT2_Q32_M4_Q32C
CONSENT_CONSENT2_Q32_M4_Q32D
CONSENT_CONSENT2_Q32_M4_Q32E

CONSENT_CONSENT2_Q42_M15_Q42A
CONSENT_CONSENT2_Q42_M15_Q42B
CONSENT_CONSENT2_Q42_M15_Q42C
CONSENT_CONSENT2_Q42_M15_Q42D
CONSENT_CONSENT2_Q42_M15_Q42E
CONSENT_CONSENT2_Q42_M15_Q42G

CONSENT_CONSENT2_Q54_S4_Q54A
CONSENT_CONSENT2_Q54_S4_Q54B
CONSENT_CONSENT2_Q54_S4_Q54C
CONSENT_CONSENT2_Q54_S4_Q54D
CONSENT_CONSENT2_Q54_S4_Q54E

CONSENT_CONSENT2_Q56_STI2_Q56A
CONSENT_CONSENT2_Q56_STI2_Q56B
CONSENT_CONSENT2_Q56_STI2_Q56C
CONSENT_CONSENT2_Q56_STI2_Q56D
CONSENT_CONSENT2_Q56_STI2_Q56E
CONSENT_CONSENT2_Q56_STI2_Q56F

CONSENT_CONSENT2_Q71_CD1_Q71A
CONSENT_CONSENT2_Q71_CD1_Q71B
CONSENT_CONSENT2_Q71_CD1_Q71C
CONSENT_CONSENT2_Q71_CD1_Q71D
CONSENT_CONSENT2_Q71_CD1_Q71E
CONSENT_CONSENT2_Q71_CD1_Q71F
CONSENT_CONSENT2_Q71_CD1_Q71G
CONSENT_CONSENT2_Q71_CD1_Q71H
CONSENT_CONSENT2_Q71_CD1_Q71I
CONSENT_CONSENT2_Q71_CD1_Q71J
CONSENT_CONSENT2_Q71_CD1_Q71K

CONSENT_CONSENT2_Q74_H2_Q74A
CONSENT_CONSENT2_Q74_H2_Q74B
CONSENT_CONSENT2_Q74_H2_Q74C
CONSENT_CONSENT2_Q74_H2_Q74D
CONSENT_CONSENT2_Q74_H2_Q74E
CONSENT_CONSENT2_Q74_H2_Q74F
CONSENT_CONSENT2_Q74_H2_Q74G
CONSENT_CONSENT2_Q74_H2_Q74H
CONSENT_CONSENT2_Q74_H2_Q74I
CONSENT_CONSENT2_Q74_H2_Q74J
CONSENT_CONSENT2_Q74_H2_Q74K

CONSENT_CONSENT2_Q77_H5_Q77A
CONSENT_CONSENT2_Q77_H5_Q77B
CONSENT_CONSENT2_Q77_H5_Q77C
CONSENT_CONSENT2_Q77_H5_Q77D
CONSENT_CONSENT2_Q77_H5_Q77E
CONSENT_CONSENT2_Q77_H5_Q77F
CONSENT_CONSENT2_Q77_H5_Q77G
CONSENT_CONSENT2_Q77_H5_Q77H
CONSENT_CONSENT2_Q78_H6_Q78A
CONSENT_CONSENT2_Q78_H6_Q78B
CONSENT_CONSENT2_Q78_H6_Q78C
CONSENT_CONSENT2_Q78_H6_Q78D
CONSENT_CONSENT2_Q78_H6_Q78E
CONSENT_CONSENT2_Q78_H6_Q78F
CONSENT_CONSENT2_Q78_H6_Q78G
CONSENT_CONSENT2_Q78_H6_Q78H
CONSENT_CONSENT2_Q78_H6_Q78I
CONSENT_CONSENT2_Q78_H6_Q78J
CONSENT_CONSENT2_Q78_H6_Q78K
CONSENT_CONSENT2_Q78_H6_Q78L
CONSENT_CONSENT2_Q78_H6_Q78M

CONSENT_CONSENT2_Q80_H8_Q80A
CONSENT_CONSENT2_Q80_H8_Q80B
CONSENT_CONSENT2_Q80_H8_Q80C
CONSENT_CONSENT2_Q80_H8_Q80D
CONSENT_CONSENT2_Q80_H8_Q80E
CONSENT_CONSENT2_Q80_H8_Q80F
CONSENT_CONSENT2_Q80_H8_Q80G
CONSENT_CONSENT2_Q80_H8_Q80H
CONSENT_CONSENT2_Q80_H8_Q80I
CONSENT_CONSENT2_Q80_H8_Q80J
CONSENT_CONSENT2_Q80_H8_Q80K

CONSENT_CONSENT2_Q83_H11_Q83A
CONSENT_CONSENT2_Q83_H11_Q83B
CONSENT_CONSENT2_Q83_H11_Q83C
CONSENT_CONSENT2_Q83_H11_Q83D
CONSENT_CONSENT2_Q83_H11_Q83E
CONSENT_CONSENT2_Q83_H11_Q83F
CONSENT_CONSENT2_Q83_H11_Q83G

CONSENT_CONSENT2_Q87_H15_Q87A
CONSENT_CONSENT2_Q87_H15_Q87B
CONSENT_CONSENT2_Q87_H15_Q87C
CONSENT_CONSENT2_Q87_H15_Q87D
CONSENT_CONSENT2_Q87_H15_Q87E
CONSENT_CONSENT2_Q87_H15_Q87F
CONSENT_CONSENT2_Q87_H15_Q87G
CONSENT_CONSENT2_Q87_H15_Q87H
CONSENT_CONSENT2_Q87_H15_Q87I

CONSENT_CONSENT2_Q94_H22_Q94A
CONSENT_CONSENT2_Q94_H22_Q94B
CONSENT_CONSENT2_Q94_H22_Q94C
CONSENT_CONSENT2_Q94_H22_Q94D
CONSENT_CONSENT2_Q94_H22_Q94E

CONSENT_CONSENT2_Q110_T4_Q110A
CONSENT_CONSENT2_Q110_T4_Q110B
CONSENT_CONSENT2_Q110_T4_Q110C
CONSENT_CONSENT2_Q110_T4_Q110D
CONSENT_CONSENT2_Q110_T4_Q110E
CONSENT_CONSENT2_Q110_T4_Q110F
CONSENT_CONSENT2_Q110_T4_Q110G
CONSENT_CONSENT2_Q110_T4_Q110H
CONSENT_CONSENT2_Q110_T4_Q110I
CONSENT_CONSENT2_Q110_T4_Q110J
CONSENT_CONSENT2_Q110_T4_Q110K

CONSENT_CONSENT2_Q117_R7_Q117A
CONSENT_CONSENT2_Q117_R7_Q117B
CONSENT_CONSENT2_Q117_R7_Q117C
CONSENT_CONSENT2_Q117_R7_Q117D
CONSENT_CONSENT2_Q117_R7_Q117E

CONSENT_CONSENT2_Q119_R9_Q119A_
CONSENT_CONSENT2_Q119_R9_Q119B_
CONSENT_CONSENT2_Q119_R9_Q119C_
CONSENT_CONSENT2_Q119_R9_Q119D_
CONSENT_CONSENT2_Q119_R9_Q119E_
CONSENT_CONSENT2_Q120A_R10A

CONSENT_CONSENT2_Q120_R10_Q120A  
CONSENT_CONSENT2_Q120_R10_Q120B  
CONSENT_CONSENT2_Q120_R10_Q120C  
CONSENT_CONSENT2_Q120_R10_Q120D  

CONSENT_CONSENT2_Q122_R12_Q122A
CONSENT_CONSENT2_Q122_R12_Q122B
CONSENT_CONSENT2_Q122_R12_Q122C
CONSENT_CONSENT2_Q122_R12_Q122D
CONSENT_CONSENT2_Q122_R12_Q122E
CONSENT_CONSENT2_Q122_R12_Q122F
CONSENT_CONSENT2_Q122_R12_Q122G 

CONSENT_CONSENT2_Q127_I5_Q127A
CONSENT_CONSENT2_Q127_I5_Q127B
CONSENT_CONSENT2_Q127_I5_Q127C
CONSENT_CONSENT2_Q127_I5_Q127D
CONSENT_CONSENT2_Q127_I5_Q127E
CONSENT_CONSENT2_Q127_I5_Q127F
CONSENT_CONSENT2_Q127_I5_Q127G
CONSENT_CONSENT2_Q127_I5_Q127H
CONSENT_CONSENT2_Q127_I5_Q127I

CONSENT_CONSENT2_Q132_I10_Q132A
CONSENT_CONSENT2_Q132_I10_Q132B
CONSENT_CONSENT2_Q132_I10_Q132C
CONSENT_CONSENT2_Q132_I10_Q132D
CONSENT_CONSENT2_Q132_I10_Q132E
CONSENT_CONSENT2_Q132_I10_Q132F
CONSENT_CONSENT2_Q132_I10_Q132G
CONSENT_CONSENT2_Q132_I10_Q132H
CONSENT_CONSENT2_Q132_I10_Q132I
CONSENT_CONSENT2_Q132_I10_Q132J
CONSENT_CONSENT2_Q132_I10_Q132K
CONSENT_CONSENT2_Q132_I10_Q132L
CONSENT_CONSENT2_Q132_I10_Q132M
CONSENT_CONSENT2_Q132_I10_Q132N
CONSENT_CONSENT2_Q132_I10_Q132O

CONSENT_CONSENT2_Q139_SP7_Q139A
CONSENT_CONSENT2_Q139_SP7_Q139B
CONSENT_CONSENT2_Q139_SP7_Q139C
CONSENT_CONSENT2_Q139_SP7_Q139D
CONSENT_CONSENT2_Q139_SP7_Q139E
CONSENT_CONSENT2_Q139_SP7_Q139F
CONSENT_CONSENT2_Q139_SP7_Q139G
CONSENT_CONSENT2_Q139_SP7_Q139H
CONSENT_CONSENT2_Q113_R3_Q113A
CONSENT_CONSENT2_Q113_R3_Q113B
CONSENT_CONSENT2_Q113_R3_Q113C
CONSENT_CONSENT2_Q113_R3_Q113D
CONSENT_CONSENT2_Q113_R3_Q113E

/* same variables */

Q0_BARCODE
Q1_I1
Q2A_I2
Q3A_I3
Q3B_I3
Q4_I4
Q5_I5
Q6_I6
Q7_I7
Q7A_CONSENT
Q8_I8
CONSENT_Q9_I9
CONSENT_Q10_I10
Q11_D1
CONSENT_Q12A_D2
CONSENT_Q12B_D2
CONSENT_Q13_D3
CONSENT_Q14_D4
CONSENT_Q15_D5
CONSENT_Q15A_D5_OTHER
CONSENT_Q16_D6
CONSENT_Q16A_D6_OTHER
CONSENT_Q17_D7
CONSENT_Q18_D8
CONSENT_Q19_D9_Q19A
CONSENT_Q19_D9_Q19B
CONSENT_Q19_D9_Q19C
CONSENT_Q20_D10
CONSENT_Q20A_D10_OTHER
CONSENT_Q21_D11
CONSENT_Q22_D12
CONSENT_Q22A_D12
CONSENT_Q23_D13
CONSENT_Q24_D14
CONSENT_Q25_D15
CONSENT_Q26_D16
CONSENT_Q27_D17
CONSENT_Q27A_D17_OTHER
CONSENT_Q28_D18
CONSENT_CONSENT2_Q29_M1
CONSENT_CONSENT2_Q29A_M1_OTHER
CONSENT_CONSENT2_Q29B_M1B
/*CONSNTCNSENT2Q29CM1C_Q29C_A
CONSNTCNSENT2Q29CM1C_Q29C_B
CONSNTCNSENT2Q29CM1C_Q29C_C
CONSNTCNSENT2Q29CM1C_Q29C_D
CONSNTCNSENT2Q29CM1C_Q29C_E
CONSNTCNSENT2Q29CM1C_Q29C_F*/
CONSENT_CONSENT2_Q30_M2
/*CONSNTCNSENT2Q29CM1C_Q29C_G*/
CONSENT_CONSENT2_Q31_M3
CONSENT_CONSENT2_Q32_M4A
/*CONSENTCONSENT2Q32M4_Q32A
CONSENTCONSENT2Q32M4_Q32B
CONSENTCONSENT2Q32M4_Q32C
CONSENTCONSENT2Q32M4_Q32D
CONSENTCONSENT2Q32M4_Q32E*/
CONSENT_CONSENT2_Q33_M5
CONSENT_CONSENT2_Q34_M6
CONSENT_CONSENT2_Q34A_M6_1
CONSENT_CONSENT2_Q34B_M6_2
CONSENT_CONSENT2_Q35_M7
CONSENT_CONSENT2_Q35A_M7_OTHER
CONSENT_CONSENT2_Q36_M8
CONSENT_CONSENT2_Q36A_M8_OTHER
CONSENT_CONSENT2_Q37_M9
CONSENT_CONSENT2_Q37A_M9_OTHER
CONSENT_CONSENT2_Q38_M10
CONSENT_CONSENT2_Q38A_M10_OTHER
CONSENT_CONSENT2_Q39_M11
CONSENT_CONSENT2_Q40_M12
CONSENT_CONSENT2_Q41_M14
/*CONSNTCNSENT2Q42M15_Q42A
CONSNTCNSENT2Q42M15_Q42B
CONSNTCNSENT2Q42M15_Q42C
CONSNTCNSENT2Q42M15_Q42D
CONSNTCNSENT2Q42M15_Q42E
CONSNTCNSENT2Q42M15_Q42G*/
CONSENT_CONSENT2_Q43_M16
CONSENT_CONSENT2_Q44_M17
CONSENT_CONSENT2_Q45_M18
CONSENT_CONSENT2_Q46_M19
CONSENT_CONSENT2_Q47_M20
CONSENT_CONSENT2_Q48_M21
CONSENT_CONSENT2_Q49_M22
CONSENT_CONSENT2_Q50_M23
CONSENT_CONSENT2_Q51_S1
CONSENT_CONSENT2_Q52_S2
CONSENT_CONSENT2_Q53_S3
/*CONSENTCONSENT2Q54S4_Q54A
CONSENTCONSENT2Q54S4_Q54B
CONSENTCONSENT2Q54S4_Q54C
CONSENTCONSENT2Q54S4_Q54D
CONSENTCONSENT2Q54S4_Q54E*/
CONSENT_CONSENT2_Q55_STI1
/*CONSNTCONSNT2Q56STI2_Q56A
CONSNTCONSNT2Q56STI2_Q56B
CONSNTCONSNT2Q56STI2_Q56C
CONSNTCONSNT2Q56STI2_Q56D
CONSNTCONSNT2Q56STI2_Q56E
CONSNTCONSNT2Q56STI2_Q56F*/
CONSENT_CONSENT2_Q57_STI3
CONSENT_CONSENT2_Q58_STI4
CONSENT_CONSENT2_Q59_TB1
CONSENT_CONSENT2_Q60_TB2
CONSENT_CONSENT2_Q61_TB3
CONSENT_CONSENT2_Q62_HY1
CONSENT_CONSENT2_Q63_HY2
CONSENT_CONSENT2_Q64_HY3
CONSENT_CONSENT2_Q65_D1
CONSENT_CONSENT2_Q66_D2
CONSENT_CONSENT2_Q67_D3
CONSENT_CONSENT2_Q68_D4
CONSENT_CONSENT2_Q69_D5
CONSENT_CONSENT2_Q70_D6
/*CONSNTCNSENT2Q71CD1_Q71A
CONSNTCNSENT2Q71CD1_Q71B
CONSNTCNSENT2Q71CD1_Q71C
CONSNTCNSENT2Q71CD1_Q71D
CONSNTCNSENT2Q71CD1_Q71E
CONSNTCNSENT2Q71CD1_Q71F
CONSNTCNSENT2Q71CD1_Q71G
CONSNTCNSENT2Q71CD1_Q71H
CONSNTCNSENT2Q71CD1_Q71I
CONSNTCNSENT2Q71CD1_Q71J
CONSNTCNSENT2Q71CD1_Q71K*/
CONSENT_CONSENT2_Q71L_CD1_OTHER
CONSENT_CONSENT2_Q72_CD2
CONSENT_CONSENT2_Q73_H1
/*CONSENTCONSENT2Q74H2_Q74A
CONSENTCONSENT2Q74H2_Q74B
CONSENTCONSENT2Q74H2_Q74C
CONSENTCONSENT2Q74H2_Q74D
CONSENTCONSENT2Q74H2_Q74E
CONSENTCONSENT2Q74H2_Q74F
CONSENTCONSENT2Q74H2_Q74G
CONSENTCONSENT2Q74H2_Q74H
CONSENTCONSENT2Q74H2_Q74I
CONSENTCONSENT2Q74H2_Q74J
CONSENTCONSENT2Q74H2_Q74K*/
CONSENT_CONSENT2_Q74L_H2A
CONSENT_CONSENT2_Q75_H3
CONSENT_CONSENT2_Q76_H4
/*CONSENTCONSENT2Q7H5_Q77A
CONSENTCONSENT2Q7H5_Q77B
CONSENTCONSENT2Q7H5_Q77C
CONSENTCONSENT2Q7H5_Q77D
CONSENTCONSENT2Q7H5_Q77E
CONSENTCONSENT2Q7H5_Q77F
CONSENTCONSENT2Q7H5_Q77G
CONSENTCONSENT2Q7H5_Q77H*/
/*CONSENTCONSENT2Q78H6_Q78A
CONSENTCONSENT2Q78H6_Q78B
CONSENTCONSENT2Q78H6_Q78C
CONSENTCONSENT2Q78H6_Q78D
CONSENTCONSENT2Q78H6_Q78E
CONSENTCONSENT2Q78H6_Q78F
CONSENTCONSENT2Q78H6_Q78G
CONSENTCONSENT2Q78H6_Q78H
CONSENTCONSENT2Q78H6_Q78I
CONSENTCONSENT2Q78H6_Q78J
CONSENTCONSENT2Q78H6_Q78K
CONSENTCONSENT2Q78H6_Q78L
CONSENTCONSENT2Q78H6_Q78M*/
CONSENT_CONSENT2_Q78N_H6A
CONSENT_CONSENT2_Q79_H7
/*CONSENTCONSENT2Q80H8_Q80A
CONSENTCONSENT2Q80H8_Q80B
CONSENTCONSENT2Q80H8_Q80C
CONSENTCONSENT2Q80H8_Q80D
CONSENTCONSENT2Q80H8_Q80E
CONSENTCONSENT2Q80H8_Q80F
CONSENTCONSENT2Q80H8_Q80G
CONSENTCONSENT2Q80H8_Q80H
CONSENTCONSENT2Q80H8_Q80I
CONSENTCONSENT2Q80H8_Q80J
CONSENTCONSENT2Q80H8_Q80K*/
CONSENT_CONSENT2_Q80L_H8A
CONSENT_CONSENT2_Q81_H9
CONSENT_CONSENT2_Q82_H10
/*CONSENTCONSENT2Q83H1_Q83A
CONSENTCONSENT2Q83H1_Q83B
CONSENTCONSENT2Q83H1_Q83C
CONSENTCONSENT2Q83H1_Q83D
CONSENTCONSENT2Q83H1_Q83E
CONSENTCONSENT2Q83H1_Q83F
CONSENTCONSENT2Q83H1_Q83G*/
CONSENT_CONSENT2_Q84_H12
CONSENT_CONSENT2_Q85_H13
CONSENT_CONSENT2_Q86_H14
/*CONSNTCNSENT2Q87H15_Q87A
CONSNTCNSENT2Q87H15_Q87B
CONSNTCNSENT2Q87H15_Q87C
CONSNTCNSENT2Q87H15_Q87D
CONSNTCNSENT2Q87H15_Q87E
CONSNTCNSENT2Q87H15_Q87F
CONSNTCNSENT2Q87H15_Q87G
CONSNTCNSENT2Q87H15_Q87H
CONSNTCNSENT2Q87H15_Q87I*/
CONSENT_CONSENT2_Q88_H16
CONSENT_CONSENT2_Q89_H17
CONSENT_CONSENT2_Q90_H18
CONSENT_CONSENT2_Q91_H19
CONSENT_CONSENT2_Q92_H20
CONSENT_CONSENT2_Q93_H21
/*CONSENTCONSENT2Q94H2_Q94A
CONSENTCONSENT2Q94H2_Q94B
CONSENTCONSENT2Q94H2_Q94C
CONSENTCONSENT2Q94H2_Q94D
CONSENTCONSENT2Q94H2_Q94E*/
CONSENT_CONSENT2_Q95_H23
CONSENT_CONSENT2_Q96_A1A
CONSENT_CONSENT2_Q97_A1B
CONSENT_CONSENT2_Q98_A2
CONSENT_CONSENT2_Q99_A3
CONSENT_CONSENT2_Q100_A4
CONSENT_CONSENT2_Q101_A5
CONSENT_CONSENT2_Q102_A6
CONSENT_CONSENT2_Q103A_A7_MALES
CONSENT_CONSENT2_Q103B_A7_FEMAL
CONSENT_CONSENT2_Q104_PA1
CONSENT_CONSENT2_Q105_PA2
CONSENT_CONSENT2_Q106_PA3
CONSENT_CONSENT2_Q107_T1
CONSENT_CONSENT2_Q108_T2
CONSENT_CONSENT2_Q109_T3
/*CONSENTCONSENT2Q10T4_Q110A
CONSENTCONSENT2Q10T4_Q110B
CONSENTCONSENT2Q10T4_Q110C
CONSENTCONSENT2Q10T4_Q110D
CONSENTCONSENT2Q10T4_Q110E
CONSENTCONSENT2Q10T4_Q110F
CONSENTCONSENT2Q10T4_Q110G
CONSENTCONSENT2Q10T4_Q110H
CONSENTCONSENT2Q10T4_Q110I
CONSENTCONSENT2Q10T4_Q110J
CONSENTCONSENT2Q10T4_Q110K*/
CONSENT_CONSENT2_Q111_R1
CONSENT_CONSENT2_Q112_R2
CONSENT_CONSENT2_Q113F_R3A
CONSENT_CONSENT2_Q114_R4
CONSENT_CONSENT2_Q115_R5
CONSENT_CONSENT2_Q116_R6
CONSENT_CONSENT2_Q117F_R7A
/*CONSENTCONSENT2Q17R7_Q117A
CONSENTCONSENT2Q17R7_Q117B
CONSENTCONSENT2Q17R7_Q117C
CONSENTCONSENT2Q17R7_Q117D
CONSENTCONSENT2Q17R7_Q117E*/
CONSENT_CONSENT2_Q118_R8
CONSENT_CONSENT2_Q119A_R9A
/*CONSENTCONSENT2Q19R9_Q119A_R9
CONSENTCONSENT2Q19R9_Q119B_R9
CONSENTCONSENT2Q19R9_Q119C_R9
CONSENTCONSENT2Q19R9_Q119D_R9
CONSENTCONSENT2Q19R9_Q119E_R9*/
CONSENT_CONSENT2_Q120A_R10A
CONSENT_CONSENT2_Q120E_R10E
/*CONSNTCNSENT2Q120R10_Q120A
CONSNTCNSENT2Q120R10_Q120B
CONSNTCNSENT2Q120R10_Q120C
CONSNTCNSENT2Q120R10_Q120D*/
CONSENT_CONSENT2_Q121_R11
/*CONSNTCNSENT2Q12R12_Q122A
CONSNTCNSENT2Q12R12_Q122B
CONSNTCNSENT2Q12R12_Q122C
CONSNTCNSENT2Q12R12_Q122D
CONSNTCNSENT2Q12R12_Q122E
CONSNTCNSENT2Q12R12_Q122F
CONSNTCNSENT2Q12R12_Q122G*/
CONSENT_CONSENT2_Q123_I1
CONSENT_CONSENT2_Q124_I2
CONSENT_CONSENT2_Q125_I3
CONSENT_CONSENT2_Q126_I4
/*CONSNTCONSNT2Q127I5_Q127A
CONSNTCONSNT2Q127I5_Q127B
CONSNTCONSNT2Q127I5_Q127C
CONSNTCONSNT2Q127I5_Q127D
CONSNTCONSNT2Q127I5_Q127E
CONSNTCONSNT2Q127I5_Q127F
CONSNTCONSNT2Q127I5_Q127G
CONSNTCONSNT2Q127I5_Q127H
CONSNTCONSNT2Q127I5_Q127I*/
CONSENT_CONSENT2_Q128_I6
CONSENT_CONSENT2_Q129_I7
CONSENT_CONSENT2_Q130_I8
CONSENT_CONSENT2_Q131_I9
/*CONSNTCONSNT2Q132I10_Q132A
CONSNTCONSNT2Q132I10_Q132B
CONSNTCONSNT2Q132I10_Q132C
CONSNTCONSNT2Q132I10_Q132D
CONSNTCONSNT2Q132I10_Q132E
CONSNTCONSNT2Q132I10_Q132F
CONSNTCONSNT2Q132I10_Q132G
CONSNTCONSNT2Q132I10_Q132H
CONSNTCONSNT2Q132I10_Q132I
CONSNTCONSNT2Q132I10_Q132J
CONSNTCONSNT2Q132I10_Q132K
CONSNTCONSNT2Q132I10_Q132L
CONSNTCONSNT2Q132I10_Q132M
CONSNTCONSNT2Q132I10_Q132N
CONSNTCONSNT2Q132I10_Q132O*/
CONSENT_CONSENT2_Q133_SP1
CONSENT_CONSENT2_Q134_SP2
CONSENT_CONSENT2_Q135_SP3
CONSENT_CONSENT2_Q136_SP4
CONSENT_CONSENT2_Q137_SP5
CONSENT_CONSENT2_Q138_SP6
/*CONSNTCNSENT2Q139SP7_Q139A
CONSNTCNSENT2Q139SP7_Q139B
CONSNTCNSENT2Q139SP7_Q139C
CONSNTCNSENT2Q139SP7_Q139D
CONSNTCNSENT2Q139SP7_Q139E
CONSNTCNSENT2Q139SP7_Q139F
CONSNTCNSENT2Q139SP7_Q139G
CONSNTCNSENT2Q139SP7_Q139H*/
/*CONSENTCONSENT2Q13R3_Q113A
CONSENTCONSENT2Q13R3_Q113B
CONSENTCONSENT2Q13R3_Q113C
CONSENTCONSENT2Q13R3_Q113D
CONSENTCONSENT2Q13R3_Q113E*/
CONSENT_CONSENT2_Q140_SP8
CONSENT_CONSENT2_Q141_SP9


CONSENT_CONSENT2_PROMPT1
CONSENT_CONSENT2_PROMPT2
CONSENT_CONSENT2_PROMPT3
CONSENT_CONSENT2_PROMPT4
CONSENT_CONSENT2_PROMPT5
CONSENT_CONSENT2_PROMPTB
CONSENT_CONSENT2_PROMPTC
CONSENT_CONSENT2_PROMPTD
CONSENT_CONSENT2_PROMPTE
CONSENT_CONSENT2_PROMPTF
CONSENT_CONSENT2_PROMPTG
CONSENT_CONSENT2_PROMPTH
CONSENT_CONSENT2_PROMPTI
CONSENT_CONSENT2_PROMPTJ
CONSENT_CONSENT2_PROMPTK
CONSENT_CONSENT2_PROMPTL
CONSENT_CONSENT2_PROMPTM
CONSENT_CONSENT2_PROMPTN
CONSENT_CONSENT2_PROMPTO
CONSENT_CONSENT2_PROMPTP


CONSENT_PROMPTA
PROMPT6
PROMPTQ
PROMPTR
_LAST_UPDATE_URI_USER
_MODEL_VERSION
_UI_VERSION
_ORDINAL_NUMBER
Q142_PB1
Q143_PB2
Q144_PB3
Q145_PB4
Q147_PB6
Q148_PB7
Q149_PB8
Q150_PB9
Q151_PB10
Q151A_PB10
Q152_PB11
Q152_PB12
Q152_PB13
Q153_PB14
Q153_PB15
Q153_PB16
Q154_PB17
Q154_PB18
Q154_PB19
Q155_PB20
Q156A_PB21
Q156B_PB22

Q157_PB23
Q157A_PB23A
Q158_PB24
Q159_PB25
Q160_PB26
Q161_PB27
Q162_PB28
Q163_PB29
Q164_EXIT1
Q164A_EXIT1_OTHER
Q165_PB31

/*var variables (flu variables)*/
var65 var68 var71 var73 var74 var91 CONSENT_CONSENT2_Q29C_M1C_Q29C_);
run;

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

*formatting;;
proc format;
	value YES_NO	1 = 'Yes'
					2 = 'No';
	
	value YES_NO_DK	1 = 'Yes'
					2 = 'No'
					88 = 'DK/Remember';

	value YES_NO_RF	1 = 'Yes'
					2 = 'No'
					99 = 'Refused';

	value YES_NO_DK_RF	1 = 'Yes'
						2 = 'No'
						88 = 'DK/Remember'
						99 = 'Refused';

	value YES_NO_DATE	1 = 'Yes, before 1997'
						2 = 'Yes, in 1997 or later'
						3 = 'No';

	value FREQa	1 = 'Daily'
				2 = 'Less than daily'
				3 = 'Not at all'
				4 = 'DK/Remember';

	value FREQb 1 = '1 time only'
				2 = '2-5 times'
				3 = '6-10 times'
				4 = '11-100 times'
				5 = 'More than 100 times'
				88 = 'DK/Remember'
				99 = 'Refused';

	value FREQc 1 = 'Less than once a week'
				2 = 'Once a week'
				3 = '2-6 times a week'
				4 = 'Once a day, every day'
				5 = '2 or more times a day, every day'
				88 = 'DK/Remember'
				99 = 'Refused';

	value FREQd 1 = 'Always'
				2 = 'Often'
				3 = 'Sometimes'
				4 = 'Never'
				88 = 'DK/Remember'
				99 = 'Refused';

	value FREQe	1 = 'Twice per year'
				2 = 'Once per year'
				3 = 'Once every 2 years'
				4 = 'Once every 3-5 years'
				5 = 'It has been more than 5 years'
				6 = 'Never'
				88 = 'DK/Remember';

	value FREQf	1 = 'Daily'
				2 = '5-6 days per week'
				3 = '1-4 days per week'
				4 = '1-3 days per month'
				5 = 'Less than once a month';

	value DAY_WEEK	1 = 'Day'
					2 = 'Week';

	value GENDER 1 = 'Male'
				 2 = 'Female';

	value ETHNICITY 1 = 'Georgian'
					2 = 'Armenian'
					3 = 'Azeri'
					4 = 'Ossetian'
					5 = 'Russian'
					77 = 'Other'
					88 = 'Dont know/Remember'
					99 = 'Refused';

	value NEW_USED	1 = 'New'
					2 = 'Used'
					88 = 'DK/Remember';

	value CHECK_ALL_one	1 = 'Yes';

	value CHECK_ALL_two	1 = 'Yes';

	value CHECK_ALL_three 1 = 'Yes';

	value CHECK_ALL_four 1 = 'Yes';

	value CHECK_ALL_five 1 = 'Yes';

	value CHECK_ALL_six 1 = 'Yes';

	value EDU 1 = 'No formal schooling'
			  2 = 'Completed less than Elementary school'
			  3 = 'Completed Elementary/Primary school'
			  4 = 'Completed Incomplete Medium/Basic school'
			  5 = 'Completed Secondary school'
			  6 = 'Completed Professional/Technical school'
			  7 = 'Completed University/College'
			  8 = 'Completed Post-graduate degree'
			  88 = 'DK/remember'
			  99 = 'Refused';

	value CUFF 1 = 'Small'
			   2 = 'Medium'
			   3 = 'Large'
			   77 = 'Other';

	value RELIGION 1 = 'Orthodox'
				   2 = 'Jewish'
				   3 = 'Jehovahs witness'
				   4 = 'Muslim'
				   5 = 'Roman Catholic'
				   6 = 'Georgian or Armenian Apostolic'
				   7 = 'Not religious'
				   77 = 'Other'
				   99 = 'Refused';

	value MARRIED 1 = 'Never married'
				  2 = 'Currently married'
				  3 = 'Separated'
				  4 = 'Divorced'
				  5 = 'Widowed'
				  6 = 'Living with partner'
				  99 = 'Refused';

	value WORK	1 = 'Government employee'
				2 = 'Non-government/Private organization employee'
				3 = 'Self-employed'
				4 = 'Non-paid worker'
				5 = 'Student'
				6 = 'Homemaker'
				7 = 'Retired'
				8 = 'Unemployed (able to work)'
				9 = 'Unemployed (unable to work)'
				99 = 'Refused';

	value HOUSE	1 = 'Rent'
				2 = 'Own'
				77 = 'Other'
				88 = 'DK/Remember'
				99 = 'Refused';

	value EARN_CAT	1 = 'GEL per week'
					2 = 'GEL per month'
					3 = 'GEL per year'
					88 = 'DK'
					99 = 'Refused';

	value EARN_EST	1 = '<= 100 GEL'
					2 = '100-500 GEL'
					3 = '501-1000 GEL'
					4 = '1001-1500 GEL'
					5 = '1501-2000 GEL'
					6 = '2001-3000 GEL'
					7 = '> 3000 GEL'
					88 = 'DK/Remember'
					99 = 'Refused';

	value INSURANCE	1 = 'Public'
					2 = 'Private'
					3 = 'Both public and private'
					99 = 'Refused';

	value MEDPAY	1 = 'Cash out of pocket'
					2 = 'Medical insurance'
					3 = 'A mixture of medical insruance and cash out of pocket'
					4 = 'I receive free medical care'
					5 = 'I do not seek medical care'
					77 = 'Other'
					88 = 'DK/Remember'
					99 = 'Refused'; 

	value MEDLOC	1 = 'Polyclinic'
					2 = 'Hospital'
					3 = 'Health care provider comes to my house'
					4 = 'Pharmacy'
					5 = 'Village doctor'
					6 = 'I do not seek care when I am sick or injured'
					77 = 'Other';

	value SHOTADMIN	1 = 'A medical doctor'
					2 = 'A nurse'
					3 = 'A dentist'
					4 = 'A pharmacist'
					5 = 'A homeopathic provider'
					6 = 'A family member who is not a healthcare worker'
					7 = 'A neighbor who is not a healthcare worker'
					8 = 'Me/myself'
					9 = 'No one, never had a shot'
					77 = 'Other'
					88 = 'DK/Remember';

	value SHOTSOURCE	1 = 'A sealed package'
						2 = 'A pot of warm water'
						3 = 'A sterilizer'
						4 = 'It was already opened, sitting on the counter'
						77 = 'Somewhere else'
						88 = 'DK/Remember';

	value SHOTPURPOSE	1 = 'To treat an infection'
						2 = 'For pain relief'
						3 = 'To treat a chronic disease or medical condition'
						4 = 'It was a vaccination'
						5 = 'For a medical or dental procedure'
						77 = 'Other'
						88 = 'DK/Remember';

	value SHOTMED	1 = 'Antibiotics'
					2 = 'Pain medication'
					3 = 'Steroid'
					4 = 'Vitamin'
					5 = 'Asthma medication'
					6 = 'Insulin'
					7 = 'Vaccine'
					8 = 'Anesthesia'
					77 = 'Other'
					88 = 'DK/Remember';

	value HIVTEST	1 = 'Positive'
					2 = 'Negative'
					88 = 'DK/Remember'
					99 = 'Refused';

	value LANG	1 = 'Kartuli'
				2 = 'Azeri'
				3 = 'Armenian'
				4 = 'Russian'
				5 = 'English';

	value HCVMED	1 = 'I completed the treatment'
					2 = 'I stopped treatment before the end'
					88 = 'DK/Remember'
					99 = 'Refused';

	value HBVMED	1 = 'Yes, I am taking medication to treat my hepatitis B infection'
					2 = 'Yes, I have taken medication in the past to treat my hepatitis B infection, but I am not taking it currently'
					3 = 'No, I have never taken medication to treat my hepatitis B infection'
					88 = 'DK/Remember'
					99 = 'Refused';

	value EXIT	1 = 'Yes'
				2 = 'No, participant refuses to participate further'
				3 = 'No, participant interviewed in error, wrong household selected'
				4 = 'No, participant interviewed in error, wrong household member selected'
				5 = 'No, participant only wants to have diagnostic tests conducted'
				77 = 'Other';

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





