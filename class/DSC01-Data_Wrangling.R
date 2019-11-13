###########################################################################
#
#    script_name : DSC01-Data_Wrangling.R   
#    author      : Gomguard
#    created     : 2019-11-13 15:07:42
#    description : how to wrangle data with R / Tidyverse
#
###########################################################################

#### tips
# shortcuts : shift + alt + k
# comment   : shift + ctrl + c

####
library(tidyverse)
library(skimr)


# Exploratory Data Analysis
diamonds

# 1. What type of variation occurs within my variables?
# 2. What type of covariation occurs between my variables?

# base R - summary, str, dim
diamonds %>% summary()
diamonds %>% str()
diamonds %>% dim()

# tidyverse - dplyr::glimpse, skimr::skim
diamonds %>% glimpse()
diamonds %>% skim()




Transposed tibble. tribble()
# cartesian - Rene Decartes