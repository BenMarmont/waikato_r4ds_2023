# Chapter 20 - Missing Values


# Set up ------------------------------------------------------------------
library(tidyverse)
library(nycflights13)


# Content -----------------------------------------------------------------

# so far we have seen...
drop_na()
# na.rm = T (inside some functions)
# omit.na 
# is.na

# remember the dplyr cheatsheet...

# Homework: download and print the dplyr and ggplot cheatsheets

treatment <- tribble(
  ~ person,           ~ treament, ~ response,
  "Derrick Whitmore", 1,            7,
  NA,                 2,            10,
  NA,                 3,            NA,
  "Katherine Burke",  1,            4
  )

treatment |> fill(everything())

x <- c(1, 4, 5, 7, NA)
x
coalesce(x, 0)

x <- c(1, 4, 5, 7, -99)
x
na_if(x, -99)

NaN 
NA

x <- c(NA, NaN)
x * 10
x == 1
is.na(x)
is.nan(x)

0/0
0 * Inf

stocks <- tibble(
  year  = c(2020 , 2020, 2020, 2021, 2021, 2021, 2021),
  qtr   = c(1,     2,    4,    1,    2,    3,    4),
  price = c(1.88,  0.59, 0.35, NA,   0.92, 0.17, 2.66)
  )
stocks

?pivot_wider

stocks |> 
  pivot_wider(
    names_from = qtr, 
    values_from = price
  )
  
stocks |> 
  pivot_wider(
    names_from = qtr, 
    values_from = price
  )

stocks
stocks |> complete(year, qtr)

stocks |> complete(year = 2019:2021, qtr)

nycflights13::airports

flights |> 
  distinct(faa = dest) |> 
  anti_join(airports)

flights |> 
  distinct(tailnum) |> 
  anti_join(planes)

health <- tibble(
  name   =   c(    "Ben", "Santiago", "Sally-Anne"),
  smoker = factor(c("no", "no",        "no"), levels = c("yes", "no")), 
  age    = c(21, 21, 21)
                )

health |> count(smoker)
health |> count(smoker, .drop = FALSE)

health |> 
  ggplot(aes(smoker)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

health |> 
  group_by(smoker) |> 
  summarise(
    n = n(),
    mean_age = mean(age),
    min_age  = min(age)
  )
 

health |> 
  group_by(smoker, .drop = FALSE) |> 
  summarise(
    n = n(),
    mean_age = mean(age),
    min_age  = min(age)
  )

health |> 
  group_by(smoker) |> 
  summarise(
    n = n(),
    mean_age = mean(age),
    min_age  = min(age)
  ) |> 
  complete(smoker)

?c()

# Chapter 21 - Joins --------------------------------------------------------------
library(tidyverse)
library(nycflights)

# Key types

# primary - variable/s that uniquely identify an observation. 
## When more than one variable is used its called a compound primary key.

airlines # primary key carrier code
airports # primary key faa code 
planes   # primary key tailnum
weather  # compound primary key - origin (location) and time hour

# foreign key - variable/s that corresponds to a primary key in another data set

flights$tailnum # foreign key in y
planes$tailnum  # primary key in x

# checking if these are good primary keys
planes |> 
  count(tailnum) |> 
  filter(n > 1)

weather |> 
  count(time_hour, origin) |> 
  filter(n > 1)

planes |> 
  filter(is.na(tailnum))

weather |> 
  filter(is.na(time_hour) | is.na(origin))

flights |> 
  count(time_hour, carrier, flight) |> 
  filter(n > 1)

airports |> 
  count(alt, lon) |> 
  filter(n > 1)

# STOP: Draw the relationship on a bit of paper between weather and airports
weather
airports

left_join()
right_join()
inner_join()
semi_join()
anti_join()
full_join()

# mutating 
flights2 <- flights |> 
  select(year, time_hour, origin, dest, tailnum, carrier)

flights2 |> 
  left_join(airlines)

weather

flights2 |>
  left_join(weather |> select(origin, time_hour, temp, wind_speed))

flights2 |> 
  left_join(planes)

flights2 |> 
  left_join(planes, join_by(tailnum))

flights2 |> 
  left_join(planes, join_by(tailnum == tailnum))

flights2 |> 
  left_join(airports, join_by(dest == faa))

?right_join

# filtering joins
airports |> 
  semi_join(flights2, join_by(faa == origin))

flights2 |> 
  anti_join(airports, join_by(dest == faa)) |> 
  distinct(dest)

flights2 |> 
  anti_join(planes, join_by(tailnum)) |> 
  distinct(tailnum)

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

x
y

x |> left_join(y, by = "key", keep = TRUE)
