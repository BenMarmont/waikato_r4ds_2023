library(tidyverse)
library(ggthemes)
library(patchwork)


# Labels ------------------------------------------------------------------

?labs
?mpg

mpg |> 
  ggplot(mapping = aes(x = displ, y = hwy)) +  #same as ggplot(aes(displ, hwy))
    geom_point(aes(colour = class)) +
    geom_smooth(se = FALSE) +
    labs(title = "Fuel efficiency decreases with displacement",
         subtitle = "With the exception of 2 seaters",
         caption = "Data: MPG, a subset of the EPA Fuel Economy Dataset",
         x = "Displacement (L)", 
         y = "Highway Fuel Consumption (MPG)", 
         colour = "Body Type", 
         tag = "Todays first plot")

#quote()

df <- tibble(
  x = 1:10,
  y = x ^ 2
)

df |> 
  ggplot(aes(x, y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
    )

# STOP: Create a plot using MPG data using as many labels as possible. 5 minutes.

# Annotation --------------------------------------------------------------

?geom_text
?case_when

label_info <- mpg |> 
  group_by(drv) |> 
  arrange(desc(displ)) |> 
  slice_head(n = 1) |> 
  mutate(drive_type = case_when(
    drv == "f" ~ "front-wheel drive",
    drv == "r" ~ "rear-wheel drive",
    drv == "4" ~ "4-wheel drive"
    )) |> 
  select(manufacturer, model, displ, drv, drive_type, hwy)

mpg |> 
  ggplot(aes(displ, hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = F) + # F same as FALSE
  geom_text(data = label_info, 
            aes(x = displ, 
                y = hwy, 
                label = drive_type), 
    fontface = "bold", 
    size = 5, 
    hjust = "right", 
    vjust = "bottom", 
    colour = "black") +
  theme(legend.position = "none")
  
mpg |> 
  ggplot(aes(displ, hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = F) + # F same as FALSE
  geom_label(data = label_info, 
            aes(x = displ, 
                y = hwy, 
                label = drive_type), 
            fontface = "bold", 
            size = 5, 
            hjust = "right", 
            vjust = "bottom", 
            colour = "black",
            alpha = .5) +
  theme(legend.position = "none")
  
mpg |> 
  ggplot(aes(displ, hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = F) + # F same as FALSE
  ggrepel::geom_label_repel(data = label_info, 
            aes(x = displ, 
                y = hwy, 
                label = drive_type), 
            fontface = "bold", 
            size = 5, 
            # hjust = "right", 
            # vjust = "bottom", 
            colour = "black",
            alpha = .5,
            nudge_x = 3,
            nudge_y = .5) +
  theme(legend.position = "none")  

potential_outliers <- mpg |> 
  filter(hwy > 40 | (hwy > 20 & displ > 5))

potential_outliers

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  ggrepel::geom_text_repel(data = potential_outliers, 
                           aes(label = model),
                           nudge_x = .25,
                           nudge_y = .25) +
  geom_point(data = potential_outliers, colour = "white", size  = 3) +
  geom_point(data = potential_outliers, colour = "red", size = 1.5)

label_info <- mpg |> 
  summarize(
    displ = max(displ),
    hwy = max(hwy), 
    label_1 = "increasing engine size relates to \ndecreasing mpg")

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  geom_text(
    data = label_info, aes(label = label_1), 
    hjust = "right")

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  annotate(
    geom = "text",
    x = Inf,
    y = Inf,
    label = "increasing engine size relates to \ndecreasing mpg",
    vjust = "top",
    hjust = "right")

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  annotate(
    geom = "text",
    x = Inf,
    y = Inf,
    label = "increasing engine size relates to \ndecreasing mpg",
    vjust = "top",
    hjust = "right") +
  annotate(
    geom = "segment", 
    x = 5,
    y = 35, 
    xend = 5, 
    yend = 17.5, 
    colour = "red",
    arrow = arrow(type = "closed")
  ) +
  annotate(
    geom = "text", 
    x = 5,
    y = 37.55, 
    label = "Interesting point" 
    )

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point() +
  geom_vline(xintercept = 5, colour = "red") +
  geom_hline(yintercept = 30, colour = "blue")

?geom_vline
?geom_hline
?geom_rect

# Scales ------------------------------------------------------------------
?mpg

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous() +
  scale_y_continuous()

?scale_x_continuous

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous() +
  scale_y_continuous(breaks = seq(0, 45, by = 5))

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)
  
mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = scales::label_dollar())

mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = scales::label_percent())

presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")

main_graph <- mpg |> 
  ggplot(aes(displ, hwy)) +
  geom_point(aes(colour = class))

main_graph + theme(legend.position = "top")
main_graph + theme(legend.position = "bottom")
main_graph + theme(legend.position = "left")
main_graph + theme(legend.position = "right")
main_graph + theme(legend.position = "none")

main_graph + 
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, 
                               override.aes = list(size = 5, alpha = .5), 
                               ))
## Log scale options

### 1
diamonds |> 
  ggplot(aes(log10(carat), log10(price))) +
  geom_bin_2d()

## 2
diamonds |> 
  ggplot(aes(carat, price)) +
  geom_bin_2d() +
  scale_x_log10() +
  scale_y_log10()

# Colour
?scale_colour_brewer

mpg |> 
  ggplot(aes(displ, hwy, colour = drv, shape = drv)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1")

presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))

?scale_fill_viridis_b()
?scale_colour_viridis_b()

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c(option = "inferno") +
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, binned", x = NULL, y = NULL)

# Zooming -----------------------------------------------------------------
# filter the data (subsetting)
# xlim and ylim (same subsetting)
# coord catersian 


# Themes ------------------------------------------------------------------


# Patchwork ---------------------------------------------------------------
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy)) +
  geom_boxplot() +
  labs(title = "Plot 2")

p3 <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point() +
  labs(title = "Plot 3")

p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &
  theme(legend.position = "top")

(p1 | p3) / p2


