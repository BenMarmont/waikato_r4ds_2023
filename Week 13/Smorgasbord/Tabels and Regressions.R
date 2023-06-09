

library(tidyverse)

# Flextable ---------------------------------------------------------------

mtcars
?mtcars
view(mtcars)
glimpse(mtcars)

# install.packages("flextable")
library(flextable)

mtcars |> 
  rownames_to_column(var = "Model")

tibble::rownames_to_column()

our_mtcars <-  mtcars |> 
  rownames_to_column(var = "Model") |> 
  separate(Model, c("Make", "Model"))

mtcars |> 
  select(Make, Model, cyl, hp, disp, mpg, wt, gear)

mtcars |> 
  select(Make, Model, cyl, hp, disp, mpg, wt, gear) |> 
  flextable()

mtcars |> 
  select(Make, Model, cyl, hp, disp, mpg, wt, gear) |> 
  flextable() |> 
  add_header_row(values = c("Car", "Engine Specifications", "Physical Specfications"),
                 colwidths = c(2, 3, 3)) |> 
  add_footer_lines("Footer example for modified mtcars dataset") |> 
  theme_zebra()

# ?add_footer_lines
# ?add_footer_row
# ?add_header_row

# install.packages("gt")


# GT ----------------------------------------------------------------------

library(gt)

our_mtcars |> 
  select(Make, Model, mpg, cyl) |> 
  gt()


# Regressions -------------------------------------------------------------

diamonds

?lm()

# General form of lm()
#lm(dependent_variable ~ indent_var_1 + independent_var_2... + independent_variable_n, data = diamonds)

diamonds_linear_model <-  lm(price ~ cut + carat, data = diamonds)
diamonds_linear_model

summary(diamonds_linear_model)

#install.packages("sjPlot")
library(sjPlot)

diamonds_linear_model |> 
  summary() |> 
  tab_model()

# exploring some of the tab model arguments
diamonds_linear_model |> 
  summary() |> 
  tab_model(
    p.val = "wald",
    show.df = 5,
    digits = 5,
    show.ci = F,
    show.icc = T,
    show.stat = F
    # file = "linear_diamonds_summary.html"
          )

?tab_model
