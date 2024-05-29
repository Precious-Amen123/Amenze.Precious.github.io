#Libraries used are tidyverse, corrplot, gridExtra, GGally, knitr

# Read the stats
wine.clustering
wines = wine.clustering
wines

# Getting an idea of what we are working with
# First rows
kable(head(wines))

# DATA ANALYSIS - we first explore and VISUALIZE THE DATA (EDA)

# Histogram for each attribute
wines %>%
  gather(Attributes, value, 1:13) %>%
  ggplot(aes(x=value, fill=Attributes))+
  geom_histogram(colour="black", show.legend = FALSE)+
  facet_wrap(~Attributes, scales = "free_x")+
  labs(x="Values", y="Frequency", title = "Wines Attributes - Histograms")+
  theme_bw()
corr
# Density plot for each attribute
wines %>%
  gather(Attributes, value, 1:13) %>%
  ggplot(aes(x=value, fill=Attributes))+
  geom_density(colour="black", alpha=0.5, show.legend = FALSE)+
  facet_wrap(~Attributes, scales = "free_x")+
  labs(x="Values", y="Density", title = "Wines Attributes - Histograms")+
  theme_bw()

# Boxplot for each attribute
wines %>%
  gather(Attributes, values, c(1:4, 6:12)) %>%
  ggplot(aes(x=reorder(Attributes, values, FUN = median), y=values, fill=Attributes))+
  geom_boxplot(show.legend = FALSE)+
  labs(title = "Wines Attribues - Boxplots")+
  theme_bw() +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank())+
  ylim(0, 35) +
  coord_flip()

#NOTE: magnesium and proline were not included because they have very high values that
#will worsen the visualization(showing outliers)

# Using correlation matrix to show the relationship btw the different attributes
corrplot(cor(wines), type = "upper", method = "ellipse", tl.cex = 0.9)

#From the corrplot, there is a strong linear correlation (equation of a straight line:y=mx+c) between Total_Phenols and 
#Flavanoids. We can model the relationship between these two variables by fitting a linear equation.

# Relationship between Phenols and Flavanoids 
ggplot(wines, aes(x=Total_Phenols, y=Flavanoids)) + 
  geom_point() +
  geom_smooth(method="lm", se=FALSE) + 
  labs(title="Wines Attributes", subtitle="Relationship between Phenols and Flavanoids") + 
  theme_bw()

# DATA PREPARATION
# Normalize the data: normalization means adjusting values measured on different scales to a common scale

# Normalization
winesNorm = as.data.frame(scale(wines))

# Plotting the original data and normalized data
p1 = ggplot(wines, aes(x=Alcohol, y=Malic_Acid))+
  geom_point()+
  labs(title="Original data")+
  theme_bw()

p2 = ggplot(winesNorm, aes(x=Alcohol, y=Malic_Acid))+
  geom_point()+
  labs(title="Normalized data")+
  theme_bw()

# Subplot
grid.arrange(p1, p2, ncol(2))

# NOTE: THE POINTS IN THE NORMALIZED DATA ARE THE SAME AS THE ORIGINAL ONE, TH EONLY THING THAT CHANGES IS THE SCALE OF THE AXIS

# K-MEANS EXECUCTION - Executing the k-means algorithm and analyse the main components that the function returns
# k=2
set.seed(1234)
wines_k2 = kmeans(winesNorm, centers = 2)

# Knowing the cluster to which each point is allocated
wines_k2$cluster

# Knowing the cluster centers
wines_k2$centers

# Cluster size
wines_k2$size

# Between-cluster sum of squares
wines_k2$betweenss

# Within-cluster sum of squares
wines_k2$withinss

# Total within-cluster sum of squares
wines_k2$tot.withinss

# Total sum of squares
wines_k2$totss

# HOW MANY CLUSTERS
# To study graphically which value of k gives the best partition, we can plot betweens and tot.withinss vs choice of k

bss = numeric()
wss = numeric()

# Run the algorithm for different values of k
set.seed(1234)
for(i in 1:10){
  # For each k, calculate betweens and tot.withinss
  bss[i] = kmeans(winesNorm, centers = i)$betweenss
  wss[i] = kmeans(winesNorm, centers = i)$tot.withinss
}

# Plot bss vs choice of k
p3 = qplot(1:10, bss, geom = c("point", "line"),
           xlab = "Number of clusters", ylab = "Between-cluster sum of squares")+
  scale_x_continuous(breaks = seq(0, 10, 1))+
  theme_bw()

# Plot wss vs choice of k
p4 = qplot(1:10, wss, geom = c("point", "line"),
           xlab = "Number of clusters", ylab = "Total within-cluster sum of squares")+
  scale_x_continuous(breaks = seq(0, 10, 1))+
  theme_bw()

# SUbplot
grid.arrange(p3, p4, ncol(2))
# NOTE: FROM THE PLOT, USING THE ELBOW CRITERION/METHOD, THE APPROPRIATE VALUE FOR K = 3

# RESULTS - k=3
set.seed(1234)
wines_k3 = kmeans(winesNorm, centers = 3)
print(wines_k3)

#visualizing the final result
fviz_cluster(wines_k3, data = winesNorm)

# Mean values of each cluster
aggregate(wines, by=list(wines_k3$cluster), mean)

# Visualizing the Cluster
ggpairs(cbind(wines, Cluster=as.factor(wines_k3$cluster)), 
        columns=1:6, aes(colour=Cluster, alpha=0.5), 
        lower=list(continuous="points"), 
        upper=list(continuous="blank"), 
        axisLabels="none", switch="both") +
  theme_bw()
