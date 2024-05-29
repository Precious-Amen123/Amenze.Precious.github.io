# Load data

df = USArrests
df  # Note: the data has been scaled from previous exercise done on kmeans clustering

head(df)

# To perform hierarchical clustering, we do  not know the method that will produce the best clusters
# In this case, we use the agnes() function to perform hierarchical clustering using several different methods

# First, define the linkage methods
m = c( "average", "single", "complete", "ward")
names(m) = c( "average", "single", "complete", "ward")

#function to compute agglomerative coefficient
ac = function(x) {
  agnes(df, method = x)$ac
}

#calculate agglomerative coefficient for each clustering linkage method
sapply(m, ac)

# The result shows that ward's minimum variance method produces the highest agglomerative coeeficient.
# Thus we shall be using ward as our final hierarchical clustering method

# using ward's minimum variance
clust = agnes(df, method = 'ward')
clust

# plotting a dendrogram
pltree(clust, cex = 0.6, hang = -1, main = "Dendrogram")

#using GAP STATISTIC METHOD to determine the optimal number of clusters
set.seed(123)
gap_stat = clusGap(df, FUN = kmeans, nstart = 25,
                   K.max = 10, B = 50)
#print the result
print(gap_stat, method = "firstmax")
#visualizing the result
fviz_gap_stat(gap_stat)

# Applying cluster labels to original dataset
d = dist(df, method = 'euclidean')

# perform hclustering using ward's method
final_clust = hclust(d, method = 'ward.D2')

# cut the denrogram into 4 clusters
groups= cutree(final_clust, k=4)
table(groups)

# append cluster label with original data
final_data = cbind(USArrests, cluster = groups)
head(final_data)

#find mean values for each cluster
aggregate(final_data, by=list(cluster=final_data$cluster), mean)

