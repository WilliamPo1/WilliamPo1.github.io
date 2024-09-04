################################################################################
########################## R Workshop --- Operators ############################
################################################################################
####################### ~~~  Tutorial by Jan Eckardt  ~~~ ###################### 
################################################################################


# Inspecting our Data

# First, we want to take a brief look at our data to get an impression of 
# its basic features. We can do this using the head() function. By default, 
# the function will print the first six rows of all columns in our dataframe. 
# For this part of the workshop we will use the "iris" dataset that is built 
# into R - no need to load anything from outside the software. 

head(iris)

# Note how the dataset seems to be related to plants - namely, the iris flowering 
# plant and measurements of its flower for different species 

# We can also use the dim() function to display the number of its columns and rows
# Remember that just when indexing, the first number represents rows, while 
# the second number refers to the number of columns in the dataframe 

dim(iris)

# Basic Statistics ####

# Mean 

# The "mean" refers to the average value of a distribution. Think of this 
# as you would about calculating your average grades in high school, for example

mean(iris$Sepal.Length)

# Median

# The "median" can be used as an alternative to the mean to avoid false inferences
# based on the presence of outliers. It refers to the 50th percentile of a 
# distribution, meaning the value that is right in the middle when values are 
# ordered from smallest to largest

median(iris$Sepal.Length)

# Here, we do not see a large difference between the mean and the median, 
# meaning that there probably are not any strong outliers biasing our mean value
# down- or upwards

# Maximum Value

# We can get a distribution's maximum value by using the max() function

max(iris$Sepal.Length)

# Minimum Value 

# Conversely, we obtain the minimum value by using min()

min(iris$Sepal.Length)

# Arithmetic Operators ####

# We can perform all kinds of basic mathematic operations in R, including: 

# Addition...

4 + 4 

# ...subtraction...

4 - 4

# ...multiplication...

4 * 4

# ...and division

4 / 4 

# We can also use these in conjunction with variables:

# For instance, we could multiply our values for Sepal.Length by 0.393701 to 
# convert them from centimeters to inches 

iris$Sepal.Length * 0.393701

# Relational Operators and Assignment ####

# There are also several "relational" operators that help us "tell" R how 
# different objects relate to each other 

# Equal-to Operator: "=="

iris[iris$Species == "setosa",]

# Not-equal-to Operator: "!="

iris[iris$Species != "setosa",]

# Greater-than Operator: ">"

iris[iris$Sepal.Length > 5.4,]

## A couple of rows, including row 6, have now been dropped from the output...

#nrow(iris[iris$Sepal.Length >= 5.4,])

# Greater-or-equal Operator: ">="

iris[iris$Sepal.Length >= 5.4,]

## ...whereas we can see it again now 

# Smaller-than Operator: "<"

iris[iris$Sepal.Length < 5.4,]

# Smaller-or-equal Operator: "<="

iris[iris$Sepal.Length <= 5.4,]

# OR Operator: "|"

iris[iris$Species == "setosa" | iris$Species == "virginica", ]

# AND Operator: & 

iris[iris$Species == "virginica" & iris$Sepal.Width > mean(iris$Sepal.Width), ]

# Assignment Operator #### 

# Typically, to store operations in R, we will use the assignment operator 
# "<-" to assign the information on the RIGHT of the operator to what is on 
# the LEFT of it. For a very basic example, we could assign the number 5 to a 
# new object named "five" 

five <- 5 

# We could also do this for character values, e.g.: 

my_favorite_university <- "Western"

# We can also assign the data we just indexed to a new object using the same 
# operator. We are also only keeping our two columns of interest 

wide_virginica <- iris[iris$Species == "virginica" & iris$Sepal.Width > mean(iris$Sepal.Width), 
                       c("Species", "Sepal.Width")]

# Note how the dimensions of our new wide_virginica dataframe are different from 
# what we had originally 

dim(wide_virginica)

# TRUE and FALSE statements/Boolean values ####

# We will now briefly look at so called Boolean values, i.e., so-called 
# 'truth-values'. These can often inform us about properties of our data.

# For instance, we could be looking at if any of our rows exceed a given value, 
# say, 5.6., for Sepal.Length. We can use the any() function for this. This will 
# be TRUE, because, as we have seen before, the maximum value for Sepal.Length 
# is 7.9 

any(iris$Sepal.Length > 5.6)

# As expected, the logical statement is TRUE, telling us that there are indeed 
# rows in our dataframe that exceed this value for the Sepal.Length column

# To get a better account of how these values can help us understand our data, 
# we can also look at a specific subset of our data. For instance, we may be 
# interested in whether any of irises of the "setosa" species in our 
# dataframe exceed the mean value for Sepal.Length. We can use indexing for 
# this 

any(iris[iris$Species == "setosa", ]$Sepal.Length > mean(iris$Sepal.Length))

# This will give us a FALSE statement, showing that no Iris setosas exceed the 
# mean value for Sepal.Length in our dataframe. In more practical terms, this 
# means that the setosa species's sepal length is always below the average 
# sepal length of the other two species included in the dataframe (setosa and 
# virginica)

# Note that any() is far from the only function outputting logical statements 
# in R (all(), is.na(), identical() can be used in a similar fashion to explore 
# our data, just to name a few). We could even display statements for each 
# row by using the basic logical operators we just learned about 

# For instance...

mean(iris$Sepal.Length) > mean(iris$Sepal.Width)

# Sepals tend to be longer, rather than wide 

# Optional EXERCISE ####

# We will now turn towards some of what we learned here to our data and apply it
# ourselves. For this, we will be using a cleaned subset of the Democracy Checkup 
# data (DC22_rworkshop_data.csv). We will also be using this subset for the final 
# part of the workshop.

# To load in data, we are using the assignment operator to assign our dataset 
# to an object in R, just like we did for the previous objects. 

DC22 <- read.csv("../data/DC22_rworkshop_data.csv")

# Now, try to subset this dataset again to only contain respondents whose interest
# in politics (interest_pol) is greater than 5 and assign it to an object called 
# 'high_polint'. 

# Hint: You will need to use a relational operator and indexing here. The solution
# can be found at the bottom of this script. 




















# SOLUTION #

high_polint <- DC22[DC22$interest_pol > 5, ]



