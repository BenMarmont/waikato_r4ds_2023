
# Set up ------------------------------------------------------------------

library(tidyverse)
library(nycflights13)

# Allocations -------------------------------------------------------------

# Logicals
# 14.3.4
# 1 – bo
# 2 – bo 
# 3 – hw
# 
# 14.4.4
# 1 – class
# 2 – bo
# 
# Numbers
# 15.3.1
# 1 – class
# 2 – bo
# 
# 15.4.8
# 1 – bo
# 2 – hw
# 
# 15.5.4
# 1 – bo
# 2 – class
# 3 – bo
# 4 – hw
# 5 – hw
# 
# 15.6.7
# 1 – class
# 2 – bo
# 3 – hw
# 
# Strings
# 16.2.4
# 1 – class
# 2 – class 
# 
# 16.3.4
# 1 – class
# 2 – class 
# 
# Regular Expressions
# Nill



# Logicals ----------------------------------------------------------------

# 14.3.4
# 1 – bo
# 2 – bo 
# 3 – hw

# 1. Find all flights where arr_delay is missing but dep_delay is not. Find
# all flights where neither arr_time nor sched_arr_time are missing,
# but arr_delay is.

flights %>% 
  filter(is.na(arr_delay) & !is.na(dep_delay))

flights %>% 
  filter(!is.na(arr_time) & !is.na(sched_arr_time) & is.na(arr_delay))

# 2. How many flights have a missing dep_time? What other variables are
# missing in these rows? What might these rows represent?
flights |>  
  filter(is.na(dep_time)) |> 
  count(dep_time)

flights |>  
  filter(is.na(dep_time)) |> 
  summarise_all(~sum(is.na(.))) |> 
  glimpse()

# Cancelled flights

# 3. Assuming that a missing dep_time implies that a flight is cancelled,
# look at the number of cancelled flights per day. Is there a pattern? Is
# there a connection between the proportion of cancelled flights and the
# average delay of non-cancelled flights?

# Create a new variable indicating whether the flight was cancelled
flights_cancelled <- flights %>% 
  mutate(cancelled = if_else(is.na(dep_time), 1, 0))

# Group flights by date and calculate the number of cancelled flights per day
cancelled_by_date <- flights_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(cancelled_flights = sum(cancelled))

# Group non-cancelled flights by date and calculate the average delay per day
non_cancelled_by_date <- flights_cancelled %>% 
  filter(cancelled == 0) %>% 
  group_by(year, month, day) %>% 
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE))

# Combine cancelled and non-cancelled flights by date
flights_by_date <- full_join(cancelled_by_date, non_cancelled_by_date)

ggplot(flights_by_date, aes(x = as.Date(paste(year, month, day, sep = "-")), y = cancelled_flights)) +
  geom_line(color = "red") +
  geom_line(aes(y = avg_delay), color = "blue") +
  scale_x_date(date_labels = "%b %d %Y", date_breaks = "1 week") 
  
# 14.4.4
# 1 – class
# 2 – bo

# 1. What will sum(is.na(x)) tell you? How about mean(is.na(x))?
?sum # sums values in vector provided
?is.na # true returns 1, therefore a sum of a vector of is.na will show the number
# of trues in a vector
?mean # calculates the arithmetic mean. When applied to a vector of t/f will give the 
# proportion of trues

# 2. What does prod() return when applied to a logical vector? What
# logical summary function is it equivalent to? What does min() return
# when applied to a logical vector? What logical summary function is it
# equivalent to? Read the documentation and perform a few experiments.

?prod # product of all values in argument. Product of a vector containing either 
# 0s or 1s will always be 1 if no 0 i.e. all true , or zero if there is one 0, i.e. 1 false 
?min # gets minimum value in a vector

test <- c(T,T,F)
min(test)
max(test)

# Numbers -----------------------------------------------------------------
# 15.3.1
# 1 – class
# 2 – bo

# 1. How can you use count() to count the number rows with a missing
# value for a given variable?

# count(is.na(x)) counts the number of rows with missing values in vector x

# 2.Expand the following calls to count() to instead use group_by(),
#summarize(), and arrange():
  #1. 
    flights |> count(dest, sort = TRUE)

flights %>%
  group_by(dest) %>%
  summarize(n = n()) %>%
  arrange(desc(n))

  #2. 
    flights |> count(tailnum, wt = distance)

flights %>%
  group_by(tailnum) %>%
  summarize(total_distance = sum(distance, na.rm = TRUE), n = n()) %>%
  arrange(desc(total_distance))
    
    
# 15.4.8
# 1 – bo
# 2 – hw

# 1. Explain in words what each line of the code used to generate
  # Figure 15.1 does.
    
flights |>
  group_by(hour = sched_dep_time %/% 100) |>
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n())
filter(hour > 1) |>
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") +
  geom_point(aes(size = n))
        
    
# 2. What trigonometric functions does R provide? Guess some names and
#     look up the documentation. Do they use degrees or radians?

# 15.5.4
# 1 – bo
# 2 – class
# 3 – bo
# 4 – hw
# 5 – hw

# 1. Find the 10 most delayed flights using a ranking function. How do you
# want to handle ties? Carefully read the documentation for min_rank().
?min_rank

flights %>%
  filter(!is.na(arr_delay)) %>%
  arrange(desc(arr_delay)) %>%
  slice_min(n = 10, order_by = arr_delay, with_ties = FALSE) 

# 2. Which plane (tailnum) has the worst on-time record?

flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(tailnum) %>%
  summarize(avg_arr_delay = mean(arr_delay)) %>%
  arrange(desc(avg_arr_delay)) %>%
  head(n = 1)

# 3. What time of day should you fly if you want to avoid delays as much as
# possible?

flights %>%
  filter(!is.na(dep_delay)) %>%
  group_by(hour) %>%
  summarize(avg_dep_delay = mean(dep_delay)) %>%
  arrange(avg_dep_delay) %>%
  head(n = 1)


# 4. What does flights |> group_by(dest) |> filter(row_number()
#   filter(row_number(dep_delay) < 4) do?

flights |> group_by(dest) |> filter(row_number()< 4)

flights |> 
  group_by(dest) |> 
  filter(row_number(dep_delay) < 4)

# 5. For each destination, compute the total minutes of delay. For each flight,
# compute the proportion of the total delay for its destination.
    

# Strings -----------------------------------------------------------------
# 16.2.4
# 1 – class
# 2 – class 
 
# 16.3.4
# 1 – class
# 2 – class 

# 1. Create strings that contain the following values:
#   1. He said "That's amazing!"
#   2. \a\b\c\d
#   3. \\\\\\    
  
# 1. Compare and contrast the results of paste0() with str_c() for the
#   following inputs:
# 2. Convert the following expressions from str_c() to str_glue() or
#   vice versa:
#   a. str_c("The price of ", food, " is ", price)
#   b. str_glue("I'm {age} years old and live in {country}")
#   c. str_c("\\section{", title, "}")  