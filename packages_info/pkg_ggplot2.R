###########################################################################
#
#    script_name : pkg_ggplot2.R
#    author      : Gomguard
#    created     : 2020-05-26 23:01:02
#    description : ggplot gallery
#
###########################################################################

library(tidyverse)

iris %>% 
  ggplot(aes(Sepal.Length, Sepal.Width, color = Species, size = Sepal.Width)) +
  geom_point(alpha = 0.5)

mtcars
