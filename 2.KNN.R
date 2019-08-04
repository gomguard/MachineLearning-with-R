###########################################################################
#
#    script_name : 2.KNN.R
#    author      : Gomguard
#    created     : 2019-08-04 11:21:35
#    description : knn algorithm
#
###########################################################################

library(tidyverse)

wbcd <- read_csv('./ml_R_bread/Chapter 03/wisc_bc_data.csv')
wbcd %>% glimpse()
table(wbcd$diagnosis)

wbcd$diagnosis <- factor(wbcd$diagnosis, 
                         levels = c("B", "M"), 
                         labels = c("Benign", "Malignant"))

round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

summary(wbcd[c('radius_mean', 'area_mean', 'smoothness_mean')])

normalize <- function(x){
  return((x - min(x)) / (max(x) - min(x)))
}

# https://rfriend.tistory.com/52 
1:50 %>% 
  normalize()
seq(0,50,5) %>% 
  normalize()
