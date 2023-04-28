# Numbers - Chapter 15

# integer
# double (precision number)

x <- c("1.2", "5.6")
# text to number
parse_double(x) 

# remove non-numeric characters
x <- c("$1,234", "USD 3,513", "59%")
parse_number(x)

dplyr::n()

flights |> 
  group_by(dest) |> 
  summarise(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )

n_distinct()

flights |> 
  summarise(carriers = n_distinct(carrier))
  
# STOP

# How can you use count() to count the number rows with a missing
# value for a given variable?
  
flights |> 
  filter(is.na(dep_delay)) |> 
  count()  

x <- c(1, 2, 3, 4)
x * 2
  
x * c(1, 2, 3)

# Modular arithmetic

# %/% how many whole numbers in y fits into x
# %%  remainder division
# y      x
1:10 %/% 3
1:10 %%  3

flights |> 
  mutate(
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100) |> 
  glimpse()

# Tips and tricks for working with numbers--------------------------------------
# R has log2, log10 and loge
# Use round() to control number of digits
  # floor() and ceiling()
  # round() uses bankers rounding (rounds to whole number when in the middle of values)
# lead() and lag() to get the proceeding/following observations
# min() and max() to get the corresponding (minimum or maximum) values in a vector
  # quantiles quantitle()
quantitle(x, .5)
quantitle(x, .95) # gets top 5 %
quantitle(x, .05) # exclude bottom 5%
# sd() function is baked in 
# IQR - Interquartile Range 
