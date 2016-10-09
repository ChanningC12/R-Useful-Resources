library(conjoint)

# Step 1: Design the profile of the product under consideration. Since we just need 21 parameters. We use fractional factorial method with 21 cards


attribute<-list(
    Origin=c("European","Canadian","Japanese"),
    Price=c("6.19","5.49","4.79"),
    Body=c("Rich full bodied","Regular","Crisp and clear"),
    Aftertaste=c("strong","mild", "very mild"),
    Calories=c("full", "regular", "low"),
    Packaging=c("Six 12Oz Large", "Six 12Oz Small",   "Four 16Oz"),
    Glass=c("Green Label",    "Brown Label",  "Brown Painted")
)

profiles = expand.grid(attribute) # Expand all the combination into a data frame

design<-caFactorialDesign(data=profiles,type="fractional", cards=21)
print(design)
nrow(design)

# Step 2: Load the file with levels (or design a matrix with level names). 
##        Load the file with preferences as received from the survey.
KrinLev <- read.csv("KrinLev.csv", header=F)
KrinPref <- read.csv("KrinPref.csv")


# Step 3: Execute the conjoint function as
Conjoint(KrinPref, design, KrinLev)

# Step 4: To get the importance of each of seven attributes, we can use
imp = caImportance(KrinPref, design)

# Step 5: Get the part utilities of each of 317 respondents with intercept on first place
uslall = caPartUtilities(KrinPref, design, KrinLev)

# Step 6: Consider to segment the customers

# Step 7: plot cluster
library(cluster)
library(fpc)
plotcluster(KrinPref, segment$cluster)












