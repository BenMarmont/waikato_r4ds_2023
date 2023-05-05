
# Chapter 18 - Factors  ---------------------------------------------------
# Set up ------------------------------------------------------------------
library(tidyverse)


# forcats - gss_cat
gss_cat
?gss_cat

# factor functions are called with fct_

x1 <- c("Dec", "Apr", "Jan", "Mar")
x1
sort(x1)

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
month_levels

y1 <- factor(x1, levels = month_levels)
sort(y1)

y1 <- fct(x1, levels = month_levels)
sort(y1)

f2 <- x1 |> 
  factor() |> 
  fct_inorder()
f2 |> sort()

levels(f2)

csv <- "
month, value
Jan, 12
Feb, 56
Mar, 12
"

read_csv(csv, col_types = cols(month = col_factor(month_levels)))

gss_cat |> 
  count(race)

# STOP: What is the most common relig in this survey? What’s the most common partyid?
gss_cat |> 
  count(relig, sort = T) #protestant
gss_cat |> 
  count(partyid, sort = T) #independant

gss_cat |> 
  group_by(relig) |>
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T), 
    n = n()
          )

gss_cat |> 
  group_by(relig) |>
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T), 
    n = n()
  ) |> 
  ggplot(aes(x = tvhours, y = relig)) +
    geom_point()

gss_cat |> 
  group_by(relig) |>
  summarise(
    age = mean(age, na.rm = T),
    tvhours = mean(tvhours, na.rm = T), 
    n = n()
  ) |> 
  ggplot(aes(x = tvhours, y = fct_reorder(relig, tvhours))) +
  geom_point()

# fct_reorder general 
# fct_reorder(factor(to change), vector(to reorder by), and optional FUNCTION)


relig_summary <- gss_cat |>
  group_by(relig) |>
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

relig_summary |>
  mutate(
    relig = fct_reorder(relig, tvhours)
  )|> 
  ggplot(aes(tvhours, relig)) +
  geom_point()

income_summary <- 
  gss_cat |> 
  group_by(rincome) |> 
  summarise(age = mean(age, na.rm = T))
  
income_summary |> 
  ggplot(aes(x =age, y = rincome)) +
  geom_point()

income_summary |> 
  ggplot(aes(x =age, y = fct_reorder(rincome, age))) +
  geom_point()

income_summary |> 
ggplot(aes(x = age, y = fct_relevel(rincome, "Not applicable"))) +
  geom_point()

gss_cat |> 
  count(partyid)

gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat"
    ))|> 
  count(partyid)

gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat",
                         "Other"                 = "No answer",
                         "Other"                 = "Don't know",
                         "Other"                 = "Other party"
    )
  )|> 
  count(partyid)

gss_cat |> 
  mutate(
    partyid = fct_collapse(partyid, 
                          "other" = c("No answer", "Don't know", "Other party"), 
                          "rep" = c("Strong republican", "Not str republican"), 
                          "ind" = c("Ind,near rep", "Independent", "Ind,near dem"), 
                          "dem" = c("Not str democrat", "Strong democrat"))
    ) |> count(partyid)


gss_cat |> 
  mutate(relig = fct_lump_lowfreq(relig)) |> 
  count(relig)

ordered(c("a", "b", "c", "d"))
# Levels: a < b < c < d

# Chapter 19 Dates and times ----------------------------------------------
library(lubridate)
library(nycflights13)

# <date>
# <time>
# <dttm> - POSIXct

# todays date
today()
# current date time
now()

# dates seperated with a dash
# dadates and times seperated by space or T
# times sepererateed wth a colon

ymd("2017-01-31")
mdy("January-31-2017")
dmy("31-Jan-2017")
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017T08:01")

flights |> 
  select(year, month, day, hour, minute) |> 
  mutate(departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights |> 
  filter(!is.na(dep_time), !is.na(arr_time)) |> 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
        )|> 
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt |> 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 86400) # 86400 secs in a day

flights |> 
  filter(dep_time < ymd(20130102)) |> 
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 600) # 600 = 10 mins

# to change types
as_datetime

# STOP 

# What happens if you parse a string that contains invalid dates?
ymd(c("2010-10-10", "bananas"))  # banana is not a date

# what does the tzone argument do in today?
?today()
# specify your timezone

datetime <- ymd_hms("2026-07-08 12:34:56")

year(datetime)
month(datetime)
# day(datetime)
mday(datetime)
yday(datetime)
wday(datetime)
hour(datetime)
minute(datetime)
second(datetime)
# can ask for labels
wday(datetime, label = T)
month(datetime, label = T)

flights_dt |> 
  mutate(wday = wday(dep_time, label = T)) |> 
  ggplot(aes(x = wday)) +
  geom_bar()

floor_date()
round_date()
ceiling_date()

flights_dt |> 
  count(week = floor_date(dep_time, "week")) |> 
  ggplot(aes(week, n)) +
  geom_point() + 
  geom_line()

datetime

year(datetime) <- 2030
datetime

day(datetime) <- 15
datetime

update(datetime, year = 2030, month = 2, hour = 2)

tomorrow <- today() + ddays(1)

x1 <- ymd_hms("2024-06-01 12:00:00", tz = "America/New_York")
x1

x2 <- ymd_hms("2024-06-01 18:00:00", tz = "Europe/Copenhagen")
x2

x3 <- ymd_hms("2024-06-02 04:00:00", tz = "Pacific/Auckland")
x3

x1 - x2

x2- x1

x1 - x3

# Timezone check

# this is when daylight savings ends (in NZ)
nz_ds_end <- dmy_hms("24-09-2023 02:00:00", tz = "Pacific/Auckland")

# this is mid day the day before daylight savings ends
ns_1 <- dmy_hm("23-09-2023 12:00", tz = "Pacific/Auckland")

# this is mid day the day after daylight savings ends
ns_2 <- dmy_hm("25-09-2023 12:00", tz = "Pacific/Auckland")

# this is the duration between midday the day before and the day after daylight savings
# we expec this to be 2 days (48 hours) normally. But because daylight sacings is ending it isnt.

ns_2 - ns_1
# 1.958533

