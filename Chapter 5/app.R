#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(vroom)
library(here)


injuries <- vroom::vroom(here("Chapter 5", "injuries.tsv.gz"))
products <- vroom::vroom(here("Chapter 5", "products.tsv"))
population <- vroom::vroom(here("Chapter 5", "population.tsv"))

count_top <- function(df, var, n = 5) {
    df %>%
        mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
        group_by({{ var }}) %>%
        summarise(n = as.integer(sum(weight)))
}

prod_codes <- setNames(products$prod_code, products$title)

ui <- fluidPage(
    # Iteration 1
    # fluidRow(
    #     column(6,
    #            selectInput("code", "Product", choices = prod_codes)
    #     )
    # ),
    fluidRow(
        column(8,
               selectInput("code", "Product",
                           choices = setNames(products$prod_code, products$title),
                           width = "100%"
               )
        ),
        column(2, selectInput("y", "Y axis", c("rate", "count")))
    ),
    fluidRow(
        column(4, tableOutput("diag")),
        column(4, tableOutput("body_part")),
        column(4, tableOutput("location"))
    ),
    fluidRow(
        column(12, plotOutput("age_sex"))
    ),
    fluidRow(
        column(2, actionButton("story", "Tell me a story")),
        column(10, textOutput("narrative"))
    )
)

server <- function(input, output, session) {
    selected <- reactive(injuries %>% filter(prod_code == input$code))
    
    # Iteration 1
    # output$diag <- renderTable(
    #     selected() %>% count(diag, wt = weight, sort = TRUE)
    # )
    # output$body_part <- renderTable(
    #     selected() %>% count(body_part, wt = weight, sort = TRUE)
    # )
    # output$location <- renderTable(
    #     selected() %>% count(location, wt = weight, sort = TRUE)
    # )
    
    # Iteration 2
    output$diag <- renderTable(
        count_top(selected(), diag), width = "100%"
    )
    output$body_part <- renderTable(
        count_top(selected(), body_part), width = "100%"
    )
    output$location <- renderTable(
        count_top(selected(), location), width = "100%"
    )
    
    summary <- reactive({
        selected() %>%
            count(age, sex, wt = weight) %>%
            left_join(population, by = c("age", "sex")) %>%
            mutate(rate = n / population * 1e4)
    })
    
    # Iteration 1
    # output$age_sex <- renderPlot({
    #     summary() %>%
    #         ggplot(aes(age, n, colour = sex)) +
    #         geom_line() +
    #         labs(y = "Estimated number of injuries")
    # }, res = 96)
    
    # Iteration 2
    output$age_sex <- renderPlot({
        if (input$y == "count") {
            summary() %>%
                ggplot(aes(age, n, colour = sex)) +
                geom_line() +
                labs(y = "Estimated number of injuries")
        } else {
            summary() %>%
                ggplot(aes(age, rate, colour = sex)) +
                geom_line(na.rm = TRUE) +
                labs(y = "Injuries per 10,000 people")
        }
    }, res = 96)
    
    narrative_sample <- eventReactive(
        list(input$story, selected()),
        selected() %>% pull(narrative) %>% sample(1)
    )
    output$narrative <- renderText(narrative_sample())
}

# Run the application 
shinyApp(ui = ui, server = server)