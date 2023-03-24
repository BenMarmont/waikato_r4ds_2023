library(ggplot2)
library(tidyverse)
library(nycflights13)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(colour = class))

y <- 10

# y ← 10
x <- 1
x

