library(caret)
# PreProcess
# Data Splitting
# Train/Test Function
# Model Comparison
library(kernlab)
# Data Splitting
inTrain = createDataPartition(y=spam$type,p=0.75,list=F)
training = spam[inTrain,]
testing = spam[-inTrain,]
dim(training)
# Fit a Model
modelFit = train(type~.,data=training,method="glm")
modelFit # see Accuracy and Kappa
modelFit$finalModel
# Prediction
predictions = predict(modelFit, newdata=testing)
predictions
confusionMatrix(predictions,testing$type)

# k-fold
set.seed(32323)
folds = createFolds(y=spam$type,k=10,list=T,returnTrain=T) # returnTrain = T, returns to train set
sapply(folds,length)
folds[[1]][1:10]

# Resample
folds = createResample(y=spam$type,times=10,list=T)
sapply(folds,length)

# Time Slices
set.seed(32323)
tme = 1:1000
folds = createTimeSlices(y=tme,initialWindow = 20, horizon = 10)
names(folds)

# Metric options
# continous outcomes: RMSE, Rsquare
# categorical outcomes: Accuracy, Kappa

set.seed(1235)
modelFit2 = train(type~.,data=training,method="glm")
modelFit2

# Plotting Predictors
library(ISLR)
library(ggplot2)
data(Wage)
summary(Wage)
# Get training/test sets
inTrain = createDataPartition(y=Wage$wage,p=0.7,list=F)
training = Wage[inTrain,]
testing = Wage[-inTrain,]
dim(training)
dim(testing)

# Feature Plot
featurePlot(x=training[,c("age","education","jobclass")],
            y=training$wage,
            plot="pairs")
# Qplot
qplot(age,wage,data=training)
qplot(age,wage,data=training,colour=jobclass)
qq = qplot(age,wage,colour=education,data=training)
qq + geom_smooth(method="lm",formula=y~x)

# cut2, making factors
library(Hmisc)
cutWage = cut2(training$wage,g=3)
table(cutWage)
p1 = qplot(cutWage,age,data=training,fill=cutWage,geom=c("boxplot"))
p1
# 
p2 = qplot(cutWage,age,data=training,fill=cutWage,geom=c("boxplot","jitter"))
grid.arrange(p1,p2,ncol=2)

# Tables
t1 = table(cutWage,training$jobclass)
t1
prop.table(t1,1)
prop.table(t1,2)

# Density
qplot(wage,colour=education,data=training,geom="density")

# Preprocessing
hist(training$capitalAve,main="",xlab="ave.capital run length")
# Standardizing test value using train mean and sd

# Impute
set.seed(13343)
training$region_na = training$region
selectNA = rbinom(dim(training)[1],size=1,prob=0.05)==1
training$region_na[selectNA]=NA
preObj = preProcess(training[,-58],method="knnImpute")
region_na = predict(preObj,training[,-58])$region_na


# Covariate Creation
library(kernlab)
data(spam)
# transforming tidy covariates
spam$capitalAveSq = spam$capitalAve^2

library(ISLR)
library(caret)
data(Wage)
inTrain = createDataPartition(y=Wage$wage,p=0.7,list=F)
training = Wage[inTrain,]
testing = Wage[-inTrain,]

table(training$jobclass)
dummies = dummyVars(wage~jobclass,data=training)
head(predict(dummies,newdata=training))

# remove zero covariate
nsv = nearZeroVar(training,saveMetrics=T)
nsv

# splines
library(splines)
bsBasis = bs(training$age,df=3) # pylonomial
head(bsBasis)

# fit curve with splines
lm1 = lm(wage~bsBasis, data=training)
plot(training$age,training$wage,pch=19,cex=0.5)
points(training$age,predict(lm1,newdata=training),col="red",pch=19,cex=0.5)
# test set
predict(bsBasis,age=testing$age)


## Preprocessing with PCA
# Include some of the key features that capture majority of the variables
library(kernlab)
library(caret)
data(spam)
inTrain = createDataPartition(y=spam$type,p=0.75,list=F)
training = spam[inTrain,]
testing = spam[-inTrain,]
M = abs(cor(training[,-58]))
diag(M)=0 # correlation between variable itself to be 0
which(M>0.8,arr.ind=T)
names(spam)[c(34,32)]
plot(spam[,34],spam[,32])

