set scheme sj 

use haywood, clear

twoway connected pop year, ms(Oh)  
graph export speak40a.eps, replace

twoway connected pop year, ms(Oh) ysc(log) yla(20 50 200 500 2000 5000) 
graph export speak40b.eps, replace

gen time = sqrt(2010 - year)

foreach y of num -6000(2000)2000 500 1000 1500 {
	local call  `call' `=sqrt(2010 - `y')'  "`y'"
}

twoway connected pop time, ms(Oh) xsc(reverse) xla(`call') xtitle(year) 
graph export speak40c.eps, replace

twoway connected pop y if year < 0, ms(Oh) ysc(r(10 7000) log) yla(10 20 50 100 200 500 1000 2000 5000, ang(h)) saving(part1, replace) xla(-6000(1000)0) xtitle("")  
twoway connected pop y if year > 0, ms(Oh) ysc(r(10 7000) log off) yla(10 20 50 100 200 500 1000 2000 5000, ang(h)) saving(part2, replace) xla(250(250)2000) xtitle("") 
graph combine "part1" "part2", imargin(small) b1title(year, size(small)) 
graph export speak40d.eps, replace
 
