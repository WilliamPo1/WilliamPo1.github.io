#----------------------------- Cleaning Data for ------------------------------#
#-------------- Why do majoritarian systems benefit the right ? ---------------#
#----------------------------- By William Poirier -----------------------------#

#### 0. Initialization ####

library(tidyverse)
library(rio)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

cses <- import("../data/cses_imd.dta")
macro <- import("../data/macro_bis.dta") |> distinct(polity, year, .keep_all = T) 
lis <- import("../data/lis_bis.dta") |> distinct(polity, year, .keep_all = T)
rile <- import("../data/RILE Right ter.dta") |> distinct(country_code, election, .keep_all = T)
frag <- import("../data/PS Frag PSRM.dta") |> distinct(country_name, year, .keep_all = T)

#### 1. Merging data files ####

dat <- cses |> 
  filter(IMD1006_NAM %in% c("Australia","Austria","Belgium","Canada","Denmark","Finland","France","Germany","Great Britain","Greece","Iceland","Ireland","Italy","Japan","Netherlands","New Zealand","Norway","Spain","Portugal","Sweden","Switzerland","United States of America")) |> 
  mutate(IMD1006_NAM = case_when(IMD1006_NAM=="United States of America" ~ "USA",
                                 IMD1006_NAM=="Great Britain" ~ "United Kingdom",
                                 TRUE ~ IMD1006_NAM),
         polity=IMD1006_NAM,
         year=IMD1008_YEAR) |> 
  arrange(polity,year) |> 
  full_join(macro, by = c("polity","year"), relationship = "many-to-many") |> 
  rename(rile_left=rile) |> 
  mutate(polity=ifelse(polity=="United Kingdom","Great Britain",polity)) |> 
  full_join(lis, by = c("polity","year"), relationship = "many-to-many") |> 
  mutate(election=IMD1008_YEAR,
         country_code=country) |> 
  arrange(country_code,election) |> 
  full_join(rile, by = c("country_code","election"), relationship = "many-to-many") |> 
  mutate(country_name=polity) |> 
  arrange(country_name,year) |> 
  full_join(frag, by = c("country_name", "year"), relationship = "many-to-many")


#### 2. Cleaning variables ####

#### 2.1 Controls ####
dat <- dat |>
  rename(study = IMD1003) |>
  mutate(age = ifelse(IMD2001_1 %in% 9997:9999, NA, IMD2001_1),
         male = ifelse(IMD2002 == 1, 1, 
                       ifelse(IMD2002 == 2, 0, NA)),
         female = 1-male,
         leftright = ifelse(IMD3006 %in% 95:99, NA, IMD3006),
         leftright01 = leftright/10,
         gideol = case_when(leftright %in% 0:4 ~ 1,
                               leftright == 5 ~ 2,
                               leftright %in% 6:10 ~ 3),
         gideol = factor(gideol, levels=1:3, labels=c("Left","Centre","Right")),
         gideol2 = case_when(leftright %in% 0:3 ~ 1,
                            leftright %in% 4:6 ~ 2,
                            leftright %in% 7:10 ~ 3),
         gideol2 = factor(gideol2, levels=1:3, labels=c("Left","Centre","Right")),
         religiosity = case_when(IMD2005_2 == 1 ~ 1,
                                 IMD2005_2 == 2 ~ .66,
                                 IMD2005_2 == 3 ~ .33,
                                 IMD2005_2 == 4 ~ 0,
                                 TRUE ~ NA_real_),
         religiosity_im = case_when(IMD2005_2 == 1 ~ 1,
                                    IMD2005_2 == 2 ~ .66,
                                    IMD2005_2 == 3 ~ .33,
                                    IMD2005_2 == 4 ~ 0,
                                    TRUE ~ .5),
         religiosity2 = case_when(IMD2005_1 == 1 ~ 0,
                                 IMD2005_1 == 2 ~ .2,
                                 IMD2005_1 == 3 ~ .4,
                                 IMD2005_1 == 4 ~ .6,
                                 IMD2005_1 == 5 ~ .8,
                                 IMD2005_1 == 6 ~ 1,
                                 TRUE ~ NA_real_),
         income = ifelse(IMD2006 %in% 7:9, NA, IMD2006),
         educ = ifelse(IMD2003 %in% 6:9, NA, IMD2003),
         degree = ifelse(educ == 4, 1, 0),
         educ01 = case_when(educ == 0 ~ 0,
                            educ == 1 ~ .25,
                            educ == 2 ~ .5,
                            educ == 4 ~ .75, # no 3 for some reason...
                            educ == 5 ~ 1),
         rurub = ifelse(IMD2007 %in% 7:9, NA, IMD2007),
         city = ifelse(rurub == 4, 1, 0))

