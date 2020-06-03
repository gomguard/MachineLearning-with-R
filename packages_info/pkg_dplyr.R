library(rlang)
library(dplyr)
iris <- as_tibble(iris)

named_vector <- c('id' = 'Species',
                  'sepal' = 'Sepal.Length')

iris %>% rename(!!! named_vector) %>% head(2)
iris %>% rename(all_of(named_vector)) %>% head(2)
