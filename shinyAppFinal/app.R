#App Structure Code

#Load Packages
library(shiny)

#UI Mod to Global Environment
source("app_ui.R")

#Server Mod to Global Environment
source("app_server.R")

#App Code
shinyApp(ui = ui, server = server)

