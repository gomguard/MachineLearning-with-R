###########################################################################
#
#    script_name : r_selenium.R
#    author      : Gomguard
#    created     : 2019-08-10 09:16:52
#    description : to scrap advs in web
#
###########################################################################

# how to install : https://ropensci.org/tutorials/rselenium_tutorial/

# Error 1 - install java
# Error in java_check() : 
#   PATH to JAVA not found. Please check JAVA is installed.
# to install java on ubuntu : https://m.blog.naver.com/opusk/220985259485

# Error 2 - 다시 실행 - sessionInfo 확인 후 실행하니까 됨
# Error in curl::curl_fetch_disk(url, x$path, handle = handle) : 
#   Unrecognized content encoding type. libcurl understands deflate, gzip content encodings.
#

# how to install docker : https://docs.docker.com/install/linux/docker-ce/ubuntu/
# to run rselenium there is 2 ways. 1 is rsdriver, 2 is by docker.
# rselenium : https://lareale.tistory.com/292

# 실행할 것 (in terminal)
# sudo docker run -p 4445:4444 selenium/standalone-chrome


install.packages("RSelenium")
install.packages('webshot')
webshot::install_phantomjs()

library(tidyverse)
library(RSelenium)
library(webshot)

rmt_dv <- RSelenium::remoteDriver(port = 4445L, browserName = 'chrome')
rmt_dv$open()
rmt_dv$navigate('https://www.daum.net')
test <- rmt_dv$findElement(using = 'xpath', value = '//*')

work_list <- read_csv('./screenshot_list.csv')

for (row_idx in 1:nrow(work_list)) {
  subsi <- work_list[[row_idx, 1]]
  country <- work_list[[row_idx, 2]]
  account <- work_list[[row_idx, 3]]
  url <- work_list[[row_idx, 4]]
  
  file_loc <- sprintf('./screenshot/%s_%s_%s.png', country, account, Sys.Date())
  
  webshot(url, file_loc, delay = 2)  
  
}

