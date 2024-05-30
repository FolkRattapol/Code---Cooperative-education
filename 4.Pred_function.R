library(tidyverse)
library(caret)
library(MLmetrics)
library(readxl)

Prediction <- function(data,model){
  ## prep data
  prep <- data %>% select(10:19)
  
  ## categorical feature
  for (i in 1:10) {
    prep[[i]] <- factor(prep[[i]])
  }
  
  ## view data structure
  glimpse(prep)
  str(prep)
  
  ## check missing value
  mean(complete.cases(prep))
  
  ## final file
  Final_data <- data
  Final_data$PREDICTION <- predict(model, newdata = prep)
  
  Final_data <- Final_data %>% separate(col = AGREEMENT_ID, into = c("agg1", "agg2"), remove = T,sep = 15)
  
  ## write csv file
  write_csv(Final_data,"Prediction_File.csv")
}

