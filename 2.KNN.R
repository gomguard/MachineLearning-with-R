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


wbcd_n <- wbcd %>% 
  dplyr::select(-1,-2) %>% 
  map( normalize) %>% 
  as_tibble()

wbcd_n %>% summary()

wbcd_train <- wbcd_n[1:469, ]
wbcd_test  <- wbcd_n[470:569, ]

wbcd_train_lbls <- wbcd[1:469, 2]
wbcd_test_lbls <- wbcd[470:569, 2]

library(class)
library(gmodels)


wbcd_n <- wbcd %>% 
  dplyr::select(-1, -2) %>% 
  map(scale) %>% 
  as_tibble()

result <- tibble()
for (idx in 1:50) {
  wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, 
                        cl = wbcd_train_lbls %>% pull(), k = idx)  
  
  ct <- CrossTable(x = wbcd_test_lbls %>% pull(), y = wbcd_test_pred)
  
  ct_prop <- ct$prop.tbl
  prop_wrong <- ct_prop[2,1] + ct_prop[1,2]
  result <- result %>% 
    bind_rows(list(idx = idx, value = prop_wrong))
}
par(mfrow = c(1, 1))
plot(result)

result %>% 
  dplyr::filter(value == min(value))
