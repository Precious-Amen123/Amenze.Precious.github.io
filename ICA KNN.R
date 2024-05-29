#Install Packages
install.packages("class")
install.packages("caret")
library('class')
library('caret')

#Import data
loan = read.csv("C:/Users/otasp/Desktop/CIS4047 DATA SCIENCE FOUNDATION/credit_data.csv")

#structure of dataset
str(loan)

#Data cleansing - removing the unwanted variables
loan.subset = loan[c("Creditability","Age..years.","Sex...Marital.Status","Occupation","Account.Balance","Credit.Amount","Length.of.current.employment","Purpose")]

#structure of new dataset
str(loan.subset)

#Data Normalization so that the output remains unbiased
head(loan.subset)
#from the dataset, credit.amount is in 4 digits while others are in single or double digt. To attain an unbiased dataset, we use normalise function
normalize = function(x) {return((x - min(x)) / (max(x) - min(x))) }

#In the below code snippet, we’re storing the normalized data set in the ‘loan.subset.n’
#variable and also we’re removing the ‘Credibility’ variable since it’s the response variable
#that needs to be predicted.
loan.subset.n = as.data.frame(lapply(loan.subset[,2:8], normalize))
head(loan.subset.n)

#Data slicing
set.seed(123)
dat.d = sample(1:nrow(loan.subset.n), size = nrow(loan.subset.n)*0.7, replace = FALSE)
train.loan = loan.subset[dat.d,]
test.loan = loan.subset[-dat.d,]

#creating a seperate dataframe for 'credibility' with is our dependent variable
train.loan_labels = loan.subset[dat.d, 1]
test.loan_labels = loan.subset[-dat.d, 1]

#Building a Machine learning model
NROW(train.loan_labels)

#Taking the square root of 700, we have 26.45. let's make K = 26 and K = 27
knn.26 = knn(train = train.loan, test = test.loan, cl = train.loan_labels, k=26)
knn.27 = knn(train = train.loan, test = test.loan, cl = train.loan_labels, k=27)

#Model Evaluation - calculating the accuracy of the created models. Calculating the proportion of correct classification for k = 26, 27
ACC.26 = 100 * sum(test.loan_labels == knn.26)/NROW(test.loan_labels)
ACC.27 = 100 * sum(test.loan_labels == knn.27)/NROW(test.loan_labels)

#check predicted actual value in tabular form for k=26
table(knn.26, test.loan_labels)
knn.26

#check the predicted actual value in tabular form for k=27
table(knn.27, test.loan_labels)
knn.27

#Using ConfusuionMatrix to calculate the accuracy of KNN model with K value set to 26
confusionMatrix(table(knn.26, test.loan_labels))
confusionMatrix(table(knn.27, test.loan_labels))

#Optimization
i=1
k.optm=1
for (i in 1:28){knn.mod = knn(train = train.loan, test = test.loan, cl = train.loan_labels, k=i) 
k.optm[i] = 100 * sum(test.loan_labels == knn.mod)/NROW(test.loan_labels) 
k=i 
cat(k,'=',k.optm[i],' ')}

#From the output, maximum accuracy is 69%. Let's represent graphically.
plot(k.optm, type = "b", xlab = "k-value", ylab = "Accuracy Level")

