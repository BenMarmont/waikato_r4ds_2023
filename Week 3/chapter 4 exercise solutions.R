# Data transformation exercises
library(tidyverse)
library(nycflights13)

# 4.2.5

# 1 In a single pipeline, find all flights that meet all of the following conditions:
  # Had an arrival delay of two or more hours
  # Flew to Houston (IAH or HOU)
  # Were operated by United, American, or Delta
  # Departed in summer (July, August, and September)
  # Arrived more than two hours late, but didn’t leave late
  # Were delayed by at least an hour, but made up over 30 minutes in flight

airlines # United = UA, American = AA, Delta = DL

# as one
flights |> 
  filter(arr_delay >= 2) |> 
  filter(dest == "IAH" | dest == "HOU") |> 
  filter(carrier == "UA" | carrier == "AA" | carrier == "DL") |> 
  filter(month >=7 & month <= 9) |> 
  filter(arr_delay >= 120 & dep_delay == 0) |> 
  filter(dep_delay - arr_delay <= 30)
# separate
flights |> 
  filter(arr_delay >= 2) 

flights|> 
  filter(dest == "IAH" | dest == "HOU")

flights|>  
  filter(carrier == "UA" | carrier == "AA" | carrier == "DL")
# Alterantively
filter(flights, carrier %in% c("AA", "DL", "UA"))

flights|>  
  filter(month >=7 & month <= 9)

flights|>
  filter(arr_delay >= 120 & dep_delay == 0)

flights|> 
  filter(dep_delay - arr_delay <= 30)


# 2 Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.
flights |> 
  arrange(desc(dep_delay)) |> 
  head()

flights |> 
  arrange(dep_time) |> 
  head()

# 3 Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)
# shortest
head(arrange(flights, air_time))
# highest speed 
flights |> 
  arrange(desc(distance / air_time))

# 4 Was there a flight on every day of 2013?
flights |> 
  filter(year == 2013) |> 
  distinct(month, day)

# 5 Which flights traveled the farthest distance? Which traveled the least distance?
flights |> 
  arrange(desc(distance)) |> 
  head()

flights |> 
  arrange(distance) |> 
  head()
  
# 6 Does it matter what order you used filter() and arrange() if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.
# No.

# 4.3.5
# 1 Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
flights |> 
  select(dep_time, sched_dep_time, dep_delay)
# delay to be result of subtracting the former
   
# 2 Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
# Select, -select, relocate, contains, starts with and ends with 

# 3 What happens if you specify the name of the same variable multiple times in a select() call?
flights |> 
  select(year, year)

# 4  What does the any_of() function do? Why might it be helpful in conjunction with this vector?
variables <- c("year", "month", "day", "dep_delay", "arr_delay")

flights |> 
  select(any_of(variables))
 
# 5 Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?
flights |> select(contains("TIME"))
flights |> select(contains("TIME", ignore.case = FALSE))
# defaults to case insensitive
# can add ignore.case = TRUE to make it case sensitive
 
# 6 Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
flights |> 
  rename(air_time_min = air_time) |> 
  glimpse()

# 7 Why doesn’t the following work, and what does the error mean?
  flights |>
  select(tailnum) |>
  arrange(arr_delay)
#> Error in `arrange()`:
#> ℹ In argument: `..1 = arr_delay`.
#> Caused by error:
#> ! object 'arr_delay' not found

# The code doesn't work because the select() only grabs tailnum, need to include arr_delay in the selection before you can arrange by it
  
# Exercises 4.5.7

# 1 Which carrier has the worst average delays? 
  #Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? 
  #(Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))

flights |> 
  group_by(carrier) |> 
  summarise(average_delay = mean(arr_delay, na.rm = TRUE)) |> 
  arrange(desc(average_delay))
  
# one idea of challenge response
flights |> 
  group_by(carrier, dest) |> 
  summarise(average_delay = mean(arr_delay, na.rm = TRUE))|> 
  arrange(desc(average_delay))

# 2 Find the flights that are most delayed upon departure from each destination.
# I've interpreted this question as find the flights that are the most delayed in departing when grouped by destination.
flights |> 
  group_by(dest, flight) |> 
  summarise(mean_dep_delay = mean(dep_delay, na.rm = T)) |> 
  arrange(desc(mean_dep_delay))

# 3 How do delays vary over the course of the day. Illustrate your answer with a plot.
flights |> 
  ggplot(aes(x = dep_time, y = arr_delay)) + 
  geom_smooth()
# big delay at the beginning and end of the day

# 4 What happens if you supply a negative n to slice_min() and friends?
?slice_head
# A negative value of n or prop will be subtracted from the group size. 

# 5  Explain what count() does in terms of the dplyr verbs you just learned. What does the sort argument to count() do?
?count()   
# count() lets you quickly count the unique values of one or more variables
# sort:	If TRUE, will show the largest groups at the top.

# 6 Suppose we have the following tiny data frame:
#   
#   df <- tibble(
#     x = 1:5,
#     y = c("a", "b", "a", "a", "b"),
#     z = c("K", "K", "L", "L", "K")
#   )
# 
#   a Write down what you think the output will look like, then check if you were correct, and describe what group_by() does.
# 
# df |>
#   group_by(y)
# 
#   b Write down what you think the output will look like, then check if you were correct, and describe what arrange() does. Also comment on how it’s different from the group_by() in part (a)?
#   
#   df |>
#   arrange(y)
# 
#   c Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
# 
# df |>
#   group_by(y) |>
#   summarize(mean_x = mean(x))
# 
#   d Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. Then, comment on what the message says.
# 
# df |>
#   group_by(y, z) |>
#   summarize(mean_x = mean(x))
# 
#   e Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. How is the output different from the one in part (d).
# 
# df |>
#   group_by(y, z) |>
#   summarize(mean_x = mean(x), .groups = "drop")
# 
#   f Write down what you think the outputs will look like, then check if you were correct, and describe what each pipeline does. How are the outputs of the two pipelines different?
#   
#   df |>
#   group_by(y, z) |>
#   summarize(mean_x = mean(x))
# 
#   df |>
#   group_by(y, z) |>
#   mutate(mean_x = mean(x))
