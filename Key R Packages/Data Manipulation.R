# Added on 9/6 from Hands on R course
library(plyr)
# change the level of factors
meps2$MENTHEALTH = mapvalues(meps2$MENTHEALTH, c("1","2","3""4"), c("None","Low","Medium","High"))
# plyr 'rename'
meps2 = rename(meps2, c("MENTHEALTH"="MHRANK"))
# or
colnames(meps)[colnames(meps)=='FEMALE'] = 'GENDER'
# count
count(meps.no.missing$SMOKER) # From plyr package, generate frequency table
# replacing 99 with NA
meps[meps$SMOKER == 99, c("SMOKER")] = NA


# Data Wrangling with dplyr and tidyr
# tidyr: https://www.r-bloggers.com/data-manipulation-with-tidyr/
# dplyr: https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html
library(dplyr)
library(tidyr)

tbl_df(iris) # converts data to tbl class
glimpse(iris) # information dense summary of tbl data
View(iris)

# %>% passes object on left hand side as first argument of function on righthand side
iris %>% 
    group by(Species) %>%
    summarise(avg = mean(Sepal.Width)) %>%
    arrange(avg)

# Reshaping Data, analogous to the melt function from reshape2
mtcars$car = rownames(mtcars)
mtcars = mtcars[,c(12,1:11)]
head(mtcars)

mtcarsNew = mtcars %>% gather(attribute, value, -car)
head(mtcarsNew)
unique(mtcarsNew$attribute)
dim(mtcarsNew)
dim(mtcars)
# tidyr is that you can gather only certain columns and leave the others alone.
mtcarsNew = gather(mtcars, attribute, value, mpg:gear)
head(mtcarsNew)

# Alternative: melt in reshape package
library(reshape)
mydata = data.frame(id=c(1,1,2,2),time=c(1,2,1,2),x1=c(5,3,6,2),x2=c(6,5,1,4))
mydata
mdata = melt(mydata, id=c("id","time"))
mdata
# cast the melted data
# cast(data, formula, function)
subjmeans = cast(mdata, id~variable, mean)
timemeans = cast(mdata, time~variable, mean)
subjmeans
timemeans

# spread: spread tows into columns
mtcarsSpread = spread(mtcarsNew, attribute, value)
head(mtcarsSpread)

# unite: unite several columns into one
set.seed(1)
date = as.Date('2016-01-01') + 0:14
date
hour = sample(1:24,15)
min = sample(1:60, 15)
second = sample(1:60, 15)
data = data.frame(date, hour, min, second)
dataNew = unite(data = data, datehour, date, hour, sep = ' ')
dataNew
dataNew = unite(data = dataNew, datetime, datehour, min, second, sep=":")
dataNew

# separate: separate one column into several
dataSep = separate(dataNew, datetime, c("datehour","min","second"), sep = ":")
dataSep
dataSep = separate(dataSep, datehour, c("date","hour"), sep = " ")
dataSep

# dplyr, data_frame: combine vectors into dataframe (optimzed)
data_frame(a=1:3, b=4:6)
# arrange: order rows by values of a column (low to high)
arrange(mtcars, mpg)
arrange(mtcars, desc(mpg))

# rename: rename the column of a data frame



# Subset observations (Rows)
filter(iris, Sepal.Length > 7 & Petal.Length > 6)
distinct(iris)
dim(iris)
sample_frac(iris, 0.2, replace = T) # randomly select fraction of rows
sample_n(iris, 10, replace = T) # randomly select n rows
slice(iris, 10:15) # select rows by position

select(iris, Sepal.Width, Petal.Length) # select columns by name or helper function
select(iris, contains("."))
select(iris, ends_with("Length"))
select(iris, everything())
select(iris, matches(".t."))
select(iris, num_range("x",1:5))
select(iris, one_of(c("Species","Genus")))
select(iris, starts_with("Sepal"))
select(iris, Sepal_Length:Petal:Width)
select(iris, -Species)


# Summarise Data
summarise(iris, avg = mean(Sepal.Length))
summarise_each(iris, funs(mean))
count(iris, Species, wt = Sepal.Length)
# summary functions: first, last, nth, n, n_distinct, IQR, min, max, mean, median, var, sd

# Make new variables
mutate(iris, sepal = Sepal.Length + Sepal.Width)
mutate_each(iris, funs(min_rank))
transmute(iris, sepal = Sepal.Length + Sepal.Width) # drop original columns
# window functions: lead, lag, dense_rank, percent_rank, row_number, ntile, between, cume_dist, cumall, cumany, cummean, cumsum, cummax, cummin, cumprod, pmax, pmin

# Group Data
group_by(iris, Species)
ungroup(iris)

# Combine datasets
left_join(a,b,by="x1")
right_join(a,b,by="x1")
inner_join(a,b,by="x1")
full_join(a,b,by="x1")

semi_join(a,b,by="x1") # all rows in a that have a match in b
anti_join(a,b,by="x1") # all rows in a that do not have a match in b

intersect(y,z) # rows that appear in both y and z
union(y,z) # rows that appear in either or both y and z
setdiff(y,z) # rows that appear in y but not z

# Binding
bind_rows(y,z) # append z to y as new rows
bind_cols(y,z) # append z to y as new columns


























