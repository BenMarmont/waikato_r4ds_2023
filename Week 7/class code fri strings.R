# Strings - Chapter 16

# stringr is the package, part of tidyverse
# string functions start with str

string_1 <- "This is a string 123"
string_number <- "1"
string_2 <- 'This is a string "Including a quote" '

backslash <- "\\"
str_view(backslash)

str_c("This is the start of the string", "and this is the end of the string")

str_c("This is the start of the string", "and this is the end of the string", sep = " ")

df <- tibble(name = c("Flora", "David", "Terra"))

df |> 
  mutate(greeting = str_glue("Hi {{name}}, good to see you!"))

# to summarise values use str_flatten

str_length("Ben")

?str_sub
vector <- "R for Data Science"
vector |> 
  str_sub(1, 5)

vector |> 
  str_sub(-7, -1)

# Other useful string things
str_view(str_trunc(vector, 3))

?str_trunc
