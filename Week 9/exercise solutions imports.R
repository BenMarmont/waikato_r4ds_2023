
# Set up ------------------------------------------------------------------

library(tidyverse)
library(readxl)
library(writexl)
library(googlesheets4)


# Spreadsheets:
#   22.2.10
# 1 –  class

# 1.	In an Excel file, create the following dataset and save it as survey.xlsx. 

# Alternatively, you can download it as an Excel file from here.
# https://docs.google.com/spreadsheets/d/1yc5gL-a2OOBr8M7B3IsDNX5uR17vBHOyWZq6xSTG2G8/edit#gid=0

# Then, read it into R, with survey_id as a character variable and n_pets as a 
# numerical variable. Hint: You will need to convert “none” to 0.

read_excel("Week 9/survey.xlsx", na = c("", "N/A")) |> 
  mutate(n_pets = if_else(n_pets == "two", "2", n_pets)) |> 
  mutate(n_pets = parse_number(n_pets))

# 2 –  bo

# In another Excel file, create the following dataset and save it as roster.xlsx. 
# Alternatively, you can download it as an Excel file from here.
# https://docs.google.com/spreadsheets/d/1oCqdXUNO8JR3Pca8fHfiz_WXWxMuZAp3YiYFaKze5V0/edit#gid=0
# Then, read it into R. The resulting data frame should be called roster and 
# should look like the following.


# with openxlsx
# install.packages("openxlsx")
# library(openxlsx)

read.xlsx(xlsxFile = "Week 9/roster.xlsx", fillMergedCells = TRUE)

# with readxl

?fill

read_excel("Week 9/roster.xlsx") |> 
  fill(group, subgroup)

# 3a – bo
# 3.	In a new Excel file, create the following dataset and save it as sales.xlsx. 
# Alternatively, you can download it as an Excel file from here.
# A # Read sales.xlsx in and save as sales. The data frame should look like the 
# following, with id and n as column names and with 9 rows.

read_excel("Week 9/sales.xlsx", skip = 4, col_names = c("id", "n"))

# b – bo 
# b. Modify sales further to get it into the following tidy format with three 
# columns (brand, id, and n) and 7 rows of data. Note that id and n are numeric, 
# brand is a character variable.

# thinking about the tables

tibble(
  id = c("Brand 1", 1234, 8721, 1822, "Brand 2", 3333, 2156, 3987, 3216),
  n = c("n", 8, 2, 3, "n", 1, 3, 6, 5)
)

tribble(
  ~brand,    ~id,  ~n,
  "Brand 1",  123, 8,
  "Brand 1", 8721, 2,
  "Brand 1", 1822, 3,
  "Brand 2", 3333, 1,
  "Brand 2", 2156, 3,
  "Brand 2", 3987, 6,
  "Brand 2", 3216, 5
)

# with read.xlsx
?read.xlsx
read.xlsx(xlsxFile = "Week 9/sales.xlsx", startRow = 5, colNames = FALSE) 

# with read_excel
read_excel("Week 9/sales.xlsx", skip = 3, col_names = c("id", "n")) |>
  mutate(brand = if_else(str_detect(id, "Brand"), id, NA)) |>
  fill(brand) |>
  filter(n != "n") |>
  relocate(brand) |>
  mutate(
    id = as.numeric(id),
    n = as.numeric(n)
  )

# 4 –  hw
# Recreate the bake_sale data frame, write it out to an Excel file using the 
# write.xlsx() function from the openxlsx package.

writing <- tibble(
  id = c("Brand 1", 1234, 8721, 1822, "Brand 2", 3333, 2156, 3987, 3216),
  n = c("n", 8, 2, 3, "n", 1, 3, 6, 5)
)

?write.xlsx

write.xlsx(writing, file = "Week 9/writing_xlsx.xlsx")

bake_sale <- tibble(
  item     = factor(c("brownie", "cupcake", "cookie")),
  quantity = c(10, 5, 8)
)

write.xlsx(bake_sale, file = "Week 9/bake_sale.xlsx")


# 5 –  hw 
# In Chapter 8 you learned about the janitor::clean_names() function to turn 
# columns names into snake case. Read the students.xlsx file that we introduced 
# earlier in this section and use this function to “clean” the column names.

# I can't find the students dataset...

?read_excel()
datasets <- readxl_example("datasets.xlsx")

students <- read_excel("R_Packages/readxl/extdata/students.xlsx")

# instead use bad_bake_sale

bad_bake_sale <- tibble(
  itemName     = factor(c("brownie", "cupcake", "cookie")),
  itemQuants = c(10, 5, 8)
)

write.xlsx(bad_bake_sale, file = "Week 9/bad_bake_sale.xlsx")

?janitor::clean_names
read_excel("Week 9/bad_bake_sale.xlsx") |> janitor::clean_names(case = "snake")

# foundd it
# https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0whttps://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w

read_excel("Week 9/students.xlsx") |> janitor::clean_names(case = "snake")

# 6 -  class
# What happens if you try to read in a file with .xlsx extension with read_xls()?

# it doesn't work:  libxls error: Unable to open file
  
read_xls("Week 9/sales.xlsx")
read_xlsx("Week 9/sales.xlsx")


# 22.3.6
# 1 –  class
# Read the students dataset from earlier in the chapter from Excel and also 
# from Google Sheets, with no additional arguments supplied to the read_excel() 
# and read_sheet() functions. Are the resulting data frames in R exactly the same? 
# If not, how are they different?

# googlesheets

# longer way
student_url <- "https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w"
read_sheet(student_url)

# note doing this directly will need some authentication
read_sheet("https://docs.google.com/spreadsheets/d/1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w/edit#gid=0/")

# readxl
read_excel("Week 9/students.xlsx")

# the two sheets are different, the googlesheets version guesses that age is a list 
# readxl has it as a character. Comes from the inclusion of "five" in an
# otherwise numerical column.

# 2 –  bo
# Read the Google Sheet titled survey from https://pos.it/r4ds-survey, 
# with survey_id as a character variable and n_pets as a numerical variable.

# reminder that R can't handle shortened links at this time
read_sheet("https://pos.it/r4ds-survey")

read_sheet("https://docs.google.com/spreadsheets/d/1yc5gL-a2OOBr8M7B3IsDNX5uR17vBHOyWZq6xSTG2G8/edit#gid=0")

?read_sheet

read_sheet("https://docs.google.com/spreadsheets/d/1yc5gL-a2OOBr8M7B3IsDNX5uR17vBHOyWZq6xSTG2G8/edit#gid=0", col_types = c("cc")) |> 
  mutate(n_pets = if_else(n_pets == "two", "2", n_pets)) |> 
  mutate(n_pets = parse_number(n_pets))

# 3 –  hw 
# Read the Google Sheet titled roster from https://pos.it/r4ds-roster. The 
# resulting data frame should be called roster and should look like the following.

# reminder that R can't handle shortened links at this time
read_sheet("https://pos.it/r4ds-roster/")

read_sheet("https://docs.google.com/spreadsheets/d/1LgZ0Bkg9d_NK8uTdP2uHXm07kAlwx8-Ictf8NocebIE/edit#gid=0") |> 
  fill(group, subgroup)
