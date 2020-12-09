# INFO201 AE
# Rajeev Krishna Vijayaraghavanmaybe

# Load in libraries
library("dplyr")

#load table consisting of mean values of the different parameters(damage,tankiness,mobility,difficulty)
source("../scripts/analysis_summary_table.R")


summary_function <- function(df) {
  highest_damage <- df %>%
    filter(`Avg Damage` == max(`Avg Damage`)) %>%
    pull(Class)
  highest_tankiness <- df%>%
    filter(`Avg Tankiness` == max(`Avg Tankiness`))%>%
    pull(Class)
  highest_mobility<- df%>%
    filter(`Avg Mobility` == max(`Avg Mobility`))%>%
    pull(Class)
  highest_difficulty<- df%>%
    filter(`Avg Difficulty` == max(`Avg Difficulty`))%>%
    pull(Class)
  lowest_difficulty<- df%>%
    filter(`Avg Difficulty` == min(`Avg Difficulty`))%>%
    pull(Class)
  result <- list(highest_damage, highest_tankiness, highest_mobility,
                 highest_difficulty, lowest_difficulty)
  return(result)
  
}
summary <- summary_function(champ_table)
