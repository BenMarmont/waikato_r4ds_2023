# Chapter 11 - Visualisation

library(tidyverse)

mpg
?mpg

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy, shape = drv)) +
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy, shape = drv, colour = drv)) +
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy, shape = class, colour = drv)) + 
  geom_point()

mpg |> 
  count(class)

mpg |> 
  ggplot(aes(x = displ, y = hwy, size = class, colour = drv)) + 
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy, alpha = class, colour = drv)) + 
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(colour = "deeppink")

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(colour = "deeppink", size = 3)

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(shape = 12)

# STOP: Create a scatterplot of hwy vs. displ where the points are pink filled in triangles.
mpg %>% ggplot (aes(x = displ, y = hwy)) +
  geom_point(colour = "deeppink", shape = 24, fill = "pink")
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(shape = 24, colour = "pink", fill = "pink")
mpg |> 
  ggplot(aes(x = displ, y = hwy)) + 
  geom_point(colour = "pink", shape = 17)
mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(shape =  17, colour = "pink", fill = "pink")
mpg |> ggplot(aes(x=displ, y=hwy)) + geom_point(shape=24, fill="deeppink")


# 11.3 - Geometric Objects ------------------------------------------------

# Left
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

mpg |> 
  ggplot(aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth() +
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv)) +
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_smooth(aes(colour = drv)) +
  geom_point()

mpg |> 
  ggplot(aes(x = displ, y = hwy)) +
  geom_smooth(aes(colour = drv), show.legend = FALSE) +
  geom_point()

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  geom_point(data = mpg |> 
               filter(class == "2seater"),
             shape = "circle open", size = 3, colour = "red")
  

# 11.4 Facets -------------------------------------------------------------
 
# Create sections headers with ctrl + shft + r (on windows), or
#   manually with a # <text> and then 4 or more dashes.
 
?facet_wrap # for facetting by 1 variable

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~ cyl)

?facet_grid # for facetting by 2 variables

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free")
#  facet_grid formula: rows ~ columns

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free_y")

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free_x")

# 11.5 Statistical Transformation -----------------------------------------
diamonds
?diamonds

diamonds |> 
  ggplot(aes(x = cut)) +
  geom_bar()

# stat = statistical transformation
?geom_bar
?stat_count

diamonds |> 
  ggplot(aes(x = cut)) +
  geom_bar()

diamonds |> 
  ggplot(aes(x = cut)) +
  geom_bar(stat = "count")

diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")

diamonds |> 
  ggplot() +
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# STOP: What is the differece between geom_col and geom_bar?
?geom_col
?geom_bar
# geom_bar() uses stat_count() by default: it counts the number of cases at 
#   each x position. geom_col() uses stat_identity(): it leaves the data as is.


# 11.6 Position Adjustments -----------------------------------------------

diamonds |> 
  ggplot(aes(x =cut, colour = cut)) +
  geom_bar()

diamonds |> 
  ggplot(aes(x =cut, colour = cut, fill = cut)) +
  geom_bar()

diamonds |> 
  ggplot(aes(x = cut, fill = cut)) +
  geom_bar(colour = "black")

diamonds |> 
  ggplot(aes(x = cut, fill = clarity)) +
  geom_bar(colour = "black")

diamonds |> 
  ggplot(aes(x = cut, fill = clarity)) +
  geom_bar()

diamonds |> 
  ggplot(aes(x = cut, fill = clarity, colour = clarity)) +
  geom_bar(position = "identity", fill = NA) +
  theme_bw()

diamonds |> 
  ggplot(aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")

diamonds |> 
  ggplot(aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point()

diamonds |> 
  ggplot(aes(x = x, y = price)) +
  geom_point(position = "jitter")

diamonds |> 
  ggplot(aes(x = x, y = price)) +
  geom_jitter()

# STOP: What controls the random noise in geom_jitter?
?geom_jitter
# the width and height arguments


# 11.7 Coordinate Systems -------------------------------------------------

nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()


