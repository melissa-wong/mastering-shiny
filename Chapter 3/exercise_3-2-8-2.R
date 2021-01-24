#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    sliderInput("date", "When should we deliver?", 
                min = as.Date("2020-09-15","%Y-%m-%d"),
                max = as.Date("2020-09-23","%Y-%m-%d"),
                value=as.Date("2020-09-17"),
                timeFormat="%Y-%m-%d")
)

# Define server logic required to draw a histogram
server <- function(input, output) {


}

# Run the application 
shinyApp(ui = ui, server = server)
