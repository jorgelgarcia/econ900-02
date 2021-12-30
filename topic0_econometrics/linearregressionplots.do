version 12.0
set more off
clear all
set matsize 11000
set maxvar  32000

// set environment variables
global projects: env projects

// set environment variables
global projects: env projects

// set general locations
// do files
global scripts           = "$projects/econ_411_611_fall2020/week1_econometrics/"
global output            = "$projects/econ_411_611_fall2020/week1_econometrics/"

cd $output
// create a plot of the mathematical model
// label for the plot as a global variable
# delimit
global box  text(9.35 9.35
         "Slope = {&beta} "
         , place(c) just(c) margin(l+1 b+1 t+1 r+1) fcolor(none)); 
# delimit cr


cd $output
#delimit
twoway  // create slope display
	// make two points (with no symbols) meet 
	(scatteri 10 10 12 10    , yline(20, lcolor(gs14)) c(l) lcolor(orange) lwidth(medium) lpattern(dash) msym(none))
	// horizontal line
	(function y= 10          , yline(0, lcolor(gs14)) range(7 10) lcolor(orange) lwidth(medium) lpattern(dash))      
	
	// linear model
	(function y= 5  + .7*x   , range(0 15) lcolor(gs0)    lwidth(vthick))

	, 
		  // make the plot pretty
		  legend(labe(3 "Model") row(1) order(3 4))
		  xlabel(0 " " 5 " " 10 " " 15 " ", labsize(medium) grid glcolor(gs14)) 
		  ylabel(0 " " 5 "{&alpha}" 10 " " 15 " " 20 " ", labsize(medium) angle(h) glcolor(gs14)) 
		  ytitle("y")
		  xtitle("x")
		  graphregion(color(white)) plotregion(color(white)) $box;
#delimit cr
graph export linear_math.eps, replace
di in r "Enter after seeing Figure" _request(Hello)

// create a plot of the empirical model
// generate some empirical observations around the model
set obs  250    // observations in memory
set seed 1      // so we all generate the same data

gen y = 0 + (15 - 0)*runiform()
gen u = rnormal(0, 1)
gen c = 5 + .7*y + u

#delimit
twoway  // create slope display
	// make two points (with no symbols) meet 
	(scatteri 10 10 12 10 ,  yline(0, lcolor(gs14)) c(l) lcolor(orange) lwidth(medium) lpattern(dash) msym(none))
	// horizontal line
	(function y= 10       , range(7 10) lcolor(orange) lwidth(medium) lpattern(dash))      
	
	// linear model
	(function y= 5  + .7*x   , range(0 15) lcolor(gs0)    lwidth(vthick))
	
	// observations
	(scatter c y, mcolor(purple) msymbol(circle))
	, 
		  // make the plot pretty
		  legend(labe(3 "Model") label(4 "Population Data") row(1) order(3 4))
		  xlabel(0 " " 5 " " 10 " " 15 " ", labsize(medium) grid glcolor(gs14)) 
		  ylabel(0 " " 5 "{&alpha}" 10 " " 15 " " 20 " ", labsize(medium) angle(h) glcolor(gs14)) 
		  ytitle("y")
		  xtitle("x")
		  graphregion(color(white)) plotregion(color(white)) $box;
#delimit cr
graph export linear_empirical.eps, replace
di in r "Enter after seeing Figure" _request(Hello)


gen yy = 0 + (15 - 0)*runiform() if y !=.   // to get the same number of observations
gen uu = rnormal(0, 1)
gen cc = 5 + .3*yy+ uu

gen uuu = rnormal(0, 1)
gen yyy  = 0 + (15 - 0)*runiform() if y !=. // to get the same number of observations
gen ccc = 5 + .5*yyy + uuu

