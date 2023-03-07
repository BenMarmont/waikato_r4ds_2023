
# Note: This file is an R script, '#' can be interpreted as comments and are not evaluated when
## code is run. Run code by pushing shift and enter while code is selected.

# Loading packages ----

library(tidyverse)
library(ggrepel)
library(palmerpenguins)
library(ggthemes)

# Interacting with the console(evaluate code by pushing control + enter, or 
#   paste into the console and push enter)
1 + 2
10 / 2
10 * 2
10 ^ 2

# Functional form ----
## In r text by itself means an object, i.e.
penguins
## text with paranthesis means a function, i.e.
sum()
## text with two colons means a function within a specific package, i.e.
palmerpenguins::penguins

# Viewing data ---- 
penguins
glimpse(penguins)
view(penguins)

# Documentation ----
## You can type a question mark followed by a function/object to view any help/
##    documentation if there is any
?penguins

# Plotting ----
## Assigning data to the plot
ggplot(data = penguins)
## Mapping variables to aesthetics
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g))
## Adding a geometrical object to represent the data

## Note the error code in the previous plot, this comes from missing values in the data.
# We can view them with:
penguins %>% 
  select(species, flipper_length_mm, body_mass_g) %>% 
  filter(is.na(body_mass_g) | is.na(flipper_length_mm))
# Don't worry, the code doesn't make sense to you now, it will soon!

# Adding colours for species
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = species)) + 
  geom_point()
# Adding a smooth line
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = species)) + 
  geom_point() +
  geom_smooth()
# Keeping one smooth line for the population, but colour by species
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(mapping = aes(colour = species)) +
  geom_smooth()
# Making line straight
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(method = "lm")
# Adding shapes
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(mapping = aes(colour = species, shape = species)) +
  geom_smooth(method = "lm")
# Adding plot labels
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(mapping = aes(colour = species, shape = species)) +
  geom_smooth(method = "lm") + 
  labs(title = "Body mass and flipper length",
       subtitle = "Dimensions for Adelie, Chinstrap and Gento Penguins",
       x = "Flipper length (mm)",
       y = "Body mass (g)",
       shape = "Species",
       colour = "Species")
# Adding colour blind friendly palette
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(mapping = aes(colour = species, shape = species)) +
  geom_smooth(method = "lm") + 
  labs(title = "Body mass and flipper length",
       subtitle = "Dimensions for Adelie, Chinstrap and Gento Penguins",
       x = "Flipper length (mm)",
       y = "Body mass (g)",
       shape = "Species",
       colour = "Species") + 
  scale_colour_colorblind()

# Exercises 2.2.5 ----
## How many rows & columns in penguins?
glimpse(penguins) #344 x 8
penguins #344 x 8
view(penguins) #344 x 8

## What does 'bill_depth_mm' mean in penguins?
?penguins
# a number denoting bill depth (millimeters)

## Make a scatterplot of bill depth and length. Describe relationship.
ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point()
## Lame plot, could make better by looking at species differences
ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(mapping = aes(colour = species)) 
## and, could add a smooth line for more insight
ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(mapping = aes(colour = species))
# this can be simplified by moving the colour mapping to global aesthetic settings
ggplot(data = penguins, mapping = aes(x = bill_depth_mm, y = bill_length_mm, colour = species)) +
  geom_point() +
  geom_smooth()

## What's wrong with this code
ggplot(data = penguins) + 
  geom_point()
## No mappings, error message tells you that you need to add x and y aesthetics.