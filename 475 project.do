*setting statistics and installing packages*
ssc install asdoc
tab educ
tab income
encode income, gen(inc)
*checking distribution of income binary
count if inc==1
count if inc==2
*percent of binary income compared to total number of entries
pr(inc<2)
pr(inc>1)
*checking distribution of year of education and income(binary)
hist educnum, tlabel(#1)
hist inc, tlabel(#2)
*generating binary variable of income distribution
gen dincome = 0
replace dincome = 1 if inc==2
*summary of statistic distributions
tab workclass
tab maritalstatus
tab race
tab sex
tab capitalgain
tab capitalloss
tab hrspw
tab nativecountry
*generating binary variable for independent variables
gen black = 1
replace black = 0 if race = black
gen white = 1
replace white = 0 if race = white
gen firstn = 1
replace firstn = 0 if race = amer-indian-eskimo
gen asian = 1
replace asian = 0 if race = asian-pac-islander
gen other.r = 1
replace other.r = 0 if race = other
encode sex, gen(sex2)
gen gender = 0
replace gender = 1 if sex = 2
*general regression
reg dincome educnum
*multivariable regression
reg dincome educnum age
*probit model basis
*average marginal effect?
