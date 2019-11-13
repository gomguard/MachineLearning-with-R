###########################################################################
#
#    script_name : DSC01-Data_Wrangling.R   
#    author      : Gomguard
#    created     : 2019-11-13 15:07:42
#    description : how to wrangle data with R / Tidyverse
#
###########################################################################

#### tips
# shortcuts : shift + alt + k
# comment   : shift + ctrl + c

####
library(tidyverse)
library(skimr)


# Exploratory Data Analysis
diamonds

# 1. What type of variation occurs within my variables?
# 2. What type of covariation occurs between my variables?

# base R - summary, str, dim
diamonds %>% summary()
diamonds %>% str()
diamonds %>% dim()

# tidyverse - dplyr::glimpse, skimr::skim
diamonds %>% glimpse()
diamonds %>% skim()


nycflights13::flights %>% 
  print()

options(tibble.print_max = 10, tibble.print_min = NULL)
options(tibble.width = Inf)

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]
df %>% as_tibble() %>% .$xyz                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   


Transposed tibble. tribble()
# cartesian - Rene Decartes


lag(1:10, n = 3, default = 1)
cumsum(1:10)
cumprod(1:10)
cummean(1:10)
cummax(1:10)

iris %>% as_tibble() %>% 
  arrange(Sepal.Length) %>% 
  summarise(first(Sepal.Length),
            nth(Sepal.Length, 2),
            IQR(Sepal.Length))

iris %>% 
  group_by(Species) %>% 
  summarise(n())
iris %>% 
  filter(Sepal.Length %in% range(Sepal.Length))

iris %>% 
  count(Species, wt = Sepal.Length)

tibble(x = rep(1:3, 3), y = 1:9) %>% 
  group_by(x) %>% 
  # count(wt = x)
  summarise(s = sum(y < 5),
            n = n(),
            a = mean(y < 5))

library(nycflights13)
# 지연 특성을 찾아보기
## 항공편은 50% 의 경우 15분 지연, 15분 단축 된다.
## 항공편은 항상 10분 늦는다

flights %>% select(dep_time, dep_delay, arr_time, arr_delay)
flights %>% select(starts_with('dep_'), starts_with('arr_'))

flights %>% select(dep_time, dep_time)
vars <- c('year', 'month', 'day', 'dep_delay', 'arr_delay', 'aa', 'bb')
flights %>% select(one_of(vars))
flights %>% select(vars)
flights %>% select(contains('TIME', ignore.case = F))

# question 
library(lubridate)
flights %>% 
  # select(dep_time, sched_dep_time) %>% 
  mutate(dep_time_f = make_datetime( year, month, day, dep_time %/% 100, dep_time %% 100),
         sched_dep_time_f = make_datetime( year, month, day, sched_dep_time %/% 100, sched_dep_time %% 100))
101 %% 10
101 %/% 10


flights %>% 
  transmute(a = make_datetime(1,1,1, air_time%/%60, air_time %% 60), 
            
            b = arr_time,
            c = dep_time,
            d = arr_time - dep_time)

# update
today() %>% 
  update(hour = 4, minute = 10)

hours(c(10, 10)) + minutes(10)

flights %>% skim()
flights %>% 
  dplyr::filter(is.na(arr_time) & is.na(dep_time))

flights %>% 
  group_by(carrier) %>% 
  summarise(n = n(), 
            dep_delay_mean = mean(dep_delay, na.rm = T),
            dep_delay_min = min(dep_delay, na.rm = T),
            dep_delay_max = max(dep_delay, na.rm = T),
            arr_delay_mean = mean(arr_delay, na.rm = T),
            arr_delay_min = min(arr_delay, na.rm = T),
            arr_delay_max = max(arr_delay, na.rm = T)
            ) %>% 
  print(n = 20)

flights %>% 
  ggplot(aes(x = carrier)) +
  geom_boxplot(aes(y = dep_delay)) +
  coord_flip()

flights %>% 
  ggplot(aes(x = dep_delay, y = arr_delay, color = carrier)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0, color = 'grey') + 
  facet_wrap(. ~ carrier)

flights %>% 
  filter(dep_time > arr_time)

## data preprocess
# 지연 부분 로직 수정

base_dt <- flights %>% 
  mutate(
    dep_dt = make_date(year, month, day),
    arr_dt = if_else(dep_time > arr_time, dep_dt + days(1), dep_dt)
  ) %>% 
  # filter(dep_dt != arr_dt)
  transmute(
    carrier, flight, tailnum, origin, dest, air_time, distance,
    sched_dep_dttm = update(dep_dt, hour = sched_dep_time %/% 100, minute = sched_dep_time %% 100),
    dep_dttm       = update(dep_dt, hour = dep_time %/% 100, minute = dep_time %% 100),
    sched_arr_dttm = update(arr_dt, hour = sched_arr_time %/% 100, minute = sched_arr_time %% 100),
    arr_dttm       = update(arr_dt, hour = arr_time %/% 100, minute = arr_time %% 100),
    air_time       = difftime(arr_dttm, dep_dttm, units = 'mins'),
    dep_delay      = difftime(dep_dttm, sched_dep_dttm, units = 'mins'),
    arr_delay      = difftime(arr_dttm, sched_arr_dttm, units = 'mins'),
    air_time_delay = arr_delay - dep_delay
    )

library(tidymodels)
library(broom)
rcp <- base_dt %>% 
  recipe(air_time_delay ~ carrier + origin + dest + sched_dep_dttm) %>% 
  step_dummy(all_nominal(), one_hot = T) %>% 
  step_date(sched_dep_dttm) %>% 
  prep()

hot <- rcp %>% 
  juice()
mod <- hot %>% 
  mutate(air_time_delay = as.numeric(air_time_delay)) %>% 
  lm(air_time_delay ~ ., data = .)


mod %>% summary()
mod %>% tidy() %>% 
  arrange(-abs(estimate))

base_dt %>% 
  dplyr::filter(dest %in% c('PSE', 'TUL')) %>% 
  arrange(dest) %>% 
  ggplot(aes(x = dest, y = air_time_delay))
