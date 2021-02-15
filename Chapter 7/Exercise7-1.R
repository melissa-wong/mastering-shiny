library(shiny)

ui <- fluidPage(
  plotOutput("plot", brush = "plot_brush"),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    #browser()
    brushedPoints(mtcars, input$plot_brush, allRows = FALSE)
    # When allRows = TRUE, brushedPoints returns all the data.frame rows
    # included a boolean column called selected_
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
