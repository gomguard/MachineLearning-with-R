#### File Info ###############################
##
##  File_name : 0.PCA.R   
##  Desc      : Description
##  Author    : GomGuard
##  Creted    : 2020-05-28
## 
##############################################

# https://rpubs.com/Evan_Jung/pca
library(tidyverse)
library(devtools)
# library(ggbiplot)
require(graphics)


# 연속형 변수
dt <- iris[, -5]
# 범주형 변수
dt_group <- iris[, 5]
pca_dt <- prcomp(dt,
                 center = T,
                 scale. = T)

plot(pca_dt,
     type = "l")
# install.packages('ggbiplot')

## package ‘ggbiplot’ is not available (for R version 4.0.0)
# g <- ggbiplot(pca_dt, choices = c(1, 2), 
#               obs.scale = 1, var.scale = 1, 
#               groups = dt_group, ellipse = TRUE, 
#               circle = TRUE) 
# g <- g + scale_color_discrete(name = '') 
# g <- g + theme(legend.direction = 'horizontal', legend.position = 'top')
# print(g)

# graphics
summary(pca_dt)
biplot(pca_dt)


pca_dt$x %>% 
  as_tibble() %>% 
  select(PC1,PC2) %>% 
  mutate(spc = iris$Species) %>% 
  ggplot() +
  geom_point(aes(x = PC1, y = PC2, color = spc))


