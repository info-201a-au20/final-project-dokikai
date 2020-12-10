library("shiny")
library("ggplot2")
library("dplyr")
library("plotly")
library("scales")

# Import pro data
df_wards <- read.csv(
  "./data/2019-summer-match-data-OraclesElixir-2019-11-10.csv",
  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")

# defining wards max and min
max_death <- max(df_wards$teamdeaths)
max_ward <- max(df_wards$wards)
champions_df <- read.csv("data/LoL-Champions.csv", stringsAsFactors = FALSE)

# Filter down rows only to be games won (using won category)
games_df <- read.csv("./data/games.csv", stringsAsFactors = FALSE)

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

# Makes a blank theme for the pie chart
blank_theme <- theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_text(size = 16, face = "bold", hjust = .5)
  )

# Creates and maintains information stored in the server
server <- function(input, output, session) {
    # Rendering the text for the win/loss part of the wards visualization
    output$message <- renderText({
      if (input$var_team == 1) {
        msg <- paste0("You've chosen Win Team with wards interval [0,",
                      input$num_ward, "], and death inteval [0,",
                      input$num_death, "]")
      } else if (input$var_team == 0) {
        msg <- paste0("You've chosen Lose Team with wards interval [0,",
                      input$num_ward, " ], and death inteval [0,",
                      input$num_death, "]")
      } else if (input$var_team == 2) {
        msg <- paste0("You've chosen Both Teams with wards interval [0,",
                      input$num_ward, "], and death inteval [0,",
                      input$num_death, "]")
      }
      return(msg)
    })

    # Generates wards to death visualization
    output$wpm_death_plot <- renderPlotly({
      data <- df_wards %>%
        group_by(gameid) %>%
        filter(position == "Team")
      if (input$var_team == 1) {
        data <- filter(data, result == 0)
      }
      if (input$var_team == 0) {
        data <- filter(data, result == 1)
      }
      useful_data <- data %>%
        ungroup() %>%
        filter(wards <= input$num_ward, teamdeaths <= input$num_death) %>%
        select(team, wards, teamdeaths)

      map <- ggplot(useful_data, mapping = aes(
        x = wards, y = teamdeaths, color = team,
      )) +
        ggtitle("Scatter Plot of Wards and Death") +
        geom_point(stat = "identity")

      map <- ggplotly(map)
      return(map)
    })

    # Generates pie chart for the objectives panel
    output$first_pie <- renderPlot({
      curr_df <- select(games_stats_pie, input$objectiveType)
      cur_col <- curr_df[[input$objectiveType]]
      pie_plot <- ggplot(curr_df, aes(x = "", y = cur_col,
                          fill = c("Won", "Lost"))) +
      ggtitle("Objective Winrate") +
      geom_bar(width = 1, stat = "identity") +
      guides(fill = guide_legend(reverse = TRUE)) +
      coord_polar("y", start = 0) +
      scale_fill_brewer("Game Result", palette = input$graph_color) +
      blank_theme + theme(axis.text.x = element_blank()) +
      geom_text(aes(y = cur_col / 2 + c(0, cumsum(cur_col)[-length(cur_col)]),
                    label = percent(cur_col / 100)), size = 5)
      return(pie_plot)
    })

    # Generates bar graph for ban champions based on pro teams
    output$bar_graph_banned <- renderPlotly({
      banned_df <- df_wards
      if (input$team_name != "All Teams") {
        banned_df <- filter(banned_df, !!as.name("team") == input$team_name)
      }
      bans_df <- banned_df %>%
        select(position, player, team, champion, contains("ban")) %>%
        filter(position == "Team") %>%
        select(ban1:ban5) %>%
        gather(ban_phase, banned_champs, ban1, ban2, ban3, ban4, ban5) %>%
        count(banned_champs) %>%
        arrange(-n) %>%
        slice(1:10) %>%
        rename("Number_of_Bans" = n) %>%
        rename("Champion" = banned_champs)
      banned_champ_bar <- ggplot(data = bans_df) +
        geom_col(aes(x = reorder(Champion, -Number_of_Bans), y = Number_of_Bans,
                     fill = Champion)) +
        labs(title = "Top Ten Banned Champions During
             The LCS 2019 Summer Season") +
        xlab("Banned Champions") + ylab("Number of Bans By Team") +
        theme(axis.text.x = element_text(angle = 20, vjust = 1, hjust = 1),
              legend.title = element_blank(), legend.position = "none")
      result <- ggplotly(banned_champ_bar, tooltip = c("Number_of_Bans",
                                                       "Champion"))
      return(result)
    })

    # Generates box plot for champion stats
    output$class <- renderPlotly({
      champions_df <- read.csv("./data/LoL-Champions.csv",
                               stringsAsFactors = FALSE)
      box_plot <- champions_df %>%
        filter(Class %in% input$checkbox) %>%
        group_by(Class) %>%
        ggplot(aes(x = Class, y = !!as.name(input$stats))) +
        ggtitle(paste("Champion Class", input$stats,
                      "Distribution")) +
        geom_boxplot(color = "black", fill = "blue", alpha = 0.2) +
        guides(fill = FALSE) + coord_flip()
      return(ggplotly(box_plot))
    })

    # Creates champion stats table for the summary information
    output$summary_table <- renderTable({
      plot <- champions_df %>%
        group_by(Class) %>%
        summarize("Avg Damage" = mean(unlist(Damage)),
                  "Avg Tankiness" = mean(unlist(Sturdiness)),
                  "Avg Mobility" = mean(unlist(Mobility)),
                  "Avg Difficulty" = mean(unlist(Difficulty)))
      return(plot)
    })

    # Creates the scatterplots for the summary information
    output$wards_win_lose <- renderPlotly({
      data <- df_wards %>%
        group_by(gameid) %>%
        filter(position == "Team")
      map <- ggplot(data, mapping = aes(
        x = wards, y = teamdeaths, color = team
      )) +
        ggtitle("Scatter Plot in Terms of Wards Versus Death Between
                Win Teams and Lose Teams") +
        geom_point() +
        facet_wrap(~result, labeller = labeller(result =
                                                 c("0" = "Lose Teams",
                                                   "1" = "Win Teams")))
       return(ggplotly(map))
    })

    # Creates a table for the top ten champion bans for the summary information
    output$top10_banned_champ <- renderTable({
      bans_top10_champ <- df_wards %>%
        group_by(gameid) %>%
        filter(position == "Team") %>%
        ungroup() %>%
        select(ban1:ban5) %>%
        gather(ban_phase, banned_champs, ban1, ban2, ban3, ban4, ban5) %>%
        count(banned_champs) %>%
        arrange(-n) %>%
        head(10) %>%
        rename("Number of Bans" = n,
               "Champion" = banned_champs)
    })
  }
