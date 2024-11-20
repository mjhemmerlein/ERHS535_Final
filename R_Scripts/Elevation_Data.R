library(sf)
library(tigris)
library(ggplot2)
library(terra)
library(dplyr)

# Park Boundaries
list.files("Raw_Data/NPS_Land_Resources_Division_Boundary_and_Tract_Data_Service_-5686076531246143185/")

NP_Boundary <- read_sf("Raw_Data/NPS_Land_Resources_Division_Boundary_and_Tract_Data_Service_-5686076531246143185/")

glacier <- NP_Boundary %>%
  filter(UNIT_NAME == "Glacier National Park")

ggplot() +
  geom_sf(data = glacier)

# Park Elevation
list.files("Raw_Data/gmted2010/")

elevation <- read_sf("Raw_Data/gmted2010/gmted2010.shp")


ggplot() +
  geom_sf(data = elevation)



