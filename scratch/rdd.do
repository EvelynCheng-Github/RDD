clear
capture log close
set obs 50000
set seed 55

* Generate running variable. 
gen x = 10 + rnormal(10, 5)
gen x2=x*x
gen x3 = x*x*x

* Treatment
gen d = 0
replace d = 1 if x>=20

* Outcome
gen quantity = 5005 + 750*d + 2*x + 0.75*x2 - 0.05*x3 + rnormal(0,1000)


