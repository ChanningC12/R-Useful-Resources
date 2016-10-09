# Poisson Distribution: used to model count variable
# Example 3. The number of awards earned by students at one high school. 
## Predictors of the number of awards earned include the type of program in which the student was enrolled 
### (e.g., vocational, general or academic) and the score on their final exam in math.
library(data.table)
library(sandwich)
library(msm)

p <- read.csv("http://www.ats.ucla.edu/stat/data/poisson_sim.csv")
View(p)
str(p)
head(p)
table(p$num_awards)
table(p$prog)

p = within(p, {
    prog = factor(prog, levels=1:3, labels=c("General", "Academic", "Vocational"))
    id = factor(id)
})

summary(p)
str(p)

with(p, tapply(num_awards, prog, function(x) {
    sprintf("M(SD) = %1.2f (%1.2f)", mean(x), sd(x))
}))

class(p)
p = as.data.table(p)
p[,.(count = .N, avg_num_awd = mean(num_awards), sd_num_awd = sd(num_awards)), by=prog]

ggplot(p, aes(x=num_awards, fill=prog)) + geom_histogram(binwidth = .5, position = "dodge")

# Poisson Regression
summary(m1 <- glm(num_awards ~ prog + math, family="poisson", data=p))
p[order(math),.(count = .N, avg_num_awd = mean(num_awards), sd_num_awd = sd(num_awards)), by=math]

# use R package sandwich below to obtain the robust standard errors and calculated the p-values accordingly
cov.m1 = vcovHC(m1, type="HC0")
std.err <- sqrt(diag(cov.m1))
r.est <- cbind(Estimate= coef(m1), "Robust SE" = std.err,
               "Pr(>|z|)" = 2 * pnorm(abs(coef(m1)/std.err), lower.tail=FALSE),
               LL = coef(m1) - 1.96 * std.err,
               UL = coef(m1) + 1.96 * std.err)
r.est
# The coefficient for math is .07.This means that the expected log count for a one-unit increase in math is .07. 

with(m1, cbind(res.deviance = deviance, df = df.residual,
               p = pchisq(deviance, df.residual, lower.tail=FALSE)))

## update m1 model dropping prog
m2 <- update(m1, . ~ . - prog)
## test model differences with chi square test
anova(m2, m1, test="Chisq")

# To compute the standard error for the incident rate ratios, we will use the Delta method.
s <- deltamethod(list(~ exp(x1), ~ exp(x2), ~ exp(x3), ~ exp(x4)), coef(m1), cov.m1)
## exponentiate old estimates dropping the p values
rexp.est <- exp(r.est[, -3])
## replace SEs with estimates for exponentiated coefficients
rexp.est[, "Robust SE"] <- s

rexp.est

(s1 <- data.frame(math = mean(p$math),
                  prog = factor(1:3, levels = 1:3, labels = levels(p$prog))))
predict(m1, s1, type="response", se.fit=TRUE)

## calculate and store predicted values
p$phat <- predict(m1, type="response")
## order by program and then by math
p <- p[with(p, order(prog, math)), ]
## create the plot
ggplot(p, aes(x = math, y = phat, colour = prog)) +
    geom_point(aes(y = num_awards), alpha=.5, position=position_jitter(h=.2)) +
    geom_line(size = 1) +
    labs(x = "Math Score", y = "Expected number of awards")


# By default, glm family will peform multiple linear regression
summary(lm(num_awards ~ prog + math, data=p))
summary(glm(num_awards ~ prog + math, data=p))

x1=c(56.1, 26.8, 23.9, 46.8, 34.8, 42.1, 22.9, 55.5, 56.1, 46.9, 26.7, 33.9, 
     37.0, 57.6, 27.2, 25.7, 37.0, 44.4, 44.7, 67.2, 48.7, 20.4, 45.2, 22.4, 23.2, 
     39.9, 51.3, 24.1, 56.3, 58.9, 62.2, 37.7, 36.0, 63.9, 62.5, 44.1, 46.9, 45.4, 
     23.7, 36.5, 56.1, 69.6, 40.3, 26.2, 67.1, 33.8, 29.9, 25.7, 40.0, 27.5)

x2=c(12.29, 11.42, 13.59, 8.64, 12.77, 9.9, 13.2, 7.34, 10.67, 18.8, 9.84, 16.72, 
     10.32, 13.67, 7.65, 9.44, 14.52, 8.24, 14.14, 17.2, 16.21, 6.01, 14.23, 15.63, 
     10.83, 13.39, 10.5, 10.01, 13.56, 11.26, 4.8, 9.59, 11.87, 11, 12.02, 10.9, 9.5, 
     10.63, 19.03, 16.71, 15.11, 7.22, 12.6, 15.35, 8.77, 9.81, 9.49, 15.82, 10.94, 6.53)

y = c(1.54, 0.81, 1.39, 1.09, 1.3, 1.16, 0.95, 1.29, 1.35, 1.86, 1.1, 0.96,
      1.03, 1.8, 0.7, 0.88, 1.24, 0.94, 1.41, 2.13, 1.63, 0.78, 1.55, 1.5, 0.96, 
      1.21, 1.4, 0.66, 1.55, 1.37, 1.19, 0.88, 0.97, 1.56, 1.51, 1.09, 1.23, 1.2, 
      1.62, 1.52, 1.64, 1.77, 0.97, 1.12, 1.48, 0.83, 1.06, 1.1, 1.21, 0.75)

lm(y ~ x1 + x2)
glm(y ~ x1 + x2, family=gaussian) 
glm(y ~ x1 + x2, family=gaussian(link="log")) 
nls(y ~ exp(b0+b1*x1+b2*x2), start=list(b0=-1,b1=0.01,b2=0.1))


