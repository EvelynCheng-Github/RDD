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

3. 
<<dd_do>>
gen BAC_dummy = .
replace BAC_dummy = 1 if bac1 >= 0.08
replace BAC_dummy = 0 if bac1 < 0.08
<</dd_do>>

4. 
<<dd_do>>
histogram bac1, width(0.001) fcolor(yellow%40) xline(0.08, lc(red))
<</dd_do>>
![](https://github.com/EvelynCheng-Github/RDD/blob/main/Q4_Graph.jpg)
I didn't see manipulations in these data. I find same results with Hansen and there are no evidence for sorting on the running variable.

5. 


