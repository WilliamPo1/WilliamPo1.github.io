/****************************************************************************************************
Syntax for:  
PSRM Paper "Why do Majoritarian Systems Benefit the Right? Income Groups and Vote Choice across different Electoral Systems"
Comparative Part
Last updated: 10 April, 2024
******************************************************************************************************/

/************************************************************************************* 

We use the CSES IMD dataset contained in the file "cses_imd.dta" (version "VER2020-DEC-08") and incorporate info from several aggregate-level datasets relevant to the analyses. The sequential addition of datasets is explained by the requests of the reviewers after the R&R invitation.

These datasets are:

1. The CSES IMD dataset is contained in the file "cses_imd.dta" (version "VER2020-DEC-08").
2. "macro_bis.dta": Gini and SD´s LR (MARPOR). The inequality variable(s) come(s) from the World Bank and the World Inequality Database
3. "lis_bis.dta¨: different measures from the LIS dataset are irrelevant at the end
4. "RILE Right ter.dta": Reduced version of the MARPOR dataset with the rile index for the mainstream right
5. "PS Frag PSRM.dta": several measures of PS fragmentation

***************************************************************************************/

set scheme s1color

global pathown = "/Users/williampoirier/Dropbox/Website/files/uwo/R_Workshop_2025/data"

use "$pathown/cses_imd.dta", replace

keep if IMD1006_NAM=="Australia" | IMD1006_NAM=="Austria" | IMD1006_NAM=="Belgium" | IMD1006_NAM=="Canada" | IMD1006_NAM=="Denmark" | IMD1006_NAM=="Finland" | IMD1006_NAM=="France" | IMD1006_NAM=="Germany" | IMD1006_NAM=="Great Britain" | IMD1006_NAM=="Greece" | IMD1006_NAM=="Iceland" | IMD1006_NAM=="Ireland" | IMD1006_NAM=="Italy" | IMD1006_NAM=="Japan" | IMD1006_NAM=="Netherlands" | IMD1006_NAM=="New Zealand" | IMD1006_NAM=="Norway" | IMD1006_NAM=="Spain" | IMD1006_NAM=="Portugal" | IMD1006_NAM=="Sweden" | IMD1006_NAM=="Switzerland" | IMD1006_NAM=="United States of America" /*Lux is not in CSES*/

replace IMD1006_NAM="USA" if IMD1006_NAM=="United States of America"
replace IMD1006_NAM="United Kingdom" if IMD1006_NAM=="Great Britain"

gen polity = IMD1006_NAM
gen year = IMD1008_YEAR

sort polity year

merge m:m polity year using "$pathown/macro_bis.dta"

rename rile rile_left

tab _merge

drop _merge

********************************************************************************

*Addition R&R

********************************************************************************

replace polity="Great Britain" if polity=="United Kingdom"

merge m:m polity year using "$pathown/lis_bis.dta"

tab _merge

drop _merge

***

gen election=IMD1008_YEAR

gen country_code=country

sort country_code election

merge country_code election using "$pathwon/"RILE Right ter.dta"

tab _merge

drop _merge

***

gen country_name=polity

sort country_name year

merge m:m country_name year using "$pathown/PS Frag PSRM.dta"

tab _merge

drop _merge

********************************************************************************

* PREPARATION OF VARIABLES

********************************************************************************

*** 1) Controls

rename IMD1003 study

gen age = IMD2001_1
recode age 9997/9999=.

recode IMD2002 1=1 2=0 else=., gen(male)

gen female=1 if male==0
replace female=0 if male==1

gen leftright=IMD3006
recode leftright 95/99=.
gen leftright01 = leftright/10
recode leftright 0/4=1 5=2 6/10=3, gen(gideol)
lab def gideol 1"Left" 2"Centre" 3"Right"
lab val gideol gideol
recode leftright 0/3=1 4/6=2 7/10=3, gen(gideol2)
lab val gideol2 gideol

recode IMD2005_2 1=1 2=.66 3=.33 4=0 else=., gen(religiosity)
recode IMD2005_2 1=1 2=.66 3=.33 4=0 else=.5, gen(religiosity_im)

recode IMD2005_1 1=0 2=.2 3=.4 4=.6 5=.8 6=1 else=., gen(religiosity2)

recode IMD2006 7/9=., gen(income)

recode IMD2003 6/9=., gen(educ)
recode IMD2003 4=1 0/3=0 6/9=., gen(degree)
recode educ 0=0 1=.25 2=.5 4=.75 5=1, gen(educ01)

recode IMD2007 7/9=., gen(rururb) /*Almost 30,000 missing*/
recode IMD2007 4=1 1/3=0 7/9=., gen(city) 

********************************************************************************

*** 2) Social classes

gen income7=income
gen income2=income
gen income3=income
gen income4=income
gen income5=income
gen income6=income

	*Wide middle class
gen class7=.
replace class7=1 if income==1
replace class7=2 if income==2
replace class7=2 if income==3
replace class7=2 if income==4
replace class7=3 if income==5
lab def class7 1"Lower income" 2"Middle income" 3"Upper income"
lab val class7 class

recode income7 1=1 2/5=0 else=., gen(lowerclass)
recode income7 2/4=1 1=0 5=0 else=., gen(middleclass)
recode income7 5=1 1/4=0 else=., gen(upperclass)

tab lowerclass income
tab upperclass income
tab middleclass income

sum lowerclass upperclass middleclass

	*Narrow middle class
