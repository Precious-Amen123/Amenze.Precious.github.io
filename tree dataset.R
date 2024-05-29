#Data manipulation using the tree dataset 
install.packages("dplyr")
library(dplyr)
library(ggplot2)
library(tidyr)

#using import dataset
trees
head(trees)

#count the number of trees for each species
#using groupby ()function and summary()

trees.grouped = group_by(trees, CommonName)
trees.summary = tally(trees.grouped)

#using the pipe function for simplicity and faster approach
#count the number of trees for each species with a pipe

trees.summary2 = trees %>%  #the dataframe object that will be passed in the pipe
  group_by(CommonName) %>%  #no need for naming the object, just the grouping variable
  tally() 

#Here we are first subsetting the data frame to only three species, and counting the 
#number of trees for each species, but also breaking them down by age group.

trees.subset = trees %>% 
  filter(CommonName %in% c('Common Ash', 'Rowan', 'Scots Pine')) %>% 
  group_by(CommonName, AgeGroup) %>% 
  tally()

#other functions of dplyr
summ.all = summarise_all(trees, mean) #summary_all function


#using ifelse() funtion, a conditional statement to evaluate if true or false

vector = c(4,13,15,6) #creating a vector to evaluate
ifelse(vector<10, "A", "B") #gives the conditions

#case_when function - for re-classifying values or factors.
#The super useful case_when() is a generalisation of ifelse() that lets you assign
#more than two outcomes. All logical operators are available, and you assign the new value with a tilde ~.

vector2 = c("What am I?", "A", "B", "C", "D")

case_when(vector2 == "What am I?" ~ "I am the walrus",
          vector2 %in% c("A", "B") ~ "goo",
          vector2 == "C" ~ "ga",
          vector2 == "D" ~ "joob")


#changing factor levels or create categorical variables

unique(trees$LatinName) #shows all the species names

#The use of mutate() together with case_when() is a great way to change the names 
#of factor levels, or create a new variable based on existing ones.
#create a new column with the tree genera
#grepl() function is character string search function which looks
#for patterns in the data and specify what to return for each data.

trees.genus = trees %>% 
  mutate(Genus = case_when(
# creates the genus column and specifies conditions
    grepl("Acer", LatinName) ~ "Acer",            
    grepl("Fraxinus", LatinName) ~ "Fraxinus", 
    grepl("Sorbus", LatinName) ~ "Sorbus", 
    grepl("Betula", LatinName) ~ "Betula", 
    grepl("Populus", LatinName) ~ "Populus", 
    grepl("Laburnum", LatinName) ~ "Laburnum", 
    grepl("Aesculus", LatinName) ~ "Aesculus", 
    grepl("Fagus", LatinName) ~ "Fagus", 
    grepl("Prunus", LatinName) ~ "Prunus", 
    grepl("Pinus", LatinName) ~ "Pinus", 
    grepl("Sambucus", LatinName) ~ "Sambucus", 
    grepl("Crataegus", LatinName) ~ "Crataegus", 
    grepl("Ilex", LatinName) ~ "Ilex", 
    grepl("Quercus", LatinName) ~ "Quercus", 
    grepl("Larix", LatinName) ~ "Larix", 
    grepl("Salix", LatinName) ~ "Salix", 
    grepl("Alnus", LatinName) ~ "Alnus")
  )

#simpler method of approach
# we're creating two new columns in a vector (genus name and species name), 
#"sep" refers to the separator, here space between the words, and remove = FALSE
#means that we want to keep the original column LatinName in the data frame

tree.genus.2 = trees %>% 
  tidyr::separate(LatinName, c("Genus", "Species"),
                  sep = " ", remove = FALSE) %>% 
  dplyr::select(-Species)


#reclassifying the height factor level

trees.genus = trees.genus %>%   #overwriting a dataframe
  mutate(Height.cat =           #creating a new column
           case_when(Height %in% c("Up to 5 meters", "5 to 10 meters") ~ "Short",
                     Height %in% c("10 to 15 meters","15 to 20 meters") ~ "Medium",
                     Height == "20 to 25 meters" ~ "Tall"))

#Reordering a factor levels

levels(trees.genus$Height.cat) # shows the different factor levels in their default order

trees.genus$Height.cat <- factor(trees.genus$Height.cat, 
                                 levels = c('Short', 'Medium', 'Tall'),
                                 labels = c('SHORT', 'MEDIUM', 'TALL'))
levels(trees.genus$Height.cat) # a new order and new names for the levels


#Advanced piping in dplyr

#subset dataframe to fewer genera

trees.five = trees.genus %>% 
  filter(Genus %in% c("Acer", "Fraxinus", "Salix", "Aesculus", "Pinus"))

#Map all the trees to see how they are distributed

