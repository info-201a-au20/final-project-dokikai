# Load in libraries
library("dplyr")
library("ggplot2")
library("scales")

# Filter down rows only to be games won (using won category)
games_df <- read.csv("data/games.csv", stringsAsFactors = FALSE)

# This variable stores the number of games played
num_of_games <- nrow(games_df)

# Generates the necessary information for first blood, first tower, first
# inhibitor, and first dragon acquisition and if the team that obtained that
# won the game (stores this as a dataframe)
games_stats <- games_df %>%
  mutate("won_first_blood" = if_else(winner == firstBlood, TRUE, FALSE),
         "won_first_tower" = if_else(winner == firstTower, TRUE, FALSE),
         "won_first_inhib" = if_else(winner == firstInhibitor, TRUE, FALSE),
         "won_first_drag" = if_else(winner == firstDragon, TRUE, FALSE)) %>%
  select(gameId, gameDuration, won_first_blood, won_first_tower,
         won_first_inhib, won_first_drag) %>%
  summarize(won_fb = sum(won_first_blood == TRUE) / num_of_games,
            won_ft = sum(won_first_tower == TRUE) / num_of_games,
            won_fi = sum(won_first_inhib == TRUE) / num_of_games,
            won_fd = sum(won_first_drag == TRUE) / num_of_games)

# This function takes a data frame as a parameter and returns the compliment
# of all values in the data frame
create_compliment <- function(data_frame) {
  return(1 - data_frame)
}

# This function takes a data frame as a parameter and returns a data frame with
# all values in it multiplied by 100
make_percent <- function(data_frame) {
  return(100.0 * data_frame)
}

# This creates the data frame for the game stats that is prepared to visualize
# as a pie graph
games_stats_pie <- games_stats %>%
  filter(row_number() == 1) %>%
  create_compliment() %>%
  bind_rows(games_stats) %>%
  make_percent() %>%
  arrange(desc(row_number()))

# Blank theme provided by:
# http://www.sthda.com/english/wiki/ggplot2-pie-chart-quick-start-guide
# -r-software-and-data-visualization
blank_theme <- theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 14, face = "bold")
  )

# Generates the pie chart for the aggregated first blood data and proportions
first_blood_pie <- games_stats_pie %>%
  ggplot(aes(x = "", y = won_fb, fill = c("Won", "Lost"))) +
  ggtitle("Got First Blood") +
  geom_bar(width = 1, stat = "identity") +
  guides(fill = guide_legend(reverse = TRUE)) +
  coord_polar("y", start = 0) +
  scale_fill_brewer("Game Result", palette = "Reds") + blank_theme +
  theme(axis.text.x = element_blank()) +
  geom_text(aes(y = won_fb / 2 + c(0, cumsum(won_fb)[-length(won_fb)]),
                label = percent(won_fb / 100)), size = 5)

# Generates the pie chart for the aggregated first blood data and proportions
first_tower_pie <- games_stats_pie %>%
  ggplot(aes(x = "", y = won_fb, fill = c("Won", "Lost"))) +
  ggtitle("Got First Tower") +
  geom_bar(width = 1, stat = "identity") +
  guides(fill = guide_legend(reverse = TRUE)) +
  coord_polar("y", start = 0) +
  scale_fill_brewer("Game Result", palette = "Blues") + blank_theme +
  theme(axis.text.x = element_blank()) +
  geom_text(aes(y = won_ft / 2 + c(0, cumsum(won_ft)[-length(won_ft)]),
                label = percent(won_ft / 100)), size = 5)

# Generates the pie chart for the aggregated first blood data and proportions
first_inhib_pie <- games_stats_pie %>%
  ggplot(aes(x = "", y = won_fb, fill = c("Won", "Lost"))) +
  ggtitle("Got First Inhibitor") +
  geom_bar(width = 1, stat = "identity") +
  guides(fill = guide_legend(reverse = TRUE)) +
  coord_polar("y", start = 0) +
  scale_fill_brewer("Game Result", palette = "Purples") + blank_theme +
  theme(axis.text.x = element_blank()) +
  geom_text(aes(y = won_fi / 2 + c(0, cumsum(won_fi)[-length(won_fi)]),
                label = percent(won_fi / 100)), size = 5)

# Generates the pie chart for the aggregated first blood data and proportions
first_drag_pie <- games_stats_pie %>%
  ggplot(aes(x = "", y = won_fb, fill = c("Won", "Lost"))) +
  ggtitle("Got First Dragon") +
  geom_bar(width = 1, stat = "identity") +
  guides(fill = guide_legend(reverse = TRUE)) +
  coord_polar("y", start = 0) +
  scale_fill_brewer("Game Result", palette = "Greens") + blank_theme +
  theme(axis.text.x = element_blank()) +
  geom_text(aes(y = won_fd / 2 + c(0, cumsum(won_fd)[-length(won_fd)]),
                label = percent(won_fd / 100)), size = 5)

# NOTE: This Multiplot function is provided by the creators of knitr for
# RMarkdown and was accessed at this link:
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/

# Multiple plot function
#
# ggplot objects can be passed in... or to plotlist (as list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  num_plots <- length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(num_plots / cols)),
                     ncol = cols, nrow = ceiling(num_plots / cols))
  }

  if (num_plots == 1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:num_plots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

# Generates the multi plot pie chart that displays disaggregated categories of
# information
final_pie_plot <- multiplot(first_blood_pie, first_tower_pie,
          first_inhib_pie, first_drag_pie, cols = 2)
