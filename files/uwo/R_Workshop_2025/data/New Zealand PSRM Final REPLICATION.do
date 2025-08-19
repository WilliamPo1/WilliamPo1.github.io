
/****************************************************************************************************
Syntax for:  
PSRM Paper "Why do Majoritarian Systems Benefit the Right? Income Groups and Vote Choice across different Electoral Systems"
New Zealand Part
Last updated: 1 March, 2024
******************************************************************************************************/

*Most variables beginning n are 1993, p or q 1996, and s 1999

*There are issues with value labels in the database. That is why we delete all value labels in the database and use the original questionnaires to identify the value labels.

********************************************************************************

set scheme s1color

global pathown = "C:\Users\robert\Downloads\Replication\"

use "$pathown/NZESPanel93_96_99.dta", replace

label drop _all

********************************************************************************

* PREPARATION OF VARIABLES

********************************************************************************

*** 1) Main Variables

****1) DVs 

*1: National vs. 0: the rest (Labour+Alliance+Greens)

***

**1999

*nvot99p         byte    %8.0g      LABU       validated party vote

gen DV_99_1=0 if nvot99p==1
replace DV_99_1=1 if nvot99p==2
replace DV_99_1=0 if nvot99p==3
replace DV_99_1=0 if nvot99p==4

***

**1996

*pnvot96p        byte    %14.0g     NVOT96P    Validated Party Vote

gen DV_96_1=0 if pnvot96p==1
replace DV_96_1=1 if pnvot96p==2
replace DV_96_1=0 if pnvot96p==3
replace DV_96_1=0 if pnvot96p==4

***

**1993

*nvot93e         byte    %11.0g     LABZ       Vote in 1993 after Validation


gen DV_93_1=0 if nvot93e==1
replace DV_93_1=1 if nvot93e==2
replace DV_93_1=0 if nvot93e==3
replace DV_93_1=0 if nvot93e==4

******

****2) IVs

lookfor income
lookfor vote

*Personal income
recode nrincum 9=.
xtile nrincum3 = nrincum, nq(3)
xtile nrincum4 = nrincum, nq(4)
xtile nrincum5 = nrincum, nq(5)

*Household income
recode hincome 9=.
xtile hincome3 = hincome, nq(3)
xtile hincome4 = hincome, nq(4)
xtile hincome5 = hincome, nq(5)
 
	*Narrow middle class (33/33/33)
recode nrincum3 1=1 2/3=0 else=., gen(lowerclass)
recode nrincum3 2=1 1=0 3=0 else=., gen(middleclass)
recode nrincum3 3=1 1/2=0 else=., gen(upperclass)

	*Wide middle class (25/50/25)
recode nrincum4 1=1 2/4=0 else=., gen(lowerclass2)
recode nrincum4 2/3=1 1=0 4=0 else=., gen(middleclass2)
recode nrincum4 4=1 1/3=0 else=., gen(upperclass2)

	*Wide middle class (20/60/20)
recode nrincum5 1=1 2/5=0 else=., gen(lowerclass3)
recode nrincum5 2/4=1 1=0 5=0 else=., gen(middleclass3)
recode nrincum5 5=1 1/4=0 else=., gen(upperclass3)

	*Narrow middle class (40/20/40)
recode nrincum5 1/2=1 3/5=0 else=., gen(lowerclass4)
recode nrincum5 3=1 1/2=0 4/5=0 else=., gen(middleclass4)
recode nrincum5 4/5=1 1/3=0 else=., gen(upperclass4)

	*Narrow middle class (33/33/33)
recode hincome3 1=1 2/3=0 else=., gen(lowerclass5)
recode hincome3 2=1 1=0 3=0 else=., gen(middleclass5)
recode hincome3 3=1 1/2=0 else=., gen(upperclass5)

	*Wide middle class (25/50/25)
recode hincome4 1=1 2/4=0 else=., gen(lowerclass6)
recode hincome4 2/3=1 1=0 4=0 else=., gen(middleclass6)
recode hincome4 4=1 1/3=0 else=., gen(upperclass6)

	*Wide middle class (20/60/20)
recode hincome5 1=1 2/5=0 else=., gen(lowerclass7)
recode hincome5 2/4=1 1=0 5=0 else=., gen(middleclass7)
recode hincome5 5=1 1/4=0 else=., gen(upperclass7)

	*Narrow middle class (40/20/40)
recode hincome5 1/2=1 3/5=0 else=., gen(lowerclass8)
recode hincome5 3=1 1/2=0 4/5=0 else=., gen(middleclass8)
recode hincome5 4/5=1 1/3=0 else=., gen(upperclass8)

