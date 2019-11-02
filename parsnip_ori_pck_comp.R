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