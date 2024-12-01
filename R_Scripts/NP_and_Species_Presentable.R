library(tidyverse)
library(dplyr)


# Read in cleaned data
nps_species <- read_csv("smoky_mountains.csv")

# Exclude vascular plants
nps_species <- nps_species %>%
  filter(TaxaGroup != "Vascular-plant") %>%
  filter(TaxaGroup != "Non-vascular plant") %>%
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
Low <- expanded_data %>%
  filter(Elevation_Group == "Low") %>%
  group_by(CategoryName)

Mid <- expanded_data %>%
  filter(Elevation_Group == "Mid") %>%
  group_by(CategoryName) 

High <- expanded_data %>%
  filter(Elevation_Group == "High") %>%
  group_by(CategoryName)

# Combined Plot -------
expanded_data %>%
  ggplot(aes(x = CategoryName, fill = Nativeness)) +
  geom_bar() +
  facet_grid(~ factor(Elevation_Group, levels = c("Low", "Mid", "High"))) +
  ggtitle("Nativeness of Species in the Great Smoky Mountains", 
          subtitle = "By Elevation Range") +
  labs(y="Count", x= "Species Category")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=10),
        axis.text.y = element_text(size=16),
        axis.title=element_text(size=16,face="bold"),
        plot.title = element_text(size = 20, face = "bold"),
        plot.subtitle = element_text(size=15, face= "bold"),
        strip.text.x = element_text(size = 12, face = "bold"), 
        legend.title=element_text(size=14, face = "bold"), 
        legend.text=element_text(size=10))


