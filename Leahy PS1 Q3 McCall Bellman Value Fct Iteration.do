/* Created by RM on 2017.11.08 for McCall Bellman Equation
For ECON 605 PS 1 Q 3 */

clear

global out "/Users/russellmorton/Desktop/Coursework/Fall 2017/ECON 605/Problem Sets/Programming/McCall Model/Output"

/* Add in parameters */

local obs = 1000
*local beta = .95
*local maxloop = 200
local unemp_ben = 35
*local gam = 1

local betas ".95 .5"
local unempbens "25 55"
local loops "3 200"

forv dist=1(1)2 {

clear

set obs `obs'



g wage = _n * .1
if `dist' == 1 {
g pre_wage_dist = 1/`obs'
}
else {
g pre_wage_dist = (_n - (`obs'/2))^4
}
egen sum_pre_wage_dist = sum(pre_wage_dist)
g wage_dist = pre_wage_dist / sum_pre_wage_dist
egen wage_dist_check = sum(wage_dist)

*preserve
*keep if _n == 1
local pdfcheck = wage_dist_check
*restore 

di "cumulative density is `pdfcheck'"

foreach beta of local betas {
foreach unemp_ben of local unempbens {
foreach maxloop of local loops {

keep wage wage_dist

di "enters loops"

g pdv_accept = 	wage / (1 - `beta')


forv i = 1(1)`maxloop' {

if `i' == 1 {
	g value_1 = 1
	}
	
	
else {
	
	local j = `i' - 1	
	
	g value_`i' = value_next_`j'

}

capture drop pre_exp_val exp_val
g pre_exp_val = wage_dist * value_`i'
egen exp_val = sum(pre_exp_val)	
	
g value_next_`i' = max(pdv_accept, `unemp_ben' + `beta' * exp_val)


if `i' == `maxloop' {
	g value_final = value_next_`i'
}

}


sort wage
g wage_change = 1 if value_final[_n+1] > value_final
g obs = [_n]
egen pre_min_obs = min(obs) if wage_change == 1
egen min_obs = max(pre_min_obs)
g pre_res_wage = round(wage,1) if min_obs == obs
egen res_wage = max(pre_res_wage)
local reswage = res_wage

di "enters pre graph"

if `dist' == 1 {

scatter (value_final wage), title("Reservation Wage from Value Fct Iteration")  ///
	xtitle("Wage") xlabel(0 "$0" 20 "$20" 40 "$40" 60 "$60" 80 "$80" 100 "$100")  ///
	ytitle("") ylabel(#5) ///
	note("The discount factor is `beta', and the unemployment benefit is $`unemp_ben'." ///
	"The distribution of wages is uniform." ///
	"The reservation wage is $`reswage'.")
	
di "makes graph"
	
graph export "$out/McCall Uniform `reswage' `beta' `unemp_ben' `maxloop'.pdf", as (pdf) replace
}

else {

scatter (value_final wage), title("Reservation Wage from Value Fct Iteration")  ///
	xtitle("Wage") xlabel(0 "$0" 20 "$20" 40 "$40" 60 "$60" 80 "$80" 100 "$100")  ///
	ytitle("") ylabel(#5) ///
	note("The discount factor is `beta', and the unemployment benefit is $`unemp_ben'." ///
	"The distribution of wages has mass proportional to the quartic deviation from mean wage." ///
	"The reservation wage is $`reswage'.")
	
di "makes graph"
	
graph export "$out/McCall Spread `reswage' `beta' `unemp_ben' `maxloop'.pdf", as (pdf) replace
}

}

}

}

}
*ylabel(`minuse'(`factor')`max')





