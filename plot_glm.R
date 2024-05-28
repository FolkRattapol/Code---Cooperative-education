install.packages("tidyverse")
install.packages("plotly")
install.packages("MLeval")
install.packages("yardstick")

library(yardstick) #pr_curve
library(ggplot2)
library(tidyverse)
library(plotly)
library(MLeval)
library(tidymodels)

ggplot(data = prep, aes(PAID_STATUS)) + 
  geom_bar() + ggtitle("Paid_status")+
  theme(plot.title = element_text(hjust = 0.5))

logistic <- glm(PAID_STATUS ~ ., data = prep_df[[2]], family = "binomial")

########################################################################
## plot logistic regression
predicted.data <- data.frame(
  probability.of.PaidStatus = probs_test$Paid,
  PaidStatus = prep_df[[2]]$PAID_STATUS
)

predicted.data <- predicted.data[
  order(predicted.data$probability.of.PaidStatus, decreasing = FALSE),]
predicted.data$rank <- 1:nrow(predicted.data)

ggplot(data = predicted.data, aes(x=rank, y=probability.of.PaidStatus)) +
  geom_point(aes(color=PaidStatus), alpha=1, shape=4, stroke=2)+
  ggtitle("Logistic Regression") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = "Index",
       y = "Predicted probability of Paid Status",
       caption = "Source : AEON D6")+
  geom_smooth(method = "glm",
              method.args = list(family = "binomial"),
              se = FALSE)+
  theme_minimal()

ggsave("paidstatusPlot.pdf")

## plot predict data (0,1)
predicted.data <- data.frame(
  probability.of.PaidStatus = p_test,
  PaidStatus = prep_df[[2]]$PAID_STATUS
)

predicted.data <- predicted.data[
  order(predicted.data$probability.of.PaidStatus, decreasing = FALSE),]
predicted.data$rank <- 1:nrow(predicted.data)

ggplot(data = predicted.data, aes(x=rank, y=probability.of.PaidStatus)) +
  geom_point(aes(color=PaidStatus), alpha=1, shape=4, stroke=2)+
  ggtitle("Logistic Regression") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = "Index",
       y = "Predicted probability of Paid Status",
       caption = "Source : AEON D6")+
  theme_minimal()


########################################################################
## plot ROC CURVE
PaidStatus <- prep_df[[2]]$PAID_STATUS
par(pty = "s")
roc(PaidStatus, 
    probs_test$Paid, 
    plot = TRUE, 
    legacy.axes=TRUE,
    main = "ROC CURVE",
    xlab = "False Positive Rate",
    ylab = "True Positive Rate",
    col = "salmon",
    lwd = 5,
    print.auc = TRUE
)

roc.info <- roc(PaidStatus,
                probs_test$Paid,
                legacy.axes=TRUE)

roc.df <- data.frame(
  tpr = roc.info$sensitivities,
  fpr = 1- roc.info$specificities,
  diff_tpr_fpr = roc.info$sensitivities - 
    (1- roc.info$specificities),
  thresholds = roc.info$thresholds
)
roc.df
(best_threshold <- roc.df[roc.df$diff_tpr_fpr == max(roc.df$diff_tpr_fpr),4])

###################################################################
## precision - recall curve
db <- data.frame(prep_df[[2]]$PAID_STATUS,probs_test$Paid)
colnames(db) <- c("Paid_Status","Pred_Paid")
pdb <- pr_curve(db, Paid_Status,Pred_Paid)

pr_curve(db, Paid_Status,Pred_Paid) %>%
  ggplot(aes(x = recall, y = precision)) +
  geom_path() +
  coord_equal() +
  theme_bw()

auc = roc_auc(db, Paid_Status, Pred_Paid)
auc = auc$.estimate

tit = paste('ROC Curve (AUC = ',toString(round(auc,2)),')',sep = '')

fig <-  plot_ly(data = pdb ,x =  ~recall, y = ~precision, type = 'scatter', mode = 'lines', fill = 'tozeroy') %>%
  add_segments(x = 0, xend = 1, y = 1, yend = 0, line = list(dash = "dash", color = 'black'),inherit = FALSE, showlegend = FALSE) %>%
  layout(title = tit, xaxis = list(title = "Recall"), yaxis = list(title = "Precision") )

fig
####################################################################
## plot imbalance problem
ggplot(prep_df[[1]], aes(PAID_STATUS, fill = PAID_STATUS))+
  geom_bar()+
  geom_text(aes(label= ..count..),
            stat = "count",
            vjust = 1.5, 
            colour = "white")+
  theme_minimal()+
  labs(
       caption = "Source : AEON_D6")+
  theme(plot.title = element_text(hjust = 0.5))
##############################################################
## Box plot importance
f <- prep_up$PMMONTHS_BK

ggplot(prep_up, aes(x=PAID_STATUS, y=PMMONTHS_BK, 
                    fill = PAID_STATUS))+
  geom_boxplot(outlier.shape = NA)+
  scale_y_continuous(limits = quantile(f, c(0.1, 0.9)))+
  theme_minimal()+
  labs(title = "PAID_STATUS BY PMMONTHS_BK",
       caption = "Source : AEON_D6")+
  theme(plot.title = element_text(hjust = 0.5))

z <- prep_up[f > quantile(f, .25) - 1.5*IQR(f) & 
               f < quantile(f, .75) + 1.5*IQR(f), ]
  

## bar plot importance
prep_up <- ovun.sample(PAID_STATUS~.,
                       data = prep, 
                       method = "over",
                       N = 285233*2)$data

ggplot(prep_up, aes(PAID_STATUS,fill = OS_BALANCE))+
  geom_bar(position = "dodge")+
  labs(x="PAID_STATUS",
       y="COUNT",
       title = "PAID_STATUS BY OS_BALANCE")+
  theme_update(plot.title = element_text(hjust = 0.5))+
  theme_minimal()

data_scale <- scale(prep$PRINCIPLE)


