# Load in libraries
library("dplyr")

# Reads CSV file of League champions into a Dataframe
champions_df <- read.csv("data/LoL-Champions.csv", stringsAsFactors = FALSE)

champ_table <- champions_df %>%
  group_by(Class) %>%
  summarize("Avg Damage" = mean(unlist(Damage)), 
            "Avg Tankiness" = mean(unlist(Sturdiness)),
            "Avg Mobility" = mean(unlist(Mobility)),
            "Avg Difficulty" = mean(unlist(Difficulty)))
