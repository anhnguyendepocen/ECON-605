/* Created by RM on 2017.11.08 for McCall Bellman Equation
For ECON 605 PS 1 Q 3 */

clear

global out "/Users/russellmorton/Desktop/Coursework/Fall 2017/ECON 605/Problem Sets/Programming/McCall Model/Output"

/* Add in parameters */

local obs = 1000
local beta = .95
local maxloop = 10
local unemp_ben = 35
*local gam = 1

local betas ".95"
local unempbens "25"
local loops "10"

local dist = 1

clear

set obs `obs'



g wage = _n * .1
g pre_wage_dist = 1/`obs'
egen sum_pre_wage_dist = sum(pre_wage_dist)
g wage_dist = pre_wage_dist / sum_pre_wage_dist
egen wage_dist_check = sum(wage_dist)

*preserve
*keep if _n == 1
local pdfcheck = wage_dist_check
*restore 

di "cumulative density is `pdfcheck'"

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

la var value_1 "1st Iteration"
la var value_2 "2nd Iteration"
la var value_3 "3rd Iteration"
la var value_4 "4th Iteration"
la var value_5 "5th Iteration"
la var value_6 "6th Iteration"
la var value_7 "7th Iteration"
la var value_8 "8th Iteration"
la var value_9 "9th Iteration"
la var value_10 "10th Iteration"

twoway (scatter value_1 wage) (scatter value_2 wage) (scatter value_3 wage) (scatter value_4 wage) ///
	(scatter value_5 wage) (scatter value_6 wage) (scatter value_7 wage) (scatter value_8 wage) ///
	(scatter value_9 wage) (scatter value_10 wage) , title("Reservation Wage from Value Fct Iteration")  ///
	xtitle("Wage") xlabel(0 "$0" 20 "$20" 40 "$40" 60 "$60" 80 "$80" 100 "$100")  ///
	ytitle("") ylabel(#5) ///
	legend( cols (5) keygap(1) ) ///
	note("The discount factor is `beta', and the unemployment benefit is $`unemp_ben'." ///
	"The distribution of wages is uniform." ///
	"The reservation wage for the 10th iteration is $`reswage'. Initial guess was V(w) = 1") 
	
di "makes graph"
	
graph export "$out/McCall Uniform Iterations.pdf", as (pdf) replace

*ylabel(`minuse'(`factor')`max')





