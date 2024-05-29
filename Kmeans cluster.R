install.packages("tidyverse")
install.packages("cluster")
install.packages("factoerxtra")
library(tidyverse)
library(cluster)
library(factoextra)
library(gridExtra)
theme_set(theme_bw())

#read the data - built-in R dataset
df = USArrests
df

#removing any missing value
df <- na.omit(df)

#scaling/standardizing the data
df = scale(df)
head(df)

#calculating and visualizing the distance matrix using the functions get_dist and fviz_dist from the factoextra R package
distance = get_dist(df)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

#clustering - K-means clustering
# Using K-means algorithm: grouping the data into 2 clusters (where the number of clusters (k) must be set before starting the algorithm)
k2 = kmeans(df, centers = 2, nstart = 25)
str(k2)

#printing the result
k2

#visualizing the result above,
fviz_cluster(k2, data = df)

#Alternatively, we can also use a standard pairwise scatter plots to illustrate the clusters compared to the original variables
#this can be done as follows
df %>%
  as_tibble() %>%
  mutate(cluster = k2$cluster,
         state = row.names(USArrests)) %>%
  ggplot(aes(UrbanPop, Murder, color = factor(cluster), label = state)) +
  geom_text()

#using different values of K to examine the differences in results, we execute the same process for k = 3, 4, 5 clusters
k3 = kmeans(df, centers = 3, nstart = 25)
str(k3)
fviz_cluster(k3, data = df)

k4 = kmeans(df, centers = 4, nstart = 25)
str(k4)
fviz_cluster(k4, data = df)

k5 = kmeans(df, centers = 5, nstart = 25)
str(k5)
fviz_cluster(k5, data = df)

#Plotting the results to compare
p1 = fviz_cluster(k2, geom = "point", data = df) + ggtitle("k = 2")
p2 = fviz_cluster(k3, geom = "point", data = df) + ggtitle("k = 3")
p3 = fviz_cluster(k4, geom = "point", data = df) + ggtitle("k = 4")
p4 = fviz_cluster(k5, geom = "point", data = df) + ggtitle("k = 5")

grid.arrange(p1, p2, p3, p4, nrow = 2)

#determining the optimal number of clusters
#using ELBOW METHOD:
set.seed(123)

#function to compute total within-cluster sum of square
wss = function(k) {
  kmeans(df, k, nstart = 10)$tot.withinss
}

#compute and plot wss for k =1 to k = 15
k.values = 1:15

#extract wss for 2-15 clusters
wss_values = map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters K",
     ylab = "Total within-clusters sum of squares")

#NOTE: the elbow method process has been wrapped up in a single function (fviz_nbclust):
#using fviz_nbclust
set.seed(123)
fviz_nbclust(df, kmeans, method = "wss")

#using AVERAGE SILHOUETTE METHOD:
avg_sil = function(k){
  km.res = kmeans(df, centers = k, nstart = 25)
  ss = silhouette(km.res$cluster, dist(df))
  mean(ss[,3])
}

#compute and plot wss for k=2 to k=15
k.values = 2:15

#extract avg silhouette for 2-15 clusters
avg_sil_values = map_dbl(k.values, avg_sil)
plot(k.values, avg_sil_values,
     type = "b", pch = 19, frame = FALSE,
     xlab = "Number of clusters K",
     yblab= "Average Silhouettes")

#NOTE: the avg_silhouette method has been wrapped in a single function (fviz_nbclust)
#using fviz_nbclust
fviz_nbclust(df, kmeans, method = "silhouette")

 #using GAP STATISTIC METHOD:
set.seed(123)
gap_stat = clusGap(df, FUN = kmeans, nstart = 25,
                   K.max = 10, B = 50)
#print the result
print(gap_stat, method = "firstmax")
#visualizing the result
fviz_gap_stat(gap_stat)

#Extracting the results: comparing the results from the different method, we have 4 as the optimal cluster. 
#we perform the final analysis and eXract the results using 4 clusters

#compute k-means clustering with k = 4
set.seed(123)
final = kmeans(df, 4, nstart = 25)
print(final)

#visualizing the final result
fviz_cluster(final, data = df)

#NOTE: we can extract the clusters and add to our initial data to do some descriptive statistics at the cluster level
USArrests %>%
  mutate(cluster = final$cluster) %>%
  group_by(cluster) %>%
  summarise_all("mean")


