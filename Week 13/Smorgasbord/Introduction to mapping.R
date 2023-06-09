
# Americas application ----------------------------------------------------


library(tidyverse)

# World map
map_data("world") |> 
  ggplot(aes(long, lat, group = group)) +
  geom_polygon()

# New Zealand map
map_data("world", region = "New Zealand") |> 
  ggplot(aes(long, lat, group = group)) +
  geom_polygon() 

# Improving the previous plots
# install.packages("sf")
library(sf)

map_data("world") |> 
  ggplot(aes(long, lat, group = group)) +
    geom_polygon() + 
    coord_sf()

map_data("world", region = "New Zealand") |> 
  ggplot(aes(long, lat, group = group)) +
    geom_polygon() + 
    coord_sf()

# install.packages(c("cowplot", 
#                    "googleway",
#                    "ggrepel",
#                    "ggspatial",
#                    "libwgeom",
#                    #"sf",
#                    "rnaturalearth",
#                    "rnaturalearthdata"))

library(ggthemes)
library(rnaturalearth)
library(rnaturalearthdata)

?ne_countries

world <- ne_countries(scale = "medium", returnclass = "sf")
nz <- ne_countries(country = "New Zealand", scale = "medium", returnclass = "sf")

class(world)

ggplot(data = world) +
  geom_sf()

ggplot(data = nz) +
  geom_sf() 

ggplot(data = world) +
  geom_sf() +
  labs( x = "Longitude",
        y = "Latitude",
        title = "World Map")

ggplot(data = world) +
  geom_sf() +
  xlab("Longitude") +
  ylab("Latitude") +
  ggtitle("World Map")

# library(ggplot2)

ggplot(data = world) +
  geom_sf(colour = "black", fill = "lightgreen")

ggplot() +
  geom_sf(data = world, colour = "black", fill = "lightgreen") +
  geom_sf(data = nz, colour = "black", fill = "blue")

ggplot(data = world) +
  geom_sf(aes(fill = pop_est)) +
  scale_fill_viridis_c(trans = "sqrt", option = "plasma")

ggplot(data = world) +
  geom_sf() +
  coord_sf(crs = st_crs(3035))

base_gulf <-  ggplot(data = world) +
  geom_sf() +
  coord_sf(xlim = c(-102.15, -74.12),
           ylim = c(7.65,33.97))

library(ggspatial)

base_gulf +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", 
                         pad_x = unit(0.75, "in"), 
                         pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)

fixed_world <- st_make_valid(world)
world_points <- st_centroid(fixed_world)
  
world_points <- cbind(fixed_world, st_coordinates(st_centroid(fixed_world$geometry)))

ggplot(data = world) +
  geom_sf()+
  geom_text(data = world_points, 
            aes(x = X, y = Y, label = name),
            fontface = "italic") +
  annotate(geom = "text",
           x = -90,
           y = 25,
           label = "Gulf of Mexico",
           fontface = "bold",
           size = 6,
           colour = "hotpink") +
  coord_sf(xlim = c(-102.15, -74.12),
           ylim = c(7.65, 33.97))


# Kiwi application --------------------------------------------------------

# install.packages("here")

library(ggrepel)
library(here)

here()

# st_read("C:/Users/MarmontB/OneDrive - DairyNZ Limited/Documents/R/waikato_r4ds_2023/Week 13/Smorgasbord/nz-coastlines-and-islands-polygons-topo-150k")
# file_path <- "C:/Users/MarmontB/OneDrive - DairyNZ Limited/Documents/R/waikato_r4ds_2023/Week 13/Smorgasbord/nz-coastlines-and-islands-polygons-topo-150k"
# st_read(file_path)

nz_outline <- st_read(here("Week 13", "Smorgasbord", "nz-coastlines-and-islands-polygons-topo-150k"))
nz_regions <- st_read(here("Week 13", "Smorgasbord", "nz-land-districts"))

NZUs <- tibble(Universities = c("UoA", "AUT", "Waikato", "Massey", "Vic", "Canterbury", "Lincoln", "Otago"),
               lat = c(-36.85224823346041, 
                       -36.853412307817784, 
                       -37.78890569065363, 
                       -40.355225055311955, 
                       -41.29002684516775, 
                       -43.52237464482431, 
                       -43.645401275754104, 
                       -45.864063192916205),
               lng = c(174.77252663829262, 
                       174.76643757919567, 
                       175.3164528404978, 
                       175.60943830584307,
                       174.76783598210622, 
                       172.57943539626334, 
                       172.46426811709463, 
                       170.5146851684737))  |>  
  select(Universities, lng, lat)

ggplot(nz_outline) +
  geom_sf()

ggplot(nz_regions) +
  geom_sf()

trimmed <- st_intersection(nz_outline, nz_regions)

base_nz_plot <-  ggplot(trimmed) +
  geom_sf()

base_nz_plot +
  coord_sf(xlim = c(165, 180)) +
  labs(x = "Longitude",
       y = "Latitude", 
       caption = "Source: Land Information New Zealand",
       title = "Map of New Zealand") +
  theme_economist()

library(ggrepel)

base_nz_plot +
  coord_sf(xlim = c(165, 180)) +
  geom_label_repel(data = NZUs,
                   aes(x = lng, y = lat, label = Universities)
  ) +
  labs(x = "Longitude",
       y = "Latitude", 
       caption = "Source: Land Information New Zealand, and Google Earth",
       title = "Map of the Universities in New Zealand") +
  theme_economist()


base_nz_plot +
  coord_sf(xlim = c(165, 180)) +
  geom_label_repel(data = NZUs,
                   aes(x = lng, y = lat, label = Universities)
                   ) +
  labs(x = "Longitude",
       y = "Latitude", 
       caption = "Source: Land Information New Zealand, and Google Earth",
       title = "Map of the Universities in New Zealand") +
  theme_bw()



