library(tidyverse)

# Exercise Allocations ----------------------------------------------------
## 12.3.3

# 1 - Homework (hw)
# 2 - Breakout (bo)
# 3 - Class
# 4 - Class

# 12.4.1
# 1 - bo
# 2 - hw

# 12.5.1.1 
# 1 - bo
# 2 - bo
# 3 - class
# 4 - hw

# 12.5.2.1
# 1 - bo
# 2 - hw
# 3 - class
# 4 - bo

# 12.5.3.1
# 1 - class
# 2 - hw
# 3 - bo
# 4 - hw
# 5 - bo
# 6 - bo


# 12.3.3 Exercises --------------------------------------------------------

# 1. Explore the distribution of each of the x, y, and z variables in
#     diamonds. What do you learn? Think about a diamond and how you
#     might decide which dimension is the length, width, and depth.

diamonds |> 
  ggplot(aes(x)) +
  geom_histogram() +
  coord_cartesian(xlim = c(0, 20))

diamonds |> 
  ggplot(aes(y)) +
  geom_bar()+
  coord_cartesian(xlim = c(0, 20))

diamonds |> 
  ggplot(aes(z)) +
  geom_bar()+
  coord_cartesian(xlim = c(0, 20))

# x and y have values in a wider range and look more related. Diamonds tend to look symmetrical from above, therefore
# expect x and y to represent length and width and z to represent depth. This inline with documentation.
?diamonds

# 2. Explore the distribution of price. Do you discover anything unusual or
#     surprising? (Hint: Carefully think about the binwidth and make sure
#              you try a wide range of values.)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 250)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 100) + 
  xlim(7500, 12500)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 500)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 750)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 1000)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 5000)


diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 100) + 
  xlim(10000, 15000)

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 100) + 
  xlim(1000, 5000)

# more expensive diamonds are less prevalent in this data set relative to cheaper diamonds and
# the count increases at a price around 7500.

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do
#     you think is the cause of the difference?

diamonds |> 
  filter(carat < 1.1 & carat > 0.9) |>
  ggplot(aes(carat)) +
  geom_histogram()

diamonds |> 
  filter(carat == 0.99) |> 
  count()

# rounding, people are attracted to bigger diamonds

#   4. Compare and contrast coord_cartesian() vs. xlim() or ylim()
#     when zooming in on a histogram. What happens if you leave binwidth
#     unset? What happens if you try and zoom so only half a bar shows?

?coord_cartesian
# zooms the plot without changing underlying data

?xlim
# values outside the range are replaced with NA

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 5000) +
  ylim(c(0, 10000))

diamonds |> 
  ggplot(aes(price)) +
  geom_histogram(binwidth = 5000) +
  coord_cartesian(ylim = c(0, 10000))

# changing the ylim also shuffles data along the x axis so that the data within those bounds are included
# at the expense of removing the other data from the display. This means that the x axis is takes a different
# scale. This does not happen in coord-cartesion as the graph zooms rather than subsets the data.

# 12.4.1 Exercises --------------------------------------------------------

# 1. What happens to missing values in a histogram? What happens to
#     missing values in a bar chart? Why is there a difference in how missing
#     values are handled in histograms and bar charts?

# In a bar chart, missing values are typically represented by an empty or "missing" category, 
# depending on the specific package and code used. By default, ggplot2 will create a 
# separate bar for missing values in a bar chart.

# The difference in how missing values are handled in histograms and bar charts 
# has to do with the type of data being visualized. In a histogram, the data is 
# continuous and ordered, so missing values can be excluded without affecting the
# overall distribution. However, in a bar chart, the data is categorical and 
# unordered, so missing values need to be explicitly represented as a separate 
# category to avoid distorting the results.


# 2. What does na.rm = TRUE do in mean() and sum()?
?mean
# na.rm	a logical evaluating to TRUE or FALSE indicating whether NA values 
# should be stripped before the computation proceeds.

# remove NA before calculating mean

?sum
# na.rm logical. Should missing values (including NaN) be removed?

# exlude missing values and NaN from sums  
  
# 12.5.1.1 Exercises ------------------------------------------------------

# 1. Use what you’ve learned to improve the visualization of the departure
#     times of cancelled vs. non-cancelled flights.

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min/60)) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_histogram(aes(colour = cancelled, fill = cancelled), binwidth = 1)

