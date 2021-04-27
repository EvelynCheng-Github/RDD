*--------------------------BEGIN Rep2_Evelyn.do------------------------
<<dd_version: 2>>

Replication 2: Abadie(2005)
================

### 1. Calculate a propensity score

In quadratic OLS model, the min and max values of the propensity score for the treatment group is .1088226 and .1934806. And for the control group is .104215 and .1934767.

In quadratic Logit model, the min and max values of the propensity score for the treatment group is .1065083 and .8996394. And for the control group is .1006338 and .8915.

In cubic OLS model, the min and max values of the propensity score for the treatment group is .1131771 and .20838. And for the control group is .1057099 and .2044633.

In cubic Logit model, the min and max values of the propensity score for the treatment group is .1062628 and .8985353. And for the control group is .101312 and .8770798.

#### Create a histogram showing the distribution of the propensity score for the treatment and control group:

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
histogram pscore2_OLS, by(treat) binrescale
<<dd_graph>>
* Logit
logit treat age agesq educ edusq marr nodegree black hisp re74 re74sq re75 re75sq u74 u75 
predict pscore2_Logit
histogram pscore2_Logit, by(treat) binrescale
<<dd_graph>>
* a cubic for a separate set of analysis
* OLS
reg treat age agesq agecube educ edusq educube marr nodegree black hisp re74 re74sq re74cube re75 re75sq re75cube u74 u75, r
predict pscore3_OLS
histogram pscore3_OLS, by(treat) binrescale
<<dd_graph>>
* Logit
logit treat age agesq agecube educ edusq educube marr nodegree black hisp re74 re74sq re74cube re75 re75sq re75cube u74 u75
predict pscore3_Logit
histogram pscore3_Logit, by(treat) binrescale
<<dd_graph>>
su pscore2_OLS pscore2_Logit pscore3_OLS pscore3_Logit if treat==1, detail
su pscore2_OLS pscore2_Logit pscore3_OLS pscore3_Logit if treat==0, detail
<</dd_do>>

#### Drop all units whose propensity scores are less than 0.1 and more than 0.9 and create a histogram:

<<dd_do: quietly>>
drop if pscore2_OLS <= 0.1 
drop if pscore2_OLS >= 0.9
histogram pscore2_OLS, by(treat) binrescale
<<dd_graph>>
drop if pscore2_Logit <= 0.1 
drop if pscore2_Logit >= 0.9
histogram pscore2_Logit, by(treat) binrescale
<<dd_graph>>
drop if pscore3_OLS <= 0.1 
drop if pscore3_OLS >= 0.9
histogram pscore3_OLS, by(treat) binrescale
<<dd_graph>>
drop if pscore3_Logit <= 0.1 
drop if pscore3_Logit >= 0.9
histogram pscore3_Logit, by(treat) binrescale
su pscore2_OLS pscore2_Logit pscore3_OLS pscore3_Logit if treat==1, detail
su pscore2_OLS pscore2_Logit pscore3_OLS pscore3_Logit if treat==0, detail
<<dd_graph>>
<</dd_do>>

### 2. Calculate a before and after first difference for each unit.

<<dd_do: quietly>>
gen diff = re78 - re75
<</dd_do>>

~~~
<<dd_do>>
su diff
<</dd_do>>
~~~

### 3. Construct a weighted difference-in-differences 

I used four condition in question 1 to seprately calculate the point estimate. In quadratic OLS model, the mean point estimate is 4406.935; and for logit model is 2029.69. In cubic OLS model, the mean point estimate is 4398.901; and for logit model is 2132.094. Compared to $1806 or $2006, the quadratic and cubic Logit model are much more closer.

<<dd_do: quietly>>
egen mean_treat = mean(treat)
gen PE_2_OLS = (diff / mean_treat) * (treat - pscore2_OLS) / (1 - pscore2_OLS)
gen PE_2_Logit = (diff / mean_treat) * (treat - pscore2_Logit) / (1 - pscore2_Logit)
gen PE_3_OLS = (diff / mean_treat) * (treat - pscore3_OLS) / (1 - pscore3_OLS)
<</dd_do>>

~~~
<<dd_do>>
gen PE_3_Logit = (diff / mean_treat) * (treat - pscore3_Logit) / (1 - pscore3_Logit)
su PE_2_OLS PE_2_Logit PE_3_OLS PE_3_Logit
<</dd_do>>
~~~

