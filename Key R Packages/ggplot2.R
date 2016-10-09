# The lattice system. lattice is built based on grid
# xyplot: main function for creating scatterplots
# bwplot: box-and-whiskers plot
# histogram: histograms
# stripplot: like a boxplot but with actual points
# dotplot: plot dots on "violin strings"
# splom: scatterplot matrix, like pairs in base plotting system
# levelplot, contourplot: for plotting image data
library(grid)
library(lattice)
# simple scatterplot
library(datasets)
xyplot(Ozone~Wind,data=airquality)
xyplot(Ozone~Wind | factor(Month),data=airquality,layout=c(5,1)) # scatterplot by month, generates 5 plots, layout them on the same horizontal level

# panel function, each panel gives the subset
set.seed(10)
x=rnorm(100)
f=rep(0:1,each=50)
y=x+f-f*x+rnorm(100,sd=0.5)
xyplot(y~x|factor(f),layout=c(2,1))
# custom panel function
xyplot(y~x|f,panel=function(x,y,...){
    panel.xyplot(x,y,...)
    panel.abline(h=median(y),lty=2)
})

xyplot(y~x|f,panel=function(x,y,...){
    panel.xyplot(x,y,...)
    panel.lmline(x,y,col=2)
})

# ggplot
library(ggplot2)
# plots are made of aesthetic (size,shape,color) and geom (points,lines), statistics
# factor variables, indicates subset of subsets, needs to be properly labeled
mpg = read.csv("~/Desktop/Github/Key R Packages/mpg.csv")
qplot(displ,hwy,data=mpg) # quick plot -- x coord, y coord, data frame. hwy. highway miles per gallon. displ. engine displacement, in litres
qplot(displ,hwy,data=mpg,color=drv) # color by factor variables. drv. f = front-wheel drive, r = rear wheel drive, 4 = 4wd
qplot(displ,hwy,data=mpg,geom=c("point","smooth")) # smooth, 95% CI of the trend line
qplot(hwy,data=mpg,fill=drv) # histogram 
# Facets
qplot(displ,hwy,data=mpg,facets=.~drv) # facet, right side: column of the panel, left: row of matrix
qplot(hwy,data=mpg,facets=drv~.,binwidth=2,color=drv)

# read maccs
maccs = readRDS(file = "~/Desktop/Github/Coursera/Exploratory Data Analysis/Exploratory Data Analysis/maacs_env.rds")
load("~/Desktop/Github/Coursera/Exploratory Data Analysis/Exploratory Data Analysis/maacs.Rda")
qplot(pm25,data=maccs)
qplot(log(pm25),data=maccs) # fill=
qplot(log(pm25),data=maccs,geom="density")
qplot(log(pm25),log(no2),data=maccs,color="red")+geom_smooth(method="lm")
qplot(log(pm25),log(eno),data=maacs,color=mopos)+geom_smooth(method="lm")

# initial call to ggplot: g = ggplot(maacs,aes(logpm25,NocturnalSympt)) 
# summary(g)
# g+geom_point()+geom_smooth()+facet_grid(.~bmicat)
g = ggplot(maacs,aes(log(pm25),log(eno)))
g + geom_point() + geom_smooth(method="lm") + facet_grid(.~mopos)
g + geom_point(color="steelblue",size=4,alpha=1/2)
g + geom_point(aes(color=mopos),size=4,alpha=1/2) + labs(title="MAACS") + 
    labs(x=expression("log"*PM[2.5]),y=expression("log"*EN)) + geom_smooth() + facet_grid(.~mopos) +
    theme_bw(base_family = "Times")

testdat = data.frame(x=1:100,y=rnorm(100))
testdat[50,2] = 100 # outlier
with(testdat,plot(x,y,type="l",ylim=c(-5,5)))

g = ggplot(testdat,aes(x=x,y=y))
g + geom_line()
g + geom_line() + ylim(-5,5) # without outlier
g + geom_line() + coord_cartesian(ylim=c(-5,5)) # with outlier


