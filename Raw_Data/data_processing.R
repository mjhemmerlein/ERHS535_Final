# load libraries
library(tidyverse)
library(dplyr)
library(tidyr)

# read in data
most_visited_nps_species_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-10-08/most_visited_nps_species_data.csv')


## data cleaning
#filter down to smoky mountains
smoky_mountains <- most_visited_nps_species_data %>%
  filter(ParkName == "Great Smoky Mountains National Park") 

#filter out animals where occurrence is not in park
smoky_mountains <- smoky_mountains %>% 
  filter(Occurrence != "Not In Park") 

#remove these columns Synonyms, ParkAccepted(what does this do?), RecordStatus, Sensitive, NPSTags, NaitivnesTags, OccurrenceTags, References, Observations, Vouchers, ExternalLinks, TEStatus, StateStatus, OzoneSensitiveStatus, GRank, SRank, TaxonRecordStatus
#I removed "Naitivnes Tags" but Nativness is still in the dataset, nativness tags includes extra information. Can include if we want. 
smoky_mountains <- smoky_mountains %>%
  select(-Synonyms, -ParkAccepted, -RecordStatus, -Sensitive, -NPSTags, -NativenessTags, -OccurrenceTags, 
         -References, -Observations, -Vouchers, -ExternalLinks, -TEStatus, -StateStatus, -OzoneSensitiveStatus, 
         -GRank, -SRank, -TaxonRecordStatus)

# Split ParkTags column into multiple columns
# seperate column for Elevation Range
smoky_mountains <- smoky_mountains %>%
  mutate(
    ElevationRange = ifelse(grepl("Elevation Range", ParkTags), 
                            sub(".*Elevation Range: ([^;]+).*", "\\1", ParkTags), 
                            NA))
# separate column for park rank this includes information of how common/uncommon in the park
smoky_mountains <- smoky_mountains %>% 
  mutate(
    ParkRank = ifelse(grepl("Park Rank", ParkTags), 
                      sub(".*Park Rank: ([^;]+);.*", "\\1", ParkTags), 
                      NA))
# separate column for species record status
smoky_mountains <- smoky_mountains %>% 
  mutate(
    SpeciesRecordStatus = ifelse(grepl("Species Record Status", ParkTags), 
                                   sub(".*Species Record Status: ([^;]+);.*", "\\1", ParkTags), 
                                   NA))
# make separate column for the habit tag this include data such as nocturnal, 
# There are a lot of missing values
smoky_mountains <- smoky_mountains %>% 
  mutate(
    Habit = ifelse(grepl("Habit", ParkTags), 
                   sub(".*Habit: ([^;]+);.*", "\\1", ParkTags), 
                   NA))
# make separate column for taxa group include the taxa information
smoky_mountains <- smoky_mountains %>% 
  mutate(
    TaxaGroup = ifelse(grepl("Taxa Group", ParkTags), 
                       sub(".*Taxa Group: ([^;]+)(;|$).*", "\\1", ParkTags), 
                       NA))
# remove the habit, species record status columns, and park rank
smoky_mountains <- smoky_mountains %>%
  select(-ParkRank, -SpeciesRecordStatus, -Habit)
# I made separate columns for this data in case we wanted to include them in down
#stream analysis. 
# I removed park rank even though it has interesting data because it had na's that 
#would remove elevation data if it was kept.

# remove na's from the elevation data
smoky_mountains <- smoky_mountains %>% 
  drop_na()
#after removal of na's in elevation data went from ~6000 obs to 2000 obs

# write cleaned data into a csv
write.table(smoky_mountains, file = "smoky_mountains.csv", sep = ",", row.names = FALSE, col.names = TRUE)

