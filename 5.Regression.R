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