## ggplot2 cheatsheet
# ggplot2 is based on the grammar of graphics. Dataset + a set of geoms + coordinate system
# key functions: qplot(), ggplot()
qplot(x=cty, y=hwy, color=cyl, data=mpg, geom="point")
# adding layers on ggplot()
ggplot(data=mpg, aes(x=cty,y=hwy)) +
    geom_point(aes(color=cyl)) +
    geom_smooth(method="lm") +
    coord_cartesian() +
    scale_color_gradient() +
    theme_bw()
ggsave("plot.png", width = 5, height = 5) # save last plot in the working directory

# Geoms
# One variable
a = ggplot(mpg, aes(hwy))
a + geom_area(stat="bin")
a + geom_density(kernel="gaussian")
a + geom_dotplot()
a + geom_freqpoly()
a + geom_histogram(binwidth=5)
b = ggplot(mpg,aes(fl))
b + geom_bar()

# Graphical Primitives
c = ggplot(mapdata,aes(long,lat))
c + geom_polygon(aes(group=group))

d = ggplot(economics, aes(date, unemploy))
d + geom_path(lineend = "butt", linejoin = "round", linemitre=1)
d + geom_ribbon(aes(ymin=unemploy-900, ymax=unemploy+900))

e = ggplot(seals, aes(x=long, y=lat))
e + geom_segment(aes(xend = long + delta_long, yend = lat + delta_lat))
e + geom_rect(aes(xmin=long, ymin=lat, xmax=long+delta_long, ymax=lat+delta_lat))

# Two variables
# Continuous X, Continuous Y
f = ggplot(mpg, aes(x=cty, y=hwy))
f + geom_blank()
f + geom_jitter()
f + geom_point()
f + geom_quantile()
f + geom_rug(sides="bl")
f + geom_smooth(method="lm")
f + geom_text(aes(label=cty))

# Discreate X, Continuous Y
g = ggplot(mpg, aes(class, hwy))
g + geom_bar(stat = "identity")
g + geom_boxplot()
g + geom_dotplot(binaxis="y",stackdir="center")
g + geom_violin(scale="area")

# Discrete X, Discrete Y
h = ggplot(diamonds, aes(x=cut, y=color))
h + geom_jitter()

# Continuous Bivariate Distribution
i = ggplot(movies, aes(year, rating))
i + geom_bin2d(binwidth=c(5,0.5))
i + geom_density2d()
i + geom_hex()

# Continuous Function
j = ggplot(economics, aes(date, unemploy))
j + geom_area()
j + geom_line()
j + geom_step(direction="hv")

# Visualizing error
df = data.frame(grp = c("A", "B"), fit = 4:5, se = 1:2)
k = ggplot(df, aes(grp, fit, ymin=fit-se, ymax=fit+se))
k + geom_crossbar(fatten=2)
k + geom_errorbar()
k + geom_linerange()
k + geom_pointrange()

# Maps
library(maps)
data = data.frame(murder = USArrests$Murder, state = tolower(rownames(USArrests)))
data
map = map_data("state")
l = ggplot(data, aes(fill=murder))
l + geom_map(aes(map_id=state), map=map) + expand_limits(x=map$long, y=map$lat)

# Three variables
seals$z = with(seals, sqrt(delta_long^2 + delta_lat^2))
m = ggplot(seals, aes(long, lat))
m + geom_contour(aes(z=z))
m + geom_raster(aes(fill=z),hjust=0.5,vjust=0.5,interpolate=F)
m + geom_tile(aes(fill=z))


# Scales: controls how a plot maps data values to the visaul value of an aesthetic. To change the mapping, add a custom scale
n = b + geom_bar(aes(fill=fl))
n
n + scale_fill_manual(values = c("skyblue","royalblue","blue","navy"),
                      limits = c("d","e","p","r"), breaks = c("d","e","p","r"),
                      name = "fuel", labels=c("D","E","P","R"))

# Faceting: divide a plot into subplots based on the values of one or more discrete variables
t = ggplot(mpg, aes(cty, hwy)) + geom_point()
t + facet_grid(.~fl)
t + facet_grid(year~.)
t + facet_grid(year~fl)
t + facet_wrap(~fl)

t + facet_grid(.~fl, scales="free")


