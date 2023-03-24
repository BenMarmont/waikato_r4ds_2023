# Load packages
library(tidyverse)
library(ggthemes)
library(palmerpenguins)

# Continuing chapter 2 ----

# So far we have written code like this
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# But we can shorten it by following standard conventions 
penguins |> 
  ggplot(aes(flipper_length_mm, body_mass_g)) +
    geom_point()
# |> is called the pipe, it takes things to the right of it and then passes it
# to the right. It can be interpreted as 'and then'. There are two pipe operators:
# ' |> ' and ' %>% ' that you may see in the wild.

# Moving to mapping categorical variables
ggplot(penguins, aes(x = species)) +
  geom_bar()

# Reordering bars 
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

# Visualising continuous variable distributions
## Binwidth is important, sets the size of the groups (width of the bars on histogram)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

# Exploring binwidth 
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)

# Exploring distribution plots
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

# Exercise 2.4.3 q 1:
# Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?
ggplot(penguins, aes(y = species)) +
  geom_bar()

# Boxplots to view distributions
ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

# Density plots
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)
# Colouring area under density curve
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

# Categorical variables
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()
# Normalising the distribution between 0 and 1
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") 

# Two numerical variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# Three+ variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))
# But this is horrendous to interpret, instead we will facet the data

# Facetting
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

# Saving plots
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")
# Always saves the last plot

# Chapter 3 ----
# Coding basics

# You can use R as a calculator
1*100
2/4
(2*3)/2
5^2
sin(pi/2)

# You can create named objects 
test_name <- 5
# and call named objects
test_name

# You can create objects with multiple values i.e. a vector
primes <- c(2, 3, 5, 7)
primes

# You can do operations to objects
primes^2

# You can created new objects refering to old objects
primes2 <- primes^2
primes2

# Naming conventions
# Names cannot start with a number, but can contain numbers. They should also be descriptive
1name <- 5
# doesnt work
name1 <- 5 
# does work

# Naming styles
this_is_snake_case <- 5
# Ben prefers snake case
this.is.period.case <- 5
thisIsCamelCase <- 5
this_follows.No.conventionAndIs_hard.to_read <- 5

# Function form
# function(argument1 = variable1, ..., argumentn = variablen)
# for example
seq(from = 1, to = 10)

# you can assign text to an object
txt <- "hello_world"
txt

# Exercises 2.2.5 ----
# 6
?geom_point()
# changes how missing values are handled. Default is FALSE

# 7
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species",
    caption = "Data from palmerpenguins package") +
  scale_color_colorblind()

# 8
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = bill_depth_mm)) +
  geom_smooth()

# 10
# Will look the same, local and global settings are set the same

# Exercises 2.4.3 ----
# 2
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
# colour of bars set by chaning fill, colour changes outline

# 3 
# Bins changes the number of bins in histogram
?geom_histogram()

# 4
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = .01)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = .5)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = .75)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 1)

# Exercises 2.5.5
# 1
?mpg
# Categorical are manufacturer, model, cyl, displ, drv, fl, class

# 2
ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point()
ggplot(mpg, aes(x = hwy, y = displ, colour = cty)) +
  geom_point()
ggplot(mpg, aes(x = hwy, y = displ, colour = cty, shape = cty)) +
  geom_point()
# Can't map continuous to shape without binning, can map to colour and will use a gradient

# 3 
ggplot(mpg, aes(x = hwy, y = displ, linewidth = cty)) +
  geom_point()
# nothing, there is no line in a scatterplot

# 4 
ggplot(mpg, aes(x = cty, y = cty)) +
  geom_point()
# You make a useless graph, or you may add value i.e. shape and colour mapped to same variable as a 3rd variable on scatterplot

# 5
ggplot(penguins, aes(x = bill_depth_mm, y = bill_length_mm, colour = species)) +
  geom_point()
# The different species are different sizes

# 6
# The legend labels are different because only one is capitalised

# Exercises 3.5

# 1
# the code doesn't work because one is a "1" and the other an "i"

# 2
# libary(todyverse)
# 
# ggplot(dTA = mpg) + 
#   geom_point(maping = aes(x = displ y = hwy)) +
#   geom_smooth(method = "lm)

libary(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy), method = "lm")

# 3
# alt + shft + k brings up all keyboard shortcuts 
# So does 'help' in the top left then navigate the menue to keyboard shortcuts

# 4
# The first plot is saved because it is called by name.