#Clustering of Housing_Prices data
#mlKmeans returns a list with cluster assignment

x = read.csv("/path/selected_features.csv")
x[,1]
as.matrix(x)
mlKmeans(x,2)

#Syntax
#data(trees, package="datasets")
#mlKmeans(t(trees),3)



