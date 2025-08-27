################################################################################
####################### R Workshop --- Data Handling II ########################
################################################################################
#################### ~~~  Tutorial by Justine Béchard  ~~~ ##################### 
################################################################################

# Part 2: Missingness and Tidy Data Practices with Tidyverse
#_______________________________________________________________________________

# Installing the Dataset ####
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
DC22 <- read.csv("../data/DC22_rworkshop_data.csv")

# Handling Missing Data ####
# NULL ####
# Represents the absence of value or an undefined object. 
# It will return NULL because "educaton" does not exist. 
DC22$educaton

# NA (Not available) ####
# It corresponds to missing or undefined data.
DC22[7,6]
  
# NaN (Not a number) ####
# A type of NA for undefined mathematical operations.
0/0

# Tidyverse ####
# Installing and activating tidyverse
install.packages("tidyverse")
library(tidyverse)

# The Pipe Operator %>% in dplyr ####
# A key feature when using dplyr. It turn nested code into sequential code. 
# This allows you to chain together multiple functions in a step-by-step process. 

# Let's imagine we want to know the average level of interest in politics
# among different age categories, but only for participants who voted 
# in the 2021 federal election. 

# Without the pipe operator:
summarize(group_by(filter(DC22, turnout_2021 == 1),age_category), 
          mean_interest_pol = mean(interest_pol, na.rm = TRUE))

# With the pipe operator:
# Each line in a piped sequence takes the most recent form of an object and apply 
# the next transformation to it.
DC22 %>% 
  filter(turnout_2021 == 1) %>%
  group_by(age_category) %>%
  summarize(
    mean_interest_pol = mean(interest_pol, na.rm = TRUE)
  )

# Tidy Data Practices ####
# select() ####
# Select subsets your data by choosing columns to keep/discard. 
select1 <- DC22 %>%
  select(age_category, education, vote_choice) # Subsetting by these variables.

# Display the result
# Print the structure of the new data frame
glimpse(select1)
# Print the first few rows 
head(select1)

# Also works with tidyselect functions. 
select2 <- DC22 %>%
  select(contains("vote")) 
glimpse(select2)

select3<- DC22 %>%
  select(starts_with("educ")) 
glimpse(select3)

# filter() ####
# Subset rows based on logical conditions. 
filter1 <- DC22 %>%
  filter(turnout_2021 == 1) 
glimpse(filter1)

filter2 <- DC22 %>% 
  filter(age_category == "18-24" & vote_choice == "Green Party")
glimpse(filter2)

filter3 <- DC22 %>%
  filter(leftright > 7)
glimpse(filter3)

# arrange() ####
# Can help you sort the data based on the values in a specific column
arrange1 <- DC22 %>%
  arrange(leftright) # Arrange data in ascending order.
glimpse(arrange1)

arrange2 <- DC22 %>%
  arrange(desc(leftright)) # Arrange data in descending order.
glimpse(arrange2)

# mutate() ####
# You can use it to transform existing columns or add new ones.  
DC22_acronym <- DC22 %>%
  mutate(
    party_acronym = case_when(
      vote_choice == "Liberal Party" ~ "LPC",
      vote_choice == "Conservative Party" ~ "CPC",
      vote_choice == "New Democratic Party" ~ "NDP",
      vote_choice == "Green Party" ~ "GP",
      vote_choice == "Bloc Québécois" ~ "BQ",
      vote_choice == "Another party" ~ "Other"
    )
  )
glimpse(DC22_acronym)

# group_by() ####
# Grouping data by one or many variables. 
# This allows us to perform operations within those groups. 
# group_by will produce different results, depending on mutate vs. summarize.
# You can group on multiple variables if you would like.

DC22 %>%
  group_by(age_category) %>%
  mutate(mean_interest = mean(interest_pol, na.rm = TRUE))

DC22 %>%
  group_by(age_category) %>%
  summarize(mean_interest = mean(interest_pol, na.rm = TRUE))

# summarize() ####
# Used to create new variables (usually after group_by) in new tibble altogether.
# It will only keep: 
# (1) the variables you group on and 
# (2) the new variables you create. 

DC22 %>%
  group_by(age_category) %>%
  summarize(mean = mean(interest_pol, na.rm = TRUE),
            max = max(interest_pol, na.rm = TRUE),
            min = min(interest_pol, na.rm = TRUE))


# Making a Plot with ggplot2####
DC22 %>%
  # Remove rows where vote_choice is NA or "Another party"
  filter(!is.na(vote_choice) & vote_choice != "Another party") %>% 
  # Group the data by age_category and vote_choice
  group_by(age_category, vote_choice) %>%
  # Counting the number of observations and calculating percentages
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count) * 100) %>%
  # This is where the plot starts! 
  ggplot(aes(x = age_category, y = percentage, fill = vote_choice)) +
  geom_bar(stat = "identity", position = "dodge") +
  #scale_fill_manual(values = c( # Manually specify custom colors
  #  "Liberal Party" = "#cc2211",
  #  "Conservative Party" = "#0f0b8e",
  #  "New Democratic Party" = "#f79619",
  #  "Green Party" = "#0eca3c",
  #  "Bloc Québécois" = "#19c8f7"
  #)) +
  #labs(title = "Vote Choice Distribution by Age", # Add labels
  #     x = "Age Category",
  #     y = "Percentage (%)",
  #     fill = "Vote Choice") +
  theme_minimal() + # Apply a predefined theme
  theme( # Additional theming options
    #plot.title = element_text(size = 16, hjust = 0.5), # Center and change the size of the plot title
    #axis.text.x = element_text(color = "black", size = 12),  # Change x-axis text color and size
    #axis.text.y = element_text(color = "black", size = 12),   # Change y-axis text color and size
  ) 

