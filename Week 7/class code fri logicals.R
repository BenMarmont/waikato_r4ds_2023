
library(tidyverse)
library(nycflights13)

# Logical Vectors ---------------------------------------------------------

x <- c(1, 2, 3, 5, 7, 11)
x

x2 <- x * 2

double_x <- tibble(x) |> 
  mutate(y = x * 2)

# <, >, <=, >=, !, !=, ==
?flights

flights |> 
  filter(dep_time > 600 & dep_time < 2000)

x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x
x == c(1, 2)

print(x, digits = 16)

near(x, c(1, 2))

?is.na()
is.na(x)

flights |> 
  filter(is.na(dep_time)) |> 
  arrange()

#STOP:
?near

sqrt(2) ^ 2 == 2
near(sqrt(2) ^ 2, 2)

# "&&" "||" 

flights |> 
  filter(month == 11 | month == 12)

flights |> 
  filter(month == 11 | 12)

# To get data in the last third
flights |> 
  filter(month >= 8)

# %in%

x %in% y
1:12 %in% c(1, 5, 11)
1:12 %in% c(1, 5, 11) |> sum()

flights |> 
  filter(month %in% c(11, 12))

c(1, 2, NA) == NA
c(1, 2, NA) %in% NA

flights |> 
  filter(dep_time %in% c(NA, 0800))

# true = 1
# false = 0

1:12 %in% c(1, 5, 11) |> mean()

?any # checks for any TRUEs
?all # checks for all TRUEs

ifelse() #base
if_else()#tidyverse

case_when() #only tidyverse version

# if else statements general form
#1) condition
#2) value when true
#3) value when false
# if_else(condition, true_value, false_value)

x <- c(-3:3, NA)

if_else(x > 0, "positive", "negative")

#4) how to handle missing values
if_else(x > 0, "positive", "negative", "?")

# case when general form
#1) condition
#2) output 
# case_when(condition ~ output)

case_when(
  x == 0 ~ "?",
  x > 0  ~ "positive",
  x < 0  ~ "negative"
)

case_when(
  x == 0   ~ "zero",
  x > 0    ~ "positive",
  x < 0    ~ "negative",
  is.na(x) ~ "?"
)

case_when(
  x > 0 ~ "postive",
  x < 0 ~ "negative",
  TRUE  ~ "other"
)
# note that catch all has to be the bottom condition and TRUE of the left.


