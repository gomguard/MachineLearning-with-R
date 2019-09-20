#### File Info ###############################
##
##  File_name : Linear Regression
##  Purpose   : 
##  Author    : GomGuard
##  Creted   : 2019-07-25
## 
#### Version Info ############################
##
##  R : 3.6.1 (2019-07-05)
##
#### History #################################
##
##
##############################################

library(tidyverse)

# 관측값  -  예측값  -  평균값
# |-----------편차------------|
# |--Error-----|--Regression--|
#   
# 회귀제곱평균(MSR) = 회귀제곱합(SSR:Sum of Square Regression)/자유도(DF)
# 잔차제곱평균(MSE) = 잔차제곱합(SSE:Sum of Square Error)/자유도(DF)
# 
# 자유도 : 통계량을 추정할 때 사용되는 데이터의 정보량, 정보의 손실 정도
# - n 개의 데이터가 갖는 정보량이 n 일 경우 평균의 경우 n 개의 데이터를 사용하여 추정.
# - 표본분산의 경우 평균값을 이미 알고 있어야 계산이 가능한데 평균값을 알고 있다는 것은 하나의 값을 몰라도
# - 된다는 의미기 때문에 n-1
# 
# SST(Sum of Square Total) = SSR + SSE
# R^2 (설명력 결정계수) = SSR/SST (전체 편차 중 Regression 이 설명할 수 있는 비율)
# 
# F-Value = MSR/MSE (Regression 과 Error 비율, 클수록 회귀가 설명 잘 되는 것)


fit <- lm(formula = Sepal.Length ~ Sepal.Width,
          data = iris)

anova(fit)
summary(fit)

fit2 <- lm(formula = Sepal.Length ~ . -Species,
           data = iris)
anova(fit2)
summary(fit2)
pairs(iris[, 1:4])

# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)   1.85600    0.25078   7.401 9.85e-12 ***
#   Sepal.Width   0.65084    0.06665   9.765  < 2e-16 ***
#   Petal.Length  0.70913    0.05672  12.502  < 2e-16 ***
#   Petal.Width  -0.55648    0.12755  -4.363 2.41e-05 ***

# 회귀분석의 4가지 기본 가정
# 1. 선형성 : 설명변수와 반응변수의 관계가 선형 관계를 가질 것
# ** 2. 독립성 : 설명변수와 다른 설명변수간에 상관관계가 적을 것
# 3. 잔차의 등분산성 : 잔차가 특정한 패턴을 보이지 않는다. ( 점점 커지거나 작아지거나 하지 않는다. )
# 4. 잔차의 정규성 : 잔차가 정규분포이다.

library(car)
vif(fit2)

# VIF(Variation Inflation Factor) 분산팽창지수 : 다른 변수에 의존하는 정도
# - 숫자 10 이상인 변수 중 큰 변수부터 제거

fit3 <- lm(formula = Sepal.Length ~ . -Species -Petal.Length, data = iris)
summary(fit3)

fit4 <- lm(formula = Sepal.Length ~.-Species-Petal.Width, data = iris)
summary(fit4)

cor(iris$Petal.Length, iris$Petal.Width)
cor(iris$Sepal.Length, iris$Sepal.Width)
cor(iris$Petal.Length, iris$Sepal.Width)
cor(iris$Petal.Width, iris$Sepal.Width)
# Petal.Width 와 Petal.Length 상관계수 0.96
# 독립성이 위배되는 회귀모델은 각 변수가 반응변수에 주는 영향을 왜곡

iris$Rest.Sepal.Width <- iris$Sepal.Length - 
  fit2$coefficients[['Petal.Length']] * iris$Petal.Length -
  fit2$coefficients[['Petal.Width']] * iris$Petal.Width

plot(iris)

# Sepal.Width 의 경우 Sepal.Length 와 선형성이 없어 보임에도 유의하다는 결과가 나온 이유는
# 다른 독립변수들의 영향력을 제거하고 나면 선형성이 생기기 때문이다.