#delimit
twoway     
	// linear model
	(function y= 5  + .5*x   , range(0 15) lcolor(gs0)    lwidth(vthick))
	
	// observations
	(scatter ccc  yyy, mcolor(gs0*.5) msymbol(circle))
	, 
		  // make the plot pretty
		  legend(labe(1 "All Individuals Model") label(2 "All Individuals Data") 
				 rows(2) cols(2) 
		  order(1 2))
		  xlabel(0 " " 5 " " 10 " " 15 " ", labsize(medium) grid glcolor(gs14)) 
		  ylabel(0 " " 5 "{&alpha}" 10 " " 15 " " 20 " ", labsize(medium) angle(h) glcolor(gs14)) 
		  ytitle("y")
		  xtitle("x")
		  graphregion(color(white)) plotregion(color(white));
#delimit cr
graph export linear_corrnocause_1.eps, replace


#delimit
twoway
	// linear model
	(function y= 5  + .5*x   , range(0 15) lcolor(gs0)    lwidth(vthick))
	
	// observations
	(scatter ccc  yyy, mcolor(gs0*.5) msymbol(circle))

	// linear model
	(function y= 5  + .7*x   , range(0 15) lcolor(purple)    lwidth(vthick))
	
	// observations
	(scatter c y, mcolor(purple*.5) msymbol(circle))
	
	// linear causal model
	(function y= 5  + .3*x   , range(0 15) lcolor(orange)    lwidth(vthick))
	
	// causal observations
	(scatter cc yy, color(orange*.5) msymbol(square) )
	, 
		  // make the plot pretty
		  legend(  labe(1 "All Individuals Model") label(2 "All Individuals Data")
			       label(3 "Observational Model")  label(4 "Observational Data") 
			       labe(5 "Causal Model")          label(6 "Causal Data")rows(3) cols(2) 
		  order(1 2 3 4 5 6))
		  xlabel(0 " " 5 " " 10 " " 15 " ", labsize(medium) grid glcolor(gs14)) 
		  ylabel(0 " " 5 "{&alpha}" 10 " " 15 " " 20 " ", labsize(medium) angle(h) glcolor(gs14)) 
		  ytitle("y")
		  xtitle("x")
		  graphregion(color(white)) plotregion(color(white));
#delimit cr
graph export linear_corrnocause.eps, replace


// Conditional Expected Value of Y
// generate scatters
foreach num of numlist 2(2)20 {
	// firßßst means
	global scatter`num' (scatteri `num' `num' , msize(large) msymbol(circle) mcolor(purple))
	
	// them points around
	foreach numy of numlist 5 10 {
		local numyy = `num' - (`numy'/10) 
		global scatter_y`num'_x1`numy' (scatteri `numyy' `num', msize(small) msymbol(circle) mcolor(purple))
		
		local numyy = `num' + (`numy'/10) 
		global scatter_y`num'_x2`numy' (scatteri `numyy' `num', msize(small) msymbol(circle) mcolor(purple))
	}
	global scatterv`num' ${scatter_y`num'_x15} ${scatter_y`num'_x110} ${scatter_y`num'_x25} ${scatter_y`num'_x210}
}
cd $output
#delimit
twoway  // underlying regression line 
		$scatter2   $scatter4  $scatter6  $scatter8  $scatter10
		$scatterv2 $scatterv4 $scatterv6 $scatterv8 $scatterv10
		(scatteri 1 1 11 11    , c(l) lcolor(gs0) lwidth(thick) msym(none))
	    	, 
		  // make the plot pretty
		  legend(labe(5 "E[y|x]") label(26 "E[y|x = x{sub:i}]") order(5 26)) 
		  xlabel(0 " " 4 " " 8 " " 12 "x", labsize(medium) grid glcolor(gs14)) 
		  ylabel(0 " " 4 " "8 " "  12 "y", labsize(medium) angle(h)  glcolor(gs14))
		  ytitle(" ")
		  xtitle(" ")
		  graphregion(color(white)) plotregion(color(white));
#delimit cr
graph export conditionalexpected.eps, replace
di in r "Enter after seeing Figure" _request(Hello)


