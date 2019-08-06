###########################################################################
#
#    script_name : 4.DecisionTree.R
#    author      : Gomguard
#    created     : 2019-08-04 18:43:50
#    description : DecisionTree & Rule Learner
#
###########################################################################

library(tidyverse)

# 의사결정 트리
# 장점 : 
# - 사람이 읽을 수 있는 형식으로 출력

# 사용처 :
# - 신청자 거절 기준이 명확히 문서화되고 편향되지 않은 신용평가모델
# - [경영진 또는 광고 대행사와 공유될] 고객 만족이나 고객 이탈과 같은 고객 행동 마케팅 연구
# - 누군가에게 보고 되어야 할 경우 

# 주의 :
# 데이터의 대부분이 명목변수이며 각 범주가 여러개로 이루어져있을 경우 트리가 너무 복잡해지는 결과가 발생
# 축-평행 분할을 사용하기 때문에 복잡한 결정경계를 형성할 수 없음

# 관련 패키지 : c5.0, c4.5, j48

# Entropy(s) = sigma_i~c( - p_i * log_2(p_i) ) # c - 항목의 개수

curve( -x * log2(x) - (1-x) * log2(1-x), col = 'red', xlab = 'x', ylab = 'Entropy', lwd = 4)

# 정보획득량 = 엔트로피의 차
# 정보획득량 이외에도 지니계수, 카이제곱 통계, 이득비율 등을 기준으로 사용할 수 있음
# An Empirical Comparison of Selection Measures for Decision-Tree Induction - Mingers J
# https://link.springer.com/article/10.1007/BF00116837

# 가지치기 Pruning

credit <- read_csv('./ml_R_bread/Chapter 05/credit.csv') %>% 
  mutate_if(is.character, factor)
credit %>% 
  summary()

# train <> test split
set.seed(190804)

sampled_credit <- credit %>% sample_frac(1)
train_credit <- sampled_credit[1:(nrow(sampled_credit)*0.9), ]
test_credit <- sampled_credit[(nrow(sampled_credit)*0.9 + 1):nrow(sampled_credit), ]

sampled_credit %>% 
  dplyr::filter(row_number() <= nrow(.)*0.7)

sampled_credit %>% 
  dplyr::filter(row_number() >  nrow(.)*0.7)


credit %>% 
  dplyr::select(default)

train_credit$default %>% 
  table() %>% 
  prop.table()

test_credit$default %>% 
  table() %>% 
  prop.table()



install.packages('C50')
library(C50)

# tibble 못읽음 에러남
credit_model <- C5.0(x = train_credit[-17] %>% as.data.frame(), y = train_credit$default)

summary(credit_model)


credit_pred <- predict(credit_model, test_credit[-17] %>% as.data.frame())

CrossTable(x = test_credit$default, y = credit_pred,
           prop.chisq = F, prop.c = F, prop.r = F)

# Adaboosting
# Boosting: Foundations and Algorithms - MIT
# https://doc.lagout.org/science/0_Computer%20Science/2_Algorithms/Boosting_%20Foundations%20and%20Algorithms%20%5BSchapire%20%26%20Freund%202012-05-18%5D.pdf


credit_boost_10 <- C5.0(x = train_credit[-17] %>% as.data.frame(), y = train_credit$default, trials = 10)
credit_pred_10 <- predict(credit_boost_10, test_credit[-17] %>% as.data.frame())

CrossTable(x = test_credit$default, y = credit_pred_10,
           prop.chisq = F, prop.c = F, prop.r = F)
