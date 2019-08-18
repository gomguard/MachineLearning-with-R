library(jsonlite)
library(tidyverse)

test_json <- 
'[
  {
    "Sepal.Length":5.1,
    "Sepal.Width":3.5,
    "Petal.Length":1.4,
    "Petal.Width":0.2,
    "Species":"setosa"
  },
  {
    "Sepal.Length":4.9,
    "Sepal.Width":3,
    "Petal.Length":1.4,
    "Petal.Width":0.2,
    "Species":"setosa"
  },
  {
    "Sepal.Length":4.7,
    "Sepal.Width":3.2,
    "Petal.Length":1.3,
    "Petal.Width":0.2,
    "Species":"setosa"
  }
]'

# create json example from dataframe
test_json <- iris[1:3,] %>% jsonlite::toJSON()

# json to dataframe
test_json %>% 
  jsonlite::fromJSON()

# jsonlite::base64
serialize(object = '가', NULL) %>% base64_enc()

# raw class and base64 encoding
# charToRaw() : ascii = ansi code -> EUC_KR / cp949
'가' %>% charToRaw() %>% base64_enc() %>%
  base64_dec() %>% rawToChar()

# a = 61 hexadecimal in cp949
# 가 =  [ b0 a1 ] in cp949

# raw class : 8bit 
# base64 : 7bit - 8bit 이진 데이터를 7bit ascii 문자로 변경하는 인코딩방식