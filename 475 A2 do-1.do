**Question 2.1**
*Part A*
*ecoding the data
encode ChildID, gen(cid)
reshape long MathScale, i(cid) j(grade) string
encode grade, gen(mathscore)
xtset cid mathscore
*The data describes a given child's academic and physical development based on academic records and physical traits.*
*The data also includes the student's and parents ID numbers, along with the students environment presenting the students social environment simultaneous to their development.*

*Part B*
summarize MathScale if mathscore==1
summarize MathScale if mathscore==2
summarize MathScale if mathscore==3
summarize MathScale if mathscore==4
summarize MathScale if mathscore==5
summarize MathScale if mathscore==6
gen MathScaleKFallS = (MathScale-52.95087)/14.87138 if mathscore==1
gen MathScaleKSpringS = (MathScale-66.80278)/15.35244 if mathscore==2
gen MathScaleG1FallS = (MathScale-70.86332)/15.01643 if mathscore==3
gen MathScaleG1SpringS = (MathScale-81.0548)/13.85994 if mathscore==4
gen MathScaleG2FallS = (MathScale-31.66781)/11.36951 if mathscore==5
gen MathScaleG2SpringS = (MathScale-45.28114)/12.18585 if mathscore==6
summarize MathScaleKFallS if mathscore==1
summarize MathScaleKSpringS if mathscore==2
summarize MathScaleG1FallS if mathscore==3
summarize MathScaleG1SpringS if mathscore==4
summarize MathScaleG2FallS if mathscore==5
summarize MathScaleG2SpringS if mathscore==6

*regressing the model for Fall Kindergarden
regress MathScaleKFallS StudentBlack StudentHispanic StudentAsian StudentOther, vce(robust)
*The math scores in the fall of kindergarden show that other than asian students, the students performed worse compared to the white students.
*these results are statistically significant at the 0.05 level.

*Part C*

*It would not be appropriate to include student or parent fixed effects, since we are witnessing variable intrercepts and variable slopes across all regression models.
*If we were looking at the presence of fixed effect, then their would be variable intercepts but consistant slopes across regression models.

*Part D*
*regressing the models seperated by semester and grade controlling for student chracteristics and scoioeconomic status.
regress MathScaleKFallS StudentBlack StudentHispanic StudentAsian StudentOther HHSocioEconScore, vce(robust)
*Black; -0.3575222
*Hispanic; -0.2020743

*regressing the models seperated by semester and grade controlling for socioeconomic index, age at entry, non-english speaking, mother's age at birth, and student characteristics.
regress MathScaleKFallS StudentBlack StudentHispanic StudentAsian StudentOther HHSocioEconScore AgeAtKEntry NonEnglishAtHome MotherAgeAtBirth, vce(robust)
*Black; -0.3390817
*Hispanic; -0.1172227
*using heteroscedastic robust standard errors
*Overall, we can see that the black-white achievement gap gets wider over time peaking at black students getting 0.3575222 units less in math scores than their white peers.
*We can see here that the hispanic-white achievement gap begins decreasing hitting a low of 0.117 units less than their white peers in math scores.

*In comparison with the two versions of the model, we can see that when we don't control for more variables the black-white achievement gaps are larger, despite continuing on the same trend.
*For the hispanic-white achievement gap we can see a larger change. When we do control for more variables the achievement gap shrinks.

*Part E*
*encoding variables
encode SchoolIDKFall, generate(nSchoolIDKFall)

*regressing with school id fixed effects
areg MathScaleKFallS StudentBlack StudentHispanic StudentAsian StudentOther HHSocioEconScore AgeAtKEntry NonEnglishAtHome MotherAgeAtBirth, absorb(nSchoolIDKFall)

*Part F*
*School fixed effects aim to allow the isolation of students effects from other school characteristics. Thus, in the segregated models there is no peer effects especially in a model whee we care about race.

**Question 2.2**
*Part A*
*Given the policy was implimented in california in 1988, the structure if the data is appropriate to use difference-in-difference analysis because it allows pre-post and control-treatement variation.
*The range of the data, from 1970-2000 shows the sale of cigarettes before and after the implimentation of the policy. This allows the effectsa of the policy to be studied gradually and accurately.
*Moreover, based on the data, this allows for California be set as the treatement variable, and the other states (given they have no other policy/tratement for smoking implimented during the range of the data) be the control groups.
*This itself allows for any variation to be controlled/accounted for, making the results of the data and potential regressions more accurate and better reflective of its economic significance.

