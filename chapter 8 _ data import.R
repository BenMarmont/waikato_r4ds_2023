# Data import

library(tidyverse)

students <- read_csv("https://raw.githubusercontent.com/hadley/r4ds/main/data/students.csv")
students <- read_csv("students.csv")

spec(students)

students

students <- read_csv("https://raw.githubusercontent.com/hadley/r4ds/main/data/students.csv", 
                     na = c("N/A", ""))
students

students |> 
  rename(
    student_name = `Full Name`,
    student_id = `Student ID`
  )

students <- students |> 
  janitor::clean_names() |> 
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

?janitor::clean_names

read_csv(
  "a, b, c
  1, 2, 3
  x, y, z"
  )

read_csv(
  "a, b, c
  1, 2, 3
  x, y, z", 
  skip = 1
)

read_csv(
  "a, b, c
  1, 2, 3
  x, y, z", 
  col_names = F
)

read_csv(
  "a, b, c
  1, 2, 3
  x, y, z", 
  col_names = c("cool", "calm", "collected")
)

csv <- "x
      10 
      .
      20
      30"
df <- read_csv(csv)

df <- read_csv(csv, col_types = list(x = col_double()))
problems(df)

df <- read_csv(csv, col_types = list(x = col_double()), na = c(".", ""))
?`readr-package`

  
read_csv("x, y, z
               1, 2, 3",
               cols_only(x = col_character()))

sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)

read_csv(sales_files, id = "file")

write_csv(students, "students.csv")
read_csv("students.csv")

?read_rds

#columnwise
tibble(
  x = c(1, 2, 3),
  y = c("a" , "b" ,"c"),
  z = c("Otago", "Massey", "Waikato")
)

# tRansposed tibble (columnwise)
tribble(
  ~x, ~y, ~z,
  1, "a", "Otago",
  2, "b", "Massey",
  3, "c", "Waikato"
)



# Exercises 8.2.4 ----------------------------------------------------------

# 1 What function would you use to read a file where fields were separated with “|”?
?read_delim
  
# 2 Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
# largely similar
?read_csv
?read_tsv

# 3 What are the most important arguments to read_fwf()?
?read_fwf
# width
# position
# empty

# 4 Sometimes strings in a CSV file contain commas. To prevent them from causing problems, 
# they need to be surrounded by a quoting character, like " or '. By default, read_csv() assumes that the quoting character will be ". 
#To read the following text into a data frame, what argument to read_csv() do you need to specify?
  
  "x,y\n1,'a,b'"
?read_csv
read_csv("x,y\n1,'a,b'")  
  
# 5 Identify what is wrong with each of the following inline CSV files. What happens when you run the code?
  
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")

# 6 Practice referring to non-syntactic names in the following data frame by:
 
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

  # a Extracting the variable called 1.
annoying |> select(`1`)

  # b Plotting a scatterplot of 1 vs. 2.
annoying |> 
  ggplot(aes(`1`, `2`)) +
  geom_point()

  # c Creating a new column called 3, which is 2 divided by 1.
annoying |> 
  mutate(
    `3` = `2` / `1`
  )
  # d Renaming the columns to one, two, and three.
annoying |> 
  mutate(
    `3` = `2` / `1`) |> 
  rename(
    one = `1`,
    two = `2`,
    three = `3`
  )  

