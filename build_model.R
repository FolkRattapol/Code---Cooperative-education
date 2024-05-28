# ติดตั้ง library สำหรับการสร้าง และปรับปรุงโมเดล
install.packages("caret")
install.packages("MLmetrics")
install.packages("pROC")


# เรียกใช้งาน library ที่โหลดเข้า
library(caret)
library(MLmetrics)
library(pROC)
library(ROSE)



prep_2 <- prep %>% select(5,9,10,11)

mean(complete.cases(prep))
## 1. split data
train_test_split <- function(data, size = 0.8) {
  set.seed(20)
  n <- nrow(data)
  train_id <- sample(1:n, size*n)
  train_df <- data[train_id, ]
  test_df <- data[-train_id, ]
  return(list(train_df, test_df))
}
prep_df <- train_test_split(prep, 0.9)

## 2. train model
# tune
ctrl <- trainControl(
  method = "cv",
  number = 5,
  summaryFunction = prSummary,
  verboseIter = TRUE,
  classProbs = TRUE,
  sampling = "down",
)
# train
logis_model <- train(
  PAID_STATUS ~ ., 
  data = prep_df[[1]],
  method = "glm",
  metric = "Recall",
  trControl = ctrl
)


## 3. Score model
probs_train <- predict(
  logis_model,
  newdata = prep_df[[1]],
  type = "prob"
)

probs_test <- predict(
  logis_model, 
  newdata = prep_df[[2]], 
  type = "prob"
)

p_train <- ifelse(
  probs_train$Paid >= 0.58,
  "Paid", "No_Paid"
)

p_test <- ifelse(
  probs_test$Paid >= 0.58, 
  "Paid", "No_Paid"
)

p_train <- factor(p_train, levels = c("No_Paid","Paid"))
p_test <- factor(p_test, levels = c("No_Paid","Paid"))

## 4. evaluate
mean(p_train == prep_df[[1]]$PAID_STATUS)
mean(p_test == prep_df[[2]]$PAID_STATUS)
# base_data <- table(prep_df[[2]]$PAID_STATUS)

## confusion matrix
table(p_test, prep_df[[2]]$PAID_STATUS, dnn=c("prediction","actual"))

confusionMatrix(
  p_train,
  prep_df[[1]]$PAID_STATUS,
  positive = "Paid",
  mode = "prec_recall"
)

confusionMatrix(
  p_test, 
  prep_df[[2]]$PAID_STATUS, 
  positive = "Paid",
  mode = "prec_recall"
)

## wirte model
saveRDS(logis_model,"logisModel.RDS")
logis_model <- readRDS("rfMedel.RDS")

# feature importance
Importance <- varImp(logis_model, scale = F)
plot(Importance, main = "Paid or Nopaid Variables Importance")
