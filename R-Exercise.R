install.packages("dplyr")
library(dplyr)

edidiv = read.csv("C:/Users/c2245096/OneDrive - Teesside University/MACHINE LEARNING/WEEK 2/edidiv.csv")
head(edidiv)
tail(edidiv)
str(edidiv)

head(edidiv$taxonGroup)
class(edidiv$taxonGroup)

edidiv$taxonGroup = as.factor(edidiv$taxonGroup)
summary(edidiv$taxonGroup)

dim(edidiv)
summary(edidiv)

#calculating the Species Richness
#first, create object for each taxon

Beetle = filter(edidiv, taxonGroup == "Beetle")
Bird = filter(edidiv, taxonGroup == "Bird")
Butterfly = filter(edidiv, taxonGroup == "Butterfly")
Dragonfly = filter(edidiv, taxonGroup == "Dragonfly")
Flowering_Plants = filter(edidiv, taxonGroup == "Flowering.Plants")
Fungus = filter(edidiv, taxonGroup =="Fungus")
Hymenopteran = filter(edidiv, taxonGroup =="Hymenopteran")
Lichen  = filter(edidiv, taxonGroup == "Lichen")
Liverwort = filter(edidiv, taxonGroup == "Liverwort")
Mammal = filter(edidiv, taxonGroup == "Mammal")
Mollusc = filter(edidiv, taxonGroup == "Mollusc")

#second, calculate the number of different species in each group 
#using the unique() and length() functions. the unique() function identifies 
#the different species and length() counts them.

a = length(unique(Beetle$taxonName))
b = length(unique(Bird$taxonName))
c = length(unique(Butterfly$taxonName))
d = length(unique(Dragonfly$taxonName))
e = length(unique(Flowering_Plants$taxonName))
f = length(unique(Fungus$taxonName))
g = length(unique(Hymenopteran$taxonName))
h = length(unique(Lichen$taxonName))
i = length(unique(Liverwort$taxonName))
j = length(unique(Mammal$taxonName))
k = length(unique(Mollusc$taxonName))

#create a vector using the c() function, that is, to concatenate or chain all
#the values together. OR
#we use names() function to add label or chain the values together

biodiv = c(a,b,c,d,e,f,g,h,i,j,k)

names(biodiv) = c("Bettle",
                  "Bird",
                  "Butterfly",
                  "Dragonfly",
                  "Flowering_Plants",
                  "Fungus",
                  "Hymenopteran",
                  "Lichen",
                  "Liverwort",
                  "Mammal",
                  "Mollusc")

#visualize species richness with the barplot() function
#using help() function to see what argument you need to add in.

help("barplot")
help("par")

png("barplot.png", width = 1600, height = 600) #customize the size and resolution of the image

#the cex code increases the font size when greater than one and 
#decreases it when lesser than one.

barplot(biodiv, xlab="Taxa", ylab="Number of Species", ylim=c(0,600), cex.axis = 1.5,
        cex.names = 1.5, cex.lab=1.5)
dev.off() #this function opens and shut down the plotting device


#creating a dataframe and plotting it
taxa = c("Bettle",
         "Bird",
         "Butterfly",
         "Dragonfly",
         "Flowering_Plants",
         "Fungus",
         "Hymenopteran",
         "Lichen",
         "Liverwort",
         "Mammal",
         "Mollusc")

#convert into a factor, i.e a categorical variable
taxa_f = as.factor((taxa))

#combining all the values for the number of the species in an object
richness = c(a,b,c,d,e,f,g,h,i,j,k)

#creating the dataframe from the two vectors
biodata = data.frame(taxa_f, richness)

#saving the file
write.csv(biodata, file = "biodata.csv")

#create and save a barplot using png() function and specifying the columns
#from the dataframe

png("barplot2.png", width=1600, height=600)
barplot(biodata$richness, names.arg = c("Bettle",
                                        "Bird",
                                        "Butterfly",
                                        "Dragonfly",
                                        "Flowering_Plants",
                                        "Fungus",
                                        "Hymenopteran",
                                        "Lichen",
                                        "Liverwort",
                                        "Mammal",
                                        "Mollusc"),
        xlab="Taxa", ylab="Number of species", ylim=c(0,600))
dev.off()


#personal exercise

bird_sp = c("sparrow",
         "kingfisher",
         "eagle",
         "hummingbird",
         "sparrow",
         "kingfisher",
         "eagle",
         "hummingbird",
         "sparrow",
         "kingfisher",
         "eagle",
         "hummingbird")
bird_species = as.factor(bird_sp)

wingspan = c(22, 26, 195, 8, 24, 23, 201, 9, 21, 25, 185, 9)

bird_wing = data.frame(bird_species, wingspan)

sparrow = mean(22,24,21)
kingfisher = mean(26,23,25)
eagle = mean(195,201,185)
hummingbird = mean(8,9,9)

wingspan2 = c(sparrow, kingfisher, eagle, hummingbird)

bird_sp2 = c("sparrow",
              "kingfisher",
              "eagle",
              "hummingbird")

class(bird_sp2)             
bird_sp2 = as.factor(bird_sp2)
class(bird_sp2)

wings = data.frame(bird_sp2, wingspan2)

png("wingspan plot.png", width=800, height=600)
barplot(wings$wingspan2, names.arg = wings$bird_sp2, xlab="Bird Species", ylab="Average wingspan (cm)",
        ylim=c(0,200), col="gold")
#using names.arg to specify the column
dev.off()