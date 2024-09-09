# Basic Operators
#### 1. Operators ####
#### 1.1 Arithmetic ############################################################

# Addition
2+3

# Substraction
2-3

# Multiplication
2*3

# Division
2/3

# Exponent
2^3

# Modulus
2%%3

#### Try it! 
# What's 2 times the sum of all integers from 1 to 5?

#### 1.3 Logic #################################################################
A <- 10
B <- 11
C <- 9

# Is A equal to B?
A == B

# Is A not equal to B?
A != B

# Is A bigger than B?
A > B

# Is A smaller than B?
A < B

# Is A bigger or equal to B?
A >= B

# Is A smaller or equal to B?
A <= B

# Condition 1 AND condition 2
A < B & A > C

# Condition 1 OR condition 2
A > B | A > C

# NOT
!(A > B | A > C)

#### Try it! 
# Assign a number to a variable called potato and another to a variable called
# melon, does the square root of their multiplication is higher than 10? 

#### 1.4 Advanced logic ####

# if (condition) {do this}
# else if (condition) {do this}
# else {do that}

if(A > B){
  print("A is bigger than B")
} else if (A == B) {
  print("A is equal to B")
} else {
  print("A is bigger than B")
}