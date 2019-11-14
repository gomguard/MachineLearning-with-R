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
