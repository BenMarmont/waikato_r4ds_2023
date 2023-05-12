

# Set up ------------------------------------------------------------------

library(tidyverse)
library(nycflights13)
library(readxl)
library(palmerpenguins)
library(writexl)
library(googlesheets4)

# Joins exercises  --------------------------------------------------------

# Joins:
# 21.2.4
# 5 – bo
# 
# Draw a diagram illustrating the connections between the Batting, People, 
# and Salaries data frames in the Lahman package. Draw another diagram that shows
# the relationship between:
                # People
                # Managers 
                # AwardsManagers. 
# How would you characterise the relationship between the: 
                # Batting 
                # Pitching
                # Fielding 
# data rames?

??lahman

Lahman::People

# 21.3.4
# 1 – bo

# Find the 48 hours (over the course of the whole year) that have the worst delays. 
# Cross-reference it with the weather data. Can you see any patterns?

colnames(flights)

bad_flights <- flights |> 
  mutate(hour = sched_dep_time %/% 100) |> 
  group_by(origin, year, month, day, hour) |> 
  summarise(av_dep_delay = mean(dep_delay, na.rm = T)) |> 
  ungroup() |> 
  arrange(desc(av_dep_delay)) |> 
  slice(1:48)

?left_join
?semi_join
?anti_join

bad_weather_flights <- semi_join(weather, bad_flights, by = c("origin", "year","month", "day", "hour"))
bad_weather_flights

# 2 – bo 
# 6 – bo (if time)


# Spreadsheets ------------------------------------------------------------
# library(readxl)

read_excel()
read_xls()
read_xlsx()

# Before we continue we need to download the survey, roster, students and 

getwd()

students <- read_excel("Week 9/students.xlsx")

students <- read_excel("Week 9/students.xlsx",
                       col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
                       skip = 1)

students <- read_excel("Week 9/students.xlsx",
                       col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
                       skip = 1,
                       na = c("", "N/A"),
                       col_types = c("numeric", "text", "text", "text", "numeric"))

students <- read_excel("Week 9/students.xlsx",
                       col_names = c("student_id", "full_name", "favourite_food", "meal_plan", "age"),
                       skip = 1,
                       na = c("", "N/A")) |> 
  mutate(age = if_else(age == "five", "5", age)) |> 
  mutate(age = parse_number(age))

read_excel("data/penguins.xlsx")

excel_sheets("Week 9/students.xlsx")

# added the palmer penguin sheet example after the fact, couldn't find the xlsx
# during class

# call sheet by position
read_excel("Week 9/penguins.xlsx ", sheet = 2)
# or, call sheet by name
read_excel("Week 9/penguins.xlsx", sheet = "Biscoe Island")

# you can print sheet names
readxl::excel_sheets("Week 9/penguins.xlsx ")

readxl_example()

deaths_path <- readxl_example("deaths.xlsx")
deaths <- read_excel(deaths_path)
deaths <- read_excel(deaths_path, skip = 4)
deaths <- read_excel(deaths_path, skip = 4, n_max = 10)
deaths <- read_excel(deaths_path, range = "A5:F15")

bake_sale <- tibble(
  item = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5 ,8)
)

writexl::write_xlsx(bake_sale, path = "Week 9/bake_sale.xlsx")
write_xlsx(bake_sale, 
           path = "Week 9/bake_sale.xlsx", 
           col_names = F)
write_xlsx(bake_sale, 
           path = "Week 9/bake_sale.xlsx", 
           format_headers = FALSE)

#  STOP:
# Read the students.xlsx file you downloaded earlier into R, with survey_id as 
# a character variable and n_pets as a numerical variable. 

read_excel("Week 9/survey.xlsx", 
           na = c("", "N/A")) |> 
  mutate(n_pets = if_else(n_pets == "two", "2", n_pets)) |> 
  mutate(n_pets = parse_number(n_pets), 
         survey_id = as.character(survey_id)) 
  
student_url <- "https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w/edit#gid=0"
students <- read_sheet(student_url)
students

students <- read_sheet(student_url,
                       col_names = c("students_id", "full_name", "favourite_food", "meal_plan", "age"),
                       skip = 1, 
                       na = c("", "N/A"),
                       col_types = c("dcccc"))
students |> 
  mutate(age = if_else(age == "five", "5", age)) |> 
  mutate(age = parse_number(age))

penguins_url <- "https://docs.google.com/spreadsheets/d/1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY/edit#gid=0"
sheet_names(penguins_url)

read_sheet(penguins_url, sheet = 2)
read_sheet(penguins_url, sheet = "Biscoe Island")


# Exercises ---------------------------------------------------------------

# In Chapter 8 you learned about the janitor::clean_names() function to turn 
# columns names into snake case. Read the students.xlsx file that we introduced 
# earlier in this section and use this function to “clean” the column names.

read_excel("Week 9/students.xlsx") |> janitor::clean_names()

# Recreate the bake_sale data frame, write it out to an Excel file using the 
# write.xlsx() function from the openxlsx package

running <- tibble(
  item = factor(c("shoes", "watch", "bottle")),
  quantity = c(1, 4, 100)
)

running

write_xlsx(running, path = "runningishard.xlsx")

desserts_needed <- tibble(
  dessert_name = factor(c("apple_crumble", "choc_pudding", "jelly")),
  quantity = c(3, 9, 6)
)
desserts_needed


