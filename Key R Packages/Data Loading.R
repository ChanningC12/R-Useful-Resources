# Raw data
# - The original source of data
# - Often hard to use for data analysis
# - Data analysis includes processing
# - Raw data may only need to be processed once

# Processed data
# - Data that is ready for analysis 
# - Processing can include merging, subsetting, transforming, etc.
# - There may be standards for processing
# - All steps should be recorded

# download.file() - getting data from internet
# download.file(fileUrl,destfile="./Desktop/cameras.csv",method='curl')

# Reading local files
cameraData=read.table("./Desktop/camera.csv",sep=",",header=TRUE)
# read.csv automately set sep="," and header=TRUE
# other parameters: quote, na.strings, nrows, skip

# Reading Excel file
library(xlsx)
cameraData=read.xlsx("Desktop/camera.xlsx",sheetIndex=1,header=T)
# Other parameters, colIndex rowIndex
# Other packages: XLConnect, XLConnect vignette

# XML, extensible markup language
library(XML)
fileUrl="http://www.w3schools.com/xml/simple.xml"
doc=xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode=xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

# JSON, Javascript Object Notation
# Common storage for data from application programming interfaces (APIs)
library(jsonlite)
jsonData=fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)

# R xlsx package
# Read an Excel file
library(xlsx)
GYZ = read.xlsx("~/Desktop/cuba_tableau/CUBA_GYZ.xlsx", sheetIndex = 1, header = F)
file <- system.file("tests", "test_import.xlsx", package = "xlsx")
res <- read.xlsx(file, 1)  # read first sheet
head(res[, 1:6])

# Write data to Excel
write.xlsx(res, file = "res.xlsx", sheetName = "res", row.names = F)
# To add multiple data sets in the same Excel workbook, you have to use the argument append = TRUE.
write.xlsx(GYZ, file = "res.xlsx", sheetName = "GYZ2", append = T, row.names = F, col.names = F)

# Create and format a nice Excel workbook
# Step 1/5 Create a new Excel Workbook
wb = createWorkbook(type="xlsx")
# Step 2/5 Define some cell styles for formatting the workbook
CellStyle(wb, dataFormat = NULL, alignment = NULL, border = NULL, font = NULL)
# Title and Subtitle styles
Title_Style = CellStyle(wb) + Font(wb, heightInPoints = 16, color = "blue", isBold = T, underline = 1)
Sub_Title_Style = CellStyle(wb) + Font(wb, heightInPoints = 14, isItalic = T, isBold = F)

# Styles for the data table row/column names
Table_Rownames_Style = CellStyle(wb) + Font(wb, isBold = T)
Table_Colnames_Style = CellStyle(wb) + Font(wb, isBold = T) + Alignment(wrapText = T, horizontal = "ALIGN_CENTER") + Border(color = "black", position=c("TOP", "BOTTOM"), pen = c("BORDER_THIN", "BORDER_THICK"))

# Step 3/5 Write Data and Plots into the workbook
sheet = createSheet(wb, sheetName = "US State Facts")

xlsx.addTitle = function(sheet, rowIndex, title, titleStyle){
    rows = createRow(sheet, rowIndex = rowIndex)
    sheetTitle = createCell(rows, colIndex = 1)
    setCellValue(sheetTitle[[1,1]], title)
    setCellStyle(sheetTitle[[1,1]], titleStyle)
}

# Add title
xlsx.addTitle(sheet, rowIndex = 1, title = "US State Facts", titleStyle = Title_Style)
# Add sub title
xlsx.addTitle(sheet, rowIndex = 2, title = "Data sets related to the 50 states of USA", titleStyle = Sub_Title_Style)

# Add a table into a worksheet
head(state.x77)
# Add a table. The function addDataframe() can be used to add the table in the new sheet.
addDataFrame(state.x77, sheet, startRow = 3, startColumn = 1, colnamesStyle = Table_Colnames_Style, rownamesStyle = Table_Rownames_Style)
# Change column width
setColumnWidth(sheet, colIndex = c(1:ncol(state.x77)), colWidth = 11)

# Add a plot into worksheet
# create a png plot
png("boxplot.png", height = 800, width = 800, res = 250, pointsize = 8)
boxplot(count~spray, data = InsectSprays, col = "blue")
dev.off()

# create a new sheet to contain the plot
sheet = createSheet(wb, sheetName = "boxplot")
# Add a title to the sheet
xlsx.addTitle(sheet, rowIndex = 1, title = "Box plot using InsectSprays data", titleStyle = Title_Style)
# Add the plot created previously
addPicture("boxplot.png", sheet, scale = 1, startRow = 4, startColumn = 1)
# Romove the plot from the disk
res = file.remove("boxplot.png")

# Step 4/5 Save the Excel workbook to the disk
saveWorkbook(wb, "r-xlsx-report-example.xlsx")


# Access to Database Management Systems
# The RODBC package provides access to databases (including Microsoft Access and Microsoft SQL Server) through an ODBC (Open Database Connectivity) interface.
odbcConnect(dsn, uid="", pwd="") # Open a connection to an ODBC database
sqlFetch(channel, sqtable) # Read a table from an ODBC database into a data frame
sqlQuery(channel, query) # Submit a query to an ODBC database and return the results
sqlSave(channel, mydf, tablename = sqtable, append = FALSE) # Write or update (append=True) a data frame to a table in the ODBC database
sqlDrop(channel, sqtable) # Remove a table from the ODBC database
close(channel)  # Close the connection

library(RODBC)
myconn <-odbcConnect("mydsn", uid="Rob", pwd="aardvark")
crimedat <- sqlFetch(myconn, "Crime")
pundat <- sqlQuery(myconn, "select * from Punishment")
close(myconn)

# The RMySQL package provides an interface to MySQL.
# The ROracle package provides an interface for Oracle.
# The RJDBC package provides access to databases through a JDBC interface.








































