
# Set up ------------------------------------------------------------------

library(tidyverse)
library(nycflights13)

# Refresher ---------------------------------------------------------------


vector <- c(1, 2, 3)
vector

dataframe <- tibble(x = c(1,2,3),
                    y = c(4,5,6),
                    z = c(7,8,9))
dataframe




# Begin! ------------------------------------------------------------------


# Vector Functions --------------------------------------------------------

df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5)
)
df

df |> mutate(
  a = (a - min(a, na.rm = TRUE)) / 
    (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)),
  
  b = (b - min(b, na.rm = TRUE)) / 
    (max(b, na.rm = TRUE) - min(b, na.rm = TRUE)),
  
  c = (c - min(c, na.rm = TRUE)) /
    (max(c, na.rm = TRUE) - min(c, na.rm = TRUE)),

  d = (d - min(d, na.rm = TRUE)) / 
    (max(d, na.rm = TRUE) - min(d, na.rm = TRUE))
)


a = (a - min(a, na.rm = TRUE)) /  (max(a, na.rm = TRUE) - min(a, na.rm = TRUE))
b = (b - min(b, na.rm = TRUE)) /  (max(b, na.rm = TRUE) - min(b, na.rm = TRUE))

## General form for writing a function:
# name <- function(argument/s){
#   body
# }

rescale01 <- function(x){
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

df |> mutate(
  a = rescale01(a),
  b = rescale01(b),
  c = rescale01(c),
  d = rescale01(d)
)

df |> mutate(across(a:d)) |> rescale01()

vector_range <- range(vector)
vector_range[1]
vector_range[2]

rescale01 <- function(x){
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

x <- c(1:10, Inf)
rescale01(x)

rescale01 <- function(x){
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(x)

# mutate functions

z_score <- function(x){
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

clamp <- function(x, min, max){
  case_when(
    x < min ~ min,
    x > max ~ max,
    .default = x
            )
}

clamp(1:10, min = 3, max = 7)

first_upper <- function(x){
  str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
  x
}

text <- "hello world"
first_upper(text)

# summary functions

commas <- function(x) {
  str_flatten(x, collapse = ", ", last = " and ")
}

commas(c("cat", "dog", "pigeon"))

coefficient_of_variation <- function(x, na.rm = FALSE){
  sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}

coefficient_of_variation(runif(100, min = 0, max = 50))

# STOP
# Practice turning the following code snippets into functions. 
# Think about what each function does. What would you call it? 
# How many arguments does it need?

mean(is.na(x))
mean(is.na(y))
mean(is.na(z))

x / sum(x, na.rm = TRUE)
y / sum(y, na.rm = TRUE)
z / sum(z, na.rm = TRUE)

round(x / sum(x, na.rm = TRUE) * 100, 1)
round(y / sum(y, na.rm = TRUE) * 100, 1)
round(z / sum(z, na.rm = TRUE) * 100, 1)

## General form for writing a function:
# name <- function(argument/s){
#   body
# }

na_proportion <- function(variable) {
  mean(is.na(variable))
}

x <-  c(2,4,6)
y <-  c(4,6,7)
z <-  c(6,7,8,NA)

na_proportion(z)

sum_to_one <- function(variable){
  variable / sum(variable, na.rm = TRUE)
}

sum_to_one(z)

rounded_average <- function(variable){
  variable / sum(variable, na.rm = TRUE) * 100 |> 
    round(digits = 1)
}

rounded_average(x)


# Data frame functions ----------------------------------------------------

{{  embrace }} # a hug!

# example of indirection

grouped_mean <- function(df, group_var, mean_var){
  df |> 
    group_by(group_var) |> 
    summarise(mean(mean_var))
}

grouped_mean(df = diamonds, group_var = clarity, mean_var = price)

diamonds |> grouped_mean(cut, carat)

# this is what group_mean is doing:
df |> group_by(group_var) |> summarize(mean(mean_var))

# this is what we need it do to get the results we want
df |> group_by(group) |> summarize(mean(x)) 

# tidy evaluation lets us call variables in the data frame by name without special treatment

# summary statistics function

summary6 <- function(data, var) {
  data |> 
    summarise(
    
    
      min     = min({{ var }},    na.rm = TRUE), 
    
      mean    = mean({{ var }},   na.rm = TRUE),
    
      median  = median({{ var }}, na.rm = TRUE),
    
      max     = max({{ var }},    na.rm = TRUE),
    
      n       = n(),
    
      n_miss  = sum(is.na({{ var }})),
    
      .groups = "drop"
                  )
}

diamonds |> 
  group_by(cut) |> 
  summary6(carat)

diamonds |> 
  group_by(clarity) |> 
  summary6(price)


# Plot functions ----------------------------------------------------------

diamonds |> 
  ggplot(aes(x = carat)) +
  geom_histogram()

diamonds |> 
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.05)

histogram <- function(df, var, bin_w = NULL) {
  df |> 
    ggplot(aes(x = {{ var }})) +
    geom_histogram(binwidth = bin_w)
}

diamonds |> histogram(carat, 0.1)
diamonds |> histogram(carat, 1) 

linearity_check <- function(df, x, y) {
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }})) +
    geom_point() +
    geom_smooth(method = "loess", formula = y ~ x, colour = "red", se = FALSE) +
    geom_smooth(method = "lm", formula = y ~ x, colour = "blue", se = FALSE)
}

starwars |> 
  filter(mass < 1000) |> 
  linearity_check(mass, height)



