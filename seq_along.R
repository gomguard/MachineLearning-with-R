###########################################################################
#
#    script_name : seq_along.R
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
