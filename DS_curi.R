###########################################################################
#
#    script_name : DS_curi.R
#    author      : Gomguard
#    created     : 2020-05-25 00:13:49
#    description : desc
#
###########################################################################

# how to check if specific package contains functions
# grep("with$", ls("package:dplyr"), value = TRUE)

데이터 사이언스 관련 정리
언어
-	R 기본 & 프로그래밍
- 기본서
# R for Data Science - https://r4ds.had.co.nz/
# R for DS Solution - https://jrnold.github.io/r4ds-exercise-solutions/ 
# ggplot2: Elegant Graphics for Data Analysis - https://ggplot2-book.org/
# R Packages - https://r-pkgs.org/
# Advanced R - https://adv-r.hadley.nz/
# Statistical Inference via Data Science - https://moderndive.com/index.html
# Feature Engineering and Selection - https://bookdown.org/max/FES/
# Text Mining with R - https://www.tidytextmining.com/

-	Tidyverse 등 패키지 설명
  - Tidyr
  - Dplyr
    - select
      # https://www.tidyverse.org/blog/2018/06/dplyr-0.7.5/
    - relocate
    - rename
    - rename_with
      # https://www.tidyverse.org/blog/2020/03/dplyr-1-0-0-select-rename-relocate/
    - rowwise
      # https://dplyr.tidyverse.org/dev/articles/rowwise.html
    - mutate
    - group_by
    - group_keys
    - group_modify (eda용)
      # https://www.tidyverse.org/blog/2019/06/dplyr-0-8-2/
    - group_nest
    - group_split
    - group_map
      # https://www.tidyverse.org/blog/2019/02/dplyr-0-8-0/
      # https://www.tidyverse.org/blog/2018/12/dplyr-0-8-0-release-candidate/
    - summarise
    - filter
    - arrange
    - row_mutation
      - rows_update
      - rows_patch
      - rows_insert
      - rows_upsert
      - rows_delete
      # https://www.tidyverse.org/blog/2020/05/dplyr-1-0-0-last-minute-additions/#row-mutation
    - across
      # https://www.tidyverse.org/blog/2020/04/dplyr-1-0-0-colwise/
    - join
    - aggregate functions
      - sum
      - n
      - ...
    - bind_cols, bind_rows
  - tidyselect
    - any_of, all_of
    - starts_with, ends_with
    - contains
  - Magrittr
  - Readr
  - Tibble
    - enframe = as_tibble
    - .namerepair
    - glimpse
      # https://www.tidyverse.org/blog/2019/01/tibble-2.0.1/
  - Ggplot2
    - geom_bar
    - geom_histogram = geom_freqpoly
    - cut_width
  - Stringr
  - Purr
  - Lubridate
  - Skimr
  - Recipes
  - Forcats
  - DBI
  - Httr
  - Rvest
  - Xml2
  - Jsonlite
  - Glue
    # https://www.tidyverse.org/blog/2020/02/glue-strings-and-tidy-eval/
  - Odbc
  - Dbplyr
  - Styler
  - Rsample
  - Parsnip
  - Stats
  - base
  - selenium
  - phantomjs
  - arules  
	
-	Sql
  - 기본 sql
  - R 과 커넥팅 방법
    # https://rstudio.com/resources/rstudioconf-2020/bridging-the-gap-between-sql-and-r/

- Database


기타 프로그램
  -	Db IDE
  -	R IDE, rstudio
  -	Python IDE
  -	…

기초 통계
  -	평균, 분산, 표준편차
  - 모평균
  - 중앙값, mode
  - T 검정, T 분포
  - https://www.youtube.com/playlist?list=PLaFfQroTgZnyxGm6hz4lWLaMbslG0KDSG
  
분석 알고리즘
-	supervised
  - Linear regression
    - Linearity
    - 다중공선성
  - Logistic
  - Robust
  - Ridge
  - Lasso
  - Elasticnet
  - Svm
  - Tree base
    - decision tree
    - bagging : random forest
    - boosting : xgb, lightgbm
  - Neural net
    - dnn
    - cnn
    - rnn : lstm
  - word2vec
  - auto encoder
  - gan

-	범주화
	- K-means, median, ….
	- Dbscan
	- Hierarchical 
	
-	룰베이스
	- Association rules
	- apriori

- time series
  - arima
  - gam
  -

- tf-idf
  
- nlp
  
모델 검증 및 평가 방법
- 데이터 선택 방법
  - hold-out
  - k-fold
- 데이터 평가
  - 정확도 ~ f1 score
  - roc, auc

결측치 제거 방법
  - amelia
  - https://rpubs.com/vsagar19/missing_value_treatment
  
Web
# 웹 개발환경 이해
# https://www.yamestyle.com/201?category=529583
-	Encoding
-	Network base
  - proxy
  - domain
  - port
  - 공유기
  - ddns
  - ip
- html
- css
- js
- xpath

Etc
-	Scheduler
-	Git
-	Github (action, …..)
- regexp
- 데이터 관련 직군 소개	
- R 주석 및 코딩 가이드
- SQL 코딩 가이드


실전 예제용 강의
-	특정 사이트 크롤링 및 DB 적재, 스케쥴링
-	샤이니를 통한 대쉬보드 제작
-	캐글 데이터 분석
	EDA
	상품 추천
	가격, 수요 예측
	

# It doesn't work
# read all csv in the same folder
# tibble(path = dir(pattern = "\\.csv$")) %>% 
#   rowwise() %>% 
#   summarise(read_csv(path))

iris %>% 
  # dplyr::top_n(n = 10, Petal.Width)
  top_frac(n = 0.5, Petal.Width)

mtcars %>% 
  group_by(cyl) %>% 
  group_split()

mtcars %>% 
  group_by(cyl, carb) %>% 
  group_modify(~ head(.x, 1))

# group_by, nest
mtcars %>% 
  group_by(cyl) %>% 
  nest()

mtcars %>% 
  group_nest(cyl)


