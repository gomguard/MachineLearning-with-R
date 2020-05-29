#### File Info ###############################
##
##  File_name : pkg_tidyeval.R
##  Desc      : Description
##  Author    : GomGuard
##  Creted    : 2020-05-28
## 
##############################################  

library(tidyverse)


starwars %>% filter(
  height < 200,
  gender == "male"
)

starwars[starwars$height < 200 & starwars$gender == "male", ]



list(
  height < 200,
  gender == "male"
)
#에러: 객체 'height'를 찾을 수 없습니다


starwars %>% summarise_at(vars(ends_with("color")), n_distinct)

# ?? why error ??
vars(
  ends_with("color"),
  height:mass
)


exprs <- vars(height / 100, mass + 50)

rlang::eval_tidy(exprs[[1]])
#> Error in rlang::eval_tidy(exprs[[1]]): object 'height' not found

rlang::eval_tidy(exprs[[1]], data = starwars)

x <- 1

rlang::qq_show(
  starwars %>% summarise(out = x)
)
#> starwars %>% summarise(out = x)

rlang::qq_show(
  starwars %>% summarise(out = !!x)
)
#> starwars %>% summarise(out = 1)


col <- "height"

rlang::qq_show(
  starwars %>% summarise(out = sum(!!col, na.rm = TRUE))
)
# Error in sum("height", na.rm = TRUE) : 인자의 'type' (character)이 올바르지 않습니다

rlang::qq_show(
  starwars %>% summarise(out = sum(!!sym(col), na.rm = TRUE))
)


## doesn't work
rlang::qq_show(
  starwars %>% summarise(out = sum({{col}}, na.rm = TRUE))
)

# eval == !!
rlang::qq_show(
  starwars %>% summarise(out = sum(eval(sym(col)), na.rm = TRUE))
)


# all 조건 
compute_bmi <- function(data) {
  if (!all(c("mass", "height") %in% names(data))) {
    stop("`data` must contain `mass` and `height` columns")
  }
  
  mean_height <- round(mean(data$height, na.rm = TRUE), 1)
  if (mean_height > 3) {
    warning(glue::glue(
      "Average height is { mean_height }, is it scaled in meters?"
    ))
  }
  
  data %>% transmute(bmi = mass / height^2)
}



iris %>% compute_bmi()
starwars %>% compute_bmi()



iris %>% 
  as_tibble() %>% 
  select_all(toupper)

# select_all(.tbl, .funs = list(), ...)
# 
# select_if(.tbl, .predicate, .funs = list(), ...)
# 
# select_at(.tbl, .vars, .funs = list(), ...)


range(c(1:10, TRUE, FALSE), na.rm = T, finite = T)

# quoting and unquoting
# enquo
grouped_mean <- function(data, group_var, summary_var) {
  group_var <- enquo(group_var)
  summary_var <- enquo(summary_var)
  
  data %>%
    group_by(!!group_var) %>%
    summarise(mean = mean(!!summary_var))
}

b <- enquo(a)

# R functions can be categorised in two broad categories: evaluating functions and quoting functions

# regular function
identity(6)
#> [1] 6

identity(2 * 3)
#> [1] 6

a <- 2
b <- 3
identity(a * b)
#> [1] 6



# On the other hand, a quoting function is not passed the value of an expression, it is passed the expression itself. 
quote(6)
#> [1] 6

quote(2 * 3)
#> 2 * 3

quote(a * b)
#> a * b

# Other familiar quoting operators are "" and ~. The "" operator quotes a piece of text at parsing time and returns a string.
~ a * b
"a * b"



# Direct vs Indirect
df <- data.frame(
  y = 1,
  var = 2
)

var <- "y"
df[[var]]
#> [1] 1

df$y
#> [1] 1

df[[var]] # Indirect
#> [1] 1

df[["y"]] # Direct
#> [1] 1

df$var    # Direct
#> [1] 2

df$y      # Direct
#> [1] 1




bb <- "tidyverse"
library(bb, character.only = TRUE )
temp <- "MASS"
library(temp, character.only = TRUE)
library(!!quote(tidyverse))

# doesn't work