# PCA, pick the combination that captures the most information possible
smallSpam = spam[,c(34,32)]
prComp = prcomp(smallSpam)
plot(prComp$x[,1],prComp$x[,2])
prComp$rotation

typeColor = ((spam$type=="spam")*1+1)
prComp = prcomp(log10(spam[,-58]+1))
plot(prComp$x[,1],prComp$x[,2],col=typeColor,xlab="PCA1",ylab="PCA2")

# PCA with caret
preProc = preProcess(log10(spam[,-58]+1),method="pca",pcaComp=2)
spamPC = predict(preProc,log10(spam[,-58]+1))
plot(spamPC[,1],spamPC[,2],col=typeColor)

# training
preProc = preProcess(log10(training[,-58]+1),method="pca",pcaComp=2)
trainPC = predict(preProc,log10(training[,-58]+1))
modelFit = train(training$type~.,method="glm",data=trainPC)

# test, you have to use the same PC calculated from training set for the test variables
testPC = predict(preProc,log10(testing[,-58]+1))
confusionMatrix(testing$type,predict(modelFit,testPC))

# Alternative 
modelFit = train(training$type~.,method="glm",preProcess="pca",data=training)
confusionMatrix(testing$type,predict(modelFit,testing))

## Predicting with Regression
library(caret)
data(faithful)
set.seed(333)
inTrain = createDataPartition(y=faithful$waiting,p=0.5,list=F)
trainFaith = faithful[inTrain,]
testFaith = faithful[-inTrain,]
head(trainFaith)
plot(trainFaith$waiting,trainFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")
lm1 = lm(eruptions~waiting,data=trainFaith)
summary(lm1)
lines(trainFaith$waiting,lm1$fitted,lwd=3)
coef(lm1)[1] + coef(lm1)[2]*80
newdata=data.frame(waiting=80)
predict(lm1,newdata)
# test set
par(mfrow=c(1,2))
plot(trainFaith$waiting,trainFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")
lines(trainFaith$waiting,lm1$fitted,lwd=3)
plot(testFaith$waiting,testFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")
lines(testFaith$waiting,predict(lm1,newdata=testFaith),lwd=3)
# training / test error
sqrt(sum(lm1$fitted-trainFaith$eruptions)^2)
sqrt(sum((predict(lm1,newdata=testFaith)-testFaith$eruptions)^2))
# prediction intervals
pred1 = predict(lm1,newdata=testFaith,interval="prediction")
ord = order(testFaith$waiting)
plot(testFaith$waiting,testFaith$eruptions,pch=19,col="blue")
matlines(testFaith$waiting[ord],pred1[ord,],type="l",,col=c(1,2,2),lty=c(1,1,1),lwd=3)
# same with caret
modFit = train(eruptions~waiting,data=trainFaith,method="lm")
summary(modFit$finalModel)

# Predicting with multiple covariates
library(ISLR)
library(ggplot2)
library(caret)
data(Wage)
Wage = subset(Wage,select=-c(logwage))
summary(Wage)
inTrain = createDataPartition(y=Wage$wage,p=0.7,list=F)
training = Wage[inTrain,]
testing = Wage[-inTrain,]
dim(training)
dim(testing)
featurePlot(x=training[,c("age","education","jobclass")],y = training$wage, plot="pairs")
qplot(age,wage,data=training)
qplot(age,wage,colour=jobclass,data=training)
qplot(age,wage,colour=education,data=training)
modFit = train(wage~age+jobclass+education,method="lm",data=training)
print(modFit)
finMod = modFit$finalModel
# Diagnostics
par(mfrow=c(1,1))
plot(finMod,1,pch=19,cex=0.5,col="#00000010")
qplot(finMod$fitted,finMod$residuals,colour=race,data=training)
plot(finMod$residuals,pch=19)
# predicted versus truth in test set
pred = predict(modFit,testing)
qplot(wage,pred,colour=year,data=testing)
# all covariates
modFitAll = train(wage~.,data=training,method="lm")
pred = predict(modFitAll,testing)
qplot(wage,pred,data=testing)
