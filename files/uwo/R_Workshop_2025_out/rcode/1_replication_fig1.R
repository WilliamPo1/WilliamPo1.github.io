#-------------------------- Replicating Figure 1 of ---------------------------#
#-------------- Why do majoritarian systems benefit the right ? ---------------#
#----------------------------- By William Poirier -----------------------------#

#### 0. Initialization ####

#### 0.0 Installing packages, you do this once ####
install.packages("tidyverse") #makes coding easier, you'll see
install.packages("rio") #to import data of different formats
install.packages("sandwich") #for robust se
install.packages("marginaleffects") #to produce ME and FD
install.packages("car") #for regression diagnostics



#### 0.1 Loading packages, you this every time you open a new R session. ####
library(tidyverse)
library(rio)
library(sandwich)
library(marginaleffects)
library(car)

#### 0.2 Setting your working directory ####
# Option 1: where you want
setwd("/Users/williampoirier/Dropbox/Website/files/uwo/R_Workshop_2025/rcode")

# Option 2: where the R file is saved
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#### 0.3 Loading data ####
# Original file is quite large
# dat <- import("../data/MajBenRight_clean_orig.dta")
# sub <- dat |> 
#  filter(IMD1009==10)

# Use this for now
sub <- import("../data/MajBenRight_clean_2010plus.dta")

#### 1. Models ####

#### 1.1 Model 1 - Bivariate ####
mod1 <- glm(right_bis ~ middleclass*proportional + upperclass + factor(year),
            family=binomial, data=sub)
# Cluster robust se on study variable
vcov1 <- sandwich::vcovCL(mod1, cluster = ~ study)

#### 1.2 Model 2 - Controls macro ####
mod2 <- glm(right_bis ~ middleclass*proportional + upperclass + factor(year) +
              gini_r + rile_left_r,
            family=binomial, data=sub)
# Cluster robust se on study variable
vcov2 <- sandwich::vcovCL(mod2, cluster = ~ study)

#### 1.3 Model 3 - Controls micro ####
mod3 <- glm(right_bis ~ middleclass*proportional + upperclass + factor(year) +
              gini_r + rile_left_r + leftright + age_r + female + degree,
            family=binomial, data=sub)
# Cluster robust se on study variable
vcov3 <- sandwich::vcovCL(mod3, cluster = ~ study)

#### 2. Analysis ####

#### 2.1 First differences ####
fd1 <- marginaleffects::avg_comparisons(
  mod1, vcov = vcov1,
  variables = c("middleclass","proportional","upperclass"),
  comparison = "difference") |>
  mutate(model = "Income group")

fd2 <- marginaleffects::avg_comparisons(
  mod2, vcov = vcov2,
  variables = c("middleclass","proportional","upperclass",
                "gini_r","rile_left_r"),
  comparison = "difference") |>
  mutate(model = "Aggregate-level controls")

fd3 <- marginaleffects::avg_comparisons(
  mod3, vcov = vcov3,
  variables = c("middleclass","proportional","upperclass",
                "gini_r","rile_left_r","leftright",
                "age_r","female","degree"),
  comparison = "difference") |>
  mutate(model = "Individual-level controls")

fd <- rbind(fd1,fd2,fd3)  |>
  mutate(term = factor(term, levels = c("middleclass","proportional","upperclass",
                                        "gini_r","rile_left_r","leftright",
                                        "age_r","female","degree"),
                       labels = c("Middle income","PR","Upper income",
                                  "Gini","Socialdemocrats' LR ideology",
                                  "Left-right ideol.","Age","Female","University degree")),
         model = factor(model, levels = c("Income group",
                                          "Aggregate-level controls",
                                          "Individual-level controls")))

#### 3. Figures ####
#### 3.1 Figure 1 ####
ggplot(fd,aes(x=estimate*100,y=fct_rev(term),color=model,shape=model)) +
  geom_vline(xintercept=0,color="#B02539")+
  geom_pointrange(aes(xmax = conf.high*100, xmin = conf.low*100),
                  position=position_dodge2(width=.8, reverse=T)) +
  scale_x_continuous("First difference in probability of voting for the right (%)")+
  scale_color_manual(values=c("#285F17","#EC5429","#27456B"))+
  theme_minimal() +
  theme(axis.title.y=element_blank(),
        legend.title=element_blank())
  
