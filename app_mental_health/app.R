library(shiny)
library(shinyWidgets)
library(ggplot2)
library(dplyr)
shinyWidgetsGallery()

mental_health_survey <- read.csv('mental_health_survey_edited.csv')
#glimpse(mental_health_survey)

ui <- fluidPage(
    # CODE BELOW: Add an appropriate title
    titlePanel("2014 Mental Health in Tech Survey"),
    sidebarPanel(
        # CODE BELOW: Add a checkboxGroupInput
        checkboxGroupInput('q1'
                           ,"Do you think that discussing a mental health issue with your employer would have negative consequences?"
                           ,choices = levels(mental_health_survey$mental_health_consequence)
                           ,selected = levels(mental_health_survey$mental_health_consequence)[1]),

        # CODE BELOW: Add a pickerInput
        pickerInput('q2'
                   ,"Do you feel that your employer takes mental health as seriously as physical health?"
                   ,choices = levels(mental_health_survey$mental_vs_physical)
                   #,selected = levels(mental_health_survey$mental_vs_physical)[1]
                   ,multiple = TRUE)
        
    ),
    mainPanel(
        # CODE BELOW: Display the output
        plotOutput('hist1')
        
    )
)

server <- function(input, output, session) {
    # CODE BELOW: Build a histogram of the age of respondents
    # Filtered by the two inputs
    output$hist1 <- renderPlot({
        
        validate(need(input$q2 !="","Be sure answer the second question."))
        
        mental_health_survey %>% 
            filter(mental_health_consequence==input$q1 & mental_vs_physical %in% input$q2)  %>% 
            ggplot(aes(x=Age)) + geom_histogram()
        
    })
    
}

shinyApp(ui, server)


# input <- NULL 
# input$q1 <- levels(mental_health_survey$mental_health_consequence)[1]
# input$q2 <- levels(mental_health_survey$mental_vs_physical)[1]   
# 
# mental_health_survey %>% 
#     filter(mental_health_consequence==input$q1 & mental_vs_physical==input$q2)  %>% 
#     ggplot(aes(x=Age)) + geom_histogram()

