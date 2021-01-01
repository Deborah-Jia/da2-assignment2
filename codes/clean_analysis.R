library(tidyverse)
library(dplyr)

df2 <- read_csv2("/Users/wodediannao/Desktop/da2-assignment2/data/raw/b_f_raw1.csv")

df2 <- df2[-c(38),]

df2 <- df2 %>% select(c(`Life satisfaction`, `Employment rate`,`Air pollution`,`Water quality`,`Quality of support network`,`Voter turnout`,`Life expectancy`,`Feeling safe walking alone at night`,`Homicide rate`))

df2 <- df2 %>% rename(life_sa = `Life satisfaction`, employ_r = `Employment rate`, air_pol = `Air pollution`,
               water_q = `Water quality`, network = `Quality of support network`, v_turnout = `Voter turnout`,
               life_exp = `Life expectancy`, walk_n = `Feeling safe walking alone at night`, homicide = `Homicide rate`)

my_path <- "/Users/wodediannao/Desktop/da2-assignment2/data/"

write_csv( df2 , paste0(my_path,'clean/b_f_clean.csv'))
