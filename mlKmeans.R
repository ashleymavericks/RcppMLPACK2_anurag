#Clustering of Housing_Prices data
#mlKmeans returns a list with cluster assignment

x = read.csv("/home/ashleymavericks/Documents/selected_features.csv")
x[,1]
as.matrix(x)
mlKmeans(x,10)



