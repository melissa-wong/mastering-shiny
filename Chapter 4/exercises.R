# Exercise 4.3.6.1
#
# server 1
# a -\   d -\
#     -> c --> e -> f
# b -/

# server 2
# x1, x2, x3 -> x -\
#                   -> z
# y1, y2 -> y -----/

# server 3
# a -> a--> b-\
#      b -/    --> c -\
#           c -/       -> d
#                  d -/

# Exercise 4.3.6.2
# It fails because df[] isn't defined (df() is the density function for the F-distribution)
# Because var() is the function for variance

library(shiny)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "!"))
  
  output$greeting <- renderText(string())
  observeEvent(input$name, {
    message("Greeting performed")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
