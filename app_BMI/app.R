
#----------------------------#
#---# The BMI calculator #---#
#----------------------------#

library("shiny")

bmi_help_text <- "Body Mass Index is a simple calculation using a person's height and weight.
                  The formula is BMI = kg/m2 where kg is a person's weight in kilograms and m2
                  is their height in metres squared. A BMI of 25.0 or more is overweight, while 
                  the healthy range is 18.5 to 24.9."

ui <- fluidPage(
    #---# title #---#
    titlePanel(strong('BMI Calculator'))
    , sidebarLayout(
        #---# SIDEBARPANEL #---#
        sidebarPanel(
            textInput(inputId = 'name'
                      , label = em('Enter your name'))
            #---# Enter height #---#
            , numericInput(inputId = 'height'
                           , label = em('Enter your height in meters')
                           , value =  1.5
                           , min = 1
                           , max = 2)
            #---# Enter weight #---#
            , numericInput(inputId = 'weight'
                           , label = em('Enter your weight in Kilograms')
                           , value = 60
                           , min = 45
                           , max = 120)
            #---# Show BMI #---#
            , actionButton(inputId = "show_bmi"
                           , label = "Show BMI")
            #---# An action button named "show_help" #---#
            , actionButton(inputId = "show_help"
                           , label = "Help"))
        #---# MAINPANEL #---#
        , mainPanel(textOutput("bmi"))
    )
)

server <- function(input, output, session) {

    observeEvent(input$show_help, {showModal(modalDialog(bmi_help_text))})
    
    rv_bmi <- eventReactive(input$show_bmi, {
        input$weight/(input$height^2)
    })
    
    output$bmi <- renderText({
        bmi <- rv_bmi()
        paste("Hi"
              , input$name
              , ". Your BMI is"
              , round(bmi, 1))
    })
}
shinyApp(ui = ui, server = server)