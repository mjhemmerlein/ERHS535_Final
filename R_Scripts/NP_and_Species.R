library(tidyverse)
library(dplyr)


# Read in cleaned data
nps_species <- read_csv("smoky_mountains.csv")

# Exclude plants
nps_species <- nps_species %>%
  filter(TaxaGroup != "Vascular-plant") %>%
  filter(!grepl("Wide", ElevationRange))

# Categories
nps_species %>%
  count(ElevationRange)

# Expand data for overlapping ranges
expanded_data <- nps_species %>%
  mutate(Elevation_Group = case_when(
    ElevationRange == "Low" ~ "Low",
    ElevationRange == "Mid" ~ "Mid",
    ElevationRange == "High" ~ "High",
    ElevationRange == "Low and High" ~ "Low", # First group for Low and High
    ElevationRange == "Low to High" ~ "Low",  # First group for Low to High
    ElevationRange == "Low to Mid" ~ "Low",   # First group for Low to Mid
    ElevationRange == "Mid to High" ~ "Mid"   # First group for Mid to High
  )) %>%
  bind_rows(
    nps_species %>%
      filter(ElevationRange == "Low and High") %>%
      mutate(Elevation_Group = "High")
  ) %>%
  bind_rows(
    nps_species %>%
      filter(ElevationRange == "Low to High") %>%
      mutate(Elevation_Group = "Mid")
  ) %>%
  bind_rows(
    nps_species %>%
      filter(ElevationRange == "Low to High") %>%
      mutate(Elevation_Group = "High")
  ) %>%
  bind_rows(
    nps_species %>%
      filter(ElevationRange == "Low to Mid") %>%
      mutate(Elevation_Group = "Mid")
  ) %>%
  bind_rows(
    nps_species %>%
      filter(ElevationRange == "Mid to High") %>%
      mutate(Elevation_Group = "High")
  )

# Summarize counts for each group
result <- expanded_data %>%
  group_by(Elevation_Group) %>%
  count(ElevationRange)

# View result
print(result)

# Elevation groups for plotting