gen class2=.
replace class2=1 if income==1
replace class2=1 if income==2
replace class2=2 if income==3
replace class2=3 if income==4
replace class2=3 if income==5
lab val class2 class
	
recode income2 1/2=1 3/5=0 else=., gen(lowerclass2)
recode income2 3=1 1/2=0 4/5=0 else=., gen(middleclass2)
recode income2 4/5=1 1/3=0 else=., gen(upperclass2)

tab lowerclass2 income
tab upperclass2 income
tab middleclass2 income

sum lowerclass2 upperclass2 middleclass2

	* There are 87,000 missing data for the Socio-Economic status variable
	
********************************************************************************

*Addition R&R

********************************************************************************

*Income3 only takes into account the categories (1, 3 & 5)
recode income3 1=1 3=0 5=0 else=., gen(lowerclass3)
recode income3 3=1 1=0 5=0 else=., gen(middleclass3)
recode income3 5=1 1=0 3=0 else=., gen(upperclass3)

tab lowerclass3 middleclass3
tab lowerclass3 upperclass3
tab middleclass3 upperclass3

*Income4 only takes into account the categories (2, 3 & 4)
recode income4 2=1 3=0 4=0 else=., gen(lowerclass4)
recode income4 3=1 2=0 4=0 else=., gen(middleclass4)
recode income4 4=1 2=0 3=0 else=., gen(upperclass4)

tab lowerclass4 middleclass4
tab lowerclass4 upperclass4
tab middleclass4 upperclass4

*Income5 only takes into account the categories (narrow categorization of before)
recode income5 1/2=1 3/5=0 else=., gen(lowerclass5)
recode income5 3=1 4=1 1/2=0 5=0 else=., gen(middleclass5)
recode income5 5=1 1/4=0 else=., gen(upperclass5)

tab lowerclass5 middleclass5
tab lowerclass5 upperclass5
tab middleclass5 upperclass5

*Income6 only takes into account the categories (wide categorization of before)
recode income6 1=1 2/5=0 else=., gen(lowerclass6)
recode income6 2=1 3=1 1=0 4/5=0 else=., gen(middleclass6)
recode income6 4=1 5=1 1/3=0 else=., gen(upperclass6)

tab lowerclass6 middleclass6
tab lowerclass6 upperclass6
tab middleclass6 upperclass6

********************************************************************************

*** 3) ES (and other ID variables related to different robustness checks)

gen proportional=1
replace proportional=0 if polity=="Australia" | polity=="Canada" | polity=="France" | polity=="Great Britain" | polity=="USA"
lab def proportional 1"PR" 0"Non-PR"
lab val proportional proportional

gen majoritarian=0 if proportional==1
replace majoritarian=1 if proportional==0
lab def majoritarian 0"Maj" 1"Non-maj"
lab val majoritarian majoritarian

*Candidate-centred systems (intra-party competition)
gen personal=0
replace personal=1 if polity=="Ireland" | polity=="Australia"

replace proportional=. if polity=="Japan"
replace majoritarian=. if polity=="Japan"
*Japan is a MMM system

gen pres=0
replace pres=1 if polity=="USA" | polity=="France"
*France is a SP system in reality

*Sample (and coding) of the original article by Iversen and Soskice (2006)
gen IversenandSoskice=0
replace IversenandSoskice=1 if polity=="Australia" | polity=="Austria" | polity=="Belgium" | polity=="Canada" | polity=="Denmark" | polity=="Finland" | polity=="France" | polity=="Germany" | polity=="Great Britain" | polity=="Ireland" | polity=="Italy" | polity=="Finland" | polity=="Netherlands" | polity=="New Zealand" | polity=="Norway" | polity=="Sweden"  | polity=="USA" /*Lux no està al CSES*/

*Robustness 1
gen thirdwave=0
replace thirdwave=1 if polity=="Spain" | polity=="Portugal" | polity=="Greece"

*Robustness 2
gen appendix=0
replace appendix=1 if polity=="Switzerland" | polity=="Iceland"

********************************************************************************

*** 4) DV

gen family_vote = IMD3002_IF_CSES
lab val family_vote V103_A	

gen right=0 if IMD3002_LR_CSES==1 | IMD3002_LR_CSES==2
replace right=1 if IMD3002_LR_CSES==3

bysort right: tab IMD3002_LH_DC if polity=="Australia"
bysort right: tab IMD3002_LH_PL if polity=="Austria"
bysort right: tab IMD3002_LH_PL if polity=="Belgium"
bysort right: tab IMD3002_LH_DC if polity=="Canada"
bysort right: tab IMD3002_LH_PL if polity=="Denmark"
bysort right: tab IMD3002_LH_PL if polity=="Finland"
bysort right: tab IMD3002_LH_DC if polity=="France"
bysort right: tab IMD3002_LH_PL if polity=="Germany"
bysort right: tab IMD3002_LH_DC if polity=="Great Britain"
bysort right: tab IMD3002_LH_PL if polity=="Greece"
bysort right: tab IMD3002_LH_PL if polity=="Iceland"
bysort right: tab IMD3002_LH_DC if polity=="Ireland"
bysort right: tab IMD3002_LH_PL if polity=="Italy"
bysort right: tab IMD3002_LH_PL if polity=="Japan"
bysort right: tab IMD3002_LH_PL if polity=="Netherlands"
bysort right: tab IMD3002_LH_PL if polity=="New Zealand"
bysort right: tab IMD3002_LH_PL if polity=="Norway"
bysort right: tab IMD3002_LH_PL if polity=="Portugal"
bysort right: tab IMD3002_LH_PL if polity=="Spain"
bysort right: tab IMD3002_LH_PL if polity=="Sweden"
bysort right: tab IMD3002_LH_PL if polity=="Switzerland"
bysort right: tab IMD3002_LH_DC if polity=="USA"

