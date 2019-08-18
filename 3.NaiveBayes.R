###########################################################################
#
#    script_name : 3.NaiveBayes.R
#    author      : Gomguard
#    created     : 2019-08-04 13:21:55
#    description : NaiveBayes Classification
#
###########################################################################

library(tidyverse)
# Naive Bayes
# 18세기 수학자 Thomas Bayes 의 연구에서 유래
# 사건의 확률과 추가정보를 고려했을 때 확률이 어떻게 바뀌어야하는지 설명하는 기본 원칙

# 결과에 대한 전체확률을 추정하기 위해 동시에 여러 속성정보를 고려해야만 하는 문제에 가장 적합

# 기본 idea : 확률의 이론은 사건에대한 우도는 복수 시행에서 즉시 이용할 수 있는 증거를 기반으로해서 추정해야만 한다.

# 장점 : 
# - 간단하고 매우 효율적
# - 잡음과 누락 데이터 잘 처리
# - 예측 위한 추정확률을 얻기 쉬움

# 단점 :
# - 수치형 데이터에는 적절하지 않을 수 있음
# - 모든 ㅌ특징이 동등하게 중요하고 독립이라는 가정이 잘못된 경우가 많음


# 확률이 0 이되는 것을 막기 위한 라플라스 추정량 : 특징이 최소 한번은 나타나게 조정


# 수치형을 범주형으로 변경 - Binning - 시간 - 오전 오후 야간

sms_raw <- read_csv('./ml_R_bread/Chapter 04/sms_spam.csv')
sms_raw %>% glimpse()
sms_raw$type <- factor(sms_raw$type)

table(sms_raw$type)

install.packages('tm')
library(tm)

sms_corpus <- sms_raw$text %>% 
  VectorSource() %>% 
  VCorpus()

sms_corpus[1:2] %>% 
  inspect()

sms_corpus[[1]] %>% 
  as.character()

sms_corpus_clean <- sms_corpus %>% 
  tm_map(content_transformer(tolower)) 

sms_corpus_clean <- sms_corpus_clean %>% 
  tm_map(removeWords, stopwords())

sms_corpus_clean <- sms_corpus_clean %>% 
  tm_map(removePunctuation)

sms_corpus_clean

install.packages('SnowballC')
library(SnowballC)

wordStem(c('learn', 'learned'))

sms_corpus_clean <- sms_corpus_clean %>% 
  tm_map(stemDocument)

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)


sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test  <- sms_dtm[4170:5559, ]

sms_train_lbls <- sms_raw[1:4169, ]$type
sms_test_lbls  <- sms_raw[4170:5559, ]$type

sms_train_lbls %>% 
  table() %>% 
  prop.table()

sms_test_lbls %>% 
  table() %>% 
  prop.table()

install.packages('wordcloud')
library(wordcloud)

wordcloud(sms_corpus_clean, min.freq = 50, random.order = F)
spam <- subset(sms_raw, type == 'spam')
ham <- subset(sms_raw, type == 'ham')

spam$text %>% 
  wordcloud(max.words = 40, scale = c(3, 0.5))
ham$text %>% 
  wordcloud(max.words = 40, scale = c(3, 0.5))

sms_freq_words <- findFreqTerms(sms_dtm_train, 5)

sms_dtm_freq_train <- sms_dtm_train[, sms_freq_words]
sms_dtm_freq_test  <- sms_dtm_test[, sms_freq_words]


convert_counts <- function(x){
  x <- ifelse(x > 0, 'Y', 'N')
}

sms_train <- apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)
sms_test  <- apply(sms_dtm_freq_test , MARGIN = 2, convert_counts)

install.packages('e1071')
library(e1071)

sms_classifire <- naiveBayes(sms_train, sms_train_lbls)
sms_classifire_lap <- naiveBayes(sms_train, sms_train_lbls, laplace = 1)

sms_predictions <- predict(sms_classifire, sms_test)
sms_predictions_lap <- predict(sms_classifire_lap, sms_test)

sms_predictions_lap %>% 
  CrossTable(x = sms_test_lbls, .,
          prop.chisq = F, prop.t = F, prop.r = F,
          dnn = c('actual', 'predicted'))
