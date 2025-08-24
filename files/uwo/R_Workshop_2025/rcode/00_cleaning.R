#### Cleaning Data for PSRM replication ####

#### 0. Initialization ####

library(tidyverse)
library(rio)

cses <- import("data/cses_imd.dta")
macro <- import("data/macro_bis.dta") |> distinct(polity, year) ### DO THIS TO THE OTHERS!!!
lis <- import("data/lis_bis.dta")
rile <- import("data/RILE Right ter.dta")
frag <- import("data/PS Frag PSRM.dta")

#### 1. Merging data files ####

dat <- cses |> 
  filter(IMD1006_NAM %in% c("Australia","Austria","Belgium","Canada","Denmark","Finland","France","Germany","Great Britain","Greece","Iceland","Ireland","Italy","Japan","Netherlands","New Zealand","Norway","Spain","Portugal","Sweden","Switzerland","United States of America")) |> 
  mutate(IMD1006_NAM = case_when(IMD1006_NAM=="United States of America" ~ "USA",
                                 IMD1006_NAM=="Great Britain" ~ "United Kingdom",
                                 TRUE ~ IMD1006_NAM),
         polity=IMD1006_NAM,
         year=IMD1008_YEAR) |> 
  arrange(polity,year) |> 
  full_join(test, by = c("polity","year"), relationship = "many-to-many") |> 
  rename(rile_left=rile) |> 
  mutate(polity=ifelse(polity=="Unites Kingdom","Great Britain",polity)) |> 
  full_join(lis, by = c("polity","year"), relationship = "many-to-many") |> 
  mutate(election=IMD1008_YEAR,
         country_code=country) |> 
  arrange(country_code,election) |> 
  full_join(rile, by = c("country_code","election"), relationship = "many-to-many") |> 
  mutate(country_name=polity) |> 
  arrange(country_name,year) |> 
  full_join(frag, by = c("country_name", "year"), relationship = "many-to-many")
  