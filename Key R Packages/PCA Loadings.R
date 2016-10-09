data(mtcars)
str(mtcars)
head(mtcars)
pca = prcomp(mtcars, center = T, scale = T)
names(pca)
summary(pca)
# Loading plot
plot(pca$rotation[,1], pca$rotation[,2],
     xlim = c(-1,1), ylim = c(-1,1),
     main = "Loadings for PC1 vs. PC2")