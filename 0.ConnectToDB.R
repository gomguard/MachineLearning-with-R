###########################################################################
#
#    script_name : 0.ConnectToDB.R
#    author      : Gomguard
#    created     : 2019-08-07 22:50:02
#    description : How to Connect to DB
#
###########################################################################

library(tidyverse)
library(DBI)
library(dbplyr)

# Mysql
library(RMySQL)
con_mysql <- dbConnect(MySQL(),
  user = getOption("database_userid"),
  password = getOption("database_password"),
  host = getOption("database.address"),
  port = 3306,
  dbname = "kaggle",
  client.flag = CLIENT_MULTI_RESULTS
)

dbGetQuery(con_mysql, "set names utf8")
table <- tbl(con_mysql, "userdb")

con_mysql <- dbConnect(MariaDB(),
                       host = '218.209.7.185',
                       user = 'student',
                       password = '1QAZxsw@',
                       port = 3306,
                       dbname = 'class_01'
)

dbWriteTable(con_mysql, 'mtcars', mtcars, row.names = F)
tbl(con_mysql, 'iris') %>% 
  select(Species) %>% 
  mutate(a = 1) %>% 
  mutate(b = 2) %>% 
  collect()

tbl(con_mysql, 'mtcars')

# Postgresql
library(RPostgreSQL)

con_post <- DBI::dbConnect(odbc::odbc(),
  drv = dbDriver("PostgreSQL"),
  host = getOption("database.address"),
  dbname = "ml_db",
  user = rstudioapi::askForPassword("Database user"),
  password = rstudioapi::askForPassword("Database password"),
  port = 5432
)
tbl(con_post, "test")
tbl(con_post, in_schema("kaggle", "iris"))

# to adjust Schema
dbWriteTable(con_post, c("kaggle", "iris"), iris)


# https://yujuwon.tistory.com/entry/MYSQL-LOAD-DATA-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0
# local-infile
# 외부 파일 올리기 안될 


# Oracle
# 필요 파일 : jdk, ojdbc
# jdk - https://openjdk.java.net/
# ojdbc - repository 내에 업로드 해둠

Sys.setenv(JAVA_HOME='C:/Program Files/JAVA/jdk-14.0.1/')
library(rJava)
library(DBI)
library(RJDBC)

# zip_path <- "C:/Users/knholic/Downloads/DBI_1.1.0.zip"
# install.packages(zip_path, repos = NULL, type="source")

#driver
drv <- JDBC("oracle.jdbc.driver.OracleDriver",
            "C:\\oraclexe\\app\\oracle\\product\\11.2.0\\server\\jdbc\\lib\\ojdbc6.jar")

##DB 연동
#connection 객체 생성
conn <- dbConnect(drv, "jdbc:oracle:thin:@//(아이피):(포트번호)/(SID)", "(접속 아이디)", "(접속 비밀번호)")


.libPaths()
sql_translate_env.JDBCConnection <- dbplyr:::sql_translate_env.Oracle
sql_select.JDBCConnection <- dbplyr:::sql_select.Oracle
sql_subquery.JDBCConnection <- dbplyr:::sql_subquery.Oracle
