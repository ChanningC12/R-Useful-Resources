# Stratified Random Sampling
library(caret)
data(spam)
dim(spam)
str(spam)
prop.table(table(spam$type))
mean(spam$all)

ind = createDataPartition(c(spam$type,spam$all),p=0.5,list=F)
spam_trn = spam[ind,]
prop.table(table(spam_trn$type))
mean(spam_trn$all,na.rm=T)
spam_tst = spam[-ind,]
prop.table(table(spam_tst$type))
mean(spam_tst$all)

# SMOTE: Synthetic Minority Over-sampling Techniques
# rare events: <15% target variables, imbalanced, SMOTE can help oversample the dataset
# Use bootstrapping and k-nearest neighbors and synthetically create more observations

library(DMwR)
SMOTE

hyper = read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/thyroid-disease/hypothyroid.data",header=F)
head(hyper,2)
names = read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/thyroid-disease/hypothyroid.names",header=F,sep='\t')[[1]]
names
# replace the :|[]
names = gsub(pattern=":|[ ]",x=names,replacement="")
# assign column name
colnames(hyper)=names

dput(names(hyper))
colnames(hyper)=c("target", "age", "sex", "on_thyroxine", "query_on_thyroxine", 
                  "on_antithyroid_medication", "thyroid_surgery", "query_hypothyroid", 
                  "query_hyperthyroid", "pregnant", "sick", "tumor", "lithium", 
                  "goitre", "TSH_measured", "TSH", "T3_measured", "T3", "TT4_measured", 
                  "TT4", "T4U_measured", "T4U", "FTI_measured", "FTI", "TBG_measured", 
                  "TBG")

head(hyper)

# change the target varaible to 0 and 1
hyper$target = ifelse(hyper$target == "negative",0,1)

# rare event
table(hyper$target)
prop.table(table(hyper$target))

# get index which is factor
ind = sapply(hyper,is.factor)
hyper[ind]=lapply(hyper[ind],as.character)

hyper[hyper=="?"] = NA
hyper[hyper=="f"] = 0
hyper[hyper=="t"] = 1
hyper[hyper=="n"] = 0
hyper[hyper=="y"] = 1
hyper[hyper=="M"] = 0
hyper[hyper=="F"] = 1

hyper[ind]=lapply(hyper[ind],as.numeric)
head(hyper,2)

# replace NAs with mean
replaceNAsWithMean = function(x) {replace(x,is.na(x),mean(x[!is.na(x)]))}
hyper = replaceNAsWithMean(hyper)

library(caret)
# separate into training and test portions
set.seed(1234)
splitIndex = createDataPartition(hyper$target,p=0.5,list=F,times=1)
trainSplit = hyper[splitIndex,]
testSplit = hyper[-splitIndex,]
table(trainSplit$target)
prop.table(table(trainSplit$target))

# use a train bag model
ctrl = trainControl(method="cv",number=5)
system.time(tbmodel <- train(as.factor(target)~.,data=trainSplit,method="treebag",trControl=ctrl)) # 12.62s
tbmodel
predictors = names(trainSplit)[names(trainSplit)!="target"]
pred = predict(tbmodel$finalModel, testSplit[,predictors], type="prob")
pred = as.data.frame(pred)
colnames(pred)=c("Neg","Pos")
library(ROCR) # AUC
perf = prediction(pred$Pos, testSplit$target)
perf_roc = performance(perf,measure="tpr",x.measure="fpr")
plot(perf_roc)
perf_auc = performance(perf,measure="auc")
unlist(perf_auc@y.values) # 0.975

# Use SMOTE package
trainSplit$target = as.factor(trainSplit$target)
# oversample 100% of target 1, undersample target 0s
trainSplit = SMOTE(target~.,trainSplit,perc.over=100,perc.under=200) 
table(trainSplit$target)

system.time(tbmodel <- train(as.factor(target)~.,data=trainSplit,method="treebag",trControl=ctrl)) # 12.62s
tbmodel
predictors = names(trainSplit)[names(trainSplit)!="target"]
pred = predict(tbmodel$finalModel, testSplit[,predictors], type="prob")
pred = as.data.frame(pred)
colnames(pred)=c("Neg","Pos")
library(ROCR) # AUC
perf = prediction(pred$Pos, testSplit$target)
perf_roc = performance(perf,measure="tpr",x.measure="fpr")
plot(perf_roc)
perf_auc = performance(perf,measure="auc")
unlist(perf_auc@y.values) # 0.968

# The sample is smaller and still keep the same accuracy







