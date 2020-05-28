###########################################################################
#
#    script_name : parsnip_ori_pck_comp.R
#    author      : Gomguard
#    created     : 2019-11-03 01:21:28
#    description : desc
#
###########################################################################

library(tidyverse)
library(tidymodels)

mtcars
# linear_reg
fm <- mpg ~ .

# lm
linear_reg(mode = 'regression', penalty = 0.1, mixture = 0.5) %>% 
  set_engine('lm') %>% 
  update(penalty = 1, fresh = T) %>% 
  fit(fm, mtcars)

lm(fm, mtcars)


# keras
mod_ln_keras <- linear_reg(mode = 'regression', penalty = 0.1, mixture = 0.5) %>% 
  set_engine('keras') %>% 
  # update(penalty = 1, fresh = T) %>% 
  set_args(hidden_units = 3) %>% 
  fit(fm, mtcars)

mtcars
predict(mod_ln_keras, mtcars)

# defining the model and layers
# library(keras)
# model <- keras_model_sequential()
# model %>%
#   layer_dense(units = 3, input_shape = 10) %>% 
#   layer_dense(units = 1, input_shape = 3)
# # compile (define loss and optimizer)
# model %>% compile(
#  loss = 'mse',
#  optimizer = optimizer_rmsprop(),
#  metrics = c('accuracy')
# )
# # train (fit)
# model %>% fit(
#   mtcars %>% select(-mpg), mtcars$mpg,
#   epochs = 30, batch_size = 128,
#   validation_split = 0.2
# )
# 
# model %>% evaluate(x_test, y_test)
# model %>% predict_classes(x_test)
# 
# The model can be created using the fit() function using the following engines:
#     
# R: "lm" (the default) or "glmnet"
# Stan: "stan"
# Spark: "spark"
# keras: "keras"





# https://rviews.rstudio.com/2019/06/19/a-gentle-intro-to-tidymodels/
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




library(tidyverse)
library(tidymodels)
library(DBI)
library(RPostgreSQL)
library(parsnip)

mod_rf <- function(.x, .log, .trees = 2000, .mtry = 5, .mode = 'regression'){
  print(sprintf('RandomForest : %s', .log))
  mod <- rand_forest(trees = .trees, mtry = .mtry, mode = .mode) %>% 
    set_engine('ranger', seed = 1101) %>% 
    fit(so_qty ~ ., .x)
  
  return(mod)
}


mod_xg <- function(.x, .log, .trees = 2000, .mtry = 5, .mode = 'regression'){
  print(sprintf('XGBoost : %s', .log))
  mod <- boost_tree(mode = .mode, mtry = .mtry, trees = .trees) %>% 
    set_engine('xgboost') %>% 
    update() %>% 
    fit(so_qty ~ ., .x)
  
  return(mod)
}

#### main ####
aggr_tbl_s <- base_tbl %>% 
  mutate(actualyear = str_sub(actualweek, 1, 4),
         lnch_flag = if_else(actualweek_num == lnch_week_num, 1, 0)) %>% 
  select(-c(attb06, productgroup, lnch_week, actualweek, lnch_week_num)) %>% 
  group_by(orglevel1, orglevel2, countrygroup) %>% 
  nest()

rec <- aggr_tbl_s$data[[1]] %>% 
  recipe(so_qty ~ .) %>% 
  step_center(all_numeric(), -so_qty) %>% 
  step_scale(all_numeric(), -so_qty) %>% 
  step_dummy(all_nominal(), one_hot = T) %>% 
  prep()

# data split
split_data <- function(.x, .type){
  tryCatch(expr = {
    result <- .x %>% 
      {if(.type == 'test') dplyr::filter(., productnm == target_model) else dplyr::filter(., productnm != target_model)} %>% 
      bake(rec, .)  
    return(result)
  }, error = function(e){
    print(e)
    return(list())
  })
}

target_model <- 'S10 TTL'
aggr_tbl_s$data[[1]]$productnm %>% unique() 
aggr_tbl_s$data[[1]] %>% 
  dplyr::filter(productnm == target_model)

aggr_tbl_s_lv1 <- aggr_tbl_s %>% 
  mutate(train = map(data, ~split_data(.x, .type = 'train'))) %>% 
  mutate(test  = map(data, ~split_data(.x, .type = 'test')))



# fit model
fit <- aggr_tbl_s_lv1 %>% 
  mutate(.pred_rf = map2(data, countrygroup, mod_rf),
         .pred_xg = map2(data, countrygroup, mod_xg))

library(rsample)
library(parsnip)
split_data <- mtcars %>% initial_split(0.7)
train <- split_data %>% training()
test <- split_data %>% testing()

mod_xgb_ori <- xgboost::xgboost(data = train %>% select(-carb) %>% data.matrix(),
                                label = train$carb,
                                nrounds = 100,
                                objective = 'reg:linear')

(mod_xgb_par <- boost_tree(mode = "regression", mtry = 10, trees = 100) %>% 
    set_engine('xgboost') %>% 
    set_args(verbose = 1) %>%
    # set_args(params = list(eta = 0.6)) %>% 
    set_args(print_every_n = 10) %>% 
    # update() %>% 
    fit(carb ~ ., train)
)


predict(mod_xgb_ori, test %>% select(-carb) %>% data.matrix())
predict(mod_xgb_par, test %>% select(-carb)) %>% pull()