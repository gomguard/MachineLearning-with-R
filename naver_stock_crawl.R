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
  html_nodes('.col_type1') %>%
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



##############################################
#### fund finder list ####
# rvest

url <- 'https://finance.naver.com//fund/fundFinderList.nhn?search=&sortOrder=&pageSize=10000'
base_html <- read_html(x = url, encoding = 'cp949')

target_list <- base_html%>% 
  html_nodes('.tbl_fund_info') %>% 
  html_nodes('a')

target_name <- base_html %>% 
  html_nodes('.tbl_fund_info') %>% 
  html_nodes('th') %>% 
  html_attr('title') %>% 
  as_tibble() %>% 
  drop_na()

url_list <- tibble(url = paste0(base_url, target_list %>% html_attr('href')))

url_list <- url_list %>% 
  dplyr::filter(str_detect(url, 'fundDetail.nhn')) %>% 
  bind_cols(target_name)

fund_master <- tibble()
result_stock_prop <- tibble()


for(idx in 1:nrow(url_list)){
print(idx)
# print(url_list[[idx, 1]])
detail_html <- url_list[[idx, 1]] %>% 
  read_html(encoding = 'cp949')

code <- detail_html %>% 
  html_nodes('.description') %>% 
  html_nodes('.code') %>% 
  html_text()

# print(code)
# print(url_list[[idx, 2]])
fund_master <- fund_master %>% 
  bind_rows(c(code = code, fund_name = url_list[[idx, 2]]))


stock_name <- detail_html %>% 
  html_nodes('.stock_area') %>% 
  html_nodes('.stock') %>% 
  html_text()

stock_name <- stock_name[stock_name != ""]
stock_prop <- detail_html %>% 
  html_nodes('.stock_area') %>% 
  html_nodes('.rate') %>% 
  html_text()
stock_prop <- stock_prop[stock_prop != ""]

# print(stock_name)
# print(stock_prop)
result_stock_prop <- result_stock_prop %>% 
  bind_rows(tibble(code, stock_name, stock_prop))

}


write_csv(fund_master, 'fund_master.csv')

wriwrite_csv()

write_csv(result_stock_prop, 'fund_detail.csv')

url <- 'https://finance.naver.com/sise/etf.nhn'
base_url <- 'https://finance.naver.com'


content <- read_html('naver_finance_etf.html')

url_list <- cbind(addr = paste0(base_url, content %>% 
  html_nodes('.ctg') %>% 
  html_nodes('a') %>% 
  html_attr('href'))
,
title = content %>% 
  html_nodes('.ctg') %>% 
  html_nodes('a') %>% 
  html_text())


result <- tibble()


# idx <- 4
for (idx in 1:nrow(url_list)) {

  print(idx)
  print(url_list[idx, 1])
  
result <- rbind(result,   
    
cbind(title = url_list[idx, 2], 
      code =
read_html(url_list[idx, 1], encoding='cp949') %>% 
  html_nodes('.code') %>% 
  html_text()
,
 name =
read_html(url_list[idx, 1], encoding='cp949') %>% 
  # html_nodes('.tb_type1_a') %>% 
  html_nodes('.ctg') %>% 
  # html_nodes('a') %>% 
  html_text() %>% 
  str_replace_all('(\\t|\\n)', '') %>% as.tibble() %>%
  .[-c(1), ]
  
,
rate =
read_html(url_list[idx, 1], encoding='cp949') %>% 
  # html_nodes('.tb_type1_a') %>% 
  html_nodes('.per') %>% 
  html_text() %>% str_replace_all('(\\t|\\n)', '') %>% as.tibble() %>% 
  .[-c(1,2), ] %>% dplyr::filter(value != "")
)
)
  
  
}

write_csv(result, 'etf_result.csv')


#### stock_code ####

b_tbl <- read_csv('./stock_code_master.csv')
b_tbl <- b_tbl %>% 
  mutate(temp_url = str_c('https://finance.naver.com/item/main.nhn?code=', 종목코드))

result <- b_tbl %>% 
  mutate(회사명_naver = map(temp_url, comp_name),
         회사_type = map(temp_url, comp_type))

comp_name <- function(.x){
  print(.x)
  base_html <- .x %>% 
    read_html(encoding = 'cp949') 
  
  comp_name <- base_html %>% 
    html_nodes('.wrap_company') %>% 
    html_node('a') %>% 
    html_text()
  
  return(comp_name)
}

comp_type <- function(.x){
  base_html <- .x %>% 
    read_html(encoding = 'cp949') 
  
  comp_type <- base_html %>% 
    html_nodes('.description') %>% 
    html_node('img') %>% 
    html_attr('alt')  
  
  return(comp_type)
}
  
result <- result %>% unnest() %>% 
  # dplyr::filter(회사명!= 회사명_naver) %>% 
  select(comp_name = 회사명_naver, stock_type = 회사_type, comp_code = 종목코드,
         comp_type = 업종, major = 주요제품, init_date = 상장일, owner = 대표자명, location = 지역,
         url = 홈페이지)

result %>% write_csv('./stock_code_master.csv')

#### etn ####
base_url <- 'https://finance.naver.com'
base_url_2 <- 'https://finance.naver.com/sise/etn.nhn'

content <- read_html('naver_etn.html', encoding = 'cp949') 

url_list <- bind_cols(
  url = content %>% 
    html_nodes('.ctg') %>% 
    html_nodes('a') %>% 
    html_attr('href'),
  etn_name = content %>% 
    html_nodes('.ctg') %>% 
    html_nodes('a') %>% 
    html_text()
  ) %>% 
  mutate(url = paste0(base_url, url)) %>% 
  mutate(url = str_replace_all(url, '(https:\\/\\/finance.naver.com\\/item\\/main\\.nhn\\?code=)', ''))

url_list %>% 
  select(code = url, etn_name) %>% 
  write_csv('naver_etn_code_master.csv')



read_csv('./stock_code_master.csv') %>% 
  View()
read_csv('./etn_code_master.csv') %>% 
  View()

