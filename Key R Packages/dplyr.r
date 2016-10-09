library(dplyr)
library(nycflights13)
flight = flights
dim(flight)
head(flight)

# filter, arrange, select, distinct, mutate, summarise, sample_n
# select all flights on Jan 1st
filter(flight,month==1,day==1)
# equal to 
flight[flight$month==1 & flight$day==1,]
filter(flight,month==1 | month==2)
slice(flight,1:10)

# arrange
arrange(flight,year,month,day)
arrange(flight,year,month,desc(day))
flight[order(flight$year),]

# select: select columns
select(flight,year,month,day)
select(flight,year:day)
select(flight,-(year:day))
select(flight,starts_with("y")) # ends_with(), matches(),contains()

# rename
rename(flight,tail_num=tailnum)

# distinct
distinct(select(flight,carrier))
distinct(select(flights, origin, dest))

# mutate: add new column
flight=mutate(flight,gain=arr_delay-dep_delay,
              speed=distance/air_time*60)
select(flight,gain,speed)

# transmute: if you only want to keep the new variables, use transmute
transmute(flights,
          gain = arr_delay - dep_delay,
          gain_per_hour = gain / (air_time / 60)
)

# summarise
summarise(flight,delay=mean(dep_delay,na.rm=T))

# sample_n(), sample_frac(), replace = T (bootstrap), weight
sample_n(flight,10)
sample_frac(flight,0.00001)

# group by
carrier_grby = group_by(flight,carrier)
delay = summarise(carrier_grby,count=n(),dist=mean(distance,na.rm=T),delay=mean(arr_delay,na.rm=T))
delay
delay = filter(delay,count>20,dist<2000)
delay
library(ggplot2)
ggplot(delay,aes(dist,delay)) + geom_point(aes(size=count),alpha=0.5) + geom_smooth() + scale_size_area()

# chaining
a1 = group_by(flight,year,month,day)
a2 = select(a1,arr_delay,dep_delay)
a3 = summarise(a2,
               arr = mean(arr_delay,na.rm=T),
               dep = mean(dep_delay,na.rm=T))
a4 = filter(a3,arr>30 | dep>30)

filter(summarise(select(group_by(flight,year,month,day),arr_delay,dep_delay),
                 arr = mean(arr_delay,na.rm=T),
                 dep = mean(dep_delay,na.rm=T)),
                 arr > 30 | dep > 30)

