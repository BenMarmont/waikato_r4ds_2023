library(tidyverse)

table1
table2
table3

table1 |> 
  mutate(rate = cases / population * 100)

table1 |> 
  count(year, wt = cases)
table1 |> 
  ggplot(aes(x = year, y = cases)) + 
  geom_line(aes(group = country)) + 
  geom_point(aes(colour = country), shape = country)

table1 |> 
  ggplot(aes(x = year, y = cases)) + 
  geom_line(aes(group = country)) + 
  geom_point(aes(colour = country, shape = country))

table1 |> 
  ggplot(aes(x = year, y = cases)) + 
  geom_line(aes(group = country)) + 
  geom_point(aes(colour = country, shape = country)) + 
  scale_x_continuous(breaks = c(1999, 2000))

?count
?pivot_longer

billboard
?billboard

billboard |> 
  pivot_longer(cols = starts_with("wk"), 
               names_to = "week", values_to = "rank")

billboard |> 
  pivot_longer(cols = starts_with("wk"), 
               names_to = "week", values_to = "rank", 
               values_drop_na = TRUE)

billboard |> 
  pivot_longer(cols = starts_with("wk"), 
               names_to = "week", 
               values_to = "rank", 
               values_drop_na = TRUE) |> 
  view()

billboard |> 
  pivot_longer(cols = starts_with("wk"), 
               names_to = "week", 
               values_to = "rank", 
               values_drop_na = TRUE) |> 
  mutate(week = parse_number(week))

df |> 
  pivot_longer(cols = bp1:bp2, 
               names_to = "name", 
               values_to = "values")
who2
?who2

who2 |> 
  pivot_longer(cols = !country:year, 
               names_to = c("diagnosis", "gender", "age"), 
               names_sep = "_", values_to = "count")

?household
household

household |> 
  pivot_longer(cols = !family, 
               names_to = c(".value", "child"), 
               names_sep = "_", 
               values_drop_na = TRUE)

household |> 
  pivot_longer(cols = !family, 
               names_to = c(".value", "child"), 
               names_sep = "_", 
               values_drop_na = TRUE) |> 
  mutate(child = parse_number(child))

?pivot_wider

cms_patient_experience
?cms_patient_experience

cms_patient_experience |> 
  distinct(measure_cd, measure_title)

cms_patient_experience |> 
  pivot_wider(names_from = measure_cd, 
              values_from = prf_rate, 
              id_cols = starts_with("org"))

df <- tribble()
df

df |> 
  pivot_wider(names_from = measurement, 
              values_from = values_from)

df |> 
  pivot_wider(names_from = measurement, 
              values_from = value )

df |> distinct(measurement)

#library(styler)

short_descriptive_name <- 1
SHORTNAME <- 2

#this_is_snake_case

1+2 # doesnt follow convention
1 + 2 # follows convention

# z <- (a + b)^2 / d this follows convention
# z<-(a+b)^6/2 # does not follow convetion

library(nycflights13)

flights |> 
  mutate(
    speed =      air_time / distance,
    dep_hour =   dep_time %/% 100,
    dep_minute = dep_time %/% 100
      ) |> 
  mutate(
    speed =      air_time / distance,
    dep_hour =   dep_time %/% 100,
    dep_minute = dep_time %/% 100
    )

flights |> 
  mutate(
    speed =      air_time / distance,
    dep_hour =   dep_time %/% 100,
    dep_minute = dep_time %/% 100
) 

# strive for 
flights |> 
  group_by(tailnum) |> 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

# strive for 
flights |> 
  group_by(tailnum) |> 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
# strive for 
flights |> 
  group_by(tailnum) |> 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

# this is poor 
flights |> 
  group_by(tailnum) |> 
  summarise(delay = mean(arr_delay, na.rm = TRUE), n = n())

# another poor example
df |> mutate(y = x + 1)

# and a good example
df |> 
  mutate(
    y = x + 1
  )

# this shows how the good example lets us add code with ease
df |> 
  mutate(
    y = x + 1,
    z = t + 2
  )

flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(air_time / distance, na.rm = TRUE)
  ) |> 
  ggplot(aes(
    x = distance, 
    y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE, 
    color = "white", 
    linewidth = 4
  ) +
  geom_point()

# Section Header -----------

flights |>
  filter(
    dest == "IAH"
  ) |>
  group_by(year, month, day) |>
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm  = TRUE)
  ) |>
  filter(
    n > 10
  )

flights |>
  filter(
    carrier == "UA", 
    dest %in% c("IAH","HOU"), 
    sched_dep_time > 0900,
    sched_arr_time < 2000
  ) |>
  group_by(flight) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    cancelled = sum(is.na(arr_delay)),
    n = n()
  ) |> 
  filter(
    n > 10
  )

# repsonding to question about this operator
help("%/%")
