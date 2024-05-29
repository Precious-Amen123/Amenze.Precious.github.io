#Install Packages
install.packages("caret")
install.packages("readr")

#Accessing Libraries
library(caret)
library(readr)

#Loading dataset
Stroke <- read.csv("C:/Users/otasp/Desktop/CIS4047 DATA SCIENCE FOUNDATION/stroke_data.csv",sep =',', header = FALSE)

#Check structure of dataset
str(Stroke)
