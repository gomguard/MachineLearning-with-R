# https://mrchypark.github.io/getWebR/#22

# html 의 주소
# 1. tag(html)
# 2. css
# 3. id
# 4. xpath

# 1번 문제
# naver 금융 >> 코스피 지수
library(rvest)
read_html('https://finance.naver.com/', encoding = 'cp949') %>% 
  html_nodes(xpath = '//*[@id="content"]/div[1]/div[2]/div[1]/div[2]/div[1]/div[1]/a/span/span[1]')
  # html_nodes(css = '#content > div.article > div.section2 > div.section_stock_market > div.section_stock > div.kospi_area.group_quot.quot_opn > div.heading_area > a > span > span.num')
  # html_nodes(css = 'span.num')


# 2번 문제
# naver 코스피 전체 크롤링
# 주소 구조 찾기
base_url_list <- paste0('https://finance.naver.com/sise/sise_market_sum.nhn?&page=', idxs)

result <- tibble()
for (target_url in base_url_list) {
  content <- target_url %>% 
    read_html(encoding = 'cp949') %>% 
    html_nodes('#contentarea > div.box_type_l > table.type_2 > tbody > tr')
  
  result <- result %>% 
    bind_rows(
        map(content, function(.x){
          ## content 
          # {xml_nodeset (13)}
          # [1] <tr><td colspan="10" class="blank_08"></td></tr>\n
          # [2] <tr onmouseover="mouseOver(this)" onmouseout="mouseOut(this)">\n<td cla ...
          # [3] <tr onmouseover="mouseOver(this)" onmouseout="mouseOut(this)">\n<td cla ...
          ## .x
          .x %>% 
          ## html_nodes('td')
          # {xml_nodeset (13)}
          # [1] <td class="no">1551</td>
          # [2] <td><a href="/item/main.nhn?code=295890" class="tltle">ARIRANG 200로우볼</ ...
          # [3] <td class="number">8,960</td>
          # [4] <td class="number">\n\t\t\t\t<img src="https://ssl.pstatic.net/imgstock ...
          # [5] <td class="number">\n\t\t\t\t<span class="tah p11 nv01">\n\t\t\t\t-1.27 ...
            html_nodes('td') %>% 
          ## html_text()
          # [1] "1551"                                        
          # [2] "ARIRANG 200로우볼"                           
          # [3] "8,960"                                       
          # [4] "\n\t\t\t\t\n\t\t\t\t115\n\t\t\t\t\n\t\t\t"   
            html_text() %>% 
          ## str_replace_all('(N/A|\\\n|\\\t|,|%)', '')
          # [1] "1551"              "ARIRANG 200로우볼" "8960"             
          # [4] "115"               "-1.27"             "0" 
            str_replace_all('(N/A|\\\n|\\\t|,|%)', '') %>% 
          ## t()
          #      [,1]   [,2]                [,3]   [,4]  [,5]    [,6] [,7] [,8]  [,9]  
          # [1,] "1551" "ARIRANG 200로우볼" "8960" "115" "-1.27" "0"  "27" "300" "0.00"
            t() %>% 
          ## as_tibble()
          # A tibble: 1 x 13
          #   V1    V2    V3    V4    V5    V6    V7    V8    V9    V10   V11   V12   V13  
          # <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
          #   1 1551  ARIR… 8960  115   -1.27 0     27    300   0.00  50    ""    ""    "" 
            as_tibble()    
        }) %>% 
        bind_rows() %>% 
        filter(V1 != "")
    )
}

header <- target_url %>% 
  read_html(encoding = 'cp949') %>% 
  html_nodes(xpath = '//*[@id="contentarea"]/div[3]/table[1]/thead/tr/th') %>% 
  html_text()

result <- result %>% 
  mutate_at(vars(num_range('V', 3:13)), as.numeric) %>% 
  set_names(header)

# 3번 문제. Javascript 로 렌더링 되는 페이지
'https://finance.naver.com/sise/etf.nhn' %>% 
  read_html(encoding = 'cp949') %>% 
  html_nodes(xpath = '//*[@id="etfItemTable"]/tr[3]/td[1]')

library(RSelenium)
pjs$stop()
pjs <- wdman::phantomjs()

