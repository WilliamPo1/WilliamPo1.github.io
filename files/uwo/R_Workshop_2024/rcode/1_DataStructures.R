################################################################################
######################### R Workshop --- Data Structures #######################
################################################################################
##################### ~~~  Tutorial by William Poirier  ~~~ #################### 
################################################################################

#### 00. House Keeping #########################################################
# Tools > Global Options > Code > Editor Scroll Speed Sensitivity > 200


#### 0. Working Directory ######################################################

# What is a directory? 
# What is a working directory?
# How do you set your working directory?

# Has this structure on MAC: /Users/williampoirier/Dropbox/etc
# Has this structure on PC: C:\Users\williampoirier\Dropbox\etc

# Shortcuts:
## MAC: option + command + c
## PC: shift + right click > Copy as Path

setwd("/Users/williampoirier/Dropbox/Website/files/uwo/R_Workshop_2024")

#### 1. Assignment #############################################################

# The right way
banana <- 3

# The wrong way
banana = 3

# Global assigner
banana <<- 3

# FOR ENGLISH KEYBOARDS
# PC: alt + - 
# MAC: option + -

#### Try it! 
# Assign some value to some variable

#### 2. Data types #############################################################

# Integer
Apple <- 13L
class(Apple)

# Numeric
Banana <- 13
class(Banana)

# Character
Cherry <- "13"
class(Cherry)

# Logical
Durian <- TRUE
class(Durian)

#### Try it! 
# What happens when you add Apple and Banana together? 
Apple + Banana

# What about Apple and Durian?
Apple + Durian

# What about Apple and Cherry?
Apple + Cherry

#### 3. Data Structures ########################################################

#### 3.1 Vectors ####
# One data type allowed. R's basic data structure.

# A vector
stuff <- "Kumquat"
stuff

# Also a vector
stuff <- c("Knickknacks","Kerfuffle","Kumquat")
stuff

# Also a vector
(otherStuff <- c(T,F,T,T,T,F)) # Parenthesis around assignment prints the new object.

#### Why c() ? 

(scoreOfWordsThatStartsWithK_1 <- 8:10) 
# OR 
(scoreOfWordsThatStartsWithK_2 <- c(8,9,10))

#### What if I want the score from 0 to 100 instead of 0 to 10?
(scoreOfWordsThatStartsWithK_3 <- 10*scoreOfWordsThatStartsWithK_2)

#### What if I want to relate the names to the score?
(names(scoreOfWordsThatStartsWithK_1) <- stuff)

# Like adding a second dimension to the data!

#### 3.2 Matrices ####
# Again, only one data type. 2 dimensions of it this time.

(myMatrix <- matrix(1:9,nrow=3,ncol=3))

# Accepts all operations that matrices accept in math
# Like transpose for example
t(myMatrix)

# Works with characters as well!
(letterMatrix <- matrix(letters,ncol=2))
t(letterMatrix)

#### What if I want multiple data types? 

#### 3.3 Data Frames ####
# One data type per column, essentially a collection of vectors, i.e. an excel sheet.

(wordData <- data.frame(stuff,scoreOfWordsThatStartsWithK_2))

#### How do I change the column names?
colnames(wordData) <- c("word","score")
wordData

# OR
(wordData <- data.frame(word=stuff,
                        score=scoreOfWordsThatStartsWithK_2))

#### What happens if I do this?
class(wordData)

#### 3.4 Lists ####
# Anything you want. Can mix object type and data structures.

myList <- list(stuff,letterMatrix,wordData)

#### 4. Functions and Packages #################################################

#### What is a function?

myFunction <- function(stuff_in){
  # Some operation
  return(stuff_out)
}

#### What are packages?
# Packages are a collection of functions wrote by other users or yoursefl!
# More on them later

#### 5. Loading a dataset ######################################################

Data <- read.csv("data/Democracy Checkup 2022/cora-cdem-2022_F1.csv")