tab nrincum3
tab nrincum4
tab nrincum5

tab hincome3
tab hincome4
tab hincome5

sum lowerclass* middleclass* upperclass*

******

****3) Controls

*Respondent Environment Growth
mvdecode envrsp, mv(0)

rename nage age
gen female=1 if nsex==2
replace female=0 if nsex==1
gen ideol=nlscale
mvdecode ideol, mv(0 8)
*ideol has lots of MVs

gen edu=edqual
gen uni=0 if edqual!=.
replace uni=1 if edqual==6

gen RUDE=nurbn
recode RUDE (5=1) (1=5) (2=4) (4=2)

gen religiosity=ngodgo
recode religiosity (5=1) (1=5) (4=2) (2=4)

sum age female ideol edu RUDE religiosity

******

****4) Mechanisms

/*
taxr            byte    %13.0g     LABH       Importance of Tax
taxes           byte    %19.0g     LABF       Reduce Taxes
taxi            byte    %16.0g     TAXI       Taxes and Health and Education
taxresp         byte    %12.0g     LABQ       Respondent Redistribution
youtax          byte    %8.0g      YOUTAX     More or Less Tax
*/

sum taxr taxes taxi taxresp youtax

tab taxr
tab taxes
tab taxresp
tab youtax

/*Salience*/

gen taxr_2=taxr

mvdecode taxr, mv(0)

gen salient=1 if taxr<3
replace salient=0 if taxr>2 & taxr!=.

recode taxr (5=1) (1=5) (4=2) (2=4)

replace taxr=2 if taxr==1

recode taxr_2 (5=1) (1=5) (4=2) (2=4)
replace taxr_2=0 if taxr==.

*salience now is good: from less to more

/*Position*/

tab taxes
gen taxes_2=taxes
mvdecode taxes, mv(0)
recode taxes (5=1) (1=5) (4=2) (2=4)

tab taxresp
gen taxresp_2=taxresp
mvdecode taxresp, mv(0)
recode taxresp (7=1) (1=7) (6=2) (2=6) (5=3) (3=5)

tab youtax
gen youtax_2=youtax
mvdecode youtax, mv(0)
recode youtax (1=3) (2=1) (3=2)

tab taxi
gen taxi_2=taxi
mvdecode taxi, mv(6)

pwcorr taxr taxes taxi taxresp youtax, sig

********************************************************************************
* Standardizing numerical predictors as suggested by Gelman 2008
********************************************************************************

gen ideol_sq=ideol*ideol

foreach var of varlist age ideol ideol_sq edu RUDE religiosity envrsp { 
	quietly: sum `var' 
	gen `var'_r = (`var' - `r(mean)') / (2 * `r(sd)') 
}

label var age "Age"
label var ideol "Ideology"
label var edu "Education"
label var RUDE "Rural-urban divide"
label var religiosity "Religiosity"
label var envrsp "Env-growth attitudes"

********************************************************************************

* PREPARATION OF THE DATASET: Panel Analysis

********************************************************************************

gen id=_n
expand 3
bysort id: gen id2=_n

gen DV_1=DV_93_1 if id2==1
replace DV_1=DV_96_1 if id2==2 
replace DV_1=DV_99_1 if id2==3

gen treatment=0
replace treatment=1 if id2==2 | id2==3

gen treatment_96=0
replace treatment_96=1 if id2==2

gen treatment_99=0
replace treatment_99=1 if id2==3

gen middle_96=treatment_96*middleclass
gen middle_99=treatment_99*middleclass

gen middle_96_bis=treatment_96*upperclass
gen middle_99_bis=treatment_99*upperclass

gen day=nday if id2==1
replace day=qday if id2==2
replace day=sday if id2==3

*Because of lack of power...
replace day=21 if day==20
replace day=28 if day==27

gen ideol_2=ideol
replace ideol_2=2 if ideol==1
replace ideol_2=6 if ideol==7

gen envrsp_2=envrsp
replace envrsp_2=2 if envrsp==1
replace envrsp_2=6 if envrsp==7

