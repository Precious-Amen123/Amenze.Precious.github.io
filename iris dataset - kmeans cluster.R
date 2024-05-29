# Packages and Library used are dlpyr, ggplot2, ggfortity

# Load the in-built dataset (iris)
iris = iris
iris

summary(iris)
head(iris)

# Eliminating the target variable/column
data = select(iris, c(1:4))
data

# Determining the best value of k - using the Elbow point method
set.seed(1234)
bss_iris = numeric()
wss_iris = numeric()

# Run the algorithm for different values of k
set.seed(1234)
for(i in 1:4){
  # For each k, calculate betweens and tot.withinss
  bss_iris[i] = kmeans(data, centers = i)$betweenss
  wss_iris[i] = kmeans(data, centers = i)$tot.withinss
}

# Plot bss vs choice of k
p1 = qplot(1:4, bss_iris, geom = c("point", "line"),
           xlab = "Number of clusters", ylab = "Between-cluster sum of squares")+
  scale_x_continuous(breaks = seq(0, 4, 1))+
  theme_bw()

# Plot wss vs choice of k
p2 = qplot(1:4, wss_iris, geom = c("point", "line"),
           xlab = "Number of clusters", ylab = "Total within-cluster sum of squares")+
  scale_x_continuous(breaks = seq(0, 4, 1))+
  theme_bw()

# SUbplot
grid.arrange(p1, p2, ncol(2))
# NOTE: FROM THE PLOT, USING THE ELBOW CRITERION/METHOD, THE APPROPRIATE VALUE FOR K = 2

# OR

#using ELBOW METHOD:
set.seed(1234)

#function to compute total within-cluster sum of square
wss_iris2 = function(k) {
  kmeans(df, k, nstart = 4)$tot.withinss
}

#compute and plot wss for k =1 to k = 15
k.values_iris = 1:4

#extract wss for 2-15 clusters
wss_values_iris = map_dbl(k.values_iris, wss_iris2)

plot(k.values_iris, wss_values_iris,
     type="b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters K",
     ylab = "Total within-clusters sum of squares")

#NOTE: the elbow method process has been wrapped up in a single function (fviz_nbclust):
#using fviz_nbclust
set.seed(1234)
fviz_nbclust(data, kmeans, method = "wss")

# NOTE: FROM THE PLOT, USING THE ELBOW CRITERION/METHOD, THE APPROPRIATE VALUE FOR K = 2

# OR

# Another computation elbow
wssplot = function(data, nc=15, seed=1234){
  wss = (nrow(data)-1)*sum(apply(data,2,var))
  for (i in 2:nc){
    set.seed(seed)
    wss[i] = sum(kmeans(data, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="Number of Clusters",
       ylab="Within groups sum of squares")
}

# IMPLEMENTING K-MEANS
set.seed(1234)
kmean = kmeans(data, 2)
print(kmean)

kmean$centers

#visualizing the final result
fviz_cluster(kmean, data = data)

# OR

autoplot(kmean, data, frame = TRUE)


# FOR COMPARISON, k = 3
kmean_3 = kmeans(data, 3)
print(kmean_3)

kmean_3$centers

#visualizing the result
fviz_cluster(kmean_3, data = data)

# OR

autoplot(kmean_3, data, frame = TRUE)
