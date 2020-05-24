###########################################################################
#
#    script_name : 0.association_rules.R
#    author      : Gomguard
#    created     : 2020-05-23 17:42:09
#    description : desc
#
###########################################################################

library(tidyverse)
library(skimr)
library(glue)
library(RPostgreSQL)
library(DBI)
library(dbplyr)

main_path <- 'C:/Data_R'
f_log_path <- file.path(main_path, 'ss_finance_log.csv')
ivt_mst_path <- file.path(main_path, 'ss_process_inventory_master.csv')


f_log <- read_csv(f_log_path) %>% 
  select(-X1) %>% 
  mutate_if(is.character, as_factor)
ivt_mst <- read_csv(ivt_mst_path, locale = locale(encoding='cp949')) %>% 
  mutate_if(is.character, as_factor)

ivt_mst %>% 
  skim()

plot_lst <- ivt_mst %>% 
  map(function(.x){
    # temp_tbl <- tibble(.x)
    p <- ggplot(temp_tbl) +
      geom_bar(aes(x = .x)) +
      theme(axis.text.x = element_text(size = 11)) +
      scale_x_discrete(guide = guide_axis(n.dodge = 2))
    # ggsave()
    print(.x)
  })

## top20 element bar plot by col
for (col in names(ivt_mst)) {
  temp_tbl <- ivt_mst %>% 
    select(val = col) %>% 
    group_by(val) %>% 
    count() %>% 
    ungroup() %>% 
    mutate(val = fct_reorder(val, n)) %>% 
    arrange(desc(n)) %>% 
    filter(row_number() <= 20)
  
  p <- ggplot(temp_tbl, aes(x = val, y = n, fill = val)) +
    geom_bar(stat = 'identity', alpha = .7) +
    theme(axis.text.x = element_text(size = 11),
          legend.position="none") +
    # scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
    coord_flip()
  
  ggsave(glue('C:/Data_R/plot/ivt_mst_{col}_bar_plot.png'))
}


## initialize Connection

con_post <- DBI::dbConnect(odbc::odbc(),
                           drv = dbDriver("PostgreSQL"),
                           host = 'anoblekman.ddns.net',
                           dbname = "postgres",
                           user = "postgres",
                           password = "postgres",
                           port = 25432
)
tbl(con_post, "fi_history")



f_log_flt <- f_log %>% 
  filter(!str_detect(module_nm, '(SAP|MM|SD)'))

f_log_flt %>% 
  ggplot() +
  geom_density(aes(x = count, color = module_nm))

f_log_flt %>% 
  arrange(desc(count)) %>% 
  View()

ivt_mst %>% 
  filter(nerp_pgm_id == 'ZFG0080')





## Date X Pgm_ID Headmap

dateXpgm_count_pvt_skin <- f_log_flt %>% 
  filter(bname == 'S.KIN') %>% 
  group_by(zdate, pgm_id) %>% 
  summarise(sum = sum(count)) %>% 
  pivot_wider(names_from = pgm_id, values_from = sum) %>% 
  ungroup()

RPostgreSQL::dbWriteTable(conn = con_post,  
                          name = 'dateXpgm_count_pvt_skin',
                          value =  dateXpgm_count_pvt_skin, 
                          row.names = FALSE,
                          overwrite = TRUE)

f_log_flt %>% 
  # filter(bname == 'S.KIN') %>%
  mutate(zdate = as_factor(zdate)) %>% 
  group_by(zdate, pgm_id) %>% 
  summarise(sum = sum(count)) %>% 
  ggplot(aes(zdate, pgm_id,  fill = sum)) +
  geom_tile() + 
  scale_fill_gradient(low="blue", high="red") +
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE)) +
  ggtitle('Date X Pgm_ID (Overall Data)')

f_log_flt$zdate %>% 
  unique() %>% 
  sort()

f_log_flt %>% 
  group_by(zdate, bukrs, gsber, kostl, prctr, pgm_id, module_nm) %>% 
  summarise(n = sum(count))

f_log_flt %>% 
  skim()

f_log_flt %>% 
  filter(is.na(prctr)) %>% 
  select(bname) %>% 
  distinct()


# library(recipes)
# rec <- f_log_flt %>% 
#   select(zdate, kostl, pgm_id, count) %>% 
#   recipe(pgm_id~., .) %>% 
#   step_dummy(all_predictors(), -all_numeric()) 
# 
# rec_prep <- prep(rec, f_log_flt)
# bake(rec_prep, f_log_flt)

#### memory error ####

# http://blog.daum.net/sys4ppl/6

library(arules)
library(arulesViz)


f_log_ar <- f_log_flt %>% 
  group_by(kostl, pgm_id) %>% 
  summarise(n = sum(count))


f_log_tran_pre <- split(f_log_ar$pgm_id, f_log_ar$kostl)
f_log_tran <- as(f_log_tran_pre, 'transactions')
summary(f_log_tran)
image(f_log_tran)

f_log_rules <- apriori(f_log_tran)
inspect(f_log_rules)
plot(f_log_rules, method = "graph")


ivt_mst %>% 
  filter(nerp_pgm_id == 'ZFG001')
