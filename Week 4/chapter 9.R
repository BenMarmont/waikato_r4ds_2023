library(tidyverse)

ggplot(diamonds, aes(carat, price)) + 
  geom_hex()

ggsave("diamonnds.pdf")

write_csv(diamonds, "diamonds.csv")
