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
  geom_point(alpha = 0.5) +
  geom_vline(aes(xintercept = 5))

# 필수 요소
- 데이터(data)
- 매핑(mapping)
- 레이어(layer)
  - 기하객체(geom)

# 선택요소
  - 통계객체(stat)
- 척도(scale)
- 좌표 객체(coord)
- 일부단면(facet)
- 테마(theme)
