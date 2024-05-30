install.packages("tidyverse")
install.packages("caret")
install.packages("MLmetrics")
install.packages("readxl")
library(tidyverse)
library(caret)
library(MLmetrics)
library(readxl)

## Prediction new data
# load new data
new_data <- read_excel("New_data.xlsx", sheet = 1)

# load model
model <- readRDS("model.RDS")

# load function
source("Pred_function.R")
Prediction(new_data, model)
