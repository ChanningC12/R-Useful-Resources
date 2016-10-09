# data.table package
library(data.table)
# general form: DT[i, j, by] -- take DT, subset rows using i, then calculate j grouped by by
# Create a data table
set.seed(45L)
DT = data.table(V1 = c(1L,2L),
                V2 = LETTERS[1:3],
                V3 = round(rnorm(4),4),
                V4 = 1:12)

# Subsetting rows using i
DT[3:5,] # selects third to fifth row
DT[V2=="A",] # selects all rows that have value A in column
DT[V2 %in% c("A","C")] # selects all rows that have the value A or C in column V2

# Manipulating on columns in j
DT[,V2] # column V2 is returned as a vector
DT[,.(V2,V3)] # columns V2 and V3 are returned as a data.table
# .() is an alias to list(). If .() is used, the returned value is a data.table. If .() is not used, the result is a vector

DT[,.(V1_sum = sum(V1))] # return the sum of all elements of column V1 in a vector
DT[,.(V1_sum = sum(V1), V3_sd = sd(V3))] # returns the sum of all elements of column V1 and the standard deviation of V3 in a data.table
DT[,.(V1, V3_sd = sd(V3))] # select column V1, and compute std.dev of V3, which returns a single value and gets recycled
# print column V2 and plot V3
DT[,{print(V2)
     plot(V3)
     NULL}]

# Doing j by group
DT
DT[,.(V4_sum = sum(V4)), by = V1] # calculates the sum of V4, for every group in V1
DT[,.(V4_sum = sum(V4)), by = .(V1,V2)] # calculates the sum of V4, for every group in V1, V2
DT[,.(V4_sum = sum(V4)), by = sign(V1-1)] # calculates the sum of V4, for every group in sign(V1-1)
DT[1:5,.(V4_sum = sum(V4)), by = V1] # # calculates the sum of V4, for every group in V1, after subsetting on the first five rows
DT[,.N,by=V1] # count the number of rows for every group in V1

# Adding / Updating columns by reference in j using :=
DT[, V1 := round(exp(V1),2)] # column V1 is updated by what is after :=
DT[, c("V1","V2") := list(round(exp(V1),2), LETTERS[4:6])] # column V1 and V2 are updated by what is after :=
DT[, ':=' (V1 = round(exp(V1),2), V2 = LETTERS[4:6])][] # when [] is added the result is printed to the screen
DT[, V1 := NULL] # removes column V1
DT[, c("V1","V2") := NULL] # removes columns V1 and V2

Col.chosen = c("V1","V2")
DT[,Col.chosen := NULL] # deletes the column with column name Col.chosen
DT[,(Col.chosen) := NULL] # deletes the columns specified in the variable Cols.chosen (V1 and V2)


# Indexing and keys
setkey(DT,V2) # a key is set on column V2
DT["A"] # returns all rows where the key column (V2) has the value A
DT[c("A","C")] # returns all the rows where the key column V2 has the value A or C
DT["A", mult = "first"] # return first row of all rows that match the value A in the key column V2
DT["A", mult = "last"] # the mult argument is used to control which row that i matches to is returned, default is all
DT[c("A","D")] # D is not found so NA is returned for D
DT[c("A","D"), nomatch = 0] # The nomatch argument is used to control what happens when a value specified in i has no match in the rows of the DT

DT[c("A","C"),sum(V4)] # returns one total sum of column V4, for the rows of the key column V2 that have values A or C
DT[c("A","C"),sum(V4), by=.EACHI] # by=.EACHI allows to group by each subset of known groups in i

setkey(DT, V1, V2)
DT[.(2,c("A","C"))] # selects the rows that have the value 2 for the first key (column V1) and within those rows the value A or C for the second key (column V2)

# Advanced Data Table Operations
DT[.N-1] # returns the penultimate row
DT[,.N] # returns number of rows
DT[,.(V2,V3)] # or
DT[,list(V2,V3)] # columns V2 and V3 are returned as a data.table
DT[,mean(V3),by=.(V1,V2)]
DT[,print(.SD),by=V2] # .SD is a data.table and holds all the values of all columns, except the one specified in by.
DT[,.SD[c(1,.N)],by=V2] # select the first and last row grouped by column V2
DT[, lapply(.SD, sum), by=V2] # calculates the sum of all columns in .SD grouped by V2
DT[, lapply(.SD, sum), by=V2, .SDcols = paste0("V", 3:4)] # only for V3 and V4
DT[, lapply(.SD, sum), by=V2, .SDcols = c("V3","V4")] # only for V3 and V4

# Chaining
DT = DT[,.(V4_sum = sum(V4)), by=V1]
DT[V4_sum > 40] # no chaining

DT[,.(V4_sum = sum(V4)),by=V1][V4_sum > 40] # same as above

DT[,.(V4_sum = sum(V4)),by=V1][order(desc(V4_sum))] # calculates sum of V4, grouped by V1, and then orders the result on V1

# Using the set()-FAMILY
setnames(DT, "V2", "Rating") # rename the column V2 to Rating
setnames(DT, c("Rating","V3"), c("V2.Rating", "V3.DataCamp"))
DT
setcolorder(DT,c("V2.Rating","V1","V3.DataCamp","V4")) # changes the column ordering to the contents of the vector
DT



























