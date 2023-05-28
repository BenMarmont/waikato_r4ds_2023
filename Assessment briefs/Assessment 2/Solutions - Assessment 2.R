library(tidyverse)

nitrate_leaching <- read_csv("nitrate-leaching-from-livestock-time-series-19902017-raw-data.csv")
nitrate_leaching

#1 Import the data at call it nitrate_leaching AND 
#     rename the columns to Region, Livestock_type, Date, Leaching.
nitrate_leaching <- read_csv("nitrate-leaching-from-livestock-time-series-19902017-raw-data.csv")
nitrate_leaching

nitrate_leaching <- nitrate_leaching %>% 
  rename(Region = `Region`,
         Livestock_type = `Livestock type`,
         Date = `Date`,
         Leaching = `Nitrate-N leached kg/yr`)

#2) Evaluate the unique values for livestock type. Choose one type and one region and plot it over time.
nitrate_leaching %>% distinct(Livestock_type)
nitrate_leaching %>% distinct(Region)

nitrate_leaching %>% 
  filter(Region == "Waikato",
         Livestock_type == "Sheep") %>% 
  ggplot(mapping = aes(x = Date, y = Leaching)) +
  geom_point()

#3) Create 2 new columns, one for decade and one for century
nitrate_leaching <-  nitrate_leaching %>% 
  mutate(Decade = (Date %/% 10) * 10,
         Century = (Date %/% 100) * 100)

#4) Use a plot or table to determin total leaching for your chosen stock class in each decade
nitrate_leaching %>% 
  select(Decade, Leaching, Livestock_type) %>%
  filter(Livestock_type == "Sheep") %>% 
  ggplot(mapping = aes(x = Decade, y = Leaching)) +
  geom_col()

#5) Find the year with the highest and lowest leaching per stock class in your choosen region
nitrate_leaching %>% 
  filter(Region == "Waikato") %>% 
  group_by(Livestock_type) %>% 
  summarise(
    count = n(),
    min_leaching = min(Leaching),
    max_leaching = max(Leaching)
  )

# Alternatively multiple of these, or the following box plot
nitrate_leaching %>%
  filter(Livestock_type == "Dairy") %>% 
  arrange(desc(Leaching))

# Box plot alternative
nitrate_leaching %>% 
  group_by(Livestock_type) %>% 
  ggplot(mapping = aes(x = Livestock_type, y = Leaching)) +
  geom_boxplot()
  
  #6) State the hypothesis in your script using a comment (“#”). Now test
#your hypothesis in R. Leave another comment explaining what your did/tried to do and whether your
# exploration indicates your hypothesis is correct or not.
#Answer will depend on your hypothesis, see feedback in Moodle 
