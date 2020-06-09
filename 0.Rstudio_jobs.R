# file_1.R

rstudioapi::jobRunScript(path = 'run_file.R', name = glue::glue(), importEn = TRUE, exportEnv = TRUE)


# file_2.R

library(tidyverse)
print(value)

saveRDS('test.rds')
