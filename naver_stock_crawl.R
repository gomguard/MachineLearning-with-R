###########################################################################
#
#    script_name : naver_stock_crawl.R
#    author      : Gomguard
#    created     : 2019-11-08 17:12:56
#    description : desc
#
###########################################################################

library(tidyverse)
library(rvest)

base_url <- 'https://finance.naver.com'

target_list <- read_html(x = paste0(base_url, '/sise/theme.nhn'), encoding = 'cp949') %>% 
  html_nodes('.col_type1') %>% 
  html_nodes('a')


url_list <- tibble(url = paste0(base_url, target_list %>% html_attr('href')),
                       theme_name = target_list %>% html_text()) %>% .[-1,]


result_tbl <- url_list %>% 
  mutate(comp_label = map(url, function(.x){
    print(.x)
    comp_grp <- .x %>% 
      read_html(encoding = 'cp949') %>% 
      html_nodes('.type_5 tr') %>% 
      html_node('td') %>% 
      html_text() %>% 
      str_replace_all(' \\*', '')
    
    comp_grp <- comp_grp[!is.na(comp_grp) & comp_grp != ""]  
    
  })) %>% 
  unnest() %>% 
  select(theme_name, comp_label, url)

result_tbl  
