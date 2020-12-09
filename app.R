library("shiny")
library("dplyr")
library("plotly")
library("tidyr")
library("ggplot2")
setwd("~/Info201/final-project-dokikai")

# Load in the UI and Server
source("app_ui.R")
source("app_server.R")

shinyApp(ui = ui, server = server)
