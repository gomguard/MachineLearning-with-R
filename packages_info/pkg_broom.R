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

library(gapminder)
data(gapminder)

by_group <- gapminder %>% 
  mutate(year1950 = year - 1950) %>% 
  group_by(continent, country) %>% 
  nest()

lm_model <- function(df){
  lm(lifeExp ~ year1950, df)
}

add_lm <- by_group %>% 
  mutate(mod = data %>% map(lm_model))

library(broom)
add_lm$mod[[1]] %>% tidy()
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
library(rsample)
library(skimr)
iris %>% 
  rsample::initial_split(0.6) %>% 
  training() %>% 
  skim()

iris %>% 
  rsample::initial_split(0.6) %>% 
  testing() %>% 
  skim()


iris_split <- iris %>% 
  rsample::initial_split(0.6) 

iris_split %>% 
  training() %>% 
  skim()

iris_split %>% 
  testing() %>% 
  skim()

fun_lst <- list(mean = mean, median = median)
fun_lst
list
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each(funs(mean, median), mpg, wt)

# BROOM
# https://r4ds.had.co.nz/many-models.html

# The broom package provides three general tools for turning models into tidy data frames:

# broom::glance(model) returns a row for each model. Each column gives a model summary: either a measure of model quality, or complexity, or a combination of the two.

# broom::tidy(model) returns a row for each coefficient in the model. Each column gives information about the estimate or its variability.

# broom::augment(model, data) returns a row for each row in data, adding extra values like residuals, and influence statistics.


df <- tribble(
  ~x,
  letters[1:5],
  1:3,
  runif(5)
)

df %>% 
  mutate(type = map_chr(x, typeof),
         length = map_int(x, length))

df <- tribble(
  ~x,
  list(a = 1, b = 2),
  list(a = 3, c = 4)
)
df %>% 
  mutate(a = map_dbl(x, 'a'),
         b = map_dbl(x, 'b', .null = NA))