gen right_bis=right

*Australia
replace right_bis=0 if IMD3002_LH_DC==0360003
replace right_bis=0 if IMD3002_LH_DC==0360004
replace right_bis=0 if IMD3002_LH_DC==0360005
replace right_bis=0 if IMD3002_LH_DC==0360010

replace right_bis=1 if IMD3002_LH_DC==0360001
replace right_bis=1 if IMD3002_LH_DC==0360002
replace right_bis=1 if IMD3002_LH_DC==0360008
replace right_bis=1 if IMD3002_LH_DC==0360009
replace right_bis=1 if IMD3002_LH_DC==0360011
replace right_bis=1 if IMD3002_LH_DC==0360012
replace right_bis=1 if IMD3002_LH_DC==0360013
replace right_bis=1 if IMD3002_LH_DC==0360019

bysort right_bis: tab IMD3002_LH_DC if polity=="Australia"

*Austria
                
*Belgium
replace right_bis=0 if IMD3002_LH_PL==0560002
replace right_bis=0 if IMD3002_LH_PL==0560004
replace right_bis=0 if IMD3002_LH_PL==0560005
replace right_bis=0 if IMD3002_LH_PL==0560013
replace right_bis=0 if IMD3002_LH_PL==0560015
replace right_bis=0 if IMD3002_LH_PL==0560017
replace right_bis=0 if IMD3002_LH_PL==0560018
replace right_bis=0 if IMD3002_LH_PL==0560020
replace right_bis=0 if IMD3002_LH_PL==0560023

replace right_bis=1 if IMD3002_LH_PL==0560003
replace right_bis=1 if IMD3002_LH_PL==0560016
replace right_bis=1 if IMD3002_LH_PL==0560019
replace right_bis=1 if IMD3002_LH_PL==0560021

bysort right_bis: tab IMD3002_LH_PL if polity=="Belgium"

*Canada
replace right_bis=0 if IMD3002_LH_DC==1240006

bysort right_bis: tab IMD3002_LH_DC if polity=="Canada"

*Denmark
replace right_bis=0 if IMD3002_LH_PL==2080005
replace right_bis=0 if IMD3002_LH_PL==2080006
replace right_bis=0 if IMD3002_LH_PL==2080011

replace right_bis=1 if IMD3002_LH_PL==2080003
replace right_bis=1 if IMD3002_LH_PL==2080007
replace right_bis=1 if IMD3002_LH_PL==2080008

bysort right_bis: tab IMD3002_LH_PL if polity=="Denmark"

*Finland
replace right_bis=0 if IMD3002_LH_PL==2460001
replace right_bis=0 if IMD3002_LH_PL==2460008
replace right_bis=0 if IMD3002_LH_PL==2460009
replace right_bis=0 if IMD3002_LH_PL==2460013
replace right_bis=0 if IMD3002_LH_PL==2460018
replace right_bis=0 if IMD3002_LH_PL==2460020

replace right_bis=1 if IMD3002_LH_PL==2460007
replace right_bis=1 if IMD3002_LH_PL==2460004
replace right_bis=1 if IMD3002_LH_PL==2460014
replace right_bis=1 if IMD3002_LH_PL==2460015
replace right_bis=1 if IMD3002_LH_PL==2460021

bysort right_bis: tab IMD3002_LH_PL if polity=="Finland"

*France
replace right_bis=0 if IMD3002_LH_DC==2500018
replace right_bis=0 if IMD3002_LH_DC==2500019
replace right_bis=0 if IMD3002_LH_DC==9999990

replace right_bis=1 if IMD3002_LH_DC==2500010
replace right_bis=1 if IMD3002_LH_DC==2500011
replace right_bis=1 if IMD3002_LH_DC==2500020
replace right_bis=1 if IMD3002_LH_DC==2500021

replace right_bis=. if IMD3002_LH_DC==9999996

bysort right_bis: tab IMD3002_LH_DC if polity=="France"

replace right_bis=0 if IMD3002_PR_2==2500002
replace right_bis=1 if IMD3002_PR_2==2500001
replace right_bis=1 if IMD3002_PR_2==2500007
replace right_bis=1 if IMD3002_PR_2==2500008

*Germany
replace right_bis=0 if IMD3002_LH_PL==2760006
replace right_bis=0 if IMD3002_LH_PL==2760030
replace right_bis=0 if IMD3002_LH_PL==2760034

replace right_bis=1 if IMD3002_LH_PL==2760001
replace right_bis=1 if IMD3002_LH_PL==2760008
replace right_bis=1 if IMD3002_LH_PL==2760009
replace right_bis=1 if IMD3002_LH_PL==2760017
replace right_bis=1 if IMD3002_LH_PL==2760020
replace right_bis=1 if IMD3002_LH_PL==2760024
replace right_bis=1 if IMD3002_LH_PL==2760025
replace right_bis=1 if IMD3002_LH_PL==2760026
replace right_bis=1 if IMD3002_LH_PL==2760028

replace right_bis=0 if IMD3002_LH_PL==2760014

bysort right_bis: tab IMD3002_LH_PL if polity=="Germany"

*UK
replace right_bis=0 if IMD3002_LH_DC==8260004

