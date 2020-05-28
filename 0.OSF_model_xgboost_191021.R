#######################################################################
# script_name : 191021. OSF_model_xgboost.R
# author      : gomguard
# created     : 2019-10-21
# desc        : description of this script
#######################################################################
ad5a63542acc1dae8de141222a1c315ad913ece1
library(rsample)
library(recipes)
library(tidyverse)
library(DBI)
library(RPostgreSQL)

conn <- DBI::dbConnect(
  odbc::odbc(),
  drv = dbDriver("PostgreSQL"),
  host = HOST,
  port = PORT,
  dbname = DB,
  user = USER,
  password = PWD
)


get_data_con <- function(scheme = "TEST", tb_name = "DIR_FOTA_NEW", n = Inf, glimp = F){
  print('getting data connection')
  cat('scheme : ', scheme, ', tb_name : ', tb_name, ', n : ', n, '\n')
  
  rtn_tbl <- dplyr::tbl(conn, dbplyr::in_schema(toupper(scheme), toupper(tb_name)))
  
  return(rtn_tbl)
}

smf <- function(data){
  data %>% 
    lapply(., function(x){
      if (class(x) == 'character') {
        x %>% as_factor() %>% return()  
      } else{
        return(x)
      }
    }) %>% as_tibble() %>% summary
}

#### main ####
base_tbl_con <- get_data_con('new_osf','global_daily_fota_sell_out_with_master')
base_tbl <- base_tbl_con %>% 
  select(orglevel2, countrygroup, actualmonth, actualweek_num, camera, storage, item_type, mkt_name, display_size, lnch_week_num, so_qty) %>%
  # feature engineering
  mutate(storage = storage %>%
           replace('GB', '') %>%
           replace('TB', ''),
         camera  = replace(camera, 'M', ''),
         lnch_flag = if_else(lnch_week_num == actualweek_num, 1, 0)) %>%
  dplyr::filter(orglevel2 == 'SENZ') %>% 
  collect() %>% 
  mutate(
    camera = as.numeric(camera),
    storage = as.numeric(storage),
    display_size = as.numeric(display_size)
  ) %>% 
  select(-c(orglevel2, lnch_week_num, countrygroup)) 
  
base_tbl %>% 
  glimpse()
  
# type casting
base_recipe <- base_tbl %>% 
  recipe(so_qty ~ .)

base_recipe %>% 
  summary()

rec <- base_recipe %>% 
  step_scale(all_numeric()) %>% 
  step_center(all_numeric()) %>%
  step_corr(all_numeric(), - all_outcomes(), threshold = 0.5) %>%
  step_dummy(all_nominal())

prep_recipe <- rec %>%
  prep()

b_tbl_split <- base_tbl %>% 
  initial_split(0.7)

cvt_train <- bake(prep_recipe, 
                  b_tbl_split %>% 
                    training())
cvt_test <- bake(prep_recipe, 
                 b_tbl_split %>% 
                   testing())

car <- function(method, recipe, rsample, data){
  # https://topepo.github.io/caret/model-training-and-tuning.html
  car <- caret::train(recipe,
                      data, 
                      method = method,
                      trControl = caret::trainControl(index = rsample$index,
                                                      indexOut = rsample$indexOut,
                                                      method = 'cv',
                                                      verboseIter = T,
                                                      savePredictions = T,
                                                      search = 'random'),
                      metric = 'RMSE',
                      tuneLength = 100
                      )
  return(car)
  # verboseIter: A logical for printing a training log.
}

rs <- vfold_cv(base_tbl, v = 5)
pretty.vfold_cv(rs)
rs_caret = rsample2caret(rs)

# lm : Linear Regression
# rpart::rpart : Decision Tree
# cubist::cubist : rule-based tree
# parRF:: : random forest
# earth : MARS(Multivariate Adaptive Regression Splines and Fast MARS)

df_m = tibble( methods = c('lm'
                           # , 'rpart',
                           # 'cubist', 
                           # 'parRF', 
                           # 'earth', 
                           # 'xgbTree'
                           ) 
               )
df_m = df_m %>%
  mutate( c = map(methods, car, rec, rs_caret, base_tbl ) )

library(skimr)
library(rsample)
library(recipes)

base_tbl %>% 
  skim()

b_tbl_split <- base_tbl %>% 
  rsample::initial_split(0.7)

b_tbl_split %>% 
  training()
b_tbl_split %>% 
  testing()

base_tbl %>% 
  recipe(so_qty ~ .) %>% 
  summary()

b_recipe <- base_tbl %>% 
  recipe(so_qty ~ .) %>% 
  step_corr(all_numeric(), threshold = 0.5) %>%      # Removes variables that have large absolute correlations with other variables
  step_center(all_numeric(), -all_outcomes()) %>%    # Normalizes numeric data to have a mean of zero
  step_scale(all_numeric(), -all_outcomes()) %>%     # Normalizes numeric data to have a standard deviation of one
  # step_string2factor(all_nominal(), -all_outcomes()) %>% 
  step_dummy(all_nominal(), one_hot = T)

prep(b_recipe, data = base_tbl) %>% 
  juice()