/*
taxr            byte    %13.0g     LABH       Importance of Tax (reverse code (done), 5 cats)
taxes           byte    %19.0g     LABF       Reduce Taxes (reverse code (done) 4 cats)
taxi            byte    %16.0g     TAXI       Taxes and Health and Education (5)
taxresp         byte    %12.0g     LABQ       Respondent Redistribution (reverse code (done), 7)
youtax          byte    %8.0g      YOUTAX     More or Less Tax

ptax            byte    %37.0g     LABF       Importance of Tax Rates (we need to reverse, 5 cats)
ptaxes          int     %37.0g     LABJ       Reduce Taxes (we need to reverse, 5 cats)
ptaxi           int     %37.0g     PTAXI      Taxes and Health and Education (5)
ptaxr           int     %37.0g     LABO       Respondent Redistribution (we need to reverse, 7)
qyoutax         int     %37.0g     QYOUTAX    More or Less Tax

stax            byte    %8.0g      LABE       importance of tax (we need to reverse, 5 cats)
staxes          byte    %8.0g      LABN       reduce taxes (we need to reverse, 5 cats)
staxi           byte    %8.0g      staxi      taxes and health and education (7)
staxr           byte    %8.0g      staxr      respondent redistribution (we need to reverse, 7)
syoutax         byte    %8.0g      syoutax    more or less tax
*/

mvdecode ptax, mv(0 9 887)

gen salient_2=1 if ptax<3
replace salient_2=0 if ptax>2 & ptax!=.

recode ptax (5=1) (1=5) (4=2) (2=4)

mvdecode stax, mv(9)
recode stax (5=1) (1=5) (4=2) (2=4)

gen sal=taxr if id2==1
replace sal=ptax if id2==2
replace sal=stax if id2==3

mvdecode ptaxes, mv(0 887)
mvdecode staxes, mv(9)

recode ptaxes (5=1) (1=5) (4=2) (2=4)
recode staxes (5=1) (1=5) (4=2) (2=4)

gen pos=taxes if id2==1
replace pos=ptaxes if id2==2
replace pos=staxes if id2==3

mvdecode taxi, mv(0 9 887)
mvdecode ptaxi, mv(0 9 887)
mvdecode staxi, mv(0 9 887)

*the (small) problem with taxes and taxi is that they don't use the same exact metric over waves

mvdecode ptaxr, mv(0 887)
mvdecode staxr, mv(9)

recode ptaxr (7=1) (1=7) (6=2) (2=6) (5=3) (3=5)
recode staxr (7=1) (1=7) (6=2) (2=6) (5=3) (3=5)

gen pos_2=taxresp if id2==1
replace pos_2=ptaxr if id2==2
replace pos_2=staxr if id2==3

mvdecode qyoutax, mv(0 887)
mvdecode syoutax, mv(9)

recode qyoutax (1=3) (2=1) (3=2)
recode syoutax (1=3) (2=1) (3=2)

gen pos_3=youtax if id2==1
replace pos_3=qyoutax if id2==2
replace pos_3=syoutax if id2==3

gen pos_4=taxi if id2==1
replace pos_4=ptaxi if id2==2
replace pos_4=staxi if id2==3

sum sal pos* taxes taxi

pwcorr taxr ptax stax
pwcorr taxes ptaxes staxes
pwcorr taxi ptaxi staxi
pwcorr taxresp ptaxr staxr
pwcorr youtax qyoutax syoutax

********************************************************************************

***** DESCRIPTIVE STATISTICS

********************************************************************************

egen missing = rowmiss(DV_1 middleclass treatment treatment_96 treatment_99 upperclass ideol_2 day sal pos_2 envrsp religiosity RUDE)

sum DV_1 DV_93_1 DV_96_1 middleclass treatment treatment_96 treatment_99 upperclass ideol day sal pos_2 envrsp_r religiosity_r RUDE_r if missing == 0 & DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=.

***shockingly enough, the DV has the same mean in 1993 and 1996

********************************************************************************

***** ANALYSIS

********************************************************************************

*Each Table:
**93 vs 96
**93 vs 96+99
**93 vs 96 vs 99

***In order to avoid the situation where one case only appears in one wave of the analyses, ///
/// we restrict them to those cases that have valid values across all waves for all variables

*Main Analysis Logit NZ (Table C1 & Figures 3 and 4)

eststo clear

eststo: logit DV_1 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id) or
estat ic
estimates store M1

*Figure 4
contrast middleclass#treatment
margins, at(middleclass=(1) treatment=(0 1)) level(90)
marginsplot, plotopts(connect(none)) title("", position(12)) xtitle("Probability of Voting Right for the Middle-Income Group") ytitle("Electoral System") horizontal xline(.4377132) yscale(range(-.1(.1)1.1)) ylabel(0 "FPP" 1 "PR(MMP)") xlabel(, grid glwidth(medthin) glcolor(gs8) glpattern(dot)) name(Figure4, replace) 
graph save Figure4, replace
dis (.4405434+.434883)/2

*

eststo: logit DV_1 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M2

*

eststo: logit DV_1 i.middleclass i.treatment_96 i.treatment_99 middle_96 middle_99 upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M3

