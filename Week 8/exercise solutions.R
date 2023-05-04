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
# 
# 19.2.5
# 1 – class
# 2 – class
# 3 – bo
# 
# Dates and Times
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
#   3. Which relig does denom (denomination) apply to? How can you find
# out with a table? How can you find out with a visualization?

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
  count(denom)

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

gss_cat |> pull(marital) |> levels()
gss_cat |> pull(race) |> levels() # arbitrary
gss_cat |> pull(rincome) |> levels() # principled
gss_cat |> pull(partyid) |> levels() # principled
gss_cat |> pull(relig) |> levels() # arbitrary
gss_cat |> pull(denom) |> levels() # arbitrary

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

# 3. Notice there are 9 groups (excluding other) in the fct_lump example
# above. Why not 10? (Hint: type ?fct_lump, and find the default for the
#                     argument other_level is “Other”.)