## 1. 선형성 ----
# 변수 중 일부가 선형성을 만족하지 않을 경우 해결방법
# 1. 새로운 변수 추가
# 2. 로그나 루트 같은 변수 변환  <> 해석력을 떨어뜨림
# 3. 선형성 만족하지 않는 변수 제거
# 4. 일단 모델 만들고 변수선택법 시행

# 변수 선택법 : 변수간 영향이 심해 다중 공선성이 발생한 경우 변수 선택하는 방법
# 1. 전진선택법 : 모델에 하나씩 입력
# 2. 후진 선택법 : 모델에서 하나씩 제거
# 3. 단계적 방법 : 1, 2번 합한 방법

model_swiss <- lm(Fertility ~ . , data = swiss)
summary(model_swiss)
vif(model_swiss)
pairs(swiss)
model_both <- step(model_swiss, direction = 'both')
model_forward <- step(model_swiss, direction = 'forward')
model_back <- step(model_swiss, direction = 'backward')

# 두 개의 서로 다른 선형 회귀 모형의 성능을 비교할 때는 보통 다음과 같은 선택 기준을 사용한다.
# 
# 조정 결정 계수 (Adjusted determination coefficient) = Adj R^2
# AIC (Akaike Information Criterion) = -2log(Likelihood) + 2K
# BIC (Bayesian Information Criterion)
# AIC, BIC 작을 수록 모델 설명력 높음

## 2. 독립성 ----
# 단순에서는 해당하지 않음. 다중에서 중요

dt <- iris[, -5]
dt$Petal.Length1 <- dt$Petal.Length + round(rnorm(nrow(dt), 0.05, 0.05), 1)
dt$Petal.Length2 <- dt$Petal.Length + round(rnorm(nrow(dt), 0.05, 0.05), 1)

plot(dt)
dt_fit <- lm(Sepal.Length ~ ., dt)
vif(dt_fit)

summary(dt_fit)
step(dt_fit, direction = 'both') %>% 
  summary()

## 3. 등분산성 ----

dt <- iris[, -5]
set.seed(1)
dt$ydata <- c(round(rnorm(75, 1, 0.3), 1), round(rnorm(75, 10, 0.3), 1))
plot(dt)

mdl <- lm(ydata ~ .,dt)
summary(mdl)
plot(rstandard(mdl))

fit2 %>% rstandard() %>% hist()
fit2 %>% rstandard() %>% plot()
# 표준화 잔차가 패턴을 갖고 있다면 추가 변수가 필요하다는 것을 의미함


## 4. 정규성 ----
# 잔차가 정규성을 만족하는가

dt <- iris[, -5]
dt$ydata <- c(round(rnorm(20, 1, 0.3), 1), round(rnorm(30, 5, 0.3), 1), round(rnorm(100, 7, 1), 1))
plot(dt)
mdl <- lm(ydata ~ ., dt)
summary(mdl)

mdl %>% rstandard() %>% hist()
mdl %>% rstandard() %>% plot()

# 정규성 검증방법 Shapiro-Wilk Test : 표본이 정규분포로부터 추출된 것인지 테스트 
shapiro.test(rstandard(mdl))
# 귀무가설 : 정규분포다
# 대립가설 : 정규분포 아니다
# p-value 0.0002 < 0.05 -> 귀무가설 기각

F 분포, T 검정 다시 명확히

# 자유도
# https://m.blog.naver.com/PostView.nhn?blogId=jindog2929&logNo=10183165564&proxyReferer=https%3A%2F%2Fwww.google.com%2F
# 선형회귀
# https://kkokkilkon.tistory.com/77
# https://kkokkilkon.tistory.com/175
# 변수 선택법
# https://nittaku.tistory.com/476
# AIC
# https://chukycheese.github.io/statistics/aic/
# 다중공선성 & VIF
# https://datascienceschool.net/view-notebook/36176e580d124612a376cf29872cd2f0/
