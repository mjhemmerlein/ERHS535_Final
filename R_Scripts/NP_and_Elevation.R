library(sf)
library(tigris)
library(ggplot2)
library(dplyr)
library(elevatr)
library(stringr)
library(forcats)

# Park Centroids ------
list.files("Raw_Data/NPS_Centroid/")

np_centroid <- read_sf("Raw_Data/NPS_Centroid/")

ggplot() +
  geom_sf(data = np_centroid) +
  theme_minimal()

# Clean POINT column to separate longitude and latitude
np_centroid <- np_centroid %>%
  mutate(
    lon = st_coordinates(geometry)[, 1],  # Extract longitude (1st column)
    lat = st_coordinates(geometry)[, 2] )   # Extract latitude (2nd column)


elevation_data <- get_elev_point(np_centroid, prj = st_crs(np_centroid), src = "aws") %>%
  arrange(elevation)

# Plot elevation by park ------

elevation_data %>%
  arrange(elevation) %>%
  ggplot(aes(x = PARKNAME, y = elevation)) +
  geom_point()

elevation_data %>%
  filter(UNIT_TYPE == "National Park") %>%
  mutate(PARKNAME = fct_reorder(PARKNAME, elevation)) %>%
  ggplot(aes(x = PARKNAME, y = elevation)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
