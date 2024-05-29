set.seed(1234)
# Read the data

#Mall_Customers
#Mall_Customers$CustomerID = NULL
#str(Mall_Customers)

# EDA


mall = Mall_Customers
mall

summary(mall)
str(mall)
any(is.na(mall))

mall$CustomerID = NULL #converting he column to null
str(mall)

# seperating the gender
mall_gen = Mall_Customers$Genre
mall_gen

#seperating the gender column
mall_gender = mall$Genre

# convert the gender column to null
mall$Genre = NULL

# Normalizing the data
mall_sc = as.data.frame(scale(mall))
mall_sc

# using euclidean method, build a distnce
mall_dist = dist(mall_sc, method = 'euclidean')


# using average linkage method of hierarchy clustering
hclust_mall = hclust(mall_dist, method = 'average')

# plotting the dendrogram
plot(hclust_mall)

# cutting the dendrogram
cut_mall = cutree(hclust_mall, k = 3)
cut_mall

plot(hclust_mall)
rect.hclust(hclust_mall, k = 3, border = 2.6)
abline(h = 3, col = 'red')

#OR

# we can also determine the optimal number of clusters using barplot
barplot(hclust_mall$height,
        names.arg = (nrow(hclust_mall))
)

# Appending the final result to the original dataframe
mall_clust = mutate(mall, cluster = cut_mall)
count(mall_clust, cluster)

# Cluster identity
cluster_identiy = data.frame(rename=c(1,2,3),
                             categories=c("Lower Income and Spending",
                             "Average Income and Spending",
                             "Higher Income and Spending"))

# cross-check the label for the clusters
table(mall_clust$cluster, mall_gen)