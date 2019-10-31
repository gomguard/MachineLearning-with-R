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
