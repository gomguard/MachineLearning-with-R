#### File Info ###############################
##
##  File_name : sqlite_test.R
##  Purpose   : Sqlite Test Code Chunk
##  Author    : JH Hong
##  Created   : 2019-03-05
## 
#### Version Info ############################
##
##  R : 3.5.2 (2018-12-20)
##
#### History #################################
##
##
##############################################

library(DBI)
library(RSQLite)

# DBI, sqlite
# connect 먼저 만들기. 두번째 파라메터에는 file 경로
con <- DBI::dbConnect(RSQLite::SQLite(), './test.sqlite')

# connection 에서 볼 수 있는 테이블 명들
DBI::dbListTables(con)

#' dbWriteTable
#' 
#' @param conn connection infomation to DB
#' @param name the name of table in the DB
#' @param value the data that you want to insert in the table
DBI::dbWriteTable(conn = con, name = 'mtcars', value = mtcars)
DBI::dbWriteTable(con, 'iris', iris)

DBI::dbListTables(con)

#' dbListFields
#' 
#' get the column names of the selected table
#' @param conn connection infomation to DB
#' @param name the name of table in the DB
DBI::dbListFields(conn = con, name = 'iris')

#' dbReadTable
#' 
#' get the data of the table
#' @param conn connection infomation to DB
#' @param name the name of table in the DB
DBI::dbReadTable(con, 'iris')


#' dbSendQuery
#' 
#' get the SQLiteResult
#' @param conn connection information to DB
#' @param statement SQL Query
#' @return SQLiteResult object
res <- DBI::dbSendQuery(conn = con,
                        statement = 'select * from mtcars')

#' dbRemoveTable
#' 
#' remove the table from DB
#' @param conn connection information to DB
#' @param name the name of table in the DB
DBI::dbRemoveTable(con, 'mtcars')


#' dbFetch
#' 
#' Fetch the next n elements from the result and return them as a data.frame
#' @param res An object inheriting from DBIResult, created by dbSendQuery.
#' @param n maximum number of records to retrieve per fetch.
#' @return a data.frame
DBI::dbFetch(res = res, n = 10)

#' dbClearResult
#' 
#' Clear the object of SQLiteResult
#' @param res An object inheriting from DBIResult, created by dbSendQuery.
DBI::dbClearResult(res)

#' dbDisconnect
#' 
#' disconnect connection with DB
#' @param con A DBIConnection object, as returned by dbCoennect.
DBI::dbDisconnect(con)


dplyr::tbl(con, 'iris') %>% object.size()

dplyr::tbl(con, 'iris') %>%
  group_by(Species) %>% 
  summarise(sum_sepal = sum(Sepal.Length, na.rm = T)) %>%
  collect()



