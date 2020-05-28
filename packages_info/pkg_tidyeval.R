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