#### 2.2 Social classes ####

dat <- dat |>
  mutate(income2 = income,
         income3 = income,
         income4 = income,
         income5 = income,
         income6 = income,
         income7 = income,
         class7 = case_when(income == 1 ~ 1,
                            income %in% 2:4 ~ 2,
                            income == 5 ~ 3),
         class7 = factor(class7, levels=1:3, labels=c("Lower income", "Middle income", "Upper income")),
         lowerclass = ifelse(income7 == 1, 1, 0),
         middleclass = ifelse(income7 %in% 2:4, 1, 0),
         upperclass = ifelse(income7 == 5, 1, 0),
         class2 = case_when(income %in% 1:2 ~ 1,
                            income == 3 ~ 2,
                            income %in% 4:5 ~ 3),
         class2 = factor(class2, levels=1:3, labels=c("Lower income", "Middle income", "Upper income")),
         lowerclass2 = ifelse(income2 %in% 1:2, 1, 0),
         middleclass2 = ifelse(income2 == 3, 1, 0),
         upperclass2 = ifelse(income2 %in% 4:5, 1, 0),
          lowerclass3 = ifelse(income3 == 1, 1, ifelse(income3 %in% c(2,4), NA, 0)),
         middleclass3 = ifelse(income3 == 3, 1, ifelse(income3 %in% c(2,4), NA, 0)),
          upperclass3 = ifelse(income3 == 5, 1, ifelse(income3 %in% c(2,4), NA, 0)),
          lowerclass4 = ifelse(income4 == 2, 1, ifelse(income4 %in% c(1,5), NA, 0)),
         middleclass4 = ifelse(income4 == 3, 1, ifelse(income4 %in% c(1,5), NA, 0)),
          upperclass4 = ifelse(income4 == 4, 1, ifelse(income4 %in% c(1,5), NA, 0)),
          lowerclass5 = ifelse(income5 %in% 1:2, 1, 0),
         middleclass5 = ifelse(income5 %in% 3:4, 1, 0),
          upperclass5 = ifelse(income5 == 5, 1, 0),
          lowerclass6 = ifelse(income6 == 1, 1, 0),
         middleclass6 = ifelse(income6 %in% 2:3, 1, 0),
          upperclass6 = ifelse(income6 %in% 4:5, 1, 0))

#### 2.3 ES (and other ID variables related to robustness checks) ####

dat <- dat |>
  mutate(proportional = ifelse(polity %in% c("Australia", "Canada", "France", 
                                             "Great Britain", "USA"), 0, 
                               ifelse(polity=="Japan",NA,0)),
         majoritarian = 1-proportional,
         proportional = factor(proportional, levels=c(1,0), labels=c("PR","Non-PR")),
         majoritarian = factor(majoritarian, levels=0:1, labels=c("Maj","Non-maj")),
         personal = ifelse(polity %in% c("Ireland", "Australia"), 1, 0),
         pres = ifelse(polity %in% c("USA", "France"), 1, 0),
         IversenandSoskice = ifelse(polity %in% c("Australia", "Austria","Belgium",
                                                  "Canada", "Denmark", "Finland",
                                                  "France", "Germany", "Great Britain", 
                                                  "Ireland", "Italy", "Netherlands", 
                                                  "New Zealand", "Norway", "Sweden",
                                                  "USA"), 1, 0),
         thirdwave = ifelse(polity %in% c("Spain", "Portugal", "Greece"), 1, 0),
         appendix = ifelse(polity %in% c("Switzerland", "Iceland"), 1, 0))

#### 2.4 DV ####
party0_DC <- c(
  # Australia
  0360003,0360004,0360005,0360010,
  # Canada
  1240006,
  # France
  2500018,2500019,9999990,2500002,
  # Great Britain
  8260004,
  #Ireland
  3720007,3720008,3720010,
  # USA
  8400002,8400004
)
party1_DC <- c(
  # Australia
  0360001,0360002,0360008,0360009,0360011,0360012,0360013,0360019,
  # France
  2500010,2500011,2500020,2500021,
  # Ireland
  3720001,
  # USA
  8400001
)

