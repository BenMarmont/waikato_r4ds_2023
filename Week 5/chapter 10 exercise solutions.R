# Exercise Solutions


# Exercise allocation (class, breakouts, homework) ------------------------
# 
# 11.2.1                  
# 1 – class               
# 2 – breakout (bo)
# 3 –  bo
# 4 – homework (hw)
# 
# 11.3.1
# 1 – hw
# 2 – bo
# 3 – hw
# 4 – bo
# 
# 11.4.1
# 1 – bo
# 2 – class
# 3 – bo
# 4 – bo
# 5 – hw
# 6 – hw
# 7 – bo
# 
# 11.5.1
# 1 – bo
# 2 – class
# 3 – hw
# 4 – hw
# 5 – bo
# 
# 11.6.1
# 1 – bo
# 2 – class
# 3 – bo
# 4 – hw
# 
# 11.7.1
# 1 – class
# 2 – bo
# 3 – hw (or bo if time)

# 11.2.1 ------------------------------------------------------------------

# 1  Create a scatterplot of hwy vs. displ where the points are pink filled in
#    triangles.

mpg |> 
  ggplot(aes(hwy, displ)) +
  geom_point(shape = 17, colour = "deeppink")

# 2 Why did the following code not result in a plot with blue points?
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy, color = "blue"))

# because the colour call should be outside the aes
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy), color = "blue")

# 3 What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
?geom_point
# Using search in the subject: "Use the stroke aesthetic to modify the width of the border"

# 4. What happens if you map an aesthetic to something other than a variable
#     name, like aes(color = displ < 5)? Note, you’ll also need to
#     specify x and y.

mpg |>
  ggplot(aes(hwy, displ, colour = displ < 5)) +
  geom_point()

# creates a true/false mapping of the relationship to colour


# 11.3.1 ------------------------------------------------------------------
# 1. What geom would you use to draw a line chart? A boxplot? A
#      histogram? An area chart?
geom_line()
geom_boxplot()
geom_histogram()
geom_area()
  ?geom_area()

#   2. Earlier in this chapter we used show.legend without explaining it:
#      What does show.legend = FALSE do here? What happens if you
#      remove it? Why do you think we used it earlier?
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

?geom_smooth()
#  From documentation : show.legend:	
#     logical. Should this layer be included in the legends? NA, the default, 
#     includes if any aesthetics are mapped. FALSE never includes, 
#     and TRUE always includes. It can also be a named logical vector to finely 
#     select the aesthetics to display.

# It removes the legend when one is made. Used earlier to simplify the graphs 
#     and make them more comparable.

#   3. What does the se argument to geom_smooth() do?
?geom_smooth
# From documentation: se	
#     Display confidence interval around smooth? 
#     (TRUE by default, see level to control.)

#   4. Recreate the R code necessary to generate the following graphs. Note
#      that wherever a categorical variable is used in the plot, it’s drv.

# a
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  geom_smooth(se = F)

# b 
mpg |> 
  ggplot(aes(displ, hwy, group = drv)) +
  geom_point() +
  geom_smooth(se = F)

# c
mpg |> 
  ggplot(aes(displ, hwy, group = drv, colour = drv)) +
  geom_point() +
  geom_smooth(se = F)

# d
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(se = F)

# e
mpg |> 
  ggplot(aes(displ, hwy, group = drv)) +
  geom_point(aes(colour = drv)) +
  geom_smooth(se = F, aes(linetype = drv))

# d
mpg |> 
  ggplot(aes(displ, hwy, colour = drv)) +
  geom_point()
# unsure if the example has white boxes around it (depends on version)
ggplot(mpg, aes(displ, hwy, fill = drv)) +
  geom_point(shape = 21, colour = "white", stroke = 3)


# 11.4.1 ------------------------------------------------------------------

# 1. What happens if you facet on a continuous variable?
mpg
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_line() +
  facet_wrap(~cty)

# makes a lot of useless graphs

#  2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean?
#   Run the following code. How do they relate to the resulting plot?

# Empty cells means to data in that group.

ggplot(mpg) +
  geom_point(aes(x = drv, y = cyl))

# this is a graph of discrete variables mapped against each other hence why it looks silly.

#  3. What plots does the following code make? What does . do?
  ggplot(mpg) +
  geom_point(aes(x = drv, y = cyl))
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# the . indicates no faceting in that side of the formula

# 4. Take the first faceted plot in this section:
#     What are the advantages to using faceting instead of the color aesthetic?
# faceting letls you see the trends in each group clearer.

#     What are the disadvantages? How might the balance change if you had a
#     larger dataset?
# if there is an important relationship between groups it may not be as 
#   apparent when faceting.

