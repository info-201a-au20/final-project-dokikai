# Load in ggplot2 and source app_server
library("ggplot2")
source("app_server.R")

# Loads in the Champion Statistics data frame for analysis
champions_df <- read.csv("./data/LoL-Champions.csv", stringsAsFactors = FALSE)
# Filters out unnecessary values
stat_values <- select(champions_df, -Id, -Name, -Class, -DamageType,
                      -Crowd.Control)

# Creates the sidebar for the wards section
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

# Creates the main panel for the sidebar layout
wpm_main_content <- mainPanel(
  p("Ward is a deployable unit that removes the fog of war in a certain
    area of the map. Then, each member of the team can clearly see where their
    teammates are and can help better place battle strategy. Generally,
    the more wards a team has, the less probablity of them be killed,and
    the higher probability of them winning. In the scatter plot,
    you can choose the win team, lose team, and both teams in
    professionalLeague of Legends play and analyzed their relationship between
    the wards that each team place in battleground and their number of
    deaths."),
  textOutput(
    "message"
  ),
  plotlyOutput(
    "wpm_death_plot"
  )
)

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

# Generates the image to be displayed on the overview page
overview_image <- mainPanel(
  HTML('<div>
  <img id = "img", src = "league.jpg">
  </div>')
)

main_overview <- p(
  HTML("<p>
    With Multiplayer Online Battle Arena (MOBA) games beginning some of
    the most popular video games in the world, its no doubt that
    <a href=https://na.leagueoflegends.com/en-us/>League of Legends</a>
    has had an immense cultural impact as the biggest MOBA in
    the world! But much like many other video games, League of Legends has
    many variables and factors that can contribute to a teams chance of
    winning.
    </p>")
)

overview_sources <- p(
  HTML("<p>
    We used data from various sources that contributed in answering
    several questions we had about League of Legends and it's data.
    We used League of Legends professional match statistics during the LCS
    2019 Summer Season
    <a href=https://www.kaggle.com/xmorra/
    league-of-legends-world-championship-2019>
    found here,
    </a>
    as well as data of western Europe's League of Legend's statistics for the
    average player
    <a href=https://www.kaggle.com/datasnaek/league-of-legends> found here,</a>
    and champion data from Riot's API for League of Legends
    <a href=https://www.kaggle.com/uskeche/leauge-of-legends-champions-dataset>
    found here.</a>
    </p>")
)

# Generates the overview for the project
overview_page <- tabPanel(
  "Project Overview",
  h2("League of Legends - a Data Driven Project"),
  main_overview,
  overview_sources,
  sidebarLayout(
    sidebarPanel(
      p("In this project, we wanted to answer three primary questions:"),
      HTML("<ul>
        <li>
          To what extent would winning certain objectives
          correlate with winning the match?
        </li>
        <li>
          How do professional League of Legends E-sports atheletes utilize
          warding and vision mechanics and how do they effect gameplay?
        </li>
        <li>
          Does the variability in banning certain champions in
          professional play along with general champion statistics?
        </li></ul>")
    ),
    overview_image
  )
)

# Produces the second tab of the website which stores the information regarding
# champion class and objective's effects on winrate.
stats_and_pie_page <- tabPanel(
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

# Page three which has information regarding warding
wards_page <- tabPanel(
  "Wards vs Death",
  h2("The Relationship Between Wards and Death"),
  sidebarLayout(
    wpm_sidebar_content,
    wpm_main_content
  )
)

# Creates page for displaying champion ban rates in professional play
bans_page <- tabPanel(
  "Banned Champions",
  h2("Statistics of Banned Champions in Professional games."),
  p("The graph shows the statistics of banned champions per phase for every
    team that played in the LCS 2019 Summer Season. With this graph, it can show
    what champions were the most popular to ban for competitive play, as esports
    data would contribute heavily in understanding the popularity of banning
    certain champions who could be strongly favored to play."),
  sidebarLayout(
    select_team,
    bar_graph_bans
  )
)

# This page produces all summary information for our visualizations
summary_page <- tabPanel(
  "Summary Takeaway",
  h2("Champion Statistics"),
  p("Notable data insight or pattern One notable data insight that we noticed
    in the visualization is that different classes of champions have different
    distributions of statistics like Style, Difficulty, Tankiness, Damage, etc.
    This is shown specifically from the box plot visualization in the Champion
    Class, Skills, and Objectives tab of the interface which has been
    consolidated into the figure below."),
  tableOutput(
    "summary_table"
  ),
  p("From this table, some general observations we can make are that, on
    average, the Tank class is the easiest to play while Mage-Assasins, on
    average, are the most difficult. Furthermore, certain classes in general
    have higher damage outputs Assasins, Mage-Marksmans, and Marksman to name
    a few."),
  p("These insights, furthermore, have broader implications for the game as a
    whole and contain valuable information for players across a broad spectrum
    of experience. For the newer player base, knowing which champion class is
    relatively less difficult or which class does damage the easiest can be
    extremely helpful in navigating such a complex game. On the other hand, for
    higher levels of play, being able to consider general stats like tankiness,
    mobility or crowd control can be extremely helpful in making advanced team
    compositions and forming the meta-game. In all, it appears that getting a
    broader level overview about Champion Class information can provide helpful
    direction to all League of Legends players."),
  h2("Objectives & Vision Control"),
  p("With that, in professional matches, wards are often discussed as a very
    important factor that may determine the winners and losers. It refers to a
    deployable unit that removes the fog of war in a certain area of the map.
    With wards, each member of the team can clearly see where their enemies are
    and can help them better place battle strategy. A takeaway we have from our
    visualization is that there appeared to be a higher concentration of wards,
    on average, for the winning teams with generally less deaths on their parts
    so we can assess that there is at least some degree of positive
    correlation between warding and winning in professional play."),
  p("This is, of course, specific to professional play but can provide insights
    into the game for players of all levels. And oftentimes, because warding is
    not prioritized as heavily in lower ELOs of play, newer or less experienced
    players may want to mimic some of the behaviors that winning professional
    teams have with regards to warding. This also leads into a broader
    discussion of map and objective control, which has historically been a
    problem that newer players face with playing League. Oftentimes, people
    focus too much on getting gold (the currency in League) and kills but not
    enough on obtaining objectives like Dragon, Towers, or Inhibitors which
    results in games that drag out and winning teams throwing their lead. In
    fact, this emphasis on objective control is highlighted well in the Pie
    Chart visualizations from the Champion Class, Skills, and Objectives
    panel that show a very strong correlation between obtaining the first
    objectives and winning the game. This is most notably shown with the First
    Inhibitor visualization where 80% of teams that won the League match got the
    first inhibitor making a strong argument that good objective control and
    map control tends to align with the winning team. In all, both in terms of
    warding and objective control, managing map presence appears the be a
    fundamental key to winning in League of Legends."),
  plotlyOutput(
    "wards_win_lose"
  ),
  p("Here, we split the winning and losing teams in professional League of
    Legends play and analyzed their relationship between the wards that each
    team place inbattleground and their number of deaths. "),
  p("From the right-hand table, it shows that the number of wards in most win
    teams is concentrated on interval [100, 150]. Whereas, on the left-hand
    table, the number of wards in most losing teams is mainly between [0, 150].
    The different intervals showed that the more wards the teams have,
    the more possibility they will win the game."),
  h2("Champion Banning"),
  p("While casual gameplay with League of Legends definitely lends itself to
    many different variables, professional play is a completely different game.
    Within pro play, there is a ban phase that allows each team to ban champions
    from being played in that match they don't want to deal with. whether it be
    because they have a team composition that struggles with that champion or
    that the other team has a player that specializes with them, this feature
    drastically changes the tides of the game as certain champions tend to be
    banned more on average due to their unique abilities. Below are displayed
    the most banned champions in professional play (from this dataset)."),
  tableOutput(
    "top10_banned_champ"
  ),
  p("It appears that by counting the pure number of bans, Pantheon is the most
    banned champion in professional play with a staggering 118 bans, with Qiyana
    and Syndra following that 86 and 66 bans respectively. The list continues to
    show the number of bans per champion and we can gain a lot of insight about
    both professional play and specific champions. In particular, it tells us
    that some champions in professional play offer some type of advantage that
    pro's feel to be too threatening - whether that be Pantheons global map
    presence and early game capabilities or Qiyana's team fight zoning and crowd
    control spells. As a result, we can deduce that these champion ban rates are
    not a coincidence but the direct result of a champions utility at that time
    and how well they fit into the meta-game scene. With that, it can also flag
    to casual players and e-sports watchers that within their games some of
    these champions that might be under looked in normal play (such as Qiyana)
    have a large amount of potential to be massive threats if used in the right
    hands!"
  )
)

# Generates the user interface
ui <- fluidPage(
  includeCSS("style.css"),
  navbarPage(
    "INFO 201 AE 3 - Kai Daniels, Michael Gov, Wenyi Sun, Rajeev Krishna",
    overview_page,
    stats_and_pie_page,
    wards_page,
    bans_page,
    summary_page
  )
)
