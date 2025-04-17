library(tidyverse)
library(readxl)
library(auk)

data = read_excel('./data/NWSD.xlsx')

head(data)

data$RUNWAY

table(data$DAMAGE_LEVEL)

data$FLT

table(data$OTHER_SPECIFY)

data$INDICATED_DAMAGE

unique(data$STATE)



species <- read_csv('./data/SpeciesList.csv')
migrants <- read_csv('./data/MigrantNonBreeder/Migrants.csv')

data_path = './data/ebd-datafile-SAMPLE/ebd_US-AL-125_202503_202503_smp_relMar-2025.txt'
df <- data_path %>% read_ebd()


#################################
set_ebirdst_access_key("4ts21pa5s600")
#################################

birds <- read_csv('./data/birds.csv', col_names = c('name'))
ebirdst_runs %>% View()

ebird_names <- ebirdst_runs %>% 
    mutate(common_name = tolower(common_name)) %>%
    select(common_name, is_resident, trends_season, trends_region)
ebird_names %>% View()


birds <- birds %>% mutate(in_ebird = as.numeric(name %in% ebird_names$common_name))

birds %>% filter(in_ebird == 0) %>% View()

birds %>% filter(in_ebird == 0) %>% select(name) %>% write_csv("not_in_list.csv")






