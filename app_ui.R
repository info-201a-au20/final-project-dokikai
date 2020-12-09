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

page_two <- tabPanel(
  "Winning First Objective and Winrate",
  h2("How First Objectives Affect Winrate"),
  sidebarLayout(
    pie_sidebar_content,
    pie_main_content
  )
)
# Kai's end


page_one <- tabPanel(
  "Page One (Overview)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

page_four <- tabPanel(
  "Page Title (Vis 3)",
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