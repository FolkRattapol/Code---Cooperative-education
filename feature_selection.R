
# เรียกใช้งาน library ที่โหลดเข้ามา
library(tidyverse)
library(readxl)

## load data
data <- read_excel("RAW_DATA.xlsx", sheet = 1)

## create mode function
Mode <- function(x, na.rm = FALSE) {
  if(na.rm){
    x = x[!is.na(x)]
  }
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}

prep <- data

## categorical feature
prep$GENDER <- factor(prep$GENDER, levels = c(0,1,2,3),
                      labels = c("Undefined", "Male", "Female","Other"))
prep$MARITAL_STATUS <- factor(prep$MARITAL_STATUS, levels = c(0,1,2),
                       labels = c("Undefined", "Married", "Single"))
prep$OCCUPATION <- factor(prep$OCCUPATION, levels = c(0,1,2,3,4,5,6,7,8),
                          labels = c("UNDEFINED", "PRIVATE COMPANY","INDEPENDENT","GOVERNMENT","BUSINESS OWNER","OTHER","TEMPORARY WORKER","STATE ENTERPISE","HOUSEWIFE"))
prep$OFFICE_SECTOR <- factor(prep$OFFICE_SECTOR, levels = c(0,1,2,3,4,5,6),
                             labels = c("Undefined","Central","Eastern","Northeastern","Northern","Western","Southern"))


## numerical into categorical feature
prep$AGE <- factor(prep$AGE, levels = c(1, 2, 3, 4),
                   labels = c("20-35","36-44","45-54","more than 54"))

prep$PRINCIPLE <- factor(prep$PRINCIPLE, levels = c(1,2,3,4), 
                         labels = c("0 - 10,000","10,001 - 20,000","20,001 - 30,000","more than 30,000"))

prep$INTEREST <- factor(prep$INTEREST, levels = c(1,2,3,4),
                        labels = c("0 - 2,000","2,001 - 4,000","4,001 - 6,000","more than 6,000"))

prep$TOTAL_OTHER_FEE <- factor(prep$TOTAL_OTHER_FEE, levels = c(1,2,3,4),
                               labels = c("0 - 2,000","2,001 - 4,000","4,001 - 6,000","more than 6,000"))

prep$OS_BALANCE <- factor(prep$OS_BALANCE, levels = c(1,2,3,4), 
                          labels = c("0 - 10,000","10,001 - 20,000","20,001 - 30,000","more than 30,000"))

prep$PMMONTHS_BK <- factor(prep$PMMONTHS_BK, levels = c(1,2,3,4,5,6,7,8),
                           labels = c("0-1","2-3","4-5","7-12","13-24","25-60","61-120","more than 120"))

prep$PAID_STATUS <- factor(prep$PAID_STATUS,
                           levels = c(0,1),
                           labels = c("No_Paid","Paid"))

## feature selection
prep <- prep %>%  
  filter(STATUS_ID != 4) %>%
  select(10:20) %>%
  drop_na()

## view data structure
glimpse(prep)


## check missing value
mean(complete.cases(prep))

prep <- prep %>% drop_na()


