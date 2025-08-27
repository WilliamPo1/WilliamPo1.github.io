################################################################################
######################### R Workshop --- Data Handling I #######################
################################################################################
##################### ~~~  Tutorial by Hunter Driggers  ~~~ #################### 
################################################################################

### Loading packages into R Studio ---------------------------------------------
# Most packages come from CRAN
install.packages("tidyverse")
library(tidyverse)

# Some packages come from elsewhere (e.g., Github)
install.packages("remotes")
library(remotes)
install_github("davidaarmstrong/damisc")
library(DAMisc)

# We can install multiple packages from CRAN at once,
# but we must remember to load them to our environment individually
install.packages("tidylog", "marginaleffects", "cowplot")
library(tidylog)
library(marginaleffects)
library(cowplot)


### Changing the working directory ---------------------------------------------
# R Studio does not assume where files should come from or go to,
# and you can load and save files more quickly by setting the working directory

# Example: set working directory to Desktop
setwd("C:/Users/hunte/Desktop")

# Example: set working directory to same location where this R script is saved
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


### Importing data into R Studio -----------------------------------------------
# R data files can be imported using load()
# Objects will automatically be named whatever they were named when last saved
load("../data/cora-cdem-2022_F1.RData")
rm(data) # removes dataframe "data" from our local environment

# Other types of data files must be imported using special functions and named
# read_csv() and read_tsv() can be used after loading the "tidyverse" library
data <- read_csv("../data/cora-cdem-2022_F1.csv")
rm(data)

data <- read_tsv("../data/cora-cdem-2022_F1.tab")
rm(data)

# Some data types require may require special packages to be installed
# before the data can successfully be imported
install.packages("haven")
library(haven)

data <- read_sav("../data/cora-cdem-2022_F1.sav")
rm(data)

data <- read_dta("../data/cora-cdem-2022_F1.dta")
rm(data)

install.packages("readxl")
library(readxl)

data <- read_excel("../data/cora-cdem-2022_F1.xlsx")


### Understanding the dimensions of our data -----------------------------------
# Function dim() takes a vector or dataframe and
# returns the number of rows and columns
dim(data)

# Function nrow() returns only the numbers of rows
nrow(data)

# Functions ncol() and length() return only the number of columns
ncol(data)
length(data)


### Taking a look at our data --------------------------------------------------
# Understand the data you are working with by checking its 'class'.
# This can be helpful for catching mistakes and debugging your code.
class(data)
class(data$ResponseId)
class(data$RecordedDate)
class(data$time)

# You can also take a peek at your data using head() or tail()
head(data, n = 5)
tail(data, n = 10)

# Function unique() outputs only unique values from some vector 
# or some column from a dataframe
unique(data$survey_wave)
unique(data$dc22_genderid)

# Function table() prints a quick crosstabulation of whichever two
# columns are selected from a dataframe. First input becomes rows,
# second input becomes columns.
table(data$dc22_genderid, data$dc22_democratic_sat)


### Indexing -------------------------------------------------------------------
# Sometimes you might want to select certain observations from a vector,
# dataframe, or similar type of object. One way to do this efficiently
# is via 'indexing'.

# Creating a simple vector with numbers ranging from 1 to 20 (for example).
vector <- c(1:20)

# Selecting the fifth observation from the vector named 'vector'.
subset <- vector[5]
print(subset)
rm(subset)

# Selecting observations five through seven from vector 'vector'.
subset <- vector[5:7]
print(subset)
rm(subset)

# For two-dimensional objects like dataframe 'data', indexing is [rows, columns].
# Selecting all observations from column five of dataframe 'data'.
subset <- data[, 5]
head(subset, n = 5)
rm(subset)

# Selecting all observations from columns five through seven of dataframe 'data'.
subset <- data[, 5:7]
head(subset, n = 5)
rm(subset)

# Selecting all observations from non-consecutive columns in dataframe 'data'.
subset <- data[, c(14, 16, 23:26)]
head(subset, n = 5)
rm(subset)

# Selecting observations from rows 6 through 600 for all columns in 'data'.
subset <- data[6:600,]
head(subset, n = 5)
rm(subset)

# Selecting observations from rows 6 through 600 for non-consecutive columns in 'data'.
subset <- data[6:600, c(14, 16, 23:26)]
head(subset, n = 5)
rm(subset)