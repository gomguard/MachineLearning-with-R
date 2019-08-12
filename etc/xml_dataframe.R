library(tidyverse)
library(xml2)

# sample xml url
xml_path <- 'https://www.w3schools.com/xml/simple.xml'

# read xml data from url
raw_xml <- read_xml(xml_path)

# food element
food_node <- xml_find_all(raw_xml, './/food')

# xml to data frame
lapply(seq_along(food_node), 
       function(x){
         temp_row <- xml_find_all(food_node[x], './*')
         tibble(
           idx = x,
           key = temp_row %>% xml_name(),
           value = temp_row %>% xml_text()
         ) %>% return()
         }
       ) %>% bind_rows() %>%
  spread(key, value) %>%
  select(first_node %>% xml_find_all('./*') %>% xml_name %>% unique())


# <breakfast_menu>
#   <food>
#   <name>Belgian Waffles</name>
#   <price>$5.95</price>
#   <description>
#   Two of our famous Belgian Waffles with plenty of real maple syrup
#   </description>
#   <calories>650</calories>
#   </food>
#   <food>
#   <name>Strawberry Belgian Waffles</name>
#   <price>$7.95</price>
#   <description>
#   Light Belgian waffles covered with strawberries and whipped cream
#   </description>
#   <calories>900</calories>
#   </food>
# ........
# </breakfast_menu>

raw_xml_2 <- 
'<VALDISTRIKT KOD="01140212" NAMN="Smedby Södra" RÖSTER="1201" RÖSTER_FGVAL="1186" TID_RAPPORT="20140914230336" MODNR="117144935">
  <GILTIGA PARTI="M" RÖSTER="227" RÖSTER_FGVAL="336" PROCENT="18,9" PROCENT_FGVAL="28,3" PROCENT_ÄNDRING="-9,4"/>
  <GILTIGA PARTI="C" RÖSTER="35" RÖSTER_FGVAL="17" PROCENT="2,9" PROCENT_FGVAL="1,4" PROCENT_ÄNDRING="+1,5"/>
  <GILTIGA PARTI="FP" RÖSTER="43" RÖSTER_FGVAL="61" PROCENT="3,6" PROCENT_FGVAL="5,1" PROCENT_ÄNDRING="-1,6"/>
  <ÖVRIGA_GILTIGA RÖSTER="20" RÖSTER_FGVAL="10" PROCENT="1,7" PROCENT_FGVAL="0,8" PROCENT_ÄNDRING="+0,8"/>
  <OGILTIGA TEXT="BLANK" RÖSTER="12" RÖSTER_FGVAL="13" PROCENT="1,0" PROCENT_FGVAL="1,1" PROCENT_ÄNDRING="-0,1"/>
  <OGILTIGA TEXT="OG" RÖSTER="13" RÖSTER_FGVAL="1" PROCENT="1,1" PROCENT_FGVAL="0,1" PROCENT_ÄNDRING="+1,0"/>
  <VALDELTAGANDE RÖSTBERÄTTIGADE="1551" RÖSTBERÄTTIGADE_KLARA_VALDISTRIKT_FGVAL="1546" SUMMA_RÖSTER="1226" SUMMA_RÖSTER_FGVAL="1200" PROCENT="79,0" PROCENT_FGVAL="77,6" PROCENT_ÄNDRING="+1,4"/>
</VALDISTRIKT>' %>% read_xml()

xml_find_all(raw_xml_2, '//VALDISTRIKT/*') %>% 
  map(xml_attrs) %>%
  map_df(~as.list(.)) %>%
  mutate(TYPE = xml_find_all(raw_xml_2, '//VALDISTRIKT/*') %>% xml_name)