bysort right_bis: tab IMD3002_LH_DC if polity=="Great Britain"

*Greece
replace right_bis=1 if IMD3002_LH_PL==3000002

bysort right_bis: tab IMD3002_LH_PL if polity=="Greece"

*Iceland
replace right_bis=0 if IMD3002_LH_PL==3520014
replace right_bis=0 if IMD3002_LH_PL==3520016
replace right_bis=0 if IMD3002_LH_PL==3520022
replace right_bis=0 if IMD3002_LH_PL==3520027

replace right_bis=1 if IMD3002_LH_PL==3520021
replace right_bis=1 if IMD3002_LH_PL==3520012

bysort right_bis: tab IMD3002_LH_PL if polity=="Iceland"

*Ireland
replace right_bis=0 if IMD3002_LH_DC==3720007
replace right_bis=0 if IMD3002_LH_DC==3720008
replace right_bis=0 if IMD3002_LH_DC==3720010

replace right_bis=1 if IMD3002_LH_DC==3720001

bysort right_bis: tab IMD3002_LH_DC if polity=="Ireland"

*Italy
replace right_bis=0 if IMD3002_LH_PL==3800012
replace right_bis=0 if IMD3002_LH_PL==3800013
replace right_bis=0 if IMD3002_LH_PL==3800038
replace right_bis=0 if IMD3002_LH_PL==3800005
replace right_bis=0 if IMD3002_LH_PL==3800009
replace right_bis=0 if IMD3002_LH_PL==3800014
replace right_bis=0 if IMD3002_LH_PL==3800015
replace right_bis=0 if IMD3002_LH_PL==3800024
replace right_bis=0 if IMD3002_LH_PL==3800029
replace right_bis=0 if IMD3002_LH_PL==3800034
replace right_bis=0 if IMD3002_LH_PL==3800036

replace right_bis=1 if IMD3002_LH_PL==3800002
replace right_bis=1 if IMD3002_LH_PL==3800022
replace right_bis=1 if IMD3002_LH_PL==3800003
replace right_bis=1 if IMD3002_LH_PL==3800026
replace right_bis=1 if IMD3002_LH_PL==3800027
replace right_bis=1 if IMD3002_LH_PL==3800028

bysort right_bis: tab IMD3002_LH_PL if polity=="Italy"

*Japan
replace right_bis=0 if IMD3002_LH_PL==3920002
replace right_bis=0 if IMD3002_LH_PL==3920004
replace right_bis=0 if IMD3002_LH_PL==3920006
replace right_bis=0 if IMD3002_LH_PL==3920018

replace right_bis=1 if IMD3002_LH_PL==3920001
replace right_bis=1 if IMD3002_LH_PL==3920012

replace right_bis=. if IMD3002_LH_PL==9999996

bysort right_bis: tab IMD3002_LH_PL if polity=="Japan"

*Netherlands
replace right_bis=0 if IMD3002_LH_PL==5280001
replace right_bis=0 if IMD3002_LH_PL==5280002
replace right_bis=0 if IMD3002_LH_PL==5280004
replace right_bis=0 if IMD3002_LH_PL==5280005
replace right_bis=0 if IMD3002_LH_PL==5280006
replace right_bis=0 if IMD3002_LH_PL==5280008
replace right_bis=0 if IMD3002_LH_PL==5280009

replace right_bis=1 if IMD3002_LH_PL==5280003
replace right_bis=1 if IMD3002_LH_PL==5280007
replace right_bis=1 if IMD3002_LH_PL==5280009
replace right_bis=1 if IMD3002_LH_PL==5280014

replace right_bis=0 if IMD3002_LH_PL==5280013
replace right_bis=0 if IMD3002_LH_PL==5280021
replace right_bis=0 if IMD3002_LH_PL==5280027

replace right_bis=1 if IMD3002_LH_PL==5280007
replace right_bis=1 if IMD3002_LH_PL==5280011
replace right_bis=1 if IMD3002_LH_PL==5280012
replace right_bis=1 if IMD3002_LH_PL==5280014
replace right_bis=1 if IMD3002_LH_PL==5280016
replace right_bis=1 if IMD3002_LH_PL==5280026
replace right_bis=1 if IMD3002_LH_PL==5280035

bysort right_bis: tab IMD3002_LH_PL if polity=="Netherlands"

*New Zealand
replace right_bis=. if IMD3002_LH_PL==9999992
replace right_bis=. if IMD3002_LH_PL==9999998
replace right_bis=. if IMD3002_LH_PL==9999999

replace right_bis=0 if IMD3002_LH_PL==5540002
replace right_bis=0 if IMD3002_LH_PL==5540003
replace right_bis=0 if IMD3002_LH_PL==5540005
replace right_bis=0 if IMD3002_LH_PL==5540006
replace right_bis=0 if IMD3002_LH_PL==5540008
replace right_bis=0 if IMD3002_LH_PL==5540009
replace right_bis=0 if IMD3002_LH_PL==5540012
replace right_bis=0 if IMD3002_LH_PL==5540015
replace right_bis=0 if IMD3002_LH_PL==5540021

replace right_bis=1 if IMD3002_LH_PL==5540001
replace right_bis=1 if IMD3002_LH_PL==5540004
replace right_bis=1 if IMD3002_LH_PL==5540007
replace right_bis=1 if IMD3002_LH_PL==5540026
replace right_bis=1 if IMD3002_LH_PL==5540029
replace right_bis=1 if IMD3002_LH_PL==5540037
replace right_bis=1 if IMD3002_LH_PL==5540014