*Part B*
* Defining the panel data
xtset state year
tabulate state, gen(dum)
*defining control and treatement groups
*notice the California is state #3
if state!=3 {
egen avgcigsale = mean(cigsale), by(year)
}
*creating the graph for each state
xtline cigsale, tlabel(#21) 
*overlaying the avgcigsale (for all states s.t state!=3) on the cigsale per state
xtline cigsale avgcigsale if state == 3, xscale(range(1970(2)2000)) xlabel(1970(2)2000) xline(1988) tlabel(#22) 

*Part C*
*The key underlying assumption for the difference-in-difference aproach is that we assume theyre are parallel trends between the tratement and the control group.
* We cannot see the parallel slopes in the figure created in C. Thus, using the difference-in-difference method doesn't seem viable.

*Part D*
scc install synth, all
gen statew = 0
replace statew = 0.164 if state == 4
replace statew = 0.069 if state == 5
replace statew = 0.199 if state == 19
replace statew = 0.234 if state == 21
replace statew = 0.334 if state == 34

*creating synth by dependent variables, predictors, 3 years of cigsales per capital from pre-treatement period.
*speciying treated unit i.e California, and treatement period; which is 1989 since it takes some time for the treatment to effect the treatement group.
*requesting predictors to average from 1980 to 1988, optimize and produce a figure.
bys year: egen calisynth = sum(statew*cigsale)
*generating the graph that compares California's cigarette sales over the time interval and synthetic California's cgarette sales over the time interval.
xtline cigsale calisynth if state==3, xscale(range(1970(2)2000)) xlabel(1970(2)2000) xline(1988) tlabel(#23) 

*Part E*
*Creating a synthetic California is useful to carry out a differences-in-differences analysis in this contect because
*we woudld like to know whether or not the policy actually made a difference. This requires a better representational treatement group.
*Here California and the rest of the 38 states specified in the data lack comparability. The synthetic treatement group using weighted vlaues goes around this issue.

*Part F*
*generating dummy for post 1988
generate pt = 0
replace pt = 1 if year>1988
*generating the interacting variable
gen pt3 = dum3*pt
*creating regression model
xtreg cigsale dum3 pt pt3
*cluster standard errors at the state level
xtreg cigsale dum3 pt pt3, cluster(state)
*These resualts imply that the control group expireinced a decrease in cigarette sales per capita by 28.511 packs after the treatement was implimented.
*However, the treatement group; California, expirenced a decease by approx (rounding to the nearest 10) 55.86 packs, this ends up being a difference of approx 27.35 decrease in cigarette sales by the package overall.
*Based of these results, I would say that considering there is a large difference between tye pontrol groups' cigarette sales by the package and California's cigarette sales by the package after Policy 99 was introduced in 1988
*there is a valid effect. All p-values are statistically significant on the 0.05 level, with the majority even reaching p-values of 0.
*Therefore, there is merit behind the policy and its effects on cigarette sales in California after it's implimentation.
*However, the fact that the sales are measured in packs the results seem less higlighted. For example, a change in the sale by single packs isn't very large, whereas perhaps if there was a change in the sale by hundreds of packs then there would
*be more impact and economic significance. Nonetheless, a decrease in the sale of cigarettes by any amount is economically significant. Thus, the model seems to fit the data, and the model shows economic and statistical significance.

**Question 2.3**
*Part A*
*distribution of the number of cigarettes consumed in a day
hist cigs
*This means there are a majority of non-smokers in the data.
* there are also more people that smoke modestly (less than 10) than those who smoke on the extreme side with more than 40.
*We also see a greater amount of those who smoke moderately ( around 20<= cigs<=40)

*Part B*
tabulate cigs
*Determining how many non-smokers are in the data.
count if cigs==0
*There are 497 non-smokers in the data.
*Determining how many smokers are in the data.
count if cigs>0
*There are 310 smokers in the data.

*Part C*
*estimating the linear model using OLS
reg cigs educ income cigpric age
*The imapact of education on smoking is that it decreases the number of cigarettes consumed by 0.3764399 per year of education. This is statistically significant at the 0.05 level with a p-value of 0.027. 
*The impact that education has by decreasing the consumption of cigarettes are economically significant even at small vlaues, since smoking isn't good for a person's health of the environment.
*A possible limitation of estimating the linear regression model with this type of data is
*that the assumption E[Y|X]=(beta)X then we are predicting the incorect values. Here we encounter the issue that when we have values on the minority side of themass point, we may encounter inccorect predictions. (Like negative ones for example)

*Part D*
*The Tobit model is very appropriate for this data set since there is a mass point at cigs=0.
*We can also see theres is a mix between continuus and discrete. Note that in the data there is no indication of decimal values for cigs but it is still feasable nonetheless.

*Part E*
*Regressing the Tobit model
tobit cigs educ income cigpric age, ll(0)
*Computing the average marginal effect of the years of education on the amount of smokers.
*computing the unconditional marginal effect
margins, dydx(educ) predict(ystar(0,.))
*Computing the impact of education on both the extensive and intensive margins.
*Average marginal effect on probability on the trunicated point
margins, dydx(educ) predict(pr(0,.)) 
*conditional marginal effect
margins, dydx(educ) predict(e(0,.))
*These results tell us that now 1 year of education will decrease smoking by 1.47 units. This is statistically significant at the 0.05 level, and economically significant.
*The unconditional marginal effect of the years of education on the number of cigarettes 
*is -0.5835076. So, the impact of education on the number of smokers is -0.584.
*The marginal effect on probability on the trunicated point, which is the probability of smoking
*is -0.0192346. so, the probability of smoking is 1.9 percent.
*The conditional average marginal effect of the expected number of cigarettes given that already smoke
*is -0.4575149. So, the impact of education on the intesive margin is -0.4575149, this means that the expected number of cigarettes given that they already smoke is -0.458.

*Part F*
*generating binary variable of smokers
gen smoker = 0
replace smoker = 1 if cigs>0
*Estimating Probit
probit smoker educ income cigpric age 
*computing the average marginal effect of years of education on the probability of smoking.
margins, dydx(educ) 
