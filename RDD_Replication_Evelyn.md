<<dd_version: 2>>

RDD Replication
================

## Github repo and summary

1. https://github.com/EvelynCheng-Github/RDD

2. What is his research question? His research question is that the effect of harsher punishments and sanctions on driving under the influence.
	
	What data does he use? He utilizes the administrative records of 512,964 drunk driving parking spots in Washington State. What’s more, blood alcohol content thresholds are important value to control drinking and driving.
	
	What is his research design, or “identification strategy”? This article provides quasi-experimental evidence on the impact of severity of punishment on future crimes. In order to provide evidence for these alternative mechanisms, this article examines the degree of change in sanctions and punishments in terms of thresholds, multiple time windows for recidivism, and alcohol-related alternative crimes.
	
	What are his conclusions? Conclusion is that the additional sanctions experienced by drunk drivers at BAC thresholds are effective in reducing repeat drunk driving.

## Reproducing somewhat Hansen’s results

3. Create a dummy

<<dd_do>>
clear
cd "D:\UT-Austin\ECO395M_Causal Inference\RDD"
use "D:\UT-Austin\ECO395M_Causal Inference\RDD\hansen_dwi.dta"
gen BAC_dummy = .
replace BAC_dummy = 1 if bac1 >= 0.08
replace BAC_dummy = 0 if bac1 < 0.08
<</dd_do>>

4. Any evidence for manipulation

<<dd_do: quietly>>
histogram bac1, width(0.001) fcolor(yellow%40) xline(0.08, lc(red))
<</dd_do>>

<<dd_graph>>

I didn't see manipulations in these data. I find same results with Hansen and there are no evidence for sorting on the running variable.

5. Recreate Table 2 Panel A

<<dd_do>>
rdrobust white bac1, c(0.08) h(0.03 0.13) kernel(uniform)
est store model1
rdrobust aged bac1, c(0.08) h(0.03 0.13) kernel(uniform)
est store model2
rdrobust acc bac1, c(0.08) h(0.03 0.13) kernel(uniform)
est store model3
esttab model1 model2 model3
<</dd_do>>

When we consider white male as dependent variables, p-value is 0.719 which means we can't reject null hypothsis. The covariates aren't balanced at the cutoff. But if we take age and accident into account, p-value is near 0 which presents these two covariates are balanced at the cutoff.

6. Recreate Figure 2 panel A-D

<<dd_do: quietly>>
cmogram acc bac1 if bac1 > 0 & bac1 < 0.2, title(Panel A. Accident - linear) cut(0.08) scatter lineat($b) lfitci histopts(bin(15))
graph save Q6_Graph_Al.gph
cmogram acc bac1 if bac1 > 0 & bac1 < 0.2, title(Panel A. Accident - quadratic) cut(0.08) scatter lineat($b) qfitci histopts(bin(15))
graph save Q6_Graph_Aq.gph
cmogram male bac1 if bac1 > 0 & bac1 < 0.2, title(Panel B. Male - linear) cut(0.08) scatter lineat($b) lfitci histopts(bin(15))
graph save Q6_Graph_Bl.gph
cmogram male bac1 if bac1 > 0 & bac1 < 0.2, title(Panel B. Male - quadratic) cut(0.08) scatter lineat($b) qfitci histopts(bin(15))
graph save Q6_Graph_Bq.gph
cmogram aged bac1 if bac1 > 0 & bac1 < 0.2, title(Panel C. Age - linear) cut(0.08) scatter lineat($b) lfitci histopts(bin(15))
graph save Q6_Graph_Cl.gph
cmogram aged bac1 if bac1 > 0 & bac1 < 0.2, title(Panel C. Age - quadratic) cut(0.08) scatter lineat($b) qfitci histopts(bin(15))
graph save Q6_Graph_Cq.gph
cmogram white bac1 if bac1 > 0 & bac1 < 0.2, title(Panel D. White - linear) cut(0.08) scatter lineat($b) lfitci histopts(bin(15))
graph save Q6_Graph_Dl.gph
cmogram white bac1 if bac1 > 0 & bac1 < 0.2, title(Panel D. White - quadratic) cut(0.08) scatter lineat($b) qfitci histopts(bin(15))
graph save Q6_Graph_Dq.gph
graph combine Q6_Graph_Al.gph Q6_Graph_Aq.gph Q6_Graph_Bl.gph Q6_Graph_Bq.gph Q6_Graph_Cl.gph Q6_Graph_Cq.gph Q6_Graph_Dl.gph Q6_Graph_Dq.gph, rows(2) title(Figure 2 panel A-D) xsize(20) ysize(10) saving(Q6.gph)
<</dd_do>>

<<dd_graph>>

In Hansen’s paper, demographic factors such as age, race, and gender are stable across the DUI punishment thresholds.

7. Replicate Table 3

<<dd_do>>
reg recidivism bac1 male white acc aged if bac1 > 0.03 & bac1 < 0.13
est store model4
rdrobust recidivism bac1, c(0.08) h(0.03 0.13) kernel(uniform) covs(male white acc aged)
est store model5
rdrobust recidivism bac1, c(0.08) h(0.03 0.13) kernel(uniform) p(2) covs(male white acc aged)
est store model6
esttab model4 model5 model6
<</dd_do>>

8. Recreate the top panel of Figure 3

<<dd_do: quietly>>
cmogram recidivism bac1 if bac1 < 0.15, title(Panel A. All offenders - linear) cut(0.08) scatter lineat($b) lfitci histopts(bin(15))
graph save Q8_Graph_l.gph
cmogram recidivism bac1 if bac1 < 0.15, title(Panel A. All offenders - quadratic) cut(0.08) scatter lineat($b) qfitci histopts(bin(15))
graph save Q8_Graph_q.gph
graph combine Q8_Graph_l.gph Q8_Graph_q.gph, cols(2) title(Top panel of Figure 3) xsize(20) ysize(10) saving(Q8.gph)
<</dd_do>>

<<dd_graph>>