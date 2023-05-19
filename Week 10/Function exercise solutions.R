#  Exercise Solutions -  Chapter 27 Functions


# Set up ------------------------------------------------------------------
library(tidyverse)
library(nycflights13)

# Allocation --------------------------------------------------------------

# Exercises 27.2.5
# 1 – class
# 2 – class
# 3 – breakout (b/o)
# 4 – homework (h/w)
# 5 – b/o
# 6 – h/w 

# Exercises 27.3.5
# 1 – all b/o
# 2 – h/w
# 3 – Class

# Exercises 27.4.4
# 1 – b/o 
# 2 – b/o
# 3 – b/o

# Exercises 27.5.1
# 1 – b/o
# 2 – h/w
# 3 – b/o


# Exercises 27.2.5 --------------------------------------------------------

# 1 – class
# 2 – class
# 3 – breakout (b/o)
# 4 – homework (h/w)
# 5 – b/o
# 6 – h/w 


#1)
# Practice turning the following code snippets into functions. 
# Think about what each function does. What would you call it? 
# How many arguments does it need?

x <-  c(2,4,6)
y <-  c(4,6,7)
z <-  c(6,7,8)

  mean(is.na(x))
  mean(is.na(y))
  mean(is.na(z))

# calculate the proportion of NAs in a vector  
proportion_na <- function(x) {
  mean(is.na(x))
}  

proportion_na(x)

# standardizes a vector to sum to 1
  x / sum(x, na.rm = TRUE)
  y / sum(y, na.rm = TRUE)
  z / sum(z, na.rm = TRUE)

sum_to_one <- function(x) {
 x / sum(x, na.rm = TRUE)  
}  
  
sum_to_one(x)
  
# calculates a rounded average
  round(x / sum(x, na.rm = TRUE) * 100, 1)
  round(y / sum(y, na.rm = TRUE) * 100, 1)
  round(z / sum(z, na.rm = TRUE) * 100, 1)

rounded_average <- function(x){
  x / sum(x, na.rm = T) * 100 |> 
    round(digits = 1)
}  

rounded_average(x)
  
#2) 
# In the second variant of rescale01(), infinite values are left unchanged. 
# Can you rewrite rescale01() so that -Inf is mapped to 0, and Inf is mapped to 1?

rescale01 <- function(x){
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  y <- (x - rng[1] / rng[2] - rng[1])
  y[y == -Inf] <- 0
  y[y == Inf]  <- 1
  y
  }

rescale01(infs_vector)


#3) 
# Given a vector of birthdates, write a function to compute the age in years.

bens_birthday <- "1999-09-14"

compute_age(bens_birthday)

compute_age <- function(birthdates) {
  # Convert birthdates to Date objects
  dates <- ymd(birthdates)
  
  # Compute the current date
  current_date <- now()
  today()
  
  # Calculate the age in years
  ages <- interval(dates, current_date) %/% years(1)
  
  # Return the age vector
  return(ages)
}

compute_age("1999-09-14")

#4) 
# Write your own functions to compute the variance and skewness of a numeric vector. Variance is defined as

# Var(x)=1/(n-1) ∑_(i=1)^n▒(x_i-x ‾ )^2  "," 

# where x ‾=(∑_i^n▒x_i )/n is the sample mean. Skewness is defined as

# Skew(x)=(1/(n-2) (∑_(i=1)^n▒(x_i-x ‾ )^3 ))/(Var(x)^(3/2) ) "." 

#5) 
# Write both_na(), a summary function that takes two vectors of the same length 
# and returns the number of positions that have an NA in both vectors.

both_na <- function(x, y) {
  if (length(x) == length(y)) {
    sum(is.na(x) & is.na(y))
  } else
    stop("Vectors are not equal length")
}

# I built this function to have a warning to show if the vectors are not equal length!

x <- c(4, NA, 7, NA, 3)
y <- c(NA, NA, 5, NA, 0)
z <- c(NA, 4)

both_na(x, y)
both_na(x, z)


#6) 
# Read the documentation to figure out what the following functions do. Why are they useful even though they are so short?

  is_directory <- function(x) file.info(x)$isdir
  is_readable <- function(x) file.access(x, 4) == 0



# Exercises 27.3.5 --------------------------------------------------------

# 1 – all b/o
# 2 – h/w
# 3 – Class

#1)
  #1.	Finds all flights that were cancelled (i.e. is.na(arr_time)) or delayed by more than an hour.
  
  filter_severe <- function() {
    flights %>%
      filter(is.na(arr_time) | dep_delay > 60)
  }
  
  filter_severe()
  
  #2.	Counts the number of cancelled flights and the number of flights delayed by more than an hour.
  
  
  summarize_severe <- function() {
    flights %>%
      summarize(num_cancelled = sum(is.na(arr_time)), num_delayed = sum(dep_delay > 60))
  }
  
  summarize_severe()
  
  #3.	Finds all flights that were cancelled or delayed by more than a user supplied number of hours:
  filter_severe_hours <- function(hours) {
    flights %>%
      filter(is.na(arr_time) | dep_delay > (hours * 60))
  }
  
  flights %>% filter_severe_hours(hours = 2)
  
    #4.	Summarizes the weather to compute the minimum, mean, and maximum, of a user supplied variable:
  
  summarize_weather <- function(variable) {
    weather %>%
      summarize(minimum = min({{variable}}, na.rm = TRUE),
                mean = mean({{variable}}, na.rm = TRUE),
                maximum = max({{variable}}, na.rm = TRUE))
  }
  
  summarize_weather(temp)
  
  #5.	Converts the user supplied variable that uses clock time (e.g. dep_time, arr_time, etc.) 
  # into a decimal time (i.e. hours + (minutes / 60)).
  
  weather |> standardize_time(time_hour)
  
  standardize_time <- function(variable) {
    weather %>%
      mutate(decimal_time = floor({{variable}} / 100) + ({{variable}} %% 100) / 60)
  }
  
  weather %>% standardize_time()
  

#2)
# For each of the following functions list all arguments that use tidy evaluation 
# and describe whether they use data-masking or tidy-selection: distinct(), 
# count(), group_by(), rename_with(), slice_min(), slice_sample().

# 3.	Generalize the following function so that you can supply any number of variables to count.
  count_prop <- function(df, var, sort = FALSE) {
    df |>
      count({{ var }}, sort = sort) |>
      mutate(prop = n / sum(n))
  }
  
  
# Exercises 27.4.4 --------------------------------------------------------

1 – b/o 
2 – b/o
3 – b/o

# Build up a rich plotting function by incrementally implementing each of the steps below:
# 1.	Draw a scatterplot given dataset and x and y variables.
# 2.	Add a line of best fit (i.e. a linear model with no standard errors).
# 3.	Add a title.


# Exercises 27.5.1 --------------------------------------------------------

1 – b/o
2 – h/w
3 – b/o

# 1.	Read the source code for each of the following two functions, puzzle out what they do, and then brainstorm better names.
f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}

f3 <- function(x, y) {
  rep(y, length.out = length(x))
}
# 2.	Take a function that you’ve written recently and spend 5 minutes brainstorming a better name for it and its arguments.

# 3.	Make a case for why norm_r(), norm_d() etc. would be better than rnorm(), dnorm(). Make a case for the opposite.