replace right_bis=. if IMD3002_LH_PL==5540010
replace right_bis=. if IMD3002_LH_PL==5540011
replace right_bis=. if IMD3002_LH_PL==5540023
replace right_bis=. if IMD3002_LH_PL==5540034
replace right_bis=. if IMD3002_LH_PL==5540036
replace right_bis=. if IMD3002_LH_PL==5540038
replace right_bis=. if IMD3002_LH_PL==5540039
replace right_bis=. if IMD3002_LH_PL==5540033

bysort right_bis: tab IMD3002_LH_PL if polity=="New Zealand"

*Norway
replace right_bis=0 if IMD3002_LH_PL==5780001
replace right_bis=0 if IMD3002_LH_PL==5780004
replace right_bis=0 if IMD3002_LH_PL==5780005
replace right_bis=0 if IMD3002_LH_PL==5780006
replace right_bis=0 if IMD3002_LH_PL==5780007
replace right_bis=0 if IMD3002_LH_PL==5780008
replace right_bis=0 if IMD3002_LH_PL==5780009
replace right_bis=0 if IMD3002_LH_PL==5780010

replace right_bis=1 if IMD3002_LH_PL==5780002
replace right_bis=1 if IMD3002_LH_PL==5780003

bysort right_bis: tab IMD3002_LH_PL if polity=="Norway"

*Portugal
replace right_bis=0 if IMD3002_LH_PL==6200002
replace right_bis=0 if IMD3002_LH_PL==6200004
replace right_bis=0 if IMD3002_LH_PL==6200006
replace right_bis=0 if IMD3002_LH_PL==6200007
replace right_bis=0 if IMD3002_LH_PL==6200009
replace right_bis=0 if IMD3002_LH_PL==6200018

replace right_bis=1 if IMD3002_LH_PL==6200001
replace right_bis=1 if IMD3002_LH_PL==6200003
replace right_bis=1 if IMD3002_LH_PL==6200011
replace right_bis=1 if IMD3002_LH_PL==6200015
replace right_bis=1 if IMD3002_LH_PL==6200017

bysort right_bis: tab IMD3002_LH_PL if polity=="Portugal"

*Spain
replace right_bis=0 if IMD3002_LH_PL==7240001
replace right_bis=0 if IMD3002_LH_PL==7240004
replace right_bis=0 if IMD3002_LH_PL==7240012
replace right_bis=0 if IMD3002_LH_PL==7240017
replace right_bis=0 if IMD3002_LH_PL==7240008
replace right_bis=0 if IMD3002_LH_PL==7240009
replace right_bis=0 if IMD3002_LH_PL==7240010
replace right_bis=0 if IMD3002_LH_PL==7240027
replace right_bis=0 if IMD3002_LH_PL==7240045
replace right_bis=0 if IMD3002_LH_PL==7240050

replace right_bis=1 if IMD3002_LH_PL==7240002
replace right_bis=1 if IMD3002_LH_PL==7240003
replace right_bis=1 if IMD3002_LH_PL==7240005
replace right_bis=1 if IMD3002_LH_PL==7240013
replace right_bis=1 if IMD3002_LH_PL==7240026
replace right_bis=1 if IMD3002_LH_PL==7240032
replace right_bis=1 if IMD3002_LH_PL==7240042

bysort right_bis: tab IMD3002_LH_PL if polity=="Spain"

*Sweden
replace right_bis=0 if IMD3002_LH_PL==7520001
replace right_bis=0 if IMD3002_LH_PL==7520005
replace right_bis=0 if IMD3002_LH_PL==7520006
replace right_bis=0 if IMD3002_LH_PL==7520007
replace right_bis=0 if IMD3002_LH_PL==7520009

replace right_bis=1 if IMD3002_LH_PL==7520002
replace right_bis=1 if IMD3002_LH_PL==7520003
replace right_bis=1 if IMD3002_LH_PL==7520004
replace right_bis=1 if IMD3002_LH_PL==7520008

bysort right_bis: tab IMD3002_LH_PL if polity=="Sweden"

*Switzerland
replace right_bis=0 if IMD3002_LH_PL==7560002
replace right_bis=0 if IMD3002_LH_PL==7560003
replace right_bis=0 if IMD3002_LH_PL==7560005
replace right_bis=. if IMD3002_LH_PL==7560006
replace right_bis=0 if IMD3002_LH_PL==7560012
replace right_bis=0 if IMD3002_LH_PL==7560019
replace right_bis=0 if IMD3002_LH_PL==7560022
replace right_bis=0 if IMD3002_LH_PL==7560026
replace right_bis=0 if IMD3002_LH_PL==9999990

replace right_bis=1 if IMD3002_LH_PL==7560001
replace right_bis=1 if IMD3002_LH_PL==7560004
replace right_bis=1 if IMD3002_LH_PL==7560008
replace right_bis=1 if IMD3002_LH_PL==7560009
replace right_bis=1 if IMD3002_LH_PL==7560010
replace right_bis=1 if IMD3002_LH_PL==7560013
replace right_bis=1 if IMD3002_LH_PL==7560014
replace right_bis=1 if IMD3002_LH_PL==7560020
replace right_bis=1 if IMD3002_LH_PL==7560021
replace right_bis=1 if IMD3002_LH_PL==7560023
replace right_bis=1 if IMD3002_LH_PL==7560024
replace right_bis=1 if IMD3002_LH_PL==7560025
replace right_bis=1 if IMD3002_LH_PL==9999991

