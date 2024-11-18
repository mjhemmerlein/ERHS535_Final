library(readr)
library(tidyverse)

most_visited_nps_species_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-10-08/most_visited_nps_species_data.csv')

Seasonality <- most_visited_nps_species_data %>%
  filter(CategoryName != "Insect")


