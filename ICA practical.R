#Install Packages
install.packages("caret")
install.packages("readr")

#Accessing Libraries
library(caret)
library(readr)

#Loading dataset
heart <- read.csv("C:/Users/otasp/Desktop/CIS4047 DATA SCIENCE FOUNDATION/heart_disease.csv",sep =',', header = FALSE)

#check structure of dataset
str(heart)

#Split the data into training set and testing set also called Splitting
intrain <- createDataPartition(y = heart$V14, p= 0.7, list = FALSE)
training <- heart[intrain,]
testing <- heart[-intrain,]

#dimensions of dataset
dim(training)
dim(testing)

#cleaning the dataset using the anyNA method
anyNA(heart)

#checking the summary of the dataset using summary() function
summary(heart)

#To convert categorical variable v14 to factor variable
training[["V14"]] = factor(training[["V14"]])

#We now train our model
#using trainControl() method
trctrl = trainControl(method = "repeatedcv", number = 10, repeats = 3)

#before starting, lets install a package
install.packages("e1071")

#Using SVM 
svm_linear = train(V14 ~., data = training, method = "svmLinear", trControl=trctrl, preProcess = c("center", "scale"), tuneLength = 10)
svm_linear

#Using predict() method
test_pred = predict(svm_linear, newdata = testing)
test_pred

#checking for accuracy of the model
confusionMatrix(table(test_pred, testing$V14))

#Building svmlinear Classifier
grid = expand.grid(C = c(0, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 5))

svm_linear_Grid = train(V14 ~., data = training, method = "svmLinear", trControl=trctrl, preProcess = c("center", "scale"), tuneGrid = grid, tuneLength = 10)
svm_linear_Grid

#plotting grid
plot(svm_linear_Grid)

#making predictions using the model for test set
test_pred_grid = predict(svm_linear_Grid, newdata = testing)
test_pred_grid

#check accuracy using confusion matrix
confusionMatrix(table(test_pred_grid, testing$V14))