remdr <- remoteDriver(port = 4567L, browserName = 'phantomjs')
remdr$open()
url <- 'https://finance.naver.com/sise/etf.nhn'
remdr$navigate(url)
remdr$getTitle()
remdr$screenshot(display = T)

# a <- remdr$findElement(using = 'xpath', 
#                        value = '//*[@id="etfItemTable"]/tr[3]/td[1]')
# a$getElementText()

remdr$getPageSource() %>% 
  unlist() %>% 
  read_html() %>% 
  html_nodes(xpath = '//*[@id="etfItemTable"]/tr[3]/td[1]')


# 4번 문제. Click 이 필요한 Javascript 렌더링 페이지
remdr$screenshot(display = T)
links <- remdr$findElements(using = 'css',
                   value = '#contentarea > div.box_type_l > ul > li > a')

links[[1]]$clickElement()
remdr$screenshot(display = T)


# rvest
# httr
# api
# rselenium
# https://whatismyipaddress.com/

# avg vpn
library(rvest)
Sys.getenv('http_proxy')

read_html('http://naver.com') %>% 
  html_nodes(xpath = '//*[@id="time_square"]/div/div[2]/div/div/div/div/a/div/p[2]/em') %>% 
  # html_text()
  html_attr('class')


library(RSelenium)
pjs <- wdman::phantomjs()
pjs$stop()
remdr <- remoteDriver(port = 4567L, browserName = 'phantomjs')
remdr$open()
url <- 'http://naver.com'
remdr$navigate(url)
remdr$getTitle()
remdr$screenshot(display = T)

a <- remdr$findElement(using = 'xpath', 
                       value = '//*[@id="PM_ID_themelist"]/ul/li')
a$getStatus()
a$getClass()
a$getTitle()
a$getElementLocation()
a$getElementText()

remdr$findElements(using = 'class', 'rolling-panel')

b <- remdr$findElement(using = 'css', 
                  value = '#PM_ID_themelist > ul > li:nth-child(16) > a')
b$getTitle()
b$getElementText()

url <- 'http://daum.net'
remdr$navigate(url)
remdr$screenshot(display = T)

c <- remdr$findElement(using = 'xpath', 
                  value = '//*[@id="gnbServiceList"]/ul/li[8]/a')
c$getElementText()

d <- remdr$findElement(using = 'css',
                       value = '#gnbServiceList > ul > li:nth-child(8) > a')
d$getElementText()
d$getElementAttribute(attrName = 'href')


url <- 'https://finance.naver.com/sise/etf.nhn'
remdr$navigate(url)
remdr$screenshot(display = T)

e <- remdr$findElement(using = 'xpath',
                  value = '//*[@id="etfItemTable"]/tr[3]/td[1]/a')
e$getElementText()
e$getElementAttribute('href')


f <- remdr$findElements(using = 'css',
                   value = '#contentarea > div.box_type_l > ul > li > a')
f[[4]]$clickElement()
remdr$screenshot(display = T)

aa <- remdr$findElement(using = 'css',
                  value = '#etfItemTable')
dd <- aa$findChildElements(using = 'css', 
                     value = 'tr')
result <- map(dd, function(.x){
  .x$getElementText() 
}) %>% unlist()

aa$getElementAttribute('innerHTML')[[1]] %>%    
  read_html() %>% 
  html_nodes('td.ctg') %>% 
  html_nodes('a') %>% 
  html_attr('href')


remdr$screenshot(file = './class/finance_etf_04.png')


# proxy

Sys.getenv('http_proxy')

url_proxy <- 'http://sprint.com/'
url_proxy <- 'http://naver.com'

pjs$stop()
pjs <- wdman::phantomjs()
remdr <- remoteDriver(port = 4567L, browserName = 'phantomjs')

# Sys.setenv(http_proxy="http://89.187.181.123:3128")
Sys.setenv(http_proxy="")

remdr$open()
remdr$navigate(url)
remdr$screenshot(display = T)


webElem <- remdr$findElement(using = "xpath", "//*[@id='url']")
webElem$sendKeysToElement(list("www.sprint.com"))
webElem$screenshot(display = T)
