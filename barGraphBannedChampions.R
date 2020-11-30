# Michael Gov
# INFO 201

library("dplyr")
library("ggplot2")
library("tidyr")
library("lintr")

# Get pro matches
promatch_df <- read.csv("./data/2019-summer-match-data-OraclesElixir-2019-11-10.csv", 
         stringsAsFactors = FALSE)

# Filter all bans from df
bans_df <- promatch_df %>%
  select(position, player, team, champion, contains("ban")) %>%
  filter(position == "Team")

# Add up all bans to find banned overall
total_bans_df <- bans_df %>%
  select(ban1:ban5) %>%
  gather(ban_phase, banned_champs, ban1, ban2, ban3, ban4, ban5) %>%
  count(banned_champs) %>%
  arrange(-n)

# Get top 10 banned champions
top_ten_bans <- total_bans_df %>%
  top_n(10, n)

# Place on plotter
banned_champ_bar <- ggplot(data = top_ten_bans) +
  geom_col(aes(x = reorder(banned_champs, -n), y = n, fill = banned_champs)) +
  labs(title = "Top Ten Banned Champs During \n2019 League Championship Series") +
  xlab("Banned Champions") + ylab("Number of Bans by Teams") + 
  theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust = 1),
        legend.title = element_blank(), legend.position = "none")

# View Plot
banned_champ_bar
