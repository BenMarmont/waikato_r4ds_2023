#  Allocation ----

# Factors:
#   18.3.1
# 1 – homework (hw)
# 2 – Class
# 3 – Breakout (bo)
# 
# 18.4.1
# 1 – class
# 2 – bo
# 3 – bo
# 
# 18.5.1
# 1 – hw
# 2 – class
# 3 – bo



# Dates and Times
# 19.2.5
# 1 – class
# 2 – class
# 3 – bo

# 19.3.4
# 1 – class
# 2 – hw
# 3 – bo
# 4 – bo
# 5 – bo
# 6 – hw
# 7 – hw
# 
# 19.4.4
# 1 – class
# 2 – hw
# 3 – bo
# 4 – bo

# Set up ---
library(tidyverse)
library(lubridate)
library(nycflights13)


# 18.3.1 Exercise ----

# 1. Explore the distribution of rincome (reported income). What makes the
# default bar chart hard to understand? How could you improve the plot?
#   2. What is the most common relig in this survey? What’s the most
# common partyid?
#   3. Which relig does denom (denomination) apply to? 
# How can you find out with a table? 
# How can you find out with a visualization?

# 1. Explore the distribution of rincome (reported income). What makes the
# default bar chart hard to understand? How could you improve the plot?
gss_cat |> 
  ggplot(aes(y = rincome)) +
  geom_bar()

# Some of the values are no straight forward. LT 1000 could be renamed as lower than (no need for abbr),
#   refused, don't know or no answer could be grouped or excluded.

#   2. What is the most common relig in this survey? What’s the most
# common partyid?
gss_cat |> 
  ggplot(aes(y = relig)) +
  geom_bar()

gss_cat |> 
  count(relig)

gss_cat |> 
  ggplot(aes(y = partyid)) +
  geom_bar()

#   3. Which relig does denom (denomination) apply to? How can you find
# out with a table? How can you find out with a visualization?

gss_cat |> 
  count(denom, sort = T) |> view()

ggplot(gss_cat, aes(y = fct_infreq(denom))) +
  geom_bar() 


# 18.4.1 Exercises ----
# 1. There are some suspiciously high numbers in tvhours. Is the mean a
# good summary?
#   2. For each factor in gss_cat identify whether the order of the levels is
# arbitrary or principled.
# 3. Why did moving “Not applicable” to the front of the levels move it to
# the bottom of the plot?


# 1. There are some suspiciously high numbers in tvhours. Is the mean a
# good summary?
gss_cat |> 
  count(tvhours)

gss_cat |> 
  summarise(av_tv = mean(tvhours, na.rm = T), 
            med_tv = median(tvhours, na.rm = T))

gss_cat |> 
  ggplot(aes(tvhours)) +
  geom_bar()

# the observations with 10 or more hours will lift the average significantly and likely not realisitic for many
# median may be more appropriate

# 2. For each factor in gss_cat identify whether the order of the levels is
# arbitrary or principled.
gss_cat

# numerical values excluded

gss_cat |> pull(marital) |> levels() # arbitrary
gss_cat |> pull(race)    |> levels() # arbitrary
gss_cat |> pull(rincome) |> levels() # principled, ish not applicable should be grouped with others
gss_cat |> pull(partyid) |> levels() # principled
gss_cat |> pull(relig)   |> levels() # arbitrary
gss_cat |> pull(denom)   |> levels() # arbitrary

# 3. Why did moving “Not applicable” to the front of the levels move it to
# the bottom of the plot?

ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

?fct_relevel
# we moved it to the front of the line therefore plotted at the bottom.

# 18.5.1 Exercises ----
# 1. How have the proportions of people identifying as Democrat,
# Republican, and Independent changed over time?
#   2. How could you collapse rincome into a small set of categories?
#   3. Notice there are 9 groups (excluding other) in the fct_lump example
# above. Why not 10? (Hint: type ?fct_lump, and find the default for the
#                     argument other_level is “Other”.)

# 1. How have the proportions of people identifying as Democrat,
# Republican, and Independent changed over time?
gss_cat %>%
  group_by(year, partyid) %>%
  summarise(count = n()) %>%
  mutate(prop = count / sum(count))

# 2. How could you collapse rincome into a small set of categories?
gss_cat

gss_cat |> pull(rincome) |> levels()

gss_cat %>% 
  mutate(rincome_cat = fct_collapse(rincome,
                                    "Under $5K" = c("$4000 to 4999", "$3000 to 3999",  "$1000 to 2999", "Lt $1000"),
                                    "Over $5K" = c("$8000 to 9999", "$7000 to 7999", "$6000 to 6999", "$5000 to 5999"),
                                    "Other" = c("No answer", "Don't know", "Refused", "Not applicable"))) 

# 3. Notice there are 9 groups (excluding other) in the fct_lump example
# above. Why not 10? (Hint: type ?fct_lump, and find the default for the
#                     argument other_level is “Other”.)

