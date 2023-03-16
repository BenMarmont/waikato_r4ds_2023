
library(tidyverse)
library(nycflights13)

?filter

filter(flights, arr_delay > 120)

flights |> filter(month == 1 & day == 1)
flights |> filter(month == 1 & day == 2)
flights |> filter(month %in% c(1,2))
flights |> filter(month == 1 | month == 2))

jan_feb_flights <- flights |> filter(month == 1 | month == 2)
View(jan_feb_flights)

?arrange
?desc

flights |> arrange(year, month, day)
flights |> arrange(year, month, day) |> view()
flights |> arrange(desc(year, month, day)) 
flights |> arrange(year, month, day) |> desc()
flights |> arrange(dep_delay)
flights |> filter(dep_delay <= 10 & dep_delay >= -10) |> arrange(desc(dep_delay))
flights |> filter(dep_delay <= 10 & dep_delay >= -10) |> arrange(desc(arr_delay))

?distinct
flights |> distinct(origin, dest)
?count
 # ex 4.3.5 
 # 2
# Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.
flights |> arrange(desc(dep_delay)) |> head()
flights |> arrange(desc(dep_delay))
# 5 Which flights traveled the farthest distance? Which traveled the least distance?

?flights

flights |> arrange(distance)
flights |> arrange(distance) |> glimpse()

?mutate
?select
?rename

?relocate

flights |> mutate(gain = dep_delay - arr_delay, speed = distance / air_time * 60)

?flights

flights |> mutate(gain = dep_delay - arr_delay, speed = distance / air_time * 60) |> glimpse()
flights |> mutate(gain = dep_delay - arr_delay, speed = distance / air_time * 60, .before = 1) |> glimpse()
flights |> mutate(gain = dep_delay - arr_delay, speed = distance / air_time * 60, .before = month) |> glimpse()
flights |> mutate(gain = dep_delay - arr_delay, speed = distance / air_time * 60, .after = month) |> glimpse()
flights |> mutate(gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours) |> glimpse()
flights |> mutate(gain = dep_delay - arr_delay, hours = air_time / 60, gain_per_hour = gain / hours, .keep = "used") |> glimpse()

?mutate

flights |> select(year, month, day)
flights |> select(year:day)
flights |> 
flights |> select(!year:day)

?select

flights |> select(contains("arr"))
flights |> select(tail_num = tailnum)

?rename

flights |> rename(tail_num = tailnum)

?relocate

flights |> relocate(time_hour, air_time)
flights |> relocate(time_hour, air_time, .before = dep_time)
flights |> select(dep_time, sched_dep_time, dep_delay)

?any_of
?group_by

flights |> group_by(month)
flights |> group_by(month) |> summarise(delay = mean(dep_delay))
flights |> group_by(month) |> summarise(delay = mean(dep_delay, na.rm = TRUE))
flights |> group_by(month) |> summarise(delay = mean(dep_delay, na.rm = TRUE), obs = n())
flights |> group_by(dest) |> slice_max(arr_delay, n = 1)
flights |> select(year:dep_delay) |> slice_max(dep_delay, n = 10)
flights |> group_by(day, month, year)

daily <- flights |> group_by(day, month, year)
daily |> summarise(n = n())
daily |> summarise(n = n()) |> glimpse()
daily |> ungroup()

flights |> summarise(av_dep_delay = mean(dep_time))
flights |> summarise(av_dep_delay = mean(dep_time, na.rm = TRUE))
flights |> mean(dep_time, na.rm = TRUE)
flights |> mean(dep_delay, na.rm = TRUE)
flights |> summarise(av_dep_delay = mean(dep_time))
flights |> summarise(av_dep_delay = mean(dep_delay))
flights |> summarise(av_dep_delay = mean(dep_delay, na.rm = T\))
flights |> group_by(dest) |> slice_max(dep_delay, n=1)

flights |> 
  group_by(dest, flight) |> 
  summarise(mean_dep_delay = mean(dep_delay, na.rm = T)) |> 
  arrange(desc(mean_dep_delay))

flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay), obs = n()
flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay), obs = n())
flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay, na.rm = TRUE), obs = n())
flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay, na.rm = TRUE), obs = n()) |> ggplot(aes(x = delay, y = obs)) + geom_freqpoly(binwidth = 10)
flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay, na.rm = TRUE), obs = n()) |> ggplot(aes(x = delay)) + geom_freqpoly(binwidth = 10)
flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay, na.rm = TRUE), obs = n()) |> ggplot(aes(x = obs, y = delay)) + geom_point()
flights |> filter(!is.na(arr_delay), !is.na(tailnum)) |> group_by(tailnum) |> summarise(delay = mean(arr_delay, na.rm = TRUE), obs = n()) |> ggplot(aes(x = obs, y = delay)) + geom_point(alpha = .1)

flights |> 
  filter(arr_delay >= 2) |> 
  filter(dest == "IAH" | dest == "HOU") |> 
  filter(carrier == "UA" | carrier == "AA" | carrier == "DL") |> 
  filter(month >=7 & month <= 9) |> 
  filter(arr_delay >= 120 & dep_delay == 0) |> 
  filter(dep_delay - arr_delay <= 30)