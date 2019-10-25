###########################################################################
#
#    script_name : seq_along_broom.R
#    author      : Gomguard
#    created     : 2019-10-25 10:06:34
#    description : why have to use seq along
#
###########################################################################

library(tidyverse)

x <- 1:3

seq_along(x)
1:length(x)


y <- c()
seq_along(y)
1:length(y)


map_dbl(mtcars, median)
map_df(mtcars, median)
map_dfc(mtcars, median)
map_dfr(mtcars, median)

select_if(iris, is.numeric)
          

fs <- c(mean, median, sd)


fs %>% 
  map(~ mtcars %>% map_dbl(.x))

data(gapminder)
library(gapminder)

by_group <- gapminder %>% 
  mutate(year1950 = year - 1950) %>% 
  group_by(continent, country) %>% 
  nest()

lm_model <- function(df){
  lm(lifeExp ~ year1950, df)
}

add_lm <- by_group %>% 
  mutate(mod = data %>% map(lm_model))

add_lm$mod[[1]] %>% tidy()
library(broom)
add_lm$mod[[1]] %>% glance()
add_lm$mod[[1]] %>% broom::augment()

add_lm %>% 
  mutate(
    glance = mod %>% map(glance),
    rsq = glance %>% map_dbl('r.squared')
  )

add_lm$mod[[1]] %>% glance() %>% .['r.squared']

  

x <- list(
  a = 1:5,
  b = 3:4, 
  c = 5:6
) 

df <- enframe(x)

#> # A tibble: 3 x 2
#>   name  value    
#>   <chr> <list>   
#> 1 a     <int [5]>
#> 2 b     <int [2]>
#> 3 c     <int [2]>
