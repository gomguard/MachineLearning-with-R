###########################################################################
#
#    script_name : parsnip_tree_test.R
#    author      : Gomguard
#    created     : 2019-11-01 00:45:10
#    description : desc
#
###########################################################################

library(tidyverse)

library(parsnip)



mod_rf <- 
  rand_forest(trees = 2000, mtry = varying(), mode = "regression") %>%
  set_engine("ranger", seed = 63233) %>% 
  set_args(mtry = 10) %>% 
  fit(mpg ~ . , mtcars) 

# mod_xg <- parsnip::xgb_train(x = iris[-5], y = iris[[5]], max_depth = 5, nrounds = 10)
mod_xgb <- boost_tree(mode = "regression", mtry = 20, trees = 50) %>% 
  set_engine('xgboost') %>% 
  update() %>% 
  fit(mpg ~ ., mtcars)


result <- mtcars %>% 
  mutate(.pred_rf = predict(mod_rf, mtcars) %>% pull(),
         .pred_xg = predict(mod_xgb, mtcars) %>% pull(),) %>% 
  select(mpg, .pred_rf, .pred_xg)

mod_xgb %>% 
  predict(mtcars)

mape(result, mpg, .pred_rf)
mape(result, mpg, .pred_xg)

# xgboost parameter
# https://tidymodels.github.io/parsnip/reference/boost_tree.html
# boost_tree() is a way to generate a specification of a model before fitting and allows the model to be created using different packages in R or via Spark. The main arguments for the model are:
#   
# mtry: The number of predictors that will be randomly sampled at each split when creating the tree models.
# trees: The number of trees contained in the ensemble. 
# min_n: The minimum number of data points in a node that are required for the node to be split further. 
# tree_depth: The maximum depth of the tree (i.e. number of splits). 
# learn_rate: The rate at which the boosting algorithm adapts from iteration-to-iteration. 
# loss_reduction: The reduction in the loss function required to split further. 
# sample_size: The amount of data exposed to the fitting routine.