*Figure 3
coefplot M1 M2 M3, drop(_cons *.day *.sal *.pos_2 *.ideol_2) ///
xtitle("Odds ratios") ///
coeflabels(1.middleclass="Middle income" 1.treatment="PR (MMP) system" 1.middleclass#1.treatment="Middle income # PR"upperclass="Upper income" age_r="Age" female="Female" ideol_r="Left-right ideology" uni="Univ. degree" envrsp_r="Env-growth attitudes" RUDE_r="Habitat size" 1.treatment_96="1996 election (PR)" 1.treatment_99="1999 election (PR)" religiosity_r="Church attendance" middle_96="Middle income # 1996" middle_99="Middle income # 1999", ///
labsize(small)) xline(1, lcolor(red)) subtitle(, size(medium) bcolor(gs12)) levels(95 90) plotlabels("Treatment=1996" "Treatment=1996 & 1999" "Treatment=1996 or 1999") ///
legend(size(small) region(lwidth(none)) position(4) col(1)) eform

graph save Figure3, replace

esttab using TableC1.rtf, eform ///
	label title (Main logit NZ) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace
	
********************************************************************************

*Null findings regarding changes of LR Ideology over time (R&R-R2): Table C7

eststo clear

eststo: reg ideol middleclass##treatment upperclass i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id)
estat ic
estimates store M1

*

eststo: reg ideol middleclass##treatment upperclass i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id)
estat ic
estimates store M2

*

eststo: reg ideol i.middleclass i.treatment_96 i.treatment_99 middle_96 middle_99 upperclass i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id)
estat ic
estimates store M3

esttab using TableC7.rtf, eform ///
	label title (LR Ideol as DV) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*Inter Treatment & Upper Class (R&R-R3): Table C8

eststo clear

eststo: logit DV_1 middleclass treatment##upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id) or
estat ic
estimates store M1

*

eststo: logit DV_1 middleclass treatment##upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M2

*

eststo: logit DV_1 i.middleclass i.treatment_96 i.treatment_99 middle_96_bis middle_99_bis upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M3

esttab using TableC8.rtf, eform ///
	label title (Inter Treatment Upper Class) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*Mechanisms? Figures 5 & C2; Table C2

eststo clear

**Salience

eststo: logit DV_1 i.middleclass DV_93_1 upperclass i.ideol_2 i.nday i.pos_2 envrsp_r female age_r uni RUDE_r religiosity_r if (id2==2) & salient==0, or
estat ic
margins, saving(Non-salient taxes, replace) level(90) dydx(i.middleclass)

eststo: logit DV_1 i.middleclass DV_93_1 upperclass i.ideol_2 i.nday i.pos_2 envrsp_r female age_r uni RUDE_r religiosity_r if (id2==2) & salient==1, or
estat ic
margins, saving(Salient taxes, replace) level(90) dydx(i.middleclass)

*Figure 5
combomarginsplot "Non-salient taxes" "Salient taxes", title("") ytitle("Effects on Predicted Vote for the Right") recast(scatter) yline(0, lcolor(red) lpattern(solid)) xtitle("Tax Rates Salience") legend(label(1 "Non-salient") label(2 "Salient")) xlabel(1 "Non-salient" 2 "Salient") xscale(range(0.75(.1)2.25)) ylabel(, grid glwidth(medthin) glcolor(gs8) glpattern(dot))
dis (-.1055044-.1090801)/2

graph save Figure5, replace

**Position

