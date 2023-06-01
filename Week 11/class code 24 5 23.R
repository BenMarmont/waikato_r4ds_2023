  
library(tidyverse)
library(lubridate)

# modelling recap

lm(diamonds$carat ~ diamonds$price)

# iteration
df <- tibble(
  a = rnorm(10), 
  b = rnorm(10), 
  c = rnorm(10), 
  d = rnorm(10)
)

df

df |> summarise(median(a))
df |> summarise(median(b))
df |> summarise(median(c))
df |> summarise(median(d))

df |> 
  summarise(
    n = n(),
    a = median(a),
    b = median(b),
    c = median(c),
    d = median(d)
  )

?across

df |> 
  summarise(
    n = n(),
    across(a:d, median)
  )
#  general form of across: across(.cols, .fns)

df <- tibble(
  grp = sample(2, 10, replace = TRUE),
  a = rnorm(10), 
  b = rnorm(10), 
  c = rnorm(10), 
  d = rnorm(10)
)

# example of the across helper; everything()
df |> 
  group_by(grp) |> 
  summarise(across(everything(), median))
  
# the other across helper is; where()
?where

?iris

iris %>%
  mutate(across(where(is.double) & !c(Petal.Length, Petal.Width), round))

rnorm_na <- function(n, n_na, mean = 0, sd = 1){
  sample(c(rnorm(n - n_na, mean = mean, sd = 1), rep(NA, n_na)))
}

df_miss <- tibble(
  a = rnorm_na(5, 1),
  b = rnorm_na(5, 1),
  c = rnorm_na(5, 2),
  d = rnorm(5)
)

df_miss |> 
  summarise(
    across(a:d, median), n = n())

df_miss |> 
  summarise(
    across(a:d, function(x) median(x, na.rm = TRUE)), 
    n = n()
  )

df_miss |> 
  summarise(
    across(a:d, \(x) median(x, na.rm = TRUE)), 
    n = n()
  )

df_miss |> 
  summarise(
    a = median(a, na.rm = TRUE),
    b = median(b, na.rm = TRUE),
    c = median(c, na.rm = TRUE), 
    d = median(d, na.rm = TRUE),
    n = n()
  )

df_miss |> 
  summarise(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),
      n_miss = \(x) sum(is.na(x))
    )), 
    n = n()
          )
# changing the way the column names and functions are glued together to make 
# the new name in the summary output tibble.

df_miss |> 
  summarise(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),
      n_miss = \(x) sum(is.na(x))
    ), .names = "{.fn}_{.col}"), 
    n = n()
  )

# if_any and if_all are good alternatives if you want to use across with a filter

df_miss |> 
  filter(if_any(a:d, is.na))

df_miss |> 
  filter(if_all(a:d, is.na))

summarise_means <- function(df, summary_vars = where(is.numeric)){
  df |> 
    summarise(
      across({{ summary_vars }}, \(x) mean(x, na.rm = TRUE)),
      n = n()
    )
}

diamonds |> 
  group_by(cut) |> 
  summarise_means()

diamonds |> 
  group_by(clarity, cut) |> 
  summarise_means(c(carat, x:z))

# STOP: Calculate the number of unique values in each column of palmerpenguins::penguins
library(palmerpenguins)
penguins

a:d # (a and d were column names in that example)
everything()
where()

#  general form of across: across(.cols, .fns)

# data: penguins
# cols: species:year, everything()
# function: n_distinct

penguins |> 
  summarise(
    across(species:year, n_distinct)
           )

penguins |> 
  summarise(
    across(everything(), n_distinct)
  )

penguins |> 
  summarise(
    across(where(is.numeric), n_distinct))


# Saving multiple files --------------------------------------------------

by_clarity <- diamonds |> 
  group_nest(clarity)

?group_nest  

by_clarity

by_clarity$data
by_clarity$data[[8]]
by_clarity$data[[3]]

by_clarity <- by_clarity |> 
  mutate(path = str_glue("diamonds-{clarity}.csv"))

write_csv(by_clarity$data[[1]], by_clarity$path[[1]])
write_csv(by_clarity$data[[2]], by_clarity$path[[2]])
write_csv(by_clarity$data[[3]], by_clarity$path[[3]])

walk2(by_clarity$data, by_clarity$path, write_csv)


# Saving plots ------------------------------------------------------------

carat_histogram <- function(df){
  ggplot(df, aes(x = carat)) +
    geom_histogram(binwidth = 0.1)
}

carat_histogram(by_clarity$data[[1]])

by_clarity <- by_clarity |> 
  mutate(
    plot = map(data, carat_histogram),
    path = str_glue("clarity-{clarity}.png")
  )

walk2(
  by_clarity$path, 
  by_clarity$plot,
  \(path, plot) ggsave(path, plot, width = 6, height = 6)
    )

# Exercises 28.2.8 

#  2.	Compute the mean of every column in mtcars.

mtcars |> 
  summarise(
    across(everything(),  \(x) mean(x, na.rm = TRUE)),
    n = n(),
  )

mtcars |> 
  summarise(
    across(everything(), mean),
    n = n(),
  )

#  3.	Group diamonds by cut, clarity, and color then count the number of 
#     observations and the mean of each numeric column.

# general form: cols, fun
# grouping

# where(is.numeric)

diamonds |> 
  group_by(cut, clarity, color) |> 
  summarise(across(where(is.numeric),
                  list(count = \(x) n(),
                       mean = \(x) mean(x, na.rm = TRUE))))

# the '~' is the same as \(x) as a short hand for function

diamonds  |> 
  group_by(cut, clarity, color) %>%
  summarise(across(where(is.numeric), 
                   list(count = ~n(), 
                        mean  = ~mean(., na.rm = TRUE)))) 

