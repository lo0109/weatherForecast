#Decision Tree
library(tidyverse)
library(ggplot2)
library(ISLR)
require(tree)
library(caret)
#1.Read the dataset into a data frame
weather <- read.csv("removedNaN_for_decision_tree.csv", stringsAsFactors=TRUE)
#2.Create two sets: training (80% observations of the drug dataset) and test (20% observations of the drug dataset) sets.
training = nrow(weather)*0.8
set.seed(101)
train_tdy=sample(1:nrow(weather), training)
training_tdyset = weather[train_tdy,]
testing_tdyset = weather[-train_tdy,]

#3.Create a classification tree using the training set and calculate the classification accuracy of the tree using the test set.
#for RainToday
#train set
tree.tdy = tree(as.factor(RainToday)~Month+MinTemp+MaxTemp+Rainfall+Evaporation+Sunshine+WindGustDir+WindGustSpeed+WindDir9am+WindDir3pm+WindSpeed9am+WindSpeed3pm+Humidity9am+Humidity3pm+Pressure9am+Pressure3pm+Cloud9am+Cloud3pm+Temp9am+Temp3pm, 
                data = weather, subset = train_tdy)
plot(tree.tdy)
text(tree.tdy, pretty=0)
#predict
tree_tdy.pred = predict(tree.tdy, weather[-train_tdy,], type="class") 
cm <- caret::confusionMatrix(with(weather[-train_tdy,], table(tree_tdy.pred,RainToday)))
print(cm)

#for RainTmr
set.seed(102)
train_tmr=sample(1:nrow(weather), training)
training_tmrset = weather[train_tmr,]
testing_tmrset = weather[-train_tmr,]
#train set
tree.tmr = tree(as.factor(RainTomorrow)~Month+MinTemp+MaxTemp+Rainfall+Evaporation+Sunshine+WindGustDir+WindGustSpeed+WindDir9am+WindDir3pm+WindSpeed9am+WindSpeed3pm+Humidity9am+Humidity3pm+Pressure9am+Pressure3pm+Cloud9am+Cloud3pm+Temp9am+Temp3pm, 
                data = weather, subset = train_tmr)
plot(tree.tmr)
text(tree.tmr, pretty=0)
#predict
tree_tmr.pred = predict(tree.tmr, weather[-train_tmr,], type="class")
with(weather[-train_tmr,], table(tree_tmr.pred,RainTomorrow))
cm_tmr <- caret::confusionMatrix(with(weather[-train_tmr,], table(tree_tmr.pred,RainTomorrow)))
print(cm_tmr)
#4.Use cross-validation to prune the tree (tree from Step 3) optimally. You can use the misclassification error as the basis for pruning. Calculate the classification accuracy of the pruned tree using the test set.
cv.tmr = cv.tree(tree.tmr, FUN = prune.misclass)
cv.tmr
plot(cv.tmr)
#best class=3
prune.tmr = prune.misclass(tree.tmr, best=3)
plot(prune.tmr)
text(prune.tmr,pretty=0)
#classification accuracy
tree_tmr.pred.p = predict(prune.tmr, weather[-train_tmr,], type="class") 
with(weather[-train_tmr,], table(tree_tmr.pred.p,RainTomorrow))
cm_tmr.p <- caret::confusionMatrix(with(weather[-train_tmr,], table(tree_tmr.pred,RainTomorrow)))
print(cm_tmr.p)
#5.Predict the RainTmr
#read csv
weather_raintmr <- read.csv("RainTmr_Predict.csv", stringsAsFactors=TRUE)
tree_raintmr.pred = predict(prune.tmr, weather_raintmr, type="class")
#write csv
weather_R_raintmr <- weather_raintmr %>%
  mutate( "R_predicted_RainTomorrow" = tree_raintmr.pred)
write.csv(weather_R_raintmr,file='R_RainTmr_Predict.csv', row.names=FALSE)

#6.Predict the RainTdy
#read csv
weather_raintdy <- read.csv("RainTdy_Predict.csv", stringsAsFactors=TRUE)
tree_raintdy.pred = predict(tree.tdy, weather_raintdy, type="class")
#write csv
weather_R_raintdy <- weather_raintdy %>%
  mutate( "R_predicted_RainToday" = tree_raintdy.pred)
write.csv(weather_R_raintdy,file='R_RainTdy_Predict.csv', row.names=FALSE)
