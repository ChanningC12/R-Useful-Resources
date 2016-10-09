## Getting help
# Get help of particular function
?mean
# Search the help files for a word or phrase
help.search("weighted mean")
# Find help for a package
help(package = "dplyr")

# Get a summary of an object's structure
str(iris)
# Find the class an object belongs to
class(iris)

## Using libraries
install.packages("dplyr")
library(dplyr)
# use a particular function from a pacakge
dplyr::select
# load a build-in dataset into the environment
data(iris)

# Working Directory
getwd()
sedwd("../Desktop/")

# Vectors
c(2,4,6)
2:6
seq(2,3,by=0.5)
rep(1:2,times=3)
rep(1:2,each=3)

# Vector functions
sort(rep(1:2,times=3))
rev(2:6)
table(rep(1:2,times=3))
unique(rep(1:2,times=3))

## Selecting Vecotr Elements
# by position
rev(2:6)[4]
rev(2:6)[-4]
rev(2:6)[2:4]
rev(2:6)[-(2:4)]
rev(2:6)[c(1,5)]

# by value
x = rev(2:6)
x[x==3]
x[x<3]
x[x %in% c(2,3,4)]

## Programming
# for loop
for (i in 1:4){
    j = i+10
    print(j)
}

# if statement
if (i>3){
    print("Y")
} else {
    print ("N")
}

# while loop
while (i<5){
    print(i)
    i=i+1
}

square = function(x){
    squared = x*x
    return(squared)
}

square(4)


## Reading and Writing Data
# Input
df = read.table("file.txt")
df = read.csv("file.csv")
load("file.RData")

# Output
write.table(df, "file.txt")
write.csv(df, "file.csv")
save(df, file="file.Rdata")

## Conditions
a == b
a > b
a >= b
a != b
a < b
a <= b
is.na(a)
is.null(a)

## types
as.logical # Boolean
as.numeric # integers or floating
as.character # character strings
as.factor # character strings with preset levels

## Maths Functions
log(x)
exp(x)
max(x)
min(x)
round(x,n)
sig.fig(x,n) # round to n significant figures
cor(x,y)
sum(x)
mean(x)
median(x)
quantile(x)
rank(x)
var(x)
sd(x)

## The environment
ls() # list all variables in the environment
rm(x) # remove x from the environment
rm(list = ls()) # remove all variables from the environment

## Matrixes
x = 1:6
m = matrix(x, nrow=3, ncol=2)
m
m[2, ]
m[, 1]
m[3,2]
t(m) # transpose
m %*% n # matrix multiplication
solve(m,n) # find x in m*x=n

## List
l = list(x = 1:5, y=c("a","b"))
l[[2]]
l[1]
l$x
l['y']


## data frame
df = data.frame(x=1:3, y=c("a","b","c"))
df
df$x
df[[2]]
View(df)
head(df)
df[,2]
df[2,]
df[2,2]
nrow(df)
ncol(df)
dim(df)
cbind(df,z=4:6)


# Strings (also see stringr library)
paste(x,y,sep=" ")
paste(x,collapse=" ") # Join elements of a vector together
grep(pattern,x) # find regular expression matches in x
gsub(pattern,replace,x) # replace matches in x with a string
toupper(x)
tolower(x)
nchar(x) # number of characters in a string

# Factors
factor(x)
cut(x, breaks = 4)

# Statistics
lm(x~y, data = df)
glm(x~y, data = df)
summary
t.test(x,y)
pairwise.t.test
prop.test
aov


# Distributions
# rnorm, dnorm, pnorm, qnorm
# rpois, dpois, ppois, qpois
# rbinom, dbinom, pbinom, qbinom
# runif, dunif, punif, qunif

# Plotting
plot(x)
plot(x,y)
hist(x)

# datas (see the lubridate library)













































