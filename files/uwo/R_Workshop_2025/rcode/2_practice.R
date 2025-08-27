#------------------------------------------------------------------------------#
#------------------------------ Practice File ---------------------------------#
#------------------------------------------------------------------------------#

#### 1. Importing Data ####

library(tidyverse)
library(rio)
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
dat <- import("../data/MajBenRight_clean_2010plus.dta")

#### 2. Looking at our data ####

#### 3. Indexing ####

#### 4. Operators ####

#### 5. Exercise ####

# Subset the data (`dat`) such that:
# 1. Only columns 390 (`polity`), 391 (`year`), and 633 (`proportional`) appear;
# 2. Only data on the `year` 2015 for which `proportional` = 0
# 
# How many unique values are there in `polity`?