bysort right_bis: tab IMD3002_LH_PL if polity=="Switzerland"

*USA
replace right_bis=0 if IMD3002_LH_DC==8400002
replace right_bis=1 if IMD3002_LH_DC==8400001
replace right_bis=0 if IMD3002_LH_DC==8400004 

replace right_bis=. if IMD3002_LH_DC==9999992
replace right_bis=. if IMD3002_LH_DC==9999997
replace right_bis=. if IMD3002_LH_DC==9999998
replace right_bis=. if IMD3002_LH_DC==9999999

bysort right_bis: tab IMD3002_LH_DC if polity=="USA"
             
replace right_bis=0 if IMD3002_PR_1==8400002
replace right_bis=0 if IMD3002_PR_1==8400004

replace right_bis=1 if IMD3002_PR_1==8400001

********************************************************************************

******* Robustness

********************************************************************************

*Without far-right
gen mainstream_right=right_bis
replace mainstream_right=. if IMD3002_IF_CSES==7 & right_bis==1

gen far_right=right_bis
replace far_right=. if IMD3002_IF_CSES==4 & right_bis==1
replace far_right=. if IMD3002_IF_CSES==5 & right_bis==1
replace far_right=. if IMD3002_IF_CSES==6 & right_bis==1

* Without CD (R&R)
gen right_ter=right_bis
replace right_ter=. if IMD3002_IF_CSES==5 & right_bis==1

**Without Radical Left (R&R)
gen right_quater=right_bis
replace right_quater=. if IMD3002_IF_CSES==1 & right_bis==0

********************************************************************************

***Descriptive Statistics

********************************************************************************

******************************************************************
* Standardizing numerical predictors as suggested by Gelman 2008
******************************************************************

foreach var of varlist age rile_left rile_right gini{ 
	quietly: sum `var' 
	gen `var'_r = (`var' - `r(mean)') / (2 * `r(sd)') 
}

label var age_r "Age"
label var rile_left_r "Center-left LR ideology"
label var rile_right_r "Center-right LR ideology"
label var gini_r "Gini"

******************************************************************
* We first run some basic descriptive statistics (Table A2)
******************************************************************

egen missing = rowmiss(right_bis proportional middleclass upperclass)

sum right_bis proportional majoritarian upperclass middleclass lowerclass leftright female age_r i.educ rile_left_r gini_r if IMD1009==10 & polity!="Japan" & missing==0

*bysort polity year: sum left* right* proportional majoritarian upperclass middleclass lowerclass upperclass2 middleclass2 lowerclass2 leftright religiosity i.rururb male age i.educ if IMD1009==10

***We only consider NON-CONCURRENT parliamentary elections (IMD1009==10)

*******************************
* Shorter labels for variables
*******************************

label def income	1"Lowest income group (Ref:)"	///
					2"Second lowest income group"	///
					3"Middle income group"	///
					4"Second highest income group"	///
					5"Highest income group"
					
label def male		0"Female (Ref:)"	///
					1"Male"
					
label def education	0"No education (Ref:)"	///
					1"Primary or lower secondary"	///
					2"Higher secondary"	///
					3"Post-secondary"	///
					4"University"
			
label val income income		
label val male male
label val educ education

*/

label var upperclass "Upper income"
label var middleclass "Middle income"
label var lowerclass "Lower income"

********************************************************************************

***Figure A1: Countries and elections

drop if IMD1006_NAM==""
drop country*
gen country=polity

encode country, gen(country1)

levelsof country, local(levels2)
local i 0
foreach x of local levels2{
	local ++ i 
	tab year if country == "`x'"
	local num = `r(r)'
	levelsof year if country == "`x'", local(values)
	matrix input country`i' = (`values')
	if `num' == 1{
		matrix colnames country`i'  = "`x'"
	}
	if `num' == 2{
		matrix colnames country`i'  = "`x'" "`x'"
	}
	if `num' == 3{
		matrix colnames country`i'  = "`x'" "`x'" "`x'"
	}
	if `num' == 4{
		matrix colnames country`i'  = "`x'" "`x'" "`x'" "`x'"
	}
	if `num' == 5{
		matrix colnames country`i'  = "`x'" "`x'" "`x'" "`x'" "`x'"
	}
	if `num' == 6{
		matrix colnames country`i'  = "`x'" "`x'" "`x'" "`x'" "`x'" "`x'"
	}
	if `num' == 7{
		matrix colnames country`i'  = "`x'" "`x'" "`x'" "`x'" "`x'" "`x'" "`x'"
	}
	matrix list country`i' 
}

matrix countries = country1

forval i = 1/21{
	matrix countries = countries, country`i'
}

coefplot	(matrix(countries)),	///
			msize(vsmall) xtitle("Election year", size(small)) ytitle("Country", size(small)) ylabel(, labsize(vsmall)) ///
			xscale(r(1995 2017)) xlabel(1996(1)2016, labsize(vsmall)) xlabel(, grid glwidth(medthin) glcolor(gs14) glpattern(line))

graph save FigureA1, replace

*****

***Figures A2 & A3: Distribution of DV and Social Class per country

set scheme s1color

histogram right_bis if IMD1009==10 & polity!="Japan", fraction xtitle("Vote for a Right-wing Party") ytitle("% respondents") by(polity) width(0.1) xlabel(0(1)1, labsize(vsmall))
graph save FigureA2, replace

histogram class7 if IMD1009==10 & polity!="Japan", fraction xtitle("Social Class") ytitle("% respondents") by(polity) width(0.1) xlabel(1(1)3, labsize(vsmall))
graph save FigureA3, replace
*/
 
