library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("plot", click = "plot_click"),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    nearPoints(mtcars, input$plot_click, allRows = TRUE)
  })
}

shinyApp(ui, server)
