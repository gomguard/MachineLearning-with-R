#### File Info ###############################
##
##  File_name : 0.k_clustering.R
##  Desc      : Description
##  Author    : GomGuard
##  Creted    : 2020-05-28
## 
##############################################

## k-means ####
# install.packages('caret')
library(caret)
set.seed(1712)

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = F)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

# scaling
training.data <- scale(training[-5])
summary(training.data)

iris.kmeans <- kmeans(training.data[,-5], centers = 3, iter.max = 10000)
iris.kmeans$centers

training$cluster <- as.factor(iris.kmeans$cluster)
qplot(Petal.Width, Petal.Length, colour = cluster, data = training)
table(training$Species, training$cluster)


# how to select cores in k-clustering
# install.packages("NbClust")
library(NbClust)

nc <- NbClust(training.data, min.nc = 2, max.nc = 15, method = "kmeans")

par(mfrow=c(1,1))
barplot(table(nc$Best.n[1,]),
        xlab="Numer of Clusters", ylab="Number of Criteria",
        main="Number of Clusters Chosen")


# how to evaluate accuracy of the model
# https://ko.wikipedia.org/wiki/K-%ED%8F%89%EA%B7%A0_%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98#Davies-Bouldin_index
# 1) 군집 내 응집도 최대화(maximizing cohesion within cluster) : 
#    군집 內 중심(centroid)과 해당 군집의 각 객체 간 거리의 합 최소화
# 2) 군집 간 분리도 최대화(maxizing separation between clusters) : 
#    각 군집의 중심(centroid) 間 거리 합 최대화 






## k-prototype ####
# install.packages('clustMixType')
library(clustMixType)
# generate toy data with factors and numerics

n   <- 100
prb <- 0.9
muk <- 1.5 
clusid <- rep(1:4, each = n)

x1 <- sample(c("A","B"), 2*n, replace = TRUE, prob = c(prb, 1-prb))
x1 <- c(x1, sample(c("A","B"), 2*n, replace = TRUE, prob = c(1-prb, prb)))
x1 <- as.factor(x1)

x2 <- sample(c("A","B"), 2*n, replace = TRUE, prob = c(prb, 1-prb))
x2 <- c(x2, sample(c("A","B"), 2*n, replace = TRUE, prob = c(1-prb, prb)))
x2 <- as.factor(x2)

x3 <- c(rnorm(n, mean = -muk), rnorm(n, mean = muk), rnorm(n, mean = -muk), rnorm(n, mean = muk))
x4 <- c(rnorm(n, mean = -muk), rnorm(n, mean = muk), rnorm(n, mean = -muk), rnorm(n, mean = muk))

x <- data.frame(x1,x2,x3,x4)

# apply k prototyps
kpres <- kproto(x, 4)
clprofiles(kpres, x)

# in real world  clusters are often not as clear cut
# by variation of lambda the emphasize is shifted towards factor / numeric variables    
kpres <- kproto(x, 2)
clprofiles(kpres, x)

kpres <- kproto(x, 2, lambda = 0.1)
clprofiles(kpres, x)

kpres <- kproto(x, 2, lambda = 25)
clprofiles(kpres, x)

iris_cl <- iris[, c(1,2,3,4)]
cls <- kmeans(iris_cl, 3)

iris$cluster <- cls$cluster

iris %>% 
  as_tibble() %>% 
  mutate(Species_cvt = case_when(
    Species == "setosa" ~ 1,
    Species == "versicolor" ~ 2,
    TRUE ~ 3
  ),
  tf_flag = cluster - Species_cvt) %>% 
  group_by(tf_flag) %>% 
  count()


iris %>% 
  ggplot() +
  geom_point(aes(x = Sepal.Width, y = Sepal.Length, color = as_factor(cluster)))

iris %>% 
  ggplot() +
  geom_point(aes(x = Sepal.Width, y = Sepal.Length, color = Species))


