library(parallel)
# Calculate the number of cores
no_cores <- detectCores() - 1 # Attempt to detect the number of CPU cores on the current host.
# Initiate cluster
cl <- makeCluster(no_cores)
parLapply(cl,2:4,function(exponent) 2^exponent)
stopCluster(cl)


cl<-makeCluster(no_cores)

base <- 2
clusterExport(cl, "base") # need the clusterExport(cl, "base") in order for the function to see the base variable.
parLapply(cl, 
          2:4, 
          function(exponent) 
              base^exponent)

stopCluster(cl)


# The foreach package
library(foreach)
library(doParallel)
cl<-makeCluster(no_cores)
registerDoParallel(cl)
registerDoParallel(no_cores)
stopImplicitCluster()

### Fitting a predictive model onto a small dataset
d = iris
str(d)
vars = c("Sepal.Length", "Sepal.Width", "Petal.Length")
yName = "Species"
yLevels = sort(unique(as.character(d[[yName]])))
print(yLevels)

# Using glm but "one versus rest" to deal with multinomial outcomes
fitOneTargetModel = function(yName,yLevel,vars,data) {
    formula = paste('(',yName,'=="',yLevel,'") ~ ', 
                    paste(vars,collapse=' + '),sep="")
    glm(as.formula(formula),family = binomial, data = data)    
}

worker = function(yLevel) {
    fitOneTargetModel(yName,yLevel,vars,d)
}
models = lapply(yLevels,worker)
names(models) = yLevels
print(models)

# set up a parallel cluster
parallelCluster = makeCluster(detectCores())
print(parallelCluster


tryCatch(
    models = parLapply(parallelCluster, yLevels, worker),
    error = function(e) print(e)
    )
      
# build a single argument function we are going to pass to parallel
mkWorker = function(yName, vars, d) {
    force(yName)
    force(vars)
    force(d)
    
    fitOneTargetModel = function(yName,yLevel,vars,data){
        formula = paste('(',yName,'=="',yLevel,'") ~ ', 
                        paste(vars,collapse=' + '), sep="")
        glm(as.formula(formula), family = binomial, data=data)
    }
    worker = function(yLevel) {
        fitOneTargetModel(yName,yLevel,vars,d)
    }
    return(worker)
}

models = parLapply(parallelCluster, yLevels, mkWorker(yName,vars,d))
names(models) = yLevels
print(models)

## Use bindtoEnv
source('Desktop/Github/Key R Packages/bindToEnv.R')
mkWorker = function(){
    bindToEnv(objNames = c('yName','vars','d','fitOneTargetModel'))
    function(yLevel){
        fitOneTargetModel(yName,yLevel,vars,d)
    }
}

models = parLapply(parallelCluster,yLevels,mkWorker())
names(models) = yLevels
print(models)

# After finishes, shutdown cluster reference
if(!is.null(parallelCluster)) {
    stopCluster(parallelCluster)
    parallelCluster = c()
}


# ensure results are repeatable
set.seed(7)
# configure multicore
library(doMC)
registerDoMC(cores=4)
# load the library
library(caret)
# load the dataset
data(iris)
# prepare training scheme
control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
model <- train(Species~., data=iris, method="lvq", trControl=control, tuneLength=5)
# summarize the model
print(model)