
# Default ggplot maps -----------------------------------------------------
library(tidyverse)
# ggplot maps are static

# World map

map_data("world") |> 
  ggplot(aes(long, lat, group = group)) + 
  geom_polygon()

# New Zealand map

world_map <- map_data("world", region = "New Zealand")

ggplot(world_map, aes(long, lat, group = group)) +
  geom_polygon()


# fixing display using coord_sf from the sf package
ggplot(world_map, aes(long, lat, group = group)) +
  geom_polygon() +
  coord_sf()

map_data("world") |> 
  ggplot(aes(long, lat, group = group)) + 
  geom_polygon() +
  coord_sf()


 ## Leaflet----------------------------------------------------------------------
#install.packages("leaflet")
library(leaflet)
library(tidyverse)
# https://rstudio.github.io/leaflet/
# https://cran.r-project.org/web/packages/leaflet.minicharts/vignettes/introduction.html

# Leadflet creates interactive maps

## Leaflet workflow
#   1) Create a map widget by calling leaflet()
#   2) Add layers/features to map with layer functions
#   3) Repeat step 2 as desired
#   4) Print the map widget to display it

# Map of Auckland University (birthplace of R)
Auckland_University <- leaflet()  |> 
  addTiles()  |>   # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

Auckland_University

## Extension - adding several points to an interactive map

NZUs <- tibble(Universities = c("UoA", "AUT", "Waikato", "Massey", "Vic", "Canterbury", "Lincoln", "Otago"),
               lat = c(-36.85224823346041, -36.853412307817784, -37.78890569065363, -40.355225055311955, -41.29002684516775, -43.52237464482431, -43.645401275754104, -45.864063192916205),
               lng = c(174.77252663829262, 174.76643757919567, 175.3164528404978, 175.60943830584307,174.76783598210622, 172.57943539626334, 172.46426811709463, 170.5146851684737))  |>  
  select(Universities, lng, lat)

NZUs  |>  
  leaflet()  |>  
  addTiles() |>  
  addMarkers(lng = ~lng, lat = ~lat, label = ~Universities, popup = "Universities of New Zealand") 
## Can assign the map and call it if I don't always want it built

## sf --------------------------------------------------------------------------
#install.packages("sf")
library(tidyverse)
library(sf)
library(ggrepel)
library(ggthemes)
library(here) # make a note of this package


# sf workflow -------------------------------------------------------------
## hybrid of ggplot and leaflet
## call data
## add layers
## can also use interaction of spatial data layers to create unique features before loading data 



# Reading files -----------------------------------------------------------
# note that we are pointing the file folder, not a specific file because of the way spatial data is stored
# use the here::here() to get the complete path to your working directory 

#download from https://data.linz.govt.nz/ you need to create an account, can be hard to find the rights layers, can also take time
# to prepare the download for you.
#or, get from GitHub

?here()

file_path <- "C:/Users/MarmontB/OneDrive - DairyNZ Limited/Documents/R/waikato_r4ds_2023/Week 13/Smorgasbord/nz-coastlines-and-islands-polygons-topo-150k"
nz_outline <- st_read(file_path)

# we can use the here function to reduce the copy and pasting!
file_path <- here("Week 13", "Smorgasbord", "nz-coastlines-and-islands-polygons-topo-150k")
nz_outline <- st_read(file_path)

# file_path <- "C:/Users/MarmontB/OneDrive - DairyNZ Limited/Documents/R/waikato_r4ds_2023/Week 13/Smorgasbord/nz-land-districts"
file_path <- here("Week 13", "Smorgasbord", "nz-land-districts")
nz_regions <- st_read(file_path)


# Maps of input files ------------------------------------------------------

ggplot(data = nz_regions) +
  geom_sf()

ggplot(nz_outline) +
  geom_sf()


# Joining the layers to get regions, and cut the 'fluffly edges -----------

trimmed <- st_intersection(nz_outline, nz_regions)

ggplot(data = trimmed) +
  geom_sf()

# This can be improved:
##  Crop, labels, labels, look, title, axis labels, source


# Improved plot -----------------------------------------------------------
ggplot(data = trimmed) +
  geom_sf() +
  coord_sf(xlim = c(165, 180)) +
  theme_bw() +
  ggtitle("Map of the Universities of New Zealand") +
  labs(x = "Longitude", 
       y = "Latitude", 
       caption = "Source: Land Information New Zealand")


# Add the Universities ----------------------------------------------------
## we move the data for the map to the geom_sf and the data for the labels to the geom_label

ggplot() +
  geom_sf(data = trimmed) +
  coord_sf(xlim = c(165, 180)) +
  geom_label_repel(data = NZUs, aes(x = lng, y = lat, label = Universities)) +
  theme_economist() +
  ggtitle("Map of the Universities of New Zealand") +
  labs(x = "Longitude", 
       y = "Latitude", 
       caption = "Source: University coordinates from google maps") 

                      