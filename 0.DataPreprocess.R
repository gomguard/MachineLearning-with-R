###########################################################################
#
#    script_name : 0.DataPreprocess.R
#    author      : Gomguard
#    created     : 2019-08-04 12:50:48
#    description : To preprocess Data
#
###########################################################################

library(tidyverse)


# https://rfriend.tistory.com/52  - 데이터 정규화
# 0-1 표준화
1:50 %>% 
  normalize()
seq(0,50,5) %>% 
  normalize()

# z-분포 표쥰화
scale(1:50)


# 정규분포화
library(UsingR)

cfb$INCOME %>% 
  summary()

(cfb$INCOME + 1) %>%
  log() %>% 
  hist(., breaks = 500, freq = T)

cfb$INCOME %>% 
  sqrt() %>% 
  hist(., breaks = 500, freq = T)

par( mfrow = c(1,3) )
qqnorm(cfb$INCOME, main = 'Q-Q plot of Income')
qqline(cfb$INCOME)

qqnorm((cfb$INCOME + 1) %>% log(), main = 'Q-Q plot of Income log')
qqline((cfb$INCOME + 1) %>% log())

cfb$INCOME %>% 
  sqrt() %>% 
  qqnorm(main = 'Q-Q plot of Income sqrt')
cfb$INCOME %>% 
  sqrt() %>% 
  qqline()



# 범주화

