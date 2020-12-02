# Load in libraries
library("dplyr")
library("styler")
library("lintr")
# Reads CSV file of League champions into a Dataframe
champions_df <- read.csv("../data/LoL-Champions.csv", stringsAsFactors = FALSE)

# Groups by champion class and then finds the average damage, tankiness,
# mobility, and difficulty of the corresponding classes

summary_table <- function(df){
  plot <- df%>%
       group_by(Class) %>%
       summarize("Avg Damage" = mean(unlist(Damage)),
                 "Avg Tankiness" = mean(unlist(Sturdiness)),
                  "Avg Mobility" = mean(unlist(Mobility)),
                  "Avg Difficulty" = mean(unlist(Difficulty)))
  return(plot)
}
champ_table <- summary_table(champions_df)