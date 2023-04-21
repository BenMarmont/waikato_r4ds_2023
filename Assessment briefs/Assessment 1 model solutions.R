# Assignment 1 Solutions

# Note that question three can take many forms which may be significantly 
# different to your submission.

# Set-up ------------------------------------------------------------------

library(tidyverse)
library(ggthemes)

# 1) Recreate plot --------------------------------------------------------

diamonds %>% 
  ggplot(mapping = aes(x = cut, y = price)) +
  geom_boxplot(aes(colour = cut)) +
  theme_excel_new()

# 2) Recreate plot --------------------------------------------------------

economics_long %>% 
  ggplot(mapping = aes(x = date, y = value))+
  geom_line() +
  facet_wrap(~variable, nrow = 2)


# 3) Create own plot ------------------------------------------------------

# The key to getting the best grade here was the comment before and after
# the plot documenting what you were thinking about testing and then reflecting 
# on this.

# Question:
# Read the documentation for the diamonds data set (use ‘?ggplot2::diamonds’). 
# Amongst the variables in the data set think about which relationships are the 
# most interesting. Make a graph to test these relationships, ideally publication 
# quality. Each missing element from your graph reduces your mark. 

# Put a comment in the script to communicate what you are trying to show before the
# graph. After the graph talk through what the graph means in relation to your 
# first thoughts.

?diamonds
# Diamons have several properties, but I am most interested in the relationship
# between the interaction between the colour of the diamond and the clarit of 
# the diamond. 

# Therefore, I will graph the distribution of the cut of diamonds relative to 
# the clarity. I expect that the superior colours will be correlated with 
# superior clarity and there will be relatively few diamonds with both poor 
# clarity and colour characteristics. Both clarity and colour and ranked variables.

diamonds |> 
  ggplot(aes(x = clarity, fill = color)) +
  geom_bar(position = "dodge") +
  scale_fill_viridis_d () +
  labs (x = "Diamond Clarity", 
        y = "Frequency", 
        title = "Frequency of the clarity of diamonds grouped by color", 
        fill = "Diamond Colour",
        subtitle = "Clarity is ordered worst to best along x axis") +
  theme_clean() 

# The graph shows that there is a concentration around the middle diamond 
# claritities. Within these clarities the middle colours are more prevalent
# relative to the the better and worse colours. Additionally, there tends to me
# a greater number of observations for better colours (D) than the worse colours 
# (J) for every clarity except the absolute best and worst. 

# My hypothesis around the correlation between clarit and colour are incorrect 
# as each clarity has a similar distribution of colours. However my second 
# hypothesis, that there will be relatively few diamonds with poor clarity and
# colour was correct,=.