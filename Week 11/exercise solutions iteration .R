library(tidyverse)
library(palmerpenguins)

# 28.2.8 Exercises

# 1.	Compute the number of unique values in each column of palmerpenguins::penguins.

penguins |> 
  summarise(across(where(is.numeric), n_distinct))

penguins |> 
  summarise(across(everything(), n_distinct))

# 2.	Compute the mean of every column in mtcars.

mtcars |> 
  summarise(across(everything(), ~ mean(.)))

mtcars |> 
  summarise(across(everything(), ~ mean(., na.rm = TRUE)))

# 3.	Group diamonds by cut, clarity, and color then count the number of observations 
# and the mean of each numeric column.

# need to use 'where' to only calculate on numeric cols

diamonds  |> 
  group_by(cut, clarity, color) %>%
  summarise(across(where(is.numeric), 
                   list(count = ~n(), 
                        mean  = ~mean(., na.rm = TRUE)))) 


# 4.	What happens if you use a list of functions, but don’t name them? 
#  How is the output named?

#  

# 5.	It is possible to use across() inside filter() where it’s equivalent to if_all(). Can you explain why?

# 6.	Adjust expand_dates() to automatically remove the date columns after they’ve been expanded. Do you need to embrace any arguments?

# 7.	Explain what each step of the pipeline in this function does. What special feature of where() are we taking advantage of?
  show_missing <- function(df, group_vars, summary_vars = everything()) {
    df |> 
      group_by(pick({{ group_vars }})) |> 
      summarize(
        across({{ summary_vars }}, \(x) sum(is.na(x))),
        .groups = "drop"
      ) |>
      select(where(\(x) any(x > 0)))
  }
nycflights13::flights |> show_missing(c(year, month, day))