gss_cat |>
  mutate(relig = fct_lump_n(relig, n = 10)) |>
  count(relig, sort = TRUE)

?fct_lump

# because we specified n = 10
# n defined as: Positive n preserves the most common n values. 
# Negative n preserves the least common -n values. 
# It there are ties, you will get at least abs(n) values.


# Exercises 19.2.5 --------------------------------------------------------

# 1 – class

# What happens if you parse a string that contains invalid dates?
  
ymd(c("2010-10-10", "bananas"))
#  Cannot pass invalid dates, remove/filter it out or extract the string then pass
ymd(c("2010-10-10"))

# 2 – class

# What does the tzone argument to today() do? Why is it important?
today()  

?today()

# tzone: a character vector specifying which time zone you would like the current time in. 
# tzone defaults to your computer's system timezone. 
# You can retrieve the current time in the Universal Coordinated Time (UTC) with now("UTC").

# 3 – bo

# For each of the following date-times show how you’d parse it using a readr column-specification and a lubridate function.
d1 <- "January 1, 2010"
mdy(d1)
d2 <- "2015-Mar-07"
ymd(d2)
d3 <- "06-Jun-2017"
dmy(d3)
d4 <- c("August 19 (2015)", "July 1 (2015)")
mdy(d4)
d5 <- "12/30/14" # Dec 30, 2014
mdy(d5)
t1 <- "1705"
hm(t1)
# need to format the date, so use string manipulation
hm(str_c(str_sub(t1, 1, 2), sep = ":", str_sub(t1, 3, 4)))
t2 <- "11:15:10.12 PM"
md_hm(t2)
# need to remove "pm" and set the seperator
mdy_h(str_c(str_sub(t2, 1, 8), sep = "T", str_sub(t2, -5, -3)))
# Exercises 19.3.4 --------------------------------------------------------

# 1 – class
# 2 – hw
# 3 – bo
# 4 – bo
# 5 – bo
# 6 – hw
# 7 – hw

# 1. How does the distribution of flight times within a day change over the
# course of the year?


# 2. Compare dep_time, sched_dep_time and dep_delay. Are they
# consistent? Explain your findings.


# 3 - bo. Compare air_time with the duration between the departure and
# arrival. Explain your findings. (Hint: consider the location of the
# airport.)
colnames(flights)

flights %>% 
  mutate(
    dep_time = make_datetime(year, month, day, dep_time),
    arr_time =  make_datetime(year, month, day, arr_time),
    duration = as.numeric(arr_time - dep_time)
        )    

# 4 - bo. How does the average delay time change over the course of a day?
# Should you use dep_time or sched_dep_time? Why?

# use observed time (dep time) to capture delays
flights %>% 
  mutate(
    dep_time = make_datetime(year, month, day, dep_time),
    arr_time =  make_datetime(year, month, day, arr_time),
    duration = as.numeric(arr_time - dep_time)
  ) |> 
  group_by(hour) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  ggplot(aes(hour, avg_delay)) +
  geom_line()

# 5 - bo. On what day of the week should you leave if you want to minimise the
# chance of a delay?

flights %>%
  drop_na() |> 
  mutate(dep_time = ymd_hm(str_c(year, month, day, dep_time, sep = "-"))) %>%
  mutate(day_of_week = wday(dep_time)) %>%
  group_by(day_of_week) %>%
  summarise(avg_delay = mean(arr_delay)) 

#tuesday

# 6. What makes the distribution of diamonds$carat and
# flights$sched_dep_time similar?

# 7. Confirm our hypothesis that the early departures of flights in minutes 20-
# 30 and 50-60 are caused by scheduled flights that leave early. Hint:
# create a binary variable that tells you whether or not a flight was
# delayed.
  

# Exercises 19.4.4 --------------------------------------------------------

# 1 – class
# 2 – hw
# 3 – bo
# 4 – bo

# 1. Explain days(overnight * 1) to someone who has just started
# learning R. How does it work?

# days(overnight * 1) is a command in R using the lubridate package that calculates 
# the number of days between two dates or times. Here, overnight is a variable that 
# likely represents the duration of a flight or some other event that spans over multiple days.
# 
# The days() function is used to indicate that we want the result of our calculation 
# to be expressed in days. The * symbol is used to multiply the value of overnight by 1,
# which doesn't actually change the value of overnight, but it does ensure that R treats 
# the result as a numeric value instead of a time duration object.
# 
# So essentially, days(overnight * 1) converts a duration object (i.e., a time period) 
# to the equivalent number of days. For example, if overnight represents a duration of 36 hours, 
# the expression days(overnight * 1) would return the value 1.5, indicating that the duration spans 1.5 days.


# 2. Create a vector of dates giving the first day of every month in 2015.
# Create a vector of dates giving the first day of every month in the
# current year.


# 3. Write a function that given your birthday (as a date), returns how old
# you are in years.


# 4. Why can’t (today() %--% (today() + years(1))) / months(1)
# work?