#   5. Read ?facet_wrap. What does nrow do? What does ncol do? What
#     other options control the layout of the individual panels? Why doesn’t
#     facet_grid() have nrow and ncol arguments?

# nrow = number of rows
# ncol = number of columns
# facet grid doesn't have these because the they are implied by the relationship ie x ~ y

#   6. Which of the following two plots makes it easier to compare engine size
#     (displ) across cars with different drive trains? What does this say
#     about when to place a faceting variable across rows or columns?

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ drv)

# first is more useful to me, easiest to compare.

#   7. Recreate the following plot using facet_wrap() instead of
#      facet_grid(). How do the positions of the facet labels change?

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .) # facet by 2 vars

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~drv, ncol = 1) # facet by 1 var


# 11.5.1 ------------------------------------------------------------------
# 1. What is the default geom associated with stat_summary()? How could
#     you rewrite the previous plot to use that geom function instead of the stat
#     function?
?stat_summary
geom_pointrange()

# 2. What does geom_col() do? How is it different from geom_bar()?
?geom_col
?geom_bar
#geom_bar makes the height og the bar proportional to the number of cases in each group
# geom bar users stat_coount by default and geom col uses stat_identity by default

# 3. Most geoms and stats come in pairs that are almost always used in
#     concert. Read through the documentation and make a list of all the pairs.
#     What do they have in common?

# See cheatsheet or use ChatGPT
# stat_count() - creates a histogram or bar chart of the frequency of values in a variable. The default geom is geom_bar().
# stat_density() - creates a density plot of a variable. The default geom is geom_density().
# stat_bin() - creates a histogram or bar chart of binned values in a variable. The default geom is geom_bar().
# stat_summary() - computes summary statistics of a variable and displays them in a plot. The default geom is geom_pointrange().
# stat_smooth() - adds a smoothed line to a plot, typically using a regression model. The default geom is geom_smooth().
# stat_ecdf() - creates an empirical cumulative distribution function plot of a variable. The default geom is geom_step().
# stat_quantile() - creates a plot showing the quantiles of a variable. The default geom is geom_quantile().
# stat_boxplot() - creates a boxplot of a variable. The default geom is geom_boxplot().
# stat_identity() - plots data as is, without any statistical transformation. The default geom is geom_point().
# stat_summary_hex() - creates a heatmap of summary statistics of a variable. The default geom is geom_hex().
# stat_sf() - displays spatial data using the sf package. The default geom is geom_sf().

# 4. What variables does stat_smooth() compute? What arguments control
#     its behavior?
?stat_smooth
# stat_smooth takes the same arguments as geom_smooth

# 5. In our proportion bar chart, we need to set group = 1. Why? In other
#     words, what is the problem with these two graphs?
ggplot(diamonds, aes(x = cut, y = after_stat(prop))) +
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) +
  geom_bar()
# the group argument is needed to ensure the calculations are computed for the  
# population rather than subset.

# see how to add the group argument below
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) +
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop), group = 1)) +
  geom_bar()


# 11.6.1 ------------------------------------------------------------------

# 1. What is the problem with the following plot? How could you improve
#   it?
ggplot(mpg, aes(x = cty, y = hwy)) +
geom_point()

# 2. What parameters to geom_jitter() control the amount of jittering?
?geom_jitter
# width and heigth

# 3. Compare and contrast geom_jitter() with geom_count().
?geom_jitter
?geom_count

mpg |> 
  ggplot(aes(displ, hwy)) + 
  geom_jitter()

mpg |> 
  ggplot(aes(displ, hwy)) + 
  geom_count()

# geom_point scales point size relative to observations close by.
# geom_jitter moves points by adding random noise.
# both address overplotting by reducing the number of points in one location.

# 4. What’s the default position adjustment for geom_boxplot()? Create a
#    visualization of the mpg dataset that demonstrates it.

?geom_boxplot
# default position is dodge

mpg |> 
ggplot(aes(x = class, y = hwy, fill = class)) +
  geom_boxplot()

# 11.7.1 ------------------------------------------------------------------
# 1. Turn a stacked bar chart into a pie chart using coord_polar().
mpg |> 
  ggplot(aes(drv, fill = drv)) +
  geom_bar() +
  coord_polar()
# 2. What’s the difference between coord_quickmap() and coord_map()?
?coord_quickmap   
#Preserves straight lines via set aspect ratio. Good for small areas close to equator. 
?coord_map
# does not preserve straightlines, requires a lot of computation.

# both of these are superceeded (out of date), instead coord_sf should be used.

# 3. What does the following plot tell you about the relationship between
      # city and highway mpg? Why is coord_fixed() important? What does
      # geom_abline() do?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

?geom_abline # shows a line from origin at 45
?coord_fixed # forces ratio between physical representation and data units on axis


