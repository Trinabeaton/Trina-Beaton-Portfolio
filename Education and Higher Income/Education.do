*Setting and Installing packages*
ssc install asdoc
*tabulating main variables
tab educnum
tab income
encode income, gen(inc)
*looking at distribution of income*
hist inc, tlabel(#1)
count if inc==1
count if inc==2
gen dinc = 1
replace dinc = 0 if inc==1
*looking at the distribution of the main independent variables*
hist educnum, xlabel(0(1)16)tlabel(#2)
hist age, tlabel(#3)
encode sex, gen(gender)
hist gender, tlabel(#4)
encode race, gen(Race)
hist Race, tlabel(#5)
tab Race

*OLS y x1 regression*
*specification 1*
reg dinc educnum
estimates store m0, title(Model 1)
predict dhat_lpm
sum dhat_lpm
estat hettest
estat ovtest

*Specification 2*
probit dinc educnum
estimates store m1, title(Model 2)
predict dhat_pr
sum dhat_pr
margins, dydx(educ)
estat classification

*Specification 3*
logit dinc educnum
estimates store m2, title(Model 3)
logit dinc educnum, or
estimates store s1
predict dhat_log
sum dhat_log
margins, dydx(educ)
estat classification


*Specification 4*
tab gender
logit dinc educnum i.gender age ib(last).Race
estimates store m4, title(Model 4)
predict dhat_log2
sum dhat_log2
margins, dydx(educnum)
estat classification
lrtest m2 m4
logit dinc educnum i.gender age i.Race, or
estimates store s2


*Specification 5*
encode workclass, gen(wclass)
tab workclass
logit dinc educnum gender age ib(last).Race hrspw 
estimates store m6, title(Model 5)
predict dhat_log3
sum dhat_log3
margins, dydx(educnum)
estat classification
lrtest m4 m6
logit dinc educnum gender age ib(last).Race hrspw, or
estimates store s3


*Specification 6*
encode maritalstatus, gen(maritals)
tab maritals
logit dinc educnum gender age ib(last).Race hrspw ib3.maritals
estimates store m8, title(Model6 6)
predict dhat_log4
sum dhat_log4
estat classification
lrtest m6 m8
margins, dydx(educnum) at(educnum==(9(1)16))
marginsplot, xdimension(educnum)
margins, dydx(educnum) at(gender==(0 1))
marginsplot, xdimension(gender)
logit dinc educnum gender age ib(last).Race hrspw ib3.maritals, or
estimates store s4
logit dinc educnum gender age ib(last).Race hrspw ib3.maritals
linktest

*installing collin command
search collin.ado
collin educnum gender age Race hrspw maritals wclass

*making specifications*
findit estout
ssc install estout, replace
estout m0, cells (b(star fmt(4)) se(par fmt(4))) ///
legend label varlabels(_cons constant) ///
stats (r2_p N, fmt(3 0 1) label(McFaddenR-Squared N))
estout m1 m2, cells (b(star fmt(4)) se(par fmt(4))) ///
legend label varlabels(_cons constant) ///
stats (r2_p N, fmt(3 0 1) label(McFaddenR-Squared N))
estout m4 m6 m8, cells (b(star fmt(4)) se(par fmt(4)) t(fmt(4))) ///
legend label varlabels(_cons constant) ///
stats (r2_p N, fmt(3 0 1) label(McFaddenR-Squared N))

estout s1, cells (b(star fmt(4)) se(par fmt(4))) ///
legend label varlabels(_cons constant) ///
eform stats (r2_p N, fmt(3 0 1) label(McFaddenR-Squared N))
estout s2 s3 s4, cells (b(star fmt(4)) se(par fmt(4))) ///
legend label varlabels(_cons constant) ///
eform stats (r2_p N, fmt(3 0 1) label(McFaddenR-Squared N))


