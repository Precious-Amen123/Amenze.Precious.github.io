# Read the built-in dataset
cars = mtcars
cars

# structure and checking for NA
str(cars)
any(is.na(cars))

# Scaling the dataset
cars_sc = as.data.frame(scale(cars))
cars_sc

# Build a distance
cars_dist = dist(cars_sc, method = 'euclidean')
cars_dist

# fitting the heirarchical clustering model to the training data 
# using average linkage method
set.seed(1234)
cars_cl = hclust(cars_dist, method = 'average')
cars_cl

# Plotting dendrogram
plot(cars_cl)

rect.hclust(cars_cl, k = 5, border = "green")

# Visually represent
abline(h = 5, col = 'green')

# You cut the dendrogram in order to create the desired number of clusters. from the dendrogram, k=5 or h=5
# the clusters are grouped into 5 (from the height)
cut_cars_cl = cutree(cars_cl, k = 5)
table(cut_cars_cl)


#append the dataset
final_data_cars = cbind(cars, cluster = cut_cars_cl)
head(final_data_cars)