party0_PL <- c(
 # Beligum
  0560002,0560004,0560005,0560013,0560015,0560017,0560018,0560020,0560023,
  # Denmark
  2080005,2080006,2080011,
  # Finland
  2460001,2460008,2460009,2460013,2460018,2460020,
  # Germany
  2760006,2760030,2760034,2760014,
  # Greece
  # Iceland
  3520014,3520016,3520022,3520027,
  # Italy
  3800012,3800013,3800038,3800005,3800009,3800014,
  3800015,3800024,3800029,3800034,3800036,
  # Japan
  3920002,3920004,3920006,3920018,
  # Netherlands
  5280001,5280002,5280004,5280005,5280006,5280008,5280009,5280013,5280021,5280027,
  # New Zealand
  5540002,5540003,5540005,5540006,5540008,5540009,5540012,5540015,5540021,
  # Norway
  5780001,5780004,5780005,5780006,5780007,5780008,5780009,5780010,
  # Portugal
  6200002,6200004,6200006,6200007,6200009,6200018,
  # Spain
  7240001,7240004,7240012,7240017,7240008,7240009,7240010,7240027,7240045,7240050,
  # Sweden
  7520001,7520005,7520006,7520007,7520009,
  # Switzerland
  7560002,7560003,7560005,7560012,7560019,7560022,7560026,9999990
)

party1_PL <- c(
  # Beligum
  0560003,0560016,0560019,0560021,
  # Denmark
  2080003,2080007,2080008,
  # Finland
  2460007,2460004,2460014,2460015,2460021,
  # Germany
  2760001,2760008,2760009,2760017,2760020,2760024,2760025,2760026,2760028,
  # Greece
  3000002,
  # Iceland
  3520021,3520012,
  # Italy
  3800002,3800022,3800003,3800026,3800027,3800028,
  # Japan
  3920001,3920012,
  # Netherlands
  5280003,5280007,5280009,5280014,5280007,5280011,5280012,5280014,5280016,5280026,5280035,
  # New Zealand
  5540001,5540004,5540007,5540026,5540029,5540037,5540014,
  # Norway
  5780002,5780003,
  # Portugal
  6200001,6200003,6200011,6200015,6200017,
  # Spain
  7240002,7240003,7240005,7240013,7240026,7240032,7240042,
  # Sweden
  7520002,7520003,7520004,7520008,
  # Switzerland
  7560001,7560004,7560008,7560009,7560010,7560013,7560014,7560020,7560021,7560023,7560024,7560025,9999991
)

party0_PR_2 <- c(
  # France
  2500002
)
party0_PR_1 <- c(
  # USA
  8400002,8400004
)

party1_PR_2 <- c(
  # France
  2500001,2500007,2500008
)
party1_PR_1 <- c(
  # USA
  8400001
)

partyNA_DC <- c(9999996,9999992,9999997,9999998,9999999)
partyNA_PL <- c(
  9999996,9999992,9999998,9999999,
  5540010,5540011,5540023,5540034,5540036,5540038,5540039,5540033,
  7560006 # For switzerland, that's weird coding, they included 9999990 and 1 instead...
)

dat <- dat |>
  mutate(family_vote = factorize(IMD3002_IF_CSES),
         right = ifelse(IMD3002_LR_CSES %in% 1:2, 0, 
                        ifelse(IMD3002_LR_CSES == 3, 1, NA)),
         right_bis = right,
         right_bis = case_when(IMD3002_LH_DC %in% party0_DC ~ 0,
                               IMD3002_LH_DC %in% party1_DC ~ 1,
                               IMD3002_LH_DC %in% partyNA_DC ~ NA,
                               IMD3002_LH_PL %in% party0_PL ~ 0,
                               IMD3002_LH_PL %in% party1_PL ~ 1,
                               IMD3002_LH_PL %in% partyNA_PL ~ NA,
                               IMD3002_PR_1 %in% party0_PR_1 ~ 0,
                               IMD3002_PR_1 %in% party1_PR_1 ~ 1,
                               IMD3002_PR_2 %in% party0_PR_2 ~ 0,
                               IMD3002_PR_2 %in% party1_PR_2 ~ 1,
                               TRUE ~ right),
         mainstream_right = ifelse(IMD3002_IF_CSES==7 & right_bis==1, NA, right_bis),
         far_right = ifelse(IMD3002_IF_CSES %in% 4:6 & right_bis==1, NA, right_bis),
         right_ter = ifelse(IMD3002_IF_CSES == 5 & right_bis==1, NA, right_bis),
         right_quarter = ifelse(IMD3002_IF_CSES == 1 & right_bis==0, NA, right_bis))

#### 2.5 Standardization ####
 dat <- dat |>
  mutate(age_r = (age - mean(age, na.rm = TRUE)) / (2 * sd(age, na.rm = TRUE)),
         rile_left_r = (rile_left - mean(rile_left, na.rm = TRUE)) / (2 * sd(rile_left, na.rm = TRUE)),
         rile_right_r = (rile_right - mean(rile_right, na.rm = TRUE)) / (2 * sd(rile_right, na.rm = TRUE)),
         gini_r = (gini - mean(gini, na.rm = TRUE)) / (2 * sd(gini, na.rm = TRUE)))

#### 3. Saving ####

write_excel_csv(dat,"../data/MajBenRight_clean.csv")

