# INFO201 AE
# Rajeev Krishna Vijayaraghavan

#clear old variables
rm(list = ls())

# Load in libraries
library("dplyr")

#load table consisting of mean values of the different parameters(damage,tankiness,mobility,difficulty)
source("analysis_summary_table.R")

#calculates Class with highest mean damage
highest_damage<- champ_table%>%
  filter(`Avg Damage` == max(`Avg Damage`))%>%
  pull(Class)

#calculates Class with highest mean tankiness
highest_tankiness<- champ_table%>%
  filter(`Avg Tankiness` == max(`Avg Tankiness`))%>%
  pull(Class)

#calculates Class with highest mean mobility
highest_mobility<- champ_table%>%
  filter(`Avg Mobility` == max(`Avg Mobility`))%>%
  pull(Class)

#calculates Class with highest mean difficulty
highest_difficulty<- champ_table%>%
  filter(`Avg Difficulty` == max(`Avg Difficulty`))%>%
  pull(Class)

#calculates Class with lowest mean difficulty
lowest_difficulty<- champ_table%>%
  filter(`Avg Difficulty` == min(`Avg Difficulty`))%>%
  pull(Class)

             

  
  
  
  