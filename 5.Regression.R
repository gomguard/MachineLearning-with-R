###########################################################################
#
#    script_name : 5.Regression.R
#    author      : Gomguard
#    created     : 2019-09-07 00:51:25
#    description : 
#
###########################################################################


# 전제가 사실인지 거짓인지 판단하는 가설검정에도 회귀 사용 가능하지만 머신러닝과 다름 

# y = ax + b
# x - 독립변수, y - 종속 변수

# 독립변수 - 1 -> 단순 선형 회귀
# 독립변수 - 2 -> 다중 선형 회귀

# 로지스틱 회귀 -> 이진 범주형 결과
# 다항 로지스틱 회귀 -> 범주형 결과
# (multinomial logistic regression)
# 푸아송 회귀 -> 정수 도수 데이터 모델링 (?)

launch <- read.csv('./ml_R_bread/Chapter 06/challenger.csv')
launch %>% 
  ggplot() +
  geom_point(aes(x = temperature, y = distress_ct))

b <- cov(launch$temperature, launch$distress_ct) /
  var(launch$temperature)
a <- mean(launch$distress_ct) - b * mean(launch$temperature)

# 다중 선형회귀
# 단순 선형회귀의 확장, 선형 방ㅇ정식의 예측 오차 최소화하는 계수값 찾는 것
# y = ax + b
# -> y = a1x1 + a2x2 + b + e

reg <- function(x,y){
  x <- as.matrix(x)
  x <- cbind(Intercept = 1, x)
  b <- solve(t(x) %*% x) %*% t(x) %*% y
  colnames(b) <- 'estimate'
  print(b)
}

reg(y = launch$distress_ct, x = launch[2])
reg(y = launch$distress_ct, x = launch[2:4])

insurance <- read.csv('./ml_R_bread/Chapter 06/insurance.csv')
insurance %>% 
  glimpse()

insurance %>% 
  summary()

lm(expenses ~ ., data = insurance)


# 데이터 종류에 따른 분석 방법
# https://rpubs.com/jmhome/datatype_analysis

# 변수의 종류와 통계 기법
# https://m.blog.naver.com/libido1014/120113775017


library(psych)
pairs.panels(insurance[c('age', 'bmi', 'children', 'expenses')])

# 타원 객체 - 상관관계 타원형 - 늘어질 수록 관계 강함
# 곡선 - 뢰스 곡선 - 추세선 - age:children 같은 경우는 볼만함

ins_model <- lm(expenses ~ age + sex + smoker + children + bmi + region,
                data = insurance)

# how to save and load linear model 
ins_model <- lm(expenses ~ ., data = insurance)
saveRDS(ins_model, './lm_test.rds')
aaa <- readRDS('./lm_test.rds')

# 모델에서 각각의 계수는 다른 값들이 고정됐다고 가정했을 때를 기준으로 계산된다.
# 그렇기 때문에 독립성이 중요함
# 만약 각각이 독립적이지 않다면 한 값이 변화할 때 다른 값이 고정되는 것이 불가능하기 때문에 잘못된 값을 도출할 수 있음

summary(ins_model)

# Part 1. Residuals : 실제값 - 예측값
ins_model$residuals %>% 
  plot()

# Part 2. p-value : 추정계수가 실제 0일 확률 추정치
# 작을 경우 실제 계수가 0이 아닐 가능성이 높다는 것이며 특징이 종속 변수와 관계 없을 가능성이 매우 낮다는 것을 의미
# 유의 수준 보다 낮은 p value 는 통계적으로 유의한 것으로 간주 (statistically significant)
# 유의 수준 : 0.05



