
library(tidyverse)

# BaseR packages we have been using unconsciously
library(package)
sum()
mean()
min()
max()

# + - / | & %% ! *


# Subsetting vectors ------------------------------------------------------

x[i]
x[j]
x[i, j]

x <- c("one", "two", "three", "four", "five")
x

#subsetting vector by positive integer
x[1]
x[5]

x[c(1, 3, 5)]
x[c(1,1,2,2,2,3,3,3,4,5)]

#subsetting vector by negativ integer
x[-1]
x[c(-1,-3,-5)]

x <- c(10, 3, NA, 5, 8, 1, NA)
x
#subsetting vector by logical integer
x[!is.na(x)]
x[x %% 2 == 0]

#subsetting vector by character vector
x <- c(abc = 1, def = 2, xyz = 3)
x["abc"]
x[c("abc", "xyz")]
x[c("abc", "abc", "def", "xyz", "xyz", "xyz")]

#subsetting by nothing
x[]
x

# Subsetting data frames --------------------------------------------------
# df[rows, cols]
#df[, cols]
#df[rows, ]

df <- tibble(
  x = 1:3,
  y = c("a", "e", "f"),
  z = runif(3)
            )
df[1, 1]
df[]
df[1, ]
df[ , 3]
df[ , c("x", "z")]
df[df$x > 1, ]


# dplyr equivalents -------------------------------------------------------

df <- tibble(
  x = c(2,3,1,1,NA),
  y = letters[1:5],
  z = runif(5)
            )
df

df |> 
  filter(x > 1)

df[!is.na(df$x) & df$x > 1, ]
df[which(df$x > 1), ]

df |> 
  arrange(x, y)

df[order(df$x, df$y), ]

df |> 
  select(x, z)

df[ ,c("x", "z")]

df |> 
  filter(x > 1) |> 
  select(y, z)

df |> 
  subset(x > 1, c(y, z))


# Selecting columns -------------------------------------------------------
# [[.]] access position or name
# $ accesses only by name
# pull()

tb <- tibble(
  x = 1:4,
  y = c(10, 4, 1, 21)
            )
tb[[1]]
tb[["x"]]
tb$x

# tidyverse equivalents
tb |> pull(1)
tb |> pull(x)
tb |> pull("x")

tb
tb$z <- tb$x + tb$y
tb

tb |> 
  mutate(z = x + y)

max(diamonds$carat)
levels(diamonds$cut)

df <- data.frame(x1 = 1)
df$x 
tb <- tibble(x1 = 1)
tb$x 


# Lists -------------------------------------------------------------------
lt <- list(
  a = 1:3,
  b = "a string",
  c = pi,
  d = list(-1, -5)
          )
lt
lt[1:2]
lt[4]

lt[1]
lt[[1]]
lt[[4]]


# Apply ~ across ----------------------------------------------------------

df <- tibble(a = 1, b = 2, c = "a", d = "b", e = 4)

num_cols <-  sapply(df, is.numeric)
num_cols

df[, num_cols] <- lapply(df[, num_cols, drop = FALSE], \(x) x * 2)
df

tapply(diamonds$price, diamonds$cut, mean)

diamonds |> 
  group_by(cut) |> 
  summarise(mean = mean(price))

# For Loop ----------------------------------------------------------------


for (element in vector){
  #body of the loop
}


# Plots -------------------------------------------------------------------

plot() #BaseR scatterplot
plot(diamonds$carat, diamonds$price)

hist() #BaseR histograme
hist(diamonds$carat)
