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

scrape_data <- function(.x){
  print(.x)
  comp_grp <- .x %>% 
    read_html(encoding = 'cp949') %>% 
    html_nodes('.type_5 tr') %>% 
    html_node('td') %>% 
    html_text() %>% 
    str_replace_all(' \\*', '')
  
  comp_grp <- comp_grp[!is.na(comp_grp) & comp_grp != ""]  
  
}

base_url <- 'https://finance.naver.com'

#### theme ####
target_list <- read_html(x = paste0(base_url, '/sise/theme.nhn'), encoding = 'cp949') %>% 
  html_nodes('.type_1') %>%
  html_nodes('a')


url_list <- tibble(url = paste0(base_url, target_list %>% html_attr('href')),
                       type = target_list %>% html_text()) %>% .[-1,]


result_tbl_theme <- url_list %>% 
  mutate(comp_label = map(url, scrape_data)) %>% 
  unnest() %>% 
  select(type, comp_label, url)

# result_tbl %>% 
#   write_csv('naver_stock_info.csv')


#### work type ####

target_list <- read_html(x = paste0(base_url, '/sise/sise_group.nhn?type=upjong'), encoding = 'cp949') %>% 
  html_nodes('.type_1') %>% 
  html_nodes('a')


url_list <- tibble(url = paste0(base_url, target_list %>% html_attr('href')),
                   type = target_list %>% html_text())


result_tbl_upjong <- url_list %>% 
  mutate(comp_label = map(url, scrape_data)) %>% 
  unnest() %>% 
  select(type, comp_label, url)


#### group ####

target_list <- read_html(x = paste0(base_url, '/sise/sise_group.nhn?type=group'), encoding = 'cp949') %>% 
  html_nodes('.type_1') %>% 
  html_nodes('a')


url_list <- tibble(url = paste0(base_url, target_list %>% html_attr('href')),
                   type = target_list %>% html_text())


result_tbl_group <- url_list %>% 
  mutate(comp_label = map(url, scrape_data)) %>% 
  unnest() %>% 
  select(type, comp_label, url)

result <- bind_rows(
  result_tbl_theme %>% 
    mutate(class = '테마별'),
  result_tbl_upjong %>% 
    mutate(class = '업종별'),
  result_tbl_group %>% 
    mutate(class = '그룹별')
) %>% 
  select(class, type, comp_label)

result %>% write_csv('result_naver_stock.csv')
result %>% count(class)


result %>% View()
