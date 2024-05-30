# ติดตั้ง library สำหรับการจัดการข้อมูล
install.packages("tidyverse")
install.packages("readxl")

# เรียกใช้งาน library ที่โหลดเข้ามา
library(tidyverse)
library(readxl)

## load data
data <- read_excel("RAW_DATA.xlsx", sheet = 1)

## back up data
prep <- data

## explore data
glimpse(prep)

## prepare data
prep <- prep %>%  
  filter(STATUS_ID != 4) %>%
  select(10:20) %>%
  drop_na() # ลบค่าว่าง

## change variables to categorical by for loop
for (i in 1:11) {
  prep[[i]] <- as.factor(prep[[i]])
}

## ตรวจสอบจำนวนค่าที่อยู่ในแต่ละตัวแปร
str(prep)

## categorical feature
prep$PAID_STATUS <- factor(prep$PAID_STATUS,
                           levels = c(0,1),
                           labels = c("No_Paid","Paid"))

## view data structure
glimpse(prep)


## check missing value
mean(complete.cases(prep))

## remove missing value
prep <- prep %>% drop_na()


