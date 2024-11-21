library(sf)
library(tigris)
library(ggplot2)
library(terra)
library(dplyr)

# Park Boundaries ------
list.files("Raw_Data/NPS_Land_Resources_Division_Boundary_and_Tract_Data_Service_-5686076531246143185/")

NP_Boundary <- read_sf("Raw_Data/NPS_Land_Resources_Division_Boundary_and_Tract_Data_Service_-5686076531246143185/")

ggplot() +
  geom_sf(data = NP_Boundary %>% filter(UNIT_NAME == "Glacier National Park"), 
          color = "blue") +  # Park boundary
  theme_minimal()


# Park Elevation -------
list.files("Raw_Data/gtopo30/")

elevation <- read_sf("Raw_Data/gtopo30/")





# Plot data together
ggplot() +
  geom_sf(data = elevation) +
  geom_sf(data = glacier)

# Check coordinate reference systems (CRS) between datasets
st_crs(NP_Boundary) # Uses EPSG:3857 formatting

st_crs(elevation) # Uses EPSG:4326 formatting

# Transform the NP_Boundary dataset to EPSG:4326

NP_Boundary <- st_transform(NP_Boundary, crs = 4326)

st_crs(NP_Boundary) # Ensure it now matches EPSG:4326


ggplot() +
  geom_sf(data = NP_Boundary %>% filter(UNIT_NAME == "Glacier National Park"), 
          color = "blue") +  # Park boundary
  geom_sf(data = elevation, fill = "gray", alpha = 0.5) +  # Elevation layer
  theme_minimal()

# Check bounding box for both datasets
st_bbox(NP_Boundary)
st_bbox(elevation)

