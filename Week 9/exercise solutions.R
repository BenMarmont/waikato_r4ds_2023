
# Set up ------------------------------------------------------------------
library(tidyverse)
library(nycflights13)
library(lubridate)

# Allocations -------------------------------------------------------------

# Missing values

## 20.3.4
# 1 - bo

# Joins

## 21.2.4
# 1 - class
# 2 - hw
# 3 - hw
# 4 - bo
# 5 - bo

## 21.3.4
# 1 - bo
# 2 - bo
# 3 - hw
# 4 - hw
# 5 - hw
# 6 - bo

## 21.5.5
# 1 - bo
# 2 - bo

# Chapter 20 - Missing Values ---------------------------------------------

# 20.3.4 Exercises --------------------------------------------------------
# 1. Can you find any relationship between the carrier and the rows that
# appear to be missing from planes?

  flights %>% 
    anti_join(planes, by = "tailnum") %>% 
    group_by(carrier) %>% 
    summarise(num_missing = n())

# Chapter 21 - Joins ------------------------------------------------------

# 1. We forgot to draw the relationship between weather and airports in
# Figure 21.1. What is the relationship and how should it appear in the
# diagram?

# 2. weather only contains information for the three origin airports in NYC.
# If it contained weather records for all airports in the USA, what
# additional connection would it make to flights?

# 3. The year, month, day, hour, and origin variables almost form a
# compound key for weather, but there’s one hour that has duplicate
# observations. Can you figure out what’s special about that hour?

flights2 <- flights |>
  mutate(id = row_number(), .before = 1)

flights2

# 4. We know that some days of the year are special and fewer people than
# usual fly on them (e.g. Christmas eve and Christmas day). How might
# you represent that data as a data frame? What would be the primary
# key? How would it connect to the existing data frames?

# First create a tibble of these dates, then left join by dates.

# Create a data frame of special days
special_days <- tibble(date = ymd(c("2013-12-24", "2013-12-25", "2014-01-01")), special_day = TRUE)

# Join the special days data frame to the flights data set, we can then drop NA to get the special flights

flights %>% 
  mutate(date = date(time_hour)) |> 
  select(origin, dest, flight, date) |> 
  left_join(special_days, by = "date") |> 
  drop_na(special_day)
  
# 5. Draw a diagram illustrating the connections between the Batting,
# People, and Salaries data frames in the Lahman package. Draw
# another diagram that shows the relationship between People,
# Managers, AwardsManagers. How would you characterise the
# relationship between the Batting, Pitching, and Fielding data
# frames?

# 21.3.4
# 1. Find the 48 hours (over the course of the whole year) that have the
# worst delays. Cross-reference it with the weather data. Can you see
# any patterns?

# 2. Imagine you’ve found the top 10 most popular destinations using this
# code: How can you find all flights to those destinations?
  
top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)

# 3. Does every departing flight have corresponding weather data for that
# hour?
  
# 4. What do the tail numbers that don’t have a matching record in planes
# have in common? (Hint: one variable explains ~90% of the problems.)

# 5. Add a column to planes that lists every carrier that has flown that
# plane. You might expect that there’s an implicit relationship between
# plane and airline, because each plane is flown by a single airline.
# Confirm or reject this hypothesis using the tools you’ve learned in
# previous chapters.

# 6. Add the latitude and the longitude of the origin and destination airport
# to flights. Is it easier to rename the columns before or after the join?

# 7. Compute the average delay by destination, then join on the airports
# data frame so you can show the spatial distribution of delays. Here’s an
# easy way to draw a map of the United States:
# You might want to use the size or color of the points to display the
# average delay for each airport.

airports |>
  semi_join(flights, join_by(faa == dest)) |>
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 8. What happened on June 13 2013? Draw a map of the delays, and then
# use Google to cross-reference with the weather.

# 21.5.5
# 1. Can you explain what’s happening with the keys in this equi-join? Why
# are they different?

x |> full_join(y, by = "key")
x |> full_join(y, by = "key", keep = TRUE)

# 2. When finding if any party period overlapped with another party period
# we used q < q in the join_by()? Why? What happens if you remove
# this inequality?
