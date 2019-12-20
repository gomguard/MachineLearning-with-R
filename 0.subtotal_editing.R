###########################################################################
#
#    script_name : 0.subtotal.R
#    author      : Gomguard
#    created     : 2019-10-26 08:02:10
#    description : desc
#
########################################################################### 

library(tidyverse)
tt <- Titanic %>% as_tibble()

subto <- function(.tbl, .summary_var, ...){
  print(.summary_var)
  print(class(.summary_var))
  
  group_var <- enquos(..., .named = TRUE)
  summary_var <- enquo(.summary_var)
  base_grp_len <- group_var %>% length()
  
  print(summary_var)
  print(summary_var %>% class())

  summary_nm <- as_label(summary_var)
  summary_nm <- paste0("sum_", summary_nm)
  
  
  print(rlang::qq_show(summarise(!!summary_nm := sum(!!summary_var))))
  result <- temp <- .tbl %>% 
    group_by(!!!group_var) %>% 
    summarise(!!summary_nm := sum(!!summary_var))
  
  flag = TRUE
  
  while(flag){
    grp_len <- temp %>% 
      group_vars() %>% 
      length()
    
    if(grp_len == 0){
      flag = FALSE
    }
    print(temp)
    print(summary_nm)
    print(summary_var)
    print(rlang::qq_show(!!summary_nm := sum(enquo(!!summary_nm))))
    temp <- temp %>% 
      summarise(!!summary_nm := sum(enquo(sym(!!summary_nm))))
    
    result <- bind_rows(result, temp)
    
  }
  
  result <- result %>% 
    arrange(...) %>% 
    map_df(~str_replace_na(.x, 'Total'))
  
  return(result)  
}

res <- subto(tt, n, Class, Sex, Age) 
res <- subto(iris, Sepal.Length, Species)
res %>% 
  arrange(Class) %>% 
  map_df(~str_replace_na(.x, 'Total')
  )

  
  
  
if (grp_len == 0) {
  flag = FALSE
}

  