********************************************************************************

*ANALYSIS

********************************************************************************

set scheme s1color

eststo clear

**Table B1 (Main Analyses)

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.year if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

*Figure 2A
contrast middleclass#proportional 
margins, at(middleclass=(1) proportional=(0 1)) level(90)
marginsplot, plotopts(connect(none)) title("") xtitle("Probability of Voting Right of the Middle-Income Group", size(small) justification(right)) ytitle("Electoral System", size(small)) horizontal xline(.40823125) xlab(,labsize(small)) ylab(,labsize(small)) yscale(range(-.1(.1)1.1)) yscale(titlegap(*-15)) name(Figure2A, replace)  

dis (.408726+.4077365)/2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
margins, at(middleclass=(1) proportional=(0 1)) level(90)
estat ic
estimates store M3

*Figure 1
coefplot M1 M2 M3, drop(_cons *.year) xline(1) xtitle(Odds ratios) coeflabels(middleclass="Middle income" majoritarian="Majoritarian" middleclass##proportional="Middle income*Maj." lowerclass="Lower income" leftright="LR ideology" age_r="Age" female="Female" degree="University degree" rile="Socialdemocrats' LR ideology" gini="Economic inequality", labsize(small)) subtitle(Probability of Voting Right, size(medium) bcolor(gs12)) legend(cols(1)) legend(size(small) region(lwidth(none)) position(4) col(1)) plotlabels("Income group" "Aggregate-level controls" "Individual-level controls") eform 
 
graph save "Figure1", replace

esttab using TableB1.rtf, eform ///
	label title (Main Logit) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B9 (R&R-R1: Adding CR Ideology)

eststo clear

***1) Controls macro
eststo m_1: logit right_bis middleclass##proportional upperclass i.year gini_r rile_right_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1

***2) Controls micro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_right_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

***3) Controls macro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_right_r rile_left_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3

***4) Controls micro
eststo m_4: logit right_bis middleclass##proportional upperclass i.year gini_r rile_right_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M4

esttab using TableB9.rtf, eform ///
	label title (Control CR) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B2 (R&R-R1: RILE as DV)

eststo clear

mvdecode IMD3100_LR_MARPOR, mv(999)

***1) Bivariate
eststo m_1: reg IMD3100_LR_MARPOR middleclass##proportional upperclass i.year if IMD1009==10, vce(cluster study)
estat ic
estimates store M1

***2) Controls macro
eststo m_2: reg IMD3100_LR_MARPOR middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10, vce(cluster study)
contrast middleclass#proportional 
estat ic
estimates store M2
margins, at(middleclass=(1) proportional=(0 1)) level(90)
marginsplot, plotopts(connect(none)) title("", position(12)) xtitle("Predicted LR ideology of the Party Voted for by the Middle-Income Group", size(small) justification(right)) ytitle("Electoral System", size(small)) horizontal xline(-2.3682532) xlab(,labsize(small)) ylab(,labsize(small)) yscale(range(-.1(.1)1.1)) yscale(titlegap(*-15))  name(Figure2B, replace) 

dis (-.7259014-4.010605)/2

graph combine Figure2A Figure2B, saving(Figure2, replace)

***3) Controls micro
eststo m_3: reg IMD3100_LR_MARPOR middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study)
estat ic
estimates store M3

esttab using TableB2.rtf, ///
	label title (RILE as DV) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B5 (R&R-R1: Only Mainstream Right)

eststo clear

***1) Bivariate
eststo m_1: logit mainstream_right middleclass##proportional upperclass i.year if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit mainstream_right middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit mainstream_right middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB5.rtf, eform ///
	label title (Exclusion of Far Right) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B6 (R&R-R2: Excluding CDs)

eststo clear

***1) Bivariate
eststo m_1: logit right_ter middleclass##proportional upperclass i.year if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_ter middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_ter middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB6.rtf, eform ///
	label title (No Christian Democrats) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace
	
********************************************************************************

**Table B11 (R&R-R2: Election FEs)

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.study if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1
/*
***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.study gini_r rile_left_r if IMD1009==10, vce(cluster study) or
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.study gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3
*/
esttab using TableB11.rtf, eform ///
	label title (Fixed Effects) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace
	
********************************************************************************

**Table B7 (R&R-R2: New operationalization of middle class)

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass6##proportional upperclass6 i.year if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass6##proportional upperclass6 i.year gini_r rile_left_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass6##proportional upperclass6 i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB7.rtf, eform ///
	label title (Alternative Social Class) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B17 (R&R-R3: Gini)

gen gini_high=0 if gini<=.4500437
replace gini_high=1 if gini>.4500437

eststo clear

***2) Controls macro
eststo m_1: logit right_bis middleclass##proportional upperclass i.year rile_left if IMD1009==10 & gini_high==0, vce(cluster study) or
estat ic
estimates store M3

eststo m_3: logit right_bis middleclass##proportional upperclass i.year rile_left if IMD1009==10 & gini_high==1, vce(cluster study) or
estimates store M4

***3) Controls micro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year rile_left_r leftright age_r female degree if IMD1009==10 & gini_high==0, vce(cluster study) or
estat ic
estimates store M5

eststo m_4: logit right_bis middleclass##proportional upperclass i.year rile_left_r leftright age_r female degree if IMD1009==10 & gini_high==1, vce(cluster study) or
estat ic
estimates store M6

