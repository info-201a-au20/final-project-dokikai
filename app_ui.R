library("ggplot2")
source("app_server.R")

# Wenyi's start:
wpm_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "var_team",
    label = "Selct Teams",
    choices = list("Win Teams" = "1", "Lose Teams" = "0", "Both" = "2"),
    selected = "Both"
  ),
  sliderInput(
    inputId = "num_ward",
    label = "Choose a interval for the number of wards",
    max = `max_ward`,
    min = 0,
    value = 0
  ),
  sliderInput(
    inputId = "num_death",
    label = "Choose a interval for the number of death",
    max = `max_death`,
    min = 0,
    value = 0,
    round = FALSE
  )
)

wpm_main_content <- mainPanel(
  h3("Scatter Plot in Terms of Wards and Death"),
  textOutput(
    "message"
  ),
  plotlyOutput(
    "wpm_death_plot"
  )
)

page_three <- tabPanel(
  "Wards VS Death",
  sidebarLayout(
    wpm_sidebar_content,
    wpm_main_content
  )
)
# Wenyi's end


# Kai's start
pie_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "graph_color",
    label = "Select Graph Color",
    choices = list("Red" = "Reds", "Blue" = "Blues",
                   "Green" = "Greens", "Purple" = "Purples"),
    selected = "Reds"
  ),
  radioButtons(
    inputId = "objectiveType",
    label = h3("Choose Objective Type"),
    choices = list("First Blood" = "won_fb", "First Tower" = "won_ft",
                   "First Dragon" = "won_fd", "First Inhibitor" = "won_fi"),
    selected = "won_fb"
  ) 
)

pie_main_content <- mainPanel(
  plotOutput(outputId = "first_pie")
)

pie_main_content <- mainPanel(
  plotOutput(outputId = "first_pie")
)

page_two <- tabPanel(
  "Winning First Objective and Winrate",
  h2("How First Objectives Affect Winrate"),
  p("When approaching this dataset, one question that was pertinent to League
    of Legends is how much of an impact game objective control had in your win
    percentages. In particular, getting early objectives relative to the other
    team can get you a lead in the game, but quantifying that lead is something
    we set out to do! As a result, these charts show the correlative win
    percentages based on if the winning team won the given objective. We also
    choice a Pie Chart to represent this data because of how it intuitively
    shows the visual demarkers spatially with area."),
  sidebarLayout(
    pie_sidebar_content,
    pie_main_content
  )
)
# Kai's end

# Start of Michael's part

# Calls plotly for main panel
bar_graph_bans <- mainPanel(
  h3("Banned Champions During LCS 2019 Summer Season"),
  plotlyOutput(
    "bar_graph_banned"
  )
)

# Creates list for inputs of teams
select_team <- sidebarPanel(
  selectInput(
    inputId = "team_name",
    label = "Select Teams",
    choices = list("All Teams" = "All Teams",
                   "AHQ e-Sports Club" = "AHQ e-Sports Club",
                   "Cloud9" = "Cloud9",
                   "Clutch Gaming" = "Clutch Gaming",
                   "Damwon Gaming" = "Damwon Gaming",
                   "DetonatioN FocusMe" = "DetonatioN FocusMe",
                   "Flamengo" = "Flamengo",
                   "Fnatic" = "Fnatic",
                   "Funplus Phoenix" = "Funplus Phoenix",
                   "G2 Esports" = "G2 Esports",
                   "GAM Esports" = "GAM Esports",
                   "Griffin" = "Griffin",
                   "Hong Kong Attitude" = "Hong Kong Attitude",
                   "Invictus Gaming" = "Invictus Gaming",
                   "Isurus Gaming" = "Isurus Gaming",
                   "J Team" = "J Team",
                   "Lowkey Esports" = "Lowkey Esports",
                   "Mammoth" = "Mammoth",
                   "MEGA Esports" = "MEGA Esports",
                   "Royal Never Give Up" = "Royal Never Give Up",
                   "Royal Youth" = "Royal Youth",
                   "SK Telecom T1" = "SK Telecom T1",
                   "Splyce" = "Splyce",
                   "Team Liquid" = "Team Liquid",
                   "Unicorns of Love" = "Unicorns of Love"),
    selected = "All Teams"
  )
)

# Page four tab of panel.
page_four <- tabPanel(
  "Banned Champions",
  h2("Statistics of Banned Champions in Professional games."),
  p("The graph shows the statistics of banned champions per phase for every team
    that played in the LCS 2019 Summer Season. With this graph, it can show what
    champions were the most popular to ban for competitive play, as esports data
    would contribute heavily in understanding the popularity of banning certain 
    champions who could be strongly favored to play."),
  sidebarLayout(
    select_team,
    bar_graph_bans
  )
)

# Michael's End

page_one <- tabPanel(
  "Page One (Overview)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

page_five <- tabPanel(
  "Page Title (Summary Takeaway)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

ui <- navbarPage(
  "INFO 201",
  page_one,
  page_two,
  page_three,
  page_four,
  page_five
)