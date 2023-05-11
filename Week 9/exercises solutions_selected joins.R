
# Set up ------------------------------------------------------------------

library(tidyverse)
library(nycflights13)

# Allocation --------------------------------------------------------------

# 21.2.4
# 5 – bo

# 5.	Draw a diagram illustrating the connections between the Batting, People, 
# and Salaries data frames in the Lahman package. Draw another diagram that shows 
# the relationship between People, Managers, AwardsManagers. 

# How would you characterise the relationship between the Batting, Pitching, 
# and Fielding data frames?

Lahman::Batting |> colnames()
Lahman::People |> colnames()
Lahman:: Salaries |> colnames()

# PlayerID a good key, yearID also useful depending on what you are trying to achieve.
# Together these would make a good compound key.

Lahman::Batting |> 
  group_by(yearID, playerID) |> 
  count(n>1)

Lahman::Batting
Lahman::Pitching
Lahman::Fielding

# The primary keys of Batting, Pitching, and Fielding are the following:
  
# Batting: (playerID, yearID, stint)
# Pitching: (playerID, yearID, stint)
# Fielding: (playerID, yearID, stint, POS).

# Since Batting, Pitching, and Fielding all share the playerID, yearID, and stint
# we would expect some foreign key relations between these tables. 
# The columns (playerID, yearID, stint) in Pitching are a foreign key which 
# references the same columns in Batting. We can check this by checking that all 
# observed combinations of values of these columns appearing in Pitching also
# appear in Batting. To do this I use an anti-join, which is discussed in the section Filtering Joins.

anti_join(Lahman::Pitching, Lahman::Batting,
               by = c("playerID", "yearID", "stint"))

# Similarly, the columns (playerID, yearID, stint) in Fielding are a foreign key 
# which references the same columns in Batting.

anti_join(Lahman::Fielding, Lahman::Batting,
               by = c("playerID", "yearID", "stint"))

# 21.3.4
# 1 – bo
# 1.	Find the 48 hours (over the course of the whole year) that have the worst 
# delays. Cross-reference it with the weather data. Can you see any patterns?


# I will start by clarifying how I will be measuring the concepts in the question. There are three concepts that need to be defined more precisely.
# 
# What is meant by “delay”? I will use departure delay. Since the weather data only contains data for the New York City airports, and departure delays will be more sensitive to New York City weather conditions than arrival delays.
# 
# What is meant by “worst”? I define worst delay as the average departure delay per flight for flights scheduled to depart in that hour. For hour, I will use the scheduled departure time rather than the actual departure time. If planes are delayed due to weather conditions, the weather conditions during the scheduled time are more important than the actual departure time, at which point, the weather could have improved.
# 
# What is meant by “48 hours over the course of the year”? This could mean two days, a span of 48 contiguous hours, or 48 hours that are not necessarily contiguous hours. I will find 48 not-necessarily contiguous hours. That definition makes better use of the methods introduced in this section and chapter.
# 
# What is the unit of analysis? Although the question mentions only hours, I will use airport hours. The weather dataset has an observation for each airport for each hour. Since all the departure airports are in the vicinity of New York City, their weather should be similar, it will not be the same.

worst_hours <- flights %>%
  mutate(hour = sched_dep_time %/% 100) %>%
  group_by(origin, year, month, day, hour) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(desc(dep_delay)) %>%
  slice(1:48)

weather_most_delayed <- semi_join(weather, worst_hours, 
                                  by = c("origin", "year",
                                         "month", "day", "hour"))

select(weather_most_delayed, temp, wind_speed, precip) 

ggplot(weather_most_delayed, aes(x = precip, y = wind_speed, color = temp)) +
  geom_point()

# 2 – bo 
# 2.	Imagine you’ve found the top 10 most popular destinations using this code:

flights2 <- flights %>%
  select(year, time_hour, origin, dest, tailnum, carrier)

top_dest <- flights2 |>
count(dest, sort = TRUE) |>
head(10)

top_dest

?inner_join

flights |> 
  inner_join(top_dest)

# 6 – bo (if time)
# 6.	Add the latitude and the longitude of the origin and destination airport to 
# flights. Is it easier to rename the columns before or after the join?

library(tidyverse)
library(nycflights13)

# Get latitude and longitude for origin airport
origin_coords <- airports %>%
  select(origin = faa, origin_lat = lat, origin_lon = lon)

# Get latitude and longitude for destination airport
dest_coords <- airports %>%
  select(dest = faa, dest_lat = lat, dest_lon = lon)

# Join latitude and longitude with flights data frame
flights_with_coords <- flights %>%
  left_join(origin_coords, by = "origin") %>%
  left_join(dest_coords, by = "dest")

# Rename the latitude and longitude columns
flights_with_coords <- flights_with_coords %>%
  rename(origin_latitude = origin_lat,
         origin_longitude = origin_lon,
         dest_latitude = dest_lat,
         dest_longitude = dest_lon)s

