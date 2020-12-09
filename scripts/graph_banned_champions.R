# Michael Gov
# INFO 201

# In this function, our goal is to graph the top ten banned
# champions during the 2019 Summoner League matches.
library("dplyr")
library("ggplot2")
library("tidyr")
library("lintr")

# Obtain matches
promatch_df <-
  read.csv("../data/2019-summer-match-data-OraclesElixir-2019-11-10.csv",
         stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")

# Filter all bans from promatch_df and obtain top ten
# Then, places top ten on a bar graph.
top_ten_bans <- function(df) {
  bans_df <- promatch_df %>%
    select(position, player, team, champion, contains("ban")) %>%
    filter(position == "Team") %>%
    select(ban1:ban5) %>%
    gather(ban_phase, banned_champs, ban1, ban2, ban3, ban4, ban5) %>%
    count(banned_champs) %>%
    arrange(-n) %>%
    slice(1:10)
  banned_champ_bar <- ggplot(data = bans_df) +
    geom_col(aes(x = reorder(banned_champs, -n), y = n, fill = banned_champs)) +
    labs(title = "Top Ten Banned Champions During
       The LCS 2019 Summer Season") +
    xlab("Banned Champions") + ylab("Number of Bans by Teams") +
    theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust = 1),
          legend.title = element_blank(), legend.position = "none")
  return(banned_champ_bar)
}

# Create bar graph variable to call on
chart3 <- top_ten_bans(promatch_df)
