# Exercise solutions

# Allocations -------------------------------------------------------------

# 13.2.1
# 1 class
# 2 homework (h/w)
# 
# 13.3.1
# 1 h/w
# 2 class
# 3 breakout (b/o)
# 4 b/o
# 5 b/o
# 
# 13.4.6
# 1 calss
# 2 h/w
# 3 b/o
# 4 h/w
# 
# 13.5.1
# 1 class
# 2 h/w
# 
# 13.6.1
# 1 class
# 2 h/w
# 

# Solution set up ---------------------------------------------------------

library(tidyverse)
library(patchwork)
library(ggthemes)

# 13.2.1 ------------------------------------------------------------------

# 1 class
# 2 homework (h/w)

# 1 Create one plot on the fuel economy data with customized title,
  # subtitle, caption, x, y, and color labels.

?mpg
mpg$class |> unique()

mpg |> 
  ggplot(aes(cty, hwy, colour = class)) +
    geom_point() +
    labs(title = "Fuel use by transport type",
         subtitle = "More leads to more",
         caption = "Data: MPG, a subset of EPA fuel economy",
         x = "city fuel use",
         y = "highway fuel use",
         colour = "Car type")

# 2. Recreate the following plot using the fuel economy data. Note that both
#   the colors and shapes of points vary by type of drive train.

# 13.3.1 ------------------------------------------------------------------


# 1 h/w
# 2 class
# 3 breakout (b/o)
# 4 b/o
# 5 b/o

# 1. Use geom_text() with infinite positions to place text at the four
#   corners of the plot.
 


# 2. Use annotate() to add a point geom in the middle of your last plot
#   without having to create a tibble. Customize the shape, size, or color of
#   the point.

mpg |> 
  ggplot(aes(cty, hwy, colour = class)) +
  geom_point() +
  annotate(
    geom = "text", x = 22.5, y = 22.5, label = "middle of the road", size = 3, colour = "red")

mpg |> 
  ggplot(aes(cty, hwy, colour = class)) +
  geom_point() +
  annotate(
    geom = "text", x = 22.5, y = 22.5, label = "middle of the road", size = 13, colour = "blue")

mpg |> 
  ggplot(aes(cty, hwy, colour = class)) +
  geom_point() +
  annotate(
    geom = "text", x = 22.5, y = 22.5, label = "middle of the road", size = 30, colour = "green")
 
# 3. How do labels with geom_text() interact with faceting? How can you
#   add a label to a single facet? How can you put a different label in each
#   facet? (Hint: Think about the underlying data.)

mpg |> 
  ggplot(aes(cty, hwy)) +
  geom_point() +
  geom_vline(xintercept = 30) +
  facet_grid(~class) +
  annotate(geom = "text", x = 22.5, y = 22.5, label = "middle of the road", size = 30, colour = "green")

# both horizontal line and the label is added within each facet rather than over the top of them all 

# 4. What arguments to geom_label() control the appearance of the
#   background box?

?geom_label
# label.padding controls the amount of padding around the label.
# label.size controls the size of the label border in mm


# 5. What are the four arguments to arrow()? How do they work? Create a
#   series of plots that demonstrate the most important options.
?arrow
?grid::arrow()


# angle	
# The angle of the arrow head in degrees (smaller numbers produce narrower, pointier arrows). Essentially describes the width of the arrow head.

# length	
# A unit specifying the length of the arrow head (from tip to base).
 
# ends	
# One of "last", "first", or "both", indicating which ends of the line to draw arrow heads.
 
# type	
# One of "open" or "closed" indicating whether the arrow head should be a closed triangle.

# type
mpg |> 
  ggplot(aes(x = cty, y = hwy)) +
  geom_point() +
  annotate(geom = "segment", 
           x = 15, y = 15, xend = 22.5, yend = 22.5, 
           arrow = arrow(type = "closed")) # this can be set to open

# length
# ??

# ends
mpg |> 
  ggplot(aes(x = cty, y = hwy)) +
  geom_point() +
  annotate(geom = "segment", 
           x = 15, y = 15, xend = 22.5, yend = 22.5, 
           arrow = arrow(type = "closed", ends = "both")) # which end arrow head at
# angle   
mpg |> 
  ggplot(aes(x = cty, y = hwy)) +
  geom_point() +
  annotate(geom = "segment", 
           x = 15, y = 15, xend = 22.5, yend = 22.5, 
           arrow = arrow(type = "closed", angle = 90)) # angle of arrow head lines

# 13.4.6 ------------------------------------------------------------------


# 1 class
# 2 h/w
# 3 b/o
# 4 h/w

# 1. Why doesn’t the following code override the default scale?
df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_colour_gradient(low = "white", high = "red") +
  coord_fixed()

# geom_hex uses a fill, not a colour. Therefore changing code to reflect this means it will run

ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_gradient(low = "white", high = "red") +
  coord_fixed()

# 2. What is the first argument to every scale? How does it compare to
#   labs()?

# 3. Change the display of the presidential terms by:
#   a. Combining the two variants shown above.
#   b. Improving the display of the y axis.
#   c. Labelling each term with the name of the president.
#   d. Adding informative plot labels.
#   e. Placing breaks every 4 years (this is trickier than it seems!).

presidential |>
  mutate(id = 33 + row_number())
 
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3")) +
  labs(x = "Year", y = NULL, title = "Presidential Terms", subtitle = "Party Affiliation by Color",
       caption = "Data source: Midwest dataset") 
  
  scale_x_continuous(limits = c(1953, 2021), breaks = seq(1953, 2021, by = 4))
  
presidential |>
  mutate(id = 33 + row_number()) |> 
  ggplot(aes(x = start, y = id, color = party)) +
    geom_point(size = 2) +
    geom_segment(aes(xend = end, yend = president), size = 1) +
    scale_x_continuous(limits = c(1860, 1920), breaks = seq(1860, 1920, by = 4)) +
    scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3")) +
    labs(x = "Year", y = NULL, title = "Presidential Terms", subtitle = "Party Affiliation by Color",
         caption = "Data source: Midwest dataset") +
    theme_classic()

# 4. Use override.aes to make the legend on the following plot easier to
# see.


# 13.5.1 ------------------------------------------------------------------

 
# 1 class
# 2 h/w


# 13.6.1 ------------------------------------------------------------------


# 1 class
# 2 h/w
