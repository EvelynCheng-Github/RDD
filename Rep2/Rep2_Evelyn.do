*--------------------------BEGIN Rep2_Evelyn.do------------------------
<<dd_version: 2>>

Replication 2: Abadie(2005)
================

### 1. Calculate a propensity score

In quadratic OLS model, the min and max values of the propensity score for the treatment group is .1018124 and .1934806. And for the control group is .100047 and .1934767.
In quadratic Logit model, the min and max values of the propensity score for the treatment group is .1036141 and .8819596. And for the control group is .1006786 and .8727123.
In cubic OLS model, the min and max values of the propensity score for the treatment group is .1173034 and .8369712. And for the control group is .101212 and .8387136.
In cubic Logit model, the min and max values of the propensity score for the treatment group is .1118508 and .8651757. And for the control group is .1000519 and .8518736.

<<dd_do: quietly>>
drop _all
clear all
use "D:\UT-Austin\ECO395M_Causal Inference\RDD\Rep2\nsw_mixtape.dta", clear
drop if treat==0
append using "D:\UT-Austin\ECO395M_Causal Inference\RDD\Rep2\cps_mixtape.dta"
gen u74 = 0 if re74!=.
replace u74 = 1 if re74==0
gen u75 = 0 if re75!=.
replace u75 = 1 if re75==0
gen agesq=age^2
gen agecube=age^3
gen edusq=educ^2
gen educube=educ^3
gen re74sq=re74^2
gen re74cube=re74^3
gen re75sq=re75^2
gen re75cube=re75^3
** a quadratic for each variable for one set of analysis
* OLS
reg treat age agesq educ edusq marr nodegree black hisp re74 re74sq re75 re75sq u74 u75, r
predict pscore2_OLS
su pscore2_OLS if treat==1, detail
su pscore2_OLS if treat==0, detail
histogram pscore2_OLS, by(treat) binrescale
<<dd_graph>>
drop if pscore2_OLS <= 0.1 
drop if pscore2_OLS >= 0.9
su pscore2_OLS if treat==1, detail
su pscore2_OLS if treat==0, detail
histogram pscore2_OLS, by(treat) binrescale
<<dd_graph>>
* Logit
logit treat age agesq educ edusq marr nodegree black hisp re74 re74sq re75 re75sq u74 u75 
predict pscore2_Logit
su pscore2_Logit if treat==1, detail
su pscore2_Logit if treat==0, detail
histogram pscore2_Logit, by(treat) binrescale
<<dd_graph>>
drop if pscore2_Logit <= 0.1 
drop if pscore2_Logit >= 0.9
su pscore2_Logit if treat==1, detail
su pscore2_Logit if treat==0, detail
histogram pscore2_Logit, by(treat) binrescale
<<dd_graph>>
* a cubic for a separate set of analysis
* OLS
reg treat age agecube educ educube marr nodegree black hisp re74 re74cube re75 re75cube u74 u75, r
predict pscore3_OLS
su pscore3_OLS if treat==1, detail
su pscore3_OLS if treat==0, detail
histogram pscore3_OLS, by(treat) binrescale
<<dd_graph>>
drop if pscore3_OLS <= 0.1 
drop if pscore3_OLS >= 0.9
su pscore3_OLS if treat==1, detail
su pscore3_OLS if treat==0, detail
histogram pscore3_OLS, by(treat) binrescale
<<dd_graph>>
* Logit
logit treat age agecube educ educube marr nodegree black hisp re74 re74cube re75 re75cube u74 u75
predict pscore3_Logit
su pscore3_Logit if treat==1, detail
su pscore3_Logit if treat==0, detail
histogram pscore3_Logit, by(treat) binrescale
<<dd_graph>>
drop if pscore3_Logit <= 0.1 
drop if pscore3_Logit >= 0.9
su pscore3_Logit if treat==1, detail
su pscore3_Logit if treat==0, detail
histogram pscore3_Logit, by(treat) binrescale
<<dd_graph>>
<</dd_do>>

### 2. Calculate a before and after first difference for each unit.

~~~
<<dd_do>>
gen diff = re78 - re75
su diff
<</dd_do>>
~~~

### 3. Construct a weighted difference-in-differences 

I used four condition in question 1 to seprately calculate the point estimate. In quadratic OLS model, the mean point estimate is 11655.38; and for logit model is 2044.232. In cubic OLS model, the mean point estimate is 1901.54; and for logit model is 1660.701. Compared to $1806 or $2006, the quadratic Logit model and the cubic OLS is much more closer.

~~~
<<dd_do>>
egen ps2_OLS_mean = mean(pscore2_OLS)
gen PE_2_OLS = (diff / ps2_OLS_mean) * (treat - pscore2_OLS) / (1 - pscore2_OLS)
egen ps2_Logit_mean = mean(pscore2_Logit)
gen PE_2_Logit = (diff / ps2_Logit_mean) * (treat - pscore2_Logit) / (1 - pscore2_Logit)
egen ps3_OLS_mean = mean(pscore3_OLS)
gen PE_3_OLS = (diff / ps3_OLS_mean) * (treat - pscore3_OLS) / (1 - pscore3_OLS)
egen ps3_Logit_mean = mean(pscore3_Logit)
gen PE_3_Logit = (diff / ps3_Logit_mean) * (treat - pscore3_Logit) / (1 - pscore3_Logit)
su PE_2_OLS PE_2_Logit PE_3_OLS PE_3_Logit
<</dd_do>>
~~~

