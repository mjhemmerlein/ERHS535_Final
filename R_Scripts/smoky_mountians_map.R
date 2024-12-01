#install.packages("shiny")
library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
#install.packages("sf")
library(sf)
library(readr)

# Load the necessary data
shapefile_path <- "../raw_data/Great_Smoky_Mountains_National_Park_Boundary"
boundary <- st_read(shapefile_path)

# transform the boundary into the correct file type for leaflet
boundary_wgs84 <- st_transform(boundary, crs = 4326) 


# Create a leaflet map with the Smokey Mountains boundary
leaflet(boundary_wgs84) %>%
  addTiles() %>%  # Add OpenStreetMap tiles
  addPolygons(
    fillColor = "lightblue",  # Fill color for the park boundary
    weight = 2,               # Line weight for the boundary
    color = "black",          # Border color of the boundary
    opacity = 1,              # Opacity of the boundary
    fillOpacity = 0.5         # Opacity of the fill
  )
# Render the map
map