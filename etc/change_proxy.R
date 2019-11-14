# https://stackoverflow.com/questions/6467277/proxy-setting-for-r

On Mac OS, I found the best solution here. Quoting the author, two simple steps are:

1) Open Terminal and do the following:

export http_proxy=http://staff-proxy.ul.ie:8080
export HTTP_PROXY=http://staff-proxy.ul.ie:8080
2) Run R and do the following:

Sys.setenv(http_proxy="http://staff-proxy.ul.ie:8080")
double-check this with:

Sys.getenv("http_proxy")
I am behind university proxy, and this solution worked perfectly. The major issue is to export the items in Terminal before running R, both in upper- and lower-case.


###############################

library(httr)
library(rvest)
Sys.setenv(http_proxy =  "http://168.219.61.252:8080/")
Sys.getenv('http_proxy')
R.home("etc")
file.exists(file.path(R.home("etc"), "curl-ca-bundle.crt"))

curl:::.onLoad()
[1] "C:/PROGRA~1/R/R-36~1.0/etc/curl-ca-bundle.crt"
"C:\Program Files\R\R-3.6.0\etc\curl-ca-bundle.crt"

read_html('http://www.naver.com')
