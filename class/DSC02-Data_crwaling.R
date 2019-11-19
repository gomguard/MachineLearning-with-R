# https://mrchypark.github.io/getWebR/#22

# rvest
# httr
# api
# rselenium

library(rvest)

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
