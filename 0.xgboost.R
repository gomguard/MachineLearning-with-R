###########################################################################
#
#    script_name : 0.xgboost.R
#    author      : Gomguard
#    created     : 2019-10-04 21:14:16
#    description : desc
#
###########################################################################


# https://xgboost.readthedocs.io/en/latest/R-package/xgboostPresentation.html

# xgboost manual
# https://xgboost.readthedocs.io/en/latest/parameter.html#additional-parameters-for-dart-booster-booster-dart
library(tidyverse)

# install.packages("drat", repos="https://cran.rstudio.com")
# drat:::addRepo("dmlc")
# install.packages("xgboost", repos="http://dmlc.ml/drat/", type = "source")
## dmlc.ml doesn't work
# install.packages("xgboost")

library(xgboost)
data(agaricus.train, package='xgboost')
data(agaricus.test, package='xgboost')
train <- agaricus.train
test <- agaricus.test


