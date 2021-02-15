library(shiny)
library(ggplot2)

# Set options for rendering DataTables.
options <- list(
  autoWidth = FALSE,
  searching = FALSE,
  ordering = FALSE,
  lengthChange = FALSE,
  lengthMenu = FALSE,
  pageLength = 5, # Only show 5 rows per page.
  paging = TRUE, # Enable pagination. Must be set for pageLength to work.
  info = FALSE
)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      width = 6,
      
      h4("Selected Points"),
      dataTableOutput("click"), br(),
      
      h4("Double Clicked Points"),
      dataTableOutput("dbl"), br(),
      
      h4("Hovered Points"),
      dataTableOutput("hover"), br(),
      
      h4("Brushed Points"),
      dataTableOutput("brush")
    ),
    
    mainPanel(width = 6,
              plotOutput("plot",
                         click = "plot_click",
                         dblclick = "plot_dbl",
                         hover = "plot_hover",
                         brush = "plot_brush")
    )
  )
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point()
  }, res = 96)
  
  output$click <- renderDataTable(
    nearPoints(iris, input$plot_click),
    options = options)
  
  output$hover <- renderDataTable(
    nearPoints(iris, input$plot_hover),
    options = options)
  
  output$dbl <- renderDataTable(
    nearPoints(iris, input$plot_dbl),
    options = options)
  
  output$brush <- renderDataTable(
    brushedPoints(iris, input$plot_brush),
    options = options)
}

shinyApp(ui, server)