(map.all = ggplot(trees.five) +
    geom_point(aes(x = Easting, y = Northing, size = Height.cat, colour = Genus), alpha = 0.5) +
    theme_bw() +
    theme(panel.grid = element_blank(),
          axis.text = element_text((size = 12)),
          legend.text = element_text(size = 12))
)


# Plotting a map for each genus using do() function and data() function

trees.plot = trees.five %>%  #the dataframe
  group_by(Genus) %>%    #grouping by genus
  do(plots =   #the pkotting call within the do function
       ggplot(data = .)+
       geom_point(aes(x = Easting, y = Northing, size = Height.cat), alpha = 0.5)+
       labs(title = paste("Map of", .$Genus, "at Craigmillar Castle", sep = " "))+
       theme_bw() + 
       theme(panel.grid = element_blank(), 
             axis.text = element_text(size = 14), 
             legend.text = element_text(size = 12), 
             plot.title = element_text(hjust = 0.5), 
             legend.position = "bottom")
  )
  
# You can view the graphs before saving them 
trees.plot$plots 


#using Craigmillar Castle in Genus for further EDA

# Calculate the quadrants # Find the center coordinates that will divide the 
#data (adding half of the range in longitude and latitude to the smallest value)

lon <- (max(trees.genus$Easting) - min(trees.genus$Easting))/2 + min(trees.genus$Easting)
lat <- (max(trees.genus$Northing) - min(trees.genus$Northing))/2 + min(trees.genus$Northing)

# Create the column

trees.genus <- trees.genus %>% 
  mutate(Quadrant = case_when(
    Easting < lon & Northing > lat ~ 'NW', 
    Easting < lon & Northing < lat ~ 'SW', 
    Easting > lon & Northing > lat ~ 'NE', 
    Easting > lon & Northing < lat ~ 'SE')
  )

# We can check that it worked 
ggplot(trees.genus) + 
  geom_point(aes(x = Easting, y = Northing, colour = Quadrant)) + 
  theme_bw()

#to remove the NA value 
trees.genus <- trees.genus %>% 
  mutate(Quadrant = case_when( 
    Easting <= lon & Northing > lat ~ 'NW', # using inferior OR EQUAL ensures that no point is forgotten 
    Easting <= lon & Northing < lat ~ 'SW',
    Easting > lon & Northing > lat ~ 'NE', 
    Easting > lon & Northing < lat ~ 'SE') 
  )

# We can check that it worked 
ggplot(trees.genus) + 
  geom_point(aes(x = Easting, y = Northing, colour = Quadrant)) + 
  theme_bw()

#1. Calculate the species richness (e.g. the number of different species) in each quadrant?

sp.richness <- trees.genus %>% 
  group_by(Quadrant) %>% 
  summarise(richness = length(unique(LatinName)))

#2. They would also like to know how abundant the genus Acer is (as a % of the total number of trees) 
#in each quadrant.

acer.percent <- trees.genus %>% 
  group_by(Quadrant, Genus) %>% 
  tally() %>%                    # get the count of trees in each quadrant x genus 
  group_by(Quadrant) %>%          # regroup only by quadrant 
  mutate(total = sum(n)) %>%      # sum the total of trees in a new column 
  filter(Genus == 'Acer') %>%     # keep only acer 
  mutate(percent = n/total)       # calculate the proportion

# We can make a plot representing the %

ggplot(acer.percent) + 
  geom_col(aes(x = Quadrant, y = percent)) + 
  labs(x = 'Quadrant', y = 'Proportion of Acer') + 
  theme_bw()

#3. Finally, they would like, for each quadrant separately, a bar plot showing counts 
#of Acer trees in the different age classes, ordered so they read from Young 
#(lumping together juvenile and semi-mature trees), Middle Aged, and Mature.

# Create an Acer-only data frame
acer <- trees.genus %>% 
  filter(Genus == 'Acer')

# Rename and reorder age factor 
acer$AgeGroup <- factor(acer$AgeGroup, 
                        levels = c('Juvenile', 'Semi-mature', 'Middle Aged', 'Mature'),
                        labels = c('Young', 'Young', 'Middle Aged', 'Mature'))

# Plot the graphs for each quadrant

acer.plots <- acer %>% 
  group_by(Quadrant) %>% 
  do(plots = # the plotting call within the do function 
       ggplot(data = .) + geom_bar(aes(x = AgeGroup)) + 
       labs(title = paste('Age distribution of Acer in ', .$Quadrant, ' corner', sep = ''),
            x = 'Age group', y = 'Number of trees') + 
       theme_bw() + 
       theme(panel.grid = element_blank(), 
             axis.title = element_text(size = 14),
             axis.text = element_text(size = 14), 
             plot.title = element_text(hjust = 0.5)) 
     )

# View the plots (use the arrows on the Plots viewer) 
acer.plots$plots
