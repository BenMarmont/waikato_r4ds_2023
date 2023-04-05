# Exploratory Data Analysis (EDA)

# Question types to ask during EDA
## 1) variation
## 2) co-variation

# variable

# value

# observation

# tabular data

# A variable is a quantity, quality, or property that you can measure.

# A value is the state of a variable when you measure it. The value of a
  # variable may change from measurement to measurement.
 
# An observation is a set of measurements made under similar conditions
  # (you usually make all of the measurements in an observation at the same
  #   time and on the same object). An observation will contain several
  # values, each associated with a different variable. We’ll sometimes refer
  # to an observation as a data point.

# Tabular data is a set of values, each associated with a variable and an
  # observation. Tabular data is tidy if each value is placed in its own
  # “cell”, each variable in its own column, and each observation in its own
  # row.

# Variation is the tendency of the values of a variable to change from
# measurement to measurement

diamonds |> 
  ggplot(aes(carat)) +
  geom_histogram()

diamonds |> 
  ggplot(aes(carat)) +
  geom_histogram(binwidth = 0.5)

smaller <- diamonds |> 
  filter(carat < 3)

smaller |> 
  ggplot(aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)

?faithful

faithful |> 
  ggplot(aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

diamonds |> 
  ggplot(aes(x = y)) + 
  geom_histogram(binwidth = 0.5)

?coord_cartesian

diamonds |> 
  ggplot(aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

?ylim

diamonds |> 
  ggplot(aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  ylim(0, 50)

unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |> 
  arrange(y)

unusual
# view(unusual)
glimpse(unusual)



?diamonds

#  STOP:ex 12.3.3 - 3

# How many diamonds are 0.99 carat?
# How many are 1 carat?
# What might cause the difference

diamonds |> 
  filter(carat == 0.99)

diamonds |> 
  filter(carat == 0.99) |> 
  count()

diamonds |> 
  count(carat == 0.99)

diamonds |> 
  count(carat == 1)


diamonds2 <- diamonds |> 
  filter(between(y, 3, 20))

diamonds
?if_else

#if_else general form: 
# if_else(condition, true, false)

diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))

# beware the 'ifelse'. ifelse =/= if_else

?case_when

diamonds2 |> 
  ggplot(aes(x = x, y = y)) + 
  geom_point()

diamonds2 |> 
  ggplot(aes(x = x, y = y)) + 
  geom_point(na.rm = T)

# Warning message:
#   Removed 9 rows containing missing values (`geom_point()`).

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(colour = cancelled))

diamonds |> 
ggplot(aes(x = price)) +
  geom_freqpoly(aes(colour = cut), linewidth = 1.5)

ggplot(diamonds, aes(cut)) +
  geom_bar()

diamonds |>  
  ggplot(aes(x = price, y = after_stat(density))) + 
           geom_freqpoly(aes(colour = cut))


diamonds |> 
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot()

diamonds         
mpg

mpg |> 
  ggplot(aes(class, hwy)) +
  geom_boxplot()

mpg |> 
  ggplot(aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot()

mpg |> 
  ggplot(aes(y = fct_reorder(class, hwy, median), x = hwy)) +
  geom_boxplot()

mpg |> 
  ggplot(aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot() +
  coord_flip()


# 2 Categorical Variables -------------------------------------------------

diamonds |> 
  ggplot(aes(x = cut, y = color)) +
  geom_count()

diamonds |> 
  count(color, cut)

diamonds |> 
  count(color, cut) |> 
  ggplot(aes(x = color, y = cut)) +
    geom_tile(aes(fill = n))

# ?seriation

# 2 Numerical Variables ---------------------------------------------------

smaller |> 
  ggplot(aes(x = carat, y = price)) +
  geom_point()

smaller |> 
  ggplot(aes(x = carat, y = price)) +
  geom_point(alpha = 1/100)

smaller |> 
  ggplot(aes(x = carat, y = price)) +
  geom_bin2d()

# look at 'hexbin' package and geom_hex

smaller |> 
  ggplot(aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)))


# Patterns and models -----------------------------------------------------

faithful |> 
  ggplot(aes(x = eruptions, y = waiting)) +
  geom_point()




