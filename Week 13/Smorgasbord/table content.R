## Flextable--------------------------------------------------------------------

# Lets look at how we might create publication quality tables using the flextable
# package and the mtcars dataset (part of the tidyverse) 

#install.packages("flextable")
library(flextable)

mtcars

# First lets turn the row names into columns called make and model. Note that currently
# they are formatted as rownames rather than as a column which are treated differently

mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  separate(Model, c("make", "model"))

# Now lets only select those columns relating to engine specifications and other 
#  specifications
mtcars %>% 
  select(cyl, hp, disp, mpg, wt, gear)

# Combine both steps and send to flextable
mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  select(Model, cyl, hp, disp, mpg, wt, gear) %>% 
  separate(Model, c("make", "model")) %>% 
  flextable()

# This is ok, but we can add headers and footers to make this better

mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  select(Model, cyl, hp, disp, mpg, wt, gear) %>% 
  separate(Model, c("make", "model")) %>% 
  flextable() %>% 
  add_header_row(values = c("Car","Engine specifications", "Other physical specifications"), 
                 colwidths = c(2,3,3)) %>%   
  add_footer_lines("mtcars data set showing headers and footers in flextable")

# We can even add themes to further improve 
mtcars %>% 
  rownames_to_column(var = "Model") %>% 
  select(Model, cyl, hp, disp, mpg, wt, gear) %>% 
  separate(Model, c("make", "model")) %>% 
  flextable() %>% 
  add_header_row(values = c("Car","Engine specifications", "Other physical specifications"), 
                 colwidths = c(2,3,3)) %>%   
  add_footer_lines("mtcars data set showing headers and footers in flextable") %>% 
  theme_zebra() 

# https://ardata-fr.github.io/flextable-book/design.html
# Show some of the very pretty table sin the documentation

## gt---------------------------------------------------------------------------

# Do i need this if I have flextable already? Probably not.

#install.packages("gt")
library(gt)

mtcars %>%
  rownames_to_column(var = "model") %>% 
  select(model, mpg) %>% 
  gt()