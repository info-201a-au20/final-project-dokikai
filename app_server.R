library("shiny")
library("ggplot2")
library("dplyr")
library("plotly")
# Import  wenyi's data
df_wards <- read.csv("data/2019-summer-match-data-OraclesElixir-2019-11-10.csv",
                     stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
# Wenyi: Define variable that wll be used in ui file
max_death <- max(df_wards$teamdeaths)
max_ward <- max(df_wards$wards)


server <- function(input, output, session) {
    output$message <- renderText({
      if(input$var_team == 1){
        msg <- paste0("You've chosen Win Team with wards interval [0,", 
                      input$num_ward,"], and death inteval [0,", input$num_death,"]")
      }
      if(input$var_team== 0){
        msg <- paste0("You've chosen Lose Team with wards interval [0,", 
                      input$num_ward," ], and death inteval [0,", input$num_death,"]")
      }
      if(input$var_team== 2){
        msg <- paste0("You've chosen Both Teams with wards interval [0,", 
                      input$num_ward,"], and death inteval [0,", input$num_death,"]")
      }
      return(msg)
    })
    output$wpm_death_plot <- renderPlotly({
      data <- df_wards %>%
        group_by(gameid) %>%
        filter(position == "Team") # select data that is useful to our analyze
      # put the wards as x-axis, and number of death as y-axis, them put team name
      # on the chats. Finally, we separate the win teams and fail team to make a
      # clear comparison
      
      if(input$var_team == 1){
        data <- filter(data, result == 0)
      }
      if(input$var_team== 0){
        data <- filter(data, result == 1)
      }
      useful_data <-data%>%
        ungroup()%>%
        filter(wards <= input$num_ward, teamdeaths <= input$num_death)%>%
        select(team, wards, teamdeaths)
      
      map <- ggplot(useful_data, mapping = aes(
        x = wards, y = teamdeaths, color = team,
      )) +
        geom_point(stat = "identity") 
      
      map <- ggplotly(map)
      return(map)
    })
  }
  
  
