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