esttab using TableB17.rtf, eform ///
	label title (Gini) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B10 (R&R-R3: Controlling for ENP)

mvdecode IMD5058_1, mv(997 999)
mvdecode IMD5058_2, mv(997 999)
mvdecode IMD5059_1, mv(997 999)
mvdecode IMD5059_2, mv(997 999)

eststo clear

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r IMD5058_1 if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

dis (.4436045+.3927492)/2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r IMD5058_1 leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB10.rtf, eform ///
	label title (ENP) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace
	
********************************************************************************

**Table B3: Analyses OLS

eststo clear

***1) Bivariate
eststo m_1: reg right_bis middleclass##proportional upperclass i.year if IMD1009==10, vce(cluster study) 
estat ic
estimates store M1

***2) Controls macro
eststo m_2: reg right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10, vce(cluster study) 
estat ic
estimates store M2

***3) Controls micro
eststo m_3: reg right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) 
estat ic
estimates store M3

esttab using TableB3.rtf, ///
	label title (Analyses OLS) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**"JackKnife" (Figure B1)

********************************************************************************

drop if polity=="Japan"
drop if polity=="Cyprus"
drop if polity=="Luxembourg"
drop if polity=="Malta"
drop if polity=="USA"

gen inter=proportional*middleclass

*Baseline model including all countries
reg right_bis inter proportional middleclass upperclass i.year rile_left_r gini_r leftright age_r female degree if IMD1009==10, vce(cluster study)
matrix results = r(table)
matrix point = results[1,1]
matrix ll = results[5,1]
matrix ul = results[6,1]
matrix res = point \ ll \ ul
matrix colname res = "Baseline (all countries)"
matrix rownames res = "b" "ll" "ul"
matrix toplot = res

levelsof polity, local(levels)
foreach x of local levels{
reg right_bis inter proportional middleclass upperclass i.year rile_left_r gini_r leftright age_r female degree if IMD1009==10 & polity!="`x'", vce(cluster study)
	matrix results = r(table)
	matrix point = results[1,1]
	matrix ll = results[5,1]
	matrix ul = results[6,1]
	matrix res = point \ ll \ ul
	matrix colname res = "`x'"
	matrix rownames res = "b" "ll" "ul"
	matrix toplot = toplot, res 
}	

coefplot	(matrix(toplot), xscale(range(-.025(.02).045)) xlabel(-.06(.02).02) xline(0, lpattern(solid)) xline(-.020567, lpattern(dash)) ///
			ci((toplot[2] toplot[3]))), ///
			groups(Australia Switzerland= "{bf:Country excluded}", angle(90)) ///
			xtitle("Middle income*Maj.") ylabel(, labsize(vsmall)) 

********************************************************************************

**Table B4: HLM

eststo clear

***1) Bivariate
eststo m_1: mixed right_bis middleclass##proportional upperclass i.year if IMD1009==10 ///
 || study:
 
***2) Controls macro
eststo m_2: mixed right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10 ///
 || study:

***3) Controls macro
eststo m_3: mixed right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10 ///
 || study:
 
esttab using TableB4.rtf, ///
	label title (HLM) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace
	
********************************************************************************

*Cases

********************************************************************************

**Table B12: No exclusion of presidentials

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.year, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB12.rtf, eform ///
	label title (No Pres) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace
	
********************************************************************************

**Table B8: Only FPP

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.year if IMD1009==10 & polity!="Australia" & polity!="France", vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10 & polity!="Australia" & polity!="France", vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10 & polity!="Australia" & polity!="France", vce(cluster study) or
estat ic
estimates store M3

esttab using TableB8.rtf, eform ///
	label title (only FPP) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B13: I&S sample

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.year if IMD1009==10 & IversenandSoskice==1, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10 & IversenandSoskice==1, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10 & IversenandSoskice==1, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB13.rtf, eform ///
	label title (I&S) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B14: Without 3rd wave

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.year if IMD1009==10 & thirdwave==0, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10 & thirdwave==0, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10 & thirdwave==0, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB14.rtf, eform ///
	label title (No thirdwave) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

corr appendix thirdwave IversenandSoskice

********************************************************************************

**Table B15: Without CHE & ICL (No I&S)

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional upperclass i.year if IMD1009==10 & appendix==0, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r if IMD1009==10 & appendix==0, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10 & appendix==0, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB15.rtf, eform ///
	label title (No CHE & ICL) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace

********************************************************************************

**Table B16: Iversen and Soskice Code

gen proportional_bis=proportional
replace proportional_bis=1 if polity=="Ireland"
replace proportional_bis=1 if polity=="Japan"

eststo clear

***1) Bivariate
eststo m_1: logit right_bis middleclass##proportional_bis upperclass i.year if IMD1009==10, vce(cluster study) or
estat ic
estimates store M1

***2) Controls macro
eststo m_2: logit right_bis middleclass##proportional_bis upperclass i.year gini_r rile_left_r if IMD1009==10, vce(cluster study) or
estat ic
estimates store M2

***3) Controls micro
eststo m_3: logit right_bis middleclass##proportional_bis upperclass i.year gini_r rile_left_r leftright age_r female degree if IMD1009==10, vce(cluster study) or
estat ic
estimates store M3

esttab using TableB16.rtf, eform ///
	label title (I&S Code) nonumbers mtitles (" " " " " ") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(3) se(3) ///
	scalars(" ") /// 
	mlabels(none) nodiscrete onecell ///
	varlabels(_cons Constant) replace
