

set.seed(786)

# Read the dataset which is in txt format
file_loc = 'C:/Users/c2245096/OneDrive - Teesside University/SEMESTER THREE/seeds_dataset.txt'

# Convert the dataset from txt to csv, taking note of the header as FALSE
seeds_df = read.csv(file_loc,sep = '\t',header = FALSE)

# The dataset is without column names: rename columns from the data description
feature_name = c('area', 'perimeter', 'compactness', 'length.of.kernel', 'width.of.kernel',
                 'asymmetry.coefficient','length.of.kernel.groove', 'type.of.seed')
colnames(seeds_df) = feature_name

# STructure of data
str(seeds_df)

# Summary of data
summary(seeds_df)

# Checking for NA
any(is.na(seeds_df))
sum(is.na(seeds_df))

# Removing the NAs 
seeds_df = na.omit(seeds_df)
seeds_df
any(is.na(seeds_df))

# From the dataset, there is a labeled colum. we seperate and exclude the column from the dataset
# so we can cluster.
seeds_label = seeds_df$type.of.seed # seperating the labelled column 

seeds_df$type.of.seed = NULL # converting the column to NULL
str(seeds_df)

# Standardizing the data using the scale() function
seeds_df_sc = as.data.frame(scale(seeds_df))
seeds_df_sc

# Build a Distance Matrix -all the values are continuous numerical, so we use the euclidean method
dist_mat = dist(seeds_df_sc, method = 'euclidean')

# Using the average linkage method of hierarchical clustering
hclust_avg = hclust(dist_mat, method = 'average')

# Plotting the dendrogram
plot(hclust_avg)

# You cut the dendrogram in order to create the desired number of clusters. from the dendrogram, k=3 or h=3
# the clusters are grouped into 3 (from the height)
cut_avg = cutree(hclust_avg, k = 3)

# To visually represent the clusters in the dendrogram, use abline() function to draw the cut line
# and superimpose rectangular compartments for each cluster on the tree with the rect.hclust() function
plot(hclust_avg)
rect.hclust(hclust_avg, k = 3, border = 2.6)
abline(h = 3, col = 'red')

# Additionally, you can visualize the tree with different colour branches using the color_branches() function
# from the dendextend library
avg_dend_obj = as.dendrogram(hclust_avg)
avg_col_dend = color_branches(avg_dend_obj, h=3)
plot(avg_col_dend)

# Appending the cluster results back in the orignal dataframe
seed_df_cl = mutate(seeds_df, cluster = cut_avg) # adding the original dataframe with the cluster results
count(seed_df_cl, cluster) # counts the number of observation in each cluster

# Creating a scatter plot of the variables (optional)
ggplot(seed_df_cl, aes(x=area, y = perimeter, color = factor(cluster))) + geom_point()


# Finally, cross-check the cluster results with the true label from the original dataset using the table() function
table(seed_df_cl$cluster, seeds_label)

# NOTE: they tally. Thank you