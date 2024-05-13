*summary information*
summarize tec
graph bar (mean) tect
gen co2efct = co2efc/100
gen tect = tec/100
gen lco2efct = ln(co2efct)
gen ltect = ln(tect)

*specification 1*
reg co2efc tec, robust
scatter co2efc tec
estat hettest
estat ovtest

*specification 2*
reg co2efc tec b6.regionc, robust
scatter co2efc tec
estat hettest
estat ovtest


*specification 3*
reg co2efc tec aco2ef co2icpp eigdpcp ngdc, robust
summarize co2efc tec aco2ef co2icpp eigdpcp ngdc
estat hettest
estat ovtest

*specification 4*
reg co2efct tect aco2ef co2icpp eigdpcp ngdc, robust
estat hettest
estat ovtest

*specification 5*
reg lco2efct ltect aco2ef co2icpp eigdpcp lngdc, robust
scatter co2efc aco2ef
scatter co2efc co2icppx
scatter co2efc eigdpcp  
scatter co2efc ngdc 
estat hettest
estat ovtest

*specification 5*
reg lco2efct ltect aco2ef co2icpp eigdpcp lngdc b6.regionc, robust
estat hettest
estat ovtest