# cancelled flights have a missing value in departure time

# 2. What variable in the diamonds dataset is most important for predicting
#     the price of a diamond? How is that variable correlated with cut? Why
#     does the combination of those two relationships lead to lower quality
#     diamonds being more expensive?

?diamonds

diamonds |> 
  ggplot(aes(carat, price)) + 
  geom_point()
# expensive diamonds are big


diamonds |> 
  ggplot(aes(x = carat, fill = clarity)) + 
  geom_bar(position = "stack")
#best clarity diamonds are small

diamonds |> 
  ggplot(aes(x, price)) + 
  geom_point()

diamonds |> 
  ggplot(aes(y, price)) + 
  geom_point()

diamonds |> 
  ggplot(aes(z, price)) + 
  geom_point()

diamonds |> 
  ggplot(aes(table, price)) + 
  geom_point()

diamonds |> 
  ggplot(aes(price, fill = cut)) + 
  geom_bar(position = "stack")

diamonds |> 
  ggplot(aes(x = carat, fill = cut)) + 
  geom_bar(position = "stack")

# appears that carat (i.e. weight, proxy for size) is the biggest determinant of price
# diamonds with the best clarity (proxy for quality) tend to be small.

# better cut diamonds tend to be smaller

# lower quality diamonds can be more expensive because they are larger 

# 3. Instead of exchanging the x and y variables, add coord_flip() as a
#     new layer to the vertical boxplot to create a horizontal one. How does
#     this compare to using exchanging the variables?

mpg |> 
  ggplot(aes(x = class, y = hwy)) +
  geom_boxplot()

mpg |> 
  ggplot(aes(y = class, x = hwy)) +
  geom_boxplot()

