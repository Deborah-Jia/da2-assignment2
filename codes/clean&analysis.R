rm(list=ls())
library(tidyverse)
library(dplyr)

my_url <- "https://raw.githubusercontent.com/Deborah-Jia/da2-assignment2/main/data/"
df2 <- read_csv2(paste0(my_url, 'raw/b_f_raw.csv'))

df2 <- df2[-c(38),]

df2 <- df2 %>% select(c(`Country`,`Life satisfaction`, `Employment rate`,`Air pollution`,`Water quality`,`Quality of support network`,`Voter turnout`,`Life expectancy`,`Feeling safe walking alone at night`,`Homicide rate`))

df2 <- df2 %>% rename(life_sa = `Life satisfaction`, employ_r = `Employment rate`, air_pol = `Air pollution`,
               water_q = `Water quality`, network = `Quality of support network`, v_turnout = `Voter turnout`,
               life_exp = `Life expectancy`, walk_n = `Feeling safe walking alone at night`, homicide = `Homicide rate`)

my_path <- "/Users/wodediannao/Desktop/da2-assignment2/data/"

write_csv( df2 , paste0(my_path,'clean/b_f_clean.csv'))


# Analysis of data --------------------------------------------------------
df <- read_csv(paste0(my_url, 'clean/b_f_clean.csv'))

# Quick check on all HISTOGRAMS
df %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") +
  geom_histogram()

summary( df )

# Check the main parameter of interests and potential con-founders:

# score 4
ggplot( df , aes(x = )) +
  geom_histogram(binwidth = 5,fill='navyblue') +
  labs(x = "Averaged values of test scores for schools") 

# stratio
ggplot( df , aes(x = )) +
  geom_histogram(binwidth = 0.5,fill='navyblue') +
  labs(x = "Student to teacher ratio") 

# English
ggplot( df , aes(x = english)) +
  geom_histogram(binwidth = 0.5,fill='navyblue') +
  labs(x = "Ratio of english learners") 

# 4) Comparing explanatory variables 
#
# Check the correlations
#
numeric_df <- keep( df , is.numeric )
cT <- cor(numeric_df , use = "complete.obs")

# Check for highly correlated values:
sum( abs(cT) >= 0.8 & cT != 1 ) / 2
# Find the correlations which are higher than 0.8
id_cr <- which( abs(cT) >= 0.8 & cT != 1 )

# no variables are hhighly related

# 4) Checking some scatter-plots:
# Create a general function to check the pattern
chck_sp <- function(x_var){
  ggplot( df , aes(x = x_var, y = life_exp)) +
    geom_point() +
    geom_smooth(method="loess" , formula = y ~ x )+
    labs(y = "Life Span") 
}

# Our main interest: Employment rate
chck_sp(df$employ_r)

chck_sp(df$air_pol)

chck_sp(df$water_q)

chck_sp(df$network)

chck_sp(df$v_turnout)

chck_sp(df$walk_n)
chck_sp(df$homicide)
# modelling ---------------------------------------------------------------
#
# Start from simple to complicated
#
# Main regression: score4 = b0 + b1*stratio
#   reg1: NO controls, simple linear
#   reg2: NO controls, use piecewise linear spline(P.L.S) with a knot at 18
# Use reg2 and control for:
#   reg3: english learner dummy
#   reg4: reg3 + Schools' special students measures (lunch with P.L.S, knot: 15; and special)
#   reg5: reg4 + salary with P.L.S, knots at 35 and 40, exptot, log of income and scratio

# reg1: NO control, simple linear regression
reg1 <- lm_robust( life_sa  ~  life_sa + employ_r + air_pol + water_q + network + v_turnout + life_exp + walk_n + homicide, data = df )
summary( reg1 )