eststo: logit DV_1 i.middleclass##c.taxresp DV_93_1 upperclass i.ideol_2 i.nday i.sal envrsp_r female age_r uni RUDE_r religiosity_r if (id2==2), or
estat ic
margins, dydx(middleclass) at(taxresp=(1(1)7)) level(90)
marginsplot, yline(0) title("") ytitle("Effects of Middle-income on Voting Right") xlabel(1 `" "1" "Rich keep wealth"' 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 `" "7" "Tax rich" "')

graph save FigureC1, replace

esttab using TableC2.rtf, eform ///
	label title (Mechanisms) nonumbers mtitles ("M1" "M2" "M3" "M4") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*Alternative operationalization of salience (R&R-R3)

drop salient_2

gen salient_2=0 if taxes==3 | taxes==4 | taxes==2 | taxes==0
replace salient_2=1 if taxes!=3 & taxes!=0 & taxes!=4 & taxes!=2

gen salient_3=0 if taxes==3 | taxes==0
replace salient_3=1 if taxes==4 | taxes==2
replace salient_3=2 if taxes==1 | taxes==5

eststo clear

eststo: logit DV_1 i.middleclass##i.salient_2 DV_93_1 upperclass i.ideol_2 i.nday i.pos_2 female age_r uni if (id2==2), or
margins i.middleclass#i.salient_2, level(90)
marginsplot, recast(dot) name(figurec2a, replace) level(90) title("Alternative salience", position(12)) ytitle(Probability of Voting Right) xtitle(Income Groups) xlabel(0 "No Middle Income" 1 "Middle Income") xscale(range(-0.25 1.25)) plotopts(dcolor(white%0)) ///
legend(order(1 "Non-salient Taxes" 2 "Salient Taxes") size(small) region(lwidth(none)) ring(0) col(1)) ylabel(, grid glwidth(medthin) glcolor(gs8) glpattern(dot))

estat ic

eststo: logit DV_1 i.middleclass##i.salient_3 DV_93_1 upperclass i.ideol_2 i.nday i.pos_2 female age_r uni if (id2==2), or
margins i.middleclass#i.salient_3, level(90)
marginsplot, recast(dot) name(figurec2b, replace) level(90) title("Continuous salience", position(12)) ytitle(Probability of Voting Right) xtitle(Income Groups) xlabel(0 "No Middle Income" 1 "Middle Income") xscale(range(-0.25 1.25)) plotopts(dcolor(white%0)) ///
legend(order(1 "Non-salient Taxes" 2 "Medium-salient Taxes" 3 "High-salient Taxes") size(small) region(lwidth(none)) ring(0) col(1)) ylabel(, grid glwidth(medthin) glcolor(gs8) glpattern(dot))

estat ic

graph combine figurec2a figurec2b, ycommon xcommon commonscheme name(g, replace)

graph save FigureC2, replace

esttab using TableC9.rtf, eform ///
	label title (Alt operationalization of salience) nonumbers mtitles ("M1" "M2" "M3" "M4") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*OLS Models

eststo clear

eststo: reg DV_1 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id) 
estat ic
estimates store M1

*

eststo: reg DV_1 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) 
estat ic
estimates store M2

*

eststo: reg DV_1 i.middleclass i.treatment_96 i.treatment_99 middle_96 middle_99 upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) 
estat ic
estimates store M3

esttab using TableC3.rtf, ///
	label title (OLS NZ) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*We add ACT

gen DV_96_2=DV_96_1
replace DV_96_2=1 if pnvot96p==5

gen DV_99_2=DV_99_1
replace DV_99_2=1 if nvot99p==5

gen DV_2=DV_93_1 if id2==1
replace DV_2=DV_96_2 if id2==2
replace DV_2=DV_99_2 if id2==3

eststo clear

eststo: logit DV_2 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_2!=. & DV_99_2!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id) or
estat ic
estimates store M1

*

eststo: logit DV_2 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_2!=. & DV_99_2!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M2

*

eststo: logit DV_2 i.middleclass i.treatment_96 i.treatment_99 middle_96 middle_99 upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_2!=. & DV_99_2!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M3

esttab using TableC4.rtf, eform ///
	label title (ACT) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*Alternative Operationalization of Social Class

eststo clear

eststo: logit DV_1 middleclass3##treatment upperclass3 i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id) or
estat ic
estimates store M1

*

eststo: logit DV_1 middleclass3##treatment upperclass3 i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M2

*

gen middle2_96=middleclass3*treatment_96
gen middle2_99=middleclass3*treatment_99

eststo: logit DV_1 i.middleclass3 i.treatment_96 i.treatment_99 middle2_96 middle2_99 upperclass3 i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M3

esttab using TableC5.rtf, eform ///
	label title (Alt Class NZ) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace

********************************************************************************

*Additional Controls

eststo clear

eststo: logit DV_1 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r female age_r uni if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=. & id2<3, vce(cluster id) or
estat ic
estimates store M1

*

eststo: logit DV_1 middleclass##treatment upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r female age_r uni if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M2

*

eststo: logit DV_1 i.middleclass i.treatment_96 i.treatment_99 middle_96 middle_99 upperclass i.ideol_2 i.day i.sal i.pos_2 envrsp_r religiosity_r RUDE_r female age_r uni if DV_93_1!=. & DV_96_1!=. & DV_99_1!=. & taxresp!=. & ptaxr!=. & staxr!=. & taxr!=. & ptax!=. & stax!=. & nday!=. & qday!=. & sday!=., vce(cluster id) or
estat ic
estimates store M3

esttab using TableC6.rtf, eform ///
	label title (Add Controls) nonumbers mtitles ("M1" "M2" "M3") ///
	starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
	b(2) se(2) r2 ///  
	varlabels(_cons Constant) replace