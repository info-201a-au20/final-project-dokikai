library("ggplot2")
source("app_server.R")

# Wenyi's start:
wpm_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "var_team",
    label = "Select Teams",
    choices = list("Both" = "2", "Win Teams" = "1", "Lose Teams" = "0"),
    selected = "Both"
  ),
  sliderInput(
    inputId = "num_ward",
    label = "Choose a interval for the number of wards",
    max = `max_ward`,
    min = 0,
    value = `max_ward`
  ),
  sliderInput(
    inputId = "num_death",
    label = "Choose a interval for the number of death",
    max = `max_death`,
    min = 0,
    value = `max_death`,
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

# Loads in the Champion Statistics dataframe for analysis
champions_df <- read.csv("./data/LoL-Champions.csv", stringsAsFactors = FALSE)
# Filters out unnecessary values
stat_values <- select(champions_df, -Id, -Name, -Class, -DamageType,
                      -Crowd.Control)

# Sidebar content for generating the sidebar options for the Pie Chart
# which includes color selection and objective type
pie_sidebar_content <- sidebarPanel(
  selectInput(
    inputId = "graph_color",
    label = "Select Graph Color",
    choices = list("Purple" = "Purples", "Red" = "Reds", "Blue" = "Blues",
                   "Green" = "Greens"),
    selected = "Purples"
  ),
  radioButtons(
    inputId = "objectiveType",
    label = h3("Choose Objective Type"),
    choices = list("First Blood" = "won_fb", "First Tower" = "won_ft",
                   "First Dragon" = "won_fd", "First Inhibitor" = "won_fi"),
    selected = "won_fb"
  )
)


# Generates the sidebar information for the Champion Class statistics
stats_sidebar <- sidebarPanel(
  checkboxGroupInput(
    inputId = "checkbox",
    label = h3("Champion Classes to Display"),
    choices = unique(champions_df$Class),
    selected = unique(champions_df$Class)
  ),
  radioButtons(
    inputId = "stats",
    label = h3("Choose Stat to Visualize"),
    choices = colnames(stat_values),
    selected = "Style"
  )
)

# Produces the second tab of the website which stores the information regarding
# champion class and objective's effects on winrate.
page_two <- tabPanel(
  "Champion Class, Skills, and Objectives",
  h2("Champion Class and Corresponding Statistics"),
  sidebarLayout(
    stats_sidebar,
    mainPanel(plotlyOutput("class"), p("\n"),
    p("In League of Legends, each playable character falls within a larger
      category of \"Champion Class\" where each class has a different set of
      skills. Some classes, such as Assasins, are better at obtaining early
      objectives such as First Blood while other classes are better at getting
      other important objectives in the game such as Dragons, Towers, or
      Inhibitors. As a result, seeing the various breakdowns of each Class and
      their ability to do damage, maneauver the map, or even their difficulty
      level can help gain insights into a broader picture of how League
      distributes and balances various playstyles and maintains game balance."),
    p("In the boxplot above, various information regarding Champion class has
      been aggregated and distributed accordingly in order to see the general
      ranges of Champion statistics. This broader scope and perpective of the
      Class breakdowns can be helpful for League of Legends players at every
      level of play. Whether you be a seasoned veteran trying to visualize the
      general class types in making team compositions or a complete novice
      assessing which role is generally the easiest skill wise, this visual
      provides insights into what direction any player might want to go!")
    )
  ),
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
    mainPanel(plotOutput(outputId = "first_pie"))
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
  p("The graph shows the statistics of banned champions per phase for every
    team that played in the LCS 2019 Summer Season. With this graph, it can show
    what champions were the most popular to ban for competitive play, as esports
    data would contribute heavily in understanding the popularity of banning
    certain champions who could be strongly favored to play.."),
  sidebarLayout(
    select_team,
    bar_graph_bans
  )
)
# Michael's End

# Generates the overview for the project
page_one <- tabPanel(
  "Project Overview",
  h2("League of Legends - a Data Driven Project "),
  sidebarLayout(
    sidebarPanel(
      p("With Multiplayer Online Battle Arena (MOBA) games beinig some of the
        most popular video games in the world, its no doubt that League of
        Legends has had an immense cultural impact as the biggest MOBA in the
        world! But much like many other video games, League of Legends has many
        variables and factors that can contribute to a teams chance of winning.
        In this project, we wanted to answer three primary questions: (1) to
        what extent winning certain objectives correlated with winninig the
        match, (2) how professional League of Legends E-sports atheletes utilize
        warding and vision mechanics and the gameplay effects that has, and (3)
        the variability in banning certain champions in professional play along
        with general champion statistics.")
    ),
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
