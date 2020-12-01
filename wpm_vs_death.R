# In this function, our goal is to virtualize the
# comparison of the number of wards  versus the number of death
# import package:
library("dplyr")
library("ggplot2")
library("plotly")
library("styler")
library("lintr")
library("knitr")
# import the dataset
match_df <- read.csv("data/2019-summer-match-data-OraclesElixir-2019-11-10.csv",
  stringsAsFactors = FALSE, fileEncoding = 'UTF-8-BOM'
)
# write the function:
wpm_death <- function(df) {
  data <- df %>%
    group_by(gameid) %>%
    filter(position == "Team") # select data that is useful to our analyze
  # put the wards as x-axis, and number of death as y-axis, them put team name
  # on the chats. Finally, we separate the win teams and fail team to make a
  # clear comparison
  map <- ggplot(data, mapping = aes(
    x = wards, y = teamdeaths, color = team,
    text = paste("result: ", result)
  )) +
    ggtitle("Scatter Plot in Terms of Wards Versus Death") +
    geom_point() +
    facet_wrap(~result)

  map <- ggplotly(map)

  return(map)
}

chart2 <- wpm_death(match_df)
