library(tidyverse)
library(readxl)
library(auk)
library(ebirdst)

data = read_excel('./data/NWSD.xlsx')

head(data)

data$RUNWAY

table(data$DAMAGE_LEVEL)

data$FLT

table(data$OTHER_SPECIFY)

data$INDICATED_DAMAGE

unique(data$STATE)


data %>% filter(STATE %in% c('UM', 'MH')) %>% select(AIRPORT_ID, AIRPORT, STATE) %>% View()

not_use_ID <- c('ZZZZ', 'H2O', 'PVT', 'RIGG')
data %>% filter(AIRPORT_ID %in% not_use_ID) %>% View()

data %>% filter(AIRPORT_ID == 'H2O') %>% View()


data %>% filter(is.na(AIRPORT_LATITUDE) & !(AIRPORT_ID %in% not_use_ID)) %>% 
    select(AIRPORT_ID, SPECIES, SPECIES_ID, STATE, AIRPORT, AIRPORT_LATITUDE, AIRPORT_LONGITUDE, DAMAGE_LEVEL, TIME, TIME_OF_DAY) %>% View()







data %>% select(EFFECT, EFFECT_OTHER) %>% filter(!is.na(EFFECT) & EFFECT != 'None') %>% View()


data %>% filter(AIRCRAFT == 'UNKNOWN' | AIRCRAFT == 'Unknown')


##### TIME 관련 #####

data %>% filter(!is.na(TIME) & is.na(TIME_OF_DAY)) %>% View()    # TIME이 기록되어 있지만 TIME_OF_DAY가 기록되어 있지 않은 경우
data %>% filter(!is.na(TIME) & !is.na(TIME_OF_DAY)) %>% View()
## 비슷한 위치, 비슷한 월 기준으로 KNN 사용하여 결측치를 채움.

data %>% filter(is.na(TIME) & is.na(TIME_OF_DAY))


## AC_CLASS, AC_MASS 가 비행기 기종이 정해지면 결정되는가?

data %>% filter(AIRCRAFT != 'UNKNOWN' & is.na(AC_CLASS)) %>% select(AIRCRAFT) %>% View()
data %>% filter(AIRCRAFT != 'UNKNOWN' & is.na(AC_CLASS)) %>% select(AIRCRAFT) %>% table()
# B-767-200, AW139



###### 엔진, 비행기 관련 ######
# EMA, EMO

data %>% filter(AIRCRAFT == 'B-737-300') %>% View()

data %>% filter(AIRCRAFT == 'B-737-300') %>% select(TYPE_ENG) %>% table()

data %>% select(AIRCRAFT) %>% table()


#########################

data_path = './data/ebd-datafile-SAMPLE/ebd_US-AL-125_202503_202503_smp_relMar-2025.txt'
ebird_df <- data_path %>% read_ebd()

ebird_df %>% View()


#################################
set_ebirdst_access_key("4ts21pa5s600")
#################################

birds <- read_csv('./data/birds.csv', col_names = c('name'))

ebirdst_runs %>% View()

ebird_names <- ebirdst_runs %>% 
    mutate(common_name = tolower(common_name)) %>%
    select(common_name, is_resident, trends_season, trends_region)
ebird_names %>% View()

ebird_names %>% filter(str_detect(common_name, "yellowlegs")) %>% View()
ebird_names %>% filter(str_detect(common_name, "ibis")) %>% View()



birds <- birds %>% mutate(in_ebird = as.numeric(name %in% ebird_names$common_name))

birds %>% filter(in_ebird == 0) %>% View()

birds %>% filter(in_ebird == 0) %>% select(name) %>% write_csv("not_in_list.csv")


trends_runs <- ebirdst_runs %>%
    filter(has_trends)


ebirdst_runs %>% View()