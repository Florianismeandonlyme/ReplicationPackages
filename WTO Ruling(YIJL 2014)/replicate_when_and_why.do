/*==================================================
project:       Replication for Supplying Compliance: Why and When the United States Complies with WTO Rulings
Author:        Wu Zi-Jie
E-email:       florian492@outllok.com
Working E-email: 24358002@suibe.edu.cn
Affiliation:	 Shanghai University of International Business and Economics
----------------------------------------------------
Creation Date:     6 Feb 2025 - 22:56:49
Modification Date:   
Do-file version:    01
References:          Rachel Brewster and Adam Chilton(2014), Supplying Compliance: Why and When the United States Complies with WTO Rulings, Yale Journal of International Law 39.
Output:             Basline Regression Table, Figure and Roboutness Check Table
==================================================*/

/*==================================================
              0: Program set up
==================================================*/
version 18
drop _all

* Setting up working directory
* cd /YourDirectory/
use compliance
/*==================================================
              1: Basline Regression
==================================================*/
global ControlVar "divided_government cow_type1_dummy usa_exports_ln gdppc_ln population_ln" //Setting control variables

global ControlVar2 "divided_government cow_type1_dummy usa_imports_ln gdppc_ln population_ln"
*----------1.1:Model 1
logit non_comply_dummy congress_required if subset_compliance==1
est sto m11

*----------1.2:Model 2
logit non_comply_dummy congress_required $ControlVar polity2 trade_remedy_dummy if subset_compliance == 1
est sto m12

*----------1.3:Model 3
logit non_comply_dummy congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance == 1
est sto m13

esttab m11 m12 m13 using basline_wto.tex, replace stats(N r2 aic)
esttab m11 m12 m13, stats(N r2 aic)
* Figure 1: Logit Models Estimating Likelihood of Non-Compliance, using s1color scheme
set scheme s1color
coefplot m11 m12 m13, xlabel(, angle(45)) drop(_cons) keep(congress_required divided_government usa_exports_ln gdppc_ln population_ln polity2 trade_remedy_dummy contribution_2010_ln) xsize(5) ysize(3) yline(0, lp(dash)) vertical

*----------1.4:Survey Analysis
stset total_days, failure(censored)
stcox congress_required
est sto sur1

stcox congress_required $ControlVar polity2 trade_remedy_dummy
est sto sur2

stcox congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln
est sto sur3

/*==================================================
              2: Robustness Check
==================================================*/
*----------2.1: Changing Variables

*----------2.1.1: Changing Helms Burton Coding
* Figure 1 HB
logit non_comply_dummy congress_required_helms_burton if subset_compliance==1
est sto m21
* Figure 2 HB
logit non_comply_dummy congress_required_helms_burton $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m22

logit non_comply_dummy congress_required_helms_burton $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m23

esttab m21 m22 m23 


stset total_days, failure(censored)
stcox congress_required_helms_burton if subset_compliance==1
est sto m21sur

stcox congress_required_helms_burton $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m22sur

stcox congress_required_helms_burton $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m23sur

*----------2.1.2: Changing Softwood Lumber Coding
logit non_comply_dummy congress_required_lumber if subset_compliance==1
est sto m31

logit non_comply_dummy congress_required_lumber $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m32

logit non_comply_dummy congress_required_lumber $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m33

esttab m31 m32 m33

stset total_days, failure(censored)
stcox congress_required_lumber if subset_compliance==1
est sto m31sur

stcox congress_required_lumber $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m32sur

stcox congress_required_lumber $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m33sur

esttab m31sur m32sur m33sur

*----------2.1.3: Changing Zeroing Coding
logit non_comply_dummy congress_required_zeroing if subset_compliance==1
est sto m41

logit non_comply_dummy congress_required_zeroing $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m42

logit non_comply_dummy congress_required_zeroing $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m43

esttab m41 m42 m43

stset total_days, failure(censored)
stcox congress_required_zeroing if subset_compliance==1
est sto m41sur

stcox congress_required_zeroing $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m42sur

stcox congress_required_zeroing $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m43sur

esttab m41sur m42sur m43sur

*----------2.1.4: Changing All 
logit non_comply_dummy congress_required_complete if subset_compliance==1
est sto m51

logit non_comply_dummy congress_required_complete $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m52

logit non_comply_dummy congress_required_complete $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m53

esttab m51 m52 m53


stset total_days, failure(censored)
stcox congress_required_complete if subset_compliance==1
est sto m51sur

stcox congress_required_complete if subset_compliance==1
est sto m52sur

stcox congress_required_complete if subset_compliance==1
est sto m53sur

esttab m51 m52 m53 m51sur m52sur m53 

*----------2.2: Compliance Models w/o Zeroing counted as Compliant
logit non_comply_dummy_zeroing congress_required if subset_compliance ==1
est sto m61

logit non_comply_dummy_zeroing congress_required $ControlVar polity2 trade_remedy_dummy if subset_compliance==1
est sto m62

logit non_comply_dummy_zeroing congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m63

esttab m61 m61 m63

*----------2.3: Including Settled Cases
stset total_days, failure(censored)
stcox congress_required if subset_total_time_settled == 1
est sto m71

stcox congress_required $ControlVar polity2 trade_remedy_dummy if subset_total_time_settled == 1
est sto m72

stcox congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_total_time_settled == 1
est sto m73

esttab m71 m72 m73

*----------2.4: Largest" Country
logit non_comply_dummy congress_required $ControlVar polity2_larges trade_remedy_dummy if subset_compliance==1
est sto m811

logit non_comply_dummy congress_required $ControlVar polity2_larges trade_remedy_dummy contribution_2010_ln if subset_compliance==1
est sto m812

stcox congress_required $ControlVar polity2_larges trade_remedy_dummy if subset_total_time_settled == 1
est sto m821

stcox congress_required $ControlVar polity2_larges trade_remedy_dummy contribution_2010_ln if subset_total_time_settled == 1
est sto m822

*----------2.5: Compliance Time
stset total_days, failure(censored)
stcox congress_required if subset_comply_time_settled == 1
est sto m91

stcox congress_required $ControlVar polity2 trade_remedy_dummy if subset_comply_time_settled == 1
est sto m92

stcox congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_comply_time_settled == 1
est sto m93



*----------2.6: Probit for Figure 1 Instead of Logit
probit non_comply_dummy congress_required if subset_compliance == 1
est sto m101

probit non_comply_dummy congress_required $ControlVar polity2 trade_remedy_dummy if subset_compliance == 1
est sto m102

probit non_comply_dummy congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance == 1
est sto m103

esttab m101 m102 m103

*----------2.7: Using USA Imports Instead of Exports
logit non_comply_dummy congress_required if subset_compliance == 1
est sto m111

logit non_comply_dummy congress_required $ControlVar2 polity2 trade_remedy_dummy if subset_compliance == 1
est sto m112

logit non_comply_dummy congress_required $ControlVar2 polity2 trade_remedy_dummy if subset_compliance == 1
est sto m113

stset total_days, failure(censored)
stcox congress_required if subset_compliance == 1
est sto m121 

stcox congress_required $ControlVar polity2 trade_remedy_dummy if subset_compliance == 1
est sto m122

stcox congress_required $ControlVar polity2 trade_remedy_dummy contribution_2010_ln if subset_compliance == 1
est sto m123 
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


* Version Control: Stata 18