mpg |> 
  ggplot(aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

# 4. One problem with boxplots is that they were developed in an era of
#     much smaller datasets and tend to display a prohibitively large number
#     of “outlying values”. One approach to remedy this problem is the letter
#     value plot. Install the lvplot package, and try using geom_lv() to
#     display the distribution of price vs. cut. What do you learn? How do you
#     interpret the plots?

# install.packages("lvplot")
library(lvplot)

diamonds |> 
  ggplot(aes(x = carat, y = price)) +
  geom_lv()

?geom_lv

# prices are concentrated sub $5000 and are increasingly spreadout are price increases

# 5. Compare and contrast geom_violin() with a faceted
#     geom_histogram(), or a colored geom_freqpoly(). What are the
#     pros and cons of each method?
diamonds |> 
  ggplot(aes(x = cut, y = price)) +
  geom_violin()
# good visualisation of distribution but lose details

diamonds |> 
  ggplot(aes(x = price)) +
  geom_histogram() +
  facet_wrap(~cut)
# detailed but harder to compare

diamonds |> 
  ggplot(aes(x = price)) +
  geom_freqpoly(aes(colour = cut), linewidth = 1)
# Poor at a glance, but more information if you look deeper.

# 6. If you have a small dataset, it’s sometimes useful to use geom_jitter()
#     to see the relationship between a continuous and categorical variable.
#     The ggbeeswarm package provides a number of methods similar to
#     geom_jitter(). List them and briefly describe what each one does.

# install.packages("ggbeeswarm")
# install.packages("patchwork)
library(ggbeeswarm)
library(patchwork)
?ggbeeswarm::geom_beeswarm()        #offsets points to reduce overplotting
?ggbeeswarm::geom_quasirandom()     # offset points to reduce overplotting
?ggbeeswarm::position_beeswarm()    # arrange points
?ggbeeswarm::position_quasirandom() # arrange points using quasirandom noise to avoid overplotting


# examples
a <- ggplot(diamonds, aes(x = x, y = price)) +
  ggbeeswarm::geom_beeswarm()
b <- ggplot(diamonds, aes(x = x, y = price)) +
  ggbeeswarm::geom_quasirandom()

# combining plots with patchwrok to compare
a + b

# 12.5.2.1 Exercises ------------------------------------------------------

# 1. How could you rescale the count dataset above to more clearly show
#     the distribution of cut within color, or color within cut?
    diamonds |>
    count(color, cut) |>
    ggplot(aes(x = color, y = cut)) +
    geom_tile(aes(fill = n))

diamonds %>% 
  group_by(color, cut) %>% 
  summarize(count = n()) %>% 
  ungroup() %>% 
  mutate(prop = count / sum(count)) %>% 
  ggplot(aes(x = color, y = cut, fill = prop)) +
  geom_tile()

# 2. How does the segmented bar chart change if color is mapped to the x
#     aesthetic and cut is mapped to the fill aesthetic? Calculate the counts
#     that fall into each of the segments.

diamonds %>%
  ggplot(aes(x = cut, fill = color)) +
  geom_bar(position = "stack")

diamonds |> 
  group_by(color, cut) |> 
  summarise(count = n())

# 3. Use geom_tile() together with dplyr to explore how average flight
#     delays vary by destination and month of year. What makes the plot
#     difficult to read? How could you improve it?

nycflights13::flights |> 
group_by(dest, month) |> 
  summarise(av_flight_delay = mean(arr_delay)) |> 
  ggplot(aes(x = dest, y = month, fill = av_flight_delay)) +
  geom_tile() +
  coord_flip()

# Plot hard to read because of the number of destinations. 
# This could be addressed by subsetting data i.e. facetting by state if state exists
# Or filtering for airports of interest.

# 4. Why is it slightly better to use aes(x = color, y = cut) rather than
#     aes(x = cut, y = color) in the example above?

diamonds |>
  count(color, cut) |>
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

diamonds |>
  count(color, cut) |>
  ggplot(aes(x = cut, y = color)) +
  geom_tile(aes(fill = n))

# x = cut increases the width of the tiles, making less aesthetic (opinion)

# 12.5.3.1 Exercises ------------------------------------------------------

smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

# 1. Instead of summarizing the conditional distribution with a boxplot, you
#     could use a frequency polygon. What do you need to consider when
#     using cut_width() vs. cut_number()? How does that impact a
#     visualization of the 2d distribution of carat and price?

?cut_width
?cut_number

smaller |> 
  ggplot(aes(carat)) +
  geom_freqpoly(aes(group = cut_width(price, 10000)))
# cut width sets the width of the bins the continuous data is being transformed into

smaller |> 
  ggplot(aes(carat)) +
  geom_freqpoly(aes(group = cut_number(price, 2)))
# cut number sets the number of bins the continuous data is being transformed into

# these changes allow you to view the result of changing the subset to see trends
# in different data combinations

smaller |> 
  ggplot(aes(carat, price)) +
  geom_bin2d()


# 2. Visualize the distribution of carat, partitioned by price.
smaller |> 
  ggplot(aes(x = carat, fill = cut_width(price, 10000))) +
  geom_histogram(position = "stack")

# 3. How does the price distribution of very large diamonds compare to
#     small diamonds? Is it as you expect, or does it surprise you?

diamonds |> 
  arrange(desc(carat)) |> 
  slice_head(n = 1000) |> 
  ggplot(aes(x = price)) +
  geom_histogram()

diamonds |> 
  arrange(carat) |> 
  slice_head(n = 1000) |> 
  ggplot(aes(x = price)) +
    geom_histogram()

# the biggest diamonds consistently get expensive to the biggest bins where as
# the smaller diamonds are not continuous in their price increases.

# 4. Combine two of the techniques you’ve learned to visualize the
#     combined distribution of cut, carat, and price.

smaller |> 
  ggplot(aes(x = carat, y = price, colour = cut)) +
  geom_tile()

# 5. Two dimensional plots reveal outliers that are not visible in one
#     dimensional plots. For example, some points in the following plot have
#     an unusual combination of x and y values, which makes the points
#     outliers even though their x and y values appear normal when examined
#     separately. Why is a scatterplot a better display than a binned plot for
#     this case?

diamonds |>
  filter(x >= 4) |>
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

# scatter plots show relationships betweeen variables not observable in 1D plots.
# this example shows this well as there is a clear trend. binning would lose some
# of this relationship.

# 6. Instead of creating boxes of equal width with cut_width(), we could
#     create boxes that contain roughly equal number of points with
#     cut_number(). What are the advantages and disadvantages of this
#     approach?

ggplot(smaller, aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_number(carat, 20)))

# using cut_number in combination with boxplot show the spread of the observations 
# that is, the wider the plot the wider the values of carat represented are. 
# this means that there is more variation in carat in the wider boxes (i.e. the bigger carats)
# than the smaller ones. 
# this may be less useful for line graphs or if you are looking at trends at specific points
# through a series.
