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

# Selecting Great Smoky Mountains for highlighting
gsm <- elevation_data %>% 
  filter(PARKNAME == "Great Smoky Mountains")


# Plot elevation by park ------

elevation_data %>%
  filter(UNIT_TYPE == "National Park") %>%
  mutate(PARKNAME = fct_reorder(PARKNAME, elevation)) %>%
  ggplot(aes(x = PARKNAME, y = elevation)) +
  geom_point(size = 2) +
  geom_point(data = gsm, color="blue", size=2)+
  geom_text(data = gsm, aes(label = elevation),
            hjust = -0.2, vjust = 1.0, color= "blue")+
  labs(y="Elevation (meters)", x= "U.S. National Park Name")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title=element_text(size=14,face="bold"),
        plot.title = element_text(size = 26, face = "bold"))+
  ggtitle("Elevation of U.S. National Parks")

  
 

